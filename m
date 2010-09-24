Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933104Ab0IXQhl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 12:37:41 -0400
Received: from kroah.org ([198.145.64.141]:37451 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933148Ab0IXQf5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 12:35:57 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Sep 24 09:33:49 2010
Message-Id: <20100924163349.429885482@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 24 Sep 2010 09:32:25 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Ben Hutchings <ben@decadent.org.uk>, linux-mips@linux-mips.org,
        Martin Michlmayr <tbm@cyrius.com>,
        Aurelien Jarno <aurelien@aurel32.net>, 584784@bugs.debian.org,
        Ralf Baechle <ralf@linux-mips.org>
Subject: [61/68] MIPS: Set io_map_base for several PCI bridges lacking it
In-Reply-To: <20100924163357.GA15741@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Ben Hutchings <ben@decadent.org.uk>

commit 8faf2e6c201d95b780cd3b4674b7a55ede6dcbbb upstream.

Several MIPS platforms don't set pci_controller::io_map_base for their
PCI bridges.  This results in a panic in pci_iomap().  (The panic is
conditional on CONFIG_PCI_DOMAINS, but that is now enabled for all PCI
MIPS systems.)

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Cc: linux-mips@linux-mips.org
Cc: Martin Michlmayr <tbm@cyrius.com>
Cc: Aurelien Jarno <aurelien@aurel32.net>
Cc: 584784@bugs.debian.org
Patchwork: https://patchwork.linux-mips.org/patch/1377/
Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/mips/mti-malta/malta-pci.c      |    2 ++
 arch/mips/nxp/pnx8550/common/pci.c   |    1 +
 arch/mips/nxp/pnx8550/common/setup.c |    2 +-
 arch/mips/pci/ops-pmcmsp.c           |    1 +
 arch/mips/pci/pci-yosemite.c         |    1 +
 5 files changed, 6 insertions(+), 1 deletion(-)

--- a/arch/mips/mti-malta/malta-pci.c
+++ b/arch/mips/mti-malta/malta-pci.c
@@ -247,6 +247,8 @@ void __init mips_pcibios_init(void)
 	iomem_resource.end &= 0xfffffffffULL;			/* 64 GB */
 	ioport_resource.end = controller->io_resource->end;
 
+	controller->io_map_base = mips_io_port_base;
+
 	register_pci_controller(controller);
 }
 
--- a/arch/mips/nxp/pnx8550/common/pci.c
+++ b/arch/mips/nxp/pnx8550/common/pci.c
@@ -44,6 +44,7 @@ extern struct pci_ops pnx8550_pci_ops;
 
 static struct pci_controller pnx8550_controller = {
 	.pci_ops	= &pnx8550_pci_ops,
+	.io_map_base	= PNX8550_PORT_BASE,
 	.io_resource	= &pci_io_resource,
 	.mem_resource	= &pci_mem_resource,
 };
--- a/arch/mips/nxp/pnx8550/common/setup.c
+++ b/arch/mips/nxp/pnx8550/common/setup.c
@@ -113,7 +113,7 @@ void __init plat_mem_setup(void)
 	PNX8550_GLB2_ENAB_INTA_O = 0;
 
 	/* IO/MEM resources. */
-	set_io_port_base(KSEG1);
+	set_io_port_base(PNX8550_PORT_BASE);
 	ioport_resource.start = 0;
 	ioport_resource.end = ~0;
 	iomem_resource.start = 0;
--- a/arch/mips/pci/ops-pmcmsp.c
+++ b/arch/mips/pci/ops-pmcmsp.c
@@ -944,6 +944,7 @@ static struct pci_controller msp_pci_con
 	.pci_ops	= &msp_pci_ops,
 	.mem_resource	= &pci_mem_resource,
 	.mem_offset	= 0,
+	.io_map_base	= MSP_PCI_IOSPACE_BASE,
 	.io_resource	= &pci_io_resource,
 	.io_offset	= 0
 };
--- a/arch/mips/pci/pci-yosemite.c
+++ b/arch/mips/pci/pci-yosemite.c
@@ -54,6 +54,7 @@ static int __init pmc_yosemite_setup(voi
 		panic(ioremap_failed);
 
 	set_io_port_base(io_v_base);
+	py_controller.io_map_base = io_v_base;
 	TITAN_WRITE(RM9000x2_OCD_LKM7, TITAN_READ(RM9000x2_OCD_LKM7) | 1);
 
 	ioport_resource.end = TITAN_IO_SIZE - 1;


