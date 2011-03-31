Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759368Ab1CaUHT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 16:07:19 -0400
Received: from hera.kernel.org ([140.211.167.34]:54901 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759349Ab1CaUHR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 16:07:17 -0400
Date: Thu, 31 Mar 2011 20:06:56 GMT
From: tip-bot for Cliff Wickman <cpw@sgi.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com, cpw@sgi.com,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        cpw@sgi.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <E1Q5Iuo-00013b-UK@eag09.americas.sgi.com>
References: <E1Q5Iuo-00013b-UK@eag09.americas.sgi.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86, UV: Fix kdump reboot
Message-ID: <tip-818987e9a19c52240ba9b1c20f28f047eef76072@git.kernel.org>
Git-Commit-ID: 818987e9a19c52240ba9b1c20f28f047eef76072
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 31 Mar 2011 20:06:56 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  818987e9a19c52240ba9b1c20f28f047eef76072
Gitweb:     http://git.kernel.org/tip/818987e9a19c52240ba9b1c20f28f047eef76072
Author:     Cliff Wickman <cpw@sgi.com>
AuthorDate: Thu, 31 Mar 2011 09:32:02 -0500
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 31 Mar 2011 18:44:03 +0200

x86, UV: Fix kdump reboot

After a crash dump on an SGI Altix UV system the crash kernel
fails to cause a reboot.  EFI mode is disabled in the kdump
kernel, so only the reboot_type of BOOT_ACPI works.

Signed-off-by: Cliff Wickman <cpw@sgi.com>
Cc: rja@sgi.com
LKML-Reference: <E1Q5Iuo-00013b-UK@eag09.americas.sgi.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/apic/x2apic_uv_x.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/apic/x2apic_uv_x.c b/arch/x86/kernel/apic/x2apic_uv_x.c
index d2cf39b..33b10a0 100644
--- a/arch/x86/kernel/apic/x2apic_uv_x.c
+++ b/arch/x86/kernel/apic/x2apic_uv_x.c
@@ -24,6 +24,7 @@
 #include <linux/pci.h>
 #include <linux/kdebug.h>
 #include <linux/delay.h>
+#include <linux/crash_dump.h>
 
 #include <asm/uv/uv_mmrs.h>
 #include <asm/uv/uv_hub.h>
@@ -35,6 +36,7 @@
 #include <asm/ipi.h>
 #include <asm/smp.h>
 #include <asm/x86_init.h>
+#include <asm/emergency-restart.h>
 
 DEFINE_PER_CPU(int, x2apic_extra_bits);
 
@@ -811,4 +813,11 @@ void __init uv_system_init(void)
 
 	/* register Legacy VGA I/O redirection handler */
 	pci_register_set_vga_state(uv_set_vga_state);
+
+	/*
+	 * For a kdump kernel the reset must be BOOT_ACPI, not BOOT_EFI, as
+	 * EFI is not enabled in the kdump kernel.
+	 */
+	if (is_kdump_kernel())
+		reboot_type = BOOT_ACPI;
 }
