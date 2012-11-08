Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753583Ab2KHFoc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 00:44:32 -0500
Received: from mga02.intel.com ([134.134.136.20]:33923 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752304Ab2KHFob (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 00:44:31 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,736,1344236400"; 
   d="scan'208,223";a="216653655"
From: "Liu, Jinsong" <jinsong.liu@intel.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Jan Beulich <jbeulich@suse.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>
Subject: [PATCH v2 2/2] Xen/acpi: revert pad config check in xen_check_mwait
Thread-Topic: [PATCH v2 2/2] Xen/acpi: revert pad config check in
 xen_check_mwait
Thread-Index: Ac29dB4WcWRk6UxxSqmLuVimXOjUhQ==
Date: Thu, 8 Nov 2012 05:44:28 +0000
Message-ID: <DE8DF0795D48FD4CA783C40EC829233537BF64@SHSMSX101.ccr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: multipart/mixed;
	boundary="_002_DE8DF0795D48FD4CA783C40EC829233537BF64SHSMSX101ccrcorpi_"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--_002_DE8DF0795D48FD4CA783C40EC829233537BF64SHSMSX101ccrcorpi_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

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

--_002_DE8DF0795D48FD4CA783C40EC829233537BF64SHSMSX101ccrcorpi_
Content-Type: application/octet-stream;
	name="0002-Xen-acpi-revert-pad-config-check-in-xen_check_mwait.patch"
Content-Description: 0002-Xen-acpi-revert-pad-config-check-in-xen_check_mwait.patch
Content-Disposition: attachment;
	filename="0002-Xen-acpi-revert-pad-config-check-in-xen_check_mwait.patch";
	size=1709; creation-date="Wed, 07 Nov 2012 17:23:53 GMT";
	modification-date="Thu, 08 Nov 2012 01:12:02 GMT"
Content-Transfer-Encoding: base64

RnJvbSBlODA0ZDU0N2JmZjBmN2NlMTA4ZTJiYjk1ODNmNjU3NzBkYzk3NDRiIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBMaXUsIEppbnNvbmcgPGppbnNvbmcubGl1QGludGVsLmNvbT4K
RGF0ZTogVGh1LCA4IE5vdiAyMDEyIDA5OjA5OjE5ICswODAwClN1YmplY3Q6IFtQQVRDSCAyLzJd
IFhlbi9hY3BpOiByZXZlcnQgcGFkIGNvbmZpZyBjaGVjayBpbiB4ZW5fY2hlY2tfbXdhaXQKCldp
dGggWGVuIGFjcGkgcGFkIGxvZ2ljIGFkZGVkIGludG8ga2VybmVsLCB3ZSBjYW4gbm93IHJldmVy
dCB4ZW4gbXdhaXQgcmVsYXRlZApwYXRjaCBkZjg4YjJkOTZlMzZkOWE5ZTMyNWJmY2QxMmViNDU2
NzFjYmJjOTM3LiBUaGUgcmVhc29uIGlzLCB3aGVuIHJ1bm5pbmcgdW5kZXIKbmV3ZXIgWGVuIHBs
YXRmb3JtLCBYZW4gcGFkIGRyaXZlciB3b3VsZCBiZSBlYXJseSBsb2FkZWQsIHNvIG5hdGl2ZSBw
YWQgZHJpdmVyCndvdWxkIGZhaWwgdG8gYmUgbG9hZGVkLCBhbmQgaGVuY2Ugbm8gbXdhaXQvbW9u
aXRvciAjVUQgcmlzayBhZ2Fpbi4KCkFub3RoZXIgcG9pbnQgaXMsIG9ubHkgWGVuNC4yIG9yIGxh
dGVyIHN1cHBvcnQgWGVuIGFjcGkgcGFkLCBzbyB3ZSB3b24ndCBleHBvc2UKbXdhaXQgY3B1aWQg
Y2FwYWJpbGl0eSB3aGVuIHJ1bm5pbmcgdW5kZXIgb2xkZXIgWGVuIHBsYXRmb3JtLgoKU2lnbmVk
LW9mZi1ieTogTGl1LCBKaW5zb25nIDxqaW5zb25nLmxpdUBpbnRlbC5jb20+Ci0tLQogYXJjaC94
ODYveGVuL2VubGlnaHRlbi5jIHwgICAxMCArKysrKysrKy0tCiAxIGZpbGVzIGNoYW5nZWQsIDgg
aW5zZXJ0aW9ucygrKSwgMiBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9hcmNoL3g4Ni94ZW4v
ZW5saWdodGVuLmMgYi9hcmNoL3g4Ni94ZW4vZW5saWdodGVuLmMKaW5kZXggNTg2ZDgzOC4uNTQ4
Mjk2ZiAxMDA2NDQKLS0tIGEvYXJjaC94ODYveGVuL2VubGlnaHRlbi5jCisrKyBiL2FyY2gveDg2
L3hlbi9lbmxpZ2h0ZW4uYwpAQCAtMjg3LDggKzI4Nyw3IEBAIHN0YXRpYyB2b2lkIHhlbl9jcHVp
ZCh1bnNpZ25lZCBpbnQgKmF4LCB1bnNpZ25lZCBpbnQgKmJ4LAogCiBzdGF0aWMgYm9vbCBfX2lu
aXQgeGVuX2NoZWNrX213YWl0KHZvaWQpCiB7Ci0jaWYgZGVmaW5lZChDT05GSUdfQUNQSSkgJiYg
IWRlZmluZWQoQ09ORklHX0FDUElfUFJPQ0VTU09SX0FHR1JFR0FUT1IpICYmIFwKLQkhZGVmaW5l
ZChDT05GSUdfQUNQSV9QUk9DRVNTT1JfQUdHUkVHQVRPUl9NT0RVTEUpCisjaWZkZWYgQ09ORklH
X0FDUEkKIAlzdHJ1Y3QgeGVuX3BsYXRmb3JtX29wIG9wID0gewogCQkuY21kCQkJPSBYRU5QRl9z
ZXRfcHJvY2Vzc29yX3BtaW5mbywKIAkJLnUuc2V0X3BtaW5mby5pZAk9IC0xLApAQCAtMzA5LDYg
KzMwOCwxMyBAQCBzdGF0aWMgYm9vbCBfX2luaXQgeGVuX2NoZWNrX213YWl0KHZvaWQpCiAJaWYg
KCF4ZW5faW5pdGlhbF9kb21haW4oKSkKIAkJcmV0dXJuIGZhbHNlOwogCisJLyoKKwkgKiBXaGVu
IHJ1bm5pbmcgdW5kZXIgcGxhdGZvcm0gZWFybGllciB0aGFuIFhlbjQuMiwgZG8gbm90IGV4cG9z
ZQorCSAqIG13YWl0LCB0byBhdm9pZCB0aGUgcmlzayBvZiBsb2FkaW5nIG5hdGl2ZSBhY3BpIHBh
ZCBkcml2ZXIKKwkgKi8KKwlpZiAoIXhlbl9ydW5uaW5nX29uX3ZlcnNpb25fb3JfbGF0ZXIoNCwg
MikpCisJCXJldHVybiBmYWxzZTsKKwogCWF4ID0gMTsKIAljeCA9IDA7CiAKLS0gCjEuNy4xCgo=

--_002_DE8DF0795D48FD4CA783C40EC829233537BF64SHSMSX101ccrcorpi_--
