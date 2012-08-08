Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759291Ab2HHUv6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 16:51:58 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:41156 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753558Ab2HHUv5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 16:51:57 -0400
MIME-Version: 1.0
In-Reply-To: <2294220.dmCbVvF3Tg@sifl>
References: <50215A7E.8000701@linaro.org>
	<CACLa4ptgoge0nnEuov5E9gc2bdR-wjCo+bpB6Auhwo8jSO99oA@mail.gmail.com>
	<1344456578.28967.244.camel@edumazet-glaptop>
	<2294220.dmCbVvF3Tg@sifl>
Date: Wed, 8 Aug 2012 16:51:56 -0400
Message-ID: <CACLa4pu4SFHp9nxp4RJ1L4a-cz+qPaYrGCULLGXDOGCYAMdqzQ@mail.gmail.com>
Subject: Re: NULL pointer dereference in selinux_ip_postroute_compat
From: Eric Paris <eparis@parisplace.org>
To: Paul Moore <paul@paul-moore.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>, John Stultz <johnstul@us.ibm.com>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        lkml <linux-kernel@vger.kernel.org>,
        James Morris <james.l.morris@oracle.com>, selinux@tycho.nsa.gov,
        Eric Dumazet <edumazet@google.com>, john.johansen@canonical.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 8, 2012 at 4:35 PM, Paul Moore <paul@paul-moore.com> wrote:
> On Wednesday, August 08, 2012 10:09:38 PM Eric Dumazet wrote:

> Actually, the issue is that the shared socket doesn't have an init/alloc
> function to do the LSM allocation like we do with other sockets so Eric's
> patch does it as part of ip_send_unicast_reply().
>
> If we look at the relevant part of Eric's patch:
>
>  +#ifdef CONFIG_SECURITY
>  +       if (!sk->sk_security && security_sk_alloc(sk, PF_INET, GFP_ATOMIC))
>  +                       goto out;
>  +#endif
>
> ... if we were to remove the CONFIG_SECURITY conditional we would end up
> calling security_sk_alloc() each time through in the CONFIG_SECURITY=n case as
> sk->sk_security would never be initialized to a non-NULL value.  In the
> CONFIG_SECURITY=y case it should only be called once as security_sk_alloc()
> should set sk->sk_security to a LSM blob.

Ifndef SECURITY this turns into (because security_sk_alloc is a static
inline in that case)

if (!sk->sk_security && 0)
        goto out;

Which I'd hope the compiler would optimize.  So that only leaves us
caring about the case there CONFIG_SECURITY is true.  In that case if
we need code which does if !alloc'd then alloc it seems we broke the
model of everything else in the code and added a branch needlessly.

Could we add a __init function which does the security_sk_alloc() in
the same file where we declared them?

>> IMHO it seems wrong to even care about security for internal sockets.
>>
>> They are per cpu, shared for all users on the machine.
>
> The issue, from a security point of view, is that these sockets are sending
> network traffic; even if it is just resets and timewait ACKs, it is still
> network traffic and the LSMs need to be able to enforce security policy on
> this traffic.  After all, what would you say if your firewall let these same
> packets pass without any filtering?
>
> The issue I'm struggling with at present is how should we handle this traffic
> from a LSM perspective.  The label based LSMs, e.g. SELinux and Smack, use the
> LSM blob assigned to locally generated outbound traffic to identify the
> traffic and apply the security policy, so not only do we have to resolve the
> issue of ensuring the traffic is labeled correctly, we have to do it with a
> shared socket (although the patch didn't change the shared nature of the
> socket).
>
> For those who are interested, I think the reasonable labeling solution here is
> to go with SECINITSID_KERNEL/kernel_t for SELinux and likely the ambient label
> for Smack as in both the TCP reset and timewait ACK there shouldn't be any
> actual user data present.

I'm willing to accept that argument from an SELinux perspective.  I'd
also accept the argument that it is private and do something similar
to what we do with IS_PRIVATE on inodes.  Although sockets probably
don't have a good field to use...
