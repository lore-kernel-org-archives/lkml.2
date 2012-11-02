Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763050Ab2KBRKo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 13:10:44 -0400
Received: from mail.kernel.org ([198.145.19.201]:33456 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762975Ab2KBRHw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 13:07:52 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Bernhard Kohl <bernhard.kohl@nsn.com>, Christoph Hellwig <hch@lst.de>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [ 19/24] target: reintroduce some obsolete SCSI-2 commands
Date: Fri,  2 Nov 2012 10:07:07 -0700
Message-Id: <20121102170248.792646812@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc3.16.g8ead1bf
In-Reply-To: <20121102170247.406319110@linuxfoundation.org>
References: <20121102170247.406319110@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bernhard Kohl <bernhard.kohl@nsn.com>

commit 1a1ff38c4cebf23be8bf0009a76b082a13bd25cb upstream.

With kernel 3.6 some obsolete SCSI-2 commands including SEEK_10 have
have been removed by commit 1fd032ee10d2816c947f5d5b9abda95e728f0a8f
"target: move code for CDB emulation".

There are still clients out there which use these old SCSI-2 commands.
This mainly happens when running VMs with legacy guest systems,
connected via SCSI command pass-through to iSCSI targets. Make them
happy and return status GOOD.

Many real SCSI disks or external iSCSI storage devices still support
these old commands. So let's make LIO backward compatible as well.

This patch adds support for the previously removed SEEK_10 and
additionally the SEEK_6 and REZERO_UNIT commands.

Signed-off-by: Bernhard Kohl <bernhard.kohl@nsn.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/target/target_core_sbc.c |   18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

--- a/drivers/target/target_core_sbc.c
+++ b/drivers/target/target_core_sbc.c
@@ -128,6 +128,12 @@ static int sbc_emulate_verify(struct se_
 	return 0;
 }
 
+static int sbc_emulate_noop(struct se_cmd *cmd)
+{
+	target_complete_cmd(cmd, GOOD);
+	return 0;
+}
+
 static inline u32 sbc_get_size(struct se_cmd *cmd, u32 sectors)
 {
 	return cmd->se_dev->se_sub_dev->se_dev_attrib.block_size * sectors;
@@ -524,6 +530,18 @@ int sbc_parse_cdb(struct se_cmd *cmd, st
 		size = 0;
 		cmd->execute_cmd = sbc_emulate_verify;
 		break;
+	case REZERO_UNIT:
+	case SEEK_6:
+	case SEEK_10:
+		/*
+		 * There are still clients out there which use these old SCSI-2
+		 * commands. This mainly happens when running VMs with legacy
+		 * guest systems, connected via SCSI command pass-through to
+		 * iSCSI targets. Make them happy and return status GOOD.
+		 */
+		size = 0;
+		cmd->execute_cmd = sbc_emulate_noop;
+		break;
 	default:
 		ret = spc_parse_cdb(cmd, &size);
 		if (ret)


