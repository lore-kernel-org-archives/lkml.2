Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755681Ab2GaEvA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 00:51:00 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:48774 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755633Ab2GaEux (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 00:50:53 -0400
Message-Id: <20120731044318.401414025@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Tue, 31 Jul 2012 05:43:54 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Roland Dreier <roland@purestorage.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [ 44/73] target: Fix reading of data length fields for UNMAP commands
In-Reply-To: <20120731044310.013763753@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

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
---
 drivers/target/target_core_cdb.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/target/target_core_cdb.c
+++ b/drivers/target/target_core_cdb.c
@@ -1114,7 +1114,6 @@ int target_emulate_unmap(struct se_task
 	struct se_cmd *cmd = task->task_se_cmd;
 	struct se_device *dev = cmd->se_dev;
 	unsigned char *buf, *ptr = NULL;
-	unsigned char *cdb = &cmd->t_task_cdb[0];
 	sector_t lba;
 	unsigned int size = cmd->data_length, range;
 	int ret = 0, offset;
@@ -1130,11 +1129,12 @@ int target_emulate_unmap(struct se_task
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


