Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756019Ab1KRCTe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 21:19:34 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:59723 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752751Ab1KRCTd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 21:19:33 -0500
From: Yong Zhang <yong.zhang0@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        James Morris <jmorris@namei.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Kevin Cernekee <cernekee@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: [RFC] [PATCH] printk: Don't emit console_cpu_notify() for CPU_DYING
Date: Fri, 18 Nov 2011 10:19:24 +0800
Message-Id: <1321582764-22218-1-git-send-email-yong.zhang0@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When running -rt, I got some warning when doing cpu hotplug,
for details please check:
http://marc.info/?l=linux-kernel&m=132143661616297&w=2

But seems the problem also exists in mainline, a typical
scenario is:

        CPU A                           CPU B

doing printk with console_sem held
                                take_cpu_down();
                                  cpu_notify(CPU_DYING);
                                    console_cpu_notify();
                                      console_lock();
                                        down(&console_sem);
                                          *BANG*
  up(&console_sem);


Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: James Morris <jmorris@namei.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Kevin Cernekee <cernekee@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/printk.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/kernel/printk.c b/kernel/printk.c
index 535bc3b..ba0393e 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -1223,7 +1223,6 @@ static int __cpuinit console_cpu_notify(struct notifier_block *self,
 	switch (action) {
 	case CPU_ONLINE:
 	case CPU_DEAD:
-	case CPU_DYING:
 	case CPU_DOWN_FAILED:
 	case CPU_UP_CANCELED:
 		console_lock();
-- 
1.7.5.4

