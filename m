Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756642Ab1LWKas (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Dec 2011 05:30:48 -0500
Received: from mga11.intel.com ([192.55.52.93]:2107 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756610Ab1LWKag (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Dec 2011 05:30:36 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208,223";a="99639487"
From: "Liu, Jinsong" <jinsong.liu@intel.com>
To: "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>
CC: "Jiang, Yunhong" <yunhong.jiang@intel.com>,
        "jeremy.fitzhardinge@citrix.com" <jeremy.fitzhardinge@citrix.com>,
        "Shan, Haitao" <haitao.shan@intel.com>,
        "Zhao, Yakui" <yakui.zhao@intel.com>,
        "Brown, Len" <len.brown@intel.com>, "Luck, Tony" <tony.luck@intel.com>,
        "Kleen, Andi" <andi.kleen@intel.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: [PATCH 08/10] xen/acpi: add cpu hotadd support
Thread-Topic: [PATCH 08/10] xen/acpi: add cpu hotadd support
Thread-Index: AczBXdnxG/uZZT4gQla9H//97c2bRw==
Date: Fri, 23 Dec 2011 10:30:12 +0000
Message-ID: <DE8DF0795D48FD4CA783C40EC82923359720@SHSMSX101.ccr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: multipart/mixed;
	boundary="_002_DE8DF0795D48FD4CA783C40EC82923359720SHSMSX101ccrcorpint_"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--_002_DE8DF0795D48FD4CA783C40EC82923359720SHSMSX101ccrcorpint_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

>From 282958be3a33b2f2b888e1ed3ac022bf8a199ec9 Mon Sep 17 00:00:00 2001
From: Liu Jinsong <jinsong.liu@intel.com>
Date: Wed, 14 Dec 2011 11:38:11 +0800
Subject: [PATCH 08/10] xen/acpi: add cpu hotadd support

This patch add cpu hotadd support.
It keep similar cpu hotadd logic as native, w/ some changes according
to xen requirement, hypercalling hypervisor related logic to hotadd cpu.

Signed-off-by: Liu, Jinsong <jinsong.liu@intel.com>
Signed-off-by: Jiang, Yunhong <yunhong.jiang@intel.com>
---
 drivers/acpi/processor_driver.c |    4 +-
 drivers/acpi/processor_xen.c    |  242 +++++++++++++++++++++++++++++++++++=
+++-
 include/acpi/processor.h        |    2 +
 include/xen/pcpu.h              |    2 +
 4 files changed, 246 insertions(+), 4 deletions(-)

diff --git a/drivers/acpi/processor_driver.c b/drivers/acpi/processor_drive=
r.c
index 8a367d7..d473fd5 100644
--- a/drivers/acpi/processor_driver.c
+++ b/drivers/acpi/processor_driver.c
@@ -221,7 +221,7 @@ static int acpi_processor_errata_piix4(struct pci_dev *=
dev)
 	return 0;
 }
=20
-static int acpi_processor_errata(struct acpi_processor *pr)
+int acpi_processor_errata(struct acpi_processor *pr)
 {
 	int result =3D 0;
 	struct pci_dev *dev =3D NULL;
@@ -378,7 +378,7 @@ static int acpi_processor_get_info(struct acpi_device *=
device)
 	return 0;
 }
=20
-static DEFINE_PER_CPU(void *, processor_device_array);
+DEFINE_PER_CPU(void *, processor_device_array);
=20
 void acpi_processor_notify(struct acpi_device *device, u32 event)
 {
diff --git a/drivers/acpi/processor_xen.c b/drivers/acpi/processor_xen.c
index 38a1c05..3af1f73 100644
--- a/drivers/acpi/processor_xen.c
+++ b/drivers/acpi/processor_xen.c
@@ -24,6 +24,7 @@
 #define PREFIX "ACPI: "
=20
 #define ACPI_PROCESSOR_CLASS            "processor"
+#define ACPI_PROCESSOR_DEVICE_NAME      "Processor"
 #define ACPI_PROCESSOR_NOTIFY_PERFORMANCE 0x80
 #define ACPI_PROCESSOR_NOTIFY_POWER	0x81
 #define ACPI_PROCESSOR_NOTIFY_THROTTLING	0x82
@@ -88,6 +89,8 @@ xen_acpi_processor_hotadd_init(struct acpi_processor *pr,=
 int *p_cpu)
 				PROCESSOR_HOTPLUG, HOTPLUG_TYPE_ADD))
 		return AE_ERROR;
=20
+	*p_cpu =3D xen_pcpu_index(pr->acpi_id, 1);
+
 	return AE_OK;
 }
=20
@@ -149,13 +152,248 @@ err_out:
 }
 #endif /* CONFIG_CPU_FREQ */
=20
+static int xen_acpi_processor_get_info(struct acpi_device *device)
+{
+	acpi_status status =3D 0;
+	union acpi_object object =3D { 0 };
+	struct acpi_buffer buffer =3D { sizeof(union acpi_object), &object };
+	struct acpi_processor *pr;
+	int cpu_index, device_declaration =3D 0;
+	static int cpu0_initialized;
+
+	pr =3D acpi_driver_data(device);
+	if (!pr)
+		return -EINVAL;
+
+	if (num_online_cpus() > 1)
+		errata.smp =3D TRUE;
+
+	acpi_processor_errata(pr);
+
+	/*
+	 * Check to see if we have bus mastering arbitration control.  This
+	 * is required for proper C3 usage (to maintain cache coherency).
+	 */
+	if (acpi_gbl_FADT.pm2_control_block && acpi_gbl_FADT.pm2_control_length) =
{
+		pr->flags.bm_control =3D 1;
+		ACPI_DEBUG_PRINT((ACPI_DB_INFO,
+				  "Bus mastering arbitration control present\n"));
+	} else
+		ACPI_DEBUG_PRINT((ACPI_DB_INFO,
+				  "No bus mastering arbitration control\n"));
+
+	if (!strcmp(acpi_device_hid(device), ACPI_PROCESSOR_OBJECT_HID)) {
+		/* Declared with "Processor" statement; match ProcessorID */
+		status =3D acpi_evaluate_object(pr->handle, NULL, NULL, &buffer);
+		if (ACPI_FAILURE(status)) {
+			printk(KERN_ERR PREFIX "Evaluating processor object\n");
+			return -ENODEV;
+		}
+
+		/*
+		 * TBD: Synch processor ID (via LAPIC/LSAPIC structures) on SMP.
+		 *      >>> 'acpi_get_processor_id(acpi_id, &id)' in
+		 *      arch/xxx/acpi.c
+		 */
+		pr->acpi_id =3D object.processor.proc_id;
+	} else {
+		/*
+		 * Declared with "Device" statement; match _UID.
+		 * Note that we don't handle string _UIDs yet.
+		 */
+		unsigned long long value;
+		status =3D acpi_evaluate_integer(pr->handle, METHOD_NAME__UID,
+						NULL, &value);
+		if (ACPI_FAILURE(status)) {
+			printk(KERN_ERR PREFIX
+			    "Evaluating processor _UID [%#x]\n", status);
+			return -ENODEV;
+		}
+		device_declaration =3D 1;
+		pr->acpi_id =3D value;
+	}
+
+	cpu_index =3D xen_pcpu_index(pr->acpi_id, 1);
+
+	/* Handle UP system running SMP kernel, with no LAPIC in MADT */
+	if (!cpu0_initialized && (cpu_index =3D=3D -1) &&
+	    (num_online_cpus() =3D=3D 1)) {
+		cpu_index =3D 0;
+	}
+
+	cpu0_initialized =3D 1;
+
+	pr->id =3D cpu_index;
+
+	/*
+	 *  Extra Processor objects may be enumerated on MP systems with
+	 *  less than the max # of CPUs. They should be ignored _iff
+	 *  they are physically not present.
+	 */
+	if (pr->id =3D=3D -1) {
+		if (ACPI_FAILURE
+		    (xen_acpi_processor_hotadd_init(pr, &pr->id))) {
+			return -ENODEV;
+		}
+	}
+	/*
+	 * On some boxes several processors use the same processor bus id.
+	 * But they are located in different scope. For example:
+	 * \_SB.SCK0.CPU0
+	 * \_SB.SCK1.CPU0
+	 * Rename the processor device bus id. And the new bus id will be
+	 * generated as the following format:
+	 * CPU+CPU ID.
+	 */
+	sprintf(acpi_device_bid(device), "CPU%X", pr->id);
+	ACPI_DEBUG_PRINT((ACPI_DB_INFO, "Processor [%d:%d]\n", pr->id,
+			  pr->acpi_id));
+
+	if (!object.processor.pblk_address)
+		ACPI_DEBUG_PRINT((ACPI_DB_INFO, "No PBLK (NULL address)\n"));
+	else if (object.processor.pblk_length !=3D 6)
+		printk(KERN_ERR PREFIX "Invalid PBLK length [%d]\n",
+			    object.processor.pblk_length);
+	else {
+		pr->throttling.address =3D object.processor.pblk_address;
+		pr->throttling.duty_offset =3D acpi_gbl_FADT.duty_offset;
+		pr->throttling.duty_width =3D acpi_gbl_FADT.duty_width;
+
+		pr->pblk =3D object.processor.pblk_address;
+
+		/*
+		 * We don't care about error returns - we just try to mark
+		 * these reserved so that nobody else is confused into thinking
+		 * that this region might be unused..
+		 *
+		 * (In particular, allocating the IO range for Cardbus)
+		 */
+		request_region(pr->throttling.address, 6, "ACPI CPU throttle");
+	}
+
+	/*
+	 * If ACPI describes a slot number for this CPU, we can use it
+	 * ensure we get the right value in the "physical id" field
+	 * of /proc/cpuinfo
+	 */
+	status =3D acpi_evaluate_object(pr->handle, "_SUN", NULL, &buffer);
+	if (ACPI_SUCCESS(status))
+		arch_fix_phys_package_id(pr->id, object.integer.value);
+
+	return 0;
+}
+
+static int __cpuinit __xen_acpi_processor_add(struct acpi_device *device)
+{
+	struct acpi_processor *pr =3D NULL;
+	int result =3D 0;
+	struct sys_device *sysdev;
+
+	pr =3D kzalloc(sizeof(struct acpi_processor), GFP_KERNEL);
+	if (!pr)
+		return -ENOMEM;
+
+	if (!zalloc_cpumask_var(&pr->throttling.shared_cpu_map, GFP_KERNEL)) {
+		kfree(pr);
+		return -ENOMEM;
+	}
+
+	pr->handle =3D device->handle;
+	strcpy(acpi_device_name(device), ACPI_PROCESSOR_DEVICE_NAME);
+	strcpy(acpi_device_class(device), ACPI_PROCESSOR_CLASS);
+	device->driver_data =3D pr;
+
+	result =3D xen_acpi_processor_get_info(device);
+	if (result) {
+		/* Processor is physically not present */
+		return 0;
+	}
+
+#ifdef CONFIG_SMP
+	if (pr->id >=3D setup_max_cpus && pr->id !=3D 0)
+		return 0;
+#endif
+
+	BUG_ON((pr->id >=3D nr_cpu_ids) || (pr->id < 0));
+
+	/*
+	 * Buggy BIOS check
+	 * ACPI id of processors can be reported wrongly by the BIOS.
+	 * Don't trust it blindly
+	 */
+	if (per_cpu(processor_device_array, pr->id) !=3D NULL &&
+	    per_cpu(processor_device_array, pr->id) !=3D device) {
+		printk(KERN_WARNING "BIOS reported wrong ACPI id "
+			"for the processor\n");
+		result =3D -ENODEV;
+		goto err_free_cpumask;
+	}
+	per_cpu(processor_device_array, pr->id) =3D device;
+
+	per_cpu(processors, pr->id) =3D pr;
+
+	sysdev =3D get_cpu_sysdev(pr->id);
+	if (sysfs_create_link(&device->dev.kobj, &sysdev->kobj, "sysdev")) {
+		result =3D -EFAULT;
+		goto err_free_cpumask;
+	}
+
+#ifdef CONFIG_CPU_FREQ
+	acpi_processor_ppc_has_changed(pr, 0);
+#endif
+	acpi_processor_get_throttling_info(pr);
+	acpi_processor_get_limit_info(pr);
+
+
+	if (cpuidle_get_driver() =3D=3D &acpi_idle_driver)
+		acpi_processor_power_init(pr, device);
+
+	pr->cdev =3D thermal_cooling_device_register("Processor", device,
+						&processor_cooling_ops);
+	if (IS_ERR(pr->cdev)) {
+		result =3D PTR_ERR(pr->cdev);
+		goto err_power_exit;
+	}
+
+	dev_dbg(&device->dev, "registered as cooling_device%d\n",
+		 pr->cdev->id);
+
+	result =3D sysfs_create_link(&device->dev.kobj,
+				   &pr->cdev->device.kobj,
+				   "thermal_cooling");
+	if (result) {
+		printk(KERN_ERR PREFIX "Create sysfs link\n");
+		goto err_thermal_unregister;
+	}
+	result =3D sysfs_create_link(&pr->cdev->device.kobj,
+				   &device->dev.kobj,
+				   "device");
+	if (result) {
+		printk(KERN_ERR PREFIX "Create sysfs link\n");
+		goto err_remove_sysfs;
+	}
+
+	return 0;
+
+err_remove_sysfs:
+	sysfs_remove_link(&device->dev.kobj, "thermal_cooling");
+err_thermal_unregister:
+	thermal_cooling_device_unregister(pr->cdev);
+err_power_exit:
+	acpi_processor_power_exit(pr, device);
+err_free_cpumask:
+	free_cpumask_var(pr->throttling.shared_cpu_map);
+
+	return result;
+}
+
 static int __cpuinit xen_acpi_processor_add(struct acpi_device *device)
 {
 	struct acpi_processor *pr =3D NULL;
 	int result =3D 0;
=20
-	result =3D acpi_processor_add(device);
-	if (result < 0)
+	result =3D __xen_acpi_processor_add(device);
+	if (result)
 		return result;
=20
 	pr =3D acpi_driver_data(device);
diff --git a/include/acpi/processor.h b/include/acpi/processor.h
index c48e2f9..3a1ee01 100644
--- a/include/acpi/processor.h
+++ b/include/acpi/processor.h
@@ -225,6 +225,8 @@ struct acpi_processor_errata {
 	} piix4;
 };
=20
+extern int acpi_processor_errata(struct acpi_processor *pr);
+
 extern int acpi_processor_preregister_performance(struct
 						  acpi_processor_performance
 						  __percpu *performance);
diff --git a/include/xen/pcpu.h b/include/xen/pcpu.h
index 7e8f9d1..3e99db9 100644
--- a/include/xen/pcpu.h
+++ b/include/xen/pcpu.h
@@ -4,6 +4,8 @@
 #include <xen/interface/platform.h>
 #include <linux/sysdev.h>
=20
+extern DEFINE_PER_CPU(void *, processor_device_array);
+
 extern int xen_pcpu_hotplug(int type, uint32_t apic_id);
 #define XEN_PCPU_ONLINE     0x01
 #define XEN_PCPU_OFFLINE    0x02
--=20
1.6.5.6

--_002_DE8DF0795D48FD4CA783C40EC82923359720SHSMSX101ccrcorpint_
Content-Type: application/octet-stream;
	name="0008-xen-acpi-add-cpu-hotadd-support.patch"
Content-Description: 0008-xen-acpi-add-cpu-hotadd-support.patch
Content-Disposition: attachment;
	filename="0008-xen-acpi-add-cpu-hotadd-support.patch"; size=10056;
	creation-date="Wed, 14 Dec 2011 15:20:15 GMT";
	modification-date="Wed, 14 Dec 2011 15:03:34 GMT"
Content-Transfer-Encoding: base64

RnJvbSAyODI5NThiZTNhMzNiMmYyYjg4OGUxZWQzYWMwMjJiZjhhMTk5ZWM5IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBMaXUgSmluc29uZyA8amluc29uZy5saXVAaW50ZWwuY29tPgpE
YXRlOiBXZWQsIDE0IERlYyAyMDExIDExOjM4OjExICswODAwClN1YmplY3Q6IFtQQVRDSCAwOC8x
MF0geGVuL2FjcGk6IGFkZCBjcHUgaG90YWRkIHN1cHBvcnQKClRoaXMgcGF0Y2ggYWRkIGNwdSBo
b3RhZGQgc3VwcG9ydC4KSXQga2VlcCBzaW1pbGFyIGNwdSBob3RhZGQgbG9naWMgYXMgbmF0aXZl
LCB3LyBzb21lIGNoYW5nZXMgYWNjb3JkaW5nCnRvIHhlbiByZXF1aXJlbWVudCwgaHlwZXJjYWxs
aW5nIGh5cGVydmlzb3IgcmVsYXRlZCBsb2dpYyB0byBob3RhZGQgY3B1LgoKU2lnbmVkLW9mZi1i
eTogTGl1LCBKaW5zb25nIDxqaW5zb25nLmxpdUBpbnRlbC5jb20+ClNpZ25lZC1vZmYtYnk6IEpp
YW5nLCBZdW5ob25nIDx5dW5ob25nLmppYW5nQGludGVsLmNvbT4KLS0tCiBkcml2ZXJzL2FjcGkv
cHJvY2Vzc29yX2RyaXZlci5jIHwgICAgNCArLQogZHJpdmVycy9hY3BpL3Byb2Nlc3Nvcl94ZW4u
YyAgICB8ICAyNDIgKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKystCiBpbmNs
dWRlL2FjcGkvcHJvY2Vzc29yLmggICAgICAgIHwgICAgMiArCiBpbmNsdWRlL3hlbi9wY3B1Lmgg
ICAgICAgICAgICAgIHwgICAgMiArCiA0IGZpbGVzIGNoYW5nZWQsIDI0NiBpbnNlcnRpb25zKCsp
LCA0IGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2RyaXZlcnMvYWNwaS9wcm9jZXNzb3JfZHJp
dmVyLmMgYi9kcml2ZXJzL2FjcGkvcHJvY2Vzc29yX2RyaXZlci5jCmluZGV4IDhhMzY3ZDcuLmQ0
NzNmZDUgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvYWNwaS9wcm9jZXNzb3JfZHJpdmVyLmMKKysrIGIv
ZHJpdmVycy9hY3BpL3Byb2Nlc3Nvcl9kcml2ZXIuYwpAQCAtMjIxLDcgKzIyMSw3IEBAIHN0YXRp
YyBpbnQgYWNwaV9wcm9jZXNzb3JfZXJyYXRhX3BpaXg0KHN0cnVjdCBwY2lfZGV2ICpkZXYpCiAJ
cmV0dXJuIDA7CiB9CiAKLXN0YXRpYyBpbnQgYWNwaV9wcm9jZXNzb3JfZXJyYXRhKHN0cnVjdCBh
Y3BpX3Byb2Nlc3NvciAqcHIpCitpbnQgYWNwaV9wcm9jZXNzb3JfZXJyYXRhKHN0cnVjdCBhY3Bp
X3Byb2Nlc3NvciAqcHIpCiB7CiAJaW50IHJlc3VsdCA9IDA7CiAJc3RydWN0IHBjaV9kZXYgKmRl
diA9IE5VTEw7CkBAIC0zNzgsNyArMzc4LDcgQEAgc3RhdGljIGludCBhY3BpX3Byb2Nlc3Nvcl9n
ZXRfaW5mbyhzdHJ1Y3QgYWNwaV9kZXZpY2UgKmRldmljZSkKIAlyZXR1cm4gMDsKIH0KIAotc3Rh
dGljIERFRklORV9QRVJfQ1BVKHZvaWQgKiwgcHJvY2Vzc29yX2RldmljZV9hcnJheSk7CitERUZJ
TkVfUEVSX0NQVSh2b2lkICosIHByb2Nlc3Nvcl9kZXZpY2VfYXJyYXkpOwogCiB2b2lkIGFjcGlf
cHJvY2Vzc29yX25vdGlmeShzdHJ1Y3QgYWNwaV9kZXZpY2UgKmRldmljZSwgdTMyIGV2ZW50KQog
ewpkaWZmIC0tZ2l0IGEvZHJpdmVycy9hY3BpL3Byb2Nlc3Nvcl94ZW4uYyBiL2RyaXZlcnMvYWNw
aS9wcm9jZXNzb3JfeGVuLmMKaW5kZXggMzhhMWMwNS4uM2FmMWY3MyAxMDA2NDQKLS0tIGEvZHJp
dmVycy9hY3BpL3Byb2Nlc3Nvcl94ZW4uYworKysgYi9kcml2ZXJzL2FjcGkvcHJvY2Vzc29yX3hl
bi5jCkBAIC0yNCw2ICsyNCw3IEBACiAjZGVmaW5lIFBSRUZJWCAiQUNQSTogIgogCiAjZGVmaW5l
IEFDUElfUFJPQ0VTU09SX0NMQVNTICAgICAgICAgICAgInByb2Nlc3NvciIKKyNkZWZpbmUgQUNQ
SV9QUk9DRVNTT1JfREVWSUNFX05BTUUgICAgICAiUHJvY2Vzc29yIgogI2RlZmluZSBBQ1BJX1BS
T0NFU1NPUl9OT1RJRllfUEVSRk9STUFOQ0UgMHg4MAogI2RlZmluZSBBQ1BJX1BST0NFU1NPUl9O
T1RJRllfUE9XRVIJMHg4MQogI2RlZmluZSBBQ1BJX1BST0NFU1NPUl9OT1RJRllfVEhST1RUTElO
RwkweDgyCkBAIC04OCw2ICs4OSw4IEBAIHhlbl9hY3BpX3Byb2Nlc3Nvcl9ob3RhZGRfaW5pdChz
dHJ1Y3QgYWNwaV9wcm9jZXNzb3IgKnByLCBpbnQgKnBfY3B1KQogCQkJCVBST0NFU1NPUl9IT1RQ
TFVHLCBIT1RQTFVHX1RZUEVfQUREKSkKIAkJcmV0dXJuIEFFX0VSUk9SOwogCisJKnBfY3B1ID0g
eGVuX3BjcHVfaW5kZXgocHItPmFjcGlfaWQsIDEpOworCiAJcmV0dXJuIEFFX09LOwogfQogCkBA
IC0xNDksMTMgKzE1MiwyNDggQEAgZXJyX291dDoKIH0KICNlbmRpZiAvKiBDT05GSUdfQ1BVX0ZS
RVEgKi8KIAorc3RhdGljIGludCB4ZW5fYWNwaV9wcm9jZXNzb3JfZ2V0X2luZm8oc3RydWN0IGFj
cGlfZGV2aWNlICpkZXZpY2UpCit7CisJYWNwaV9zdGF0dXMgc3RhdHVzID0gMDsKKwl1bmlvbiBh
Y3BpX29iamVjdCBvYmplY3QgPSB7IDAgfTsKKwlzdHJ1Y3QgYWNwaV9idWZmZXIgYnVmZmVyID0g
eyBzaXplb2YodW5pb24gYWNwaV9vYmplY3QpLCAmb2JqZWN0IH07CisJc3RydWN0IGFjcGlfcHJv
Y2Vzc29yICpwcjsKKwlpbnQgY3B1X2luZGV4LCBkZXZpY2VfZGVjbGFyYXRpb24gPSAwOworCXN0
YXRpYyBpbnQgY3B1MF9pbml0aWFsaXplZDsKKworCXByID0gYWNwaV9kcml2ZXJfZGF0YShkZXZp
Y2UpOworCWlmICghcHIpCisJCXJldHVybiAtRUlOVkFMOworCisJaWYgKG51bV9vbmxpbmVfY3B1
cygpID4gMSkKKwkJZXJyYXRhLnNtcCA9IFRSVUU7CisKKwlhY3BpX3Byb2Nlc3Nvcl9lcnJhdGEo
cHIpOworCisJLyoKKwkgKiBDaGVjayB0byBzZWUgaWYgd2UgaGF2ZSBidXMgbWFzdGVyaW5nIGFy
Yml0cmF0aW9uIGNvbnRyb2wuICBUaGlzCisJICogaXMgcmVxdWlyZWQgZm9yIHByb3BlciBDMyB1
c2FnZSAodG8gbWFpbnRhaW4gY2FjaGUgY29oZXJlbmN5KS4KKwkgKi8KKwlpZiAoYWNwaV9nYmxf
RkFEVC5wbTJfY29udHJvbF9ibG9jayAmJiBhY3BpX2dibF9GQURULnBtMl9jb250cm9sX2xlbmd0
aCkgeworCQlwci0+ZmxhZ3MuYm1fY29udHJvbCA9IDE7CisJCUFDUElfREVCVUdfUFJJTlQoKEFD
UElfREJfSU5GTywKKwkJCQkgICJCdXMgbWFzdGVyaW5nIGFyYml0cmF0aW9uIGNvbnRyb2wgcHJl
c2VudFxuIikpOworCX0gZWxzZQorCQlBQ1BJX0RFQlVHX1BSSU5UKChBQ1BJX0RCX0lORk8sCisJ
CQkJICAiTm8gYnVzIG1hc3RlcmluZyBhcmJpdHJhdGlvbiBjb250cm9sXG4iKSk7CisKKwlpZiAo
IXN0cmNtcChhY3BpX2RldmljZV9oaWQoZGV2aWNlKSwgQUNQSV9QUk9DRVNTT1JfT0JKRUNUX0hJ
RCkpIHsKKwkJLyogRGVjbGFyZWQgd2l0aCAiUHJvY2Vzc29yIiBzdGF0ZW1lbnQ7IG1hdGNoIFBy
b2Nlc3NvcklEICovCisJCXN0YXR1cyA9IGFjcGlfZXZhbHVhdGVfb2JqZWN0KHByLT5oYW5kbGUs
IE5VTEwsIE5VTEwsICZidWZmZXIpOworCQlpZiAoQUNQSV9GQUlMVVJFKHN0YXR1cykpIHsKKwkJ
CXByaW50ayhLRVJOX0VSUiBQUkVGSVggIkV2YWx1YXRpbmcgcHJvY2Vzc29yIG9iamVjdFxuIik7
CisJCQlyZXR1cm4gLUVOT0RFVjsKKwkJfQorCisJCS8qCisJCSAqIFRCRDogU3luY2ggcHJvY2Vz
c29yIElEICh2aWEgTEFQSUMvTFNBUElDIHN0cnVjdHVyZXMpIG9uIFNNUC4KKwkJICogICAgICA+
Pj4gJ2FjcGlfZ2V0X3Byb2Nlc3Nvcl9pZChhY3BpX2lkLCAmaWQpJyBpbgorCQkgKiAgICAgIGFy
Y2gveHh4L2FjcGkuYworCQkgKi8KKwkJcHItPmFjcGlfaWQgPSBvYmplY3QucHJvY2Vzc29yLnBy
b2NfaWQ7CisJfSBlbHNlIHsKKwkJLyoKKwkJICogRGVjbGFyZWQgd2l0aCAiRGV2aWNlIiBzdGF0
ZW1lbnQ7IG1hdGNoIF9VSUQuCisJCSAqIE5vdGUgdGhhdCB3ZSBkb24ndCBoYW5kbGUgc3RyaW5n
IF9VSURzIHlldC4KKwkJICovCisJCXVuc2lnbmVkIGxvbmcgbG9uZyB2YWx1ZTsKKwkJc3RhdHVz
ID0gYWNwaV9ldmFsdWF0ZV9pbnRlZ2VyKHByLT5oYW5kbGUsIE1FVEhPRF9OQU1FX19VSUQsCisJ
CQkJCQlOVUxMLCAmdmFsdWUpOworCQlpZiAoQUNQSV9GQUlMVVJFKHN0YXR1cykpIHsKKwkJCXBy
aW50ayhLRVJOX0VSUiBQUkVGSVgKKwkJCSAgICAiRXZhbHVhdGluZyBwcm9jZXNzb3IgX1VJRCBb
JSN4XVxuIiwgc3RhdHVzKTsKKwkJCXJldHVybiAtRU5PREVWOworCQl9CisJCWRldmljZV9kZWNs
YXJhdGlvbiA9IDE7CisJCXByLT5hY3BpX2lkID0gdmFsdWU7CisJfQorCisJY3B1X2luZGV4ID0g
eGVuX3BjcHVfaW5kZXgocHItPmFjcGlfaWQsIDEpOworCisJLyogSGFuZGxlIFVQIHN5c3RlbSBy
dW5uaW5nIFNNUCBrZXJuZWwsIHdpdGggbm8gTEFQSUMgaW4gTUFEVCAqLworCWlmICghY3B1MF9p
bml0aWFsaXplZCAmJiAoY3B1X2luZGV4ID09IC0xKSAmJgorCSAgICAobnVtX29ubGluZV9jcHVz
KCkgPT0gMSkpIHsKKwkJY3B1X2luZGV4ID0gMDsKKwl9CisKKwljcHUwX2luaXRpYWxpemVkID0g
MTsKKworCXByLT5pZCA9IGNwdV9pbmRleDsKKworCS8qCisJICogIEV4dHJhIFByb2Nlc3NvciBv
YmplY3RzIG1heSBiZSBlbnVtZXJhdGVkIG9uIE1QIHN5c3RlbXMgd2l0aAorCSAqICBsZXNzIHRo
YW4gdGhlIG1heCAjIG9mIENQVXMuIFRoZXkgc2hvdWxkIGJlIGlnbm9yZWQgX2lmZgorCSAqICB0
aGV5IGFyZSBwaHlzaWNhbGx5IG5vdCBwcmVzZW50LgorCSAqLworCWlmIChwci0+aWQgPT0gLTEp
IHsKKwkJaWYgKEFDUElfRkFJTFVSRQorCQkgICAgKHhlbl9hY3BpX3Byb2Nlc3Nvcl9ob3RhZGRf
aW5pdChwciwgJnByLT5pZCkpKSB7CisJCQlyZXR1cm4gLUVOT0RFVjsKKwkJfQorCX0KKwkvKgor
CSAqIE9uIHNvbWUgYm94ZXMgc2V2ZXJhbCBwcm9jZXNzb3JzIHVzZSB0aGUgc2FtZSBwcm9jZXNz
b3IgYnVzIGlkLgorCSAqIEJ1dCB0aGV5IGFyZSBsb2NhdGVkIGluIGRpZmZlcmVudCBzY29wZS4g
Rm9yIGV4YW1wbGU6CisJICogXF9TQi5TQ0swLkNQVTAKKwkgKiBcX1NCLlNDSzEuQ1BVMAorCSAq
IFJlbmFtZSB0aGUgcHJvY2Vzc29yIGRldmljZSBidXMgaWQuIEFuZCB0aGUgbmV3IGJ1cyBpZCB3
aWxsIGJlCisJICogZ2VuZXJhdGVkIGFzIHRoZSBmb2xsb3dpbmcgZm9ybWF0OgorCSAqIENQVStD
UFUgSUQuCisJICovCisJc3ByaW50ZihhY3BpX2RldmljZV9iaWQoZGV2aWNlKSwgIkNQVSVYIiwg
cHItPmlkKTsKKwlBQ1BJX0RFQlVHX1BSSU5UKChBQ1BJX0RCX0lORk8sICJQcm9jZXNzb3IgWyVk
OiVkXVxuIiwgcHItPmlkLAorCQkJICBwci0+YWNwaV9pZCkpOworCisJaWYgKCFvYmplY3QucHJv
Y2Vzc29yLnBibGtfYWRkcmVzcykKKwkJQUNQSV9ERUJVR19QUklOVCgoQUNQSV9EQl9JTkZPLCAi
Tm8gUEJMSyAoTlVMTCBhZGRyZXNzKVxuIikpOworCWVsc2UgaWYgKG9iamVjdC5wcm9jZXNzb3Iu
cGJsa19sZW5ndGggIT0gNikKKwkJcHJpbnRrKEtFUk5fRVJSIFBSRUZJWCAiSW52YWxpZCBQQkxL
IGxlbmd0aCBbJWRdXG4iLAorCQkJICAgIG9iamVjdC5wcm9jZXNzb3IucGJsa19sZW5ndGgpOwor
CWVsc2UgeworCQlwci0+dGhyb3R0bGluZy5hZGRyZXNzID0gb2JqZWN0LnByb2Nlc3Nvci5wYmxr
X2FkZHJlc3M7CisJCXByLT50aHJvdHRsaW5nLmR1dHlfb2Zmc2V0ID0gYWNwaV9nYmxfRkFEVC5k
dXR5X29mZnNldDsKKwkJcHItPnRocm90dGxpbmcuZHV0eV93aWR0aCA9IGFjcGlfZ2JsX0ZBRFQu
ZHV0eV93aWR0aDsKKworCQlwci0+cGJsayA9IG9iamVjdC5wcm9jZXNzb3IucGJsa19hZGRyZXNz
OworCisJCS8qCisJCSAqIFdlIGRvbid0IGNhcmUgYWJvdXQgZXJyb3IgcmV0dXJucyAtIHdlIGp1
c3QgdHJ5IHRvIG1hcmsKKwkJICogdGhlc2UgcmVzZXJ2ZWQgc28gdGhhdCBub2JvZHkgZWxzZSBp
cyBjb25mdXNlZCBpbnRvIHRoaW5raW5nCisJCSAqIHRoYXQgdGhpcyByZWdpb24gbWlnaHQgYmUg
dW51c2VkLi4KKwkJICoKKwkJICogKEluIHBhcnRpY3VsYXIsIGFsbG9jYXRpbmcgdGhlIElPIHJh
bmdlIGZvciBDYXJkYnVzKQorCQkgKi8KKwkJcmVxdWVzdF9yZWdpb24ocHItPnRocm90dGxpbmcu
YWRkcmVzcywgNiwgIkFDUEkgQ1BVIHRocm90dGxlIik7CisJfQorCisJLyoKKwkgKiBJZiBBQ1BJ
IGRlc2NyaWJlcyBhIHNsb3QgbnVtYmVyIGZvciB0aGlzIENQVSwgd2UgY2FuIHVzZSBpdAorCSAq
IGVuc3VyZSB3ZSBnZXQgdGhlIHJpZ2h0IHZhbHVlIGluIHRoZSAicGh5c2ljYWwgaWQiIGZpZWxk
CisJICogb2YgL3Byb2MvY3B1aW5mbworCSAqLworCXN0YXR1cyA9IGFjcGlfZXZhbHVhdGVfb2Jq
ZWN0KHByLT5oYW5kbGUsICJfU1VOIiwgTlVMTCwgJmJ1ZmZlcik7CisJaWYgKEFDUElfU1VDQ0VT
UyhzdGF0dXMpKQorCQlhcmNoX2ZpeF9waHlzX3BhY2thZ2VfaWQocHItPmlkLCBvYmplY3QuaW50
ZWdlci52YWx1ZSk7CisKKwlyZXR1cm4gMDsKK30KKworc3RhdGljIGludCBfX2NwdWluaXQgX194
ZW5fYWNwaV9wcm9jZXNzb3JfYWRkKHN0cnVjdCBhY3BpX2RldmljZSAqZGV2aWNlKQoreworCXN0
cnVjdCBhY3BpX3Byb2Nlc3NvciAqcHIgPSBOVUxMOworCWludCByZXN1bHQgPSAwOworCXN0cnVj
dCBzeXNfZGV2aWNlICpzeXNkZXY7CisKKwlwciA9IGt6YWxsb2Moc2l6ZW9mKHN0cnVjdCBhY3Bp
X3Byb2Nlc3NvciksIEdGUF9LRVJORUwpOworCWlmICghcHIpCisJCXJldHVybiAtRU5PTUVNOwor
CisJaWYgKCF6YWxsb2NfY3B1bWFza192YXIoJnByLT50aHJvdHRsaW5nLnNoYXJlZF9jcHVfbWFw
LCBHRlBfS0VSTkVMKSkgeworCQlrZnJlZShwcik7CisJCXJldHVybiAtRU5PTUVNOworCX0KKwor
CXByLT5oYW5kbGUgPSBkZXZpY2UtPmhhbmRsZTsKKwlzdHJjcHkoYWNwaV9kZXZpY2VfbmFtZShk
ZXZpY2UpLCBBQ1BJX1BST0NFU1NPUl9ERVZJQ0VfTkFNRSk7CisJc3RyY3B5KGFjcGlfZGV2aWNl
X2NsYXNzKGRldmljZSksIEFDUElfUFJPQ0VTU09SX0NMQVNTKTsKKwlkZXZpY2UtPmRyaXZlcl9k
YXRhID0gcHI7CisKKwlyZXN1bHQgPSB4ZW5fYWNwaV9wcm9jZXNzb3JfZ2V0X2luZm8oZGV2aWNl
KTsKKwlpZiAocmVzdWx0KSB7CisJCS8qIFByb2Nlc3NvciBpcyBwaHlzaWNhbGx5IG5vdCBwcmVz
ZW50ICovCisJCXJldHVybiAwOworCX0KKworI2lmZGVmIENPTkZJR19TTVAKKwlpZiAocHItPmlk
ID49IHNldHVwX21heF9jcHVzICYmIHByLT5pZCAhPSAwKQorCQlyZXR1cm4gMDsKKyNlbmRpZgor
CisJQlVHX09OKChwci0+aWQgPj0gbnJfY3B1X2lkcykgfHwgKHByLT5pZCA8IDApKTsKKworCS8q
CisJICogQnVnZ3kgQklPUyBjaGVjaworCSAqIEFDUEkgaWQgb2YgcHJvY2Vzc29ycyBjYW4gYmUg
cmVwb3J0ZWQgd3JvbmdseSBieSB0aGUgQklPUy4KKwkgKiBEb24ndCB0cnVzdCBpdCBibGluZGx5
CisJICovCisJaWYgKHBlcl9jcHUocHJvY2Vzc29yX2RldmljZV9hcnJheSwgcHItPmlkKSAhPSBO
VUxMICYmCisJICAgIHBlcl9jcHUocHJvY2Vzc29yX2RldmljZV9hcnJheSwgcHItPmlkKSAhPSBk
ZXZpY2UpIHsKKwkJcHJpbnRrKEtFUk5fV0FSTklORyAiQklPUyByZXBvcnRlZCB3cm9uZyBBQ1BJ
IGlkICIKKwkJCSJmb3IgdGhlIHByb2Nlc3NvclxuIik7CisJCXJlc3VsdCA9IC1FTk9ERVY7CisJ
CWdvdG8gZXJyX2ZyZWVfY3B1bWFzazsKKwl9CisJcGVyX2NwdShwcm9jZXNzb3JfZGV2aWNlX2Fy
cmF5LCBwci0+aWQpID0gZGV2aWNlOworCisJcGVyX2NwdShwcm9jZXNzb3JzLCBwci0+aWQpID0g
cHI7CisKKwlzeXNkZXYgPSBnZXRfY3B1X3N5c2Rldihwci0+aWQpOworCWlmIChzeXNmc19jcmVh
dGVfbGluaygmZGV2aWNlLT5kZXYua29iaiwgJnN5c2Rldi0+a29iaiwgInN5c2RldiIpKSB7CisJ
CXJlc3VsdCA9IC1FRkFVTFQ7CisJCWdvdG8gZXJyX2ZyZWVfY3B1bWFzazsKKwl9CisKKyNpZmRl
ZiBDT05GSUdfQ1BVX0ZSRVEKKwlhY3BpX3Byb2Nlc3Nvcl9wcGNfaGFzX2NoYW5nZWQocHIsIDAp
OworI2VuZGlmCisJYWNwaV9wcm9jZXNzb3JfZ2V0X3Rocm90dGxpbmdfaW5mbyhwcik7CisJYWNw
aV9wcm9jZXNzb3JfZ2V0X2xpbWl0X2luZm8ocHIpOworCisKKwlpZiAoY3B1aWRsZV9nZXRfZHJp
dmVyKCkgPT0gJmFjcGlfaWRsZV9kcml2ZXIpCisJCWFjcGlfcHJvY2Vzc29yX3Bvd2VyX2luaXQo
cHIsIGRldmljZSk7CisKKwlwci0+Y2RldiA9IHRoZXJtYWxfY29vbGluZ19kZXZpY2VfcmVnaXN0
ZXIoIlByb2Nlc3NvciIsIGRldmljZSwKKwkJCQkJCSZwcm9jZXNzb3JfY29vbGluZ19vcHMpOwor
CWlmIChJU19FUlIocHItPmNkZXYpKSB7CisJCXJlc3VsdCA9IFBUUl9FUlIocHItPmNkZXYpOwor
CQlnb3RvIGVycl9wb3dlcl9leGl0OworCX0KKworCWRldl9kYmcoJmRldmljZS0+ZGV2LCAicmVn
aXN0ZXJlZCBhcyBjb29saW5nX2RldmljZSVkXG4iLAorCQkgcHItPmNkZXYtPmlkKTsKKworCXJl
c3VsdCA9IHN5c2ZzX2NyZWF0ZV9saW5rKCZkZXZpY2UtPmRldi5rb2JqLAorCQkJCSAgICZwci0+
Y2Rldi0+ZGV2aWNlLmtvYmosCisJCQkJICAgInRoZXJtYWxfY29vbGluZyIpOworCWlmIChyZXN1
bHQpIHsKKwkJcHJpbnRrKEtFUk5fRVJSIFBSRUZJWCAiQ3JlYXRlIHN5c2ZzIGxpbmtcbiIpOwor
CQlnb3RvIGVycl90aGVybWFsX3VucmVnaXN0ZXI7CisJfQorCXJlc3VsdCA9IHN5c2ZzX2NyZWF0
ZV9saW5rKCZwci0+Y2Rldi0+ZGV2aWNlLmtvYmosCisJCQkJICAgJmRldmljZS0+ZGV2LmtvYmos
CisJCQkJICAgImRldmljZSIpOworCWlmIChyZXN1bHQpIHsKKwkJcHJpbnRrKEtFUk5fRVJSIFBS
RUZJWCAiQ3JlYXRlIHN5c2ZzIGxpbmtcbiIpOworCQlnb3RvIGVycl9yZW1vdmVfc3lzZnM7CisJ
fQorCisJcmV0dXJuIDA7CisKK2Vycl9yZW1vdmVfc3lzZnM6CisJc3lzZnNfcmVtb3ZlX2xpbmso
JmRldmljZS0+ZGV2LmtvYmosICJ0aGVybWFsX2Nvb2xpbmciKTsKK2Vycl90aGVybWFsX3VucmVn
aXN0ZXI6CisJdGhlcm1hbF9jb29saW5nX2RldmljZV91bnJlZ2lzdGVyKHByLT5jZGV2KTsKK2Vy
cl9wb3dlcl9leGl0OgorCWFjcGlfcHJvY2Vzc29yX3Bvd2VyX2V4aXQocHIsIGRldmljZSk7Citl
cnJfZnJlZV9jcHVtYXNrOgorCWZyZWVfY3B1bWFza192YXIocHItPnRocm90dGxpbmcuc2hhcmVk
X2NwdV9tYXApOworCisJcmV0dXJuIHJlc3VsdDsKK30KKwogc3RhdGljIGludCBfX2NwdWluaXQg
eGVuX2FjcGlfcHJvY2Vzc29yX2FkZChzdHJ1Y3QgYWNwaV9kZXZpY2UgKmRldmljZSkKIHsKIAlz
dHJ1Y3QgYWNwaV9wcm9jZXNzb3IgKnByID0gTlVMTDsKIAlpbnQgcmVzdWx0ID0gMDsKIAotCXJl
c3VsdCA9IGFjcGlfcHJvY2Vzc29yX2FkZChkZXZpY2UpOwotCWlmIChyZXN1bHQgPCAwKQorCXJl
c3VsdCA9IF9feGVuX2FjcGlfcHJvY2Vzc29yX2FkZChkZXZpY2UpOworCWlmIChyZXN1bHQpCiAJ
CXJldHVybiByZXN1bHQ7CiAKIAlwciA9IGFjcGlfZHJpdmVyX2RhdGEoZGV2aWNlKTsKZGlmZiAt
LWdpdCBhL2luY2x1ZGUvYWNwaS9wcm9jZXNzb3IuaCBiL2luY2x1ZGUvYWNwaS9wcm9jZXNzb3Iu
aAppbmRleCBjNDhlMmY5Li4zYTFlZTAxIDEwMDY0NAotLS0gYS9pbmNsdWRlL2FjcGkvcHJvY2Vz
c29yLmgKKysrIGIvaW5jbHVkZS9hY3BpL3Byb2Nlc3Nvci5oCkBAIC0yMjUsNiArMjI1LDggQEAg
c3RydWN0IGFjcGlfcHJvY2Vzc29yX2VycmF0YSB7CiAJfSBwaWl4NDsKIH07CiAKK2V4dGVybiBp
bnQgYWNwaV9wcm9jZXNzb3JfZXJyYXRhKHN0cnVjdCBhY3BpX3Byb2Nlc3NvciAqcHIpOworCiBl
eHRlcm4gaW50IGFjcGlfcHJvY2Vzc29yX3ByZXJlZ2lzdGVyX3BlcmZvcm1hbmNlKHN0cnVjdAog
CQkJCQkJICBhY3BpX3Byb2Nlc3Nvcl9wZXJmb3JtYW5jZQogCQkJCQkJICBfX3BlcmNwdSAqcGVy
Zm9ybWFuY2UpOwpkaWZmIC0tZ2l0IGEvaW5jbHVkZS94ZW4vcGNwdS5oIGIvaW5jbHVkZS94ZW4v
cGNwdS5oCmluZGV4IDdlOGY5ZDEuLjNlOTlkYjkgMTAwNjQ0Ci0tLSBhL2luY2x1ZGUveGVuL3Bj
cHUuaAorKysgYi9pbmNsdWRlL3hlbi9wY3B1LmgKQEAgLTQsNiArNCw4IEBACiAjaW5jbHVkZSA8
eGVuL2ludGVyZmFjZS9wbGF0Zm9ybS5oPgogI2luY2x1ZGUgPGxpbnV4L3N5c2Rldi5oPgogCitl
eHRlcm4gREVGSU5FX1BFUl9DUFUodm9pZCAqLCBwcm9jZXNzb3JfZGV2aWNlX2FycmF5KTsKKwog
ZXh0ZXJuIGludCB4ZW5fcGNwdV9ob3RwbHVnKGludCB0eXBlLCB1aW50MzJfdCBhcGljX2lkKTsK
ICNkZWZpbmUgWEVOX1BDUFVfT05MSU5FICAgICAweDAxCiAjZGVmaW5lIFhFTl9QQ1BVX09GRkxJ
TkUgICAgMHgwMgotLSAKMS42LjUuNgoK

--_002_DE8DF0795D48FD4CA783C40EC82923359720SHSMSX101ccrcorpint_--
