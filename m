Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752890Ab2GZVUv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 17:20:51 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:49659 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752813Ab2GZVUq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 17:20:46 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Roland Dreier <roland@purestorage.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [ 05/23] target: Clean up returning errors in PR handling code
Date: Thu, 26 Jul 2012 14:19:44 -0700
Message-Id: <20120726211406.329971244@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120726211405.959857593@linuxfoundation.org>
References: <20120726211420.GA7678@kroah.com>
 <20120726211405.959857593@linuxfoundation.org>
User-Agent: quilt/0.60-20.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Roland Dreier <roland@purestorage.com>

commit d35212f3ca3bf4fb49d15e37f530c9931e2d2183 upstream.

 - instead of (PTR_ERR(file) < 0) just use IS_ERR(file)
 - return -EINVAL instead of EINVAL
 - all other error returns in target_scsi3_emulate_pr_out() use
   "goto out" -- get rid of the one remaining straight "return."

Signed-off-by: Roland Dreier <roland@purestorage.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/target/target_core_pr.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/drivers/target/target_core_pr.c
+++ b/drivers/target/target_core_pr.c
@@ -2038,7 +2038,7 @@ static int __core_scsi3_write_aptpl_to_f
 	if (IS_ERR(file) || !file || !file->f_dentry) {
 		pr_err("filp_open(%s) for APTPL metadata"
 			" failed\n", path);
-		return (PTR_ERR(file) < 0 ? PTR_ERR(file) : -ENOENT);
+		return IS_ERR(file) ? PTR_ERR(file) : -ENOENT;
 	}
 
 	iov[0].iov_base = &buf[0];
@@ -3826,7 +3826,7 @@ int target_scsi3_emulate_pr_out(struct s
 			" SPC-2 reservation is held, returning"
 			" RESERVATION_CONFLICT\n");
 		cmd->scsi_sense_reason = TCM_RESERVATION_CONFLICT;
-		ret = EINVAL;
+		ret = -EINVAL;
 		goto out;
 	}
 
@@ -3836,7 +3836,8 @@ int target_scsi3_emulate_pr_out(struct s
 	 */
 	if (!cmd->se_sess) {
 		cmd->scsi_sense_reason = TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
-		return -EINVAL;
+		ret = -EINVAL;
+		goto out;
 	}
 
 	if (cmd->data_length < 24) {


