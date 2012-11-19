Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753069Ab2KSFhq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 00:37:46 -0500
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:45573 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750920Ab2KSFah convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 00:30:37 -0500
X-Originating-IP: 217.70.178.132
X-Originating-IP: 50.43.39.152
From: Josh Triplett <josh@joshtriplett.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Joerg Roedel <joerg.roedel@amd.com>, Yinghai Lu <yinghai@kernel.org>,
        Alexander Gordeev <agordeev@redhat.com>, linux-kernel@vger.kernel.org
Cc: Josh Triplett <josh@joshtriplett.org>
Subject: [PATCH 28/58] x86: io_apic: Don't define acpi_get_override_irq if CONFIG_ACPI=n
Date: Sun, 18 Nov 2012 21:28:07 -0800
Message-Id: <1353302917-13995-29-git-send-email-josh@joshtriplett.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1353302917-13995-1-git-send-email-josh@joshtriplett.org>
References: <1353302917-13995-1-git-send-email-josh@joshtriplett.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

arch/x86/kernel/apic/io_apic.c defines acpi_get_override_irq
unconditionally, but linux/acpi.h only prototypes it if CONFIG_ACPI=y,
and nothing calls it unless CONFIG_ACPI=y.  Make the definition itself
conditional on CONFIG_ACPI.  This saves space when CONFIG_ACPI=n, and
eliminates warnings from GCC (-Wmissing-prototypes) and Sparse (-Wdecl).

arch/x86/kernel/apic/io_apic.c:3638:5: warning: no previous prototype for ‘acpi_get_override_irq’ [-Wmissing-prototypes]

Signed-off-by: Josh Triplett <josh@joshtriplett.org>
---
 arch/x86/kernel/apic/io_apic.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 1817fa9..6d01108 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -3635,6 +3635,7 @@ static int __init io_apic_get_version(int ioapic)
 	return reg_01.bits.version;
 }
 
+#ifdef CONFIG_ACPI
 int acpi_get_override_irq(u32 gsi, int *trigger, int *polarity)
 {
 	int ioapic, pin, idx;
@@ -3658,6 +3659,7 @@ int acpi_get_override_irq(u32 gsi, int *trigger, int *polarity)
 	*polarity = irq_polarity(idx);
 	return 0;
 }
+#endif
 
 /*
  * This function currently is only a helper for the i386 smp boot process where
-- 
1.7.10.4

