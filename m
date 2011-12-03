Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753415Ab1LCROM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Dec 2011 12:14:12 -0500
Received: from mtaout03-winn.ispmail.ntl.com ([81.103.221.49]:24815 "EHLO
	mtaout03-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753197Ab1LCROJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Dec 2011 12:14:09 -0500
From: Daniel Drake <dsd@laptop.org>
To: akpm@linux-foundation.org
To: mingo@redhat.com
To: tglx@linutronix.de
To: hpa@zytor.com
To: x86@kernel.org
Cc: dilinger@queued.net
Cc: linux-kernel@vger.kernel.org
Cc: mjg@redhat.com
Cc: linux-acpi@vger.kernel.org
Subject: [PATCH v2] x86, olpc-xo15-sci: enable lid close wakeup control through sysfs
Message-Id: <20111203171402.1D0F69D401E@zog.reactivated.net>
Date: Sat,  3 Dec 2011 17:14:01 +0000 (GMT)
X-Cloudmark-Analysis: v=1.1 cv=JvdXmxIgLJv2/GthKqHpGJEEHukvLcvELVXUanXFreg= c=1 sm=0 a=5Kjt_YVBILYA:10 a=vJ1w_8FsMGIA:10 a=Op-mwl0xAAAA:8 a=XmCPp68nuIsWK2zfXUgA:9 a=gy4WKV_SFzLYomyrzBMA:7 a=d4CUUju0HPYA:10 a=HpAAvcLHHh0Zw7uRqdWCyQ==:117
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Like most systems, OLPC's ACPI LID switch wakes up the system when the lid
is opened, but not when it is closed.

Under OLPC's opportunistic suspend model, the lid may be closed while the
system was oportunistically suspended with the screen running.  In this
event, we want to wake up to turn the screen off.

Enable control of normal ACPI wakeups through lid close events through a
new sysfs attribute "lid_wake_on_closed".  When set, and when LID wakeups
are enabled through ACPI, the system will wake up on both open and close
lid events.

Signed-off-by: Daniel Drake <dsd@laptop.org>
---
 arch/x86/platform/olpc/olpc-xo15-sci.c |   67 ++++++++++++++++++++++++++++++++
 1 files changed, 67 insertions(+), 0 deletions(-)

v2: Fix sscanf usage error and add an explanatory comment in the code, both pointed out by Andrew Morton. Thanks!

diff --git a/arch/x86/platform/olpc/olpc-xo15-sci.c b/arch/x86/platform/olpc/olpc-xo15-sci.c
index 2b235b7..8aef370 100644
--- a/arch/x86/platform/olpc/olpc-xo15-sci.c
+++ b/arch/x86/platform/olpc/olpc-xo15-sci.c
@@ -24,6 +24,62 @@
 #define XO15_SCI_DEVICE_NAME		"OLPC XO-1.5 SCI"
 
 static unsigned long xo15_sci_gpe;
+static bool lid_wake_on_close;
+
+/*
+ * The normal ACPI LID wakeup behavior is wake-on-open, but not
+ * wake-on-close. This is implemented as standard by the XO-1.5 DSDT.
+ *
+ * We provide here a sysfs attribute that will additionally enable
+ * wake-on-close behavior. This is useful (e.g.) when we oportunistically
+ * suspend with the display running; if the lid is then closed, we want to
+ * wake up to turn the display off.
+ *
+ * This is controlled through a custom method in the XO-1.5 DSDT.
+ */
+static int set_lid_wake_behavior(bool wake_on_close)
+{
+	struct acpi_object_list arg_list;
+	union acpi_object arg;
+	acpi_status status;
+
+	arg_list.count = 1;
+	arg_list.pointer = &arg;
+	arg.type = ACPI_TYPE_INTEGER;
+	arg.integer.value = wake_on_close;
+	status = acpi_evaluate_object(NULL, "\\_SB.PCI0.LID.LIDW", &arg_list,
+				      NULL);
+	if (ACPI_FAILURE(status)) {
+		pr_warning(PFX "failed to set lid behavior\n");
+		return 1;
+	}
+
+	lid_wake_on_close = wake_on_close;
+	return 0;
+}
+
+static ssize_t lid_wake_on_close_show(struct kobject *s,
+				      struct kobj_attribute *attr, char *buf)
+{
+	return sprintf(buf, "%u\n", lid_wake_on_close);
+}
+
+static ssize_t lid_wake_on_close_store(struct kobject *s,
+				       struct kobj_attribute *attr,
+				       const char *buf, size_t n)
+{
+	unsigned int val;
+
+	if (sscanf(buf, "%u", &val) != 1)
+		return -EINVAL;
+
+	set_lid_wake_behavior(!!val);
+	return n;
+}
+
+static struct kobj_attribute lid_wake_on_close_attr =
+	__ATTR(lid_wake_on_close, 0644,
+	       lid_wake_on_close_show, lid_wake_on_close_store);
 
 static void battery_status_changed(void)
 {
@@ -91,6 +147,7 @@ static int xo15_sci_add(struct acpi_device *device)
 {
 	unsigned long long tmp;
 	acpi_status status;
+	int r;
 
 	if (!device)
 		return -EINVAL;
@@ -112,6 +169,10 @@ static int xo15_sci_add(struct acpi_device *device)
 
 	dev_info(&device->dev, "Initialized, GPE = 0x%lx\n", xo15_sci_gpe);
 
+	r = sysfs_create_file(&device->dev.kobj, &lid_wake_on_close_attr.attr);
+	if (r)
+		goto err_sysfs;
+
 	/* Flush queue, and enable all SCI events */
 	process_sci_queue();
 	olpc_ec_mask_write(EC_SCI_SRC_ALL);
@@ -123,6 +184,11 @@ static int xo15_sci_add(struct acpi_device *device)
 		device_init_wakeup(&device->dev, true);
 
 	return 0;
+
+err_sysfs:
+	acpi_remove_gpe_handler(NULL, xo15_sci_gpe, xo15_sci_gpe_handler);
+	cancel_work_sync(&sci_work);
+	return r;
 }
 
 static int xo15_sci_remove(struct acpi_device *device, int type)
@@ -130,6 +196,7 @@ static int xo15_sci_remove(struct acpi_device *device, int type)
 	acpi_disable_gpe(NULL, xo15_sci_gpe);
 	acpi_remove_gpe_handler(NULL, xo15_sci_gpe, xo15_sci_gpe_handler);
 	cancel_work_sync(&sci_work);
+	sysfs_remove_file(&device->dev.kobj, &lid_wake_on_close_attr.attr);
 	return 0;
 }
 
-- 
1.7.7.3

