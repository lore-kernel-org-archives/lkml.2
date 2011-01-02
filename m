Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752567Ab1ABIIm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 03:08:42 -0500
Received: from mail.windriver.com ([147.11.1.11]:34415 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752281Ab1ABHWB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 02:22:01 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Dan Carpenter <error27@gmail.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 045/260] USB: ehci-ppc-of: problems in unwind
Date: Sun,  2 Jan 2011 02:15:41 -0500
Message-Id: <1293952756-15010-46-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.3.3
In-Reply-To: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
References: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
X-OriginalArrivalTime: 02 Jan 2011 07:20:55.0273 (UTC) FILETIME=[9830CD90:01CBAA4D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dan Carpenter <error27@gmail.com>

commit 08a3b3b1c2e622e378d9086aee9e2e42ce37591d upstream.

The iounmap(ehci->ohci_hcctrl_reg); should be the first thing we do
because the ioremap() was the last thing we did.  Also if we hit any of
the goto statements in the original code then it would have led to a
NULL dereference of "ehci".  This bug was introduced in: 796bcae7361c
"USB: powerpc: Workaround for the PPC440EPX USBH_23 errata [take 3]"

I modified the few lines in front a little so that my code didn't
obscure the return success code path.

Signed-off-by: Dan Carpenter <error27@gmail.com>
Reviewed-by: Grant Likely <grant.likely@secretlab.ca>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/usb/host/ehci-ppc-of.c |   12 +++++++-----
 1 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/usb/host/ehci-ppc-of.c b/drivers/usb/host/ehci-ppc-of.c
index 8df33b8..5c2fbd1 100644
--- a/drivers/usb/host/ehci-ppc-of.c
+++ b/drivers/usb/host/ehci-ppc-of.c
@@ -192,17 +192,19 @@ ehci_hcd_ppc_of_probe(struct of_device *op, const struct of_device_id *match)
 	}
 
 	rv = usb_add_hcd(hcd, irq, 0);
-	if (rv == 0)
-		return 0;
+	if (rv)
+		goto err_ehci;
+
+	return 0;
 
+err_ehci:
+	if (ehci->has_amcc_usb23)
+		iounmap(ehci->ohci_hcctrl_reg);
 	iounmap(hcd->regs);
 err_ioremap:
 	irq_dispose_mapping(irq);
 err_irq:
 	release_mem_region(hcd->rsrc_start, hcd->rsrc_len);
-
-	if (ehci->has_amcc_usb23)
-		iounmap(ehci->ohci_hcctrl_reg);
 err_rmr:
 	usb_put_hcd(hcd);
 
-- 
1.7.3.3

