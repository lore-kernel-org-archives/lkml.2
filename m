Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757775Ab0DVT47 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 15:56:59 -0400
Received: from kroah.org ([198.145.64.141]:40792 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756281Ab0DVT2a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 15:28:30 -0400
X-Mailbox-Line: From gregkh@kvm.kroah.org Thu Apr 22 12:09:14 2010
Message-Id: <20100422190914.191157538@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Thu, 22 Apr 2010 12:08:47 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Alan Jenkins <alan-jenkins@tuffmail.co.uk>,
       Corentin Chary <corentincj@iksaif.net>, Len Brown <len.brown@intel.com>,
       Ben Hutchings <ben@decadent.org.uk>
Subject: [076/197] eeepc-laptop: disable cpu speed control on EeePC 701
In-Reply-To: <20100422191857.GA13268@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

commit da8ba01deb98f3dc0558b1f5a37e64f40bba7904 upstream.

The EeePC 4G ("701") implements CFVS, but it is not supported by the
pre-installed OS, and the original option to change it in the BIOS
setup screen was removed in later versions.  Judging by the lack of
"Super Hybrid Engine" on Asus product pages, this applies to all "701"
models (4G/4G Surf/2G Surf).

So Asus made a deliberate decision not to support it on this model.
We have several reports that using it can cause the system to hang [1].
That said, it does not happen all the time.  Some users do not
experience it at all (and apparently wish to continue "right-clocking").

Check for the EeePC 701 using DMI.  If met, then disable writes to the
"cpufv" sysfs attribute and log an explanatory message.

Add a "cpufv_disabled" attribute which allow users to override this
policy.  Writing to this attribute will log a second message.

The sysfs attribute is more useful than a module option, because it
makes it easier for userspace scripts to provide consistent behaviour
(according to user configuration), regardless of whether the kernel
includes this change.

[1] <http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=559578>

[bwh: Backported to 2.6.32]

Signed-off-by: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Signed-off-by: Corentin Chary <corentincj@iksaif.net>
Signed-off-by: Len Brown <len.brown@intel.com>
Cc: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/platform/x86/eeepc-laptop.c |   84 ++++++++++++++++++++++++++++++++++++
 1 file changed, 84 insertions(+)

--- a/drivers/platform/x86/eeepc-laptop.c
+++ b/drivers/platform/x86/eeepc-laptop.c
@@ -34,6 +34,7 @@
 #include <linux/rfkill.h>
 #include <linux/pci.h>
 #include <linux/pci_hotplug.h>
+#include <linux/dmi.h>
 
 #define EEEPC_LAPTOP_VERSION	"0.1"
 
@@ -135,6 +136,7 @@ struct eeepc_hotk {
 	acpi_handle handle;		/* the handle of the hotk device */
 	u32 cm_supported;		/* the control methods supported
 					   by this BIOS */
+	bool cpufv_disabled;
 	uint init_flag;			/* Init flags */
 	u16 event_count[128];		/* count for each event */
 	struct input_dev *inputdev;
@@ -467,6 +469,8 @@ static ssize_t store_cpufv(struct device
 	struct eeepc_cpufv c;
 	int rv, value;
 
+	if (ehotk->cpufv_disabled)
+		return -EPERM;
 	if (get_cpufv(&c))
 		return -ENODEV;
 	rv = parse_arg(buf, count, &value);
@@ -478,6 +482,38 @@ static ssize_t store_cpufv(struct device
 	return rv;
 }
 
+static ssize_t show_cpufv_disabled(struct device *dev,
+			  struct device_attribute *attr,
+			  char *buf)
+{
+	return sprintf(buf, "%d\n", ehotk->cpufv_disabled);
+}
+
+static ssize_t store_cpufv_disabled(struct device *dev,
+			   struct device_attribute *attr,
+			   const char *buf, size_t count)
+{
+	int rv, value;
+
+	rv = parse_arg(buf, count, &value);
+	if (rv < 0)
+		return rv;
+
+	switch (value) {
+	case 0:
+		if (ehotk->cpufv_disabled)
+			pr_warning("cpufv enabled (not officially supported "
+				"on this model)\n");
+		ehotk->cpufv_disabled = false;
+		return rv;
+	case 1:
+		return -EPERM;
+	default:
+		return -EINVAL;
+	}
+}
+
+
 static struct device_attribute dev_attr_cpufv = {
 	.attr = {
 		.name = "cpufv",
@@ -493,12 +529,22 @@ static struct device_attribute dev_attr_
 	.show   = show_available_cpufv
 };
 
+static struct device_attribute dev_attr_cpufv_disabled = {
+	.attr = {
+		.name = "cpufv_disabled",
+		.mode = 0644 },
+	.show   = show_cpufv_disabled,
+	.store  = store_cpufv_disabled
+};
+
+
 static struct attribute *platform_attributes[] = {
 	&dev_attr_camera.attr,
 	&dev_attr_cardr.attr,
 	&dev_attr_disp.attr,
 	&dev_attr_cpufv.attr,
 	&dev_attr_available_cpufv.attr,
+	&dev_attr_cpufv_disabled.attr,
 	NULL
 };
 
@@ -564,6 +610,42 @@ static int eeepc_setkeycode(struct input
 	return -EINVAL;
 }
 
+static void eeepc_dmi_check(void)
+{
+	const char *model;
+
+	/*
+	 * Blacklist for setting cpufv (cpu speed).
+	 *
+	 * EeePC 4G ("701") implements CFVS, but it is not supported
+	 * by the pre-installed OS, and the original option to change it
+	 * in the BIOS setup screen was removed in later versions.
+	 *
+	 * Judging by the lack of "Super Hybrid Engine" on Asus product pages,
+	 * this applies to all "701" models (4G/4G Surf/2G Surf).
+	 *
+	 * So Asus made a deliberate decision not to support it on this model.
+	 * We have several reports that using it can cause the system to hang
+	 *
+	 * The hang has also been reported on a "702" (Model name "8G"?).
+	 *
+	 * We avoid dmi_check_system() / dmi_match(), because they use
+	 * substring matching.  We don't want to affect the "701SD"
+	 * and "701SDX" models, because they do support S.H.E.
+	 */
+
+	model = dmi_get_system_info(DMI_PRODUCT_NAME);
+	if (!model)
+		return;
+
+	if (strcmp(model, "701") == 0 || strcmp(model, "702") == 0) {
+		ehotk->cpufv_disabled = true;
+		pr_info("model %s does not officially support setting cpu "
+			"speed\n", model);
+		pr_info("cpufv disabled to avoid instability\n");
+	}
+}
+
 static void cmsg_quirk(int cm, const char *name)
 {
 	int dummy;
@@ -1208,6 +1290,8 @@ static int __devinit eeepc_hotk_add(stru
 	device->driver_data = ehotk;
 	ehotk->device = device;
 
+	eeepc_dmi_check();
+
 	result = eeepc_hotk_check();
 	if (result)
 		goto fail_platform_driver;


