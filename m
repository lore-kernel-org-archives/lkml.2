Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752594Ab0F2DuH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jun 2010 23:50:07 -0400
Received: from vms173005pub.verizon.net ([206.46.173.5]:47816 "EHLO
	vms173005pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751320Ab0F2DuF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jun 2010 23:50:05 -0400
Date: Mon, 28 Jun 2010 23:49:46 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@localhost.localdomain
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: 2.6.35-rc3 regression: IBM Maia system is unbootable [ACPI
 related?]
In-reply-to: <1277141166.10998.79.camel@mulgrave.site>
Message-id: <alpine.LFD.2.00.1006282346320.16755@localhost.localdomain>
References: <1277136189.10998.63.camel@mulgrave.site>
 <87pqzkqrzq.fsf@basil.nowhere.org>  <1277138034.10998.69.camel@mulgrave.site>
 <1277139286.10998.72.camel@mulgrave.site>
 <1277141166.10998.79.camel@mulgrave.site>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Len Brown <len.brown@intel.com>
Subject: [PATCH] ACPI: handle systems which asynchoronously enable ACPI mode

Folklore suggested that such systems existed
in the pre-history of ACPI.

However, we removed the SCI_EN polling loop from
acpi_hw_set_mode() in b430acbd7c4b919886fa7fd92eeb7a695f1940d3
because it delayed resume by 3 seconds on boxes
that refused to set SCI_EN.

Matthew removed the call to acpi_enable() from
the suspend resume path.

James found a modern system that still needs to be polled
upon boot.

So here we restore the workaround, except that we
put it in acpi_enable() rather than the low level
acpi_hw_set_mode().

https://bugzilla.kernel.org/show_bug.cgi?id=16271

Signed-off-by: Len Brown <len.brown@intel.com>
---

James, What does the IBM system see with this patch?

thanks,
-Len

 drivers/acpi/acpica/evxfevnt.c |   19 +++++++++++--------
 1 files changed, 11 insertions(+), 8 deletions(-)

diff --git a/drivers/acpi/acpica/evxfevnt.c b/drivers/acpi/acpica/evxfevnt.c
index d97b8dc..18b3f14 100644
--- a/drivers/acpi/acpica/evxfevnt.c
+++ b/drivers/acpi/acpica/evxfevnt.c
@@ -70,6 +70,7 @@ acpi_ev_get_gpe_device(struct acpi_gpe_xrupt_info *gpe_xrupt_info,
 acpi_status acpi_enable(void)
 {
 	acpi_status status;
+	int retry;
 
 	ACPI_FUNCTION_TRACE(acpi_enable);
 
@@ -98,16 +99,18 @@ acpi_status acpi_enable(void)
 
 	/* Sanity check that transition succeeded */
 
-	if (acpi_hw_get_mode() != ACPI_SYS_MODE_ACPI) {
-		ACPI_ERROR((AE_INFO,
-			    "Hardware did not enter ACPI mode"));
-		return_ACPI_STATUS(AE_NO_HARDWARE_RESPONSE);
+	for (retry = 0; retry < 30000; ++retry) {
+		if (acpi_hw_get_mode() == ACPI_SYS_MODE_ACPI) {
+			if (retry != 0)
+				ACPI_WARNING((AE_INFO,
+				"Platform took > %d00 usec to enter ACPI mode", retry));
+			return_ACPI_STATUS(AE_OK);
+		}
+		acpi_os_stall(100);	/* 100 usec */
 	}
 
-	ACPI_DEBUG_PRINT((ACPI_DB_INIT,
-			  "Transition to ACPI mode successful\n"));
-
-	return_ACPI_STATUS(AE_OK);
+	ACPI_ERROR((AE_INFO, "Hardware did not enter ACPI mode"));
+	return_ACPI_STATUS(AE_NO_HARDWARE_RESPONSE);
 }
 
 ACPI_EXPORT_SYMBOL(acpi_enable)
-- 
1.7.2.rc0

