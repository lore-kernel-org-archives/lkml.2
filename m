Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755740Ab1CVXJd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 19:09:33 -0400
Received: from smtp-out.google.com ([74.125.121.67]:54995 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755682Ab1CVXJa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 19:09:30 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
	b=jDCtQhfR0Gs/PueAnXgOvaK2WNQ6zVGi9pL98MnWpMpiyy1If1zMo87WPXXlIPnlV
	QXzKmQZD1ZT5lH1sVXmHw==
From: Justin TerAvest <teravest@google.com>
To: vgoyal@redhat.com, jaxboe@fusionio.com
Cc: m-ikeda@ds.jp.nec.com, ryov@valinux.co.jp, taka@valinux.co.jp,
        kamezawa.hiroyu@jp.fujitsu.com, righi.andrea@gmail.com,
        guijianfeng@cn.fujitsu.com, balbir@linux.vnet.ibm.com,
        ctalbott@google.com, linux-kernel@vger.kernel.org,
        Justin TerAvest <teravest@google.com>
Subject: [PATCH v2 8/8] cfq: Don't allow preemption across cgroups
Date: Tue, 22 Mar 2011 16:08:55 -0700
Message-Id: <1300835335-2777-9-git-send-email-teravest@google.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1300835335-2777-1-git-send-email-teravest@google.com>
References: <1300835335-2777-1-git-send-email-teravest@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Previously, a sync queue in can preempt an async queue in another
cgroup. This changes that behavior to disallow such preemption.

Signed-off-by: Justin TerAvest <teravest@google.com>
---
 block/cfq-iosched.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 23caa79..0d0189b 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -3430,6 +3430,9 @@ cfq_should_preempt(struct cfq_data *cfqd, struct cfq_queue *new_cfqq,
 	if (!cfqq)
 		return false;
 
+	if (new_cfqq->cfqg != cfqq->cfqg)
+		return false;
+
 	if (cfq_class_idle(new_cfqq))
 		return false;
 
@@ -3449,9 +3452,6 @@ cfq_should_preempt(struct cfq_data *cfqd, struct cfq_queue *new_cfqq,
 	if (rq_is_sync(rq) && !cfq_cfqq_sync(cfqq))
 		return true;
 
-	if (new_cfqq->cfqg != cfqq->cfqg)
-		return false;
-
 	if (cfq_slice_used(cfqq))
 		return true;
 
-- 
1.7.3.1

