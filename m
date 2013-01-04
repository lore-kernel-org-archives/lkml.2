Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755376Ab3ADWA2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2013 17:00:28 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:60472 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755286Ab3ADV6z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2013 16:58:55 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Len Brown <lenb@kernel.org>,
        Lv Zheng <lv.zheng@intel.com>, Huang Ying <ying.huang@intel.com>
Subject: [PATCH 1/6] ACPI / PM: Change the way power transitions to D3cold are carried out
Date: Fri, 04 Jan 2013 23:00:26 +0100
Message-ID: <3421785.2lTFog1i8W@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0-rc2+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <2311196.icSMDvAsYg@vostro.rjw.lan>
References: <2311196.icSMDvAsYg@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

During power transitions into D3cold from any shallower power states
we are supposed to transition the device into D3hot and remove power
from it afterward, but the current code in acpi_device_set_power()
doesn't work this way.

At the same time, though, we need to be careful enough to preserve
backwards compatibility for systems that don't distinguish between
D3hot and D3cold (e.g. designed before ACPI 4).

Modify acpi_device_set_power() so that it works in accordance with
the expectations in both cases.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/acpi/bus.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

Index: linux/drivers/acpi/bus.c
===================================================================
--- linux.orig/drivers/acpi/bus.c
+++ linux/drivers/acpi/bus.c
@@ -270,6 +270,7 @@ int acpi_device_set_power(struct acpi_de
 	int result = 0;
 	acpi_status status = AE_OK;
 	char object_name[5] = { '_', 'P', 'S', '0' + state, '\0' };
+	bool cut_power = false;
 
 	if (!device || (state < ACPI_STATE_D0) || (state > ACPI_STATE_D3_COLD))
 		return -EINVAL;
@@ -294,9 +295,13 @@ int acpi_device_set_power(struct acpi_de
 		return -ENODEV;
 	}
 
-	/* For D3cold we should execute _PS3, not _PS4. */
-	if (state == ACPI_STATE_D3_COLD)
+	/* For D3cold we should first transition into D3hot. */
+	if (state == ACPI_STATE_D3_COLD
+	    && device->power.states[ACPI_STATE_D3_COLD].flags.os_accessible) {
+		state = ACPI_STATE_D3_HOT;
 		object_name[3] = '3';
+		cut_power = true;
+	}
 
 	/*
 	 * Transition Power
@@ -341,6 +346,9 @@ int acpi_device_set_power(struct acpi_de
 		}
 	}
 
+	if (cut_power)
+		result = acpi_power_transition(device, ACPI_STATE_D3_COLD);
+
       end:
 	if (result)
 		printk(KERN_WARNING PREFIX

