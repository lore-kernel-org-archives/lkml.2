Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756073Ab2JTQa2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Oct 2012 12:30:28 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:64209 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755920Ab2JTQaZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Oct 2012 12:30:25 -0400
From: Joonsoo Kim <js1304@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, Joonsoo Kim <js1304@gmail.com>
Subject: [PATCH 1/3] workqueue: optimize mod_delayed_work_on() when @delay == 0
Date: Sun, 21 Oct 2012 01:30:05 +0900
Message-Id: <1350750607-2051-2-git-send-email-js1304@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1350750607-2051-1-git-send-email-js1304@gmail.com>
References: <Yes>
 <1350750607-2051-1-git-send-email-js1304@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After try_to_grab_pending(), __queue_delayed_work() is invoked
in mod_delayed_work_on(). When @delay == 0, we can call __queue_work()
directly in order to avoid setting useless timer.

Signed-off-by: Joonsoo Kim <js1304@gmail.com>

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index d951daa..c57358e 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -1477,7 +1477,11 @@ bool mod_delayed_work_on(int cpu, struct workqueue_struct *wq,
 	} while (unlikely(ret == -EAGAIN));
 
 	if (likely(ret >= 0)) {
-		__queue_delayed_work(cpu, wq, dwork, delay);
+		if (!delay)
+			__queue_work(cpu, wq, &dwork->work);
+		else
+			__queue_delayed_work(cpu, wq, dwork, delay);
+
 		local_irq_restore(flags);
 	}
 
-- 
1.7.9.5

