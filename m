Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932714Ab0DGO47 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Apr 2010 10:56:59 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:45040 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932581Ab0DGO45 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Apr 2010 10:56:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=NtGNMPJW3oZ/4e7QeY1Lr8aRuXa4JBBWnFHkioCIhYjg9sl1FshzTZSIvPhXaB6dyD
         rZOWYRU8poc/VqaHEe+a9khen8Gr92O9udFlOrSQtzafBb2nwRuksILrJSvropZ4/rGs
         XyjFCILmRQB99AQUCfjUsR+UN7Tg4r9S0YpNo=
Subject: Re: [PATCH 1/2] rcu: add rcu_access_pointer and
 rcu_dereference_protect
From: Eric Dumazet <eric.dumazet@gmail.com>
To: David Howells <dhowells@redhat.com>
Cc: paulmck@linux.vnet.ibm.com, Trond.Myklebust@netapp.com,
       linux-nfs@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20100407135732.12414.16416.stgit@warthog.procyon.org.uk>
References: <20100407135732.12414.16416.stgit@warthog.procyon.org.uk>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 07 Apr 2010 16:56:50 +0200
Message-ID: <1270652210.8141.9.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mercredi 07 avril 2010 à 14:57 +0100, David Howells a écrit :
> From: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> 
> This patch adds variants of rcu_dereference() that handle situations
> where the RCU-protected data structure cannot change, perhaps due to
> our holding the update-side lock, or where the RCU-protected pointer is
> only to be fetched, not dereferenced.
> 
> The new rcu_access_pointer() primitive is for the case where the pointer
> is be fetch and not dereferenced.  This primitive may be used without
> protection, RCU or otherwise, due to the fact that it uses ACCESS_ONCE().
> 
> The new rcu_dereference_protect() primitive is for the case where updates
> are prevented, for example, due to holding the update-side lock.  This
> primitive does neither ACCESS_ONCE() nor smp_read_barrier_depends(), so
> can only be used when updates are somehow prevented.
> 
> Suggested-by: David Howells <dhowells@redhat.com>
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> Signed-off-by: David Howells <dhowells@redhat.com>
> ---
> 
>  include/linux/rcupdate.h |   34 ++++++++++++++++++++++++++++++++++
>  1 files changed, 34 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
> index 872a98e..a1b14b6 100644
> --- a/include/linux/rcupdate.h
> +++ b/include/linux/rcupdate.h
> @@ -209,9 +209,43 @@ static inline int rcu_read_lock_sched_held(void)
>  		rcu_dereference_raw(p); \
>  	})
>  
> +/**
> + * rcu_access_pointer - fetch RCU pointer with no dereferencing
> + *
> + * Return the value of the specified RCU-protected pointer, but omit the
> + * smp_read_barrier_depends() and keep the ACCESS_ONCE().  This is useful
> + * when the value of this pointer is accessed, but the pointer is not
> + * dereferenced, for example, when testing an RCU-protected pointer against
> + * NULL.  This may also be used in cases where update-side locks prevent
> + * the value of the pointer from changing, but rcu_dereference_protect()
> + * is a lighter-weight primitive for this use case.
> + */
> +#define rcu_access_pointer(p) \
> +	({ \
> +		ACCESS_ONCE(p); \
> +	})
> +
> +/**
> + * rcu_dereference_protected - fetch RCU pointer when updates prevented
> + *
> + * Return the value of the specified RCU-protected pointer, but omit
> + * both the smp_read_barrier_depends() and the ACCESS_ONCE().  This
> + * is useful in cases where update-side locks prevent the value of the
> + * pointer from changing.  Please note that this primitive does -not-
> + * prevent the compiler from repeating this reference or combining it
> + * with other references, so it should not be used without protection
> + * of appropriate locks.
> + */
> +#define rcu_dereference_protected(p) \
> +	({ \
> +		(p); \
> +	})
> +
>  #else /* #ifdef CONFIG_PROVE_RCU */
>  
>  #define rcu_dereference_check(p, c)	rcu_dereference_raw(p)
> +#define rcu_access_pointer(p)		ACCESS_ONCE(p)
> +#define rcu_dereference_protect(p)	(p)
>  
>  #endif /* #else #ifdef CONFIG_PROVE_RCU */
>  
> 
> --

This is not the version Paul posted. 

Removing checks just to shutup warnings ?

All the point is to get lockdep assistance, and you throw it away.

We want to explicit the condition, so that RCU users can explicitly
state what protects their data.



