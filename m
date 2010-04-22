Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757372Ab0DVToG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 15:44:06 -0400
Received: from kroah.org ([198.145.64.141]:41246 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756705Ab0DVT3S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 15:29:18 -0400
X-Mailbox-Line: From gregkh@kvm.kroah.org Thu Apr 22 12:09:19 2010
Message-Id: <20100422190919.396816185@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Thu, 22 Apr 2010 12:09:46 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Mike Travis <travis@sgi.com>, Thomas Gleixner <tglx@linutronix.de>,
       Robin Holt <holt@sgi.com>, Jack Steiner <steiner@sgi.com>,
       Ingo Molnar <mingo@elte.hu>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       David Airlie <airlied@linux.ie>, "H. Peter Anvin" <hpa@zytor.com>,
       maximilian attems <max@stro.at>
Subject: [135/197] vgaarb: Fix VGA arbiter to accept PCI domains other than 0
In-Reply-To: <20100422191857.GA13268@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Mike Travis <travis@sgi.com>

commit 773a38dbdad03474c5ee235f7d9bf9f51c9e3c2b upstream.

Update the VGA Arbiter to accept PCI Domains other than 0.

Signed-off-by: Mike Travis <travis@sgi.com>
LKML-Reference: <201002022238.o12McFe8018730@imap1.linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Robin Holt <holt@sgi.com>
Cc: Jack Steiner <steiner@sgi.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: David Airlie <airlied@linux.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Cc: maximilian attems <max@stro.at>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/vga/vgaarb.c |   23 +++++++++++++++++++----
 1 file changed, 19 insertions(+), 4 deletions(-)

--- a/drivers/gpu/vga/vgaarb.c
+++ b/drivers/gpu/vga/vgaarb.c
@@ -954,6 +954,7 @@ static ssize_t vga_arb_write(struct file
 		}
 
 	} else if (strncmp(curr_pos, "target ", 7) == 0) {
+		struct pci_bus *pbus;
 		unsigned int domain, bus, devfn;
 		struct vga_device *vgadev;
 
@@ -969,18 +970,31 @@ static ssize_t vga_arb_write(struct file
 				ret_val = -EPROTO;
 				goto done;
 			}
+			pr_devel("vgaarb: %s ==> %x:%x:%x.%x\n", curr_pos,
+				domain, bus, PCI_SLOT(devfn), PCI_FUNC(devfn));
 
-			pdev = pci_get_bus_and_slot(bus, devfn);
+			pbus = pci_find_bus(domain, bus);
+			pr_devel("vgaarb: pbus %p\n", pbus);
+			if (pbus == NULL) {
+				pr_err("vgaarb: invalid PCI domain and/or bus address %x:%x\n",
+					domain, bus);
+				ret_val = -ENODEV;
+				goto done;
+			}
+			pdev = pci_get_slot(pbus, devfn);
+			pr_devel("vgaarb: pdev %p\n", pdev);
 			if (!pdev) {
-				pr_info("vgaarb: invalid PCI address!\n");
+				pr_err("vgaarb: invalid PCI address %x:%x\n",
+					bus, devfn);
 				ret_val = -ENODEV;
 				goto done;
 			}
 		}
 
 		vgadev = vgadev_find(pdev);
+		pr_devel("vgaarb: vgadev %p\n", vgadev);
 		if (vgadev == NULL) {
-			pr_info("vgaarb: this pci device is not a vga device\n");
+			pr_err("vgaarb: this pci device is not a vga device\n");
 			pci_dev_put(pdev);
 			ret_val = -ENODEV;
 			goto done;
@@ -998,7 +1012,8 @@ static ssize_t vga_arb_write(struct file
 			}
 		}
 		if (i == MAX_USER_CARDS) {
-			pr_err("vgaarb: maximum user cards number reached!\n");
+			pr_err("vgaarb: maximum user cards (%d) number reached!\n",
+				MAX_USER_CARDS);
 			pci_dev_put(pdev);
 			/* XXX: which value to return? */
 			ret_val =  -ENOMEM;


