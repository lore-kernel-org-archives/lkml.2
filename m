Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755076Ab2KGNCR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 08:02:17 -0500
Received: from mga03.intel.com ([143.182.124.21]:19049 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755051Ab2KGNCO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 08:02:14 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,730,1344236400"; 
   d="scan'208,223";a="165488182"
From: "Liu, Jinsong" <jinsong.liu@intel.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>
Subject: RE: [PATCH 2/2] Revert pad config check in xen_check_mwait
Thread-Topic: [PATCH 2/2] Revert pad config check in xen_check_mwait
Thread-Index: Ac2yq1FN1e+6ZP87QOCrcigNApJpmAKPGhiQ
Date: Wed, 7 Nov 2012 13:02:05 +0000
Message-ID: <DE8DF0795D48FD4CA783C40EC829233537B9B8@SHSMSX101.ccr.corp.intel.com>
References: <DE8DF0795D48FD4CA783C40EC8292335371593@SHSMSX101.ccr.corp.intel.com>
In-Reply-To: <DE8DF0795D48FD4CA783C40EC8292335371593@SHSMSX101.ccr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: multipart/mixed;
	boundary="_002_DE8DF0795D48FD4CA783C40EC829233537B9B8SHSMSX101ccrcorpi_"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--_002_DE8DF0795D48FD4CA783C40EC829233537B9B8SHSMSX101ccrcorpi_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Add xen version check for xen_check_mwait.

Thanks,
Jinsong

=3D=3D=3D=3D=3D=3D=3D=3D=3D

>From b8288c4b8bce46468e5abbb95fae4c9c748bafaa Mon Sep 17 00:00:00 2001
From: Liu, Jinsong <jinsong.liu@intel.com>
Date: Thu, 8 Nov 2012 04:31:11 +0800
Subject: [PATCH 2/2] Revert pad config check in xen_check_mwait

With Xen acpi pad logic added into kernel, we can now revert xen mwait rela=
ted
patch df88b2d96e36d9a9e325bfcd12eb45671cbbc937. The reason is, when running=
 under
newer Xen platform, Xen pad driver would be early loaded, so native pad dri=
ver
would fail to be loaded, and hence no mwait/monitor #UD risk again.

Another point is, only Xen4.2 or later support Xen acpi pad, so we won't ex=
pose
mwait cpuid capability when running under older Xen platform.

Signed-off-by: Liu, Jinsong <jinsong.liu@intel.com>
---
 arch/x86/xen/enlighten.c |   10 ++++++++--
 1 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index 586d838..548296f 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -287,8 +287,7 @@ static void xen_cpuid(unsigned int *ax, unsigned int *b=
x,
=20
 static bool __init xen_check_mwait(void)
 {
-#if defined(CONFIG_ACPI) && !defined(CONFIG_ACPI_PROCESSOR_AGGREGATOR) && =
\
-	!defined(CONFIG_ACPI_PROCESSOR_AGGREGATOR_MODULE)
+#ifdef CONFIG_ACPI
 	struct xen_platform_op op =3D {
 		.cmd			=3D XENPF_set_processor_pminfo,
 		.u.set_pminfo.id	=3D -1,
@@ -309,6 +308,13 @@ static bool __init xen_check_mwait(void)
 	if (!xen_initial_domain())
 		return false;
=20
+	/*
+	 * When running under platform earlier than Xen4.2, do not expose
+	 * mwait, to avoid the risk of loading native acpi pad driver
+	 */
+	if (!xen_running_on_version_or_later(4, 2))
+		return false;
+
 	ax =3D 1;
 	cx =3D 0;
=20
--=20
1.7.1

--_002_DE8DF0795D48FD4CA783C40EC829233537B9B8SHSMSX101ccrcorpi_
Content-Type: application/octet-stream;
	name="0002-Revert-pad-config-check-in-xen_check_mwait.patch"
Content-Description: 0002-Revert-pad-config-check-in-xen_check_mwait.patch
Content-Disposition: attachment;
	filename="0002-Revert-pad-config-check-in-xen_check_mwait.patch"; size=1699;
	creation-date="Wed, 07 Nov 2012 12:49:11 GMT";
	modification-date="Wed, 07 Nov 2012 20:32:34 GMT"
Content-Transfer-Encoding: base64

RnJvbSBiODI4OGM0YjhiY2U0NjQ2OGU1YWJiYjk1ZmFlNGM5Yzc0OGJhZmFhIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBMaXUsIEppbnNvbmcgPGppbnNvbmcubGl1QGludGVsLmNvbT4K
RGF0ZTogVGh1LCA4IE5vdiAyMDEyIDA0OjMxOjExICswODAwClN1YmplY3Q6IFtQQVRDSCAyLzJd
IFJldmVydCBwYWQgY29uZmlnIGNoZWNrIGluIHhlbl9jaGVja19td2FpdAoKV2l0aCBYZW4gYWNw
aSBwYWQgbG9naWMgYWRkZWQgaW50byBrZXJuZWwsIHdlIGNhbiBub3cgcmV2ZXJ0IHhlbiBtd2Fp
dCByZWxhdGVkCnBhdGNoIGRmODhiMmQ5NmUzNmQ5YTllMzI1YmZjZDEyZWI0NTY3MWNiYmM5Mzcu
IFRoZSByZWFzb24gaXMsIHdoZW4gcnVubmluZyB1bmRlcgpuZXdlciBYZW4gcGxhdGZvcm0sIFhl
biBwYWQgZHJpdmVyIHdvdWxkIGJlIGVhcmx5IGxvYWRlZCwgc28gbmF0aXZlIHBhZCBkcml2ZXIK
d291bGQgZmFpbCB0byBiZSBsb2FkZWQsIGFuZCBoZW5jZSBubyBtd2FpdC9tb25pdG9yICNVRCBy
aXNrIGFnYWluLgoKQW5vdGhlciBwb2ludCBpcywgb25seSBYZW40LjIgb3IgbGF0ZXIgc3VwcG9y
dCBYZW4gYWNwaSBwYWQsIHNvIHdlIHdvbid0IGV4cG9zZQptd2FpdCBjcHVpZCBjYXBhYmlsaXR5
IHdoZW4gcnVubmluZyB1bmRlciBvbGRlciBYZW4gcGxhdGZvcm0uCgpTaWduZWQtb2ZmLWJ5OiBM
aXUsIEppbnNvbmcgPGppbnNvbmcubGl1QGludGVsLmNvbT4KLS0tCiBhcmNoL3g4Ni94ZW4vZW5s
aWdodGVuLmMgfCAgIDEwICsrKysrKysrLS0KIDEgZmlsZXMgY2hhbmdlZCwgOCBpbnNlcnRpb25z
KCspLCAyIGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2FyY2gveDg2L3hlbi9lbmxpZ2h0ZW4u
YyBiL2FyY2gveDg2L3hlbi9lbmxpZ2h0ZW4uYwppbmRleCA1ODZkODM4Li41NDgyOTZmIDEwMDY0
NAotLS0gYS9hcmNoL3g4Ni94ZW4vZW5saWdodGVuLmMKKysrIGIvYXJjaC94ODYveGVuL2VubGln
aHRlbi5jCkBAIC0yODcsOCArMjg3LDcgQEAgc3RhdGljIHZvaWQgeGVuX2NwdWlkKHVuc2lnbmVk
IGludCAqYXgsIHVuc2lnbmVkIGludCAqYngsCiAKIHN0YXRpYyBib29sIF9faW5pdCB4ZW5fY2hl
Y2tfbXdhaXQodm9pZCkKIHsKLSNpZiBkZWZpbmVkKENPTkZJR19BQ1BJKSAmJiAhZGVmaW5lZChD
T05GSUdfQUNQSV9QUk9DRVNTT1JfQUdHUkVHQVRPUikgJiYgXAotCSFkZWZpbmVkKENPTkZJR19B
Q1BJX1BST0NFU1NPUl9BR0dSRUdBVE9SX01PRFVMRSkKKyNpZmRlZiBDT05GSUdfQUNQSQogCXN0
cnVjdCB4ZW5fcGxhdGZvcm1fb3Agb3AgPSB7CiAJCS5jbWQJCQk9IFhFTlBGX3NldF9wcm9jZXNz
b3JfcG1pbmZvLAogCQkudS5zZXRfcG1pbmZvLmlkCT0gLTEsCkBAIC0zMDksNiArMzA4LDEzIEBA
IHN0YXRpYyBib29sIF9faW5pdCB4ZW5fY2hlY2tfbXdhaXQodm9pZCkKIAlpZiAoIXhlbl9pbml0
aWFsX2RvbWFpbigpKQogCQlyZXR1cm4gZmFsc2U7CiAKKwkvKgorCSAqIFdoZW4gcnVubmluZyB1
bmRlciBwbGF0Zm9ybSBlYXJsaWVyIHRoYW4gWGVuNC4yLCBkbyBub3QgZXhwb3NlCisJICogbXdh
aXQsIHRvIGF2b2lkIHRoZSByaXNrIG9mIGxvYWRpbmcgbmF0aXZlIGFjcGkgcGFkIGRyaXZlcgor
CSAqLworCWlmICgheGVuX3J1bm5pbmdfb25fdmVyc2lvbl9vcl9sYXRlcig0LCAyKSkKKwkJcmV0
dXJuIGZhbHNlOworCiAJYXggPSAxOwogCWN4ID0gMDsKIAotLSAKMS43LjEKCg==

--_002_DE8DF0795D48FD4CA783C40EC829233537B9B8SHSMSX101ccrcorpi_--
