Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753262Ab2KAGjN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 02:39:13 -0400
Received: from mga02.intel.com ([134.134.136.20]:4379 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752608Ab2KAGjM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 02:39:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,691,1344236400"; 
   d="scan'208,223";a="235568496"
From: "Liu, Jinsong" <jinsong.liu@intel.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>
Subject: RE: [PATCH 2/2] Revert pad config check in xen_check_mwait
Thread-Topic: [PATCH 2/2] Revert pad config check in xen_check_mwait
Thread-Index: Ac2yq1FN1e+6ZP87QOCrcigNApJpmAFT/F+A
Date: Thu, 1 Nov 2012 06:38:41 +0000
Message-ID: <DE8DF0795D48FD4CA783C40EC829233537735C@SHSMSX101.ccr.corp.intel.com>
References: <DE8DF0795D48FD4CA783C40EC8292335371593@SHSMSX101.ccr.corp.intel.com>
In-Reply-To: <DE8DF0795D48FD4CA783C40EC8292335371593@SHSMSX101.ccr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: multipart/mixed;
	boundary="_002_DE8DF0795D48FD4CA783C40EC829233537735CSHSMSX101ccrcorpi_"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--_002_DE8DF0795D48FD4CA783C40EC829233537735CSHSMSX101ccrcorpi_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Updated, adding version check at mwait routine.

Thanks,
Jinsong

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>From 27e28963d4d25e4c998b5b5ea3828a02e6de9470 Mon Sep 17 00:00:00 2001
From: Liu, Jinsong <jinsong.liu@intel.com>
Date: Thu, 1 Nov 2012 21:18:43 +0800
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
 arch/x86/xen/enlighten.c |   14 ++++++++++++--
 1 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index 586d838..9e22e41 100644
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
@@ -297,6 +296,10 @@ static bool __init xen_check_mwait(void)
 	uint32_t buf[3];
 	unsigned int ax, bx, cx, dx;
 	unsigned int mwait_mask;
+	unsigned int version =3D HYPERVISOR_xen_version(XENVER_version, NULL);
+	unsigned int major =3D version >> 16;
+	unsigned int minor =3D version & 0xffff;
+
=20
 	/* We need to determine whether it is OK to expose the MWAIT
 	 * capability to the kernel to harvest deeper than C3 states from ACPI
@@ -309,6 +312,13 @@ static bool __init xen_check_mwait(void)
 	if (!xen_initial_domain())
 		return false;
=20
+	/*
+	 * When running under platform earlier than Xen4.2, do not expose
+	 * mwait, to avoid the risk of loading native acpi pad driver
+	 */
+	if (((major =3D=3D 4) && (minor < 2)) || (major < 4))
+		return false;
+
 	ax =3D 1;
 	cx =3D 0;
=20
--=20
1.7.1

--_002_DE8DF0795D48FD4CA783C40EC829233537735CSHSMSX101ccrcorpi_
Content-Type: application/octet-stream;
	name="0002-Revert-pad-config-check-in-xen_check_mwait.patch"
Content-Description: 0002-Revert-pad-config-check-in-xen_check_mwait.patch
Content-Disposition: attachment;
	filename="0002-Revert-pad-config-check-in-xen_check_mwait.patch"; size=2139;
	creation-date="Thu, 01 Nov 2012 06:25:57 GMT";
	modification-date="Thu, 01 Nov 2012 13:29:12 GMT"
Content-Transfer-Encoding: base64

RnJvbSAyN2UyODk2M2Q0ZDI1ZTRjOTk4YjViNWVhMzgyOGEwMmU2ZGU5NDcwIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBMaXUsIEppbnNvbmcgPGppbnNvbmcubGl1QGludGVsLmNvbT4K
RGF0ZTogVGh1LCAxIE5vdiAyMDEyIDIxOjE4OjQzICswODAwClN1YmplY3Q6IFtQQVRDSCAyLzJd
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
aWdodGVuLmMgfCAgIDE0ICsrKysrKysrKysrKy0tCiAxIGZpbGVzIGNoYW5nZWQsIDEyIGluc2Vy
dGlvbnMoKyksIDIgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvYXJjaC94ODYveGVuL2VubGln
aHRlbi5jIGIvYXJjaC94ODYveGVuL2VubGlnaHRlbi5jCmluZGV4IDU4NmQ4MzguLjllMjJlNDEg
MTAwNjQ0Ci0tLSBhL2FyY2gveDg2L3hlbi9lbmxpZ2h0ZW4uYworKysgYi9hcmNoL3g4Ni94ZW4v
ZW5saWdodGVuLmMKQEAgLTI4Nyw4ICsyODcsNyBAQCBzdGF0aWMgdm9pZCB4ZW5fY3B1aWQodW5z
aWduZWQgaW50ICpheCwgdW5zaWduZWQgaW50ICpieCwKIAogc3RhdGljIGJvb2wgX19pbml0IHhl
bl9jaGVja19td2FpdCh2b2lkKQogewotI2lmIGRlZmluZWQoQ09ORklHX0FDUEkpICYmICFkZWZp
bmVkKENPTkZJR19BQ1BJX1BST0NFU1NPUl9BR0dSRUdBVE9SKSAmJiBcCi0JIWRlZmluZWQoQ09O
RklHX0FDUElfUFJPQ0VTU09SX0FHR1JFR0FUT1JfTU9EVUxFKQorI2lmZGVmIENPTkZJR19BQ1BJ
CiAJc3RydWN0IHhlbl9wbGF0Zm9ybV9vcCBvcCA9IHsKIAkJLmNtZAkJCT0gWEVOUEZfc2V0X3By
b2Nlc3Nvcl9wbWluZm8sCiAJCS51LnNldF9wbWluZm8uaWQJPSAtMSwKQEAgLTI5Nyw2ICsyOTYs
MTAgQEAgc3RhdGljIGJvb2wgX19pbml0IHhlbl9jaGVja19td2FpdCh2b2lkKQogCXVpbnQzMl90
IGJ1ZlszXTsKIAl1bnNpZ25lZCBpbnQgYXgsIGJ4LCBjeCwgZHg7CiAJdW5zaWduZWQgaW50IG13
YWl0X21hc2s7CisJdW5zaWduZWQgaW50IHZlcnNpb24gPSBIWVBFUlZJU09SX3hlbl92ZXJzaW9u
KFhFTlZFUl92ZXJzaW9uLCBOVUxMKTsKKwl1bnNpZ25lZCBpbnQgbWFqb3IgPSB2ZXJzaW9uID4+
IDE2OworCXVuc2lnbmVkIGludCBtaW5vciA9IHZlcnNpb24gJiAweGZmZmY7CisKIAogCS8qIFdl
IG5lZWQgdG8gZGV0ZXJtaW5lIHdoZXRoZXIgaXQgaXMgT0sgdG8gZXhwb3NlIHRoZSBNV0FJVAog
CSAqIGNhcGFiaWxpdHkgdG8gdGhlIGtlcm5lbCB0byBoYXJ2ZXN0IGRlZXBlciB0aGFuIEMzIHN0
YXRlcyBmcm9tIEFDUEkKQEAgLTMwOSw2ICszMTIsMTMgQEAgc3RhdGljIGJvb2wgX19pbml0IHhl
bl9jaGVja19td2FpdCh2b2lkKQogCWlmICgheGVuX2luaXRpYWxfZG9tYWluKCkpCiAJCXJldHVy
biBmYWxzZTsKIAorCS8qCisJICogV2hlbiBydW5uaW5nIHVuZGVyIHBsYXRmb3JtIGVhcmxpZXIg
dGhhbiBYZW40LjIsIGRvIG5vdCBleHBvc2UKKwkgKiBtd2FpdCwgdG8gYXZvaWQgdGhlIHJpc2sg
b2YgbG9hZGluZyBuYXRpdmUgYWNwaSBwYWQgZHJpdmVyCisJICovCisJaWYgKCgobWFqb3IgPT0g
NCkgJiYgKG1pbm9yIDwgMikpIHx8IChtYWpvciA8IDQpKQorCQlyZXR1cm4gZmFsc2U7CisKIAlh
eCA9IDE7CiAJY3ggPSAwOwogCi0tIAoxLjcuMQoK

--_002_DE8DF0795D48FD4CA783C40EC829233537735CSHSMSX101ccrcorpi_--
