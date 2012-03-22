Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754485Ab2CVOHH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 10:07:07 -0400
Received: from mga10.intel.com ([192.55.52.92]:59424 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752786Ab2CVOHD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 10:07:03 -0400
MIME-Version: 1.0
In-Reply-To: <1332356057-3356-11-git-send-email-zohar@linux.vnet.ibm.com>
References: <1332356057-3356-1-git-send-email-zohar@linux.vnet.ibm.com>
	<1332356057-3356-11-git-send-email-zohar@linux.vnet.ibm.com>
Date: Thu, 22 Mar 2012 16:07:00 +0200
Message-ID: <CALLzPKax1Kmuec+F1w9fK0GbRap6FQJjFXbcZsfXBThB8kw4bA@mail.gmail.com>
Subject: Re: [PATCH v3 10/12] ima: defer calling __fput()
From: "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        David Safford <safford@linux.vnet.ibm.com>,
        Matt Helsley <matt.helsley@gmail.com>, Mimi Zohar <zohar@us.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,


On Wed, Mar 21, 2012 at 8:54 PM, Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:
> If a file is closed before it is munmapped, __fput() is called with
> the mmap_sem taken.  With IMA-appraisal enabled, this results in an
> mmap_sem/i_mutex lockdep.  ima_defer_fput() increments the f_count
> to defer __fput() being called until after the mmap_sem is released.
>

Have you noticed any performance implications?


> Changelog v3:
> - use slab mempool (suggested by Dmitry Kasatkin)
> - renamed a few functions based on Matt Helsley's review
> - define ima_fput_mempool as static (fix sparse error)
> - fix ima_defer_fput() stub definition
>
> Changelog v2:
> - based on discussions with: Tyler Hicks (use workqueues),
>  Dave Hansen (defer only IMA related files), and
>  Dmitry Kasatkin (add new IMA hook)
> - use slab memory for allocating work
>
> Signed-off-by: Mimi Zohar <zohar@us.ibm.com>
> ---
>  include/linux/ima.h                   |    5 ++
>  mm/mmap.c                             |    1 +
>  security/integrity/ima/ima_appraise.c |   84 +++++++++++++++++++++++++++++++++
>  3 files changed, 90 insertions(+), 0 deletions(-)
>
> diff --git a/include/linux/ima.h b/include/linux/ima.h
> index 2c7223d..af8cb3b 100644
> --- a/include/linux/ima.h
> +++ b/include/linux/ima.h
> @@ -47,6 +47,7 @@ extern void ima_inode_post_setattr(struct dentry *dentry);
>  extern int ima_inode_setxattr(struct dentry *dentry, const char *xattr_name,
>                       const void *xattr_value, size_t xattr_value_len);
>  extern int ima_inode_removexattr(struct dentry *dentry, const char *xattr_name);
> +extern void ima_defer_fput(struct file *file);
>  #else
>  static inline void ima_inode_post_setattr(struct dentry *dentry)
>  {
> @@ -66,5 +67,9 @@ static inline int ima_inode_removexattr(struct dentry *dentry,
>  {
>        return 0;
>  }
> +static inline void ima_defer_fput(struct file *file)
> +{
> +       return;
> +}
>  #endif /* CONFIG_IMA_APPRAISE_H */
>  #endif /* _LINUX_IMA_H */
> diff --git a/mm/mmap.c b/mm/mmap.c
> index 4c16a0a..c1accd4 100644
> --- a/mm/mmap.c
> +++ b/mm/mmap.c
> @@ -232,6 +232,7 @@ static struct vm_area_struct *remove_vma(struct vm_area_struct *vma)
>        if (vma->vm_ops && vma->vm_ops->close)
>                vma->vm_ops->close(vma);
>        if (vma->vm_file) {
> +               ima_defer_fput(vma->vm_file); /* drop mmap_sem first */
>                fput(vma->vm_file);
>                if (vma->vm_flags & VM_EXECUTABLE)
>                        removed_exe_file_vma(vma->vm_mm);
> diff --git a/security/integrity/ima/ima_appraise.c b/security/integrity/ima/ima_appraise.c
> index becc7e0..a100a3c 100644
> --- a/security/integrity/ima/ima_appraise.c
> +++ b/security/integrity/ima/ima_appraise.c
> @@ -11,6 +11,7 @@
>  #include <linux/module.h>
>  #include <linux/file.h>
>  #include <linux/fs.h>
> +#include <linux/mempool.h>
>  #include <linux/xattr.h>
>  #include <linux/magic.h>
>  #include <linux/ima.h>
> @@ -226,3 +227,86 @@ int ima_inode_removexattr(struct dentry *dentry, const char *xattr_name)
>        }
>        return result;
>  }
> +
> +struct ima_fput_req {
> +       struct file *file;
> +       struct work_struct work;
> +};
> +static struct kmem_cache *ima_fput_slab;
> +static mempool_t *ima_fput_mempool;
> +
> +static void ima_deferred_fput(struct work_struct *work)
> +{
> +       struct ima_fput_req *deferred = container_of(work, struct ima_fput_req,
> +                                                    work);
> +
> +       fput(deferred->file);
> +       mempool_free(deferred, ima_fput_mempool);
> +}
> +
> +/**
> + * ima_defer_fput - defer calling __fput() for mmaped files
> + * @file: pointer to file structure to be freed
> + *
> + * The i_mutex is taken by ima_file_free(), called on  __fput(), to
> + * update 'security.ima' to reflect the current file data hash.  When
> + * a file is closed before it is munmapped, __fput() is called with
> + * the mmap_sem taken, resulting in an mmap_sem/i_mutex lockdep.
> + * This function defers calling __fput() until after the mmap_sem is
> + * released.
> + */
> +void ima_defer_fput(struct file *file)
> +{
> +       struct dentry *dentry = file->f_path.dentry;
> +       struct inode *inode = dentry->d_inode;
> +       struct ima_fput_req *defer;
> +       int rc;
> +
> +       if (!IS_IMA(inode))
> +               return;
> +
> +       defer = mempool_alloc(ima_fput_mempool, GFP_NOIO);
> +       if (!defer)
> +               return;
> +
> +       get_file(file);
> +
> +       defer->file = file;
> +       INIT_WORK(&defer->work, ima_deferred_fput);
> +       rc = schedule_work(&defer->work);
> +       if (rc == 0) {
> +               pr_info("ima: schedule work failed\n");
> +               mempool_free(defer, ima_fput_mempool);
> +               fput_atomic(file);
> +       }
> +}
> +
> +static int __init ima_fput_mempool_create(void)
> +{
> +       ima_fput_slab = kmem_cache_create("ima_fput",
> +                                          sizeof(struct ima_fput_req),
> +                                          0, 0, NULL);
> +       if (!ima_fput_slab) {
> +               pr_info("ima: failed kmem_cache_create\n");
> +               goto err_out;
> +       }
> +
> +       ima_fput_mempool = mempool_create_slab_pool(1, ima_fput_slab);
> +       if (!ima_fput_mempool)  {
> +               pr_info("ima: failed mempool_create_slab_pool\n");
> +               goto free_slab;
> +       }
> +       return 0;
> +
> +free_slab:
> +       kmem_cache_destroy(ima_fput_slab);
> +err_out:
> +       return -ENOMEM;
> +}
> +
> +static void __exit ima_fput_mempool_destroy(void)
> +{
> +       mempool_destroy(ima_fput_mempool);
> +       kmem_cache_destroy(ima_fput_slab);
> +}

Is it really needed? I think it will never be called if not a module...

> +security_initcall(ima_fput_mempool_create);
> --
> 1.7.6.5
>
