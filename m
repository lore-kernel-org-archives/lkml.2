Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753117Ab2HUWfK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 18:35:10 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:37022 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754783Ab2HUWes (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 18:34:48 -0400
From: Daniel Vetter <daniel.vetter@ffwll.ch>
To: LKML <linux-kernel@vger.kernel.org>
Cc: DRI Development <dri-devel@lists.freedesktop.org>,
        linux-fbdev@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Dave Airlie <airlied@gmail.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 1/2] console: use might_sleep in console_lock
Date: Wed, 22 Aug 2012 00:34:31 +0200
Message-Id: <1345588472-4055-2-git-send-email-daniel.vetter@ffwll.ch>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1345588472-4055-1-git-send-email-daniel.vetter@ffwll.ch>
References: <1345588472-4055-1-git-send-email-daniel.vetter@ffwll.ch>
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

