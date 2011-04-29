Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933598Ab1D2TD2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 15:03:28 -0400
Received: from kroah.org ([198.145.64.141]:50348 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933241Ab1D2S6g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 14:58:36 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Apr 29 11:56:56 2011
Message-Id: <20110429185655.957385536@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Fri, 29 Apr 2011 11:55:58 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Len Brown <lenb@kernel.org>
Subject: [35/55] ACPI / PM: Avoid infinite recurrence while registering power resources
In-Reply-To: <20110429185706.GA12824@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Rafael J. Wysocki <rjw@sisk.pl>

commit 7bed50c5edf5cba8dd515a31191cbfb6065ddc85 upstream.

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
Acked-by: Len Brown <lenb@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/acpi/scan.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/acpi/scan.c
+++ b/drivers/acpi/scan.c
@@ -944,6 +944,10 @@ static int acpi_bus_get_flags(struct acp
 	if (ACPI_SUCCESS(status))
 		device->flags.lockable = 1;
 
+	/* Power resources cannot be power manageable. */
+	if (device->device_type == ACPI_BUS_TYPE_POWER)
+		return 0;
+
 	/* Presence of _PS0|_PR0 indicates 'power manageable' */
 	status = acpi_get_handle(device->handle, "_PS0", &temp);
 	if (ACPI_FAILURE(status))


