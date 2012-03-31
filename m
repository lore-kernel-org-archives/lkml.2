Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757171Ab2CaKT1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2012 06:19:27 -0400
Received: from ch1ehsobe004.messaging.microsoft.com ([216.32.181.184]:55658
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755935Ab2CaKTW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2012 06:19:22 -0400
X-SpamScore: -5
X-BigFish: VPS-5(zz1803Mzz1202hzz8275bhz2dh668h839hd24h)
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0M1QVC4-01-295-02
X-M-MSG: 
From: Aaron Lu <aaron.lu@amd.com>
To: Len Brown <lenb@kernel.org>, "Rafeal J. Wysocki" <rjw@sisk.pl>,
        Lin Ming <ming.m.lin@intel.com>
CC: <linux-acpi@vger.kernel.org>, <linux-pm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Zhang Rui <rui.zhang@intel.com>,
        Aaron Lu <aaron.lu@amd.com>, Andiry Xu <andiry.xu@amd.com>,
        Alex He <alex.he@amd.com>
Subject: [PATCH] ACPI: evaluate _PS3 when entering D3 Cold
Date: Sun, 1 Apr 2012 02:18:30 +0800
Message-ID: <1333217910-29579-1-git-send-email-aaron.lu@amd.com>
X-Mailer: git-send-email 1.7.9.2.315.g25a78.dirty
X-OriginalArrivalTime: 31 Mar 2012 10:19:10.0695 (UTC) FILETIME=[B6B32F70:01CD0F27]
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When entering D3 Cold from a higher device state, evaluate _PS3 first
and then make the proper power transition.
This is used to solve the ZPODD problem on AMD's platform, _PS3 on such
platforms will power off the ODD device and thus make the device enter
D3 cold state.

Signed-off-by: Aaron Lu <aaron.lu@amd.com>
Cc: Andiry Xu <andiry.xu@amd.com>
Cc: Alex He <alex.he@amd.com>
---
 drivers/acpi/bus.c |   17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/drivers/acpi/bus.c b/drivers/acpi/bus.c
index 3263b68..68e593f 100644
--- a/drivers/acpi/bus.c
+++ b/drivers/acpi/bus.c
@@ -227,6 +227,8 @@ static int __acpi_bus_set_power(struct acpi_device *device, int state)
 	int result = 0;
 	acpi_status status = AE_OK;
 	char object_name[5] = { '_', 'P', 'S', '0' + state, '\0' };
+	struct acpi_device_power_state *ps;
+	u8 explicit_set;
 
 	if (!device || (state < ACPI_STATE_D0) || (state > ACPI_STATE_D3_COLD))
 		return -EINVAL;
@@ -239,7 +241,8 @@ static int __acpi_bus_set_power(struct acpi_device *device, int state)
 		return 0;
 	}
 
-	if (!device->power.states[state].flags.valid) {
+	ps = &device->power.states[state];
+	if (!ps->flags.valid) {
 		printk(KERN_WARNING PREFIX "Device does not support D%d\n", state);
 		return -ENODEV;
 	}
@@ -263,7 +266,7 @@ static int __acpi_bus_set_power(struct acpi_device *device, int state)
 			if (result)
 				goto end;
 		}
-		if (device->power.states[state].flags.explicit_set) {
+		if (ps->flags.explicit_set) {
 			status = acpi_evaluate_object(device->handle,
 						      object_name, NULL, NULL);
 			if (ACPI_FAILURE(status)) {
@@ -272,7 +275,15 @@ static int __acpi_bus_set_power(struct acpi_device *device, int state)
 			}
 		}
 	} else {
-		if (device->power.states[state].flags.explicit_set) {
+		/* If state is D3 Cold, try to evaluate _PS3 first */
+		if (state == ACPI_STATE_D3_COLD) {
+			explicit_set = (ps - 1)->flags.explicit_set;
+			object_name[3] -= 1;
+		}
+		else {
+			explicit_set = ps->flags.explicit_set;
+		}
+		if (explicit_set) {
 			status = acpi_evaluate_object(device->handle,
 						      object_name, NULL, NULL);
 			if (ACPI_FAILURE(status)) {
-- 
1.7.9.2.315.g25a78.dirty


