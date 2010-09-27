Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758865Ab0I0HPR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 03:15:17 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:58384 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757503Ab0I0HPP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 03:15:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=g1RBHCmkqnpmWLJOzLbI2g9lqCH2Glm7/DXMiDAl8QcxR+du0mfVIa7L6bPoOol0LE
         Vf5pLIWIjzt2tC7BQPoIWJYMDULqghEVmXN8D+egZa5sHd4l/YK2uU1tM38kblmN34ue
         yejtIoGgGk6K4slMfcALRicqlTjbU4iHgsIWg=
MIME-Version: 1.0
In-Reply-To: <m1d3s19z38.fsf@fess.ebiederm.org>
References: <m1sk0x9z62.fsf@fess.ebiederm.org>
	<m1d3s19z38.fsf@fess.ebiederm.org>
Date: Mon, 27 Sep 2010 10:15:14 +0300
X-Google-Sender-Auth: kVuqbw4CrU-aG7waMPEoL2RHKlY
Message-ID: <AANLkTik=6cGkkpBJUfhNJ8ZhB8MfFrm=zXWtLOP-S_ZR@mail.gmail.com>
Subject: Re: [PATCH 3/3] mm: Cause revoke_mappings to wait until all close
 methods have completed.
From: Pekka Enberg <penberg@kernel.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Rik van Riel <riel@redhat.com>,
        Hugh Dickins <hughd@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 26, 2010 at 2:34 AM, Eric W. Biederman
<ebiederm@xmission.com> wrote:
>
> Signed-off-by: Eric W. Biederman <ebiederm@aristanetworks.com>

The changelog is slightly too terse for me to review this. What's the
race you're trying to avoid? If the point is to make the revoke task
wait until everything has been closed, why can't we use the completion
API here?

> ---
>  include/linux/fs.h |    2 ++
>  mm/mmap.c          |   13 ++++++++++++-
>  mm/revoke.c        |   18 +++++++++++++++---
>  3 files changed, 29 insertions(+), 4 deletions(-)
>
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index 76041b6..5d3d6b8 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -633,6 +633,8 @@ struct address_space {
>        const struct address_space_operations *a_ops;   /* methods */
>        unsigned long           flags;          /* error bits/gfp mask */
>        struct backing_dev_info *backing_dev_info; /* device readahead, etc */
> +       struct task_struct      *revoke_task;   /* Who to wake up when all vmas are closed */
> +       unsigned int            close_count;    /* Cover race conditions with revoke_mappings */
>        spinlock_t              private_lock;   /* for use by the address_space */
>        struct list_head        private_list;   /* ditto */
>        struct address_space    *assoc_mapping; /* ditto */
> diff --git a/mm/mmap.c b/mm/mmap.c
> index 17dd003..3df3193 100644
> --- a/mm/mmap.c
> +++ b/mm/mmap.c
> @@ -218,6 +218,7 @@ void unlink_file_vma(struct vm_area_struct *vma)
>                struct address_space *mapping = file->f_mapping;
>                spin_lock(&mapping->i_mmap_lock);
>                __remove_shared_vm_struct(vma, file, mapping);
> +               mapping->close_count++;
>                spin_unlock(&mapping->i_mmap_lock);
>        }
>  }
> @@ -233,9 +234,19 @@ static struct vm_area_struct *remove_vma(struct vm_area_struct *vma)
>        if (vma->vm_ops && vma->vm_ops->close)
>                vma->vm_ops->close(vma);
>        if (vma->vm_file) {
> -               fput(vma->vm_file);
> +               struct address_space *mapping = vma->vm_file->f_mapping;
>                if (vma->vm_flags & VM_EXECUTABLE)
>                        removed_exe_file_vma(vma->vm_mm);
> +
> +               /* Decrement the close count and wake up a revoker if present */
> +               spin_lock(&mapping->i_mmap_lock);
> +               mapping->close_count--;
> +               if ((mapping->close_count == 0) && mapping->revoke_task)
> +                       /* Is wake_up_process the right variant of try_to_wake_up? */
> +                       wake_up_process(mapping->revoke_task);
> +               spin_unlock(&mapping->i_mmap_lock);
> +
> +               fput(vma->vm_file);
>        }
>        mpol_put(vma_policy(vma));
>        kmem_cache_free(vm_area_cachep, vma);
> diff --git a/mm/revoke.c b/mm/revoke.c
> index a76cd1a..e19f7df 100644
> --- a/mm/revoke.c
> +++ b/mm/revoke.c
> @@ -143,15 +143,17 @@ void revoke_mappings(struct address_space *mapping)
>        /* Make any access to previously mapped pages trigger a SIGBUS,
>         * and stop calling vm_ops methods.
>         *
> -        * When revoke_mappings returns invocations of vm_ops->close
> -        * may still be in progress, but no invocations of any other
> -        * vm_ops methods will be.
> +        * When revoke_mappings no invocations of any method will be
> +        * in progress.
>         */
>        struct vm_area_struct *vma;
>        struct prio_tree_iter iter;
>
>        spin_lock(&mapping->i_mmap_lock);
>
> +       WARN_ON(mapping->revoke_task);
> +       mapping->revoke_task = current;
> +
>  restart_tree:
>        vma_prio_tree_foreach(vma, &iter, &mapping->i_mmap, 0, ULONG_MAX) {
>                if (revoke_mapping(mapping, vma->vm_mm, vma->vm_start))
> @@ -164,6 +166,16 @@ restart_list:
>                        goto restart_list;
>        }
>
> +       while (!list_empty(&mapping->i_mmap_nonlinear) ||
> +              !prio_tree_empty(&mapping->i_mmap) ||
> +              mapping->close_count)
> +       {
> +               __set_current_state(TASK_UNINTERRUPTIBLE);
> +               spin_unlock(&mapping->i_mmap_lock);
> +               schedule();
> +               spin_lock(&mapping->i_mmap_lock);
> +       }
> +       mapping->revoke_task = NULL;
>        spin_unlock(&mapping->i_mmap_lock);
>  }
>  EXPORT_SYMBOL_GPL(revoke_mappings);
> --
> 1.7.2.3
>
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
>
>
