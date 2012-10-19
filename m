Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030454Ab2JSDCa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 23:02:30 -0400
Received: from mail.kernel.org ([198.145.19.201]:52134 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964897Ab2JSCsu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 22:48:50 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Paolo Bonzini <pbonzini@redhat.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [ 30/76] target: fix truncation of mode data, support zero allocation length
Date: Thu, 18 Oct 2012 19:46:54 -0700
Message-Id: <20121019024354.985523098@linuxfoundation.org>
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

commit 7a3f369ce31694017996524a1cdb08208a839077 upstream.

The offset was not bumped back to the full size after writing the
header of the MODE SENSE response, so the last 1 or 2 bytes were
not copied.

On top of this, support zero-length requests by checking for the
return value of transport_kmap_data_sg.

Testcase: sg_raw -r20 /dev/sdb 5a 00 0a 00 00 00 00 00 14 00
    last byte should be 0x1e
    it is 0x00 without the patch
    it is correct with the patch

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/target/target_core_spc.c |   17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)

--- a/drivers/target/target_core_spc.c
+++ b/drivers/target/target_core_spc.c
@@ -784,7 +784,7 @@ static int spc_emulate_modesense(struct
 	unsigned char *rbuf;
 	int type = dev->transport->get_device_type(dev);
 	int ten = (cmd->t_task_cdb[0] == MODE_SENSE_10);
-	int offset = ten ? 8 : 4;
+	u32 offset = ten ? 8 : 4;
 	int length = 0;
 	unsigned char buf[SE_MODE_PAGE_BUF];
 
@@ -817,6 +817,7 @@ static int spc_emulate_modesense(struct
 		offset -= 2;
 		buf[0] = (offset >> 8) & 0xff;
 		buf[1] = offset & 0xff;
+		offset += 2;
 
 		if ((cmd->se_lun->lun_access & TRANSPORT_LUNFLAGS_READ_ONLY) ||
 		    (cmd->se_deve &&
@@ -826,13 +827,10 @@ static int spc_emulate_modesense(struct
 		if ((dev->se_sub_dev->se_dev_attrib.emulate_write_cache > 0) &&
 		    (dev->se_sub_dev->se_dev_attrib.emulate_fua_write > 0))
 			spc_modesense_dpofua(&buf[3], type);
-
-		if ((offset + 2) > cmd->data_length)
-			offset = cmd->data_length;
-
 	} else {
 		offset -= 1;
 		buf[0] = offset & 0xff;
+		offset += 1;
 
 		if ((cmd->se_lun->lun_access & TRANSPORT_LUNFLAGS_READ_ONLY) ||
 		    (cmd->se_deve &&
@@ -842,14 +840,13 @@ static int spc_emulate_modesense(struct
 		if ((dev->se_sub_dev->se_dev_attrib.emulate_write_cache > 0) &&
 		    (dev->se_sub_dev->se_dev_attrib.emulate_fua_write > 0))
 			spc_modesense_dpofua(&buf[2], type);
-
-		if ((offset + 1) > cmd->data_length)
-			offset = cmd->data_length;
 	}
 
 	rbuf = transport_kmap_data_sg(cmd);
-	memcpy(rbuf, buf, offset);
-	transport_kunmap_data_sg(cmd);
+	if (rbuf) {
+		memcpy(rbuf, buf, min(offset, cmd->data_length));
+		transport_kunmap_data_sg(cmd);
+	}
 
 	target_complete_cmd(cmd, GOOD);
 	return 0;


