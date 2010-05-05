Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933755Ab0EECIj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 22:08:39 -0400
Received: from hera.kernel.org ([140.211.167.34]:34943 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760454Ab0EECID (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 22:08:03 -0400
Date: Wed, 5 May 2010 02:07:38 GMT
From: "tip-bot for Eric W. Biederman" <ebiederm@xmission.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       tglx@linutronix.de, ebiederm@xmission.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, ebiederm@xmission.com
In-Reply-To: <1269936436-7039-4-git-send-email-ebiederm@xmission.com>
References: <1269936436-7039-4-git-send-email-ebiederm@xmission.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/irq] x86, acpi/irq: Fix acpi_sci_ioapic_setup so it has both bus_irq and gsi
Message-ID: <tip-9d2062b879495649bb525cf7979126da2e45d288@git.kernel.org>
Git-Commit-ID: 9d2062b879495649bb525cf7979126da2e45d288
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 05 May 2010 02:07:38 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9d2062b879495649bb525cf7979126da2e45d288
Gitweb:     http://git.kernel.org/tip/9d2062b879495649bb525cf7979126da2e45d288
Author:     Eric W. Biederman <ebiederm@xmission.com>
AuthorDate: Tue, 30 Mar 2010 01:07:05 -0700
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Tue, 4 May 2010 13:34:34 -0700

x86, acpi/irq: Fix acpi_sci_ioapic_setup so it has both bus_irq and gsi

Currently acpi_sci_ioapic_setup calls mp_override_legacy_irq with
bus_irq == gsi, which is wrong if we are comming from an override
Instead pass the bus_irq into acpi_sci_ioapic_setup.

This fix was inspired by a similar fix from:
Yinghai Lu <yinghai@kernel.org>

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
LKML-Reference: <1269936436-7039-4-git-send-email-ebiederm@xmission.com>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/kernel/acpi/boot.c |   12 +++++++-----
 1 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
index da718d6..0a036dc 100644
--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -313,7 +313,7 @@ acpi_parse_ioapic(struct acpi_subtable_header * header, const unsigned long end)
 /*
  * Parse Interrupt Source Override for the ACPI SCI
  */
-static void __init acpi_sci_ioapic_setup(u32 gsi, u16 polarity, u16 trigger)
+static void __init acpi_sci_ioapic_setup(u8 bus_irq, u16 polarity, u16 trigger, u32 gsi)
 {
 	if (trigger == 0)	/* compatible SCI trigger is level */
 		trigger = 3;
@@ -333,7 +333,7 @@ static void __init acpi_sci_ioapic_setup(u32 gsi, u16 polarity, u16 trigger)
 	 * If GSI is < 16, this will update its flags,
 	 * else it will create a new mp_irqs[] entry.
 	 */
-	mp_override_legacy_irq(gsi, polarity, trigger, gsi);
+	mp_override_legacy_irq(bus_irq, polarity, trigger, gsi);
 
 	/*
 	 * stash over-ride to indicate we've been here
@@ -357,9 +357,10 @@ acpi_parse_int_src_ovr(struct acpi_subtable_header * header,
 	acpi_table_print_madt_entry(header);
 
 	if (intsrc->source_irq == acpi_gbl_FADT.sci_interrupt) {
-		acpi_sci_ioapic_setup(intsrc->global_irq,
+		acpi_sci_ioapic_setup(intsrc->source_irq,
 				      intsrc->inti_flags & ACPI_MADT_POLARITY_MASK,
-				      (intsrc->inti_flags & ACPI_MADT_TRIGGER_MASK) >> 2);
+				      (intsrc->inti_flags & ACPI_MADT_TRIGGER_MASK) >> 2,
+				      intsrc->global_irq);
 		return 0;
 	}
 
@@ -1162,7 +1163,8 @@ static int __init acpi_parse_madt_ioapic_entries(void)
 	 * pretend we got one so we can set the SCI flags.
 	 */
 	if (!acpi_sci_override_gsi)
-		acpi_sci_ioapic_setup(acpi_gbl_FADT.sci_interrupt, 0, 0);
+		acpi_sci_ioapic_setup(acpi_gbl_FADT.sci_interrupt, 0, 0,
+				      acpi_gbl_FADT.sci_interrupt);
 
 	/* Fill in identity legacy mappings where no override */
 	mp_config_acpi_legacy_irqs();
