Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753137Ab1AONUE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Jan 2011 08:20:04 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:38368 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752911Ab1AONUB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Jan 2011 08:20:01 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: linux-next: build failure after merge of the final tree (linus' tree related)
Date: Sat, 15 Jan 2011 14:19:16 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37+; KDE/4.4.4; x86_64; ; )
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ozan Caglayan <ozan@pardus.org.tr>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Linus <torvalds@linux-foundation.org>
References: <20110115133412.58b8cd89.sfr@canb.auug.org.au>
In-Reply-To: <20110115133412.58b8cd89.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201101151419.16758.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, January 15, 2011, Stephen Rothwell wrote:
> Hi all,
> 
> After merging the final tree, today's linux-next build (powerpc
> allyesconfig) failed like this:
> 
> In file included from drivers/pci/pcie/aer/aerdrv.c:20:
> include/linux/pci-acpi.h:39: error: expected '=', ',', ';', 'asm' or '__attribute__' before 'acpi_find_root_bridge_handle'
> 
> Caused by commit 415e12b2379239973feab91850b0dce985c6058a ("PCI/ACPI:
> Request _OSC control once for each root bridge (v3)").  (Yet another
> patch not seen in linux-next until merged into Linus' tree.  In this case
> the breakage was not seen because the new part of the pci tree was
> excluded from linux-next for several days because of another commit that
> broke my builds.

Ah.  I thought it was in linux-next. :-(

> That other commit was only excluded from the pci tree
> just before being sent to Linus :-()
> 
> This is the non CONFIG_ACPI version of acpi_find_root_bridge_handle()
> which returns an acpi_handle.  pci-acpi.h is now always included in
> drivers/pci/pcie/aer/aerdrv.c.
> 
> I tried ifef'ing out the inclusion of pci-acpi.h, but that only made
> matters worse.  I have just left it for today.  Please fix.

It looks like the non-CONFIG_ACPI version of acpi_find_root_bridge_handle()
is just not necessary any more, because acpi_find_root_bridge_handle() is only
used in code that depends on CONFIG_ACPI.

A patch removing it is appended, please test.

Thanks,
Rafael

---
 include/linux/pci-acpi.h |    3 ---
 1 file changed, 3 deletions(-)

Index: linux-2.6/include/linux/pci-acpi.h
===================================================================
--- linux-2.6.orig/include/linux/pci-acpi.h
+++ linux-2.6/include/linux/pci-acpi.h
@@ -35,9 +35,6 @@ static inline acpi_handle acpi_pci_get_b
 	return acpi_get_pci_rootbridge_handle(pci_domain_nr(pbus),
 					      pbus->number);
 }
-#else
-static inline acpi_handle acpi_find_root_bridge_handle(struct pci_dev *pdev)
-{ return NULL; }
 #endif
 
 #ifdef CONFIG_ACPI_APEI
