Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754101Ab1JPK5Y (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Oct 2011 06:57:24 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:64860 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754027Ab1JPK5V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Oct 2011 06:57:21 -0400
From: Yong Zhang <yong.zhang0@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: linux-rt-users@vger.kernel.org, tglx@linutronix.de
Subject: [RFC] [PATCH -rt 3/5] printk: don't call printk_tick in printk_needs_cpu()
Date: Sun, 16 Oct 2011 18:56:45 +0800
Message-Id: <1318762607-2261-4-git-send-email-yong.zhang0@gmail.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1318762607-2261-1-git-send-email-yong.zhang0@gmail.com>
References: <1318762607-2261-1-git-send-email-yong.zhang0@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

printk_tick() can't be called in atomic context, otherwise below
warning will show:

[  117.597095] BUG: sleeping function called from invalid context at kernel/rtmutex.c:645
[  117.597102] in_atomic(): 1, irqs_disabled(): 1, pid: 0, name: kworker/0:0
[  117.597111] Pid: 0, comm: kworker/0:0 Not tainted 3.0.6-rt17-00284-gb76d419-dirty #7
[  117.597116] Call Trace:
[  117.597131]  [<c06e3b61>] ? printk+0x1d/0x24
[  117.597142]  [<c01390b6>] __might_sleep+0xe6/0x110
[  117.597151]  [<c06e634c>] rt_spin_lock+0x1c/0x30
[  117.597158]  [<c0142f26>] __wake_up+0x26/0x60
[  117.597166]  [<c014c78e>] printk_tick+0x3e/0x40
[  117.597173]  [<c014c7b4>] printk_needs_cpu+0x24/0x30
[  117.597181]  [<c017ecc8>] tick_nohz_stop_sched_tick+0x2e8/0x410
[  117.597191]  [<c017305a>] ? sched_clock_idle_wakeup_event+0x1a/0x20
[  117.597201]  [<c010182a>] cpu_idle+0x4a/0xb0
[  117.597209]  [<c06e0b97>] start_secondary+0xd3/0xd7

Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>
---
 kernel/printk.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/printk.c b/kernel/printk.c
index 0c9a0ab..a50af4e 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -1282,8 +1282,8 @@ void printk_tick(void)
 
 int printk_needs_cpu(int cpu)
 {
-	if (cpu_is_offline(cpu))
-		printk_tick();
+	if (unlikely(cpu_is_offline(cpu)))
+		__this_cpu_write(printk_pending, 0);
 	return __this_cpu_read(printk_pending);
 }
 
-- 
1.7.1

