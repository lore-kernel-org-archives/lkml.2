Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759297Ab2HHUrI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 16:47:08 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:37407 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759163Ab2HHUrG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 16:47:06 -0400
From: Paul Moore <paul@paul-moore.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Eric Paris <eparis@parisplace.org>, John Stultz <johnstul@us.ibm.com>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        lkml <linux-kernel@vger.kernel.org>,
        James Morris <james.l.morris@oracle.com>, selinux@tycho.nsa.gov,
        Eric Dumazet <edumazet@google.com>, john.johansen@canonical.com
Subject: Re: NULL pointer dereference in selinux_ip_postroute_compat
Date: Wed, 08 Aug 2012 16:46:59 -0400
Message-ID: <1610114.P5WAdux1ri@sifl>
User-Agent: KMail/4.9 (Linux/3.4.7-gentoo; KDE/4.9.0; x86_64; ; )
In-Reply-To: <1344457972.28967.251.camel@edumazet-glaptop>
References: <50215A7E.8000701@linaro.org> <1344456578.28967.244.camel@edumazet-glaptop> <1344457972.28967.251.camel@edumazet-glaptop>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, August 08, 2012 10:32:52 PM Eric Dumazet wrote:
> On Wed, 2012-08-08 at 22:09 +0200, Eric Dumazet wrote:
> > On Wed, 2012-08-08 at 15:59 -0400, Eric Paris wrote:
> > > Seems wrong.  We shouldn't ever need ifdef CONFIG_SECURITY in core
> > > code.
> > 
> > Sure but it seems include file misses an accessor for this.
> > 
> > We could add it on a future cleanup patch, as Paul mentioned.
> 
> I cooked following patch.
> But smack/smack_lsm.c makes a reference to
> smk_of_current()... so it seems we are in a hole...
> 
> It makes little sense to me to have any kind of security on this
> internal sockets.
> 
> Maybe selinux should not crash if sk->sk_security is NULL ?

I realize our last emails probably passed each other mid-flight, but hopefully 
it explains why we can't just pass packets when sk->sk_security is NULL.

Regardless, some quick comments below ...

> diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
> index 6c77f63..459eca6 100644
> --- a/security/selinux/hooks.c
> +++ b/security/selinux/hooks.c
> @@ -4289,10 +4289,13 @@ out:
>  	return 0;
>  }
> 
> -static int selinux_sk_alloc_security(struct sock *sk, int family, ...
> +static int selinux_sk_alloc_security(struct sock *sk, int family, ...
>  {
>  	struct sk_security_struct *sksec;
> 
> +	if (check && sk->sk_security)
> +		return 0;
> +
>  	sksec = kzalloc(sizeof(*sksec), priority);
>  	if (!sksec)
>  		return -ENOMEM;

I think I might replace the "check" boolean with a "kern/kernel" boolean so 
that in addition to the allocation we can also initialize the socket to 
SECINITSID_KERNEL/kernel_t here in the case when the boolean is set.  The only 
place that would set the boolean to true would be ip_send_unicast_reply(), all 
other callers would set it to false.

> diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
> index 8221514..8965cf1 100644
> --- a/security/smack/smack_lsm.c
> +++ b/security/smack/smack_lsm.c
> @@ -1754,11 +1754,14 @@ static void smack_task_to_inode(struct task_struct
> *p, struct inode *inode) *
>   * Returns 0 on success, -ENOMEM is there's no memory
>   */
> -static int smack_sk_alloc_security(struct sock *sk, int family, gfp_t
> gfp_flags) +static int smack_sk_alloc_security(struct sock *sk, int family,
> gfp_t gfp_flags, bool check) {
>  	char *csp = smk_of_current();
>  	struct socket_smack *ssp;
> 
> +	if (check && sk->sk_security)
> +		return 0;
> +
>  	ssp = kzalloc(sizeof(struct socket_smack), gfp_flags);
>  	if (ssp == NULL)
>  		return -ENOMEM;

In the case of Smack, when the kernel boolean is true I think the right 
solution is to use smack_net_ambient.

-- 
paul moore
www.paul-moore.com

