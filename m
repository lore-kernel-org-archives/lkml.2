Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967490Ab2ERU5o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 16:57:44 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:53350 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933163Ab2ERU5P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 16:57:15 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: ACPI Devel Mailing List <linux-acpi@vger.kernel.org>
Subject: [PATCH 2/2] ACPI / PM: Make __acpi_bus_get_power() cover D3cold correctly
Date: Fri, 18 May 2012 23:01:56 +0200
User-Agent: KMail/1.13.6 (Linux/3.4.0-rc7+; KDE/4.6.0; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>, Len Brown <lenb@kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Lin Ming <ming.m.lin@intel.com>
References: <201205142253.57023.rjw@sisk.pl> <201205182258.56497.rjw@sisk.pl>
In-Reply-To: <201205182258.56497.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201205182301.56478.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

After recent changes of the ACPI device power states definitions, if
power resources are not used for the device's power management, the
state returned by __acpi_bus_get_power() cannot exceed D3hot, because
the return values of _PSC are 0 through 3.  However, if the _PR3
method is not present for the device and _PS3 returns 3, we have to
assume that the device is in D3cold, so the value returned by
__acpi_bus_get_power() in that case should be 4.

Similarly, acpi_power_get_inferred_state() should take the power
resources for the D3hot state into account in general, so that it
can return 3 if those resources are "on" or 4 (D3cold) otherwise.

Fix the the above two issues and make sure that if both _PSC and
_PR3 are present for the device, the power resources listed by _PR3
will be used to determine if the number 3 returned by _PSC is meant
to represent D3cold or D3hot.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/acpi/bus.c   |   51 +++++++++++++++++++++++++++++----------------------
 drivers/acpi/power.c |    2 +-
 2 files changed, 30 insertions(+), 23 deletions(-)

Index: linux/drivers/acpi/bus.c
===================================================================
--- linux.orig/drivers/acpi/bus.c
+++ linux/drivers/acpi/bus.c
@@ -202,37 +202,44 @@ static char *state_string(int state)
 
 static int __acpi_bus_get_power(struct acpi_device *device, int *state)
 {
-	int result = 0;
-	acpi_status status = 0;
-	unsigned long long psc = 0;
+	int result = ACPI_STATE_UNKNOWN;
 
 	if (!device || !state)
 		return -EINVAL;
 
-	*state = ACPI_STATE_UNKNOWN;
-
-	if (device->flags.power_manageable) {
-		/*
-		 * Get the device's power state either directly (via _PSC) or
-		 * indirectly (via power resources).
-		 */
-		if (device->power.flags.power_resources) {
-			result = acpi_power_get_inferred_state(device, state);
-			if (result)
-				return result;
-		} else if (device->power.flags.explicit_get) {
-			status = acpi_evaluate_integer(device->handle, "_PSC",
-						       NULL, &psc);
-			if (ACPI_FAILURE(status))
-				return -ENODEV;
-			*state = (int)psc;
-		}
-	} else {
+	if (!device->flags.power_manageable) {
 		/* TBD: Non-recursive algorithm for walking up hierarchy. */
 		*state = device->parent ?
 			device->parent->power.state : ACPI_STATE_D0;
+		goto out;
+	}
+
+	/*
+	 * Get the device's power state either directly (via _PSC) or
+	 * indirectly (via power resources).
+	 */
+	if (device->power.flags.explicit_get) {
+		unsigned long long psc;
+		acpi_status status = acpi_evaluate_integer(device->handle,
+							   "_PSC", NULL, &psc);
+		if (ACPI_FAILURE(status))
+			return -ENODEV;
+
+		result = psc;
+	}
+	/* The test below covers ACPI_STATE_UNKNOWN too. */
+	if (result <= ACPI_STATE_D2) {
+	  ; /* Do nothing. */
+	} else if (device->power.flags.power_resources) {
+		int error = acpi_power_get_inferred_state(device, &result);
+		if (error)
+			return error;
+	} else if (result == ACPI_STATE_D3_HOT) {
+		result = ACPI_STATE_D3;
 	}
+	*state = result;
 
+ out:
 	ACPI_DEBUG_PRINT((ACPI_DB_INFO, "Device [%s] power state is %s\n",
 			  device->pnp.bus_id, state_string(*state)));
 
Index: linux/drivers/acpi/power.c
===================================================================
--- linux.orig/drivers/acpi/power.c
+++ linux/drivers/acpi/power.c
@@ -631,7 +631,7 @@ int acpi_power_get_inferred_state(struct
 	 * We know a device's inferred power state when all the resources
 	 * required for a given D-state are 'on'.
 	 */
-	for (i = ACPI_STATE_D0; i < ACPI_STATE_D3_HOT; i++) {
+	for (i = ACPI_STATE_D0; i <= ACPI_STATE_D3_HOT; i++) {
 		list = &device->power.states[i].resources;
 		if (list->count < 1)
 			continue;

