Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757196Ab2HOU1W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 16:27:22 -0400
Received: from mail.windriver.com ([147.11.1.11]:36745 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756322Ab2HOTuN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 15:50:13 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Mike Christie <michaelc@cs.wisc.edu>,
        James Bottomley <JBottomley@parallels.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 051/165] libiscsi_tcp: fix LLD data allocation
Date: Wed, 15 Aug 2012 15:46:35 -0400
Message-ID: <1345060109-9187-52-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.12.rc2
In-Reply-To: <1345060109-9187-1-git-send-email-paul.gortmaker@windriver.com>
References: <1345060109-9187-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mike Christie <michaelc@cs.wisc.edu>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 74dcd0ec735ba9c5bef254b2f6e53068cf3f9ff0 upstream.

Have libiscsi_tcp have upper layers allocate the LLD data
along with the iscsi_cls_conn struct, so it is refcounted.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
Signed-off-by: James Bottomley <JBottomley@Parallels.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/scsi/libiscsi_tcp.c | 14 +++-----------
 1 file changed, 3 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/libiscsi_tcp.c b/drivers/scsi/libiscsi_tcp.c
index 5c92620..b90bb2a 100644
--- a/drivers/scsi/libiscsi_tcp.c
+++ b/drivers/scsi/libiscsi_tcp.c
@@ -1073,7 +1073,8 @@ iscsi_tcp_conn_setup(struct iscsi_cls_session *cls_session, int dd_data_size,
 	struct iscsi_cls_conn *cls_conn;
 	struct iscsi_tcp_conn *tcp_conn;
 
-	cls_conn = iscsi_conn_setup(cls_session, sizeof(*tcp_conn), conn_idx);
+	cls_conn = iscsi_conn_setup(cls_session,
+				    sizeof(*tcp_conn) + dd_data_size, conn_idx);
 	if (!cls_conn)
 		return NULL;
 	conn = cls_conn->dd_data;
@@ -1085,22 +1086,13 @@ iscsi_tcp_conn_setup(struct iscsi_cls_session *cls_session, int dd_data_size,
 
 	tcp_conn = conn->dd_data;
 	tcp_conn->iscsi_conn = conn;
-
-	tcp_conn->dd_data = kzalloc(dd_data_size, GFP_KERNEL);
-	if (!tcp_conn->dd_data) {
-		iscsi_conn_teardown(cls_conn);
-		return NULL;
-	}
+	tcp_conn->dd_data = conn->dd_data + sizeof(*tcp_conn);
 	return cls_conn;
 }
 EXPORT_SYMBOL_GPL(iscsi_tcp_conn_setup);
 
 void iscsi_tcp_conn_teardown(struct iscsi_cls_conn *cls_conn)
 {
-	struct iscsi_conn *conn = cls_conn->dd_data;
-	struct iscsi_tcp_conn *tcp_conn = conn->dd_data;
-
-	kfree(tcp_conn->dd_data);
 	iscsi_conn_teardown(cls_conn);
 }
 EXPORT_SYMBOL_GPL(iscsi_tcp_conn_teardown);
-- 
1.7.12.rc2

