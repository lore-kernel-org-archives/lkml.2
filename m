Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030514Ab2EQWem (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 18:34:42 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:51236 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030477Ab2EQWei convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 18:34:38 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH] ACPI / PCI / PM: Fix device PM regression related to D3hot/D3cold
Date: Fri, 18 May 2012 00:39:35 +0200
User-Agent: KMail/1.13.6 (Linux/3.4.0-rc7+; KDE/4.6.0; x86_64; ; )
Cc: Len Brown <lenb@kernel.org>, Lekensteyn <lekensteyn@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        ACPI Devel Mailing List <linux-acpi@vger.kernel.org>,
        Lin Ming <ming.m.lin@intel.com>,
        Cristian =?utf-8?q?Rodr=C3=ADguez?= <crrodriguez@opensuse.org>,
        rocko <rockorequin@hotmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201205180039.35318.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Commit 1cc0c998fdf2cb665d625fb565a0d6db5c81c639 (ACPI: Fix D3hot
v D3cold confusion) introduced a bug in __acpi_bus_set_power() and
changed the behavior of acpi_pci_set_power_state() in such a way that
it generally doesn't work as expected if PCI_D3hot is passed to it
as the second argument.

First off, if ACPI_STATE_D3 (equal to ACPI_STATE_D3_COLD) is passed
to __acpi_bus_set_power() and the explicit_set flag is set for the
D3cold state, the function will try to execute AML method called
"_PS4", which doesn't exist.

Fix this by adding a check to ensure that the name of the AML method
to execute for transitions to ACPI_STATE_D3_COLD is correct in
__acpi_bus_set_power().  Also make sure that the explicit_set flag
for ACPI_STATE_D3_COLD will be set if _PS3 is present and modify
acpi_power_transition() to avoid accessing power resources for
ACPI_STATE_D3_COLD, because they don't exist.

Second, if PCI_D3hot is passed to acpi_pci_set_power_state() as the
target state, the function will request a transition to
ACPI_STATE_D3_HOT instead of ACPI_STATE_D3.  However,
ACPI_STATE_D3_HOT is now only marked as supported if the _PR3 AML
method is defined for the given device, which is rare.  This causes
problems to happen on systems where devices were successfully put
into ACPI D3 by pci_set_power_state(PCI_D3hot) which doesn't work
now.  In particular, some unused graphics adapters are not turned
off as a result.

To fix this issue restore the old behavior of
acpi_pci_set_power_state(), which is to request a transition to
ACPI_STATE_D3 (equal to ACPI_STATE_D3_COLD) if either PCI_D3hot or
PCI_D3cold is passed to it as the argument.

This approach is not ideal, because generally power should not
be removed from devices if PCI_D3hot is the target power state,
but since this behavior is relied on, we have no choice but to
restore it at the moment and spend more time on designing a
better solution in the future.

References: https://bugzilla.kernel.org/show_bug.cgi?id=43228
Reported-by: rocko <rockorequin@hotmail.com>
Reported-by: Cristian Rodríguez <crrodriguez@opensuse.org>
Reported-and-tested-by: Peter <lekensteyn@gmail.com>
Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---

Hi Linus,

Could you please take this one directly?  It fixes obvious bugs and
makes pci_set_power_state(PCI_D3hot) work the same way as it did in
v3.3 and before, which is quite a big deal IMO.

Thanks,
Rafael

---
 drivers/acpi/bus.c     |    4 ++++
 drivers/acpi/power.c   |    9 ++++++---
 drivers/acpi/scan.c    |    4 ++++
 drivers/pci/pci-acpi.c |    2 +-
 4 files changed, 15 insertions(+), 4 deletions(-)

Index: linux/drivers/pci/pci-acpi.c
===================================================================
--- linux.orig/drivers/pci/pci-acpi.c
+++ linux/drivers/pci/pci-acpi.c
@@ -223,7 +223,7 @@ static int acpi_pci_set_power_state(stru
 		[PCI_D0] = ACPI_STATE_D0,
 		[PCI_D1] = ACPI_STATE_D1,
 		[PCI_D2] = ACPI_STATE_D2,
-		[PCI_D3hot] = ACPI_STATE_D3_HOT,
+		[PCI_D3hot] = ACPI_STATE_D3,
 		[PCI_D3cold] = ACPI_STATE_D3
 	};
 	int error = -EINVAL;
Index: linux/drivers/acpi/bus.c
===================================================================
--- linux.orig/drivers/acpi/bus.c
+++ linux/drivers/acpi/bus.c
@@ -250,6 +250,10 @@ static int __acpi_bus_set_power(struct a
 		return -ENODEV;
 	}
 
+	/* For D3cold we should execute _PS3, not _PS4. */
+	if (state == ACPI_STATE_D3_COLD)
+		object_name[3] = '3';
+
 	/*
 	 * Transition Power
 	 * ----------------
Index: linux/drivers/acpi/scan.c
===================================================================
--- linux.orig/drivers/acpi/scan.c
+++ linux/drivers/acpi/scan.c
@@ -908,6 +908,10 @@ static int acpi_bus_get_power_flags(stru
 	device->power.states[ACPI_STATE_D3].flags.valid = 1;
 	device->power.states[ACPI_STATE_D3].power = 0;
 
+	/* Set D3cold's explicit_set flag if _PS3 exists. */
+	if (device->power.states[ACPI_STATE_D3_HOT].flags.explicit_set)
+		device->power.states[ACPI_STATE_D3_COLD].flags.explicit_set = 1;
+
 	acpi_bus_init_power(device);
 
 	return 0;
Index: linux/drivers/acpi/power.c
===================================================================
--- linux.orig/drivers/acpi/power.c
+++ linux/drivers/acpi/power.c
@@ -660,7 +660,7 @@ int acpi_power_on_resources(struct acpi_
 
 int acpi_power_transition(struct acpi_device *device, int state)
 {
-	int result;
+	int result = 0;
 
 	if (!device || (state < ACPI_STATE_D0) || (state > ACPI_STATE_D3_COLD))
 		return -EINVAL;
@@ -679,8 +679,11 @@ int acpi_power_transition(struct acpi_de
 	 * (e.g. so the device doesn't lose power while transitioning).  Then,
 	 * we dereference all power resources used in the current list.
 	 */
-	result = acpi_power_on_list(&device->power.states[state].resources);
-	if (!result)
+	if (state < ACPI_STATE_D3_COLD)
+		result = acpi_power_on_list(
+			&device->power.states[state].resources);
+
+	if (!result && device->power.state < ACPI_STATE_D3_COLD)
 		acpi_power_off_list(
 			&device->power.states[device->power.state].resources);
 
