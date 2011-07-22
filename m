Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753882Ab1GVKUK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jul 2011 06:20:10 -0400
Received: from casper.infradead.org ([85.118.1.10]:34809 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753826Ab1GVKUI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jul 2011 06:20:08 -0400
Subject: On migrate_disable() and latencies
From: Peter Zijlstra <peterz@infradead.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Carsten Emde <ce@ceag.ch>,
        Clark Williams <williams@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Kumar Gala <galak@gate.crashing.org>,
        Ralf Baechle <ralf@linux-mips.org>, rostedt <rostedt@goodmis.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 22 Jul 2011 12:19:52 +0200
Message-ID: <1311329992.27400.23.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-07-20 at 02:37 +0200, Thomas Gleixner wrote:
>    - Twist your brain around the schedulability impact of the
>      migrate_disable() approach.
> 
>      A really interesting research topic for our friends from the
>      academic universe. Relevant and conclusive (even short notice)
>      papers and/or talks on that topic have a reserved slot in the
>      Kernel developers track at the Realtime Linux Workshop in Prague
>      in October this year. 

>From what I can tell it can induce a latency in the order of
max-migrate-disable-period * nr-cpus.

The scenario is on where you stack N migrate-disable tasks on a run
queue (necessarily of increasing priority). Doing this requires all cpus
in the system to be as busy, for otherwise the task would simply be
moved to another cpu.

Anyway, once you manage to stack these migrate-disable tasks, all other
tasks go to sleep, leaving a vacuum. Normally we would migrate tasks to
fill the vacuum left by the tasks going to sleep, but clearly
migrate-disable prohibits this.

So we have this stack of migrate-disable tasks and M-1 idle cpus (loss
of utilization). Now it takes the length of the migrate-disable region
of the highest priority task on the stack (the one running) to complete
and enable migration again. This will instantly move the task away to an
idle cpu. This will then need to happen min(N-1, M-1) times before the
lowest priority migrate_disable task can run again or all cpus are busy.

Therefore the worst case latency is in the order of
max-migrate-disable-period * nr-cpus.

Currently we have no means of measuring these latencies, this is
something we need to grow, I think Steven can fairly easy craft a
migrate_disable runtime tracer -- it needs to use t->se.sum_exec_runtime
for measure so as to only count the actual time spend on the task and
ignore any time it was blocked.

Once we have this, its back to the old game of 'lock'-breaking.


