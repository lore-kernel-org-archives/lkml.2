Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030466Ab2JSDC6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 23:02:58 -0400
Received: from mail.kernel.org ([198.145.19.201]:52124 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964888Ab2JSCst (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 22:48:49 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Paolo Bonzini <pbonzini@redhat.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [ 29/76] target: support zero allocation length in INQUIRY
Date: Thu, 18 Oct 2012 19:46:53 -0700
Message-Id: <20121019024354.833046111@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc0.18.gf84667d
In-Reply-To: <20121019024350.087156547@linuxfoundation.org>
References: <20121019024350.087156547@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paolo Bonzini <pbonzini@redhat.com>

commit ffe7b0e9326d9c68f5688bef691dd49f1e0d3651 upstream.

INQUIRY processing already uses an on-heap bounce buffer for loopback,
but not for other fabrics.  Switch this to a cheaper on-stack bounce
buffer, similar to the one used by MODE SENSE and REQUEST SENSE, and
use it unconditionally.  With this in place, zero allocation length is
handled simply by checking the return address of transport_kmap_data_sg.

Testcase: sg_raw /dev/sdb 12 00 83 00 00 00
    should fail with ILLEGAL REQUEST / INVALID FIELD IN CDB sense
    does not fail without the patch
    fails correctly with the series

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/target/target_core_spc.c |   31 ++++++-------------------------
 1 file changed, 6 insertions(+), 25 deletions(-)

--- a/drivers/target/target_core_spc.c
+++ b/drivers/target/target_core_spc.c
@@ -600,30 +600,11 @@ static int spc_emulate_inquiry(struct se
 {
 	struct se_device *dev = cmd->se_dev;
 	struct se_portal_group *tpg = cmd->se_lun->lun_sep->sep_tpg;
-	unsigned char *buf, *map_buf;
+	unsigned char *rbuf;
 	unsigned char *cdb = cmd->t_task_cdb;
+	unsigned char buf[SE_INQUIRY_BUF];
 	int p, ret;
 
-	map_buf = transport_kmap_data_sg(cmd);
-	/*
-	 * If SCF_PASSTHROUGH_SG_TO_MEM_NOALLOC is not set, then we
-	 * know we actually allocated a full page.  Otherwise, if the
-	 * data buffer is too small, allocate a temporary buffer so we
-	 * don't have to worry about overruns in all our INQUIRY
-	 * emulation handling.
-	 */
-	if (cmd->data_length < SE_INQUIRY_BUF &&
-	    (cmd->se_cmd_flags & SCF_PASSTHROUGH_SG_TO_MEM_NOALLOC)) {
-		buf = kzalloc(SE_INQUIRY_BUF, GFP_KERNEL);
-		if (!buf) {
-			transport_kunmap_data_sg(cmd);
-			cmd->scsi_sense_reason = TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
-			return -ENOMEM;
-		}
-	} else {
-		buf = map_buf;
-	}
-
 	if (dev == tpg->tpg_virt_lun0.lun_se_dev)
 		buf[0] = 0x3f; /* Not connected */
 	else
@@ -655,11 +636,11 @@ static int spc_emulate_inquiry(struct se
 	ret = -EINVAL;
 
 out:
-	if (buf != map_buf) {
-		memcpy(map_buf, buf, cmd->data_length);
-		kfree(buf);
+	rbuf = transport_kmap_data_sg(cmd);
+	if (rbuf) {
+		memcpy(rbuf, buf, min_t(u32, sizeof(buf), cmd->data_length));
+		transport_kunmap_data_sg(cmd);
 	}
-	transport_kunmap_data_sg(cmd);
 
 	if (!ret)
 		target_complete_cmd(cmd, GOOD);


