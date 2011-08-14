Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754370Ab1HNRkQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Aug 2011 13:40:16 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:55150 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753537Ab1HNRkO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Aug 2011 13:40:14 -0400
Subject: Re: sch_generic: warning: the comparison will always evaluate as
 =?UTF-8?Q?=E2=80=98true=E2=80=99?= for the address of
 =?UTF-8?Q?=E2=80=98noop=5Fqdisc=E2=80=99?= will never be NULL
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Kevin Winchester <kjwinchester@gmail.com>
Cc: hadi@cyberus.ca, davem@davemloft.net, netdev@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
In-Reply-To: <CAELBVzA-ArFvp9MRp5ZvgsEpi4ikt9Nq=zHsNSLAOiD=TqZC=w@mail.gmail.com>
References: <CAELBVzA-ArFvp9MRp5ZvgsEpi4ikt9Nq=zHsNSLAOiD=TqZC=w@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 14 Aug 2011 19:39:58 +0200
Message-ID: <1313343598.2798.12.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le dimanche 14 août 2011 à 10:44 -0300, Kevin Winchester a écrit :
> With:
> 
> gcc (GCC) 4.6.1
> 
> I noticed the following warning appearing in my build:
> 
> net/sched/sch_generic.c: In function ‘dev_graft_qdisc’:
> net/sched/sch_generic.c:678:2: warning: the comparison will always
> evaluate as ‘true’ for the address of ‘noop_qdisc’ will never be NULL
> [-Waddress]
> 
> The code in question runs:
> 
> 
>         /* ... and graft new one */
>         if (qdisc == NULL)
>                 qdisc = &noop_qdisc;
>         dev_queue->qdisc_sleeping = qdisc;
>         rcu_assign_pointer(dev_queue->qdisc, &noop_qdisc);
> 
> where rcu_assign_pointer has a null check that does not apply to
> noop_qdisc, which will never be null.
> 

gcc is a bit stupid here. Of course we know &noop_qdisc cannot be NULL.

> My question is, should that really be assigning &noop_qdisc in there?
> It seems odd to assign &noop_qdisc to qdisc only if qdisc is null, and
> then unconditionally assign &noop_qdisc into dev_queue->qdisc.
> 
> Should the line be:
> 
>         rcu_assign_pointer(dev_queue->qdisc, qdisc);
> 
> instead?
> 
> Just curious,
> 

This was already taken into account, the trick is to make rcu_assign()
not trying to be smart, and use RCU_INIT_POINTER() in places we want to
assign NULL pointers.

So one patch is carried by Paul McKenney (RCU maintainer) for next
kernel, and other one in net-next :

http://git2.kernel.org/?p=linux/kernel/git/paulmck/linux-2.6-rcu.git;a=commitdiff;h=a7590ddfc2c855e75111ef18147a86578fe136e4

http://git2.kernel.org/?p=linux/kernel/git/davem/net-next-2.6.git;a=commitdiff;h=a9b3cd7f323b2e57593e7215362a7b02fc933e3a



