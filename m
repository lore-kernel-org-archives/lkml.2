Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756088Ab2CFQUp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 11:20:45 -0500
Received: from terminus.zytor.com ([198.137.202.10]:39107 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755276Ab2CFQUj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 11:20:39 -0500
Date: Tue, 6 Mar 2012 08:19:30 -0800
From: tip-bot for Daniel Drake <dsd@laptop.org>
Message-ID: <tip-bgt8hxu2wwe0x5p8edhogtf7@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, mjg@redhat.com, hpa@zytor.com,
        mingo@redhat.com, dsd@laptop.org, akpm@linux-foundation.org,
        dilinger@queued.net, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, mjg@redhat.com,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        dsd@laptop.org, dilinger@queued.net, tglx@linutronix.de, mingo@elte.hu
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/platform] x86/olpc/xo15/sci:
  Enable lid close wakeup control
Git-Commit-ID: d1f42e314c9c50541c79a6edf2b4cab63fe02ee3
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 06 Mar 2012 08:20:00 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d1f42e314c9c50541c79a6edf2b4cab63fe02ee3
Gitweb:     http://git.kernel.org/tip/d1f42e314c9c50541c79a6edf2b4cab63fe02ee3
Author:     Daniel Drake <dsd@laptop.org>
AuthorDate: Mon, 5 Mar 2012 15:01:00 -0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 6 Mar 2012 09:57:11 +0100

x86/olpc/xo15/sci: Enable lid close wakeup control

Like most systems, OLPC's ACPI LID switch wakes up the system
when the lid is opened, but not when it is closed.

Under OLPC's opportunistic suspend model, the lid may be closed
while the system was oportunistically suspended with the screen
running.  In this event, we want to wake up to turn the screen
off.

Enable control of normal ACPI wakeups through lid close events
through a new sysfs attribute "lid_wake_on_closed".  When set,
and when LID wakeups are enabled through ACPI, the system will
wake up on both open and close lid events.

Signed-off-by: Daniel Drake <dsd@laptop.org>
Cc: Andres Salomon <dilinger@queued.net>
Cc: Matthew Garrett <mjg@redhat.com>
[ Fixed sscanf checking]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Link: http://lkml.kernel.org/n/tip-bgt8hxu2wwe0x5p8edhogtf7@git.kernel.org
[ Did very minor readability tweaks ]
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/platform/olpc/olpc-xo15-sci.c |   72 +++++++++++++++++++++++++++++++-
 1 files changed, 71 insertions(+), 1 deletions(-)

diff --git a/arch/x86/platform/olpc/olpc-xo15-sci.c b/arch/x86/platform/olpc/olpc-xo15-sci.c
index 2b235b7..23e5b9d 100644
--- a/arch/x86/platform/olpc/olpc-xo15-sci.c
+++ b/arch/x86/platform/olpc/olpc-xo15-sci.c
@@ -23,7 +23,66 @@
 #define XO15_SCI_CLASS			DRV_NAME
 #define XO15_SCI_DEVICE_NAME		"OLPC XO-1.5 SCI"
 
-static unsigned long xo15_sci_gpe;
+static unsigned long			xo15_sci_gpe;
+static bool				lid_wake_on_close;
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
+	arg_list.count		= 1;
+	arg_list.pointer	= &arg;
+	arg.type		= ACPI_TYPE_INTEGER;
+	arg.integer.value	= wake_on_close;
+
+	status = acpi_evaluate_object(NULL, "\\_SB.PCI0.LID.LIDW", &arg_list, NULL);
+	if (ACPI_FAILURE(status)) {
+		pr_warning(PFX "failed to set lid behavior\n");
+		return 1;
+	}
+
+	lid_wake_on_close = wake_on_close;
+
+	return 0;
+}
+
+static ssize_t
+lid_wake_on_close_show(struct kobject *s, struct kobj_attribute *attr, char *buf)
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
+
+	return n;
+}
+
+static struct kobj_attribute lid_wake_on_close_attr =
+	__ATTR(lid_wake_on_close, 0644,
+	       lid_wake_on_close_show,
+	       lid_wake_on_close_store);
 
 static void battery_status_changed(void)
 {
@@ -91,6 +150,7 @@ static int xo15_sci_add(struct acpi_device *device)
 {
 	unsigned long long tmp;
 	acpi_status status;
+	int r;
 
 	if (!device)
 		return -EINVAL;
@@ -112,6 +172,10 @@ static int xo15_sci_add(struct acpi_device *device)
 
 	dev_info(&device->dev, "Initialized, GPE = 0x%lx\n", xo15_sci_gpe);
 
+	r = sysfs_create_file(&device->dev.kobj, &lid_wake_on_close_attr.attr);
+	if (r)
+		goto err_sysfs;
+
 	/* Flush queue, and enable all SCI events */
 	process_sci_queue();
 	olpc_ec_mask_write(EC_SCI_SRC_ALL);
@@ -123,6 +187,11 @@ static int xo15_sci_add(struct acpi_device *device)
 		device_init_wakeup(&device->dev, true);
 
 	return 0;
+
+err_sysfs:
+	acpi_remove_gpe_handler(NULL, xo15_sci_gpe, xo15_sci_gpe_handler);
+	cancel_work_sync(&sci_work);
+	return r;
 }
 
 static int xo15_sci_remove(struct acpi_device *device, int type)
@@ -130,6 +199,7 @@ static int xo15_sci_remove(struct acpi_device *device, int type)
 	acpi_disable_gpe(NULL, xo15_sci_gpe);
 	acpi_remove_gpe_handler(NULL, xo15_sci_gpe, xo15_sci_gpe_handler);
 	cancel_work_sync(&sci_work);
+	sysfs_remove_file(&device->dev.kobj, &lid_wake_on_close_attr.attr);
 	return 0;
 }
 
