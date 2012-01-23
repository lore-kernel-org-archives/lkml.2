Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756130Ab2AWXt1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 18:49:27 -0500
Received: from cantor2.suse.de ([195.135.220.15]:42615 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756109Ab2AWXtV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 18:49:21 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Mon Jan 23 15:40:25 2012
Message-Id: <20120123234025.419550531@clark.kroah.org>
User-Agent: quilt/0.50-11.1
Date: Mon, 23 Jan 2012 15:39:15 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Bjorn Helgaas <bhelgaas@google.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: [29/90] PNP: work around Dell 1536/1546 BIOS MMCONFIG bug that breaks USB
In-Reply-To: <20120123234211.GA19504@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bjorn Helgaas <bhelgaas@google.com>

commit eb31aae8cb5eb54e234ed2d857ddac868195d911 upstream.

Some Dell BIOSes have MCFG tables that don't report the entire
MMCONFIG area claimed by the chipset.  If we move PCI devices into
that claimed-but-unreported area, they don't work.

This quirk reads the AMD MMCONFIG MSRs and adds PNP0C01 resources as
needed to cover the entire area.

Example problem scenario:

  BIOS-e820: 00000000cfec5400 - 00000000d4000000 (reserved)
  Fam 10h mmconf [d0000000, dfffffff]
  PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 0xd0000000-0xd3ffffff] (base 0xd0000000)
  pnp 00:0c: [mem 0xd0000000-0xd3ffffff]
  pci 0000:00:12.0: reg 10: [mem 0xffb00000-0xffb00fff]
  pci 0000:00:12.0: no compatible bridge window for [mem 0xffb00000-0xffb00fff]
  pci 0000:00:12.0: BAR 0: assigned [mem 0xd4000000-0xd40000ff]

Reported-by: Lisa Salimbas <lisa.salimbas@canonical.com>
Reported-by: <thuban@singularity.fr>
Tested-by: dann frazier <dann.frazier@canonical.com>
References: https://bugzilla.kernel.org/show_bug.cgi?id=31602
References: https://bugs.launchpad.net/ubuntu/+source/linux/+bug/647043
References: https://bugzilla.redhat.com/show_bug.cgi?id=770308
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/pnp/quirks.c |   42 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 42 insertions(+)

--- a/drivers/pnp/quirks.c
+++ b/drivers/pnp/quirks.c
@@ -295,6 +295,45 @@ static void quirk_system_pci_resources(s
 	}
 }
 
+#ifdef CONFIG_AMD_NB
+
+#include <asm/amd_nb.h>
+
+static void quirk_amd_mmconfig_area(struct pnp_dev *dev)
+{
+	resource_size_t start, end;
+	struct pnp_resource *pnp_res;
+	struct resource *res;
+	struct resource mmconfig_res, *mmconfig;
+
+	mmconfig = amd_get_mmconfig_range(&mmconfig_res);
+	if (!mmconfig)
+		return;
+
+	list_for_each_entry(pnp_res, &dev->resources, list) {
+		res = &pnp_res->res;
+		if (res->end < mmconfig->start || res->start > mmconfig->end ||
+		    (res->start == mmconfig->start && res->end == mmconfig->end))
+			continue;
+
+		dev_info(&dev->dev, FW_BUG
+			 "%pR covers only part of AMD MMCONFIG area %pR; adding more reservations\n",
+			 res, mmconfig);
+		if (mmconfig->start < res->start) {
+			start = mmconfig->start;
+			end = res->start - 1;
+			pnp_add_mem_resource(dev, start, end, 0);
+		}
+		if (mmconfig->end > res->end) {
+			start = res->end + 1;
+			end = mmconfig->end;
+			pnp_add_mem_resource(dev, start, end, 0);
+		}
+		break;
+	}
+}
+#endif
+
 /*
  *  PnP Quirks
  *  Cards or devices that need some tweaking due to incomplete resource info
@@ -322,6 +361,9 @@ static struct pnp_fixup pnp_fixups[] = {
 	/* PnP resources that might overlap PCI BARs */
 	{"PNP0c01", quirk_system_pci_resources},
 	{"PNP0c02", quirk_system_pci_resources},
+#ifdef CONFIG_AMD_NB
+	{"PNP0c01", quirk_amd_mmconfig_area},
+#endif
 	{""}
 };
 


