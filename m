Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753874Ab2GWBxk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2012 21:53:40 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:54332 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753420Ab2GWBnR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2012 21:43:17 -0400
Message-Id: <20120723010700.567517051@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 23 Jul 2012 02:07:51 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Roland Dreier <roland@purestorage.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [ 060/108] target: Fix range calculation in WRITE SAME emulation when num
 blocks == 0
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

commit 1765fe5edcb83f53fc67edeb559fcf4bc82c6460 upstream.

When NUMBER OF LOGICAL BLOCKS is 0, WRITE SAME is supposed to write
all the blocks from the specified LBA through the end of the device.
However, dev->transport->get_blocks(dev) (perhaps confusingly) returns
the last valid LBA rather than the number of blocks, so the correct
number of blocks to write starting with lba is

dev->transport->get_blocks(dev) - lba + 1

(nab: Backport roland's for-3.6 patch to for-3.5)

Signed-off-by: Roland Dreier <roland@purestorage.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/target/target_core_cdb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/target/target_core_cdb.c b/drivers/target/target_core_cdb.c
index 9888693..664f6e7 100644
--- a/drivers/target/target_core_cdb.c
+++ b/drivers/target/target_core_cdb.c
@@ -1095,7 +1095,7 @@ int target_emulate_write_same(struct se_cmd *cmd)
 	if (num_blocks != 0)
 		range = num_blocks;
 	else
-		range = (dev->transport->get_blocks(dev) - lba);
+		range = (dev->transport->get_blocks(dev) - lba) + 1;
 
 	pr_debug("WRITE_SAME UNMAP: LBA: %llu Range: %llu\n",
 		 (unsigned long long)lba, (unsigned long long)range);


