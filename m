Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932190Ab0JDSX2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 14:23:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40717 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756813Ab0JDSXF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 14:23:05 -0400
From: Matthew Garrett <mjg@redhat.com>
To: linux-acpi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        Matthew Garrett <mjg@redhat.com>
Subject: [PATCH 4/5] ACPI: Missing _S0W shouldn't disable runtime PM
Date: Mon,  4 Oct 2010 14:22:28 -0400
Message-Id: <1286216549-5438-5-git-send-email-mjg@redhat.com>
In-Reply-To: <1286216549-5438-1-git-send-email-mjg@redhat.com>
References: <1286216549-5438-1-git-send-email-mjg@redhat.com>
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 66.187.233.202
X-SA-Exim-Mail-From: mjg@redhat.com
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A failure to evaluate _S0W will effectively result in the suspend state
for PCI devices being set to D0. We should limit that to genuine failures
rather than doing so if the method isn't present.

Signed-off-by: Matthew Garrett <mjg@redhat.com>
---
 drivers/acpi/sleep.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/acpi/sleep.c b/drivers/acpi/sleep.c
index cf82989..ab0ba78 100644
--- a/drivers/acpi/sleep.c
+++ b/drivers/acpi/sleep.c
@@ -609,9 +609,9 @@ int acpi_pm_device_sleep_state(struct device *dev, int *d_min_p)
 		acpi_method[3] = 'W';
 		status = acpi_evaluate_integer(handle, acpi_method, NULL,
 						&d_max);
-		if (ACPI_FAILURE(status)) {
+		if (ACPI_FAILURE(status) && status != AE_NOT_FOUND) {
 			d_max = d_min;
-		} else if (d_max < d_min) {
+		} else if (ACPI_SUCCESS(status) && d_max < d_min) {
 			/* Warn the user of the broken DSDT */
 			printk(KERN_WARNING "ACPI: Wrong value from %s\n",
 				acpi_method);
-- 
1.7.3.1

