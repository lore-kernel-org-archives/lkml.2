Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755793Ab2HMWSa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 18:18:30 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:59678 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755762Ab2HMWSZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 18:18:25 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Roland Dreier <roland@purestorage.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [ 51/65] target: Add range checking to UNMAP emulation
Date: Mon, 13 Aug 2012 15:14:35 -0700
Message-Id: <20120813221419.464505322@linuxfoundation.org>
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

commit 2594e29865c291db162313187612cd9f14538f33 upstream.

When processing an UNMAP command, we need to make sure that the number
of blocks we're asked to UNMAP does not exceed our reported maximum
number of blocks per UNMAP, and that the range of blocks we're
unmapping doesn't go past the end of the device.

Signed-off-by: Roland Dreier <roland@purestorage.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
[bwh: Backported to 3.2: adjust filename, context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/target/target_core_cdb.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/drivers/target/target_core_cdb.c
+++ b/drivers/target/target_core_cdb.c
@@ -1053,6 +1053,18 @@ int target_emulate_unmap(struct se_task
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


