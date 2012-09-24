Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756267Ab2IXPGY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 11:06:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12929 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756231Ab2IXPGP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 11:06:15 -0400
From: Matthew Garrett <mjg@redhat.com>
To: yakui.zhao@intel.com
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        cminyard@mvista.com, Matthew Garrett <mjg@redhat.com>
Subject: [PATCH 4/4] ACPI: Add a default handler for IPMI operation regions
Date: Mon, 24 Sep 2012 11:05:40 -0400
Message-Id: <1348499140-13550-5-git-send-email-mjg@redhat.com>
In-Reply-To: <1348499140-13550-1-git-send-email-mjg@redhat.com>
References: <1348499140-13550-1-git-send-email-mjg@redhat.com>
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 66.187.233.206
X-SA-Exim-Mail-From: mjg@redhat.com
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ACPI spec makes it clear that IPMI operation regions should be declared
inside the scope of an IPMI device. Based on the existence of systems for
which this is untrue, it seems likely that alternative implementations exist
that perform some kind of fallback for regions outside the scope of an IPMI
device. Add a callback to the ACPI IPMI driver to glue these operation
regions onto an IPMI device. Behaviour in the case of multiple controllers
may be unpredictable, but there's clearly no way to know the correct answer
in that case.

Signed-off-by: Matthew Garrett <mjg@redhat.com>
---
 drivers/acpi/acpi_ipmi.c | 50 ++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 50 insertions(+)

diff --git a/drivers/acpi/acpi_ipmi.c b/drivers/acpi/acpi_ipmi.c
index f40acef..15dc0e8 100644
--- a/drivers/acpi/acpi_ipmi.c
+++ b/drivers/acpi/acpi_ipmi.c
@@ -72,6 +72,7 @@ struct ipmi_driver_data {
 	struct ipmi_smi_watcher	bmc_events;
 	struct ipmi_user_hndl	ipmi_hndlrs;
 	struct mutex		ipmi_lock;
+	struct acpi_ipmi_device *global_device;
 };
 
 struct acpi_ipmi_msg {
@@ -106,9 +107,14 @@ struct acpi_ipmi_buffer {
 
 static void ipmi_register_bmc(int iface, struct device *dev);
 static void ipmi_bmc_gone(int iface);
+static void ipmi_probe_complete(void);
 static void ipmi_msg_handler(struct ipmi_recv_msg *msg, void *user_msg_data);
 static void acpi_add_ipmi_device(struct acpi_ipmi_device *ipmi_device);
 static void acpi_remove_ipmi_device(struct acpi_ipmi_device *ipmi_device);
+static acpi_status
+acpi_ipmi_space_handler(u32 function, acpi_physical_address address,
+			u32 bits, acpi_integer *value,
+			void *handler_context, void *region_context);
 
 static struct ipmi_driver_data driver_data = {
 	.ipmi_devices = LIST_HEAD_INIT(driver_data.ipmi_devices),
@@ -116,6 +122,7 @@ static struct ipmi_driver_data driver_data = {
 		.owner = THIS_MODULE,
 		.new_smi = ipmi_register_bmc,
 		.smi_gone = ipmi_bmc_gone,
+		.smi_probe_complete = ipmi_probe_complete,
 	},
 	.ipmi_hndlrs = {
 		.ipmi_recv_hndl = ipmi_msg_handler,
@@ -276,6 +283,32 @@ static void ipmi_msg_handler(struct ipmi_recv_msg *msg, void *user_msg_data)
 	ipmi_free_recv_msg(msg);
 };
 
+/* Must be called with driver_data.ipmi_lock held */
+static void ipmi_update_global_handler(void)
+{
+	struct acpi_ipmi_device *ipmi_device;
+	acpi_status status;
+
+	if (driver_data.global_device)
+		return;
+
+	list_for_each_entry(ipmi_device, &driver_data.ipmi_devices, head) {
+		/*
+		 * Register a handler for IPMI regions that aren't under a
+		 * specific IPMI namespace. This appears to be a spec violation
+		 * but we should do what we can.
+		 */
+		status = acpi_install_address_space_handler(ACPI_ROOT_OBJECT,
+						      ACPI_ADR_SPACE_IPMI,
+						      &acpi_ipmi_space_handler,
+						      NULL, ipmi_device);
+		if (ACPI_SUCCESS(status)) {
+			driver_data.global_device = ipmi_device;
+			break;
+		}
+	}
+}
+
 static void ipmi_register_bmc(int iface, struct device *dev)
 {
 	struct acpi_ipmi_device *ipmi_device, *temp;
@@ -347,12 +380,29 @@ static void ipmi_bmc_gone(int iface)
 			continue;
 
 		acpi_remove_ipmi_device(ipmi_device);
+
+		if (driver_data.global_device == ipmi_device) {
+			acpi_remove_address_space_handler(ACPI_ROOT_OBJECT,
+				ACPI_ADR_SPACE_IPMI, &acpi_ipmi_space_handler);
+			driver_data.global_device = NULL;
+			ipmi_update_global_handler();
+		}
+
 		put_device(ipmi_device->smi_data.dev);
 		kfree(ipmi_device);
 		break;
 	}
+
 	mutex_unlock(&driver_data.ipmi_lock);
 }
+
+static void ipmi_probe_complete(void)
+{
+	mutex_lock(&driver_data.ipmi_lock);
+	ipmi_update_global_handler();
+	mutex_unlock(&driver_data.ipmi_lock);
+}
+
 /* --------------------------------------------------------------------------
  *			Address Space Management
  * -------------------------------------------------------------------------- */
-- 
1.7.11.4

