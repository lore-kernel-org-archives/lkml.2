Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752368Ab1DYUPw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 16:15:52 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:48876 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751095Ab1DYUPv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 16:15:51 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux PM mailing list <linux-pm@lists.linux-foundation.org>
Subject: [PATCH] ACPI / PM: Avoid infinite recurrence while registering power resources
Date: Mon, 25 Apr 2011 22:15:58 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.39-rc4+; KDE/4.6.0; x86_64; ; )
Cc: Len Brown <lenb@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        ACPI Devel Mailing List <linux-acpi@vger.kernel.org>,
        Pascal Dormeau <pdormeau@free.fr>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201104252215.58860.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

There is at least one BIOS with a DSDT containing a power resource
object with a _PR0 entry pointing back to that power resource.  In
consequence, while registering that power resource
acpi_bus_get_power_flags() sees that it depends on itself and tries
to register it again, which leads to an infinitely deep recurrence.
This problem was introduced by commit bf325f9538d8c89312be305b9779e
(ACPI / PM: Register power resource devices as soon as they are
needed).

To fix this problem use the observation that power resources cannot
be power manageable and prevent acpi_bus_get_power_flags() from
being called for power resource objects.

References: https://bugzilla.kernel.org/show_bug.cgi?id=31872
Reported-and-tested-by: Pascal Dormeau <pdormeau@free.fr>
Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/acpi/scan.c |    4 ++++
 1 file changed, 4 insertions(+)

Index: linux-2.6/drivers/acpi/scan.c
===================================================================
--- linux-2.6.orig/drivers/acpi/scan.c
+++ linux-2.6/drivers/acpi/scan.c
@@ -943,6 +943,10 @@ static int acpi_bus_get_flags(struct acp
 	if (ACPI_SUCCESS(status))
 		device->flags.lockable = 1;
 
+	/* Power resources cannot be power manageable. */
+	if (device->device_type == ACPI_BUS_TYPE_POWER)
+		return 0;
+
 	/* Presence of _PS0|_PR0 indicates 'power manageable' */
 	status = acpi_get_handle(device->handle, "_PS0", &temp);
 	if (ACPI_FAILURE(status))
