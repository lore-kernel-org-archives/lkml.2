Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932728Ab0EZQsf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 12:48:35 -0400
Received: from mga09.intel.com ([134.134.136.24]:9099 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932133Ab0EZQsc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 12:48:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,304,1272870000"; 
   d="scan'208";a="625042838"
Subject: Re: [PATCH V2] x86/pat: fix memory leak in free_memtype
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Xiaotian Feng <dfeng@redhat.com>
Cc: "x86@kernel.org" <x86@kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Jack Steiner <steiner@sgi.com>,
       Venkatesh Pallipadi <venki@google.com>
In-Reply-To: <1274838670-8731-1-git-send-email-dfeng@redhat.com>
References: <1274832742.2892.549.camel@sbs-t61.sc.intel.com>
	 <1274838670-8731-1-git-send-email-dfeng@redhat.com>
Content-Type: text/plain
Organization: Intel Corp
Date: Wed, 26 May 2010 09:47:33 -0700
Message-Id: <1274892453.2838.9.camel@sbs-t61.sc.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-05-25 at 18:51 -0700, Xiaotian Feng wrote:
> reserve_memtype will allocate memory for new memtype, but
> in free_memtype, after the memtype erased from rbtree, the
> memory is not freed.
> 
> Changes since V1:
> 	make rbt_memtype_erase return erased memtype so that 
> 	it can be freed in free_memtype.
> 
> Signed-off-by: Xiaotian Feng <dfeng@redhat.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: "H. Peter Anvin" <hpa@zytor.com>
> Cc: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
> Cc: Jack Steiner <steiner@sgi.com>
> Cc: Suresh Siddha <suresh.b.siddha@intel.com>

It looks bigger than I expected. But it is a bit cleaner (as both
allocation/free happens in pat.c API)

Acked-by: Suresh Siddha <suresh.b.siddha@intel.com>

> ---
>  arch/x86/mm/pat.c          |   10 +++++++---
>  arch/x86/mm/pat_internal.h |    6 +++---
>  arch/x86/mm/pat_rbtree.c   |    7 ++++---
>  3 files changed, 14 insertions(+), 9 deletions(-)
> 
> diff --git a/arch/x86/mm/pat.c b/arch/x86/mm/pat.c
> index bbe5502..bf2b5fa 100644
> --- a/arch/x86/mm/pat.c
> +++ b/arch/x86/mm/pat.c
> @@ -336,6 +336,7 @@ int free_memtype(u64 start, u64 end)
>  {
>  	int err = -EINVAL;
>  	int is_range_ram;
> +	struct memtype *entry;
>  
>  	if (!pat_enabled)
>  		return 0;
> @@ -355,17 +356,20 @@ int free_memtype(u64 start, u64 end)
>  	}
>  
>  	spin_lock(&memtype_lock);
> -	err = rbt_memtype_erase(start, end);
> +	entry = rbt_memtype_erase(start, end);
>  	spin_unlock(&memtype_lock);
>  
> -	if (err) {
> +	if (!entry) {
>  		printk(KERN_INFO "%s:%d freeing invalid memtype %Lx-%Lx\n",
>  			current->comm, current->pid, start, end);
> +		return -EINVAL;
>  	}
> +	
> +	kfree(entry);
>  
>  	dprintk("free_memtype request 0x%Lx-0x%Lx\n", start, end);
>  
> -	return err;
> +	return 0;
>  }
>  
> 
> diff --git a/arch/x86/mm/pat_internal.h b/arch/x86/mm/pat_internal.h
> index 4f39eef..77e5ba1 100644
> --- a/arch/x86/mm/pat_internal.h
> +++ b/arch/x86/mm/pat_internal.h
> @@ -28,15 +28,15 @@ static inline char *cattr_name(unsigned long flags)
>  #ifdef CONFIG_X86_PAT
>  extern int rbt_memtype_check_insert(struct memtype *new,
>  					unsigned long *new_type);
> -extern int rbt_memtype_erase(u64 start, u64 end);
> +extern struct memtype *rbt_memtype_erase(u64 start, u64 end);
>  extern struct memtype *rbt_memtype_lookup(u64 addr);
>  extern int rbt_memtype_copy_nth_element(struct memtype *out, loff_t pos);
>  #else
>  static inline int rbt_memtype_check_insert(struct memtype *new,
>  					unsigned long *new_type)
>  { return 0; }
> -static inline int rbt_memtype_erase(u64 start, u64 end)
> -{ return 0; }
> +static inline struct memtype *rbt_memtype_erase(u64 start, u64 end)
> +{ return NULL; }
>  static inline struct memtype *rbt_memtype_lookup(u64 addr)
>  { return NULL; }
>  static inline int rbt_memtype_copy_nth_element(struct memtype *out, loff_t pos)
> diff --git a/arch/x86/mm/pat_rbtree.c b/arch/x86/mm/pat_rbtree.c
> index 07de4cb..f537087 100644
> --- a/arch/x86/mm/pat_rbtree.c
> +++ b/arch/x86/mm/pat_rbtree.c
> @@ -231,16 +231,17 @@ int rbt_memtype_check_insert(struct memtype *new, unsigned long *ret_type)
>  	return err;
>  }
>  
> -int rbt_memtype_erase(u64 start, u64 end)
> +struct memtype *rbt_memtype_erase(u64 start, u64 end)
>  {
>  	struct memtype *data;
>  
>  	data = memtype_rb_exact_match(&memtype_rbroot, start, end);
>  	if (!data)
> -		return -EINVAL;
> +		goto out;
>  
>  	rb_erase(&data->rb, &memtype_rbroot);
> -	return 0;
> +out:
> +	return data;
>  }
>  
>  struct memtype *rbt_memtype_lookup(u64 addr)

