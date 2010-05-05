Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760502Ab0EECLw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 22:11:52 -0400
Received: from hera.kernel.org ([140.211.167.34]:37072 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756491Ab0EECLt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 22:11:49 -0400
Date: Wed, 5 May 2010 02:10:11 GMT
From: "tip-bot for Eric W. Biederman" <ebiederm@xmission.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       tglx@linutronix.de, ebiederm@xmission.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, ebiederm@xmission.com
In-Reply-To: <1269936436-7039-13-git-send-email-ebiederm@xmission.com>
References: <1269936436-7039-13-git-send-email-ebiederm@xmission.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/irq] x86, ioapic: Simplify probe_nr_irqs_gsi.
Message-ID: <tip-4afc51a835d3aeba11c35090f524e05c84586d27@git.kernel.org>
Git-Commit-ID: 4afc51a835d3aeba11c35090f524e05c84586d27
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 05 May 2010 02:10:11 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4afc51a835d3aeba11c35090f524e05c84586d27
Gitweb:     http://git.kernel.org/tip/4afc51a835d3aeba11c35090f524e05c84586d27
Author:     Eric W. Biederman <ebiederm@xmission.com>
AuthorDate: Tue, 30 Mar 2010 01:07:14 -0700
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Tue, 4 May 2010 13:35:11 -0700

x86, ioapic: Simplify probe_nr_irqs_gsi.

Use the global gsi_end value now that all ioapics have
valid gsi numbers instead of a combination of acpi_probe_gsi
and walking all of the ioapics and couting their number of
entries by hand if acpi_probe_gsi gave us an answer we did
not like.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
LKML-Reference: <1269936436-7039-13-git-send-email-ebiederm@xmission.com>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/include/asm/mpspec.h  |    6 ------
 arch/x86/kernel/acpi/boot.c    |   23 -----------------------
 arch/x86/kernel/apic/io_apic.c |   17 +++--------------
 3 files changed, 3 insertions(+), 43 deletions(-)

diff --git a/arch/x86/include/asm/mpspec.h b/arch/x86/include/asm/mpspec.h
index 29994f0..c82868e 100644
--- a/arch/x86/include/asm/mpspec.h
+++ b/arch/x86/include/asm/mpspec.h
@@ -105,12 +105,6 @@ extern void mp_config_acpi_legacy_irqs(void);
 struct device;
 extern int mp_register_gsi(struct device *dev, u32 gsi, int edge_level,
 				 int active_high_low);
-extern int acpi_probe_gsi(void);
-#else /* !CONFIG_ACPI: */
-static inline int acpi_probe_gsi(void)
-{
-	return 0;
-}
 #endif /* CONFIG_ACPI */
 
 #define PHYSID_ARRAY_SIZE	BITS_TO_LONGS(MAX_APICS)
diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
index 3ee92f2..07a63ce 100644
--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -876,29 +876,6 @@ static int __init acpi_parse_madt_lapic_entries(void)
 extern int es7000_plat;
 #endif
 
-int __init acpi_probe_gsi(void)
-{
-	int idx;
-	int gsi;
-	int max_gsi = 0;
-
-	if (acpi_disabled)
-		return 0;
-
-	if (!acpi_ioapic)
-		return 0;
-
-	max_gsi = 0;
-	for (idx = 0; idx < nr_ioapics; idx++) {
-		gsi = mp_gsi_routing[idx].gsi_end;
-
-		if (gsi > max_gsi)
-			max_gsi = gsi;
-	}
-
-	return max_gsi + 1;
-}
-
 static void assign_to_mp_irq(struct mpc_intsrc *m,
 				    struct mpc_intsrc *mp_irq)
 {
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 0d35f46..9f3f6ca 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -3850,22 +3850,11 @@ int __init io_apic_get_redir_entries (int ioapic)
 
 void __init probe_nr_irqs_gsi(void)
 {
-	int nr = 0;
+	int nr;
 
-	nr = acpi_probe_gsi();
-	if (nr > nr_irqs_gsi) {
+	nr = gsi_end + 1;
+	if (nr > nr_irqs_gsi)
 		nr_irqs_gsi = nr;
-	} else {
-		/* for acpi=off or acpi is not compiled in */
-		int idx;
-
-		nr = 0;
-		for (idx = 0; idx < nr_ioapics; idx++)
-			nr += io_apic_get_redir_entries(idx);
-
-		if (nr > nr_irqs_gsi)
-			nr_irqs_gsi = nr;
-	}
 
 	printk(KERN_DEBUG "nr_irqs_gsi: %d\n", nr_irqs_gsi);
 }
