Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932313Ab2BXDwo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 22:52:44 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:37316 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755472Ab2BXDtn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 22:49:43 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [PATCH 07/13] x86, irq: more strict check for register ioapic
Date: Thu, 23 Feb 2012 19:48:53 -0800
Message-Id: <1330055339-11662-8-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1330055339-11662-1-git-send-email-yinghai@kernel.org>
References: <1330055339-11662-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
X-CT-RefId: str=0001.0A090204.4F4708C7.009E,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

1. check overlaping gsi range
for hotplug ioapic case, BIOS may have some entries in MADT
and also in pci bus with _GSB.

2. make bad_ioapics take idx instead of nr_ioapics.
for hotadd ioapic could find spare slot in the middle later.

3. check if entries in right range.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>
---
 arch/x86/kernel/apic/io_apic.c |   19 ++++++++++++++-----
 1 files changed, 14 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 527b184..57ffa86 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -4065,11 +4065,11 @@ int mp_find_ioapic_pin(int ioapic, u32 gsi)
 	return gsi - gsi_cfg->gsi_base;
 }
 
-static __init int bad_ioapic(unsigned long address)
+static __init int bad_ioapic(int idx, unsigned long address)
 {
-	if (nr_ioapics >= MAX_IO_APICS) {
+	if (idx >= MAX_IO_APICS) {
 		printk(KERN_WARNING "WARNING: Max # of I/O APICs (%d) exceeded "
-		       "(found %d), skipping\n", MAX_IO_APICS, nr_ioapics);
+		       "(found %d), skipping\n", MAX_IO_APICS, idx);
 		return 1;
 	}
 	if (!address) {
@@ -4082,14 +4082,17 @@ static __init int bad_ioapic(unsigned long address)
 
 void __init mp_register_ioapic(int id, u32 address, u32 gsi_base)
 {
-	int idx = 0;
+	int idx;
 	int entries;
 	struct mp_ioapic_gsi *gsi_cfg;
 
-	if (bad_ioapic(address))
+	idx = mp_find_ioapic(gsi_base);
+	if (idx >= 0)
 		return;
 
 	idx = nr_ioapics;
+	if (bad_ioapic(idx, address))
+		return;
 
 	ioapics[idx].mp_config.type = MP_IOAPIC;
 	ioapics[idx].mp_config.flags = MPC_APIC_USABLE;
@@ -4104,6 +4107,12 @@ void __init mp_register_ioapic(int id, u32 address, u32 gsi_base)
 	 * and to prevent reprogramming of IOAPIC pins (PCI GSIs).
 	 */
 	entries = io_apic_get_redir_entries(idx);
+
+	if (!entries || entries > MP_MAX_IOAPIC_PIN) {
+		clear_fixmap(FIX_IO_APIC_BASE_0 + idx);
+		return;
+	}
+
 	gsi_cfg = mp_ioapic_gsi_routing(idx);
 	gsi_cfg->gsi_base = gsi_base;
 	gsi_cfg->gsi_end = gsi_base + entries - 1;
-- 
1.7.7

