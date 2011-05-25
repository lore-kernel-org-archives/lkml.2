Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750993Ab1EYEBI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 00:01:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13593 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750706Ab1EYEBH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 00:01:07 -0400
From: Dave Airlie <airlied@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: jbarnes@virtuousgeek.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, Dave Airlie <airlied@redhat.com>
Subject: [PATCH] uv/x2apic: update for change in pci bridge handling.
Date: Wed, 25 May 2011 14:00:49 +1000
Message-Id: <1306296049-11797-1-git-send-email-airlied@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dave Airlie <airlied@redhat.com>

I forgot about the special uv handling code for this, so this
patch fixes it up.

Signed-off-by: Dave Airlie <airlied@redhat.com>
---
 arch/x86/kernel/apic/x2apic_uv_x.c |    8 ++++----
 drivers/pci/pci.c                  |    4 ++--
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/apic/x2apic_uv_x.c b/arch/x86/kernel/apic/x2apic_uv_x.c
index 33b10a0..185cd1e 100644
--- a/arch/x86/kernel/apic/x2apic_uv_x.c
+++ b/arch/x86/kernel/apic/x2apic_uv_x.c
@@ -599,14 +599,14 @@ late_initcall(uv_init_heartbeat);
 
 /* Direct Legacy VGA I/O traffic to designated IOH */
 int uv_set_vga_state(struct pci_dev *pdev, bool decode,
-		      unsigned int command_bits, bool change_bridge)
+		      unsigned int command_bits, u32 flags)
 {
 	int domain, bus, rc;
 
-	PR_DEVEL("devfn %x decode %d cmd %x chg_brdg %d\n",
-			pdev->devfn, decode, command_bits, change_bridge);
+	PR_DEVEL("devfn %x decode %d cmd %x flags %d\n",
+			pdev->devfn, decode, command_bits, flags);
 
-	if (!change_bridge)
+	if (!(flags & PCI_VGA_STATE_CHANGE_BRIDGE))
 		return 0;
 
 	if ((command_bits & PCI_COMMAND_IO) == 0)
diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index a339237..4528ee7 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -2862,11 +2862,11 @@ void __init pci_register_set_vga_state(arch_set_vga_state_t func)
 }
 
 static int pci_set_vga_state_arch(struct pci_dev *dev, bool decode,
-		      unsigned int command_bits, bool change_bridge)
+		      unsigned int command_bits, u32 flags)
 {
 	if (arch_set_vga_state)
 		return arch_set_vga_state(dev, decode, command_bits,
-						change_bridge);
+						flags);
 	return 0;
 }
 
-- 
1.7.1

