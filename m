Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756583Ab0KXXQl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 18:16:41 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:52714 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756470Ab0KXXQi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 18:16:38 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Len Brown <lenb@kernel.org>
Subject: [PATCH 4/13] ACPI / PM: Add functions for manipulating lists of power resources
Date: Thu, 25 Nov 2010 00:06:09 +0100
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
Message-Id: <201011250006.09337.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

ACPI device power resources should be reference counted during
device initialization, so that their reference counters are always
up to date.  It is convenient to do that with the help of a function
that will reference count and possibly turn on power resources in
a given list, so introduce that function, acpi_power_on_list().
For symmetry, introduce acpi_power_off_list() for performing the
reverse operation and use the both of them to simplify
acpi_power_transition().

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/acpi/power.c |   67 ++++++++++++++++++++++++++++-----------------------
 1 file changed, 38 insertions(+), 29 deletions(-)

Index: linux-2.6/drivers/acpi/power.c
===================================================================
--- linux-2.6.orig/drivers/acpi/power.c
+++ linux-2.6/drivers/acpi/power.c
@@ -266,6 +266,35 @@ static int acpi_power_off_device(acpi_ha
 	return result;
 }
 
+static void __acpi_power_off_list(struct acpi_handle_list *list, int num_res)
+{
+	int i;
+
+	for (i = num_res - 1; i >= 0 ; i--)
+		acpi_power_off_device(list->handles[i]);
+}
+
+static void acpi_power_off_list(struct acpi_handle_list *list)
+{
+	__acpi_power_off_list(list, list->count);
+}
+
+static int acpi_power_on_list(struct acpi_handle_list *list)
+{
+	int result = 0;
+	int i;
+
+	for (i = 0; i < list->count; i++) {
+		result = acpi_power_on(list->handles[i]);
+		if (result) {
+			__acpi_power_off_list(list, i);
+			break;
+		}
+	}
+
+	return result;
+}
+
 /**
  * acpi_device_sleep_wake - execute _DSW (Device Sleep Wake) or (deprecated in
  *                          ACPI 3.0) _PSW (Power State Wake)
@@ -458,10 +487,7 @@ int acpi_power_get_inferred_state(struct
 
 int acpi_power_transition(struct acpi_device *device, int state)
 {
-	int result = 0;
-	struct acpi_handle_list *cl = NULL;	/* Current Resources */
-	struct acpi_handle_list *tl = NULL;	/* Target Resources */
-	int i = 0;
+	int result;
 
 	if (!device || (state < ACPI_STATE_D0) || (state > ACPI_STATE_D3))
 		return -EINVAL;
@@ -473,37 +499,20 @@ int acpi_power_transition(struct acpi_de
 	    || (device->power.state > ACPI_STATE_D3))
 		return -ENODEV;
 
-	cl = &device->power.states[device->power.state].resources;
-	tl = &device->power.states[state].resources;
-
 	/* TBD: Resources must be ordered. */
 
 	/*
 	 * First we reference all power resources required in the target list
-	 * (e.g. so the device doesn't lose power while transitioning).
-	 */
-	for (i = 0; i < tl->count; i++) {
-		result = acpi_power_on(tl->handles[i]);
-		if (result)
-			goto end;
-	}
-
-	/*
-	 * Then we dereference all power resources used in the current list.
+	 * (e.g. so the device doesn't lose power while transitioning).  Then,
+	 * we dereference all power resources used in the current list.
 	 */
-	for (i = 0; i < cl->count; i++) {
-		result = acpi_power_off_device(cl->handles[i]);
-		if (result)
-			goto end;
-	}
+	result = acpi_power_on_list(&device->power.states[state].resources);
+	if (!result)
+		acpi_power_off_list(
+			&device->power.states[device->power.state].resources);
 
-     end:
-	if (result)
-		device->power.state = ACPI_STATE_UNKNOWN;
-	else {
-	/* We shouldn't change the state till all above operations succeed */
-		device->power.state = state;
-	}
+	/* We shouldn't change the state unless the above operations succeed. */
+	device->power.state = result ? ACPI_STATE_UNKNOWN : state;
 
 	return result;
 }

