Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754566Ab0FHJBg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jun 2010 05:01:36 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:37159 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754301Ab0FHJAi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jun 2010 05:00:38 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Len Brown <lenb@kernel.org>
Subject: [PATCH 4/5] ACPI / ACPICA: Fix GPE initialization
Date: Tue, 8 Jun 2010 10:50:20 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.35-rc1-rjw; KDE/4.3.5; x86_64; ; )
Cc: Matthew Garrett <mjg59@srcf.ucam.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       "Moore, Robert" <robert.moore@intel.com>,
       Len Brown <len.brown@intel.com>, Zhang Rui <rui.zhang@intel.com>
References: <201006080024.46142.rjw@sisk.pl> <201006081046.48488.rjw@sisk.pl>
In-Reply-To: <201006081046.48488.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201006081050.20475.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

While developing the GPE reference counting code we overlooked the
fact that acpi_ev_update_gpes() could have enabled GPEs before
acpi_ev_initialize_gpe_block() was called.  As a result, some GPEs
are enabled twice during the initialization.

To fix this issue avoid calling acpi_enable_gpe() from
acpi_ev_initialize_gpe_block() for the GPEs that have nonzero
runtime reference counters.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/acpi/acpica/evgpeblk.c |   14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

Index: linux-2.6/drivers/acpi/acpica/evgpeblk.c
===================================================================
--- linux-2.6.orig/drivers/acpi/acpica/evgpeblk.c
+++ linux-2.6/drivers/acpi/acpica/evgpeblk.c
@@ -500,6 +500,19 @@ acpi_ev_initialize_gpe_block(struct acpi
 
 			gpe_index = (i * ACPI_GPE_REGISTER_WIDTH) + j;
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
@@ -516,7 +529,6 @@ acpi_ev_initialize_gpe_block(struct acpi
 
 			/* Enable this GPE */
 
-			gpe_number = gpe_index + gpe_block->block_base_number;
 			status = acpi_enable_gpe(gpe_device, gpe_number,
 						 ACPI_GPE_TYPE_RUNTIME);
 			if (ACPI_FAILURE(status)) {

