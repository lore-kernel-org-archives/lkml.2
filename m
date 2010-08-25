Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753943Ab0HYNqw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Aug 2010 09:46:52 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:40186 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753023Ab0HYNqp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Aug 2010 09:46:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=XpIDJZpamnhBq8cs2GwPyKCidAOOoH895aJTiBv0sDU69NkzkhLaFulauAokfkV0Du
         GTs16RWjUJL91zXjoxknp0KVwpMSrGML0Ndbh+QXMyN+UlOHDeH7pxYmTEQaYHO3zJgG
         2A0RbkfKUVvtiwU0dStgYT9HGUuBw7NTgF1Ms=
From: Yong Zhang <yong.zhang0@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de, akpm@linux-foundation.org, mingo@elte.hu,
        oleg@redhat.com, peterz@infradead.org
Subject: [RFC V2 PATCH 3/3] timer: warn when del_timer_sync() used in hardirq context
Date: Wed, 25 Aug 2010 21:45:59 +0800
Message-Id: <1282743959-5427-4-git-send-email-yong.zhang0@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1282743959-5427-1-git-send-email-yong.zhang0@gmail.com>
References: <1282743959-5427-1-git-send-email-yong.zhang0@gmail.com>
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

