Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759316Ab2HHVDY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 17:03:24 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:48322 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759277Ab2HHVDV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 17:03:21 -0400
From: Paul Moore <paul@paul-moore.com>
To: Eric Paris <eparis@parisplace.org>
Cc: Eric Dumazet <eric.dumazet@gmail.com>, John Stultz <johnstul@us.ibm.com>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        lkml <linux-kernel@vger.kernel.org>,
        James Morris <james.l.morris@oracle.com>, selinux@tycho.nsa.gov,
        Eric Dumazet <edumazet@google.com>, john.johansen@canonical.com
Subject: Re: NULL pointer dereference in selinux_ip_postroute_compat
Date: Wed, 08 Aug 2012 17:03:17 -0400
Message-ID: <1463614.KLCBsoWyCC@sifl>
User-Agent: KMail/4.9 (Linux/3.4.7-gentoo; KDE/4.9.0; x86_64; ; )
In-Reply-To: <CACLa4pu4SFHp9nxp4RJ1L4a-cz+qPaYrGCULLGXDOGCYAMdqzQ@mail.gmail.com>
References: <50215A7E.8000701@linaro.org> <2294220.dmCbVvF3Tg@sifl> <CACLa4pu4SFHp9nxp4RJ1L4a-cz+qPaYrGCULLGXDOGCYAMdqzQ@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, August 08, 2012 04:51:56 PM Eric Paris wrote:
> On Wed, Aug 8, 2012 at 4:35 PM, Paul Moore <paul@paul-moore.com> wrote:
> > On Wednesday, August 08, 2012 10:09:38 PM Eric Dumazet wrote:
> > 
> > Actually, the issue is that the shared socket doesn't have an init/alloc
> > function to do the LSM allocation like we do with other sockets so Eric's
> > patch does it as part of ip_send_unicast_reply().
> > 
> > If we look at the relevant part of Eric's patch:
> >  +#ifdef CONFIG_SECURITY
> >  +       if (!sk->sk_security && security_sk_alloc(sk, PF_INET,
> >  GFP_ATOMIC))
> >  +                       goto out;
> >  +#endif
> > 
> > ... if we were to remove the CONFIG_SECURITY conditional we would end up
> > calling security_sk_alloc() each time through in the CONFIG_SECURITY=n
> > case as sk->sk_security would never be initialized to a non-NULL value. 
> > In the CONFIG_SECURITY=y case it should only be called once as
> > security_sk_alloc() should set sk->sk_security to a LSM blob.
> 
> Ifndef SECURITY this turns into (because security_sk_alloc is a static
> inline in that case)
> 
> if (!sk->sk_security && 0)
>         goto out;
> 
> Which I'd hope the compiler would optimize.  So that only leaves us
> caring about the case there CONFIG_SECURITY is true.  In that case if
> we need code which does if !alloc'd then alloc it seems we broke the
> model of everything else in the code and added a branch needlessly.
> 
> Could we add a __init function which does the security_sk_alloc() in
> the same file where we declared them?

Is it safe to call security_sk_alloc() from inside another __init function?  I 
think in both the case of SELinux and Smack it shouldn't be a problem, but I'm 
concerned about the more general case of calling a LSM hook potentially before 
the LSM has been initialized.

If that isn't an issue we could probably do something in ip_init().

> > The issue I'm struggling with at present is how should we handle this
> > traffic from a LSM perspective.  The label based LSMs, e.g. SELinux and
> > Smack, use the LSM blob assigned to locally generated outbound traffic to
> > identify the traffic and apply the security policy, so not only do we
> > have to resolve the issue of ensuring the traffic is labeled correctly,
> > we have to do it with a shared socket (although the patch didn't change
> > the shared nature of the socket).
> > 
> > For those who are interested, I think the reasonable labeling solution
> > here is to go with SECINITSID_KERNEL/kernel_t for SELinux and likely the
> > ambient label for Smack as in both the TCP reset and timewait ACK there
> > shouldn't be any actual user data present.
> 
> I'm willing to accept that argument from an SELinux perspective.  I'd
> also accept the argument that it is private and do something similar
> to what we do with IS_PRIVATE on inodes.  Although sockets probably
> don't have a good field to use...

I'm not aware of one.  See my comments on Eric's last patch posting (the other 
Eric, not you).

-- 
paul moore
www.paul-moore.com

