Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751905Ab1LROGZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Dec 2011 09:06:25 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:63373 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751736Ab1LROGX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Dec 2011 09:06:23 -0500
From: Marek Vasut <marek.vasut@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, Marek Vasut <marek.vasut@gmail.com>,
        Wolfgang Denk <wd@denx.de>, Stefano Babic <sbabic@denx.de>,
        Shawn Guo <shawn.guo@linaro.org>, Huang Shijie <b32955@freescale.com>,
        Sascha Hauer <s.hauer@pengutronix.de>
Subject: [PATCH] MXS: Convert mutexes in clock.c to spinlocks
Date: Sun, 18 Dec 2011 15:06:13 +0100
Message-Id: <1324217174-6574-1-git-send-email-marek.vasut@gmail.com>
X-Mailer: git-send-email 1.7.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The mutexes can't be safely used under certain circumstances. I noticed this
issue during some network instability at home:

1) I received information about duplicate ipv6 address
2) I use amba-pl011 driver for console output

Backtrace produced (not 80-per-line aligned):

eth0: IPv6 duplicate address XXXX::YYYY:ZZZZ:WWWW:0 detected!
------------[ cut here ]------------
WARNING: at kernel/mutex.c:198 mutex_lock_nested+0x284/0x2c0()
Modules linked in:
[<c0013ab8>] (unwind_backtrace+0x0/0xf0) from [<c001d934>] (warn_slowpath_common+0x4c/0x64)
[<c001d934>] (warn_slowpath_common+0x4c/0x64) from [<c001d968>] (warn_slowpath_null+0x1c/0x24)
[<c001d968>] (warn_slowpath_null+0x1c/0x24) from [<c033a4f4>] (mutex_lock_nested+0x284/0x2c0)
[<c033a4f4>] (mutex_lock_nested+0x284/0x2c0) from [<c0017d88>] (clk_enable+0x20/0x48)
[<c0017d88>] (clk_enable+0x20/0x48) from [<c01dfbf0>] (pl011_console_write+0x20/0x74)
[<c01dfbf0>] (pl011_console_write+0x20/0x74) from [<c001da98>] (__call_console_drivers+0x7c/0x94)
[<c001da98>] (__call_console_drivers+0x7c/0x94) from [<c001df20>] (console_unlock+0xf8/0x244)
[<c001df20>] (console_unlock+0xf8/0x244) from [<c001e308>] (vprintk+0x29c/0x484)
[<c001e308>] (vprintk+0x29c/0x484) from [<c03355a8>] (printk+0x20/0x30)
[<c03355a8>] (printk+0x20/0x30) from [<c02df600>] (addrconf_dad_failure+0x148/0x158)
[<c02df600>] (addrconf_dad_failure+0x148/0x158) from [<c02ebde0>] (ndisc_rcv+0xb38/0xdb0)
[<c02ebde0>] (ndisc_rcv+0xb38/0xdb0) from [<c02f1b28>] (icmpv6_rcv+0x6ec/0x9c4)
[<c02f1b28>] (icmpv6_rcv+0x6ec/0x9c4) from [<c02da9a4>] (ip6_input_finish+0x144/0x4e0)
[<c02da9a4>] (ip6_input_finish+0x144/0x4e0) from [<c02db424>] (ip6_mc_input+0xb8/0x154)
[<c02db424>] (ip6_mc_input+0xb8/0x154) from [<c02db12c>] (ipv6_rcv+0x300/0x53c)
[<c02db12c>] (ipv6_rcv+0x300/0x53c) from [<c0267b78>] (__netif_receive_skb+0x240/0x420)
[<c0267b78>] (__netif_receive_skb+0x240/0x420) from [<c0267de8>] (process_backlog+0x90/0x150)
[<c0267de8>] (process_backlog+0x90/0x150) from [<c026a5f8>] (net_rx_action+0xc0/0x264)
[<c026a5f8>] (net_rx_action+0xc0/0x264) from [<c0023cfc>] (__do_softirq+0xa8/0x214)
[<c0023cfc>] (__do_softirq+0xa8/0x214) from [<c00242c0>] (irq_exit+0x8c/0x94)
[<c00242c0>] (irq_exit+0x8c/0x94) from [<c000f6d0>] (handle_IRQ+0x34/0x84)
[<c000f6d0>] (handle_IRQ+0x34/0x84) from [<c000e5d8>] (__irq_usr+0x38/0x80)
---[ end trace 32eab6a8dcdca9c0 ]---

So the problem summary:
1) ICMPv6 packet is received
2) Interrupt is produced, packet is actually received
3) Packet processing goes on (in tasklet)
4) Duplicate ipv6 address detected, warning produced
5) printk() called, calls pl011_console_write()
6) pl011_console_write() calls clk_enable()
7) clk_enable() for mxs does a mutex_lock(), which is wrong in this context

Signed-off-by: Marek Vasut <marek.vasut@gmail.com>
Cc: Wolfgang Denk <wd@denx.de>
Cc: Stefano Babic <sbabic@denx.de>
Cc: Shawn Guo <shawn.guo@linaro.org>
Cc: Huang Shijie <b32955@freescale.com>
Cc: Sascha Hauer <s.hauer@pengutronix.de>
---
 arch/arm/mach-mxs/clock.c |   25 +++++++++++++++----------
 1 files changed, 15 insertions(+), 10 deletions(-)

diff --git a/arch/arm/mach-mxs/clock.c b/arch/arm/mach-mxs/clock.c
index a7093c8..677ecff 100644
--- a/arch/arm/mach-mxs/clock.c
+++ b/arch/arm/mach-mxs/clock.c
@@ -32,7 +32,7 @@
 #include <linux/kernel.h>
 #include <linux/list.h>
 #include <linux/module.h>
-#include <linux/mutex.h>
+#include <linux/spinlock.h>
 #include <linux/platform_device.h>
 #include <linux/proc_fs.h>
 #include <linux/semaphore.h>
@@ -41,7 +41,7 @@
 #include <mach/clock.h>
 
 static LIST_HEAD(clocks);
-static DEFINE_MUTEX(clocks_mutex);
+static DEFINE_SPINLOCK(clocks_lock);
 
 /*-------------------------------------------------------------------------
  * Standard clock functions defined in include/linux/clk.h
@@ -80,13 +80,14 @@ static int __clk_enable(struct clk *clk)
 int clk_enable(struct clk *clk)
 {
 	int ret = 0;
+	unsigned long flags;
 
 	if (clk == NULL || IS_ERR(clk))
 		return -EINVAL;
 
-	mutex_lock(&clocks_mutex);
+	spin_lock_irqsave(&clocks_lock, flags);
 	ret = __clk_enable(clk);
-	mutex_unlock(&clocks_mutex);
+	spin_unlock_irqrestore(&clocks_lock, flags);
 
 	return ret;
 }
@@ -98,12 +99,14 @@ EXPORT_SYMBOL(clk_enable);
  */
 void clk_disable(struct clk *clk)
 {
+	unsigned long flags;
+
 	if (clk == NULL || IS_ERR(clk))
 		return;
 
-	mutex_lock(&clocks_mutex);
+	spin_lock_irqsave(&clocks_lock, flags);
 	__clk_disable(clk);
-	mutex_unlock(&clocks_mutex);
+	spin_unlock_irqrestore(&clocks_lock, flags);
 }
 EXPORT_SYMBOL(clk_disable);
 
@@ -142,14 +145,15 @@ EXPORT_SYMBOL(clk_round_rate);
  */
 int clk_set_rate(struct clk *clk, unsigned long rate)
 {
+	unsigned long flags;
 	int ret = -EINVAL;
 
 	if (clk == NULL || IS_ERR(clk) || clk->set_rate == NULL || rate == 0)
 		return ret;
 
-	mutex_lock(&clocks_mutex);
+	spin_lock_irqsave(&clocks_lock, flags);
 	ret = clk->set_rate(clk, rate);
-	mutex_unlock(&clocks_mutex);
+	spin_unlock_irqrestore(&clocks_lock, flags);
 
 	return ret;
 }
@@ -160,6 +164,7 @@ int clk_set_parent(struct clk *clk, struct clk *parent)
 {
 	int ret = -EINVAL;
 	struct clk *old;
+	unsigned long flags;
 
 	if (clk == NULL || IS_ERR(clk) || parent == NULL ||
 	    IS_ERR(parent) || clk->set_parent == NULL)
@@ -168,7 +173,7 @@ int clk_set_parent(struct clk *clk, struct clk *parent)
 	if (clk->usecount)
 		clk_enable(parent);
 
-	mutex_lock(&clocks_mutex);
+	spin_lock_irqsave(&clocks_lock, flags);
 	ret = clk->set_parent(clk, parent);
 	if (ret == 0) {
 		old = clk->parent;
@@ -176,7 +181,7 @@ int clk_set_parent(struct clk *clk, struct clk *parent)
 	} else {
 		old = parent;
 	}
-	mutex_unlock(&clocks_mutex);
+	spin_unlock_irqrestore(&clocks_lock, flags);
 
 	if (clk->usecount)
 		clk_disable(old);
-- 
1.7.6.4

