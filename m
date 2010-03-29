Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754906Ab0C2XUz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 19:20:55 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:54133 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754006Ab0C2XUt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 19:20:49 -0400
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, linux-kernel@vger.kernel.org,
       Thomas Renninger <trenn@suse.de>,
       Suresh Siddha <suresh.b.siddha@intel.com>, len.brown@intel.com,
       Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>,
       linux-acpi@vger.kernel.org, Iranna D Ankad <iranna.ankad@in.ibm.com>,
       Gary Hade <garyhade@us.ibm.com>,
       Natalie Protasevich <protasnb@gmail.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [PATCH 03/14] x86 acpi/irq: pci device dev->irq is an isa irq not a gsi
Date: Mon, 29 Mar 2010 16:20:14 -0700
Message-Id: <1269904825-27462-3-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.6.5.2.143.g8cc62
In-Reply-To: <m1r5n2wwah.fsf_-_@fess.ebiederm.org>
References: <m1r5n2wwah.fsf_-_@fess.ebiederm.org>
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Rcpt-To: hpa@zytor.com, tglx@linutronix.de, mingo@elte.hu, akpm@linux-foundation.org, jbarnes@virtuousgeek.org, linux-kernel@vger.kernel.org, trenn@suse.de, suresh.b.siddha@intel.com, len.brown@intel.com, tony.luck@intel.com, fenghua.yu@intel.com, linux-acpi@vger.kernel.org, iranna.ankad@in.ibm.com, garyhade@us.ibm.com, protasnb@gmail.com, ebiederm@xmission.com
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in02.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric W. Biederman <ebiederm@xmission.com>

Strictly speaking on x86 (where acpi is used) dev->irq must be
a dual i8259 irq input aka an isa irq.  Therefore we should translate
that isa irq into a gsi before passing it to a function that
takes a gsi.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 drivers/acpi/pci_irq.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/acpi/pci_irq.c b/drivers/acpi/pci_irq.c
index 843699e..703541d 100644
--- a/drivers/acpi/pci_irq.c
+++ b/drivers/acpi/pci_irq.c
@@ -400,11 +400,13 @@ int acpi_pci_irq_enable(struct pci_dev *dev)
 	 * driver reported one, then use it. Exit in any case.
 	 */
 	if (gsi < 0) {
+		u32 dev_gsi;
 		dev_warn(&dev->dev, "PCI INT %c: no GSI", pin_name(pin));
 		/* Interrupt Line values above 0xF are forbidden */
-		if (dev->irq > 0 && (dev->irq <= 0xF)) {
-			printk(" - using IRQ %d\n", dev->irq);
-			acpi_register_gsi(&dev->dev, dev->irq,
+		if (dev->irq > 0 && (dev->irq <= 0xF) &&
+		    (acpi_isa_irq_to_gsi(dev->irq, &dev_gsi) == 0)) {
+			printk(" - using ISA IRQ %d\n", dev->irq);
+			acpi_register_gsi(&dev->dev, dev_gsi,
 					  ACPI_LEVEL_SENSITIVE,
 					  ACPI_ACTIVE_LOW);
 			return 0;
-- 
1.6.5.2.143.g8cc62

