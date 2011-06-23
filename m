Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934179Ab1FWSG4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 14:06:56 -0400
Received: from mail.windriver.com ([147.11.1.11]:34687 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933443Ab1FWRgy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 13:36:54 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Paul Zimmerman <Paul.Zimmerman@synopsys.com>,
        Paul Zimmerman <paulz@synopsys.com>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 136/247] xhci: Fix an error in count_sg_trbs_needed()
Date: Thu, 23 Jun 2011 13:33:24 -0400
Message-Id: <1308850515-15242-77-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1308850515-15242-1-git-send-email-paul.gortmaker@windriver.com>
References: <1308849690-14530-1-git-send-email-paul.gortmaker@windriver.com>
 <1308850515-15242-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul Zimmerman <Paul.Zimmerman@synopsys.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit bcd2fde05341cef0052e49566ec88b406a521cf3 upstream.

The expression

	while (running_total < sg_dma_len(sg))

does not take into account that the remaining data length can be less
than sg_dma_len(sg). In that case, running_total can end up being
greater than the total data length, so an extra TRB is counted.
Changing the expression to

	while (running_total < sg_dma_len(sg) && running_total < temp)

fixes that.

This patch should be queued for stable kernels back to 2.6.31.

Signed-off-by: Paul Zimmerman <paulz@synopsys.com>
Signed-off-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/usb/host/xhci-ring.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/host/xhci-ring.c b/drivers/usb/host/xhci-ring.c
index e4afa99..34ce5d4 100644
--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -1716,7 +1716,7 @@ static unsigned int count_sg_trbs_needed(struct xhci_hcd *xhci, struct urb *urb)
 			num_trbs++;
 
 		/* How many more 64KB chunks to transfer, how many more TRBs? */
-		while (running_total < sg_dma_len(sg)) {
+		while (running_total < sg_dma_len(sg) && running_total < temp) {
 			num_trbs++;
 			running_total += TRB_MAX_BUFF_SIZE;
 		}
-- 
1.7.4.4

