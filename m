Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753476Ab2GWBnV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2012 21:43:21 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:54336 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753421Ab2GWBnS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2012 21:43:18 -0400
Message-Id: <20120723010700.419812793@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 23 Jul 2012 02:07:50 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Roland Dreier <roland@purestorage.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [ 059/108] target: Clean up returning errors in PR handling code
In-Reply-To: <20120723010651.408577075@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Roland Dreier <roland@purestorage.com>

commit d35212f3ca3bf4fb49d15e37f530c9931e2d2183 upstream.

 - instead of (PTR_ERR(file) < 0) just use IS_ERR(file)
 - return -EINVAL instead of EINVAL
 - all other error returns in target_scsi3_emulate_pr_out() use
   "goto out" -- get rid of the one remaining straight "return."

Signed-off-by: Roland Dreier <roland@purestorage.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/target/target_core_pr.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/target/target_core_pr.c b/drivers/target/target_core_pr.c
index 8556499..a1bcd92 100644
--- a/drivers/target/target_core_pr.c
+++ b/drivers/target/target_core_pr.c
@@ -2031,7 +2031,7 @@ static int __core_scsi3_write_aptpl_to_file(
 	if (IS_ERR(file) || !file || !file->f_dentry) {
 		pr_err("filp_open(%s) for APTPL metadata"
 			" failed\n", path);
-		return (PTR_ERR(file) < 0 ? PTR_ERR(file) : -ENOENT);
+		return IS_ERR(file) ? PTR_ERR(file) : -ENOENT;
 	}
 
 	iov[0].iov_base = &buf[0];
@@ -3818,7 +3818,7 @@ int target_scsi3_emulate_pr_out(struct se_cmd *cmd)
 			" SPC-2 reservation is held, returning"
 			" RESERVATION_CONFLICT\n");
 		cmd->scsi_sense_reason = TCM_RESERVATION_CONFLICT;
-		ret = EINVAL;
+		ret = -EINVAL;
 		goto out;
 	}
 
@@ -3828,7 +3828,8 @@ int target_scsi3_emulate_pr_out(struct se_cmd *cmd)
 	 */
 	if (!cmd->se_sess) {
 		cmd->scsi_sense_reason = TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
-		return -EINVAL;
+		ret = -EINVAL;
+		goto out;
 	}
 
 	if (cmd->data_length < 24) {


