Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754129Ab2HEA65 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Aug 2012 20:58:57 -0400
Received: from out03.mta.xmission.com ([166.70.13.233]:56051 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753954Ab2HEA6w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Aug 2012 20:58:52 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Sasha Levin <levinsasha928@gmail.com>
Cc: torvalds@linux-foundation.org, tj@kernel.org, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        paul.gortmaker@windriver.com, davem@davemloft.net, rostedt@goodmis.org,
        mingo@elte.hu, aarcange@redhat.com, ericvh@gmail.com,
        netdev@vger.kernel.org
References: <1344003788-1417-1-git-send-email-levinsasha928@gmail.com>
	<1344003788-1417-3-git-send-email-levinsasha928@gmail.com>
Date: Sat, 04 Aug 2012 17:58:32 -0700
In-Reply-To: <1344003788-1417-3-git-send-email-levinsasha928@gmail.com> (Sasha
	Levin's message of "Fri, 3 Aug 2012 16:23:03 +0200")
Message-ID: <87pq76tarr.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1+bdFC9EB8n5pkoAxo8KHQYZ/edI2vwvq4=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0063]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Sasha Levin <levinsasha928@gmail.com>
X-Spam-Relay-Country: 
Subject: Re: [RFC v2 2/7] user_ns: use new hashtable implementation
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sasha Levin <levinsasha928@gmail.com> writes:

> Switch user_ns to use the new hashtable implementation. This reduces the amount of
> generic unrelated code in user_ns.


Just looking at this ick.

- Your comparison function is broken.
- The naming is awkward.
    hash_get without a reference count being  incremented?
- The magic is deep.
   hash_get is named like a function but takes a piece of code to call
   like only a macro can.
- uid_hash_find always bumped the reference count
  but your uidhash_entry doesn't nor do all of the callers of
  uidhash_entry bump the reference count.

Nacked-by: "Eric W. Biederman" <ebiederm@xmission.com>

I don't have the time for a new improved better hash table that makes
the code buggier.

Eric


> Signed-off-by: Sasha Levin <levinsasha928@gmail.com>
> ---
>  kernel/user.c |   53 ++++++++++++++++++-----------------------------------
>  1 files changed, 18 insertions(+), 35 deletions(-)
>
> diff --git a/kernel/user.c b/kernel/user.c
> index b815fef..555c71a 100644
> --- a/kernel/user.c
> +++ b/kernel/user.c
> @@ -16,6 +16,7 @@
>  #include <linux/interrupt.h>
>  #include <linux/export.h>
>  #include <linux/user_namespace.h>
> +#include <linux/hashtable.h>
>  
>  /*
>   * userns count is 1 for root user, 1 for init_uts_ns,
> @@ -50,15 +51,14 @@ EXPORT_SYMBOL_GPL(init_user_ns);
>   * UID task count cache, to get fast user lookup in "alloc_uid"
>   * when changing user ID's (ie setuid() and friends).
>   */
> -
> -#define UIDHASH_BITS	(CONFIG_BASE_SMALL ? 3 : 7)
> -#define UIDHASH_SZ	(1 << UIDHASH_BITS)
> -#define UIDHASH_MASK		(UIDHASH_SZ - 1)
> -#define __uidhashfn(uid)	(((uid >> UIDHASH_BITS) + uid) & UIDHASH_MASK)
> -#define uidhashentry(uid)	(uidhash_table + __uidhashfn((__kuid_val(uid))))
> +#define UIDHASH_BITS		(CONFIG_BASE_SMALL ? 3 : 7)
> +#define UIDHASH_CMP(obj, key) 	((obj)->uid == (key))
> +#define uidhash_entry(key)	(hash_get(&uidhash_table, key,		\
> +				struct user_struct, uidhash_node,	\
> +				UIDHASH_CMP))
>  
>  static struct kmem_cache *uid_cachep;
> -struct hlist_head uidhash_table[UIDHASH_SZ];
> +DEFINE_STATIC_HASHTABLE(uidhash_table, UIDHASH_BITS);
>  
>  /*
>   * The uidhash_lock is mostly taken from process context, but it is
> @@ -84,29 +84,14 @@ struct user_struct root_user = {
>  /*
>   * These routines must be called with the uidhash spinlock held!
>   */
> -static void uid_hash_insert(struct user_struct *up, struct hlist_head *hashent)
> +static void uid_hash_insert(struct user_struct *up)
>  {
> -	hlist_add_head(&up->uidhash_node, hashent);
> +	hash_add(&uidhash_table, &up->uidhash_node, up->uid);
>  }
>  
>  static void uid_hash_remove(struct user_struct *up)
>  {
> -	hlist_del_init(&up->uidhash_node);
> -}
> -
> -static struct user_struct *uid_hash_find(kuid_t uid, struct hlist_head *hashent)
> -{
> -	struct user_struct *user;
> -	struct hlist_node *h;
> -
> -	hlist_for_each_entry(user, h, hashent, uidhash_node) {
> -		if (uid_eq(user->uid, uid)) {
> -			atomic_inc(&user->__count);
> -			return user;
> -		}
> -	}
> -
> -	return NULL;
> +	hash_del(&up->uidhash_node);
>  }
>  
>  /* IRQs are disabled and uidhash_lock is held upon function entry.
> @@ -135,7 +120,9 @@ struct user_struct *find_user(kuid_t uid)
>  	unsigned long flags;
>  
>  	spin_lock_irqsave(&uidhash_lock, flags);
> -	ret = uid_hash_find(uid, uidhashentry(uid));
> +	ret = uidhash_entry(uid);
> +	if (ret)
> +		atomic_inc(&ret->__count);
>  	spin_unlock_irqrestore(&uidhash_lock, flags);
>  	return ret;
>  }
> @@ -156,11 +143,10 @@ void free_uid(struct user_struct *up)
>  
>  struct user_struct *alloc_uid(kuid_t uid)
>  {
> -	struct hlist_head *hashent = uidhashentry(uid);
>  	struct user_struct *up, *new;
>  
>  	spin_lock_irq(&uidhash_lock);
> -	up = uid_hash_find(uid, hashent);
> +	up = uidhash_entry(uid);
>  	spin_unlock_irq(&uidhash_lock);
>  
>  	if (!up) {
> @@ -176,13 +162,13 @@ struct user_struct *alloc_uid(kuid_t uid)
>  		 * on adding the same user already..
>  		 */
>  		spin_lock_irq(&uidhash_lock);
> -		up = uid_hash_find(uid, hashent);
> +		up = uidhash_entry(uid);
>  		if (up) {
>  			key_put(new->uid_keyring);
>  			key_put(new->session_keyring);
>  			kmem_cache_free(uid_cachep, new);
>  		} else {
> -			uid_hash_insert(new, hashent);
> +			uid_hash_insert(new);
>  			up = new;
>  		}
>  		spin_unlock_irq(&uidhash_lock);
> @@ -196,17 +182,14 @@ out_unlock:
>  
>  static int __init uid_cache_init(void)
>  {
> -	int n;
> -
>  	uid_cachep = kmem_cache_create("uid_cache", sizeof(struct user_struct),
>  			0, SLAB_HWCACHE_ALIGN|SLAB_PANIC, NULL);
>  
> -	for(n = 0; n < UIDHASH_SZ; ++n)
> -		INIT_HLIST_HEAD(uidhash_table + n);
> +	hash_init(&uidhash_table, UIDHASH_BITS);
>  
>  	/* Insert the root user immediately (init already runs as root) */
>  	spin_lock_irq(&uidhash_lock);
> -	uid_hash_insert(&root_user, uidhashentry(GLOBAL_ROOT_UID));
> +	uid_hash_insert(&root_user);
>  	spin_unlock_irq(&uidhash_lock);
>  
>  	return 0;
