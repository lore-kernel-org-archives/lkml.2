Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760475Ab0EECIG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 22:08:06 -0400
Received: from hera.kernel.org ([140.211.167.34]:34937 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760425Ab0EECIA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 22:08:00 -0400
Date: Wed, 5 May 2010 02:07:21 GMT
From: "tip-bot for Eric W. Biederman" <ebiederm@xmission.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       tglx@linutronix.de, ebiederm@xmission.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, ebiederm@xmission.com
In-Reply-To: <1269936436-7039-3-git-send-email-ebiederm@xmission.com>
References: <1269936436-7039-3-git-send-email-ebiederm@xmission.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/irq] x86, acpi/irq: pci device dev->irq is an isa irq not a gsi
Message-ID: <tip-414d3448dbcb40807a1265ace64b2576ef919fbe@git.kernel.org>
Git-Commit-ID: 414d3448dbcb40807a1265ace64b2576ef919fbe
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 05 May 2010 02:07:21 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  414d3448dbcb40807a1265ace64b2576ef919fbe
Gitweb:     http://git.kernel.org/tip/414d3448dbcb40807a1265ace64b2576ef919fbe
Author:     Eric W. Biederman <ebiederm@xmission.com>
AuthorDate: Tue, 30 Mar 2010 01:07:04 -0700
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Tue, 4 May 2010 13:34:30 -0700

x86, acpi/irq: pci device dev->irq is an isa irq not a gsi

Strictly speaking on x86 (where acpi is used) dev->irq must be
a dual i8259 irq input aka an isa irq.  Therefore we should translate
that isa irq into a gsi before passing it to a function that
takes a gsi.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
LKML-Reference: <1269936436-7039-3-git-send-email-ebiederm@xmission.com>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 drivers/acpi/pci_irq.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/acpi/pci_irq.c b/drivers/acpi/pci_irq.c
index b0a71ec..e4804fb 100644
--- a/drivers/acpi/pci_irq.c
+++ b/drivers/acpi/pci_irq.c
@@ -401,11 +401,13 @@ int acpi_pci_irq_enable(struct pci_dev *dev)
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
