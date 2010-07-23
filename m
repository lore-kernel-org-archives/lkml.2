Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756327Ab0GWLDM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jul 2010 07:03:12 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:49385 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754411Ab0GWLDJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jul 2010 07:03:09 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Fri, 23 Jul 2010 13:02:54 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH] firewire: core: fix upper bound of possible CSR allocations
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org
Message-ID: <tkrat.e4d747d0544a6f14@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

region->end is defined as an upper bound of the requested address range,
exclusive --- i.e. as an address outside of the range in which the
requested CSR is to be placed.

Hence 0x0001,0000,0000,0000 is the biggest valid region->end, not
0x0000,ffff,ffff,fffc like the current check asserted.

For simplicity, the fix drops the region->end & 3 test because there is
no actual problem with these bits set in region->end.  The allocated
address range will be quadlet aligned and of a size of multiple quadlets
due to the checks for region->start & 3 and handler->length & 3 alone.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/core-transaction.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: b/drivers/firewire/core-transaction.c
===================================================================
--- a/drivers/firewire/core-transaction.c
+++ b/drivers/firewire/core-transaction.c
@@ -543,8 +543,8 @@ int fw_core_add_address_handler(struct f
 	int ret = -EBUSY;
 
 	if (region->start & 0xffff000000000003ULL ||
-	    region->end   & 0xffff000000000003ULL ||
 	    region->start >= region->end ||
+	    region->end   > 0x0001000000000000ULL ||
 	    handler->length & 3 ||
 	    handler->length == 0)
 		return -EINVAL;

-- 
Stefan Richter
-=====-==-=- -=== =-===
http://arcgraph.de/sr/

