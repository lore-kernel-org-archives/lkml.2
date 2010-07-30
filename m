Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933024Ab0G3SGS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 14:06:18 -0400
Received: from kroah.org ([198.145.64.141]:59257 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932825Ab0G3R5w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 13:57:52 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Jul 30 10:51:51 2010
Message-Id: <20100730175151.224995607@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 30 Jul 2010 10:53:28 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Len Brown <len.brown@intel.com>
Subject: [191/205] ACPI / ACPICA: Fix GPE initialization
In-Reply-To: <20100730175238.GA3924@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.34-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Rafael J. Wysocki <rjw@sisk.pl>

commit ce43ace02320a3fb9614ddb27edc3a8700d68b26 upstream.

While developing the GPE reference counting code we overlooked the
fact that acpi_ev_update_gpes() could have enabled GPEs before
acpi_ev_initialize_gpe_block() was called.  As a result, some GPEs
are enabled twice during the initialization.

To fix this issue avoid calling acpi_enable_gpe() from
acpi_ev_initialize_gpe_block() for the GPEs that have nonzero
runtime reference counters.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Signed-off-by: Len Brown <len.brown@intel.com>

---
 drivers/acpi/acpica/evgpeblk.c |   14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

--- a/drivers/acpi/acpica/evgpeblk.c
+++ b/drivers/acpi/acpica/evgpeblk.c
@@ -1023,6 +1023,19 @@ acpi_ev_initialize_gpe_block(struct acpi
 			/* Get the info block for this particular GPE */
 			gpe_index = (acpi_size)i * ACPI_GPE_REGISTER_WIDTH + j;
 			gpe_event_info = &gpe_block->event_info[gpe_index];
+			gpe_number = gpe_index + gpe_block->block_base_number;
+
+			/*
+			 * If the GPE has already been enabled for runtime
+			 * signaling, make sure it remains enabled, but do not
+			 * increment its reference counter.
+			 */
+			if (gpe_event_info->runtime_count) {
+				acpi_set_gpe(gpe_device, gpe_number,
+						ACPI_GPE_ENABLE);
+				gpe_enabled_count++;
+				continue;
+			}
 
 			if (gpe_event_info->flags & ACPI_GPE_CAN_WAKE) {
 				wake_gpe_count++;
@@ -1033,7 +1046,6 @@ acpi_ev_initialize_gpe_block(struct acpi
 			if (!(gpe_event_info->flags & ACPI_GPE_DISPATCH_METHOD))
 				continue;
 
-			gpe_number = gpe_index + gpe_block->block_base_number;
 			status = acpi_enable_gpe(gpe_device, gpe_number,
 						ACPI_GPE_TYPE_RUNTIME);
 			if (ACPI_FAILURE(status))


