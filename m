Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933272Ab1I1Ws2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 18:48:28 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54800 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933262Ab1I1WsX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 18:48:23 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Sep 28 15:01:46 2011
Message-Id: <20110928220146.878909100@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 28 Sep 2011 15:02:48 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Mike Christie <michaelc@cs.wisc.edu>,
        James Bottomley <JBottomley@Parallels.com>
Subject: [204/244] [SCSI] libiscsi_tcp: fix LLD data allocation
In-Reply-To: <20110928220225.GA27128@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

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
@@ -1084,7 +1084,8 @@ iscsi_tcp_conn_setup(struct iscsi_cls_se
 	struct iscsi_cls_conn *cls_conn;
 	struct iscsi_tcp_conn *tcp_conn;
 
-	cls_conn = iscsi_conn_setup(cls_session, sizeof(*tcp_conn), conn_idx);
+	cls_conn = iscsi_conn_setup(cls_session,
+				    sizeof(*tcp_conn) + dd_data_size, conn_idx);
 	if (!cls_conn)
 		return NULL;
 	conn = cls_conn->dd_data;
@@ -1096,22 +1097,13 @@ iscsi_tcp_conn_setup(struct iscsi_cls_se
 
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


