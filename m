Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759845Ab0GVVWL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 17:22:11 -0400
Received: from vms173013pub.verizon.net ([206.46.173.13]:63954 "EHLO
	vms173013pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751507Ab0GVVWI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 17:22:08 -0400
Date: Thu, 22 Jul 2010 17:21:42 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@localhost.localdomain
To: Andi Kleen <andi@firstfloor.org>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, "Yu, Luming" <luming.yu@intel.com>,
        Philip Langdale <philipl@overt.org>, Jeff Garrett <jeff@jgarrett.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "venki@google.com" <venki@google.com>
Subject: [PATCH] ACPI: skip checking BM_STS if the BIOS doesn't ask for it
In-reply-to: <alpine.LFD.2.00.1007221153120.3164@localhost.localdomain>
Message-id: <alpine.LFD.2.00.1007221720270.7970@localhost.localdomain>
References: <20100427124703.GA16706@jgarrett.org>
 <alpine.LFD.2.00.1004301218280.2489@sony>
 <20100430174447.GA14889@srcf.ucam.org>
 <d7f2dd35a4361e5156079278543769a0@localhost>
 <alpine.LFD.2.00.1005250125590.20648@localhost.localdomain>
 <CE761E84DADF2947A4AF22FB8D97A4731E0366B5@shsmsx501.ccr.corp.intel.com>
 <20100525124325.GC7876@srcf.ucam.org>
 <alpine.LFD.2.00.1005251114420.4114@localhost.localdomain>
 <20100525185507.GA15997@srcf.ucam.org>
 <alpine.LFD.2.00.1007211729550.409@localhost.localdomain>
 <20100722074750.GA22520@one.firstfloor.org>
 <alpine.LFD.2.00.1007221153120.3164@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Len Brown <len.brown@intel.com>

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
 arch/x86/kernel/acpi/cstate.c |    9 +++++++++
 drivers/acpi/processor_idle.c |    2 +-
 include/acpi/processor.h      |    3 ++-
 3 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/acpi/cstate.c b/arch/x86/kernel/acpi/cstate.c
index 2e837f5..fb7a5f0 100644
--- a/arch/x86/kernel/acpi/cstate.c
+++ b/arch/x86/kernel/acpi/cstate.c
@@ -145,6 +145,15 @@ int acpi_processor_ffh_cstate_probe(unsigned int cpu,
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
diff --git a/drivers/acpi/processor_idle.c b/drivers/acpi/processor_idle.c
index b1b3856..b351342 100644
--- a/drivers/acpi/processor_idle.c
+++ b/drivers/acpi/processor_idle.c
@@ -947,7 +947,7 @@ static int acpi_idle_enter_bm(struct cpuidle_device *dev,
 	if (acpi_idle_suspend)
 		return(acpi_idle_enter_c1(dev, state));
 
-	if (acpi_idle_bm_check()) {
+	if (!cx->bm_sts_skip && acpi_idle_bm_check()) {
 		if (dev->safe_state) {
 			dev->last_state = dev->safe_state;
 			return dev->safe_state->enter(dev, dev->safe_state);
diff --git a/include/acpi/processor.h b/include/acpi/processor.h
index da565a4..a68ca8a 100644
--- a/include/acpi/processor.h
+++ b/include/acpi/processor.h
@@ -48,7 +48,7 @@ struct acpi_power_register {
 	u8 space_id;
 	u8 bit_width;
 	u8 bit_offset;
-	u8 reserved;
+	u8 access_size;
 	u64 address;
 } __attribute__ ((packed));
 
@@ -63,6 +63,7 @@ struct acpi_processor_cx {
 	u32 power;
 	u32 usage;
 	u64 time;
+	u8 bm_sts_skip;
 	char desc[ACPI_CX_DESC_LEN];
 };
 
-- 
1.7.2

