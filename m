Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755811Ab2HMWSf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 18:18:35 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:52232 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755460Ab2HMWSa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 18:18:30 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Roland Dreier <roland@purestorage.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [ 52/65] target: Fix reading of data length fields for UNMAP commands
Date: Mon, 13 Aug 2012 15:14:36 -0700
Message-Id: <20120813221419.557755497@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120813221414.965154048@linuxfoundation.org>
References: <20120813221414.965154048@linuxfoundation.org>
User-Agent: quilt/0.60-20.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Roland Dreier <roland@purestorage.com>

commit 1a5fa4576ec8a462313c7516b31d7453481ddbe8 upstream.

The UNMAP DATA LENGTH and UNMAP BLOCK DESCRIPTOR DATA LENGTH fields
are in the unmap descriptor (the payload transferred to our data out
buffer), not in the CDB itself.  Read them from the correct place in
target_emulated_unmap.

Signed-off-by: Roland Dreier <roland@purestorage.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
[bwh: Backported to 3.2: adjust filename, context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/target/target_core_cdb.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/target/target_core_cdb.c
+++ b/drivers/target/target_core_cdb.c
@@ -1022,7 +1022,6 @@ int target_emulate_unmap(struct se_task
 	struct se_cmd *cmd = task->task_se_cmd;
 	struct se_device *dev = cmd->se_dev;
 	unsigned char *buf, *ptr = NULL;
-	unsigned char *cdb = &cmd->t_task_cdb[0];
 	sector_t lba;
 	unsigned int size = cmd->data_length, range;
 	int ret = 0, offset;
@@ -1038,11 +1037,12 @@ int target_emulate_unmap(struct se_task
 	/* First UNMAP block descriptor starts at 8 byte offset */
 	offset = 8;
 	size -= 8;
-	dl = get_unaligned_be16(&cdb[0]);
-	bd_dl = get_unaligned_be16(&cdb[2]);
 
 	buf = transport_kmap_data_sg(cmd);
 
+	dl = get_unaligned_be16(&buf[0]);
+	bd_dl = get_unaligned_be16(&buf[2]);
+
 	ptr = &buf[offset];
 	pr_debug("UNMAP: Sub: %s Using dl: %hu bd_dl: %hu size: %hu"
 		" ptr: %p\n", dev->transport->name, dl, bd_dl, size, ptr);


