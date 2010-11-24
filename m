Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932083Ab0KXXQv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 18:16:51 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:52716 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756544Ab0KXXQk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 18:16:40 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Len Brown <lenb@kernel.org>
Subject: [PATCH 1/13] ACPI / PM: Check device state before refcounting power resources
Date: Thu, 25 Nov 2010 00:02:36 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37-rc3+; KDE/4.4.4; x86_64; ; )
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Linux-pm mailing list" <linux-pm@lists.linux-foundation.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>
References: <201011250001.11297.rjw@sisk.pl>
In-Reply-To: <201011250001.11297.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201011250002.37114.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Commit 3e384ee6c687cb397581ee8f9440fc8220cfac80 (ACPI / PM: Fix
reference counting of power resources) introduced a regression by
causing fan power resources to be turned on and reference counted
unnecessarily during resume, so on some boxes fans are always on
after resume.

Fix the problem by checking if the current device state is different
from the new state before reference counting and turning on power
resources in acpi_power_transition().

Addresses https://bugzilla.kernel.org/show_bug.cgi?id=22932 .

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Reported-and-tested-by: Maciej Rutecki <maciej.rutecki@gmail.com>
---
 drivers/acpi/power.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

Index: linux-2.6/drivers/acpi/power.c
===================================================================
--- linux-2.6.orig/drivers/acpi/power.c
+++ linux-2.6/drivers/acpi/power.c
@@ -465,10 +465,12 @@ int acpi_power_transition(struct acpi_de
 	struct acpi_handle_list *tl = NULL;	/* Target Resources */
 	int i = 0;
 
-
 	if (!device || (state < ACPI_STATE_D0) || (state > ACPI_STATE_D3))
 		return -EINVAL;
 
+	if (device->power.state == state)
+		return 0;
+
 	if ((device->power.state < ACPI_STATE_D0)
 	    || (device->power.state > ACPI_STATE_D3))
 		return -ENODEV;
@@ -488,10 +490,6 @@ int acpi_power_transition(struct acpi_de
 			goto end;
 	}
 
-	if (device->power.state == state) {
-		goto end;
-	}
-
 	/*
 	 * Then we dereference all power resources used in the current list.
 	 */

