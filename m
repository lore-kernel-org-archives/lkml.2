Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755576Ab1CKVNO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 16:13:14 -0500
Received: from mx1.redhat.com ([209.132.183.28]:38431 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754711Ab1CKVNE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 16:13:04 -0500
From: Matthew Garrett <mjg@redhat.com>
To: linux-acpi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, x86@kernel.org,
        Matthew Garrett <mjg@redhat.com>
Subject: [PATCH 3/4] ACPI: Bug compatibility for Windows on the ACPI reboot vector
Date: Fri, 11 Mar 2011 16:12:19 -0500
Message-Id: <1299877940-6870-3-git-send-email-mjg@redhat.com>
In-Reply-To: <1299877940-6870-1-git-send-email-mjg@redhat.com>
References: <1299877940-6870-1-git-send-email-mjg@redhat.com>
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 209.6.41.104
X-SA-Exim-Mail-From: mjg@redhat.com
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Windows ignores the bit_offset and bit_width, despite the spec requiring
that they be validated. Drop the checks so that we match this behaviour.
Windows also goes straight for the keyboard controller if the ACPI reboot
fails, so we shouldn't sleep if we're still alive.

Signed-off-by: Matthew Garrett <mjg@redhat.com>
---
 drivers/acpi/reboot.c |    9 ++++-----
 1 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/acpi/reboot.c b/drivers/acpi/reboot.c
index 93f9114..4870aaa 100644
--- a/drivers/acpi/reboot.c
+++ b/drivers/acpi/reboot.c
@@ -15,9 +15,10 @@ void acpi_reboot(void)
 
 	rr = &acpi_gbl_FADT.reset_register;
 
-	/* Is the reset register supported? */
-	if (!(acpi_gbl_FADT.flags & ACPI_FADT_RESET_REGISTER) ||
-	    rr->bit_width != 8 || rr->bit_offset != 0)
+	/* Is the reset register supported? The spec says we should be
+	 * checking the bit width and bit offset, but Windows ignores
+	 * these fields */
+	if (!(acpi_gbl_FADT.flags & ACPI_FADT_RESET_REGISTER))
 		return;
 
 	reset_value = acpi_gbl_FADT.reset_value;
@@ -45,6 +46,4 @@ void acpi_reboot(void)
 		acpi_reset();
 		break;
 	}
-	/* Wait ten seconds */
-	acpi_os_stall(10000000);
 }
-- 
1.7.4.1

