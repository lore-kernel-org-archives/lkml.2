Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753761Ab0KBWrV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Nov 2010 18:47:21 -0400
Received: from cantor2.suse.de ([195.135.220.15]:37793 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751355Ab0KBWrU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Nov 2010 18:47:20 -0400
Date: Tue, 2 Nov 2010 23:47:18 +0100
From: David Sterba <dsterba@suse.cz>
To: linux-usb@vger.kernel.org
Cc: sarah.a.sharp@linux.intel.com, linux-kernel@vger.kernel.org
Subject: [PATCH] USB: xhci: Use GFP_ATOMIC under spin_lock
Message-ID: <20101102224718.GB27513@ds.suse.cz>
Reply-To: dsterba@suse.cz
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

coccinelle check scripts/coccinelle/locks/call_kern.cocci found that
in drivers/usb/host/xhci.c an allocation with GFP_KERNEL is done
with locks held:

xhci_resume
  spin_lock_irq(xhci->lock)
    xhci_setup_msix
      kmalloc(GFP_KERNEL)

Change it to GFP_ATOMIC.

Signed-off-by: David Sterba <dsterba@suse.cz>
CC: Sarah Sharp <sarah.a.sharp@linux.intel.com>

---
Exists in v2.6.37-rc1 and current linux-next

diff -u -p a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
--- a/drivers/usb/host/xhci.c 2010-10-27 11:27:23.534310054 +0200
+++ b/drivers/usb/host/xhci.c 2010-11-02 15:53:03.000000000 +0100
@@ -240,7 +240,7 @@ static int xhci_setup_msix(struct xhci_h

        xhci->msix_entries =
                kmalloc((sizeof(struct msix_entry))*xhci->msix_count,
-                               GFP_KERNEL);
+                               GFP_ATOMIC);
        if (!xhci->msix_entries) {
                xhci_err(xhci, "Failed to allocate MSI-X entries\n");
                return -ENOMEM;

