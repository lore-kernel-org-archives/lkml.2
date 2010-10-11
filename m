Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753364Ab0JKHx4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Oct 2010 03:53:56 -0400
Received: from casper.infradead.org ([85.118.1.10]:46987 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753149Ab0JKHxz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Oct 2010 03:53:55 -0400
Subject: Re: 1 RT task blocks 4-core machine ?
From: Peter Zijlstra <peterz@infradead.org>
To: Tommaso Cucinotta <tommaso.cucinotta@sssup.it>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <4CB0A998.3020407@sssup.it>
References: <4CB0A998.3020407@sssup.it>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 11 Oct 2010 09:53:50 +0200
Message-ID: <1286783630.2336.106.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-10-09 at 19:42 +0200, Tommaso Cucinotta wrote:
> Peter wrote:
> >  On Tue, 2010-10-05 at 00:26 +0200, Tommaso Cucinotta wrote:
> >  >  A possible explanation might be that the CFS load balancing logic sees
> >  >  my only active task (e.g., the ssh server or shell etc.) as running
> >  >  alone on its core, and does not detect that it is inhibited to actually
> >  >  run due to RT tasks on the same core. Therefore, it will not migrate
> >  >  the task to the free cores. Does this explanation make sense
> >  >  or is it completely wrong ?
> >
> >  Possibly, its got some logic to detect this but maybe it gets confused
> >  still, in particular look at the adaptive cpu_power in
> >  update_cpu_power() and calling functions.
> 
> Ok, I'll have a look (when I have some time :-( ), thanks.
> 
> >  >  Also, I'd like to hear whether this is considered the "normal/desired"
> >  >  behavior of intermixing RT and non-RT tasks.
> >
> >  Pegging a cpu using sched_fifo/rr pretty much means you get to keep the
> >  pieces, if it works nice, if you can make it work better kudos, but no
> >  polling from sched_fifo/rr is not something that is considered sane for
> >  the general health of your system.
> 
> Sure, I was not thinking to push/pull across heterogeneous scheduling
> classes, but rather to simply account for the proper per-CPU tasks count
> and load (including all the tasks comprising RT ones) when load-balancing
> in CFS. 

Right, so we do that. Part of the problem is that RR/FIFO tasks have no
weight/load (not even a worst case weight like sporadic tasks have). So
what we do is (per-cpu) take an average measure of the time spend on !
CFS tasks (sched_rt_avg_update() and friends) and use that to lower that
CPUs total throughput, which is reflected in the mentioned ->cpu_power
variable.

> Perhaps, you mean, e.g., if a RT task ends, the CPU would go idle
> and it would be supposed to pull ? Just we don't do that, and at the next
> load-balancing decision things would be fixed up (please, consider I don't
> know the CFS load balancer so well).

No, what I meant was that if a particular CPU is very busy with !CFS
work, its ->cpu_power variable will decrease to 1 (0 will get us
division by zero issues). Somehow we need to avoid this load-balancer
from thinking its a good idea to place tasks there.

The natural balance is to move tasks away from weak CPUs, but clearly
its not good enough.

Also, there is housekeeping that needs to be done on a per-cpu basis.
CPU affine tasks like workqueue things need to run in order to keep the
system functional, pegging a CPU with a RT task starves these, causing
general system dysfunction.

> So, for example, in addition to fix the reported issue, we'd get also that,
> when pinning a heavy RT workload on a CPU, CFS tasks would migrate to other
> CPUs, if available. Again, that doesn't need to be instantaneous (push), but
> it could happen later when the CFS load-balancer is invoked (is it invoked
> periodically, as of now ?).

That should basically work, we normalize the cpu load (sum of all cfs
task weights) by the ->cpu_power, a weak cpu will tend to get all its
tasks migrated away to stronger CPUs, again, there's probably some
corner case that doesn't quite work as expected.



