Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933065Ab0G3SGY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 14:06:24 -0400
Received: from kroah.org ([198.145.64.141]:59253 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932822Ab0G3R5u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 13:57:50 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Jul 30 10:51:51 2010
Message-Id: <20100730175151.140960777@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 30 Jul 2010 10:53:27 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Len Brown <len.brown@intel.com>
Subject: [190/205] ACPI / ACPICA: Avoid writing full enable masks to GPE registers
In-Reply-To: <20100730175238.GA3924@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.34-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Rafael J. Wysocki <rjw@sisk.pl>

commit c9a8bbb7704cbf515c0fc68970abbe4e91d68521 upstream.

ACPICA uses acpi_hw_write_gpe_enable_reg() to re-enable a GPE after
an event signaled by it has been handled.  However, this function
writes the entire GPE enable mask to the GPE's enable register which
may not be correct.  Namely, if one of the other GPEs in the same
register was previously enabled by acpi_enable_gpe() and subsequently
disabled using acpi_set_gpe(), acpi_hw_write_gpe_enable_reg() will
re-enable it along with the target GPE.

To fix this issue rework acpi_hw_write_gpe_enable_reg() so that it
calls acpi_hw_low_set_gpe() with a special action value,
ACPI_GPE_COND_ENABLE, that will make it only enable the GPE if the
corresponding bit in its register's enable_for_run mask is set.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Signed-off-by: Len Brown <len.brown@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/acpi/acpica/hwgpe.c |   18 +++++-------------
 include/acpi/actypes.h      |    1 +
 2 files changed, 6 insertions(+), 13 deletions(-)

--- a/drivers/acpi/acpica/hwgpe.c
+++ b/drivers/acpi/acpica/hwgpe.c
@@ -118,6 +118,10 @@ acpi_hw_low_set_gpe(struct acpi_gpe_even
 	register_bit = acpi_hw_gpe_register_bit(gpe_event_info,
 						gpe_register_info);
 	switch (action) {
+	case ACPI_GPE_COND_ENABLE:
+		if (!(register_bit & gpe_register_info->enable_for_run))
+			return (AE_BAD_PARAMETER);
+
 	case ACPI_GPE_ENABLE:
 		ACPI_SET_BIT(enable_mask, register_bit);
 		break;
@@ -154,23 +158,11 @@ acpi_hw_low_set_gpe(struct acpi_gpe_even
 acpi_status
 acpi_hw_write_gpe_enable_reg(struct acpi_gpe_event_info * gpe_event_info)
 {
-	struct acpi_gpe_register_info *gpe_register_info;
 	acpi_status status;
 
 	ACPI_FUNCTION_ENTRY();
 
-	/* Get the info block for the entire GPE register */
-
-	gpe_register_info = gpe_event_info->register_info;
-	if (!gpe_register_info) {
-		return (AE_NOT_EXIST);
-	}
-
-	/* Write the entire GPE (runtime) enable register */
-
-	status = acpi_hw_write(gpe_register_info->enable_for_run,
-			       &gpe_register_info->enable_address);
-
+	status = acpi_hw_low_set_gpe(gpe_event_info, ACPI_GPE_COND_ENABLE);
 	return (status);
 }
 
--- a/include/acpi/actypes.h
+++ b/include/acpi/actypes.h
@@ -665,6 +665,7 @@ typedef u32 acpi_event_status;
 
 #define ACPI_GPE_ENABLE                 0
 #define ACPI_GPE_DISABLE                1
+#define ACPI_GPE_COND_ENABLE            2
 
 /*
  * GPE info flags - Per GPE


