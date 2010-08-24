Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754292Ab0HXHAO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 03:00:14 -0400
Received: from mail.windriver.com ([147.11.1.11]:42951 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754231Ab0HXHAJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 03:00:09 -0400
From: Yong Zhang <yong.zhang0@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de, akpm@linux-foundation.org, mingo@elte.hu,
        peterz@infradead.org, oleg@redhat.com
Subject: [RFC PATCH 3/3] timer: warn when del_timer_sync() used in hardirq context
Date: Tue, 24 Aug 2010 14:58:49 +0800
Message-Id: <1282633129-9187-4-git-send-email-yong.zhang0@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1282633129-9187-1-git-send-email-yong.zhang0@gmail.com>
References: <1282633129-9187-1-git-send-email-yong.zhang0@gmail.com>
X-OriginalArrivalTime: 24 Aug 2010 06:59:00.0636 (UTC) FILETIME=[D47DDDC0:01CB4359]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yong Zhang <yong.zhang@windriver.com>

Add explict warning to prevent del_timer_sync() from using
in hardirq context.

Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>
---
 kernel/timer.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/kernel/timer.c b/kernel/timer.c
index 08c9559..1bc4b4a 100644
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -996,7 +996,11 @@ int del_timer_sync(struct timer_list *timer)
 	lock_map_release(&timer->lockdep_map);
 	local_bh_enable();
 #endif
-
+	/*
+	 * don't use it in hardirq context, because it
+	 * could lead to deadlock.
+	 */
+	WARN_ON(in_irq());
 	for (;;) {
 		int ret = try_to_del_timer_sync(timer);
 		if (ret >= 0)
-- 
1.7.0.4

