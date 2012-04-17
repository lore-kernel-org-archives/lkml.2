Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754648Ab2DQFsV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 01:48:21 -0400
Received: from mga14.intel.com ([143.182.124.37]:49201 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754236Ab2DQFsT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 01:48:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="89863278"
From: Lin Ming <ming.m.lin@intel.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>, Len Brown <lenb@kernel.og>
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        Zhang Rui <rui.zhang@intel.com>,
        Huang Ying <huang.ying.caritas@gmail.com>, Aaron Lu <aaron.lu@amd.com>
Subject: [PATCH 6/6] ACPI: Rename ACPI_STATE_D3 to ACPI_STATE_D3_HOT
Date: Tue, 17 Apr 2012 13:47:56 +0800
Message-Id: <1334641676-14566-7-git-send-email-ming.m.lin@intel.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1334641676-14566-1-git-send-email-ming.m.lin@intel.com>
References: <1334641676-14566-1-git-send-email-ming.m.lin@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So now there are 2 clear ACPI D3 states:
ACPI_STATE_D3_HOT and ACPI_STATE_D3_COLD.

Signed-off-by: Lin Ming <ming.m.lin@intel.com>
---
 drivers/acpi/fan.c         |    4 ++--
 drivers/acpi/power.c       |    4 ++--
 drivers/acpi/scan.c        |    2 +-
 drivers/ata/libata-acpi.c  |    4 ++--
 drivers/ide/ide-acpi.c     |    4 ++--
 drivers/pci/pci-acpi.c     |    4 ++--
 drivers/pnp/pnpacpi/core.c |    4 ++--
 include/acpi/actypes.h     |    2 +-
 8 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/acpi/fan.c b/drivers/acpi/fan.c
index 0f0356c..6f57272 100644
--- a/drivers/acpi/fan.c
+++ b/drivers/acpi/fan.c
@@ -90,7 +90,7 @@ static int fan_get_cur_state(struct thermal_cooling_device *cdev, unsigned long
 	if (result)
 		return result;
 
-	*state = (acpi_state == ACPI_STATE_D3 ? 0 :
+	*state = (acpi_state == ACPI_STATE_D3_HOT ? 0 :
 		 (acpi_state == ACPI_STATE_D0 ? 1 : -1));
 	return 0;
 }
@@ -105,7 +105,7 @@ fan_set_cur_state(struct thermal_cooling_device *cdev, unsigned long state)
 		return -EINVAL;
 
 	result = acpi_bus_set_power(device->handle,
-				state ? ACPI_STATE_D0 : ACPI_STATE_D3);
+				state ? ACPI_STATE_D0 : ACPI_STATE_D3_HOT);
 
 	return result;
 }
diff --git a/drivers/acpi/power.c b/drivers/acpi/power.c
index d6065110..e84759f 100644
--- a/drivers/acpi/power.c
+++ b/drivers/acpi/power.c
@@ -631,7 +631,7 @@ int acpi_power_get_inferred_state(struct acpi_device *device, int *state)
 	 * We know a device's inferred power state when all the resources
 	 * required for a given D-state are 'on'.
 	 */
-	for (i = ACPI_STATE_D0; i < ACPI_STATE_D3; i++) {
+	for (i = ACPI_STATE_D0; i < ACPI_STATE_D3_HOT; i++) {
 		list = &device->power.states[i].resources;
 		if (list->count < 1)
 			continue;
@@ -652,7 +652,7 @@ int acpi_power_get_inferred_state(struct acpi_device *device, int *state)
 
 int acpi_power_on_resources(struct acpi_device *device, int state)
 {
-	if (!device || state < ACPI_STATE_D0 || state > ACPI_STATE_D3)
+	if (!device || state < ACPI_STATE_D0 || state > ACPI_STATE_D3_HOT)
 		return -EINVAL;
 
 	return acpi_power_on_list(&device->power.states[state].resources);
diff --git a/drivers/acpi/scan.c b/drivers/acpi/scan.c
index fb56388..1fbb2a2 100644
--- a/drivers/acpi/scan.c
+++ b/drivers/acpi/scan.c
@@ -869,7 +869,7 @@ static int acpi_bus_get_power_flags(struct acpi_device *device)
 	/*
 	 * Enumerate supported power management states
 	 */
-	for (i = ACPI_STATE_D0; i <= ACPI_STATE_D3; i++) {
+	for (i = ACPI_STATE_D0; i <= ACPI_STATE_D3_HOT; i++) {
 		struct acpi_device_power_state *ps = &device->power.states[i];
 		char object_name[5] = { '_', 'P', 'R', '0' + i, '\0' };
 
diff --git a/drivers/ata/libata-acpi.c b/drivers/ata/libata-acpi.c
index bb7c5f1..27e0e56 100644
--- a/drivers/ata/libata-acpi.c
+++ b/drivers/ata/libata-acpi.c
@@ -920,10 +920,10 @@ void ata_acpi_set_state(struct ata_port *ap, pm_message_t state)
 		if (dev->acpi_handle)
 			acpi_bus_set_power(dev->acpi_handle,
 				state.event == PM_EVENT_ON ?
-					ACPI_STATE_D0 : ACPI_STATE_D3);
+					ACPI_STATE_D0 : ACPI_STATE_D3_HOT);
 	}
 	if (state.event != PM_EVENT_ON)
-		acpi_bus_set_power(ap->acpi_handle, ACPI_STATE_D3);
+		acpi_bus_set_power(ap->acpi_handle, ACPI_STATE_D3_HOT);
 }
 
 /**
diff --git a/drivers/ide/ide-acpi.c b/drivers/ide/ide-acpi.c
index f1a6796b..7524831 100644
--- a/drivers/ide/ide-acpi.c
+++ b/drivers/ide/ide-acpi.c
@@ -520,11 +520,11 @@ void ide_acpi_set_state(ide_hwif_t *hwif, int on)
 	ide_port_for_each_present_dev(i, drive, hwif) {
 		if (drive->acpidata->obj_handle)
 			acpi_bus_set_power(drive->acpidata->obj_handle,
-					   on ? ACPI_STATE_D0 : ACPI_STATE_D3);
+					   on ? ACPI_STATE_D0 : ACPI_STATE_D3_HOT);
 	}
 
 	if (!on)
-		acpi_bus_set_power(hwif->acpidata->obj_handle, ACPI_STATE_D3);
+		acpi_bus_set_power(hwif->acpidata->obj_handle, ACPI_STATE_D3_HOT);
 }
 
 /**
diff --git a/drivers/pci/pci-acpi.c b/drivers/pci/pci-acpi.c
index e641953..77aa4e1 100644
--- a/drivers/pci/pci-acpi.c
+++ b/drivers/pci/pci-acpi.c
@@ -200,7 +200,7 @@ static pci_power_t acpi_pci_choose_state(struct pci_dev *pdev)
 		return PCI_D1;
 	case ACPI_STATE_D2:
 		return PCI_D2;
-	case ACPI_STATE_D3:
+	case ACPI_STATE_D3_HOT:
 		return PCI_D3hot;
 	case ACPI_STATE_D3_COLD:
 		return PCI_D3cold;
@@ -223,7 +223,7 @@ static int acpi_pci_set_power_state(struct pci_dev *dev, pci_power_t state)
 		[PCI_D0] = ACPI_STATE_D0,
 		[PCI_D1] = ACPI_STATE_D1,
 		[PCI_D2] = ACPI_STATE_D2,
-		[PCI_D3hot] = ACPI_STATE_D3,
+		[PCI_D3hot] = ACPI_STATE_D3_HOT,
 		[PCI_D3cold] = ACPI_STATE_D3_COLD
 	};
 	int error = -EINVAL;
diff --git a/drivers/pnp/pnpacpi/core.c b/drivers/pnp/pnpacpi/core.c
index d21e8f5..9448ab9 100644
--- a/drivers/pnp/pnpacpi/core.c
+++ b/drivers/pnp/pnpacpi/core.c
@@ -128,7 +128,7 @@ static int pnpacpi_disable_resources(struct pnp_dev *dev)
 	/* acpi_unregister_gsi(pnp_irq(dev, 0)); */
 	ret = 0;
 	if (acpi_bus_power_manageable(handle))
-		acpi_bus_set_power(handle, ACPI_STATE_D3);
+		acpi_bus_set_power(handle, ACPI_STATE_D3_HOT);
 		/* continue even if acpi_bus_set_power() fails */
 	if (ACPI_FAILURE(acpi_evaluate_object(handle, "_DIS", NULL, NULL)))
 		ret = -ENODEV;
@@ -174,7 +174,7 @@ static int pnpacpi_suspend(struct pnp_dev *dev, pm_message_t state)
 
 		if (power_state < 0)
 			power_state = (state.event == PM_EVENT_ON) ?
-					ACPI_STATE_D0 : ACPI_STATE_D3;
+					ACPI_STATE_D0 : ACPI_STATE_D3_HOT;
 
 		/*
 		 * acpi_bus_set_power() often fails (keyboard port can't be
diff --git a/include/acpi/actypes.h b/include/acpi/actypes.h
index eba6604..e3b7cac 100644
--- a/include/acpi/actypes.h
+++ b/include/acpi/actypes.h
@@ -499,7 +499,7 @@ typedef u64 acpi_integer;
 #define ACPI_STATE_D0                   (u8) 0
 #define ACPI_STATE_D1                   (u8) 1
 #define ACPI_STATE_D2                   (u8) 2
-#define ACPI_STATE_D3                   (u8) 3
+#define ACPI_STATE_D3_HOT               (u8) 3
 #define ACPI_STATE_D3_COLD              (u8) 4
 #define ACPI_D_STATES_MAX               ACPI_STATE_D3_COLD
 #define ACPI_D_STATE_COUNT              5
-- 
1.7.2.5

