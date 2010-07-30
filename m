Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759588Ab0G3SLt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 14:11:49 -0400
Received: from kroah.org ([198.145.64.141]:59112 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932725Ab0G3R5Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 13:57:24 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Jul 30 10:51:49 2010
Message-Id: <20100730175148.933166698@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 30 Jul 2010 10:53:02 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Len Brown <len.brown@intel.com>
Subject: [165/205] ACPI: skip checking BM_STS if the BIOS doesnt ask for it
In-Reply-To: <20100730175238.GA3924@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.34-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Len Brown <len.brown@intel.com>

commit 718be4aaf3613cf7c2d097f925abc3d3553c0605 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kernel/acpi/cstate.c |    9 +++++++++
 drivers/acpi/processor_idle.c |    2 +-
 include/acpi/processor.h      |    3 ++-
 3 files changed, 12 insertions(+), 2 deletions(-)

--- a/arch/x86/kernel/acpi/cstate.c
+++ b/arch/x86/kernel/acpi/cstate.c
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
--- a/drivers/acpi/processor_idle.c
+++ b/drivers/acpi/processor_idle.c
@@ -955,7 +955,7 @@ static int acpi_idle_enter_bm(struct cpu
 	if (acpi_idle_suspend)
 		return(acpi_idle_enter_c1(dev, state));
 
-	if (acpi_idle_bm_check()) {
+	if (!cx->bm_sts_skip && acpi_idle_bm_check()) {
 		if (dev->safe_state) {
 			dev->last_state = dev->safe_state;
 			return dev->safe_state->enter(dev, dev->safe_state);
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
 
@@ -74,6 +74,7 @@ struct acpi_processor_cx {
 	u32 power;
 	u32 usage;
 	u64 time;
+	u8 bm_sts_skip;
 	struct acpi_processor_cx_policy promotion;
 	struct acpi_processor_cx_policy demotion;
 	char desc[ACPI_CX_DESC_LEN];


