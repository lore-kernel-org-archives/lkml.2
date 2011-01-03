Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932157Ab1ACNw5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jan 2011 08:52:57 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:39769 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755325Ab1ACNum (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jan 2011 08:50:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=MjIOq4yCIxFI1s/pfVIxfgpfu2OCGNLP2dHFsPGi/dZsefpWglHUWm/K6CVmFaGGUW
         y9SGyx+f6YbupjQxttpn0XOeMXcMkmnjhfNZlW2DzSY0AXODnC3SmTsacZoEwRXd8SfN
         B3OlrbmmkKnv7f7RKma6KCpwru+v4RH3G3tII=
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>, Sage Weil <sage@newdream.net>,
        ceph-devel@vger.kernel.org
Subject: [PATCH 22/32] ceph: fsc->*_wq's aren't used in memory reclaim path
Date: Mon,  3 Jan 2011 14:49:45 +0100
Message-Id: <1294062595-30097-23-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1294062595-30097-1-git-send-email-tj@kernel.org>
References: <1294062595-30097-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fsc->*_wq's aren't depended upon during memory reclaim.  Convert to
alloc_workqueue() w/o WQ_MEM_RECLAIM.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Sage Weil <sage@newdream.net>
Cc: ceph-devel@vger.kernel.org
---
Only compile tested.  Please feel free to take it into the subsystem
tree or simply ack - I'll route it through the wq tree.

Thanks.

 fs/ceph/super.c |   10 +++++++---
 1 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/fs/ceph/super.c b/fs/ceph/super.c
index 08b460a..1f6436e 100644
--- a/fs/ceph/super.c
+++ b/fs/ceph/super.c
@@ -443,13 +443,17 @@ struct ceph_fs_client *create_fs_client(struct ceph_mount_options *fsopt,
 		goto fail_client;
 
 	err = -ENOMEM;
-	fsc->wb_wq = create_workqueue("ceph-writeback");
+	/*
+	 * The number of concurrent works can be high but they don't need
+	 * to be processed in parallel, limit concurrency.
+	 */
+	fsc->wb_wq = alloc_workqueue("ceph-writeback", 0, 1);
 	if (fsc->wb_wq == NULL)
 		goto fail_bdi;
-	fsc->pg_inv_wq = create_singlethread_workqueue("ceph-pg-invalid");
+	fsc->pg_inv_wq = alloc_workqueue("ceph-pg-invalid", 0, 1);
 	if (fsc->pg_inv_wq == NULL)
 		goto fail_wb_wq;
-	fsc->trunc_wq = create_singlethread_workqueue("ceph-trunc");
+	fsc->trunc_wq = alloc_workqueue("ceph-trunc", 0, 1);
 	if (fsc->trunc_wq == NULL)
 		goto fail_pg_inv_wq;
 
-- 
1.7.1

