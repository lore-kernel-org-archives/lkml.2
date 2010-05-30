Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751824Ab0E3Huh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 May 2010 03:50:37 -0400
Received: from [69.28.251.93] ([69.28.251.93]:44038 "EHLO b32.net"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751609Ab0E3Hub (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 May 2010 03:50:31 -0400
From: Kevin Cernekee <cernekee@gmail.com>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: <linux-mips@linux-mips.org>, <linux-kernel@vger.kernel.org>
Date: Sun, 30 May 2010 00:35:58 -0700
Subject: [PATCH 2/2] MIPS: Fix deferred console messages during CPU hotplug
Message-Id: <526fcbfa605500d9da9b04ac0f93ef2beddca6ed@localhost.localdomain>
In-Reply-To: <1b31306f28573a4bee56f164b1f74962fced9bc5@localhost.localdomain>
References: <1b31306f28573a4bee56f164b1f74962fced9bc5@localhost.localdomain>
User-Agent: vim 7.2
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When a secondary CPU is booting up in start_secondary(), cpu_probe() and
calibrate_delay() are called while cpu_online(smp_processor_id()) == 0.
This means that can_use_console() will return 0 on many systems:

static inline int can_use_console(unsigned int cpu)
{
	return cpu_online(cpu) || have_callable_console();
}

If (can_use_console() == 0), printk() will spool its output to log_buf
and it will be visible in "dmesg", but that output will NOT be echoed to
the console until somebody calls release_console_sem() from a CPU that
is online.  Effectively this means that the cpu_probe() and
calibrate_delay() messages will sit in limbo, and will only get dumped
to the screen the next time printk() happens to get called.

At boot time, more printk() messages are invariably generated after SMP
initialization as the kernel boot proceeds, so this problem is unlikely
to be noticed.  But when using the CPU hotplug feature to reactivate a
dormant processor, the new CPU's boot messages could be stuck in limbo
for quite a while since nothing is necessarily printed to the kernel log
afterward.

The proposed workaround is to acquire and release console_sem from
__cpu_up(), so any queued messages can be flushed out to the console by
a CPU that is definitely known to be online.

This issue was seen on 2.6.34.

Signed-off-by: Kevin Cernekee <cernekee@gmail.com>
---
 arch/mips/kernel/smp.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/arch/mips/kernel/smp.c b/arch/mips/kernel/smp.c
index 6cdca19..bf8923f 100644
--- a/arch/mips/kernel/smp.c
+++ b/arch/mips/kernel/smp.c
@@ -33,6 +33,7 @@
 #include <linux/cpu.h>
 #include <linux/err.h>
 #include <linux/ftrace.h>
+#include <linux/console.h>
 
 #include <asm/atomic.h>
 #include <asm/cpu.h>
@@ -219,6 +220,10 @@ int __cpuinit __cpu_up(unsigned int cpu)
 
 	cpu_set(cpu, cpu_online_map);
 
+	/* Flush out any buffered log messages from the new CPU */
+	if (try_acquire_console_sem() == 0)
+		release_console_sem();
+
 	return 0;
 }
 
-- 
1.7.0.4

