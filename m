Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932735Ab1ISV0s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Sep 2011 17:26:48 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:40197 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932284Ab1ISV0n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Sep 2011 17:26:43 -0400
X-Authority-Analysis: v=1.1 cv=lfM0d0QHaVz67dfwwr9cyIw6NbaGR/pZhMD6XWNi0kk= c=1 sm=0 a=vhdKIqpQuCYA:10 a=Jhh6sXEt9w0A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=17wjrS5wAhQaEczCPkpxpQ==:17 a=NV_8UQkdWAwnLpXvGecA:9 a=1VItCKZcEaXJuO_Ma5AA:7 a=17wjrS5wAhQaEczCPkpxpQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.83.30
Message-Id: <20110919212040.745370781@goodmis.org>
User-Agent: quilt/0.48-1
Date: Mon, 19 Sep 2011 17:20:40 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Christoph Lameter <cl@linux.com>
Subject: [RFC][PATCH 0/5] Introduce checks for preemptable code for this_cpu_read/write()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I just found out that the this_cpu_*() functions do not perform the
test to see if the usage is in atomic or not. Thus, the blind
conversion of the per_cpu(*, smp_processor_id()) and the get_cpu_var()
code to this_cpu_*() introduce the regression to detect the hard
to find case where a per cpu variable is used in preempt code that
migrates and causes bugs.

I'm adding back a simple call to smp_processor_id() to
this_cpu_read() and this_cpu_write() to see what errors I find.
I found 4 places that required touch up. 3 were areas that the race
is known and we don't care, but the memcg looks very buggy.

Anyway, if I had known that the this_cpu_*() code removed this
smp_processor_id() check, I would have NAK'd all the changes to the tracing
code.

I only modified this_cpu_read and *_write() I may decide other this_cpu_*
code should be updated too. Especially the ones that return a value.

-- Steve

Steven Rostedt (5):
      x86: Remove const_udelay() caring about which cpu var it uses
      mm: Switch mod_state() to __this_cpu_read()
      memcg: Disable preemption in memcg_check_events()
      printk: Have wake_up_klogd() use __this_cpu_write()
      percpu: Add preempt checks back into this_cpu_read/write()

----
 arch/x86/lib/delay.c   |    2 +-
 include/linux/percpu.h |   17 +++++++++++++++--
 kernel/printk.c        |    2 +-
 mm/memcontrol.c        |    2 ++
 mm/vmstat.c            |    4 ++--
 5 files changed, 21 insertions(+), 6 deletions(-)
