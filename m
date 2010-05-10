Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757733Ab0EJXMt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 19:12:49 -0400
Received: from kroah.org ([198.145.64.141]:45348 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932931Ab0EJW62 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 18:58:28 -0400
X-Mailbox-Line: From gregkh@kvm.kroah.org Mon May 10 15:35:41 2010
Message-Id: <20100510223541.420401073@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Mon, 10 May 2010 15:35:30 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Carlos ODonell <carlos@codesourcery.com>,
       Kyle McMartin <kyle@redhat.com>
Subject: [78/98] parisc: Set PCI CLS early in boot.
In-Reply-To: <20100510223714.GA18416@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Carlos O'Donell <carlos@codesourcery.com>

commit 5fd4514bb351b5ecb0da3692fff70741e5ed200c upstream.

Set the PCI CLS early in the boot process to prevent
device failures. In pcibios_set_master use the new
pci_cache_line_size instead of a hard-coded value.

Signed-off-by: Carlos O'Donell <carlos@codesourcery.com>
Reviewed-by: Grant Grundler <grundler@google.com>
Signed-off-by: Kyle McMartin <kyle@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/parisc/kernel/pci.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/arch/parisc/kernel/pci.c
+++ b/arch/parisc/kernel/pci.c
@@ -18,7 +18,6 @@
 
 #include <asm/io.h>
 #include <asm/system.h>
-#include <asm/cache.h>		/* for L1_CACHE_BYTES */
 #include <asm/superio.h>
 
 #define DEBUG_RESOURCES 0
@@ -123,6 +122,10 @@ static int __init pcibios_init(void)
 	} else {
 		printk(KERN_WARNING "pci_bios != NULL but init() is!\n");
 	}
+
+	/* Set the CLS for PCI as early as possible. */
+	pci_cache_line_size = pci_dfl_cache_line_size;
+
 	return 0;
 }
 
@@ -171,7 +174,7 @@ void pcibios_set_master(struct pci_dev *
 	** upper byte is PCI_LATENCY_TIMER.
 	*/
 	pci_write_config_word(dev, PCI_CACHE_LINE_SIZE,
-				(0x80 << 8) | (L1_CACHE_BYTES / sizeof(u32)));
+			      (0x80 << 8) | pci_cache_line_size);
 }
 
 


