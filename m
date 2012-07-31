Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755881Ab2GaE5O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 00:57:14 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:48790 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755641Ab2GaEu4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 00:50:56 -0400
Message-Id: <20120731044318.235449624@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Tue, 31 Jul 2012 05:43:53 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Roland Dreier <roland@purestorage.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [ 43/73] target: Add range checking to UNMAP emulation
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

commit 2594e29865c291db162313187612cd9f14538f33 upstream.

When processing an UNMAP command, we need to make sure that the number
of blocks we're asked to UNMAP does not exceed our reported maximum
number of blocks per UNMAP, and that the range of blocks we're
unmapping doesn't go past the end of the device.

Signed-off-by: Roland Dreier <roland@purestorage.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
[bwh: Backported to 3.2: adjust filename, context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/target/target_core_cdb.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/drivers/target/target_core_cdb.c
+++ b/drivers/target/target_core_cdb.c
@@ -1145,6 +1145,18 @@ int target_emulate_unmap(struct se_task
 		pr_debug("UNMAP: Using lba: %llu and range: %u\n",
 				 (unsigned long long)lba, range);
 
+		if (range > dev->se_sub_dev->se_dev_attrib.max_unmap_lba_count) {
+			cmd->scsi_sense_reason = TCM_INVALID_PARAMETER_LIST;
+			ret = -EINVAL;
+			goto err;
+		}
+
+		if (lba + range > dev->transport->get_blocks(dev) + 1) {
+			cmd->scsi_sense_reason = TCM_ADDRESS_OUT_OF_RANGE;
+			ret = -EINVAL;
+			goto err;
+		}
+
 		ret = dev->transport->do_discard(dev, lba, range);
 		if (ret < 0) {
 			pr_err("blkdev_issue_discard() failed: %d\n",


