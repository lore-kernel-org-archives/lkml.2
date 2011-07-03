Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751916Ab1GCXZS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jul 2011 19:25:18 -0400
Received: from wnohang.net ([178.79.154.173]:38844 "EHLO mail.wnohang.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751318Ab1GCXZQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jul 2011 19:25:16 -0400
X-DKIM: Sendmail DKIM Filter v2.8.3 mail.wnohang.net 99A69F0008
X-DKIM: Sendmail DKIM Filter v2.8.3 mail.wnohang.net 05E2EF0003
Date: Mon, 4 Jul 2011 04:55:08 +0530
From: Raghavendra D Prabhu <rprabhu@wnohang.net>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: jeremy.fitzhardinge@citrix.com, xen-devel@lists.xensource.com,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] Modpost section mismatch fix
Message-ID: <20110703232508.GB4440@Xye>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="xXmbgvnjoT4axfJE"
Content-Disposition: inline
X-Operating-System: Arch linux x86_64 3.0.0-rc5-LYM
X-Editor: VIM - Vi IMproved 7.3
User-Agent: Mutt/1.5.21 (2010-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--xXmbgvnjoT4axfJE
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline

[Sorry if duplicate, one earlier was corrupt]

Hi,
     I got section mismatches reported by modpost in latest build. It got
     reported for xen_register_pirq and xen_unplug_emulated_devices
     functions. xen_register_pirq makes reference to
     acpi_sci_override_gsi in init.data section; marking
     xen_register_pirq with __init is not feasible since calls are made
     to it from acpi_register_gsi in non-init contexts. So marking it
     __refdata based on assumption that when acpi_sci_override_gsi is
     referenced, it is in  early stages where it is alive.


--------------------------
Raghavendra Prabhu
GPG Id : 0xD72BE977
Fingerprint: B93F EBCB 8E05 7039 CD3C A4B8 A616 DCA1 D72B E977
www: wnohang.net

--xXmbgvnjoT4axfJE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="0001-xen-pci-Fix-modpost-warnings-regarding-section-misma.patch"

>From 7dfd47575fd695fe8ddba951515cfac01a2ab8bc Mon Sep 17 00:00:00 2001
Message-Id: <7dfd47575fd695fe8ddba951515cfac01a2ab8bc.1309641255.git.rprabhu@wnohang.net>
From: Raghavendra D Prabhu <rprabhu@wnohang.net>
Date: Sun, 3 Jul 2011 01:48:50 +0530
Subject: [PATCH] xen/pci: Fix modpost warnings regarding section mismatch

Marking xen_register_pirq with __refdata since it is referencing
acpi_sci_override_gsi, an __initdata variable.  Removing __init from
check_platform_magic since it is called by xen_unplug_emulated_devices in
non-init contexts (It probably gets inlined because of
-finline-functions-called-once, removing __init is more to avoid mismatch being
reported).

Signed-off-by: Raghavendra D Prabhu <rprabhu@wnohang.net>
---
 arch/x86/pci/xen.c                 |    2 +-
 arch/x86/xen/platform-pci-unplug.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/pci/xen.c b/arch/x86/pci/xen.c
index fe00830..fb5eeb0 100644
--- a/arch/x86/pci/xen.c
+++ b/arch/x86/pci/xen.c
@@ -327,7 +327,7 @@ int __init pci_xen_hvm_init(void)
 }
 
 #ifdef CONFIG_XEN_DOM0
-static int xen_register_pirq(u32 gsi, int triggering)
+static  __refdata  int xen_register_pirq(u32 gsi, int triggering)
 {
 	int rc, pirq, irq = -1;
 	struct physdev_map_pirq map_irq;
diff --git a/arch/x86/xen/platform-pci-unplug.c b/arch/x86/xen/platform-pci-unplug.c
index 25c52f9..ffcf261 100644
--- a/arch/x86/xen/platform-pci-unplug.c
+++ b/arch/x86/xen/platform-pci-unplug.c
@@ -35,7 +35,7 @@ EXPORT_SYMBOL_GPL(xen_platform_pci_unplug);
 #ifdef CONFIG_XEN_PVHVM
 static int xen_emul_unplug;
 
-static int __init check_platform_magic(void)
+static int check_platform_magic(void)
 {
 	short magic;
 	char protocol;
-- 
1.7.6


--xXmbgvnjoT4axfJE--
