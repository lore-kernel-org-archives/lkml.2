Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753008Ab2GZVZY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 17:25:24 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:55834 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752571Ab2GZVUu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 17:20:50 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Roland Dreier <roland@purestorage.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [ 06/23] target: Fix range calculation in WRITE SAME emulation when num blocks == 0
Date: Thu, 26 Jul 2012 14:19:45 -0700
Message-Id: <20120726211406.406061223@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120726211405.959857593@linuxfoundation.org>
References: <20120726211420.GA7678@kroah.com>
 <20120726211405.959857593@linuxfoundation.org>
User-Agent: quilt/0.60-20.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/target/target_core_cdb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/target/target_core_cdb.c
+++ b/drivers/target/target_core_cdb.c
@@ -1107,7 +1107,7 @@ int target_emulate_write_same(struct se_
 	if (num_blocks != 0)
 		range = num_blocks;
 	else
-		range = (dev->transport->get_blocks(dev) - lba);
+		range = (dev->transport->get_blocks(dev) - lba) + 1;
 
 	pr_debug("WRITE_SAME UNMAP: LBA: %llu Range: %llu\n",
 		 (unsigned long long)lba, (unsigned long long)range);


