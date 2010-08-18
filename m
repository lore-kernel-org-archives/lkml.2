Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753537Ab0HROjT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 10:39:19 -0400
Received: from g5t0006.atlanta.hp.com ([15.192.0.43]:26489 "EHLO
	g5t0006.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752999Ab0HROjS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 10:39:18 -0400
Subject: [PATCH] cciss: disable doorbell reset on reset_devices
To: axboe@kernel.dk
From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Cc: akpm@linux-foundation.org, mikem@beardog.cce.hp.com,
        linux-kernel@vger.kernel.org, brace@beardog.cce.hp.com
Date: Wed, 18 Aug 2010 09:45:16 -0500
Message-ID: <20100818144516.21791.86572.stgit@beardog.cce.hp.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

The doorbell reset initially appears to work correctly,
the controller resets, comes up, some i/o can even be
done, but on at least some Smart Arrays in some servers,
it eventually causes a subsequent controller lockup due
to some kind of PCIe error, and kdump can end up leaving
the root filesystem in an unbootable state.  For this
reason, until the problem is fixed, or at least isolated
to certain hardware enough to be avoided, the doorbell
reset should not be used at all.

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/block/cciss.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index 39083e6..3cd1d62 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -4520,6 +4520,12 @@ static __devinit int cciss_kdump_hard_reset_controller(struct pci_dev *pdev)
 	misc_fw_support = readl(&cfgtable->misc_fw_support);
 	use_doorbell = misc_fw_support & MISC_FW_DOORBELL_RESET;
 
+	/* The doorbell reset seems to cause lockups on some Smart
+	 * Arrays (e.g. P410, P410i, maybe others).  Until this is
+	 * fixed or at least isolated, avoid the doorbell reset.
+	 */
+	use_doorbell = 0;
+
 	rc = cciss_controller_hard_reset(pdev, vaddr, use_doorbell);
 	if (rc)
 		goto unmap_cfgtable;

