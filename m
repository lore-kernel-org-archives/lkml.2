Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756078Ab2LNDXP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 22:23:15 -0500
Received: from 50-56-35-84.static.cloud-ips.com ([50.56.35.84]:58210 "EHLO
	mail.hallyn.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754851Ab2LNDXO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 22:23:14 -0500
Date: Fri, 14 Dec 2012 03:28:20 +0000
From: "Serge E. Hallyn" <serge@hallyn.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: "Serge E. Hallyn" <serge@hallyn.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        containers@lists.linux-foundation.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andy Lutomirski <luto@amacapital.net>,
        linux-security-module@vger.kernel.org
Subject: Re: [RFC][PATCH] Fix cap_capable to only allow owners in the
 parent user namespace to have caps.
Message-ID: <20121214032820.GA5115@mail.hallyn.com>
References: <87ip88uw4n.fsf@xmission.com>
 <50CA2B55.5070402@amacapital.net>
 <87mwxhtxve.fsf@xmission.com>
 <87zk1hshk7.fsf_-_@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87zk1hshk7.fsf_-_@xmission.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Eric W. Biederman (ebiederm@xmission.com):
> 
> Andy Lutomirski pointed out that the current behavior of allowing the
> owner of a user namespace to have all caps when that owner is not in a
> parent user namespace is wrong.

To make sure I understand right, the issue is when a uid is mapped
into multiple namespaces, i.e. uid 1000 in ns1 may own ns2, but uid
1000 in ns3 does not?

> This is a bug introduced by the kuid conversion which made it possible
> for the owner of a user namespace to live in a child user namespace.  I
> goofed and totally missed this implication.
> 
> Serge and can you please take a look and see if my corrected cap_capable
> reads correctly to you.
> 
> Andy or anyone else that wants to give me a second eyeball and double
> check me on this I would appreciate it.
> 
> Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>

Acked-by: Serge Hallyn <serge.hallyn@canonical.com>

> ---
> 
> diff --git a/security/commoncap.c b/security/commoncap.c
> index 6dbae46..4639f44 100644
> --- a/security/commoncap.c
> +++ b/security/commoncap.c
> @@ -70,37 +70,44 @@ int cap_netlink_send(struct sock *sk, struct sk_buff *skb)
>   *
>   * NOTE WELL: cap_has_capability() cannot be used like the kernel's capable()
>   * and has_capability() functions.  That is, it has the reverse semantics:
>   * cap_has_capability() returns 0 when a task has a capability, but the
>   * kernel's capable() and has_capability() returns 1 for this case.
>   */
>  int cap_capable(const struct cred *cred, struct user_namespace *targ_ns,
>  		int cap, int audit)
>  {
>  	for (;;) {
> -		/* The owner of the user namespace has all caps. */
> -		if (targ_ns != &init_user_ns && uid_eq(targ_ns->owner, cred->euid))
> -			return 0;
> +		struct user_namespace *parent_ns;
>  
>  		/* Do we have the necessary capabilities? */
>  		if (targ_ns == cred->user_ns)
>  			return cap_raised(cred->cap_effective, cap) ? 0 : -EPERM;
>  
>  		/* Have we tried all of the parent namespaces? */
>  		if (targ_ns == &init_user_ns)
>  			return -EPERM;
>  
> +		parent_ns = targ_ns->parent;
> +
> +		/* 
> +		 * The owner of the user namespace in the parent user
> +		 * namespace has all caps.
> +		 */
> +		if ((parent_ns == cred->user_ns) && uid_eq(targ_ns->owner, cred->euid))
> +			return 0;
> +
>  		/*
> -		 *If you have a capability in a parent user ns, then you have
> +		 * If you have a capability in a parent user ns, then you have
>  		 * it over all children user namespaces as well.
>  		 */
> -		targ_ns = targ_ns->parent;
> +		targ_ns = parent_ns;
>  	}
>  
>  	/* We never get here */
>  }
>  
>  /**
>   * cap_settime - Determine whether the current process may set the system clock
>   * @ts: The time to set
>   * @tz: The timezone to set
>   *
