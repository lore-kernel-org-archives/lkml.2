Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933225Ab0EJXET (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 19:04:19 -0400
Received: from kroah.org ([198.145.64.141]:45359 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932935Ab0EJW6a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 18:58:30 -0400
X-Mailbox-Line: From gregkh@kvm.kroah.org Mon May 10 15:35:41 2010
Message-Id: <20100510223541.597252373@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Mon, 10 May 2010 15:35:32 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Michael Chan <mchan@broadcom.com>,
       "David S. Miller" <davem@davemloft.net>
Subject: [80/98] bnx2: Fix lost MSI-X problem on 5709 NICs.
In-Reply-To: <20100510223714.GA18416@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Michael Chan <mchan@broadcom.com>

commit c441b8d2cb2194b05550a558d6d95d8944e56a84 upstream.

It has been reported that under certain heavy traffic conditions in MSI-X
mode, the driver can lose an MSI-X vector causing all packets in the
associated rx/tx ring pair to be dropped.  The problem is caused by
the chip dropping the write to unmask the MSI-X vector by the kernel
(when migrating the IRQ for example).

This can be prevented by increasing the GRC timeout value for these
register read and write operations.

Thanks to Dell for helping us debug this problem.

Signed-off-by: Michael Chan <mchan@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/bnx2.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/net/bnx2.c
+++ b/drivers/net/bnx2.c
@@ -4752,8 +4752,12 @@ bnx2_reset_chip(struct bnx2 *bp, u32 res
 		rc = bnx2_alloc_bad_rbuf(bp);
 	}
 
-	if (bp->flags & BNX2_FLAG_USING_MSIX)
+	if (bp->flags & BNX2_FLAG_USING_MSIX) {
 		bnx2_setup_msix_tbl(bp);
+		/* Prevent MSIX table reads and write from timing out */
+		REG_WR(bp, BNX2_MISC_ECO_HW_CTL,
+			BNX2_MISC_ECO_HW_CTL_LARGE_GRC_TMOUT_EN);
+	}
 
 	return rc;
 }


