Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755908Ab0IRTCE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Sep 2010 15:02:04 -0400
Received: from kroah.org ([198.145.64.141]:51170 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754508Ab0IRTBV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Sep 2010 15:01:21 -0400
X-Mailbox-Line: From gregkh@clark.site Sat Sep 18 11:59:54 2010
Message-Id: <20100918185954.441670147@clark.site>
User-Agent: quilt/0.48-11.2
Date: Sat, 18 Sep 2010 11:57:43 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Dan Carpenter <error27@gmail.com>
Subject: [019/123] USB: ehci-ppc-of: problems in unwind
References: <20100918185724.290702750@clark.site>
Content-Disposition: inline; filename=usb-ehci-ppc-of-problems-in-unwind.patch
In-Reply-To: <20100918190024.GA14388@kroah.com>
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

---
 drivers/usb/host/ehci-ppc-of.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

--- a/drivers/usb/host/ehci-ppc-of.c
+++ b/drivers/usb/host/ehci-ppc-of.c
@@ -192,17 +192,19 @@ ehci_hcd_ppc_of_probe(struct of_device *
 	}
 
 	rv = usb_add_hcd(hcd, irq, 0);
-	if (rv == 0)
-		return 0;
+	if (rv)
+		goto err_ehci;
 
+	return 0;
+
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
 


