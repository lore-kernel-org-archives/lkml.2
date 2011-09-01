Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757481Ab1IACgZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 22:36:25 -0400
Received: from mga03.intel.com ([143.182.124.21]:36073 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757441Ab1IACgX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 22:36:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,310,1312182000"; 
   d="scan'208";a="13067032"
Subject: [PATCH] EFI: Revert "x86: Serialize EFI time accesses on rtc_lock"
From: Zhang Rui <rui.zhang@intel.com>
To: jbeulich@novell.com
Cc: LKML <linux-kernel@vger.kernel.org>, Matthew Garrett <mjg59@srcf.ucam.org>,
        "Zhang, Rui" <rui.zhang@intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 01 Sep 2011 10:36:16 +0800
Message-ID: <1314844576.26340.10.camel@rui>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

My kernel freezes during boot with the following log.
I'm not sure what the problem is, but reverting 
ef68c8f87ed13f65df867dddf36c0e185b27b942 does help.

>From 887ff758774df22af42cf7246d09222d5f9b3de2 Mon Sep 17 00:00:00 2001
From: Zhang Rui <rui.zhang@intel.com>
Date: Thu, 1 Sep 2011 10:07:44 +0800
Subject: [PATCH] Revert "x86: Serialize EFI time accesses on rtc_lock"

This reverts commit ef68c8f87ed13f65df867dddf36c0e185b27b942.

[    0.000000] BUG: spinlock recursion on CPU#0, swapper/0
[    0.000000]  lock: c18abfa0, .magic: dead4ead, .owner: swapper/0, .owner_cpu:
 0
[    0.000000] Pid: 0, comm: swapper Not tainted 3.1.0-rc3-acpi-0831 #56
[    0.000000] Call Trace:
[    0.000000]  [<c1645d28>] ? printk+0x19/0x1b
[    0.000000]  [<c1295674>] spin_bug+0xa4/0xf0
[    0.000000]  [<c12957cd>] do_raw_spin_lock+0x10d/0x160
[    0.000000]  [<c1648ed8>] _raw_spin_lock_irqsave+0x18/0x20
[    0.000000]  [<c1921e6a>] phys_efi_get_time+0x18/0x52
[    0.000000]  [<c102a744>] efi_get_time+0x14/0x60
[    0.000000]  [<c1077afb>] ? mutex_remove_waiter+0x3b/0x100
[    0.000000]  [<c1647bcc>] ? __mutex_lock_slowpath+0x1bc/0x280
[    0.000000]  [<c1648ed8>] ? _raw_spin_lock_irqsave+0x18/0x20
[    0.000000]  [<c1008fb6>] read_persistent_clock+0x26/0x50
[    0.000000]  [<c1925845>] timekeeping_init+0x11/0xcd
[    0.000000]  [<c10487ad>] ? cpu_maps_update_done+0xd/0x30
[    0.000000]  [<c162d33e>] ? register_cpu_notifier+0x1e/0x30
[    0.000000]  [<c1924934>] ? softirq_init+0x6f/0x8e
[    0.000000]  [<c1910607>] start_kernel+0x1c4/0x2f2
[    0.000000]  [<c19101c7>] ? loglevel+0x1b/0x1b
[    0.000000]  [<c19100bf>] i386_start_kernel+0xbf/0xc8
[    0.000000] BUG: spinlock lockup on CPU#0, swapper/0, c18abfa0
[    0.000000] Pid: 0, comm: swapper Not tainted 3.1.0-rc3-acpi-0831 #56
[    0.000000] Call Trace:
[    0.000000]  [<c1645d28>] ? printk+0x19/0x1b
[    0.000000]  [<c1295805>] do_raw_spin_lock+0x145/0x160
[    0.000000]  [<c1648ed8>] _raw_spin_lock_irqsave+0x18/0x20
[    0.000000]  [<c1921e6a>] phys_efi_get_time+0x18/0x52
[    0.000000]  [<c102a744>] efi_get_time+0x14/0x60
[    0.000000]  [<c1077afb>] ? mutex_remove_waiter+0x3b/0x100
[    0.000000]  [<c1647bcc>] ? __mutex_lock_slowpath+0x1bc/0x280
[    0.000000]  [<c1648ed8>] ? _raw_spin_lock_irqsave+0x18/0x20
[    0.000000]  [<c1008fb6>] read_persistent_clock+0x26/0x50
[    0.000000]  [<c1925845>] timekeeping_init+0x11/0xcd
[    0.000000]  [<c10487ad>] ? cpu_maps_update_done+0xd/0x30
[    0.000000]  [<c162d33e>] ? register_cpu_notifier+0x1e/0x30
[    0.000000]  [<c1924934>] ? softirq_init+0x6f/0x8e
[    0.000000]  [<c1910607>] start_kernel+0x1c4/0x2f2
[    0.000000]  [<c19101c7>] ? loglevel+0x1b/0x1b
[    0.000000]  [<c19100bf>] i386_start_kernel+0xbf/0xc8
---
 arch/x86/platform/efi/efi.c |   39 ++++++---------------------------------
 1 files changed, 6 insertions(+), 33 deletions(-)

diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index cebdab8..b416526 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -90,50 +90,26 @@ early_param("add_efi_memmap", setup_add_efi_memmap);
 
 static efi_status_t virt_efi_get_time(efi_time_t *tm, efi_time_cap_t *tc)
 {
-	unsigned long flags;
-	efi_status_t status;
-
-	spin_lock_irqsave(&rtc_lock, flags);
-	status = efi_call_virt2(get_time, tm, tc);
-	spin_unlock_irqrestore(&rtc_lock, flags);
-	return status;
+	return efi_call_virt2(get_time, tm, tc);
 }
 
 static efi_status_t virt_efi_set_time(efi_time_t *tm)
 {
-	unsigned long flags;
-	efi_status_t status;
-
-	spin_lock_irqsave(&rtc_lock, flags);
-	status = efi_call_virt1(set_time, tm);
-	spin_unlock_irqrestore(&rtc_lock, flags);
-	return status;
+	return efi_call_virt1(set_time, tm);
 }
 
 static efi_status_t virt_efi_get_wakeup_time(efi_bool_t *enabled,
 					     efi_bool_t *pending,
 					     efi_time_t *tm)
 {
-	unsigned long flags;
-	efi_status_t status;
-
-	spin_lock_irqsave(&rtc_lock, flags);
-	status = efi_call_virt3(get_wakeup_time,
-				enabled, pending, tm);
-	spin_unlock_irqrestore(&rtc_lock, flags);
-	return status;
+	return efi_call_virt3(get_wakeup_time,
+			      enabled, pending, tm);
 }
 
 static efi_status_t virt_efi_set_wakeup_time(efi_bool_t enabled, efi_time_t *tm)
 {
-	unsigned long flags;
-	efi_status_t status;
-
-	spin_lock_irqsave(&rtc_lock, flags);
-	status = efi_call_virt2(set_wakeup_time,
-				enabled, tm);
-	spin_unlock_irqrestore(&rtc_lock, flags);
-	return status;
+	return efi_call_virt2(set_wakeup_time,
+			      enabled, tm);
 }
 
 static efi_status_t virt_efi_get_variable(efi_char16_t *name,
@@ -233,14 +209,11 @@ static efi_status_t __init phys_efi_set_virtual_address_map(
 static efi_status_t __init phys_efi_get_time(efi_time_t *tm,
 					     efi_time_cap_t *tc)
 {
-	unsigned long flags;
 	efi_status_t status;
 
-	spin_lock_irqsave(&rtc_lock, flags);
 	efi_call_phys_prelog();
 	status = efi_call_phys2(efi_phys.get_time, tm, tc);
 	efi_call_phys_epilog();
-	spin_unlock_irqrestore(&rtc_lock, flags);
 	return status;
 }
 
-- 
1.7.1



