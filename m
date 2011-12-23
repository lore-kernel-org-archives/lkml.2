Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756656Ab1LWKa5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Dec 2011 05:30:57 -0500
Received: from mga11.intel.com ([192.55.52.93]:34099 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756610Ab1LWKaw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Dec 2011 05:30:52 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208,223";a="99639593"
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
Subject: [PATCH 09/10] xen/acpi: Change Cx notify and add PPC handle
Thread-Topic: [PATCH 09/10] xen/acpi: Change Cx notify and add PPC handle
Thread-Index: AczBXe8v+3aspNmsQx2YiaRIU03xuw==
Date: Fri, 23 Dec 2011 10:30:48 +0000
Message-ID: <DE8DF0795D48FD4CA783C40EC82923359737@SHSMSX101.ccr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: multipart/mixed;
	boundary="_002_DE8DF0795D48FD4CA783C40EC82923359737SHSMSX101ccrcorpint_"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--_002_DE8DF0795D48FD4CA783C40EC82923359737SHSMSX101ccrcorpint_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

>From ca403566e922dde51e8809d7489337be4a55adfc Mon Sep 17 00:00:00 2001
From: Liu Jinsong <jinsong.liu@intel.com>
Date: Wed, 14 Dec 2011 15:59:02 +0800
Subject: [PATCH 09/10] xen/acpi: Change Cx notify and add PPC handle

This patch update Xen Cx notify.
Current Cx notify has 2 potential trigger points w/ some logically redundan=
t.
We remove the Cx notify point which is outside __xen_acpi_processor_add,
merging its logic to the Cx notify point inside __xen_acpi_processor_add.
This would more clean, as what native Cx did.

This patch also add Xen PPC handle when cpu hotadd.

Signed-off-by: Liu, Jinsong <jinsong.liu@intel.com>
---
 drivers/acpi/processor_xen.c |  103 +++++++++++++++++++++++---------------=
----
 1 files changed, 57 insertions(+), 46 deletions(-)

diff --git a/drivers/acpi/processor_xen.c b/drivers/acpi/processor_xen.c
index 3af1f73..083e2b1 100644
--- a/drivers/acpi/processor_xen.c
+++ b/drivers/acpi/processor_xen.c
@@ -283,6 +283,59 @@ static int xen_acpi_processor_get_info(struct acpi_dev=
ice *device)
 	return 0;
 }
=20
+static int xen_acpi_processor_get_platform_limit(struct acpi_processor *pr=
)
+{
+        acpi_status status =3D 0;
+        unsigned long long ppc =3D 0;
+
+        if (!pr)
+                return -EINVAL;
+
+        /*
+         * _PPC indicates the maximum state currently supported by the pla=
tform
+         * (e.g. 0 =3D states 0..n; 1 =3D states 1..n; etc.
+         */
+        status =3D acpi_evaluate_integer(pr->handle, "_PPC", NULL, &ppc);
+
+        if (ACPI_FAILURE(status) && status !=3D AE_NOT_FOUND) {
+                ACPI_EXCEPTION((AE_INFO, status, "Evaluating _PPC"));
+                return -ENODEV;
+        }
+
+        pr->performance_platform_limit =3D (int)ppc;
+
+        return 0;
+}
+
+static int xen_acpi_processor_ppc_has_changed(struct acpi_processor *pr)
+{
+	int ret;
+
+	ret =3D xen_acpi_processor_get_platform_limit(pr);
+
+	if (ret < 0)
+		return ret;
+	else
+		return processor_cntl_xen_notify(pr,
+			PROCESSOR_PM_CHANGE, PM_TYPE_PERF);
+}
+
+static void __cpuinit xen_acpi_processor_power_init(struct acpi_processor =
*pr,
+			      struct acpi_device *device)
+{
+	if (likely(!pr->flags.power_setup_done)) {
+		/* reset idle boot option which we don't care */
+		boot_option_idle_override =3D IDLE_NO_OVERRIDE;
+		acpi_processor_power_init(pr, device);
+		/* set to IDLE_HALT for trapping into Xen */
+		boot_option_idle_override =3D IDLE_HALT;
+
+		if (pr->flags.power)
+			processor_cntl_xen_notify(pr,
+					PROCESSOR_PM_INIT, PM_TYPE_IDLE);
+	}
+}
+
 static int __cpuinit __xen_acpi_processor_add(struct acpi_device *device)
 {
 	struct acpi_processor *pr =3D NULL;
@@ -339,14 +392,12 @@ static int __cpuinit __xen_acpi_processor_add(struct =
acpi_device *device)
 	}
=20
 #ifdef CONFIG_CPU_FREQ
-	acpi_processor_ppc_has_changed(pr, 0);
+	xen_acpi_processor_ppc_has_changed(pr);
 #endif
 	acpi_processor_get_throttling_info(pr);
 	acpi_processor_get_limit_info(pr);
=20
-
-	if (cpuidle_get_driver() =3D=3D &acpi_idle_driver)
-		acpi_processor_power_init(pr, device);
+	xen_acpi_processor_power_init(pr, device);
=20
 	pr->cdev =3D thermal_cooling_device_register("Processor", device,
 						&processor_cooling_ops);
@@ -400,48 +451,8 @@ static int __cpuinit xen_acpi_processor_add(struct acp=
i_device *device)
 	if (!pr)
 		return -EINVAL;
=20
-	if (pr->id =3D=3D -1) {
-		int device_declaration;
-		int apic_id =3D -1;
-
-		if (!strcmp(acpi_device_hid(device), ACPI_PROCESSOR_OBJECT_HID))
-			device_declaration =3D 0;
-		else
-			device_declaration =3D 1;
-
-		apic_id =3D acpi_get_cpuid(pr->handle,
-			device_declaration, pr->acpi_id);
-		if (apic_id =3D=3D -1) {
-			/* Processor is not present in MADT table */
-			return 0;
-		}
-
-		/*
-		 * It's possible to have pr->id as '-1' even when it's actually
-		 * present in MADT table, e.g. due to limiting dom0 max vcpus
-		 * less than physical present number. In such case we still want
-		 * to parse ACPI processor object information, so mimic the
-		 * pr->id to CPU-0. This should be safe because we only care
-		 * about raw ACPI information, which only relies on pr->acpi_id.
-		 * For other information relying on pr->id and gathered through
-		 * SMP function call, it's safe to let them run on CPU-0 since
-		 * underlying Xen will collect them. Only a valid pr->id can
-		 * make later invocations forward progress.
-		 */
-		pr->id =3D 0;
-	}
-
-	if (likely(!pr->flags.power_setup_done)) {
-		/* reset idle boot option which we don't care */
-		boot_option_idle_override =3D IDLE_NO_OVERRIDE;
-		acpi_processor_power_init(pr, device);
-		/* set to IDLE_HALT for trapping into Xen */
-		boot_option_idle_override =3D IDLE_HALT;
-
-		if (pr->flags.power)
-			processor_cntl_xen_notify(pr,
-					PROCESSOR_PM_INIT, PM_TYPE_IDLE);
-	}
+	if (pr->id =3D=3D -1)
+		return 0;
=20
 #ifdef CONFIG_CPU_FREQ
 	if (likely(!pr->performance))
--=20
1.6.5.6

--_002_DE8DF0795D48FD4CA783C40EC82923359737SHSMSX101ccrcorpint_
Content-Type: application/octet-stream;
	name="0009-xen-acpi-Change-Cx-notify-and-add-PPC-handle.patch"
Content-Description: 0009-xen-acpi-Change-Cx-notify-and-add-PPC-handle.patch
Content-Disposition: attachment;
	filename="0009-xen-acpi-Change-Cx-notify-and-add-PPC-handle.patch";
	size=4832; creation-date="Wed, 14 Dec 2011 15:20:15 GMT";
	modification-date="Wed, 14 Dec 2011 15:03:34 GMT"
Content-Transfer-Encoding: base64

RnJvbSBjYTQwMzU2NmU5MjJkZGU1MWU4ODA5ZDc0ODkzMzdiZTRhNTVhZGZjIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBMaXUgSmluc29uZyA8amluc29uZy5saXVAaW50ZWwuY29tPgpE
YXRlOiBXZWQsIDE0IERlYyAyMDExIDE1OjU5OjAyICswODAwClN1YmplY3Q6IFtQQVRDSCAwOS8x
MF0geGVuL2FjcGk6IENoYW5nZSBDeCBub3RpZnkgYW5kIGFkZCBQUEMgaGFuZGxlCgpUaGlzIHBh
dGNoIHVwZGF0ZSBYZW4gQ3ggbm90aWZ5LgpDdXJyZW50IEN4IG5vdGlmeSBoYXMgMiBwb3RlbnRp
YWwgdHJpZ2dlciBwb2ludHMgdy8gc29tZSBsb2dpY2FsbHkgcmVkdW5kYW50LgpXZSByZW1vdmUg
dGhlIEN4IG5vdGlmeSBwb2ludCB3aGljaCBpcyBvdXRzaWRlIF9feGVuX2FjcGlfcHJvY2Vzc29y
X2FkZCwKbWVyZ2luZyBpdHMgbG9naWMgdG8gdGhlIEN4IG5vdGlmeSBwb2ludCBpbnNpZGUgX194
ZW5fYWNwaV9wcm9jZXNzb3JfYWRkLgpUaGlzIHdvdWxkIG1vcmUgY2xlYW4sIGFzIHdoYXQgbmF0
aXZlIEN4IGRpZC4KClRoaXMgcGF0Y2ggYWxzbyBhZGQgWGVuIFBQQyBoYW5kbGUgd2hlbiBjcHUg
aG90YWRkLgoKU2lnbmVkLW9mZi1ieTogTGl1LCBKaW5zb25nIDxqaW5zb25nLmxpdUBpbnRlbC5j
b20+Ci0tLQogZHJpdmVycy9hY3BpL3Byb2Nlc3Nvcl94ZW4uYyB8ICAxMDMgKysrKysrKysrKysr
KysrKysrKysrKystLS0tLS0tLS0tLS0tLS0tLS0tCiAxIGZpbGVzIGNoYW5nZWQsIDU3IGluc2Vy
dGlvbnMoKyksIDQ2IGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2RyaXZlcnMvYWNwaS9wcm9j
ZXNzb3JfeGVuLmMgYi9kcml2ZXJzL2FjcGkvcHJvY2Vzc29yX3hlbi5jCmluZGV4IDNhZjFmNzMu
LjA4M2UyYjEgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvYWNwaS9wcm9jZXNzb3JfeGVuLmMKKysrIGIv
ZHJpdmVycy9hY3BpL3Byb2Nlc3Nvcl94ZW4uYwpAQCAtMjgzLDYgKzI4Myw1OSBAQCBzdGF0aWMg
aW50IHhlbl9hY3BpX3Byb2Nlc3Nvcl9nZXRfaW5mbyhzdHJ1Y3QgYWNwaV9kZXZpY2UgKmRldmlj
ZSkKIAlyZXR1cm4gMDsKIH0KIAorc3RhdGljIGludCB4ZW5fYWNwaV9wcm9jZXNzb3JfZ2V0X3Bs
YXRmb3JtX2xpbWl0KHN0cnVjdCBhY3BpX3Byb2Nlc3NvciAqcHIpCit7CisgICAgICAgIGFjcGlf
c3RhdHVzIHN0YXR1cyA9IDA7CisgICAgICAgIHVuc2lnbmVkIGxvbmcgbG9uZyBwcGMgPSAwOwor
CisgICAgICAgIGlmICghcHIpCisgICAgICAgICAgICAgICAgcmV0dXJuIC1FSU5WQUw7CisKKyAg
ICAgICAgLyoKKyAgICAgICAgICogX1BQQyBpbmRpY2F0ZXMgdGhlIG1heGltdW0gc3RhdGUgY3Vy
cmVudGx5IHN1cHBvcnRlZCBieSB0aGUgcGxhdGZvcm0KKyAgICAgICAgICogKGUuZy4gMCA9IHN0
YXRlcyAwLi5uOyAxID0gc3RhdGVzIDEuLm47IGV0Yy4KKyAgICAgICAgICovCisgICAgICAgIHN0
YXR1cyA9IGFjcGlfZXZhbHVhdGVfaW50ZWdlcihwci0+aGFuZGxlLCAiX1BQQyIsIE5VTEwsICZw
cGMpOworCisgICAgICAgIGlmIChBQ1BJX0ZBSUxVUkUoc3RhdHVzKSAmJiBzdGF0dXMgIT0gQUVf
Tk9UX0ZPVU5EKSB7CisgICAgICAgICAgICAgICAgQUNQSV9FWENFUFRJT04oKEFFX0lORk8sIHN0
YXR1cywgIkV2YWx1YXRpbmcgX1BQQyIpKTsKKyAgICAgICAgICAgICAgICByZXR1cm4gLUVOT0RF
VjsKKyAgICAgICAgfQorCisgICAgICAgIHByLT5wZXJmb3JtYW5jZV9wbGF0Zm9ybV9saW1pdCA9
IChpbnQpcHBjOworCisgICAgICAgIHJldHVybiAwOworfQorCitzdGF0aWMgaW50IHhlbl9hY3Bp
X3Byb2Nlc3Nvcl9wcGNfaGFzX2NoYW5nZWQoc3RydWN0IGFjcGlfcHJvY2Vzc29yICpwcikKK3sK
KwlpbnQgcmV0OworCisJcmV0ID0geGVuX2FjcGlfcHJvY2Vzc29yX2dldF9wbGF0Zm9ybV9saW1p
dChwcik7CisKKwlpZiAocmV0IDwgMCkKKwkJcmV0dXJuIHJldDsKKwllbHNlCisJCXJldHVybiBw
cm9jZXNzb3JfY250bF94ZW5fbm90aWZ5KHByLAorCQkJUFJPQ0VTU09SX1BNX0NIQU5HRSwgUE1f
VFlQRV9QRVJGKTsKK30KKworc3RhdGljIHZvaWQgX19jcHVpbml0IHhlbl9hY3BpX3Byb2Nlc3Nv
cl9wb3dlcl9pbml0KHN0cnVjdCBhY3BpX3Byb2Nlc3NvciAqcHIsCisJCQkgICAgICBzdHJ1Y3Qg
YWNwaV9kZXZpY2UgKmRldmljZSkKK3sKKwlpZiAobGlrZWx5KCFwci0+ZmxhZ3MucG93ZXJfc2V0
dXBfZG9uZSkpIHsKKwkJLyogcmVzZXQgaWRsZSBib290IG9wdGlvbiB3aGljaCB3ZSBkb24ndCBj
YXJlICovCisJCWJvb3Rfb3B0aW9uX2lkbGVfb3ZlcnJpZGUgPSBJRExFX05PX09WRVJSSURFOwor
CQlhY3BpX3Byb2Nlc3Nvcl9wb3dlcl9pbml0KHByLCBkZXZpY2UpOworCQkvKiBzZXQgdG8gSURM
RV9IQUxUIGZvciB0cmFwcGluZyBpbnRvIFhlbiAqLworCQlib290X29wdGlvbl9pZGxlX292ZXJy
aWRlID0gSURMRV9IQUxUOworCisJCWlmIChwci0+ZmxhZ3MucG93ZXIpCisJCQlwcm9jZXNzb3Jf
Y250bF94ZW5fbm90aWZ5KHByLAorCQkJCQlQUk9DRVNTT1JfUE1fSU5JVCwgUE1fVFlQRV9JRExF
KTsKKwl9Cit9CisKIHN0YXRpYyBpbnQgX19jcHVpbml0IF9feGVuX2FjcGlfcHJvY2Vzc29yX2Fk
ZChzdHJ1Y3QgYWNwaV9kZXZpY2UgKmRldmljZSkKIHsKIAlzdHJ1Y3QgYWNwaV9wcm9jZXNzb3Ig
KnByID0gTlVMTDsKQEAgLTMzOSwxNCArMzkyLDEyIEBAIHN0YXRpYyBpbnQgX19jcHVpbml0IF9f
eGVuX2FjcGlfcHJvY2Vzc29yX2FkZChzdHJ1Y3QgYWNwaV9kZXZpY2UgKmRldmljZSkKIAl9CiAK
ICNpZmRlZiBDT05GSUdfQ1BVX0ZSRVEKLQlhY3BpX3Byb2Nlc3Nvcl9wcGNfaGFzX2NoYW5nZWQo
cHIsIDApOworCXhlbl9hY3BpX3Byb2Nlc3Nvcl9wcGNfaGFzX2NoYW5nZWQocHIpOwogI2VuZGlm
CiAJYWNwaV9wcm9jZXNzb3JfZ2V0X3Rocm90dGxpbmdfaW5mbyhwcik7CiAJYWNwaV9wcm9jZXNz
b3JfZ2V0X2xpbWl0X2luZm8ocHIpOwogCi0KLQlpZiAoY3B1aWRsZV9nZXRfZHJpdmVyKCkgPT0g
JmFjcGlfaWRsZV9kcml2ZXIpCi0JCWFjcGlfcHJvY2Vzc29yX3Bvd2VyX2luaXQocHIsIGRldmlj
ZSk7CisJeGVuX2FjcGlfcHJvY2Vzc29yX3Bvd2VyX2luaXQocHIsIGRldmljZSk7CiAKIAlwci0+
Y2RldiA9IHRoZXJtYWxfY29vbGluZ19kZXZpY2VfcmVnaXN0ZXIoIlByb2Nlc3NvciIsIGRldmlj
ZSwKIAkJCQkJCSZwcm9jZXNzb3JfY29vbGluZ19vcHMpOwpAQCAtNDAwLDQ4ICs0NTEsOCBAQCBz
dGF0aWMgaW50IF9fY3B1aW5pdCB4ZW5fYWNwaV9wcm9jZXNzb3JfYWRkKHN0cnVjdCBhY3BpX2Rl
dmljZSAqZGV2aWNlKQogCWlmICghcHIpCiAJCXJldHVybiAtRUlOVkFMOwogCi0JaWYgKHByLT5p
ZCA9PSAtMSkgewotCQlpbnQgZGV2aWNlX2RlY2xhcmF0aW9uOwotCQlpbnQgYXBpY19pZCA9IC0x
OwotCi0JCWlmICghc3RyY21wKGFjcGlfZGV2aWNlX2hpZChkZXZpY2UpLCBBQ1BJX1BST0NFU1NP
Ul9PQkpFQ1RfSElEKSkKLQkJCWRldmljZV9kZWNsYXJhdGlvbiA9IDA7Ci0JCWVsc2UKLQkJCWRl
dmljZV9kZWNsYXJhdGlvbiA9IDE7Ci0KLQkJYXBpY19pZCA9IGFjcGlfZ2V0X2NwdWlkKHByLT5o
YW5kbGUsCi0JCQlkZXZpY2VfZGVjbGFyYXRpb24sIHByLT5hY3BpX2lkKTsKLQkJaWYgKGFwaWNf
aWQgPT0gLTEpIHsKLQkJCS8qIFByb2Nlc3NvciBpcyBub3QgcHJlc2VudCBpbiBNQURUIHRhYmxl
ICovCi0JCQlyZXR1cm4gMDsKLQkJfQotCi0JCS8qCi0JCSAqIEl0J3MgcG9zc2libGUgdG8gaGF2
ZSBwci0+aWQgYXMgJy0xJyBldmVuIHdoZW4gaXQncyBhY3R1YWxseQotCQkgKiBwcmVzZW50IGlu
IE1BRFQgdGFibGUsIGUuZy4gZHVlIHRvIGxpbWl0aW5nIGRvbTAgbWF4IHZjcHVzCi0JCSAqIGxl
c3MgdGhhbiBwaHlzaWNhbCBwcmVzZW50IG51bWJlci4gSW4gc3VjaCBjYXNlIHdlIHN0aWxsIHdh
bnQKLQkJICogdG8gcGFyc2UgQUNQSSBwcm9jZXNzb3Igb2JqZWN0IGluZm9ybWF0aW9uLCBzbyBt
aW1pYyB0aGUKLQkJICogcHItPmlkIHRvIENQVS0wLiBUaGlzIHNob3VsZCBiZSBzYWZlIGJlY2F1
c2Ugd2Ugb25seSBjYXJlCi0JCSAqIGFib3V0IHJhdyBBQ1BJIGluZm9ybWF0aW9uLCB3aGljaCBv
bmx5IHJlbGllcyBvbiBwci0+YWNwaV9pZC4KLQkJICogRm9yIG90aGVyIGluZm9ybWF0aW9uIHJl
bHlpbmcgb24gcHItPmlkIGFuZCBnYXRoZXJlZCB0aHJvdWdoCi0JCSAqIFNNUCBmdW5jdGlvbiBj
YWxsLCBpdCdzIHNhZmUgdG8gbGV0IHRoZW0gcnVuIG9uIENQVS0wIHNpbmNlCi0JCSAqIHVuZGVy
bHlpbmcgWGVuIHdpbGwgY29sbGVjdCB0aGVtLiBPbmx5IGEgdmFsaWQgcHItPmlkIGNhbgotCQkg
KiBtYWtlIGxhdGVyIGludm9jYXRpb25zIGZvcndhcmQgcHJvZ3Jlc3MuCi0JCSAqLwotCQlwci0+
aWQgPSAwOwotCX0KLQotCWlmIChsaWtlbHkoIXByLT5mbGFncy5wb3dlcl9zZXR1cF9kb25lKSkg
ewotCQkvKiByZXNldCBpZGxlIGJvb3Qgb3B0aW9uIHdoaWNoIHdlIGRvbid0IGNhcmUgKi8KLQkJ
Ym9vdF9vcHRpb25faWRsZV9vdmVycmlkZSA9IElETEVfTk9fT1ZFUlJJREU7Ci0JCWFjcGlfcHJv
Y2Vzc29yX3Bvd2VyX2luaXQocHIsIGRldmljZSk7Ci0JCS8qIHNldCB0byBJRExFX0hBTFQgZm9y
IHRyYXBwaW5nIGludG8gWGVuICovCi0JCWJvb3Rfb3B0aW9uX2lkbGVfb3ZlcnJpZGUgPSBJRExF
X0hBTFQ7Ci0KLQkJaWYgKHByLT5mbGFncy5wb3dlcikKLQkJCXByb2Nlc3Nvcl9jbnRsX3hlbl9u
b3RpZnkocHIsCi0JCQkJCVBST0NFU1NPUl9QTV9JTklULCBQTV9UWVBFX0lETEUpOwotCX0KKwlp
ZiAocHItPmlkID09IC0xKQorCQlyZXR1cm4gMDsKIAogI2lmZGVmIENPTkZJR19DUFVfRlJFUQog
CWlmIChsaWtlbHkoIXByLT5wZXJmb3JtYW5jZSkpCi0tIAoxLjYuNS42Cgo=

--_002_DE8DF0795D48FD4CA783C40EC82923359737SHSMSX101ccrcorpint_--
