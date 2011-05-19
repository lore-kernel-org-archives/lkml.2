Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932182Ab1ESCGZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 22:06:25 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:54103 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755690Ab1ESCGX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 22:06:23 -0400
X-Authority-Analysis: v=1.1 cv=y6zMVzRGPZqd+EkIbWgKRW0ZY5+85Abqc3bXR1aXymM= c=1 sm=0 a=wom5GMh1gUkA:10 a=wtnYtgMbmu0A:10 a=Rj1_iGo3bfgA:10 a=kj9zAlcOel0A:10 a=g3F5VGk0NOMZWSIEWMgijA==:17 a=VnNF1IyMAAAA:8 a=fxJcL_dCAAAA:8 a=VwQbUJbxAAAA:8 a=W0vUJOdyAAAA:8 a=m6LMz6NZga1H6JMBiG4A:9 a=M1rmCluM9b59vw0cHhAA:7 a=CjuIK1q_8ugA:10 a=x8gzFH9gYPwA:10 a=2eKvNQJKnqYA:10 a=g3F5VGk0NOMZWSIEWMgijA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 70.123.158.191
Date: Wed, 18 May 2011 21:06:20 -0500
From: "Serge E. Hallyn" <serge@hallyn.com>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, James Morris <jmorris@namei.org>,
        David Safford <safford@watson.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>,
        Dmitry Kasatkin <dmitry.kasatkin@nokia.com>,
        Mimi Zohar <zohar@us.ibm.com>
Subject: Re: [PATCH v5 01/21] integrity: move ima inode integrity data
 management
Message-ID: <20110519020619.GA10188@mail.hallyn.com>
References: <1305557115-15652-1-git-send-email-zohar@linux.vnet.ibm.com>
 <1305557115-15652-2-git-send-email-zohar@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1305557115-15652-2-git-send-email-zohar@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Mimi Zohar (zohar@linux.vnet.ibm.com):
> Move the inode integrity data(iint) management up to the integrity directory
> in order to share the iint among the different integrity models.

You also

  rename several globally visible ima_* functions, structs, locks etc to
     integrity_\0
  replace '20' by SHA1_DIGEST_SIZE
  remove unnecessary initialization of iint_initialized to 0

Which all are fine, but probably should be mentioned in changelog,
along with the magic phrase "no other functional changes" to aid
reviewers.

> Changelog:
>    - Rebased on current ima_iint.c
>    - Define integrity_iint_store/lock as static
> 
> Signed-off-by: Mimi Zohar <zohar@us.ibm.com>

Acked-by: Serge Hallyn <serge.hallyn@ubuntu.com>

thanks,
-serge

> ---
>  include/linux/ima.h               |   13 ---
>  include/linux/integrity.h         |   30 +++++++
>  security/Kconfig                  |    2 +-
>  security/Makefile                 |    4 +-
>  security/integrity/Kconfig        |    6 ++
>  security/integrity/Makefile       |   10 ++
>  security/integrity/iint.c         |  170 +++++++++++++++++++++++++++++++++++++
>  security/integrity/ima/Kconfig    |    1 +
>  security/integrity/ima/Makefile   |    2 +-
>  security/integrity/ima/ima.h      |   29 ++-----
>  security/integrity/ima/ima_api.c  |    7 +-
>  security/integrity/ima/ima_iint.c |  169 ------------------------------------
>  security/integrity/ima/ima_main.c |   12 ++--
>  security/integrity/integrity.h    |   37 ++++++++
>  security/security.c               |    3 +-
>  15 files changed, 279 insertions(+), 216 deletions(-)
>  create mode 100644 include/linux/integrity.h
>  create mode 100644 security/integrity/Kconfig
>  create mode 100644 security/integrity/Makefile
>  create mode 100644 security/integrity/iint.c
>  delete mode 100644 security/integrity/ima/ima_iint.c
>  create mode 100644 security/integrity/integrity.h
> 
> diff --git a/include/linux/ima.h b/include/linux/ima.h
> index 09e6e62..6ac8e50 100644
> --- a/include/linux/ima.h
> +++ b/include/linux/ima.h
> @@ -15,8 +15,6 @@ struct linux_binprm;
>  
>  #ifdef CONFIG_IMA
>  extern int ima_bprm_check(struct linux_binprm *bprm);
> -extern int ima_inode_alloc(struct inode *inode);
> -extern void ima_inode_free(struct inode *inode);
>  extern int ima_file_check(struct file *file, int mask);
>  extern void ima_file_free(struct file *file);
>  extern int ima_file_mmap(struct file *file, unsigned long prot);
> @@ -27,16 +25,6 @@ static inline int ima_bprm_check(struct linux_binprm *bprm)
>  	return 0;
>  }
>  
> -static inline int ima_inode_alloc(struct inode *inode)
> -{
> -	return 0;
> -}
> -
> -static inline void ima_inode_free(struct inode *inode)
> -{
> -	return;
> -}
> -
>  static inline int ima_file_check(struct file *file, int mask)
>  {
>  	return 0;
> @@ -51,6 +39,5 @@ static inline int ima_file_mmap(struct file *file, unsigned long prot)
>  {
>  	return 0;
>  }
> -
>  #endif /* CONFIG_IMA_H */
>  #endif /* _LINUX_IMA_H */
> diff --git a/include/linux/integrity.h b/include/linux/integrity.h
> new file mode 100644
> index 0000000..9059812
> --- /dev/null
> +++ b/include/linux/integrity.h
> @@ -0,0 +1,30 @@
> +/*
> + * Copyright (C) 2009 IBM Corporation
> + * Author: Mimi Zohar <zohar@us.ibm.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation, version 2 of the License.
> + */
> +
> +#ifndef _LINUX_INTEGRITY_H
> +#define _LINUX_INTEGRITY_H
> +
> +#include <linux/fs.h>
> +
> +#ifdef CONFIG_INTEGRITY
> +extern int integrity_inode_alloc(struct inode *inode);
> +extern void integrity_inode_free(struct inode *inode);
> +
> +#else
> +static inline int integrity_inode_alloc(struct inode *inode)
> +{
> +	return 0;
> +}
> +
> +static inline void integrity_inode_free(struct inode *inode)
> +{
> +	return;
> +}
> +#endif /* CONFIG_INTEGRITY_H */
> +#endif /* _LINUX_INTEGRITY_H */
> diff --git a/security/Kconfig b/security/Kconfig
> index e0f08b5..22847a8 100644
> --- a/security/Kconfig
> +++ b/security/Kconfig
> @@ -186,7 +186,7 @@ source security/smack/Kconfig
>  source security/tomoyo/Kconfig
>  source security/apparmor/Kconfig
>  
> -source security/integrity/ima/Kconfig
> +source security/integrity/Kconfig
>  
>  choice
>  	prompt "Default security module"
> diff --git a/security/Makefile b/security/Makefile
> index 8bb0fe9..a5e502f 100644
> --- a/security/Makefile
> +++ b/security/Makefile
> @@ -24,5 +24,5 @@ obj-$(CONFIG_SECURITY_APPARMOR)		+= apparmor/built-in.o
>  obj-$(CONFIG_CGROUP_DEVICE)		+= device_cgroup.o
>  
>  # Object integrity file lists
> -subdir-$(CONFIG_IMA)			+= integrity/ima
> -obj-$(CONFIG_IMA)			+= integrity/ima/built-in.o
> +subdir-$(CONFIG_INTEGRITY)		+= integrity
> +obj-$(CONFIG_INTEGRITY)			+= integrity/built-in.o
> diff --git a/security/integrity/Kconfig b/security/integrity/Kconfig
> new file mode 100644
> index 0000000..2704691
> --- /dev/null
> +++ b/security/integrity/Kconfig
> @@ -0,0 +1,6 @@
> +#
> +config INTEGRITY
> +	def_bool y
> +	depends on IMA
> +
> +source security/integrity/ima/Kconfig
> diff --git a/security/integrity/Makefile b/security/integrity/Makefile
> new file mode 100644
> index 0000000..6eddd61
> --- /dev/null
> +++ b/security/integrity/Makefile
> @@ -0,0 +1,10 @@
> +#
> +# Makefile for caching inode integrity data (iint)
> +#
> +
> +obj-$(CONFIG_INTEGRITY) += integrity.o
> +
> +integrity-y := iint.o
> +
> +subdir-$(CONFIG_IMA)			+= ima
> +obj-$(CONFIG_IMA)			+= ima/built-in.o
> diff --git a/security/integrity/iint.c b/security/integrity/iint.c
> new file mode 100644
> index 0000000..d17de48
> --- /dev/null
> +++ b/security/integrity/iint.c
> @@ -0,0 +1,170 @@
> +/*
> + * Copyright (C) 2008 IBM Corporation
> + *
> + * Authors:
> + * Mimi Zohar <zohar@us.ibm.com>
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License as
> + * published by the Free Software Foundation, version 2 of the
> + * License.
> + *
> + * File: integrity_iint.c
> + *	- implements the integrity hooks: integrity_inode_alloc,
> + *	  integrity_inode_free
> + *	- cache integrity information associated with an inode
> + *	  using a rbtree tree.
> + */
> +#include <linux/slab.h>
> +#include <linux/module.h>
> +#include <linux/spinlock.h>
> +#include <linux/rbtree.h>
> +#include "integrity.h"
> +
> +static struct rb_root integrity_iint_tree = RB_ROOT;
> +static DEFINE_SPINLOCK(integrity_iint_lock);
> +static struct kmem_cache *iint_cache __read_mostly;
> +
> +int iint_initialized;
> +
> +/*
> + * __integrity_iint_find - return the iint associated with an inode
> + */
> +static struct integrity_iint_cache *__integrity_iint_find(struct inode *inode)
> +{
> +	struct integrity_iint_cache *iint;
> +	struct rb_node *n = integrity_iint_tree.rb_node;
> +
> +	assert_spin_locked(&integrity_iint_lock);
> +
> +	while (n) {
> +		iint = rb_entry(n, struct integrity_iint_cache, rb_node);
> +
> +		if (inode < iint->inode)
> +			n = n->rb_left;
> +		else if (inode > iint->inode)
> +			n = n->rb_right;
> +		else
> +			break;
> +	}
> +	if (!n)
> +		return NULL;
> +
> +	return iint;
> +}
> +
> +/*
> + * integrity_iint_find - return the iint associated with an inode
> + */
> +struct integrity_iint_cache *integrity_iint_find(struct inode *inode)
> +{
> +	struct integrity_iint_cache *iint;
> +
> +	if (!IS_IMA(inode))
> +		return NULL;
> +
> +	spin_lock(&integrity_iint_lock);
> +	iint = __integrity_iint_find(inode);
> +	spin_unlock(&integrity_iint_lock);
> +
> +	return iint;
> +}
> +
> +static void iint_free(struct integrity_iint_cache *iint)
> +{
> +	iint->version = 0;
> +	iint->flags = 0UL;
> +	kmem_cache_free(iint_cache, iint);
> +}
> +
> +/**
> + * integrity_inode_alloc - allocate an iint associated with an inode
> + * @inode: pointer to the inode
> + */
> +int integrity_inode_alloc(struct inode *inode)
> +{
> +	struct rb_node **p;
> +	struct rb_node *new_node, *parent = NULL;
> +	struct integrity_iint_cache *new_iint, *test_iint;
> +	int rc;
> +
> +	new_iint = kmem_cache_alloc(iint_cache, GFP_NOFS);
> +	if (!new_iint)
> +		return -ENOMEM;
> +
> +	new_iint->inode = inode;
> +	new_node = &new_iint->rb_node;
> +
> +	mutex_lock(&inode->i_mutex);	/* i_flags */
> +	spin_lock(&integrity_iint_lock);
> +
> +	p = &integrity_iint_tree.rb_node;
> +	while (*p) {
> +		parent = *p;
> +		test_iint = rb_entry(parent, struct integrity_iint_cache,
> +				     rb_node);
> +		rc = -EEXIST;
> +		if (inode < test_iint->inode)
> +			p = &(*p)->rb_left;
> +		else if (inode > test_iint->inode)
> +			p = &(*p)->rb_right;
> +		else
> +			goto out_err;
> +	}
> +
> +	inode->i_flags |= S_IMA;
> +	rb_link_node(new_node, parent, p);
> +	rb_insert_color(new_node, &integrity_iint_tree);
> +
> +	spin_unlock(&integrity_iint_lock);
> +	mutex_unlock(&inode->i_mutex);	/* i_flags */
> +
> +	return 0;
> +out_err:
> +	spin_unlock(&integrity_iint_lock);
> +	mutex_unlock(&inode->i_mutex);	/* i_flags */
> +	iint_free(new_iint);
> +
> +	return rc;
> +}
> +
> +/**
> + * integrity_inode_free - called on security_inode_free
> + * @inode: pointer to the inode
> + *
> + * Free the integrity information(iint) associated with an inode.
> + */
> +void integrity_inode_free(struct inode *inode)
> +{
> +	struct integrity_iint_cache *iint;
> +
> +	if (!IS_IMA(inode))
> +		return;
> +
> +	spin_lock(&integrity_iint_lock);
> +	iint = __integrity_iint_find(inode);
> +	rb_erase(&iint->rb_node, &integrity_iint_tree);
> +	spin_unlock(&integrity_iint_lock);
> +
> +	iint_free(iint);
> +}
> +
> +static void init_once(void *foo)
> +{
> +	struct integrity_iint_cache *iint = foo;
> +
> +	memset(iint, 0, sizeof *iint);
> +	iint->version = 0;
> +	iint->flags = 0UL;
> +	mutex_init(&iint->mutex);
> +}
> +
> +static int __init integrity_iintcache_init(void)
> +{
> +	iint_cache =
> +	    kmem_cache_create("iint_cache", sizeof(struct integrity_iint_cache),
> +			      0, SLAB_PANIC, init_once);
> +	iint_initialized = 1;
> +	return 0;
> +}
> +security_initcall(integrity_iintcache_init);
> diff --git a/security/integrity/ima/Kconfig b/security/integrity/ima/Kconfig
> index b6ecfd4..19c053b 100644
> --- a/security/integrity/ima/Kconfig
> +++ b/security/integrity/ima/Kconfig
> @@ -3,6 +3,7 @@
>  config IMA
>  	bool "Integrity Measurement Architecture(IMA)"
>  	depends on SECURITY
> +	select INTEGRITY
>  	select SECURITYFS
>  	select CRYPTO
>  	select CRYPTO_HMAC
> diff --git a/security/integrity/ima/Makefile b/security/integrity/ima/Makefile
> index 787c4cb..5690c02 100644
> --- a/security/integrity/ima/Makefile
> +++ b/security/integrity/ima/Makefile
> @@ -6,4 +6,4 @@
>  obj-$(CONFIG_IMA) += ima.o
>  
>  ima-y := ima_fs.o ima_queue.o ima_init.o ima_main.o ima_crypto.o ima_api.o \
> -	 ima_policy.o ima_iint.o ima_audit.o
> +	 ima_policy.o ima_audit.o
> diff --git a/security/integrity/ima/ima.h b/security/integrity/ima/ima.h
> index 08408bd..29d97af 100644
> --- a/security/integrity/ima/ima.h
> +++ b/security/integrity/ima/ima.h
> @@ -24,11 +24,13 @@
>  #include <linux/tpm.h>
>  #include <linux/audit.h>
>  
> +#include "../integrity.h"
> +
>  enum ima_show_type { IMA_SHOW_BINARY, IMA_SHOW_ASCII };
>  enum tpm_pcrs { TPM_PCR0 = 0, TPM_PCR8 = 8 };
>  
>  /* digest size for IMA, fits SHA1 or MD5 */
> -#define IMA_DIGEST_SIZE		20
> +#define IMA_DIGEST_SIZE		SHA1_DIGEST_SIZE
>  #define IMA_EVENT_NAME_LEN_MAX	255
>  
>  #define IMA_HASH_BITS 9
> @@ -96,34 +98,21 @@ static inline unsigned long ima_hash_key(u8 *digest)
>  	return hash_long(*digest, IMA_HASH_BITS);
>  }
>  
> -/* iint cache flags */
> -#define IMA_MEASURED		0x01
> -
> -/* integrity data associated with an inode */
> -struct ima_iint_cache {
> -	struct rb_node rb_node; /* rooted in ima_iint_tree */
> -	struct inode *inode;	/* back pointer to inode in question */
> -	u64 version;		/* track inode changes */
> -	unsigned char flags;
> -	u8 digest[IMA_DIGEST_SIZE];
> -	struct mutex mutex;	/* protects: version, flags, digest */
> -};
> -
>  /* LIM API function definitions */
>  int ima_must_measure(struct inode *inode, int mask, int function);
> -int ima_collect_measurement(struct ima_iint_cache *iint, struct file *file);
> -void ima_store_measurement(struct ima_iint_cache *iint, struct file *file,
> +int ima_collect_measurement(struct integrity_iint_cache *iint,
> +			    struct file *file);
> +void ima_store_measurement(struct integrity_iint_cache *iint, struct file *file,
>  			   const unsigned char *filename);
>  int ima_store_template(struct ima_template_entry *entry, int violation,
>  		       struct inode *inode);
> -void ima_template_show(struct seq_file *m, void *e,
> -		       enum ima_show_type show);
> +void ima_template_show(struct seq_file *m, void *e, enum ima_show_type show);
>  
>  /* rbtree tree calls to lookup, insert, delete
>   * integrity data associated with an inode.
>   */
> -struct ima_iint_cache *ima_iint_insert(struct inode *inode);
> -struct ima_iint_cache *ima_iint_find(struct inode *inode);
> +struct integrity_iint_cache *integrity_iint_insert(struct inode *inode);
> +struct integrity_iint_cache *integrity_iint_find(struct inode *inode);
>  
>  /* IMA policy related functions */
>  enum ima_hooks { FILE_CHECK = 1, FILE_MMAP, BPRM_CHECK };
> diff --git a/security/integrity/ima/ima_api.c b/security/integrity/ima/ima_api.c
> index da36d2c..0d50df0 100644
> --- a/security/integrity/ima/ima_api.c
> +++ b/security/integrity/ima/ima_api.c
> @@ -126,7 +126,8 @@ int ima_must_measure(struct inode *inode, int mask, int function)
>   *
>   * Return 0 on success, error code otherwise
>   */
> -int ima_collect_measurement(struct ima_iint_cache *iint, struct file *file)
> +int ima_collect_measurement(struct integrity_iint_cache *iint,
> +			    struct file *file)
>  {
>  	int result = -EEXIST;
>  
> @@ -156,8 +157,8 @@ int ima_collect_measurement(struct ima_iint_cache *iint, struct file *file)
>   *
>   * Must be called with iint->mutex held.
>   */
> -void ima_store_measurement(struct ima_iint_cache *iint, struct file *file,
> -			   const unsigned char *filename)
> +void ima_store_measurement(struct integrity_iint_cache *iint,
> +			   struct file *file, const unsigned char *filename)
>  {
>  	const char *op = "add_template_measure";
>  	const char *audit_cause = "ENOMEM";
> diff --git a/security/integrity/ima/ima_iint.c b/security/integrity/ima/ima_iint.c
> deleted file mode 100644
> index 4ae7304..0000000
> --- a/security/integrity/ima/ima_iint.c
> +++ /dev/null
> @@ -1,169 +0,0 @@
> -/*
> - * Copyright (C) 2008 IBM Corporation
> - *
> - * Authors:
> - * Mimi Zohar <zohar@us.ibm.com>
> - *
> - * This program is free software; you can redistribute it and/or
> - * modify it under the terms of the GNU General Public License as
> - * published by the Free Software Foundation, version 2 of the
> - * License.
> - *
> - * File: ima_iint.c
> - * 	- implements the IMA hooks: ima_inode_alloc, ima_inode_free
> - *	- cache integrity information associated with an inode
> - *	  using a rbtree tree.
> - */
> -#include <linux/slab.h>
> -#include <linux/module.h>
> -#include <linux/spinlock.h>
> -#include <linux/rbtree.h>
> -#include "ima.h"
> -
> -static struct rb_root ima_iint_tree = RB_ROOT;
> -static DEFINE_SPINLOCK(ima_iint_lock);
> -static struct kmem_cache *iint_cache __read_mostly;
> -
> -int iint_initialized = 0;
> -
> -/*
> - * __ima_iint_find - return the iint associated with an inode
> - */
> -static struct ima_iint_cache *__ima_iint_find(struct inode *inode)
> -{
> -	struct ima_iint_cache *iint;
> -	struct rb_node *n = ima_iint_tree.rb_node;
> -
> -	assert_spin_locked(&ima_iint_lock);
> -
> -	while (n) {
> -		iint = rb_entry(n, struct ima_iint_cache, rb_node);
> -
> -		if (inode < iint->inode)
> -			n = n->rb_left;
> -		else if (inode > iint->inode)
> -			n = n->rb_right;
> -		else
> -			break;
> -	}
> -	if (!n)
> -		return NULL;
> -
> -	return iint;
> -}
> -
> -/*
> - * ima_iint_find - return the iint associated with an inode
> - */
> -struct ima_iint_cache *ima_iint_find(struct inode *inode)
> -{
> -	struct ima_iint_cache *iint;
> -
> -	if (!IS_IMA(inode))
> -		return NULL;
> -
> -	spin_lock(&ima_iint_lock);
> -	iint = __ima_iint_find(inode);
> -	spin_unlock(&ima_iint_lock);
> -
> -	return iint;
> -}
> -
> -static void iint_free(struct ima_iint_cache *iint)
> -{
> -	iint->version = 0;
> -	iint->flags = 0UL;
> -	kmem_cache_free(iint_cache, iint);
> -}
> -
> -/**
> - * ima_inode_alloc - allocate an iint associated with an inode
> - * @inode: pointer to the inode
> - */
> -int ima_inode_alloc(struct inode *inode)
> -{
> -	struct rb_node **p;
> -	struct rb_node *new_node, *parent = NULL;
> -	struct ima_iint_cache *new_iint, *test_iint;
> -	int rc;
> -
> -	new_iint = kmem_cache_alloc(iint_cache, GFP_NOFS);
> -	if (!new_iint)
> -		return -ENOMEM;
> -
> -	new_iint->inode = inode;
> -	new_node = &new_iint->rb_node;
> -
> -	mutex_lock(&inode->i_mutex); /* i_flags */
> -	spin_lock(&ima_iint_lock);
> -
> -	p = &ima_iint_tree.rb_node;
> -	while (*p) {
> -		parent = *p;
> -		test_iint = rb_entry(parent, struct ima_iint_cache, rb_node);
> -
> -		rc = -EEXIST;
> -		if (inode < test_iint->inode)
> -			p = &(*p)->rb_left;
> -		else if (inode > test_iint->inode)
> -			p = &(*p)->rb_right;
> -		else
> -			goto out_err;
> -	}
> -
> -	inode->i_flags |= S_IMA;
> -	rb_link_node(new_node, parent, p);
> -	rb_insert_color(new_node, &ima_iint_tree);
> -
> -	spin_unlock(&ima_iint_lock);
> -	mutex_unlock(&inode->i_mutex); /* i_flags */
> -
> -	return 0;
> -out_err:
> -	spin_unlock(&ima_iint_lock);
> -	mutex_unlock(&inode->i_mutex); /* i_flags */
> -	iint_free(new_iint);
> -
> -	return rc;
> -}
> -
> -/**
> - * ima_inode_free - called on security_inode_free
> - * @inode: pointer to the inode
> - *
> - * Free the integrity information(iint) associated with an inode.
> - */
> -void ima_inode_free(struct inode *inode)
> -{
> -	struct ima_iint_cache *iint;
> -
> -	if (!IS_IMA(inode))
> -		return;
> -
> -	spin_lock(&ima_iint_lock);
> -	iint = __ima_iint_find(inode);
> -	rb_erase(&iint->rb_node, &ima_iint_tree);
> -	spin_unlock(&ima_iint_lock);
> -
> -	iint_free(iint);
> -}
> -
> -static void init_once(void *foo)
> -{
> -	struct ima_iint_cache *iint = foo;
> -
> -	memset(iint, 0, sizeof *iint);
> -	iint->version = 0;
> -	iint->flags = 0UL;
> -	mutex_init(&iint->mutex);
> -}
> -
> -static int __init ima_iintcache_init(void)
> -{
> -	iint_cache =
> -	    kmem_cache_create("iint_cache", sizeof(struct ima_iint_cache), 0,
> -			      SLAB_PANIC, init_once);
> -	iint_initialized = 1;
> -	return 0;
> -}
> -security_initcall(ima_iintcache_init);
> diff --git a/security/integrity/ima/ima_main.c b/security/integrity/ima/ima_main.c
> index 39d66dc..25f9fe7 100644
> --- a/security/integrity/ima/ima_main.c
> +++ b/security/integrity/ima/ima_main.c
> @@ -82,7 +82,7 @@ out:
>  				  "open_writers");
>  }
>  
> -static void ima_check_last_writer(struct ima_iint_cache *iint,
> +static void ima_check_last_writer(struct integrity_iint_cache *iint,
>  				  struct inode *inode,
>  				  struct file *file)
>  {
> @@ -105,12 +105,12 @@ static void ima_check_last_writer(struct ima_iint_cache *iint,
>  void ima_file_free(struct file *file)
>  {
>  	struct inode *inode = file->f_dentry->d_inode;
> -	struct ima_iint_cache *iint;
> +	struct integrity_iint_cache *iint;
>  
>  	if (!iint_initialized || !S_ISREG(inode->i_mode))
>  		return;
>  
> -	iint = ima_iint_find(inode);
> +	iint = integrity_iint_find(inode);
>  	if (!iint)
>  		return;
>  
> @@ -121,7 +121,7 @@ static int process_measurement(struct file *file, const unsigned char *filename,
>  			       int mask, int function)
>  {
>  	struct inode *inode = file->f_dentry->d_inode;
> -	struct ima_iint_cache *iint;
> +	struct integrity_iint_cache *iint;
>  	int rc = 0;
>  
>  	if (!ima_initialized || !S_ISREG(inode->i_mode))
> @@ -131,9 +131,9 @@ static int process_measurement(struct file *file, const unsigned char *filename,
>  	if (rc != 0)
>  		return rc;
>  retry:
> -	iint = ima_iint_find(inode);
> +	iint = integrity_iint_find(inode);
>  	if (!iint) {
> -		rc = ima_inode_alloc(inode);
> +		rc = integrity_inode_alloc(inode);
>  		if (!rc || rc == -EEXIST)
>  			goto retry;
>  		return rc;
> diff --git a/security/integrity/integrity.h b/security/integrity/integrity.h
> new file mode 100644
> index 0000000..2217a28
> --- /dev/null
> +++ b/security/integrity/integrity.h
> @@ -0,0 +1,37 @@
> +/*
> + * Copyright (C) 2009-2010 IBM Corporation
> + *
> + * Authors:
> + * Mimi Zohar <zohar@us.ibm.com>
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License as
> + * published by the Free Software Foundation, version 2 of the
> + * License.
> + *
> + */
> +
> +#include <linux/types.h>
> +#include <linux/integrity.h>
> +#include <crypto/sha.h>
> +
> +#define MAX_DIGEST_SIZE		SHA1_DIGEST_SIZE
> +
> +/* iint cache flags */
> +#define IMA_MEASURED		0x01
> +
> +/* integrity data associated with an inode */
> +struct integrity_iint_cache {
> +	struct rb_node rb_node; /* rooted in integrity_iint_tree */
> +	struct inode *inode;	/* back pointer to inode in question */
> +	u64 version;		/* track inode changes */
> +	unsigned char flags;
> +	u8 digest[MAX_DIGEST_SIZE];
> +	struct mutex mutex;	/* protects: version, flags, digest */
> +};
> +
> +/* rbtree tree calls to lookup, insert, delete
> + * integrity data associated with an inode.
> + */
> +struct integrity_iint_cache *integrity_iint_insert(struct inode *inode);
> +struct integrity_iint_cache *integrity_iint_find(struct inode *inode);
> diff --git a/security/security.c b/security/security.c
> index 1011423..d0c6576 100644
> --- a/security/security.c
> +++ b/security/security.c
> @@ -16,6 +16,7 @@
>  #include <linux/init.h>
>  #include <linux/kernel.h>
>  #include <linux/security.h>
> +#include <linux/integrity.h>
>  #include <linux/ima.h>
>  
>  /* Boot-time LSM user choice */
> @@ -334,7 +335,7 @@ int security_inode_alloc(struct inode *inode)
>  
>  void security_inode_free(struct inode *inode)
>  {
> -	ima_inode_free(inode);
> +	integrity_inode_free(inode);
>  	security_ops->inode_free_security(inode);
>  }
>  
> -- 
> 1.7.3.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
