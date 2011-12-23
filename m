Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756596Ab1LWK0z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Dec 2011 05:26:55 -0500
Received: from mga01.intel.com ([192.55.52.88]:62759 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754092Ab1LWK0x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Dec 2011 05:26:53 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208,223";a="99638597"
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
Subject: [PATCH 04/10] Xen: Add pcpu hotadd support to pvops dom0.
Thread-Topic: [PATCH 04/10] Xen: Add pcpu hotadd support to pvops dom0.
Thread-Index: AczBXVB6uMUxR0YtT4yH9J/oEfJ7Ig==
Date: Fri, 23 Dec 2011 10:26:21 +0000
Message-ID: <DE8DF0795D48FD4CA783C40EC829233596DC@SHSMSX101.ccr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: multipart/mixed;
	boundary="_002_DE8DF0795D48FD4CA783C40EC829233596DCSHSMSX101ccrcorpint_"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--_002_DE8DF0795D48FD4CA783C40EC829233596DCSHSMSX101ccrcorpint_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

>From 5f5eb7bf950836edb4910173d3be2f26ad737093 Mon Sep 17 00:00:00 2001
From: Liu Jinsong <jinsong.liu@intel.com>
Date: Sun, 11 Dec 2011 15:42:03 +0800
Subject: [PATCH 04/10] Xen: Add pcpu hotadd support to pvops dom0.

This patch rebased from Jeremy's pvops commit
3129884bc75d7e6578be7499ac04a06d9fc5b31d

This patch implement CPU hotplug callback in xen acpi_processor. User
can later bring the pcpu online through sysfs interface.

xen_get_apic_id() is mostly duplicated with the get_cpu_id() in
driver/acpi/processor_core.c, but it should be ok since it has been
duplicated in arch directory already by upstream kernel.

One thing left is, currently the acpi_processor's id is quite
confusing (it is in fact with vcpu's dom0 cpu_id). Will update it with
xen's cpuid through the pcpu interface. But to achieve it, we need
investigate more on the pr->id, and also we need change the pcpu logic
to use spin_lock, instead of mutex for the pcpu list. That will be
next step.

Signed-off-by: Liu, Jinsong <jinsong.liu@intel.com>
Signed-off-by: Jiang, Yunhong <yunhong.jiang@intel.com>
Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 drivers/xen/acpi_processor.c     |  114 ++++++++++++++++++++++++++++++++++=
+++-
 include/xen/interface/platform.h |   10 +++-
 2 files changed, 122 insertions(+), 2 deletions(-)

diff --git a/drivers/xen/acpi_processor.c b/drivers/xen/acpi_processor.c
index 327a56e..acab49b 100644
--- a/drivers/xen/acpi_processor.c
+++ b/drivers/xen/acpi_processor.c
@@ -22,12 +22,19 @@
 #include <linux/cpufreq.h>
 #include <acpi/processor.h>
 #include <xen/acpi.h>
+#include <xen/pcpu.h>
=20
 #include <xen/interface/platform.h>
 #include <asm/xen/hypercall.h>
 #include <asm/xen/hypervisor.h>
=20
-static struct processor_cntl_xen_ops xen_ops;
+static int xen_get_apic_id(acpi_handle handle);
+static int xen_cpu_hotplug_notifier(struct acpi_processor *pr, int event);
+
+static struct processor_cntl_xen_ops xen_ops =3D {
+	.hotplug =3D xen_cpu_hotplug_notifier,
+};
+
 int processor_cntl_xen_notify(struct acpi_processor *pr, int event, int ty=
pe)
 {
 	int ret =3D -EINVAL;
@@ -41,6 +48,18 @@ int processor_cntl_xen_notify(struct acpi_processor *pr,=
 int event, int type)
=20
 		ret =3D xen_ops.pm_ops[type](pr, event);
 		break;
+	case PROCESSOR_HOTPLUG:
+	{
+		int apic_id;
+
+		apic_id =3D xen_get_apic_id(pr->handle);
+		if (apic_id < 0)
+			break;
+		if (xen_ops.hotplug)
+			ret =3D xen_ops.hotplug(pr, type);
+		xen_pcpu_hotplug(type, apic_id);
+		break;
+	}
 	default:
 		printk(KERN_ERR "Unsupport processor events %d.\n", event);
 		break;
@@ -50,6 +69,49 @@ int processor_cntl_xen_notify(struct acpi_processor *pr,=
 int event, int type)
 }
 EXPORT_SYMBOL(processor_cntl_xen_notify);
=20
+#ifdef CONFIG_ACPI_HOTPLUG_CPU
+static int xen_get_apic_id(acpi_handle handle)
+{
+	struct acpi_buffer buffer =3D { ACPI_ALLOCATE_BUFFER, NULL };
+	union acpi_object *obj;
+	struct acpi_madt_local_apic *lapic;
+	u8 physid;
+
+	if (ACPI_FAILURE(acpi_evaluate_object(handle, "_MAT", NULL, &buffer)))
+		return -EINVAL;
+
+	if (!buffer.length || !buffer.pointer)
+		return -EINVAL;
+
+	obj =3D buffer.pointer;
+	if (obj->type !=3D ACPI_TYPE_BUFFER ||
+	    obj->buffer.length < sizeof(*lapic)) {
+		kfree(buffer.pointer);
+		return -EINVAL;
+	}
+
+	lapic =3D (struct acpi_madt_local_apic *)obj->buffer.pointer;
+
+	if (lapic->header.type !=3D ACPI_MADT_TYPE_LOCAL_APIC ||
+	    !(lapic->lapic_flags & ACPI_MADT_ENABLED)) {
+		kfree(buffer.pointer);
+		return -EINVAL;
+	}
+
+	physid =3D lapic->id;
+	kfree(buffer.pointer);
+	buffer.length =3D ACPI_ALLOCATE_BUFFER;
+	buffer.pointer =3D NULL;
+
+	return physid;
+}
+#else
+static int xen_get_apic_id(acpi_handle handle)
+{
+	return -1;
+}
+#endif
+
 static inline void xen_convert_pct_reg(struct xen_pct_register *xpct,
 	struct acpi_pct_register *apct)
 {
@@ -246,6 +308,56 @@ static int xen_px_notifier(struct acpi_processor *pr, =
int action)
 	return ret;
 }
=20
+#ifdef CONFIG_ACPI_HOTPLUG_CPU
+static int xen_cpu_hotplug_notifier(struct acpi_processor *pr, int event)
+{
+	int ret =3D -EINVAL;
+	uint32_t apic_id;
+	unsigned long long pxm;
+	acpi_status status =3D 0;
+
+	xen_platform_op_t op =3D {
+		.interface_version  =3D XENPF_INTERFACE_VERSION,
+	};
+
+	apic_id =3D xen_get_apic_id(pr->handle);
+	if (apic_id < 0) {
+		printk(KERN_WARNING "Can't get apic_id for acpi_id %x\n",
+		  pr->acpi_id);
+		return -1;
+	}
+
+	status =3D acpi_evaluate_integer(pr->handle, "_PXM",
+	  NULL, &pxm);
+	if (ACPI_FAILURE(status)) {
+		printk(KERN_WARNING "can't get pxm for acpi_id %x\n",
+		  pr->acpi_id);
+		return -1;
+	}
+
+	switch (event) {
+	case HOTPLUG_TYPE_ADD:
+		op.cmd =3D XENPF_cpu_hotadd;
+		op.u.cpu_add.apic_id =3D apic_id;
+		op.u.cpu_add.acpi_id =3D pr->acpi_id;
+		op.u.cpu_add.pxm =3D pxm;
+		ret =3D HYPERVISOR_dom0_op(&op);
+		break;
+	case HOTPLUG_TYPE_REMOVE:
+		printk(KERN_WARNING "Xen not support CPU hotremove\n");
+		ret =3D -ENOSYS;
+		break;
+	}
+
+	return ret;
+}
+#else
+static int xen_cpu_hotplug_notifier(struct acpi_processor *pr, int event)
+{
+	return -ENOSYS;
+}
+#endif
+
 static int __init xen_acpi_processor_extcntl_init(void)
 {
 	unsigned int pmbits;
diff --git a/include/xen/interface/platform.h b/include/xen/interface/platf=
orm.h
index 47ffe16..9fd6b07 100644
--- a/include/xen/interface/platform.h
+++ b/include/xen/interface/platform.h
@@ -317,11 +317,18 @@ DEFINE_GUEST_HANDLE_STRUCT(xenpf_pcpuinfo_t);
 #define XENPF_cpu_online    56
 #define XENPF_cpu_offline   57
 struct xenpf_cpu_ol {
-    uint32_t cpuid;
+	uint32_t cpuid;
 };
 typedef struct xenpf_cpu_ol xenpf_cpu_ol_t;
 DEFINE_GUEST_HANDLE_STRUCT(xenpf_cpu_ol_t);
=20
+#define XENPF_cpu_hotadd    58
+struct xenpf_cpu_hotadd {
+	uint32_t apic_id;
+	uint32_t acpi_id;
+	uint32_t pxm;
+};
+
 struct xen_platform_op {
 	uint32_t cmd;
 	uint32_t interface_version; /* XENPF_INTERFACE_VERSION */
@@ -339,6 +346,7 @@ struct xen_platform_op {
 		struct xenpf_set_processor_pminfo set_pminfo;
 		struct xenpf_pcpuinfo          pcpu_info;
 		struct xenpf_cpu_ol            cpu_ol;
+		struct xenpf_cpu_hotadd        cpu_add;
 		uint8_t                        pad[128];
 	} u;
 };
--=20
1.6.5.6

--_002_DE8DF0795D48FD4CA783C40EC829233596DCSHSMSX101ccrcorpint_
Content-Type: application/octet-stream;
	name="0004-Xen-Add-pcpu-hotadd-support-to-pvops-dom0.patch"
Content-Description: 0004-Xen-Add-pcpu-hotadd-support-to-pvops-dom0.patch
Content-Disposition: attachment;
	filename="0004-Xen-Add-pcpu-hotadd-support-to-pvops-dom0.patch"; size=6111;
	creation-date="Wed, 14 Dec 2011 15:20:15 GMT";
	modification-date="Wed, 14 Dec 2011 15:03:34 GMT"
Content-Transfer-Encoding: base64

RnJvbSA1ZjVlYjdiZjk1MDgzNmVkYjQ5MTAxNzNkM2JlMmYyNmFkNzM3MDkzIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBMaXUgSmluc29uZyA8amluc29uZy5saXVAaW50ZWwuY29tPgpE
YXRlOiBTdW4sIDExIERlYyAyMDExIDE1OjQyOjAzICswODAwClN1YmplY3Q6IFtQQVRDSCAwNC8x
MF0gWGVuOiBBZGQgcGNwdSBob3RhZGQgc3VwcG9ydCB0byBwdm9wcyBkb20wLgoKVGhpcyBwYXRj
aCByZWJhc2VkIGZyb20gSmVyZW15J3MgcHZvcHMgY29tbWl0CjMxMjk4ODRiYzc1ZDdlNjU3OGJl
NzQ5OWFjMDRhMDZkOWZjNWIzMWQKClRoaXMgcGF0Y2ggaW1wbGVtZW50IENQVSBob3RwbHVnIGNh
bGxiYWNrIGluIHhlbiBhY3BpX3Byb2Nlc3Nvci4gVXNlcgpjYW4gbGF0ZXIgYnJpbmcgdGhlIHBj
cHUgb25saW5lIHRocm91Z2ggc3lzZnMgaW50ZXJmYWNlLgoKeGVuX2dldF9hcGljX2lkKCkgaXMg
bW9zdGx5IGR1cGxpY2F0ZWQgd2l0aCB0aGUgZ2V0X2NwdV9pZCgpIGluCmRyaXZlci9hY3BpL3By
b2Nlc3Nvcl9jb3JlLmMsIGJ1dCBpdCBzaG91bGQgYmUgb2sgc2luY2UgaXQgaGFzIGJlZW4KZHVw
bGljYXRlZCBpbiBhcmNoIGRpcmVjdG9yeSBhbHJlYWR5IGJ5IHVwc3RyZWFtIGtlcm5lbC4KCk9u
ZSB0aGluZyBsZWZ0IGlzLCBjdXJyZW50bHkgdGhlIGFjcGlfcHJvY2Vzc29yJ3MgaWQgaXMgcXVp
dGUKY29uZnVzaW5nIChpdCBpcyBpbiBmYWN0IHdpdGggdmNwdSdzIGRvbTAgY3B1X2lkKS4gV2ls
bCB1cGRhdGUgaXQgd2l0aAp4ZW4ncyBjcHVpZCB0aHJvdWdoIHRoZSBwY3B1IGludGVyZmFjZS4g
QnV0IHRvIGFjaGlldmUgaXQsIHdlIG5lZWQKaW52ZXN0aWdhdGUgbW9yZSBvbiB0aGUgcHItPmlk
LCBhbmQgYWxzbyB3ZSBuZWVkIGNoYW5nZSB0aGUgcGNwdSBsb2dpYwp0byB1c2Ugc3Bpbl9sb2Nr
LCBpbnN0ZWFkIG9mIG11dGV4IGZvciB0aGUgcGNwdSBsaXN0LiBUaGF0IHdpbGwgYmUKbmV4dCBz
dGVwLgoKU2lnbmVkLW9mZi1ieTogTGl1LCBKaW5zb25nIDxqaW5zb25nLmxpdUBpbnRlbC5jb20+
ClNpZ25lZC1vZmYtYnk6IEppYW5nLCBZdW5ob25nIDx5dW5ob25nLmppYW5nQGludGVsLmNvbT4K
U2lnbmVkLW9mZi1ieTogSmVyZW15IEZpdHpoYXJkaW5nZSA8amVyZW15LmZpdHpoYXJkaW5nZUBj
aXRyaXguY29tPgotLS0KIGRyaXZlcnMveGVuL2FjcGlfcHJvY2Vzc29yLmMgICAgIHwgIDExNCAr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrLQogaW5jbHVkZS94ZW4vaW50ZXJm
YWNlL3BsYXRmb3JtLmggfCAgIDEwICsrKy0KIDIgZmlsZXMgY2hhbmdlZCwgMTIyIGluc2VydGlv
bnMoKyksIDIgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvZHJpdmVycy94ZW4vYWNwaV9wcm9j
ZXNzb3IuYyBiL2RyaXZlcnMveGVuL2FjcGlfcHJvY2Vzc29yLmMKaW5kZXggMzI3YTU2ZS4uYWNh
YjQ5YiAxMDA2NDQKLS0tIGEvZHJpdmVycy94ZW4vYWNwaV9wcm9jZXNzb3IuYworKysgYi9kcml2
ZXJzL3hlbi9hY3BpX3Byb2Nlc3Nvci5jCkBAIC0yMiwxMiArMjIsMTkgQEAKICNpbmNsdWRlIDxs
aW51eC9jcHVmcmVxLmg+CiAjaW5jbHVkZSA8YWNwaS9wcm9jZXNzb3IuaD4KICNpbmNsdWRlIDx4
ZW4vYWNwaS5oPgorI2luY2x1ZGUgPHhlbi9wY3B1Lmg+CiAKICNpbmNsdWRlIDx4ZW4vaW50ZXJm
YWNlL3BsYXRmb3JtLmg+CiAjaW5jbHVkZSA8YXNtL3hlbi9oeXBlcmNhbGwuaD4KICNpbmNsdWRl
IDxhc20veGVuL2h5cGVydmlzb3IuaD4KIAotc3RhdGljIHN0cnVjdCBwcm9jZXNzb3JfY250bF94
ZW5fb3BzIHhlbl9vcHM7CitzdGF0aWMgaW50IHhlbl9nZXRfYXBpY19pZChhY3BpX2hhbmRsZSBo
YW5kbGUpOworc3RhdGljIGludCB4ZW5fY3B1X2hvdHBsdWdfbm90aWZpZXIoc3RydWN0IGFjcGlf
cHJvY2Vzc29yICpwciwgaW50IGV2ZW50KTsKKworc3RhdGljIHN0cnVjdCBwcm9jZXNzb3JfY250
bF94ZW5fb3BzIHhlbl9vcHMgPSB7CisJLmhvdHBsdWcgPSB4ZW5fY3B1X2hvdHBsdWdfbm90aWZp
ZXIsCit9OworCiBpbnQgcHJvY2Vzc29yX2NudGxfeGVuX25vdGlmeShzdHJ1Y3QgYWNwaV9wcm9j
ZXNzb3IgKnByLCBpbnQgZXZlbnQsIGludCB0eXBlKQogewogCWludCByZXQgPSAtRUlOVkFMOwpA
QCAtNDEsNiArNDgsMTggQEAgaW50IHByb2Nlc3Nvcl9jbnRsX3hlbl9ub3RpZnkoc3RydWN0IGFj
cGlfcHJvY2Vzc29yICpwciwgaW50IGV2ZW50LCBpbnQgdHlwZSkKIAogCQlyZXQgPSB4ZW5fb3Bz
LnBtX29wc1t0eXBlXShwciwgZXZlbnQpOwogCQlicmVhazsKKwljYXNlIFBST0NFU1NPUl9IT1RQ
TFVHOgorCXsKKwkJaW50IGFwaWNfaWQ7CisKKwkJYXBpY19pZCA9IHhlbl9nZXRfYXBpY19pZChw
ci0+aGFuZGxlKTsKKwkJaWYgKGFwaWNfaWQgPCAwKQorCQkJYnJlYWs7CisJCWlmICh4ZW5fb3Bz
LmhvdHBsdWcpCisJCQlyZXQgPSB4ZW5fb3BzLmhvdHBsdWcocHIsIHR5cGUpOworCQl4ZW5fcGNw
dV9ob3RwbHVnKHR5cGUsIGFwaWNfaWQpOworCQlicmVhazsKKwl9CiAJZGVmYXVsdDoKIAkJcHJp
bnRrKEtFUk5fRVJSICJVbnN1cHBvcnQgcHJvY2Vzc29yIGV2ZW50cyAlZC5cbiIsIGV2ZW50KTsK
IAkJYnJlYWs7CkBAIC01MCw2ICs2OSw0OSBAQCBpbnQgcHJvY2Vzc29yX2NudGxfeGVuX25vdGlm
eShzdHJ1Y3QgYWNwaV9wcm9jZXNzb3IgKnByLCBpbnQgZXZlbnQsIGludCB0eXBlKQogfQogRVhQ
T1JUX1NZTUJPTChwcm9jZXNzb3JfY250bF94ZW5fbm90aWZ5KTsKIAorI2lmZGVmIENPTkZJR19B
Q1BJX0hPVFBMVUdfQ1BVCitzdGF0aWMgaW50IHhlbl9nZXRfYXBpY19pZChhY3BpX2hhbmRsZSBo
YW5kbGUpCit7CisJc3RydWN0IGFjcGlfYnVmZmVyIGJ1ZmZlciA9IHsgQUNQSV9BTExPQ0FURV9C
VUZGRVIsIE5VTEwgfTsKKwl1bmlvbiBhY3BpX29iamVjdCAqb2JqOworCXN0cnVjdCBhY3BpX21h
ZHRfbG9jYWxfYXBpYyAqbGFwaWM7CisJdTggcGh5c2lkOworCisJaWYgKEFDUElfRkFJTFVSRShh
Y3BpX2V2YWx1YXRlX29iamVjdChoYW5kbGUsICJfTUFUIiwgTlVMTCwgJmJ1ZmZlcikpKQorCQly
ZXR1cm4gLUVJTlZBTDsKKworCWlmICghYnVmZmVyLmxlbmd0aCB8fCAhYnVmZmVyLnBvaW50ZXIp
CisJCXJldHVybiAtRUlOVkFMOworCisJb2JqID0gYnVmZmVyLnBvaW50ZXI7CisJaWYgKG9iai0+
dHlwZSAhPSBBQ1BJX1RZUEVfQlVGRkVSIHx8CisJICAgIG9iai0+YnVmZmVyLmxlbmd0aCA8IHNp
emVvZigqbGFwaWMpKSB7CisJCWtmcmVlKGJ1ZmZlci5wb2ludGVyKTsKKwkJcmV0dXJuIC1FSU5W
QUw7CisJfQorCisJbGFwaWMgPSAoc3RydWN0IGFjcGlfbWFkdF9sb2NhbF9hcGljICopb2JqLT5i
dWZmZXIucG9pbnRlcjsKKworCWlmIChsYXBpYy0+aGVhZGVyLnR5cGUgIT0gQUNQSV9NQURUX1RZ
UEVfTE9DQUxfQVBJQyB8fAorCSAgICAhKGxhcGljLT5sYXBpY19mbGFncyAmIEFDUElfTUFEVF9F
TkFCTEVEKSkgeworCQlrZnJlZShidWZmZXIucG9pbnRlcik7CisJCXJldHVybiAtRUlOVkFMOwor
CX0KKworCXBoeXNpZCA9IGxhcGljLT5pZDsKKwlrZnJlZShidWZmZXIucG9pbnRlcik7CisJYnVm
ZmVyLmxlbmd0aCA9IEFDUElfQUxMT0NBVEVfQlVGRkVSOworCWJ1ZmZlci5wb2ludGVyID0gTlVM
TDsKKworCXJldHVybiBwaHlzaWQ7Cit9CisjZWxzZQorc3RhdGljIGludCB4ZW5fZ2V0X2FwaWNf
aWQoYWNwaV9oYW5kbGUgaGFuZGxlKQoreworCXJldHVybiAtMTsKK30KKyNlbmRpZgorCiBzdGF0
aWMgaW5saW5lIHZvaWQgeGVuX2NvbnZlcnRfcGN0X3JlZyhzdHJ1Y3QgeGVuX3BjdF9yZWdpc3Rl
ciAqeHBjdCwKIAlzdHJ1Y3QgYWNwaV9wY3RfcmVnaXN0ZXIgKmFwY3QpCiB7CkBAIC0yNDYsNiAr
MzA4LDU2IEBAIHN0YXRpYyBpbnQgeGVuX3B4X25vdGlmaWVyKHN0cnVjdCBhY3BpX3Byb2Nlc3Nv
ciAqcHIsIGludCBhY3Rpb24pCiAJcmV0dXJuIHJldDsKIH0KIAorI2lmZGVmIENPTkZJR19BQ1BJ
X0hPVFBMVUdfQ1BVCitzdGF0aWMgaW50IHhlbl9jcHVfaG90cGx1Z19ub3RpZmllcihzdHJ1Y3Qg
YWNwaV9wcm9jZXNzb3IgKnByLCBpbnQgZXZlbnQpCit7CisJaW50IHJldCA9IC1FSU5WQUw7CisJ
dWludDMyX3QgYXBpY19pZDsKKwl1bnNpZ25lZCBsb25nIGxvbmcgcHhtOworCWFjcGlfc3RhdHVz
IHN0YXR1cyA9IDA7CisKKwl4ZW5fcGxhdGZvcm1fb3BfdCBvcCA9IHsKKwkJLmludGVyZmFjZV92
ZXJzaW9uICA9IFhFTlBGX0lOVEVSRkFDRV9WRVJTSU9OLAorCX07CisKKwlhcGljX2lkID0geGVu
X2dldF9hcGljX2lkKHByLT5oYW5kbGUpOworCWlmIChhcGljX2lkIDwgMCkgeworCQlwcmludGso
S0VSTl9XQVJOSU5HICJDYW4ndCBnZXQgYXBpY19pZCBmb3IgYWNwaV9pZCAleFxuIiwKKwkJICBw
ci0+YWNwaV9pZCk7CisJCXJldHVybiAtMTsKKwl9CisKKwlzdGF0dXMgPSBhY3BpX2V2YWx1YXRl
X2ludGVnZXIocHItPmhhbmRsZSwgIl9QWE0iLAorCSAgTlVMTCwgJnB4bSk7CisJaWYgKEFDUElf
RkFJTFVSRShzdGF0dXMpKSB7CisJCXByaW50ayhLRVJOX1dBUk5JTkcgImNhbid0IGdldCBweG0g
Zm9yIGFjcGlfaWQgJXhcbiIsCisJCSAgcHItPmFjcGlfaWQpOworCQlyZXR1cm4gLTE7CisJfQor
CisJc3dpdGNoIChldmVudCkgeworCWNhc2UgSE9UUExVR19UWVBFX0FERDoKKwkJb3AuY21kID0g
WEVOUEZfY3B1X2hvdGFkZDsKKwkJb3AudS5jcHVfYWRkLmFwaWNfaWQgPSBhcGljX2lkOworCQlv
cC51LmNwdV9hZGQuYWNwaV9pZCA9IHByLT5hY3BpX2lkOworCQlvcC51LmNwdV9hZGQucHhtID0g
cHhtOworCQlyZXQgPSBIWVBFUlZJU09SX2RvbTBfb3AoJm9wKTsKKwkJYnJlYWs7CisJY2FzZSBI
T1RQTFVHX1RZUEVfUkVNT1ZFOgorCQlwcmludGsoS0VSTl9XQVJOSU5HICJYZW4gbm90IHN1cHBv
cnQgQ1BVIGhvdHJlbW92ZVxuIik7CisJCXJldCA9IC1FTk9TWVM7CisJCWJyZWFrOworCX0KKwor
CXJldHVybiByZXQ7Cit9CisjZWxzZQorc3RhdGljIGludCB4ZW5fY3B1X2hvdHBsdWdfbm90aWZp
ZXIoc3RydWN0IGFjcGlfcHJvY2Vzc29yICpwciwgaW50IGV2ZW50KQoreworCXJldHVybiAtRU5P
U1lTOworfQorI2VuZGlmCisKIHN0YXRpYyBpbnQgX19pbml0IHhlbl9hY3BpX3Byb2Nlc3Nvcl9l
eHRjbnRsX2luaXQodm9pZCkKIHsKIAl1bnNpZ25lZCBpbnQgcG1iaXRzOwpkaWZmIC0tZ2l0IGEv
aW5jbHVkZS94ZW4vaW50ZXJmYWNlL3BsYXRmb3JtLmggYi9pbmNsdWRlL3hlbi9pbnRlcmZhY2Uv
cGxhdGZvcm0uaAppbmRleCA0N2ZmZTE2Li45ZmQ2YjA3IDEwMDY0NAotLS0gYS9pbmNsdWRlL3hl
bi9pbnRlcmZhY2UvcGxhdGZvcm0uaAorKysgYi9pbmNsdWRlL3hlbi9pbnRlcmZhY2UvcGxhdGZv
cm0uaApAQCAtMzE3LDExICszMTcsMTggQEAgREVGSU5FX0dVRVNUX0hBTkRMRV9TVFJVQ1QoeGVu
cGZfcGNwdWluZm9fdCk7CiAjZGVmaW5lIFhFTlBGX2NwdV9vbmxpbmUgICAgNTYKICNkZWZpbmUg
WEVOUEZfY3B1X29mZmxpbmUgICA1Nwogc3RydWN0IHhlbnBmX2NwdV9vbCB7Ci0gICAgdWludDMy
X3QgY3B1aWQ7CisJdWludDMyX3QgY3B1aWQ7CiB9OwogdHlwZWRlZiBzdHJ1Y3QgeGVucGZfY3B1
X29sIHhlbnBmX2NwdV9vbF90OwogREVGSU5FX0dVRVNUX0hBTkRMRV9TVFJVQ1QoeGVucGZfY3B1
X29sX3QpOwogCisjZGVmaW5lIFhFTlBGX2NwdV9ob3RhZGQgICAgNTgKK3N0cnVjdCB4ZW5wZl9j
cHVfaG90YWRkIHsKKwl1aW50MzJfdCBhcGljX2lkOworCXVpbnQzMl90IGFjcGlfaWQ7CisJdWlu
dDMyX3QgcHhtOworfTsKKwogc3RydWN0IHhlbl9wbGF0Zm9ybV9vcCB7CiAJdWludDMyX3QgY21k
OwogCXVpbnQzMl90IGludGVyZmFjZV92ZXJzaW9uOyAvKiBYRU5QRl9JTlRFUkZBQ0VfVkVSU0lP
TiAqLwpAQCAtMzM5LDYgKzM0Niw3IEBAIHN0cnVjdCB4ZW5fcGxhdGZvcm1fb3AgewogCQlzdHJ1
Y3QgeGVucGZfc2V0X3Byb2Nlc3Nvcl9wbWluZm8gc2V0X3BtaW5mbzsKIAkJc3RydWN0IHhlbnBm
X3BjcHVpbmZvICAgICAgICAgIHBjcHVfaW5mbzsKIAkJc3RydWN0IHhlbnBmX2NwdV9vbCAgICAg
ICAgICAgIGNwdV9vbDsKKwkJc3RydWN0IHhlbnBmX2NwdV9ob3RhZGQgICAgICAgIGNwdV9hZGQ7
CiAJCXVpbnQ4X3QgICAgICAgICAgICAgICAgICAgICAgICBwYWRbMTI4XTsKIAl9IHU7CiB9Owot
LSAKMS42LjUuNgoK

--_002_DE8DF0795D48FD4CA783C40EC829233596DCSHSMSX101ccrcorpint_--
