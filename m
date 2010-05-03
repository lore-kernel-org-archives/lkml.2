Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759227Ab0ECWab (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 May 2010 18:30:31 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:45376 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753175Ab0ECWa3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 May 2010 18:30:29 -0400
Date: Mon, 3 May 2010 17:30:23 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: David Howells <dhowells@redhat.com>
Cc: torvalds@osdl.org, akpm@linux-foundation.org, keyrings@linux-nfs.org,
       linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/7] KEYS: Use RCU dereference wrappers in keyring key
 type code
Message-ID: <20100503223023.GC6968@us.ibm.com>
References: <20100430133208.2126.56765.stgit@warthog.procyon.org.uk>
 <20100430133218.2126.28129.stgit@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100430133218.2126.28129.stgit@warthog.procyon.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting David Howells (dhowells@redhat.com):
> The keyring key type code should use RCU dereference wrappers, even when it
> holds the keyring's key semaphore.
> 
> Reported-by: Vegard Nossum <vegard.nossum@gmail.com>
> Signed-off-by: David Howells <dhowells@redhat.com>

Acked-by: Serge Hallyn <serue@us.ibm.com>


<shrug> does this mean that the
        klist = rcu_dereference_check(keyring->payload.subscriptions,
				      lockdep_is_held(&key_serial_lock));
in security/keys/gc.c:key_gc_keyring() should become a
rcu_dereference_protected() to avoid the rcu_dereference_raw() and for
consistency?

> ---
> 
>  security/keys/keyring.c |   23 +++++++++++++----------
>  1 files changed, 13 insertions(+), 10 deletions(-)
> 
> diff --git a/security/keys/keyring.c b/security/keys/keyring.c
> index d570824..63385af 100644
> --- a/security/keys/keyring.c
> +++ b/security/keys/keyring.c
> @@ -20,6 +20,11 @@
>  #include <linux/uaccess.h>
>  #include "internal.h"
> 
> +#define rcu_dereference_locked_keyring(keyring)				\
> +	(rcu_dereference_protected(					\
> +		(keyring)->payload.subscriptions,			\
> +		rwsem_is_locked((struct rw_semaphore *)&(keyring)->sem)))
> +
>  /*
>   * when plumbing the depths of the key tree, this sets a hard limit set on how
>   * deep we're willing to go
> @@ -201,8 +206,7 @@ static long keyring_read(const struct key *keyring,
>  	int loop, ret;
> 
>  	ret = 0;
> -	klist = keyring->payload.subscriptions;
> -
> +	klist = rcu_dereference_locked_keyring(keyring);

Weird, this was a straight rcu_dereference in my tree (which would
still deserve a switch for the same reason as patch 1 of course)

>  	if (klist) {
>  		/* calculate how much data we could return */
>  		qty = klist->nkeys * sizeof(key_serial_t);
> @@ -720,8 +724,7 @@ int __key_link(struct key *keyring, struct key *key)
>  	}
> 
>  	/* see if there's a matching key we can displace */
> -	klist = keyring->payload.subscriptions;
> -
> +	klist = rcu_dereference_locked_keyring(keyring);
>  	if (klist && klist->nkeys > 0) {
>  		struct key_type *type = key->type;
> 
> @@ -765,8 +768,6 @@ int __key_link(struct key *keyring, struct key *key)
>  	if (ret < 0)
>  		goto error2;
> 
> -	klist = keyring->payload.subscriptions;
> -

huh, yeah, seems to have been there and unneeded since at least 2007.

-serge
