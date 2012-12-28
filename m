Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754919Ab2L1T3X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2012 14:29:23 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55611 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932407Ab2L1TTi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2012 14:19:38 -0500
Message-Id: <20121228190339.849197247@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Fri, 28 Dec 2012 20:04:17 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Roland Dreier <roland@purestorage.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [ 047/173] iscsi-target: Always send a response before terminating iSCSI
 connection
In-Reply-To: <20121228190330.025298996@decadent.org.uk>
X-SA-Exim-Connect-IP: 151.217.219.220
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Roland Dreier <roland@purestorage.com>

commit 1c5c12c666fda27c7c494b34934a0a0631a48130 upstream.

There are some cases, for example when the initiator sends an
out-of-bounds ErrorRecoveryLevel value, where the iSCSI target
terminates the connection without sending back any error.  Audit the
login path and add appropriate iscsit_tx_login_rsp() calls to make
sure this doesn't happen.

Signed-off-by: Roland Dreier <roland@purestorage.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/target/iscsi/iscsi_target_login.c |    8 ++++----
 drivers/target/iscsi/iscsi_target_nego.c  |   10 ++++++++--
 2 files changed, 12 insertions(+), 6 deletions(-)

--- a/drivers/target/iscsi/iscsi_target_login.c
+++ b/drivers/target/iscsi/iscsi_target_login.c
@@ -130,13 +130,13 @@ int iscsi_check_for_session_reinstatemen
 
 	initiatorname_param = iscsi_find_param_from_key(
 			INITIATORNAME, conn->param_list);
-	if (!initiatorname_param)
-		return -1;
-
 	sessiontype_param = iscsi_find_param_from_key(
 			SESSIONTYPE, conn->param_list);
-	if (!sessiontype_param)
+	if (!initiatorname_param || !sessiontype_param) {
+		iscsit_tx_login_rsp(conn, ISCSI_STATUS_CLS_INITIATOR_ERR,
+			ISCSI_LOGIN_STATUS_MISSING_FIELDS);
 		return -1;
+	}
 
 	sessiontype = (strncmp(sessiontype_param->value, NORMAL, 6)) ? 1 : 0;
 
--- a/drivers/target/iscsi/iscsi_target_nego.c
+++ b/drivers/target/iscsi/iscsi_target_nego.c
@@ -632,8 +632,11 @@ static int iscsi_target_handle_csg_one(s
 			login->req_buf,
 			payload_length,
 			conn->param_list);
-	if (ret < 0)
+	if (ret < 0) {
+		iscsit_tx_login_rsp(conn, ISCSI_STATUS_CLS_INITIATOR_ERR,
+				ISCSI_LOGIN_STATUS_INIT_ERR);
 		return -1;
+	}
 
 	if (login->first_request)
 		if (iscsi_target_check_first_request(conn, login) < 0)
@@ -648,8 +651,11 @@ static int iscsi_target_handle_csg_one(s
 			login->rsp_buf,
 			&login->rsp_length,
 			conn->param_list);
-	if (ret < 0)
+	if (ret < 0) {
+		iscsit_tx_login_rsp(conn, ISCSI_STATUS_CLS_INITIATOR_ERR,
+				ISCSI_LOGIN_STATUS_INIT_ERR);
 		return -1;
+	}
 
 	if (!login->auth_complete &&
 	     ISCSI_TPG_ATTRIB(ISCSI_TPG_C(conn))->authentication) {


