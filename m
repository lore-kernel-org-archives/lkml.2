Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932183Ab1CIC6g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 21:58:36 -0500
Received: from gate.crashing.org ([63.228.1.57]:60100 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932117Ab1CIC6e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 21:58:34 -0500
Subject: [BUG] rebuild_sched_domains considered dangerous
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        Jesse Larrew <jlarrew@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 09 Mar 2011 13:58:07 +1100
Message-ID: <1299639487.22236.256.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So I've been experiencing hangs shortly after boot with recent kernels
on a Power7 machine. I was testing with PREEMPT & HZ=1024 which might
increase the frequency of the problem but I don't think they are
necessary to expose it.

>From what I've figured out, when the machine hangs, it's essentially
looping forever in update_sd_lb_stats(), due to a corrupted sd->groups
list (in my cases, the list contains a loop that doesn't loop back
the the first element).

It appears that this corresponds to one CPU deciding to rebuild the
sched domains. There's various reasons why that can happen, the typical
one in our case is the new VPNH feature where the hypervisor informs us
of a change in node affinity of our virtual processors. s390 has a
similar feature and should be affected as well.

I suspect the problem could be reproduced on x86 by hammering the sysfs
file that can be used to trigger a rebuild as well on a sufficently
large machine.

>From what I can tell, there's some missing locking here between
rebuilding the domains and find_busiest_group. I haven't quite got my
head around how that -should- be done, though, as I an really not very
familiar with that code. For example, I don't quite get when domains are
attached to an rq, and whether code like build_numa_sched_groups() which
allocates groups and attach them to sched domains sd->groups does it on
a "live" domain or not (in that case, there's a problem since it kmalloc
and attaches the uninitialized result immediately).

I don't believe I understand enough of the scheduler to fix that quickly
and I'm really bogged down with some other urgent stuff, so I would very
much appreciate if you could provide some assistance here, even if it's
just in the form of suggestions/hints.

Cheers,
Ben.


