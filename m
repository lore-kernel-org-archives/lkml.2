Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760260Ab2EJRdp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 13:33:45 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:58653 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760230Ab2EJRdk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 13:33:40 -0400
Message-Id: <20120510173133.420776202@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Thu, 10 May 2012 10:31:37 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Jan Beulich <jbeulich@suse.com>,
        David Vrabel <david.vrabel@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [ 05/52] xen/pci: dont use PCI BIOS service for configuration space accesses
In-Reply-To: <20120510173229.GA5678@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/xen/enlighten.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -62,6 +62,7 @@
 #include <asm/reboot.h>
 #include <asm/stackprotector.h>
 #include <asm/hypervisor.h>
+#include <asm/pci_x86.h>
 
 #include "xen-ops.h"
 #include "mmu.h"
@@ -1274,8 +1275,10 @@ asmlinkage void __init xen_start_kernel(
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


