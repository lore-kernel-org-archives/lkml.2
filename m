Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759214Ab2HHUJp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 16:09:45 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:57185 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757337Ab2HHUJn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 16:09:43 -0400
Subject: Re: NULL pointer dereference in selinux_ip_postroute_compat
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Eric Paris <eparis@parisplace.org>
Cc: Paul Moore <paul@paul-moore.com>, John Stultz <johnstul@us.ibm.com>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        lkml <linux-kernel@vger.kernel.org>,
        James Morris <james.l.morris@oracle.com>, selinux@tycho.nsa.gov,
        Eric Dumazet <edumazet@google.com>, john.johansen@canonical.com
In-Reply-To: <CACLa4ptgoge0nnEuov5E9gc2bdR-wjCo+bpB6Auhwo8jSO99oA@mail.gmail.com>
References: <50215A7E.8000701@linaro.org> <502198B4.8040503@linaro.org>
	 <5022BAA2.90606@us.ibm.com> <17464273.DGOeQvDGIE@sifl>
	 <1344454701.28967.233.camel@edumazet-glaptop>
	 <CACLa4ptgoge0nnEuov5E9gc2bdR-wjCo+bpB6Auhwo8jSO99oA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 08 Aug 2012 22:09:38 +0200
Message-ID: <1344456578.28967.244.camel@edumazet-glaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-08-08 at 15:59 -0400, Eric Paris wrote:

> Seems wrong.  We shouldn't ever need ifdef CONFIG_SECURITY in core
> code. 

Sure but it seems include file misses an accessor for this.

We could add it on a future cleanup patch, as Paul mentioned.

>  Ifndef CONF_SECURITY then security_sk_alloc() is a static
> inline return 0;   I guess the question is "Where did the sk come
> from"?  Why wasn't security_sk_alloc() called when it was allocated?
> Should it have been updated at some time and that wasn't done either?
> Seems wrong to be putting packets on the queue for a socket where the
> security data was never allocated and was never set to its proper
> state.
> 

IMHO it seems wrong to even care about security for internal sockets.

They are per cpu, shared for all users on the machine.

What kind of security do you envision exactly ?


These unicast_sock are percpu, and preallocated.

/*
 *      Generic function to send a packet as reply to another packet.
 *      Used to send some TCP resets/acks so far.
 *
 *      Use a fake percpu inet socket to avoid false sharing and contention.
 */
static DEFINE_PER_CPU(struct inet_sock, unicast_sock) = {
        .sk = {
                .__sk_common = {
                        .skc_refcnt = ATOMIC_INIT(1),
                },
                .sk_wmem_alloc  = ATOMIC_INIT(1),
                .sk_allocation  = GFP_ATOMIC,
                .sk_flags       = (1UL << SOCK_USE_WRITE_QUEUE),
        },
        .pmtudisc       = IP_PMTUDISC_WANT,
        .uc_ttl         = -1,
};


