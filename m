Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753376Ab1HNNoa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Aug 2011 09:44:30 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:55944 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753323Ab1HNNo1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Aug 2011 09:44:27 -0400
MIME-Version: 1.0
Date: Sun, 14 Aug 2011 10:44:26 -0300
Message-ID: <CAELBVzA-ArFvp9MRp5ZvgsEpi4ikt9Nq=zHsNSLAOiD=TqZC=w@mail.gmail.com>
Subject: =?windows-1252?Q?sch=5Fgeneric=3A_warning=3A_the_comparison_will_always_eva?=
	=?windows-1252?Q?luate_as_=91true=92_for_the_address_of_=91noop=5Fqdisc=92_will?=
	=?windows-1252?Q?_never_be_NULL?=
From: Kevin Winchester <kjwinchester@gmail.com>
To: hadi@cyberus.ca, davem@davemloft.net
Cc: netdev@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With:

gcc (GCC) 4.6.1

I noticed the following warning appearing in my build:

net/sched/sch_generic.c: In function ‘dev_graft_qdisc’:
net/sched/sch_generic.c:678:2: warning: the comparison will always
evaluate as ‘true’ for the address of ‘noop_qdisc’ will never be NULL
[-Waddress]

The code in question runs:


        /* ... and graft new one */
        if (qdisc == NULL)
                qdisc = &noop_qdisc;
        dev_queue->qdisc_sleeping = qdisc;
        rcu_assign_pointer(dev_queue->qdisc, &noop_qdisc);

where rcu_assign_pointer has a null check that does not apply to
noop_qdisc, which will never be null.

My question is, should that really be assigning &noop_qdisc in there?
It seems odd to assign &noop_qdisc to qdisc only if qdisc is null, and
then unconditionally assign &noop_qdisc into dev_queue->qdisc.

Should the line be:

        rcu_assign_pointer(dev_queue->qdisc, qdisc);

instead?

Just curious,

-- 
Kevin Winchester
