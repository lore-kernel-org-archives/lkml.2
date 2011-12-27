Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752307Ab1L0GfU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Dec 2011 01:35:20 -0500
Received: from one.firstfloor.org ([213.235.205.2]:41337 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751429Ab1L0GfD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Dec 2011 01:35:03 -0500
From: Andi Kleen <andi@firstfloor.org>
To: lenb@kernel.org
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andi Kleen <andi@firstfloor.org>, Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 2/4] ACPI: Make ACPI interrupt threaded
Date: Mon, 26 Dec 2011 22:34:45 -0800
Message-Id: <1324967687-10559-3-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1324967687-10559-1-git-send-email-andi@firstfloor.org>
References: <1324967687-10559-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some ACPI interrupt actions may need to wait, and it's easiest to
have a thread context for this. So turn the ACPI interrupt
into a threaded interrupt.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 drivers/acpi/osl.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/acpi/osl.c b/drivers/acpi/osl.c
index f31c5c5..3503434 100644
--- a/drivers/acpi/osl.c
+++ b/drivers/acpi/osl.c
@@ -564,7 +564,8 @@ acpi_os_install_interrupt_handler(u32 gsi, acpi_osd_handler handler,
 
 	acpi_irq_handler = handler;
 	acpi_irq_context = context;
-	if (request_irq(irq, acpi_irq, IRQF_SHARED, "acpi", acpi_irq)) {
+	if (request_threaded_irq(irq, NULL, acpi_irq, IRQF_SHARED, "acpi", 
+				 acpi_irq)) {
 		printk(KERN_ERR PREFIX "SCI (IRQ%d) allocation failed\n", irq);
 		acpi_irq_handler = NULL;
 		return AE_NOT_ACQUIRED;
-- 
1.7.7

