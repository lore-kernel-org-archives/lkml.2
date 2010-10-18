Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757439Ab0JRQuN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 12:50:13 -0400
Received: from mga06.intel.com ([134.134.136.21]:55257 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752771Ab0JRQuL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 12:50:11 -0400
X-Greylist: delayed 320 seconds by postgrey-1.27 at vger.kernel.org; Mon, 18 Oct 2010 12:50:11 EDT
MIME-Version: 1.0
In-Reply-To: <20101018062530.GD8332@bombadil.infradead.org>
References: <20101016065206.GO4681@dastard>
	<20101016192027.GA6883@infradead.org>
	<ebc4973c-6c11-4397-b8b0-c212a27abce4@email.android.com>
	<20101017004945.GE1614@infradead.org>
	<20101017054008.GA16383@elte.hu>
	<20101017184652.GB28060@infradead.org>
	<alpine.LRH.2.00.1010181127480.9476@tundra.namei.org>
	<20101018062530.GD8332@bombadil.infradead.org>
Date: Mon, 18 Oct 2010 09:46:57 -0700
Message-ID: <AANLkTi=8CSk+j9atz9OsqiF_7v9DcwrMAZYJchg24xVL@mail.gmail.com>
Subject: Re: ima: use of radix tree cache indexing == massive waste of memory?
From: Ryan Ware <ryan.r.ware@intel.com>
To: Kyle McMartin <kyle@mcmartin.ca>
Cc: James Morris <jmorris@namei.org>, Christoph Hellwig <hch@infradead.org>,
        kernel@lists.fedoraproject.org, Mimi Zohar <zohar@us.ibm.com>,
        warthog9@kernel.org, Dave Chinner <david@fromorbit.com>,
        linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Serge Hallyn <serue@us.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, mingo@elte.hu,
        eparis@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 17, 2010 at 11:25 PM, Kyle McMartin <kyle@mcmartin.ca> wrote:
> If someone gives me a good reason why Fedora actually needs this
> enabled, I'm going to apply the following patch to our kernel so that
> IMA is globally an opt-in feature... Otherwise I'm inclined to just
> disable it.
>
> (But the more I look at this, the more it looks like a completely niche
>  option that has little use outside of three-letter agencies.)

Not true.  We'll be using it in MeeGo.

> I regret not looking at this more closely when it was enabled,
> (although, in my defence, when the option first showed up, I left it
> off...)
>
> It's probably way more heavyweight than necessary, as I think in most
> cases the iint_initalized test will cover the call into IMA. But better
> safe than sorry or something and there's a bunch of other cases where
> -ENOMEM will leak back up from failing kmem_cache_alloc, iirc.

Then let's bounce around ideas for making it more lightweight.  I'd
love to hear suggestions.

Ryan

> regards, Kyle
>
> ---
> From: Kyle McMartin <kyle@mcmartin.ca>
> Date: Mon, 18 Oct 2010 02:08:35 -0400
> Subject: [PATCH] ima: allow it to be completely disabled (and default to off)
>
> Allow IMA to be entirely disabled, don't even bother calling into
> the provided hooks, and avoid initializing caches.
>
> (A lot of the hooks will test iint_initialized, and so this doubly
>  disables them, since the iint cache won't be enabled. But hey, we
>  avoid a pointless branch...)
>
> Signed-off-by: Kyle McMartin <kyle@redhat.com>
> ---
>  include/linux/ima.h               |   66 +++++++++++++++++++++++++++++++++----
>  security/integrity/ima/ima_iint.c |   13 +++++--
>  security/integrity/ima/ima_main.c |   34 +++++++++++++------
>  3 files changed, 91 insertions(+), 22 deletions(-)
>
> diff --git a/include/linux/ima.h b/include/linux/ima.h
> index 975837e..2fa456d 100644
> --- a/include/linux/ima.h
> +++ b/include/linux/ima.h
> @@ -14,13 +14,65 @@
>  struct linux_binprm;
>
>  #ifdef CONFIG_IMA
> -extern int ima_bprm_check(struct linux_binprm *bprm);
> -extern int ima_inode_alloc(struct inode *inode);
> -extern void ima_inode_free(struct inode *inode);
> -extern int ima_file_check(struct file *file, int mask);
> -extern void ima_file_free(struct file *file);
> -extern int ima_file_mmap(struct file *file, unsigned long prot);
> -extern void ima_counts_get(struct file *file);
> +
> +extern int ima_enabled;
> +
> +extern int __ima_bprm_check(struct linux_binprm *bprm);
> +extern int __ima_inode_alloc(struct inode *inode);
> +extern void __ima_inode_free(struct inode *inode);
> +extern int __ima_file_check(struct file *file, int mask);
> +extern void __ima_file_free(struct file *file);
> +extern int __ima_file_mmap(struct file *file, unsigned long prot);
> +extern void __ima_counts_get(struct file *file);
> +
> +static inline int ima_bprm_check(struct linux_binprm *bprm)
> +{
> +       if (ima_enabled)
> +               return __ima_bprm_check(bprm);
> +       return 0;
> +}
> +
> +static inline int ima_inode_alloc(struct inode *inode)
> +{
> +       if (ima_enabled)
> +               return __ima_inode_alloc(inode);
> +       return 0;
> +}
> +
> +static inline void ima_inode_free(struct inode *inode)
> +{
> +       if (ima_enabled)
> +               __ima_inode_free(inode);
> +       return;
> +}
> +
> +static inline int ima_file_check(struct file *file, int mask)
> +{
> +       if (ima_enabled)
> +               return __ima_file_check(file, mask);
> +       return 0;
> +}
> +
> +static inline void ima_file_free(struct file *file)
> +{
> +       if (ima_enabled)
> +               __ima_file_free(file);
> +       return;
> +}
> +
> +static inline int ima_file_mmap(struct file *file, unsigned long prot)
> +{
> +       if (ima_enabled)
> +               return __ima_file_mmap(file, prot);
> +       return 0;
> +}
> +
> +static inline void ima_counts_get(struct file *file)
> +{
> +       if (ima_enabled)
> +               return __ima_counts_get(file);
> +       return;
> +}
>
>  #else
>  static inline int ima_bprm_check(struct linux_binprm *bprm)
> diff --git a/security/integrity/ima/ima_iint.c b/security/integrity/ima/ima_iint.c
> index afba4ae..767f026 100644
> --- a/security/integrity/ima/ima_iint.c
> +++ b/security/integrity/ima/ima_iint.c
> @@ -46,10 +46,10 @@ out:
>  }
>
>  /**
> - * ima_inode_alloc - allocate an iint associated with an inode
> + * __ima_inode_alloc - allocate an iint associated with an inode
>  * @inode: pointer to the inode
>  */
> -int ima_inode_alloc(struct inode *inode)
> +int __ima_inode_alloc(struct inode *inode)
>  {
>        struct ima_iint_cache *iint = NULL;
>        int rc = 0;
> @@ -107,12 +107,12 @@ void iint_rcu_free(struct rcu_head *rcu_head)
>  }
>
>  /**
> - * ima_inode_free - called on security_inode_free
> + * __ima_inode_free - called on security_inode_free
>  * @inode: pointer to the inode
>  *
>  * Free the integrity information(iint) associated with an inode.
>  */
> -void ima_inode_free(struct inode *inode)
> +void __ima_inode_free(struct inode *inode)
>  {
>        struct ima_iint_cache *iint;
>
> @@ -139,6 +139,11 @@ static void init_once(void *foo)
>
>  static int __init ima_iintcache_init(void)
>  {
> +       extern int ima_enabled;
> +
> +       if (!ima_enabled)
> +               return 0;
> +
>        iint_cache =
>            kmem_cache_create("iint_cache", sizeof(struct ima_iint_cache), 0,
>                              SLAB_PANIC, init_once);
> diff --git a/security/integrity/ima/ima_main.c b/security/integrity/ima/ima_main.c
> index e662b89..92e084c 100644
> --- a/security/integrity/ima/ima_main.c
> +++ b/security/integrity/ima/ima_main.c
> @@ -26,6 +26,7 @@
>  #include "ima.h"
>
>  int ima_initialized;
> +int ima_enabled = 0;
>
>  char *ima_hash = "sha1";
>  static int __init hash_setup(char *str)
> @@ -36,6 +37,14 @@ static int __init hash_setup(char *str)
>  }
>  __setup("ima_hash=", hash_setup);
>
> +static int __init ima_enable(char *str)
> +{
> +       if (strncmp(str, "on", 2) == 0)
> +               ima_enabled = 1;
> +       return 1;
> +}
> +__setup("ima=", ima_enable);
> +
>  struct ima_imbalance {
>        struct hlist_node node;
>        unsigned long fsmagic;
> @@ -130,7 +139,7 @@ static void ima_inc_counts(struct ima_iint_cache *iint, fmode_t mode)
>  }
>
>  /*
> - * ima_counts_get - increment file counts
> + * __ima_counts_get - increment file counts
>  *
>  * Maintain read/write counters for all files, but only
>  * invalidate the PCR for measured files:
> @@ -140,7 +149,7 @@ static void ima_inc_counts(struct ima_iint_cache *iint, fmode_t mode)
>  *       could result in a file measurement error.
>  *
>  */
> -void ima_counts_get(struct file *file)
> +void __ima_counts_get(struct file *file)
>  {
>        struct dentry *dentry = file->f_path.dentry;
>        struct inode *inode = dentry->d_inode;
> @@ -204,13 +213,13 @@ static void ima_dec_counts(struct ima_iint_cache *iint, struct inode *inode,
>  }
>
>  /**
> - * ima_file_free - called on __fput()
> + * __ima_file_free - called on __fput()
>  * @file: pointer to file structure being freed
>  *
>  * Flag files that changed, based on i_version;
>  * and decrement the iint readcount/writecount.
>  */
> -void ima_file_free(struct file *file)
> +void __ima_file_free(struct file *file)
>  {
>        struct inode *inode = file->f_dentry->d_inode;
>        struct ima_iint_cache *iint;
> @@ -255,7 +264,7 @@ out:
>  }
>
>  /**
> - * ima_file_mmap - based on policy, collect/store measurement.
> + * __ima_file_mmap - based on policy, collect/store measurement.
>  * @file: pointer to the file to be measured (May be NULL)
>  * @prot: contains the protection that will be applied by the kernel.
>  *
> @@ -265,7 +274,7 @@ out:
>  * Return 0 on success, an error code on failure.
>  * (Based on the results of appraise_measurement().)
>  */
> -int ima_file_mmap(struct file *file, unsigned long prot)
> +int __ima_file_mmap(struct file *file, unsigned long prot)
>  {
>        int rc;
>
> @@ -278,7 +287,7 @@ int ima_file_mmap(struct file *file, unsigned long prot)
>  }
>
>  /**
> - * ima_bprm_check - based on policy, collect/store measurement.
> + * __ima_bprm_check - based on policy, collect/store measurement.
>  * @bprm: contains the linux_binprm structure
>  *
>  * The OS protects against an executable file, already open for write,
> @@ -290,7 +299,7 @@ int ima_file_mmap(struct file *file, unsigned long prot)
>  * Return 0 on success, an error code on failure.
>  * (Based on the results of appraise_measurement().)
>  */
> -int ima_bprm_check(struct linux_binprm *bprm)
> +int __ima_bprm_check(struct linux_binprm *bprm)
>  {
>        int rc;
>
> @@ -300,7 +309,7 @@ int ima_bprm_check(struct linux_binprm *bprm)
>  }
>
>  /**
> - * ima_path_check - based on policy, collect/store measurement.
> + * __ima_path_check - based on policy, collect/store measurement.
>  * @file: pointer to the file to be measured
>  * @mask: contains MAY_READ, MAY_WRITE or MAY_EXECUTE
>  *
> @@ -309,7 +318,7 @@ int ima_bprm_check(struct linux_binprm *bprm)
>  * Always return 0 and audit dentry_open failures.
>  * (Return code will be based upon measurement appraisal.)
>  */
> -int ima_file_check(struct file *file, int mask)
> +int __ima_file_check(struct file *file, int mask)
>  {
>        int rc;
>
> @@ -318,12 +327,15 @@ int ima_file_check(struct file *file, int mask)
>                                 FILE_CHECK);
>        return 0;
>  }
> -EXPORT_SYMBOL_GPL(ima_file_check);
> +EXPORT_SYMBOL_GPL(__ima_file_check);
>
>  static int __init init_ima(void)
>  {
>        int error;
>
> +       if (!ima_enabled)
> +               return 0;
> +
>        error = ima_init();
>        ima_initialized = 1;
>        return error;
> --
> 1.7.3.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
