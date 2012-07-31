Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755813Ab2GaE6M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 00:58:12 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:48782 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755635Ab2GaEuz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 00:50:55 -0400
Message-Id: <20120731044318.657657711@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Tue, 31 Jul 2012 05:43:56 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Roland Dreier <roland@purestorage.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [ 46/73] target: Check number of unmap descriptors against our limit
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

commit 7409a6657aebf8be74c21d0eded80709b27275cb upstream.

Fail UNMAP commands that have more than our reported limit on unmap
descriptors.

Signed-off-by: Roland Dreier <roland@purestorage.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
[bwh: Backported to 3.2: adjust filename]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/target/target_core_cdb.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/target/target_core_cdb.c
+++ b/drivers/target/target_core_cdb.c
@@ -1133,6 +1133,11 @@ int target_emulate_unmap(struct se_task
 	bd_dl = get_unaligned_be16(&buf[2]);
 
 	size = min(size - 8, bd_dl);
+	if (size / 16 > dev->se_sub_dev->se_dev_attrib.max_unmap_block_desc_count) {
+		cmd->scsi_sense_reason = TCM_INVALID_PARAMETER_LIST;
+		ret = -EINVAL;
+		goto err;
+	}
 
 	/* First UNMAP block descriptor starts at 8 byte offset */
 	ptr = &buf[8];


