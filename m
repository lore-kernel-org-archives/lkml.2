Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757409Ab0LIVra (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 16:47:30 -0500
Received: from mx1.redhat.com ([209.132.183.28]:50045 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757390Ab0LIVr1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 16:47:27 -0500
From: Matthew Garrett <mjg@redhat.com>
To: x86@kernel.org
Cc: hpa@zytor.com, linux-acpi@vger.kernel.org, lenb@kernel.org,
        linux-kernel@vger.kernel.org, Matthew Garrett <mjg@redhat.com>
Subject: [PATCH 2/3] ACPICA: Fix access width for reset vector
Date: Thu,  9 Dec 2010 16:46:43 -0500
Message-Id: <1291931204-5854-2-git-send-email-mjg@redhat.com>
In-Reply-To: <1291931204-5854-1-git-send-email-mjg@redhat.com>
References: <1291931204-5854-1-git-send-email-mjg@redhat.com>
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 66.187.233.202
X-SA-Exim-Mail-From: mjg@redhat.com
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Section 4.7.3.6 of the ACPI specification requires that the register width
of the reset vector be 8 bits. Windows simply hardcodes the access to be
a byte and ignores the width provided in the FADT, so make sure that we
do the same.

Signed-off-by: Matthew Garrett <mjg@redhat.com>
---
 drivers/acpi/acpica/hwxface.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/acpi/acpica/hwxface.c b/drivers/acpi/acpica/hwxface.c
index 50cc3be..c6a4e63 100644
--- a/drivers/acpi/acpica/hwxface.c
+++ b/drivers/acpi/acpica/hwxface.c
@@ -82,12 +82,11 @@ acpi_status acpi_reset(void)
 		/*
 		 * For I/O space, write directly to the OSL. This bypasses the port
 		 * validation mechanism, which may block a valid write to the reset
-		 * register.
+		 * register. Spec section 4.7.3.6 requires register width to be 8.
 		 */
 		status =
 		    acpi_os_write_port((acpi_io_address) reset_reg->address,
-				       acpi_gbl_FADT.reset_value,
-				       reset_reg->bit_width);
+				       acpi_gbl_FADT.reset_value, 8)
 	} else {
 		/* Write the reset value to the reset register */
 
-- 
1.7.3.2

