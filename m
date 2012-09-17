Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932596Ab2IQXD4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 19:03:56 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:42372 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754975Ab2IQXDy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 19:03:54 -0400
From: Daniel Vetter <daniel.vetter@ffwll.ch>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
        DRI Development <dri-devel@lists.freedesktop.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Dave Airlie <airlied@gmail.com>, Thomas Gleixner <tglx@linutronix.de>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 1/2] [RESEND] console: use might_sleep in console_lock
Date: Tue, 18 Sep 2012 01:03:31 +0200
Message-Id: <1347923013-4253-1-git-send-email-daniel.vetter@ffwll.ch>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of BUG_ON(in_interrupt()), since that doesn't check for all
the newfangled stuff like preempt.

Note that this is valid since the console_sem is essentially used like
a real mutex with only two twists:
- we allow trylock from hardirq context
- across suspend/resume we lock the logical console_lock, but drop the
  semaphore protecting the locking state.

Now that doesn't guarantee that no one is playing tricks in
single-thread atomic contexts at suspend/resume/boot time, but
- I couldn't find anything suspicious with some grepping,
- might_sleep shouldn't die,
- and I think the upside of catching more potential issues is worth
  the risk of getting a might_sleep backtrace that would have been
  save (and then dealing with that fallout).

Cc: Dave Airlie <airlied@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
---
 kernel/printk.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/printk.c b/kernel/printk.c
index 66a2ea3..ed9af6a 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -1909,7 +1909,8 @@ static int __cpuinit console_cpu_notify(struct notifier_block *self,
  */
 void console_lock(void)
 {
-	BUG_ON(in_interrupt());
+	might_sleep();
+
 	down(&console_sem);
 	if (console_suspended)
 		return;
-- 
1.7.10.4

