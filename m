Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758572Ab2EDOK3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 10:10:29 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:39912 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751585Ab2EDOK1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 10:10:27 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org
Cc: David Vrabel <david.vrabel@citrix.com>, stable@kernel.org,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 4/4] xen/pci: don't use PCI BIOS service for configuration space accesses
Date: Fri,  4 May 2012 10:04:27 -0400
Message-Id: <1336140267-7399-5-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.7.5
In-Reply-To: <1336140267-7399-1-git-send-email-konrad.wilk@oracle.com>
References: <1336140267-7399-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Vrabel <david.vrabel@citrix.com>

The accessing PCI configuration space with the PCI BIOS32 service does
not work in PV guests.

On systems without MMCONFIG or where the BIOS hasn't marked the
MMCONFIG region as reserved in the e820 map, the BIOS service is
probed (even though direct access is preferred) and this hangs.

CC: stable@kernel.org
Acked-by: Jan Beulich <jbeulich@suse.com>
Signed-off-by: David Vrabel <david.vrabel@citrix.com>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/x86/xen/enlighten.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index 4f437de..fbf9a75 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -63,6 +63,7 @@
 #include <asm/stackprotector.h>
 #include <asm/hypervisor.h>
 #include <asm/mwait.h>
+#include <asm/pci_x86.h>
 
 #ifdef CONFIG_ACPI
 #include <linux/acpi.h>
@@ -1398,7 +1399,9 @@ asmlinkage void __init xen_start_kernel(void)
 		/* Make sure ACS will be enabled */
 		pci_request_acs();
 	}
-		
+
+	/* PCI BIOS service won't work from a PV guest. */
+	pci_probe &= ~PCI_PROBE_BIOS;
 
 	xen_raw_console_write("about to get started...\n");
 
-- 
1.7.7.5

