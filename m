Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755702Ab1HRLvv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 07:51:51 -0400
Received: from smtp.eu.citrix.com ([62.200.22.115]:4603 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755535Ab1HRLvt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 07:51:49 -0400
X-IronPort-AV: E=Sophos;i="4.68,245,1312156800"; 
   d="scan'208";a="7334327"
Subject: how to handle tracing .h loops
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>
CC: <linux-kernel@vger.kernel.org>
Content-Type: multipart/mixed; boundary="=-aWvhExpabIMy4+5rIWEv"
Organization: Citrix Systems, Inc.
Date: Thu, 18 Aug 2011 12:51:47 +0100
Message-ID: <1313668307.5010.300.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
X-Mailer: Evolution 2.32.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-aWvhExpabIMy4+5rIWEv
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit

Hi,

I'm working on a patch which needs to add a #include <linux/highmem.h>
to <linux/skbuff.h>. This is causing a bunch of fallout in the trace
headers which I can't figure out the right solution to. Simplifying the
patch to just:

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 7b996ed..3f5ee74 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -29,6 +29,7 @@
 #include <linux/rcupdate.h>
 #include <linux/dmaengine.h>
 #include <linux/hrtimer.h>
+#include <linux/highmem.h>
 
 /* Don't change this without changing skb_csum_unnecessary! */
 #define CHECKSUM_NONE 0

reproduces on an i386 defconfig (v3.1-rc2). (actually just including
interrupt.h is sufficient too).

The spew is:

In file included from include/trace/ftrace.h:296:0,
                 from include/trace/define_trace.h:96,
                 from include/trace/events/irq.h:150,
                 from include/linux/interrupt.h:23,
                 from arch/x86/include/asm/highmem.h:23,
                 from include/linux/highmem.h:33,
                 from include/linux/skbuff.h:32,
                 from kernel/audit.h:24,
                 from kernel/signal.c:38:
include/trace/events/irq.h: In function 'ftrace_raw_output_softirq':
include/trace/events/irq.h:87:1: error: 'HI_SOFTIRQ' undeclared (first use in this function)
include/trace/events/irq.h:87:1: note: each undeclared identifier is reported only once for each function it appears in
include/trace/events/irq.h:87:1: error: 'TIMER_SOFTIRQ' undeclared (first use in this function)
include/trace/events/irq.h:87:1: error: 'NET_TX_SOFTIRQ' undeclared (first use in this function)
include/trace/events/irq.h:87:1: error: 'NET_RX_SOFTIRQ' undeclared (first use in this function)
include/trace/events/irq.h:87:1: error: 'BLOCK_SOFTIRQ' undeclared (first use in this function)
include/trace/events/irq.h:87:1: error: 'BLOCK_IOPOLL_SOFTIRQ' undeclared (first use in this function)
include/trace/events/irq.h:87:1: error: 'TASKLET_SOFTIRQ' undeclared (first use in this function)
include/trace/events/irq.h:87:1: error: 'SCHED_SOFTIRQ' undeclared (first use in this function)
include/trace/events/irq.h:87:1: error: 'HRTIMER_SOFTIRQ' undeclared (first use in this function)
include/trace/events/irq.h:87:1: error: 'RCU_SOFTIRQ' undeclared (first use in this function)

There are more following that but I suspect they are just secondary
fallout so I've omitted them in the interests of brevity. Full log is
attached.

The reason I can't see a solution is that it seems to be that
trace/events/irq.h in included in linux/interrupt.h before the
definition of the enum with all those values in it.

I looked in tip.git#perf/core (and master) but I can't see anything
which relates to this issue.

Clearly other places are including interrupt.h and highmem.h without
issue so what am I doing wrong here?

Thanks,
Ian.

--=-aWvhExpabIMy4+5rIWEv
Content-Type: application/octet-stream; name="log"
Content-Disposition: attachment; filename="log"
Content-Transfer-Encoding: 7bit

command line branch is net-skb-frag-lifecycle
building a i386/native kernel (suffix -native)
Adding /usr/lib/ccache to $PATH
output directory is ../linux-2.6-build-net-skb-frag-lifecycle-i386-native
+ make O=../linux-2.6-build-net-skb-frag-lifecycle-i386-native ARCH=i386 CROSS_COMPILE=/home/ianc/devel/cross/gcc-4.6.0-nolibc/i386-linux/bin/i386-linux- -j12 -s kernel/signal.o
]0;/home/ianc/devel/kernels/linux-2.6: make O=../linux-2.6-build-net-skb-frag-lifecycle-i386-native ARCH=i386 CROSS_COMPILE=/home/ianc/devel/cross/gcc-4.6.0-nolibc/i386-linux/bin/i386-linux- -j12 -s kernel/signal.oIn file included from /local/scratch/ianc/devel/kernels/linux-2.6/include/trace/ftrace.h:296:0,
                 from /local/scratch/ianc/devel/kernels/linux-2.6/include/trace/define_trace.h:96,
                 from /local/scratch/ianc/devel/kernels/linux-2.6/include/trace/events/irq.h:150,
                 from /local/scratch/ianc/devel/kernels/linux-2.6/include/linux/interrupt.h:23,
                 from /local/scratch/ianc/devel/kernels/linux-2.6/arch/x86/include/asm/highmem.h:23,
                 from /local/scratch/ianc/devel/kernels/linux-2.6/include/linux/highmem.h:33,
                 from /local/scratch/ianc/devel/kernels/linux-2.6/include/linux/skbuff.h:32,
                 from /local/scratch/ianc/devel/kernels/linux-2.6/kernel/audit.h:24,
                 from /local/scratch/ianc/devel/kernels/linux-2.6/kernel/signal.c:38:
/local/scratch/ianc/devel/kernels/linux-2.6/include/trace/events/irq.h: In function 'ftrace_raw_output_softirq':
/local/scratch/ianc/devel/kernels/linux-2.6/include/trace/events/irq.h:87:1: error: 'HI_SOFTIRQ' undeclared (first use in this function)
/local/scratch/ianc/devel/kernels/linux-2.6/include/trace/events/irq.h:87:1: note: each undeclared identifier is reported only once for each function it appears in
/local/scratch/ianc/devel/kernels/linux-2.6/include/trace/events/irq.h:87:1: error: 'TIMER_SOFTIRQ' undeclared (first use in this function)
/local/scratch/ianc/devel/kernels/linux-2.6/include/trace/events/irq.h:87:1: error: 'NET_TX_SOFTIRQ' undeclared (first use in this function)
/local/scratch/ianc/devel/kernels/linux-2.6/include/trace/events/irq.h:87:1: error: 'NET_RX_SOFTIRQ' undeclared (first use in this function)
/local/scratch/ianc/devel/kernels/linux-2.6/include/trace/events/irq.h:87:1: error: 'BLOCK_SOFTIRQ' undeclared (first use in this function)
/local/scratch/ianc/devel/kernels/linux-2.6/include/trace/events/irq.h:87:1: error: 'BLOCK_IOPOLL_SOFTIRQ' undeclared (first use in this function)
/local/scratch/ianc/devel/kernels/linux-2.6/include/trace/events/irq.h:87:1: error: 'TASKLET_SOFTIRQ' undeclared (first use in this function)
/local/scratch/ianc/devel/kernels/linux-2.6/include/trace/events/irq.h:87:1: error: 'SCHED_SOFTIRQ' undeclared (first use in this function)
/local/scratch/ianc/devel/kernels/linux-2.6/include/trace/events/irq.h:87:1: error: 'HRTIMER_SOFTIRQ' undeclared (first use in this function)
/local/scratch/ianc/devel/kernels/linux-2.6/include/trace/events/irq.h:87:1: error: 'RCU_SOFTIRQ' undeclared (first use in this function)
In file included from /local/scratch/ianc/devel/kernels/linux-2.6/include/trace/ftrace.h:404:0,
                 from /local/scratch/ianc/devel/kernels/linux-2.6/include/trace/define_trace.h:96,
                 from /local/scratch/ianc/devel/kernels/linux-2.6/include/trace/events/irq.h:150,
                 from /local/scratch/ianc/devel/kernels/linux-2.6/include/linux/interrupt.h:23,
                 from /local/scratch/ianc/devel/kernels/linux-2.6/arch/x86/include/asm/highmem.h:23,
                 from /local/scratch/ianc/devel/kernels/linux-2.6/include/linux/highmem.h:33,
                 from /local/scratch/ianc/devel/kernels/linux-2.6/include/linux/skbuff.h:32,
                 from /local/scratch/ianc/devel/kernels/linux-2.6/kernel/audit.h:24,
                 from /local/scratch/ianc/devel/kernels/linux-2.6/kernel/signal.c:38:
/local/scratch/ianc/devel/kernels/linux-2.6/include/trace/events/irq.h: In function 'ftrace_get_offsets_irq_handler_entry':
/local/scratch/ianc/devel/kernels/linux-2.6/include/trace/events/irq.h:37:1: error: dereferencing pointer to incomplete type
/local/scratch/ianc/devel/kernels/linux-2.6/include/trace/events/irq.h:37:1: error: request for member 'name' in something not a structure or union
/local/scratch/ianc/devel/kernels/linux-2.6/include/trace/events/irq.h:54:1: warning: passing argument 1 of 'strlen' from incompatible pointer type [enabled by default]
/local/scratch/ianc/devel/kernels/linux-2.6/arch/x86/include/asm/string_32.h:30:15: note: expected 'const char *' but argument is of type 'const struct trace_print_flags *'
/local/scratch/ianc/devel/kernels/linux-2.6/include/trace/events/irq.h:37:1: error: dereferencing pointer to incomplete type
/local/scratch/ianc/devel/kernels/linux-2.6/include/trace/events/irq.h:37:1: error: request for member 'name' in something not a structure or union
/local/scratch/ianc/devel/kernels/linux-2.6/include/trace/events/irq.h:54:1: warning: passing argument 1 of 'strlen' from incompatible pointer type [enabled by default]
/local/scratch/ianc/devel/kernels/linux-2.6/arch/x86/include/asm/string_32.h:30:15: note: expected 'const char *' but argument is of type 'const struct trace_print_flags *'
In file included from /local/scratch/ianc/devel/kernels/linux-2.6/include/trace/ftrace.h:567:0,
                 from /local/scratch/ianc/devel/kernels/linux-2.6/include/trace/define_trace.h:96,
                 from /local/scratch/ianc/devel/kernels/linux-2.6/include/trace/events/irq.h:150,
                 from /local/scratch/ianc/devel/kernels/linux-2.6/include/linux/interrupt.h:23,
                 from /local/scratch/ianc/devel/kernels/linux-2.6/arch/x86/include/asm/highmem.h:23,
                 from /local/scratch/ianc/devel/kernels/linux-2.6/include/linux/highmem.h:33,
                 from /local/scratch/ianc/devel/kernels/linux-2.6/include/linux/skbuff.h:32,
                 from /local/scratch/ianc/devel/kernels/linux-2.6/kernel/audit.h:24,
                 from /local/scratch/ianc/devel/kernels/linux-2.6/kernel/signal.c:38:
/local/scratch/ianc/devel/kernels/linux-2.6/include/trace/events/irq.h: In function 'ftrace_raw_event_irq_handler_entry':
/local/scratch/ianc/devel/kernels/linux-2.6/include/trace/events/irq.h:37:1: error: dereferencing pointer to incomplete type
/local/scratch/ianc/devel/kernels/linux-2.6/include/trace/events/irq.h:37:1: error: request for member 'name' in something not a structure or union
/local/scratch/ianc/devel/kernels/linux-2.6/include/trace/events/irq.h:37:1: warning: passing argument 2 of 'strcpy' from incompatible pointer type [enabled by default]
/local/scratch/ianc/devel/kernels/linux-2.6/arch/x86/include/asm/string_32.h:9:14: note: expected 'const char *' but argument is of type 'const struct trace_print_flags *'
In file included from /local/scratch/ianc/devel/kernels/linux-2.6/include/trace/ftrace.h:771:0,
                 from /local/scratch/ianc/devel/kernels/linux-2.6/include/trace/define_trace.h:96,
                 from /local/scratch/ianc/devel/kernels/linux-2.6/include/trace/events/irq.h:150,
                 from /local/scratch/ianc/devel/kernels/linux-2.6/include/linux/interrupt.h:23,
                 from /local/scratch/ianc/devel/kernels/linux-2.6/arch/x86/include/asm/highmem.h:23,
                 from /local/scratch/ianc/devel/kernels/linux-2.6/include/linux/highmem.h:33,
                 from /local/scratch/ianc/devel/kernels/linux-2.6/include/linux/skbuff.h:32,
                 from /local/scratch/ianc/devel/kernels/linux-2.6/kernel/audit.h:24,
                 from /local/scratch/ianc/devel/kernels/linux-2.6/kernel/signal.c:38:
/local/scratch/ianc/devel/kernels/linux-2.6/include/trace/events/irq.h: In function 'perf_trace_irq_handler_entry':
/local/scratch/ianc/devel/kernels/linux-2.6/include/trace/events/irq.h:37:1: error: dereferencing pointer to incomplete type
/local/scratch/ianc/devel/kernels/linux-2.6/include/trace/events/irq.h:37:1: error: request for member 'name' in something not a structure or union
/local/scratch/ianc/devel/kernels/linux-2.6/include/trace/events/irq.h:54:1: warning: passing argument 2 of 'strcpy' from incompatible pointer type [enabled by default]
/local/scratch/ianc/devel/kernels/linux-2.6/arch/x86/include/asm/string_32.h:9:14: note: expected 'const char *' but argument is of type 'const struct trace_print_flags *'
make[2]: *** [kernel/signal.o] Error 1
make[1]: *** [kernel/signal.o] Error 2
make: *** [sub-make] Error 2
E: failed: make O=../linux-2.6-build-net-skb-frag-lifecycle-i386-native ARCH=i386 CROSS_COMPILE=/home/ianc/devel/cross/gcc-4.6.0-nolibc/i386-linux/bin/i386-linux- -j12 -s kernel/signal.o

--=-aWvhExpabIMy4+5rIWEv--
