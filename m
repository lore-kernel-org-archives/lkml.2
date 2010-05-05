Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760463Ab0EECIE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 22:08:04 -0400
Received: from hera.kernel.org ([140.211.167.34]:34936 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760405Ab0EECH7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 22:07:59 -0400
Date: Wed, 5 May 2010 02:06:46 GMT
From: "tip-bot for Eric W. Biederman" <ebiederm@xmission.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       tglx@linutronix.de, ebiederm@xmission.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, ebiederm@xmission.com
In-Reply-To: <1269936436-7039-1-git-send-email-ebiederm@xmission.com>
References: <1269936436-7039-1-git-send-email-ebiederm@xmission.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/irq] x86, acpi/irq: Introduce apci_isa_irq_to_gsi
Message-ID: <tip-2c2df8418ac7908eec4558407b83f16739006c54@git.kernel.org>
Git-Commit-ID: 2c2df8418ac7908eec4558407b83f16739006c54
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 05 May 2010 02:06:47 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2c2df8418ac7908eec4558407b83f16739006c54
Gitweb:     http://git.kernel.org/tip/2c2df8418ac7908eec4558407b83f16739006c54
Author:     Eric W. Biederman <ebiederm@xmission.com>
AuthorDate: Tue, 30 Mar 2010 01:07:02 -0700
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Tue, 4 May 2010 13:34:23 -0700

x86, acpi/irq: Introduce apci_isa_irq_to_gsi

There are a number of cases where the current code makes the assumption
that isa irqs identity map to the first 16 acpi global system intereupts.
In most instances that assumption is correct as that is the required
behaviour in dual i8259 mode and the default behavior in ioapic mode.

However there are some systems out there that take advantage of acpis
interrupt remapping  for the isa irqs to have a completely different
mapping of isa_irq to gsi.

Introduce acpi_isa_irq_to_gsi to perform this mapping explicitly in the
code that needs it.  Initially this will be just the current assumed
identity mapping to ensure it's introduction does not cause regressions.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
LKML-Reference: <1269936436-7039-1-git-send-email-ebiederm@xmission.com>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/ia64/kernel/acpi.c     |    8 ++++++++
 arch/x86/kernel/acpi/boot.c |    8 ++++++++
 include/linux/acpi.h        |    1 +
 3 files changed, 17 insertions(+), 0 deletions(-)

diff --git a/arch/ia64/kernel/acpi.c b/arch/ia64/kernel/acpi.c
index 4d1a7e9..c6c90f3 100644
--- a/arch/ia64/kernel/acpi.c
+++ b/arch/ia64/kernel/acpi.c
@@ -785,6 +785,14 @@ int acpi_gsi_to_irq(u32 gsi, unsigned int *irq)
 	return 0;
 }
 
+int acpi_isa_irq_to_gsi(unsigned isa_irq, u32 *gsi)
+{
+	if (isa_irq >= 16)
+		return -1;
+	*gsi = isa_irq;
+	return 0;
+}
+
 /*
  *  ACPI based hotplug CPU support
  */
diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
index cd40aba..da718d6 100644
--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -458,6 +458,14 @@ int acpi_gsi_to_irq(u32 gsi, unsigned int *irq)
 	return 0;
 }
 
+int acpi_isa_irq_to_gsi(unsigned isa_irq, u32 *gsi)
+{
+	if (isa_irq >= 16)
+		return -1;
+	*gsi = isa_irq;
+	return 0;
+}
+
 /*
  * success: return IRQ number (>=0)
  * failure: return < 0
diff --git a/include/linux/acpi.h b/include/linux/acpi.h
index b926afe..7a937da 100644
--- a/include/linux/acpi.h
+++ b/include/linux/acpi.h
@@ -116,6 +116,7 @@ extern unsigned long acpi_realmode_flags;
 
 int acpi_register_gsi (struct device *dev, u32 gsi, int triggering, int polarity);
 int acpi_gsi_to_irq (u32 gsi, unsigned int *irq);
+int acpi_isa_irq_to_gsi (unsigned isa_irq, u32 *gsi);
 
 #ifdef CONFIG_X86_IO_APIC
 extern int acpi_get_override_irq(int bus_irq, int *trigger, int *polarity);
