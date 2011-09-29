Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757977Ab1I2V0g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 17:26:36 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:37976 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756926Ab1I2V0e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 17:26:34 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Subject: Re: PME via interrupt or SCI mechanism?
Date: Thu, 29 Sep 2011 23:28:45 +0200
User-Agent: KMail/1.13.6 (Linux/3.1.0-rc8+; KDE/4.6.0; x86_64; ; )
Cc: linux-acpi@vger.kernel.org, linux-pci@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>
References: <20110912171003.GA7939@xanatos> <201109292139.56626.rjw@sisk.pl> <20110929204440.GA6043@xanatos>
In-Reply-To: <20110929204440.GA6043@xanatos>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201109292328.45375.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, September 29, 2011, Sarah Sharp wrote:
> On Thu, Sep 29, 2011 at 09:39:56PM +0200, Rafael J. Wysocki wrote:
> > On Thursday, September 29, 2011, Sarah Sharp wrote:
> > > On Thu, Sep 29, 2011 at 12:21:28AM +0200, Rafael J. Wysocki wrote:
> > Please try the appended patch and check if you see the "Notification error
> > for GPE" message (please keep your previous debug patches applied).
> 
> Do I need to have the ACPI debug_level or debug_layer set to anything in
> particular to see this message?

No, I don't think so, but just in case please try the patch below instead
of the previous one.

Thanks,
Rafael

---
 drivers/acpi/acpica/evgpe.c |   14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

Index: linux/drivers/acpi/acpica/evgpe.c
===================================================================
--- linux.orig/drivers/acpi/acpica/evgpe.c
+++ linux/drivers/acpi/acpica/evgpe.c
@@ -521,12 +521,24 @@ static void ACPI_SYSTEM_XFACE acpi_ev_as
 		status = acpi_ev_queue_notify_request(
 				local_gpe_event_info->dispatch.device.node,
 				ACPI_NOTIFY_DEVICE_WAKE);
+		if (ACPI_FAILURE(status))
+			pr_err("Notification error for GPE 0x%X",
+				local_gpe_event_info->gpe_number);
+		else
+			pr_info("Notification queued up for GPE 0x%X",
+				local_gpe_event_info->gpe_number);
 
 		notify_object = local_gpe_event_info->dispatch.device.next;
-		while (ACPI_SUCCESS(status) && notify_object) {
+		while (notify_object) {
 			status = acpi_ev_queue_notify_request(
 					notify_object->node,
 					ACPI_NOTIFY_DEVICE_WAKE);
+			if (ACPI_FAILURE(status))
+				pr_err("Notification error for GPE 0x%X",
+					local_gpe_event_info->gpe_number);
+			else
+				pr_info("Notification queued up for GPE 0x%X",
+					local_gpe_event_info->gpe_number);
 			notify_object = notify_object->next;
 		}
 
