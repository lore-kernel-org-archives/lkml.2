Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755044Ab1EMEw2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 00:52:28 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:39453 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750797Ab1EMEw0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 00:52:26 -0400
Date: Fri, 13 May 2011 14:52:21 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Russell King <rmk@arm.linux.org.uk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        John Stultz <john.stultz@linaro.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@redhat.com>, Ralf Baechle <ralf@linux-mips.org>
Subject: linux-next: build failure after merge of the final tree (arm tree
 related)
Message-Id: <20110513145221.88c3de87.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.24.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

After merging the final tree, today's linux-next build (i386 defconfig)
failed like this:

arch/x86/kernel/i8253.c: In function 'init_pit_clocksource':
arch/x86/kernel/i8253.c:133: error: implicit declaration of function 'clocksource_pit_init'

Caused by commit 3490f584b9ba ("clocksource: convert x86 to generic i8253 clocksource").

I took a punt and added the following patch for today (also attempting to
fix mips as well).

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Fri, 13 May 2011 14:48:36 +1000
Subject: [PATCH] clocksource: fix up for generic i8253 conversions

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 arch/mips/kernel/i8253.c |    3 ++-
 arch/x86/kernel/i8253.c  |    3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/mips/kernel/i8253.c b/arch/mips/kernel/i8253.c
index e4660ba..227373e 100644
--- a/arch/mips/kernel/i8253.c
+++ b/arch/mips/kernel/i8253.c
@@ -10,6 +10,7 @@
 #include <linux/smp.h>
 #include <linux/spinlock.h>
 #include <linux/irq.h>
+#include <linux/clocksource.h>
 
 #include <asm/delay.h>
 #include <asm/i8253.h>
@@ -130,6 +131,6 @@ static int __init init_pit_clocksource(void)
 	if (num_possible_cpus() > 1) /* PIT does not scale! */
 		return 0;
 
-	return clocksource_pit_init();
+	return clocksource_i8253_init();
 }
 arch_initcall(init_pit_clocksource);
diff --git a/arch/x86/kernel/i8253.c b/arch/x86/kernel/i8253.c
index a97aefc..21f121a 100644
--- a/arch/x86/kernel/i8253.c
+++ b/arch/x86/kernel/i8253.c
@@ -11,6 +11,7 @@
 #include <linux/delay.h>
 #include <linux/init.h>
 #include <linux/io.h>
+#include <linux/clocksource.h>
 
 #include <asm/i8253.h>
 #include <asm/hpet.h>
@@ -130,7 +131,7 @@ static int __init init_pit_clocksource(void)
 	    pit_ce.mode != CLOCK_EVT_MODE_PERIODIC)
 		return 0;
 
-	return clocksource_pit_init();
+	return clocksource_i8253_init();
 }
 arch_initcall(init_pit_clocksource);
 
-- 
1.7.5.1

-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/
