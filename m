Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932164Ab1CIKUO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 05:20:14 -0500
Received: from casper.infradead.org ([85.118.1.10]:33037 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757160Ab1CIKUL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 05:20:11 -0500
Subject: Re: [BUG] rebuild_sched_domains considered dangerous
From: Peter Zijlstra <peterz@infradead.org>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        Jesse Larrew <jlarrew@linux.vnet.ibm.com>
In-Reply-To: <1299639487.22236.256.camel@pasglop>
References: <1299639487.22236.256.camel@pasglop>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 09 Mar 2011 11:19:58 +0100
Message-ID: <1299665998.2308.2753.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-03-09 at 13:58 +1100, Benjamin Herrenschmidt wrote:
> So I've been experiencing hangs shortly after boot with recent kernels
> on a Power7 machine. I was testing with PREEMPT & HZ=1024 which might
> increase the frequency of the problem but I don't think they are
> necessary to expose it.
> 
> From what I've figured out, when the machine hangs, it's essentially
> looping forever in update_sd_lb_stats(), due to a corrupted sd->groups
> list (in my cases, the list contains a loop that doesn't loop back
> the the first element).
> 
> It appears that this corresponds to one CPU deciding to rebuild the
> sched domains. There's various reasons why that can happen, the typical
> one in our case is the new VPNH feature where the hypervisor informs us
> of a change in node affinity of our virtual processors. s390 has a
> similar feature and should be affected as well.

Ahh, so that's triggering it :-), just curious, how often does the HV do
that to you?

> I suspect the problem could be reproduced on x86 by hammering the sysfs
> file that can be used to trigger a rebuild as well on a sufficently
> large machine.

Should, yeah, regular hotplug is racy too.

> From what I can tell, there's some missing locking here between
> rebuilding the domains and find_busiest_group. 

init_sched_build_groups() races against pretty much all sched_group
iterations, like the one in update_sd_lb_stats() which is the most
common one and the one you're getting stuck in.

> I haven't quite got my
> head around how that -should- be done, though, as I an really not very
> familiar with that code. 

:-)

> For example, I don't quite get when domains are
> attached to an rq, and whether code like build_numa_sched_groups() which
> allocates groups and attach them to sched domains sd->groups does it on
> a "live" domain or not (in that case, there's a problem since it kmalloc
> and attaches the uninitialized result immediately).

No, the domain stuff is good, we allocate new domains and have a
synchronize_sched() between us installing the new ones and freeing the
old ones.

But the sched_group list is as said rather icky.

> I don't believe I understand enough of the scheduler to fix that quickly
> and I'm really bogged down with some other urgent stuff, so I would very
> much appreciate if you could provide some assistance here, even if it's
> just in the form of suggestions/hints.

Yeah, sched_group rebuild is racy as hell, I haven't really managed to
come up with a sane fix yet, will poke at it.
