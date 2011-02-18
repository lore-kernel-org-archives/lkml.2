Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753323Ab1BRSZo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Feb 2011 13:25:44 -0500
Received: from adelie.canonical.com ([91.189.90.139]:43454 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751999Ab1BRSZn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Feb 2011 13:25:43 -0500
Date: Fri, 18 Feb 2011 12:25:02 -0600
From: "Serge E. Hallyn" <serge.hallyn@canonical.com>
To: Matt Helsley <matthltc@us.ibm.com>
Cc: linux-kernel@vger.kernel.org, Pavel Emelyanov <xemul@parallels.com>,
        containers@lists.linux-foundation.org,
        David Howells <dhowells@redhat.com>,
        Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [PATCH] Reduce uidhash lock hold time when lookup succeeds
Message-ID: <20110218182502.GA22238@localhost>
References: <caebc7ebaa97599ef72b22d1172dfd2ebe770fce.1297986770.git.matthltc@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <caebc7ebaa97599ef72b22d1172dfd2ebe770fce.1297986770.git.matthltc@us.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Matt Helsley (matthltc@us.ibm.com):
> When lookup succeeds we don't need the "new" user struct which hasn't
> been linked into the uidhash. So we can immediately drop the lock and
> then free "new" rather than free it with the lock held.
> 
> Signed-off-by: Matt Helsley <matthltc@us.ibm.com>
> Cc: David Howells <dhowells@redhat.com>
> Cc: Pavel Emelyanov <xemul@parallels.com>
> Cc: Alexey Dobriyan <adobriyan@gmail.com>
> Cc: "Serge E. Hallyn" <serge@hallyn.com>

Acked-by: Serge E. Hallyn <serge@hallyn.com>

And might I say that the label 'out_unlock' in that function is
sadly named :)

> Cc: containers@lists.linux-foundation.org
> ---
>  kernel/user.c |   12 +++++++-----
>  1 files changed, 7 insertions(+), 5 deletions(-)
> 
> diff --git a/kernel/user.c b/kernel/user.c
> index 5c598ca..4ea8e58 100644
> --- a/kernel/user.c
> +++ b/kernel/user.c
> @@ -157,16 +157,18 @@ struct user_struct *alloc_uid(struct user_namespace *ns, uid_t uid)
>  		 */
>  		spin_lock_irq(&uidhash_lock);
>  		up = uid_hash_find(uid, hashent);
> -		if (up) {
> +		if (!up) {
> +			uid_hash_insert(new, hashent);
> +			up = new;
> +		}
> +		spin_unlock_irq(&uidhash_lock);
> +
> +		if (up != new) {
>  			put_user_ns(ns);
>  			key_put(new->uid_keyring);
>  			key_put(new->session_keyring);
>  			kmem_cache_free(uid_cachep, new);
> -		} else {
> -			uid_hash_insert(new, hashent);
> -			up = new;
>  		}
> -		spin_unlock_irq(&uidhash_lock);
>  	}
>  
>  	return up;
> -- 
> 1.6.3.3
> 
> _______________________________________________
> Containers mailing list
> Containers@lists.linux-foundation.org
> https://lists.linux-foundation.org/mailman/listinfo/containers
