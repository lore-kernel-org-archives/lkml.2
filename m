Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754442Ab1KDCMT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 22:12:19 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38607 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753068Ab1KDCMS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 22:12:18 -0400
From: Thomas Renninger <trenn@suse.de>
To: linux-kernel@vger.kernel.org
Cc: trenn@suse.de, linux-acpi@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>, bjorn.helgaas@hp.com,
        lenb@kernel.org, stable@kernel.org, Ingo Molnar <mingo@elte.hu>,
        H Peter Anvin <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH] PNP ACPI: Use real gsi
Date: Fri,  4 Nov 2011 03:12:08 +0100
Message-Id: <1320372728-3235-1-git-send-email-trenn@suse.de>
X-Mailer: git-send-email 1.7.6.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yinghai Lu <yinghai@kernel.org>

In 2.6.35 a lot cleanups in this area (not pnp, but x86 ioapic setup) have
been introduced.
On an IBM Xseries (x3850) this caused the machine to freeze around when
the init userspace process is tried to get started.
The reason is that the timer interrupt is not set up correctly on this machine.

I could bisect the issue to one of ioapic cleanups introduced in 2.6.35:
commit a4384df3e24579d6292a1b3b41d500349948f30b

While on this machine the problem was an interrupt timer issue,
there may be other platforms with different interrupt issues relatd to this
problem. Kernel logs with similar IOAPIC errors inside pnpacpi setup might
need this patch:
  pnp 00:04: [io  0x02f8-0x02ff]
  IOAPIC[1]: Invalid reference to IRQ 0
  pnp 00:04: [irq 2]
  pnp 00:04: Plug and Play ACPI device, IDs PNP0501 (active)

Yinghai came up with this patch which fixes the problem for me.
Looks like the bisected commit is correct, but the pnp layer has been
overseen.

Tested-by: Thomas Renninger <trenn@suse.de>
CC: Eric W. Biederman <ebiederm@xmission.com>
CC: bjorn.helgaas@hp.com
CC: lenb@kernel.org
CC: stable@kernel.org
CC: Ingo Molnar <mingo@elte.hu>
CC: H Peter Anvin <hpa@zytor.com>
CC: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Thomas Renninger <trenn@suse.de>
---
 drivers/pnp/pnpacpi/rsparser.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/drivers/pnp/pnpacpi/rsparser.c b/drivers/pnp/pnpacpi/rsparser.c
index bbf3edd..dad5da9 100644
--- a/drivers/pnp/pnpacpi/rsparser.c
+++ b/drivers/pnp/pnpacpi/rsparser.c
@@ -106,6 +106,14 @@ static void pnpacpi_parse_allocated_irqresource(struct pnp_dev *dev,
 		return;
 	}
 
+#ifdef CONFIG_X86_IO_APIC
+	/*
+	 * Convert it back to real gsi
+	 */
+	if (acpi_irq_model == ACPI_IRQ_MODEL_IOAPIC)
+		acpi_isa_irq_to_gsi(gsi, &gsi);
+#endif
+
 	/*
 	 * in IO-APIC mode, use overrided attribute. Two reasons:
 	 * 1. BIOS bug in DSDT
-- 
1.7.6.1

