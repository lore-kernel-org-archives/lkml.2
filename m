Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757450Ab2EIGGe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 02:06:34 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:39177 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756058Ab2EIFxg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 01:53:36 -0400
Message-Id: <20120509055051.519471385@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Wed, 09 May 2012 06:53:08 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, David Vrabel <david.vrabel@citrix.com>,
        Jan Beulich <jbeulich@suse.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [ 159/167] [PATCH] xen/pci: dont use PCI BIOS service for configuration space
 accesses
In-Reply-To: <20120509055029.588587017@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Vrabel <david.vrabel@citrix.com>

commit 76a8df7b49168509df02461f83fab117a4a86e08 upstream.

The accessing PCI configuration space with the PCI BIOS32 service does
not work in PV guests.

On systems without MMCONFIG or where the BIOS hasn't marked the
MMCONFIG region as reserved in the e820 map, the BIOS service is
probed (even though direct access is preferred) and this hangs.

Acked-by: Jan Beulich <jbeulich@suse.com>
Signed-off-by: David Vrabel <david.vrabel@citrix.com>
[v1: Fixed compile error when CONFIG_PCI is not set]
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/x86/xen/enlighten.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- linux.orig/arch/x86/xen/enlighten.c
+++ linux/arch/x86/xen/enlighten.c
@@ -62,6 +62,7 @@
 #include <asm/reboot.h>
 #include <asm/stackprotector.h>
 #include <asm/hypervisor.h>
+#include <asm/pci_x86.h>
 
 #include "xen-ops.h"
 #include "mmu.h"
@@ -1278,8 +1279,10 @@
 		/* Make sure ACS will be enabled */
 		pci_request_acs();
 	}
-		
-
+#ifdef CONFIG_PCI
+	/* PCI BIOS service won't work from a PV guest. */
+	pci_probe &= ~PCI_PROBE_BIOS;
+#endif
 	xen_raw_console_write("about to get started...\n");
 
 	xen_setup_runstate_info(0);


