Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753451Ab0GZXv4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jul 2010 19:51:56 -0400
Received: from vms173003pub.verizon.net ([206.46.173.3]:56379 "EHLO
	vms173003pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752411Ab0GZXvy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jul 2010 19:51:54 -0400
Date: Mon, 26 Jul 2010 19:51:29 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@localhost.localdomain
To: stable@kernel.org
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-acpi@vger.kernel.org
Subject: [PATCH 2.6.{32, 33, 34}.stable] ACPI: skip checking BM_STS if the BIOS
 doesn't ask for it
Message-id: <alpine.LFD.2.00.1007261945260.5292@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Len Brown <len.brown@intel.com>

upstream 718be4aaf3613cf7c2d097f925abc3d3553c0605

It turns out that there is a bit in the _CST for Intel FFH C3
that tells the OS if we should be checking BM_STS or not.

Linux has been unconditionally checking BM_STS.
If the chip-set is configured to enable BM_STS,
it can retard or completely prevent entry into
deep C-states -- as illustrated by turbostat:

http://userweb.kernel.org/~lenb/acpi/utils/pmtools/turbostat/

ref: Intel Processor Vendor-Specific ACPI Interface Specification
table 4 "_CST FFH GAS Field Encoding"
Bit 1: Set to 1 if OSPM should use Bus Master avoidance for this C-state

https://bugzilla.kernel.org/show_bug.cgi?id=15886

Signed-off-by: Len Brown <len.brown@intel.com>
---

this backport applies cleanly to 2.6.32.y.
It applies w/ a small offset to 2.6.33.y and 2.34.y


 arch/x86/kernel/acpi/cstate.c |    9 +++++++++
 drivers/acpi/processor_idle.c |    2 +-
 include/acpi/processor.h      |    3 ++-
 3 files changed, 12 insertions(+), 2 deletions(-)

Index: linux-2.6.32.y/arch/x86/kernel/acpi/cstate.c
===================================================================
--- linux-2.6.32.y.orig/arch/x86/kernel/acpi/cstate.c
+++ linux-2.6.32.y/arch/x86/kernel/acpi/cstate.c
@@ -145,6 +145,15 @@ int acpi_processor_ffh_cstate_probe(unsi
 		percpu_entry->states[cx->index].eax = cx->address;
 		percpu_entry->states[cx->index].ecx = MWAIT_ECX_INTERRUPT_BREAK;
 	}
+
+	/*
+	 * For _CST FFH on Intel, if GAS.access_size bit 1 is cleared,
+	 * then we should skip checking BM_STS for this C-state.
+	 * ref: "Intel Processor Vendor-Specific ACPI Interface Specification"
+	 */
+	if ((c->x86_vendor == X86_VENDOR_INTEL) && !(reg->access_size & 0x2))
+		cx->bm_sts_skip = 1;
+
 	return retval;
 }
 EXPORT_SYMBOL_GPL(acpi_processor_ffh_cstate_probe);
Index: linux-2.6.32.y/drivers/acpi/processor_idle.c
===================================================================
--- linux-2.6.32.y.orig/drivers/acpi/processor_idle.c
+++ linux-2.6.32.y/drivers/acpi/processor_idle.c
@@ -962,7 +962,7 @@ static int acpi_idle_enter_bm(struct cpu
 	if (acpi_idle_suspend)
 		return(acpi_idle_enter_c1(dev, state));
 
-	if (acpi_idle_bm_check()) {
+	if (!cx->bm_sts_skip && acpi_idle_bm_check()) {
 		if (dev->safe_state) {
 			dev->last_state = dev->safe_state;
 			return dev->safe_state->enter(dev, dev->safe_state);
Index: linux-2.6.32.y/include/acpi/processor.h
===================================================================
--- linux-2.6.32.y.orig/include/acpi/processor.h
+++ linux-2.6.32.y/include/acpi/processor.h
@@ -48,7 +48,7 @@ struct acpi_power_register {
 	u8 space_id;
 	u8 bit_width;
 	u8 bit_offset;
-	u8 reserved;
+	u8 access_size;
 	u64 address;
 } __attribute__ ((packed));
 
@@ -74,6 +74,7 @@ struct acpi_processor_cx {
 	u32 power;
 	u32 usage;
 	u64 time;
+	u8 bm_sts_skip;
 	struct acpi_processor_cx_policy promotion;
 	struct acpi_processor_cx_policy demotion;
 	char desc[ACPI_CX_DESC_LEN];
