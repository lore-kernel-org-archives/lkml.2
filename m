Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933159Ab1KCBfD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 21:35:03 -0400
Received: from cantor2.suse.de ([195.135.220.15]:50532 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933120Ab1KCBe4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 21:34:56 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  2 15:14:53 2011
Message-Id: <20111102221453.495886972@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 02 Nov 2011 15:14:03 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Mike Christie <michaelc@cs.wisc.edu>,
        James Bottomley <JBottomley@Parallels.com>
Subject: [037/107] [SCSI] libiscsi_tcp: fix LLD data allocation
In-Reply-To: <20111102221600.GA26650@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Mike Christie <michaelc@cs.wisc.edu>

commit 74dcd0ec735ba9c5bef254b2f6e53068cf3f9ff0 upstream.

Have libiscsi_tcp have upper layers allocate the LLD data
along with the iscsi_cls_conn struct, so it is refcounted.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
Signed-off-by: James Bottomley <JBottomley@Parallels.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/scsi/libiscsi_tcp.c |   14 +++-----------
 1 file changed, 3 insertions(+), 11 deletions(-)

--- a/drivers/scsi/libiscsi_tcp.c
+++ b/drivers/scsi/libiscsi_tcp.c
@@ -1069,7 +1069,8 @@ iscsi_tcp_conn_setup(struct iscsi_cls_se
 	struct iscsi_cls_conn *cls_conn;
 	struct iscsi_tcp_conn *tcp_conn;
 
-	cls_conn = iscsi_conn_setup(cls_session, sizeof(*tcp_conn), conn_idx);
+	cls_conn = iscsi_conn_setup(cls_session,
+				    sizeof(*tcp_conn) + dd_data_size, conn_idx);
 	if (!cls_conn)
 		return NULL;
 	conn = cls_conn->dd_data;
@@ -1081,22 +1082,13 @@ iscsi_tcp_conn_setup(struct iscsi_cls_se
 
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


