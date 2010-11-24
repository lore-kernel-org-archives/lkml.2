Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932128Ab0KXXQz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 18:16:55 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:52715 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754641Ab0KXXQi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 18:16:38 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Len Brown <lenb@kernel.org>
Subject: [PATCH 3/13] ACPI / PM: Prevent acpi_power_get_inferred_state() from making changes
Date: Thu, 25 Nov 2010 00:05:17 +0100
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
Message-Id: <201011250005.17710.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

acpi_power_get_inferred_state() should not update
device->power.state behind the back of its caller, so make it return
the state via a pointer instead.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/acpi/bus.c      |    3 ++-
 drivers/acpi/internal.h |    2 +-
 drivers/acpi/power.c    |   12 ++++--------
 3 files changed, 7 insertions(+), 10 deletions(-)

Index: linux-2.6/drivers/acpi/power.c
===================================================================
--- linux-2.6.orig/drivers/acpi/power.c
+++ linux-2.6/drivers/acpi/power.c
@@ -423,19 +423,16 @@ int acpi_disable_wakeup_device_power(str
                              Device Power Management
    -------------------------------------------------------------------------- */
 
-int acpi_power_get_inferred_state(struct acpi_device *device)
+int acpi_power_get_inferred_state(struct acpi_device *device, int *state)
 {
 	int result = 0;
 	struct acpi_handle_list *list = NULL;
 	int list_state = 0;
 	int i = 0;
 
-
-	if (!device)
+	if (!device || !state)
 		return -EINVAL;
 
-	device->power.state = ACPI_STATE_UNKNOWN;
-
 	/*
 	 * We know a device's inferred power state when all the resources
 	 * required for a given D-state are 'on'.
@@ -450,13 +447,12 @@ int acpi_power_get_inferred_state(struct
 			return result;
 
 		if (list_state == ACPI_POWER_RESOURCE_STATE_ON) {
-			device->power.state = i;
+			*state = i;
 			return 0;
 		}
 	}
 
-	device->power.state = ACPI_STATE_D3;
-
+	*state = ACPI_STATE_D3;
 	return 0;
 }
 
Index: linux-2.6/drivers/acpi/bus.c
===================================================================
--- linux-2.6.orig/drivers/acpi/bus.c
+++ linux-2.6/drivers/acpi/bus.c
@@ -222,7 +222,8 @@ int acpi_bus_get_power(acpi_handle handl
 		 * indirectly (via power resources).
 		 */
 		if (device->power.flags.power_resources) {
-			result = acpi_power_get_inferred_state(device);
+			result = acpi_power_get_inferred_state(device,
+							&device->power.state);
 			if (result)
 				return result;
 		} else if (device->power.flags.explicit_get) {
Index: linux-2.6/drivers/acpi/internal.h
===================================================================
--- linux-2.6.orig/drivers/acpi/internal.h
+++ linux-2.6/drivers/acpi/internal.h
@@ -41,7 +41,7 @@ static inline int acpi_debugfs_init(void
 int acpi_power_init(void);
 int acpi_device_sleep_wake(struct acpi_device *dev,
                            int enable, int sleep_state, int dev_state);
-int acpi_power_get_inferred_state(struct acpi_device *device);
+int acpi_power_get_inferred_state(struct acpi_device *device, int *state);
 int acpi_power_transition(struct acpi_device *device, int state);
 extern int acpi_power_nocheck;
 

