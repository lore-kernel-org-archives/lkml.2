Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752754Ab2HMQTr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 12:19:47 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:63093 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752526Ab2HMQTo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 12:19:44 -0400
From: Joonsoo Kim <js1304@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, Joonsoo Kim <js1304@gmail.com>
Subject: [PATCH 5/5] workqueue: use system_highpri_wq for unbind_work
Date: Tue, 14 Aug 2012 01:17:52 +0900
Message-Id: <1344874672-6257-5-git-send-email-js1304@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1344874672-6257-1-git-send-email-js1304@gmail.com>
References: <Yes>
 <1344874672-6257-1-git-send-email-js1304@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To speed cpu down processing up, use system_highpri_wq.
As scheduling priority of workers on it is higher than system_wq and
it is not contended by other normal works on this cpu, work on it
is processed faster than system_wq.

Signed-off-by: Joonsoo Kim <js1304@gmail.com>

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index e0e1d41..5d50955 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -3501,7 +3501,7 @@ static int __devinit workqueue_cpu_down_callback(struct notifier_block *nfb,
 	case CPU_DOWN_PREPARE:
 		/* unbinding should happen on the local CPU */
 		INIT_WORK_ONSTACK(&unbind_work, gcwq_unbind_fn);
-		schedule_work_on(cpu, &unbind_work);
+		queue_work_on(cpu, system_highpri_wq, &unbind_work);
 		flush_work(&unbind_work);
 		break;
 	}
-- 
1.7.9.5

