Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756077Ab1C3QvL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 12:51:11 -0400
Received: from smtp-out.google.com ([216.239.44.51]:17309 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756050Ab1C3QvI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 12:51:08 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
	b=yZvdZVmfUxW0h/Uc/MzD1mJSYvsyW3p3ltS/cZ88uXkfyoyPGeRS7i8fV2p59Toya
	eHYtLz1vvNmmM0s+I+Low==
From: Justin TerAvest <teravest@google.com>
To: vgoyal@redhat.com
Cc: jaxboe@fusionio.com, m-ikeda@ds.jp.nec.com, ryov@valinux.co.jp,
        taka@valinux.co.jp, kamezawa.hiroyu@jp.fujitsu.com,
        righi.andrea@gmail.com, guijianfeng@cn.fujitsu.com,
        balbir@linux.vnet.ibm.com, ctalbott@google.com,
        linux-kernel@vger.kernel.org, Justin TerAvest <teravest@google.com>
Subject: [PATCH v3 8/8] cfq: Don't allow preemption across cgroups
Date: Wed, 30 Mar 2011 09:50:40 -0700
Message-Id: <1301503840-25851-9-git-send-email-teravest@google.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1301503840-25851-1-git-send-email-teravest@google.com>
References: <1301503840-25851-1-git-send-email-teravest@google.com>
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

