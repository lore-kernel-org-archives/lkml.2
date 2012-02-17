Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752150Ab2BQJAq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 04:00:46 -0500
Received: from mga01.intel.com ([192.55.52.88]:18899 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751730Ab2BQJAp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 04:00:45 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="126616123"
From: "Liu, Jinsong" <jinsong.liu@intel.com>
To: Jan Beulich <JBeulich@suse.com>, "keir.xen@gmail.com" <keir.xen@gmail.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Kernel development list <linux-kernel@vger.kernel.org>
CC: "Li, Shaohua" <shaohua.li@intel.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [Patch 1/2] Xen core parking 1: hypercall
Thread-Topic: [Patch 1/2] Xen core parking 1: hypercall
Thread-Index: AcztUoOfr+N2rwJJRvakui4rZ0L2nQ==
Date: Fri, 17 Feb 2012 08:59:54 +0000
Message-ID: <DE8DF0795D48FD4CA783C40EC829233509D8A4@SHSMSX101.ccr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: multipart/mixed;
	boundary="_002_DE8DF0795D48FD4CA783C40EC829233509D8A4SHSMSX101ccrcorpi_"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--_002_DE8DF0795D48FD4CA783C40EC829233509D8A4SHSMSX101ccrcorpi_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Xen core parking 1: hypercall

This patch implement hypercall through which dom0 send core parking request=
, and get core parking result.
Due to the characteristic of continue_hypercall_on_cpu, dom0 seperately sen=
d/get core parking request/result.

Signed-off-by: Liu, Jinsong <jinsong.liu@intel.com>

diff -r 92e03310878f xen/arch/x86/platform_hypercall.c
--- a/xen/arch/x86/platform_hypercall.c	Wed Feb 08 21:05:52 2012 +0800
+++ b/xen/arch/x86/platform_hypercall.c	Mon Feb 13 11:33:16 2012 +0800
@@ -56,6 +56,10 @@
 long cpu_up_helper(void *data);
 long cpu_down_helper(void *data);
=20
+/* from core_parking.c */
+long core_parking_helper(void *data);
+uint32_t get_cur_idle_nums(void);
+
 ret_t do_platform_op(XEN_GUEST_HANDLE(xen_platform_op_t) u_xenpf_op)
 {
     ret_t ret =3D 0;
@@ -593,6 +597,32 @@
                       op->u.mem_add.epfn,
                       op->u.mem_add.pxm);
         break;
+
+    case XENPF_core_parking:
+    {
+        uint32_t idle_nums;
+
+        switch(op->u.core_parking.type)
+        {
+        case XEN_CORE_PARKING_SET:
+            idle_nums =3D min_t(uint32_t,
+                    op->u.core_parking.idle_nums, num_present_cpus() - 1);
+            ret =3D continue_hypercall_on_cpu(
+                    0, core_parking_helper, (void *)(unsigned long)idle_nu=
ms);
+            break;
+
+        case XEN_CORE_PARKING_GET:
+            op->u.core_parking.idle_nums =3D get_cur_idle_nums();
+            ret =3D copy_to_guest(u_xenpf_op, op, 1) ? -EFAULT : 0;
+            break;
+
+        default:
+            ret =3D -EINVAL;
+            break;
+        }
+    }
+    break;
+
     default:
         ret =3D -ENOSYS;
         break;
diff -r 92e03310878f xen/common/Makefile
--- a/xen/common/Makefile	Wed Feb 08 21:05:52 2012 +0800
+++ b/xen/common/Makefile	Mon Feb 13 11:33:16 2012 +0800
@@ -1,6 +1,7 @@
 obj-y +=3D bitmap.o
 obj-y +=3D cpu.o
 obj-y +=3D cpupool.o
+obj-y +=3D core_parking.o
 obj-y +=3D domctl.o
 obj-y +=3D domain.o
 obj-y +=3D event_channel.o
diff -r 92e03310878f xen/common/core_parking.c
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/xen/common/core_parking.c	Mon Feb 13 11:33:16 2012 +0800
@@ -0,0 +1,13 @@
+#include <xen/types.h>
+
+static uint32_t cur_idle_nums;
+
+long core_parking_helper(void *data)
+{
+    return 0;
+}
+
+uint32_t get_cur_idle_nums(void)
+{
+    return cur_idle_nums;
+}
diff -r 92e03310878f xen/include/public/platform.h
--- a/xen/include/public/platform.h	Wed Feb 08 21:05:52 2012 +0800
+++ b/xen/include/public/platform.h	Mon Feb 13 11:33:16 2012 +0800
@@ -490,6 +490,20 @@
     uint32_t flags;
 };
=20
+#define XENPF_core_parking  60
+
+#define XEN_CORE_PARKING_SET 1
+#define XEN_CORE_PARKING_GET 2
+struct xenpf_core_parking {
+    /* IN variables */
+    uint32_t type;
+    /* IN variables:  set cpu nums expected to be idled */
+    /* OUT variables: get cpu nums actually be idled */
+    uint32_t idle_nums;
+};
+typedef struct xenpf_core_parking xenpf_core_parking_t;
+DEFINE_XEN_GUEST_HANDLE(xenpf_core_parking_t);
+
 struct xen_platform_op {
     uint32_t cmd;
     uint32_t interface_version; /* XENPF_INTERFACE_VERSION */
@@ -511,6 +525,7 @@
         struct xenpf_cpu_ol            cpu_ol;
         struct xenpf_cpu_hotadd        cpu_add;
         struct xenpf_mem_hotadd        mem_add;
+        struct xenpf_core_parking      core_parking;
         uint8_t                        pad[128];
     } u;
 };=

--_002_DE8DF0795D48FD4CA783C40EC829233509D8A4SHSMSX101ccrcorpi_
Content-Type: application/octet-stream; name="xen_core_parking_1.patch"
Content-Description: xen_core_parking_1.patch
Content-Disposition: attachment; filename="xen_core_parking_1.patch";
	size=3395; creation-date="Fri, 17 Feb 2012 08:53:15 GMT";
	modification-date="Mon, 13 Feb 2012 16:41:16 GMT"
Content-Transfer-Encoding: base64

WGVuIGNvcmUgcGFya2luZyAxOiBoeXBlcmNhbGwKClRoaXMgcGF0Y2ggaW1wbGVtZW50IGh5cGVy
Y2FsbCB0aHJvdWdoIHdoaWNoIGRvbTAgc2VuZCBjb3JlIHBhcmtpbmcgcmVxdWVzdCwgYW5kIGdl
dCBjb3JlIHBhcmtpbmcgcmVzdWx0LgpEdWUgdG8gdGhlIGNoYXJhY3RlcmlzdGljIG9mIGNvbnRp
bnVlX2h5cGVyY2FsbF9vbl9jcHUsIGRvbTAgc2VwZXJhdGVseSBzZW5kL2dldCBjb3JlIHBhcmtp
bmcgcmVxdWVzdC9yZXN1bHQuCgpTaWduZWQtb2ZmLWJ5OiBMaXUsIEppbnNvbmcgPGppbnNvbmcu
bGl1QGludGVsLmNvbT4KCmRpZmYgLXIgOTJlMDMzMTA4NzhmIHhlbi9hcmNoL3g4Ni9wbGF0Zm9y
bV9oeXBlcmNhbGwuYwotLS0gYS94ZW4vYXJjaC94ODYvcGxhdGZvcm1faHlwZXJjYWxsLmMJV2Vk
IEZlYiAwOCAyMTowNTo1MiAyMDEyICswODAwCisrKyBiL3hlbi9hcmNoL3g4Ni9wbGF0Zm9ybV9o
eXBlcmNhbGwuYwlNb24gRmViIDEzIDExOjMzOjE2IDIwMTIgKzA4MDAKQEAgLTU2LDYgKzU2LDEw
IEBACiBsb25nIGNwdV91cF9oZWxwZXIodm9pZCAqZGF0YSk7CiBsb25nIGNwdV9kb3duX2hlbHBl
cih2b2lkICpkYXRhKTsKIAorLyogZnJvbSBjb3JlX3BhcmtpbmcuYyAqLworbG9uZyBjb3JlX3Bh
cmtpbmdfaGVscGVyKHZvaWQgKmRhdGEpOwordWludDMyX3QgZ2V0X2N1cl9pZGxlX251bXModm9p
ZCk7CisKIHJldF90IGRvX3BsYXRmb3JtX29wKFhFTl9HVUVTVF9IQU5ETEUoeGVuX3BsYXRmb3Jt
X29wX3QpIHVfeGVucGZfb3ApCiB7CiAgICAgcmV0X3QgcmV0ID0gMDsKQEAgLTU5Myw2ICs1OTcs
MzIgQEAKICAgICAgICAgICAgICAgICAgICAgICBvcC0+dS5tZW1fYWRkLmVwZm4sCiAgICAgICAg
ICAgICAgICAgICAgICAgb3AtPnUubWVtX2FkZC5weG0pOwogICAgICAgICBicmVhazsKKworICAg
IGNhc2UgWEVOUEZfY29yZV9wYXJraW5nOgorICAgIHsKKyAgICAgICAgdWludDMyX3QgaWRsZV9u
dW1zOworCisgICAgICAgIHN3aXRjaChvcC0+dS5jb3JlX3BhcmtpbmcudHlwZSkKKyAgICAgICAg
eworICAgICAgICBjYXNlIFhFTl9DT1JFX1BBUktJTkdfU0VUOgorICAgICAgICAgICAgaWRsZV9u
dW1zID0gbWluX3QodWludDMyX3QsCisgICAgICAgICAgICAgICAgICAgIG9wLT51LmNvcmVfcGFy
a2luZy5pZGxlX251bXMsIG51bV9wcmVzZW50X2NwdXMoKSAtIDEpOworICAgICAgICAgICAgcmV0
ID0gY29udGludWVfaHlwZXJjYWxsX29uX2NwdSgKKyAgICAgICAgICAgICAgICAgICAgMCwgY29y
ZV9wYXJraW5nX2hlbHBlciwgKHZvaWQgKikodW5zaWduZWQgbG9uZylpZGxlX251bXMpOworICAg
ICAgICAgICAgYnJlYWs7CisKKyAgICAgICAgY2FzZSBYRU5fQ09SRV9QQVJLSU5HX0dFVDoKKyAg
ICAgICAgICAgIG9wLT51LmNvcmVfcGFya2luZy5pZGxlX251bXMgPSBnZXRfY3VyX2lkbGVfbnVt
cygpOworICAgICAgICAgICAgcmV0ID0gY29weV90b19ndWVzdCh1X3hlbnBmX29wLCBvcCwgMSkg
PyAtRUZBVUxUIDogMDsKKyAgICAgICAgICAgIGJyZWFrOworCisgICAgICAgIGRlZmF1bHQ6Cisg
ICAgICAgICAgICByZXQgPSAtRUlOVkFMOworICAgICAgICAgICAgYnJlYWs7CisgICAgICAgIH0K
KyAgICB9CisgICAgYnJlYWs7CisKICAgICBkZWZhdWx0OgogICAgICAgICByZXQgPSAtRU5PU1lT
OwogICAgICAgICBicmVhazsKZGlmZiAtciA5MmUwMzMxMDg3OGYgeGVuL2NvbW1vbi9NYWtlZmls
ZQotLS0gYS94ZW4vY29tbW9uL01ha2VmaWxlCVdlZCBGZWIgMDggMjE6MDU6NTIgMjAxMiArMDgw
MAorKysgYi94ZW4vY29tbW9uL01ha2VmaWxlCU1vbiBGZWIgMTMgMTE6MzM6MTYgMjAxMiArMDgw
MApAQCAtMSw2ICsxLDcgQEAKIG9iai15ICs9IGJpdG1hcC5vCiBvYmoteSArPSBjcHUubwogb2Jq
LXkgKz0gY3B1cG9vbC5vCitvYmoteSArPSBjb3JlX3Bhcmtpbmcubwogb2JqLXkgKz0gZG9tY3Rs
Lm8KIG9iai15ICs9IGRvbWFpbi5vCiBvYmoteSArPSBldmVudF9jaGFubmVsLm8KZGlmZiAtciA5
MmUwMzMxMDg3OGYgeGVuL2NvbW1vbi9jb3JlX3BhcmtpbmcuYwotLS0gL2Rldi9udWxsCVRodSBK
YW4gMDEgMDA6MDA6MDAgMTk3MCArMDAwMAorKysgYi94ZW4vY29tbW9uL2NvcmVfcGFya2luZy5j
CU1vbiBGZWIgMTMgMTE6MzM6MTYgMjAxMiArMDgwMApAQCAtMCwwICsxLDEzIEBACisjaW5jbHVk
ZSA8eGVuL3R5cGVzLmg+CisKK3N0YXRpYyB1aW50MzJfdCBjdXJfaWRsZV9udW1zOworCitsb25n
IGNvcmVfcGFya2luZ19oZWxwZXIodm9pZCAqZGF0YSkKK3sKKyAgICByZXR1cm4gMDsKK30KKwor
dWludDMyX3QgZ2V0X2N1cl9pZGxlX251bXModm9pZCkKK3sKKyAgICByZXR1cm4gY3VyX2lkbGVf
bnVtczsKK30KZGlmZiAtciA5MmUwMzMxMDg3OGYgeGVuL2luY2x1ZGUvcHVibGljL3BsYXRmb3Jt
LmgKLS0tIGEveGVuL2luY2x1ZGUvcHVibGljL3BsYXRmb3JtLmgJV2VkIEZlYiAwOCAyMTowNTo1
MiAyMDEyICswODAwCisrKyBiL3hlbi9pbmNsdWRlL3B1YmxpYy9wbGF0Zm9ybS5oCU1vbiBGZWIg
MTMgMTE6MzM6MTYgMjAxMiArMDgwMApAQCAtNDkwLDYgKzQ5MCwyMCBAQAogICAgIHVpbnQzMl90
IGZsYWdzOwogfTsKIAorI2RlZmluZSBYRU5QRl9jb3JlX3BhcmtpbmcgIDYwCisKKyNkZWZpbmUg
WEVOX0NPUkVfUEFSS0lOR19TRVQgMQorI2RlZmluZSBYRU5fQ09SRV9QQVJLSU5HX0dFVCAyCitz
dHJ1Y3QgeGVucGZfY29yZV9wYXJraW5nIHsKKyAgICAvKiBJTiB2YXJpYWJsZXMgKi8KKyAgICB1
aW50MzJfdCB0eXBlOworICAgIC8qIElOIHZhcmlhYmxlczogIHNldCBjcHUgbnVtcyBleHBlY3Rl
ZCB0byBiZSBpZGxlZCAqLworICAgIC8qIE9VVCB2YXJpYWJsZXM6IGdldCBjcHUgbnVtcyBhY3R1
YWxseSBiZSBpZGxlZCAqLworICAgIHVpbnQzMl90IGlkbGVfbnVtczsKK307Cit0eXBlZGVmIHN0
cnVjdCB4ZW5wZl9jb3JlX3BhcmtpbmcgeGVucGZfY29yZV9wYXJraW5nX3Q7CitERUZJTkVfWEVO
X0dVRVNUX0hBTkRMRSh4ZW5wZl9jb3JlX3BhcmtpbmdfdCk7CisKIHN0cnVjdCB4ZW5fcGxhdGZv
cm1fb3AgewogICAgIHVpbnQzMl90IGNtZDsKICAgICB1aW50MzJfdCBpbnRlcmZhY2VfdmVyc2lv
bjsgLyogWEVOUEZfSU5URVJGQUNFX1ZFUlNJT04gKi8KQEAgLTUxMSw2ICs1MjUsNyBAQAogICAg
ICAgICBzdHJ1Y3QgeGVucGZfY3B1X29sICAgICAgICAgICAgY3B1X29sOwogICAgICAgICBzdHJ1
Y3QgeGVucGZfY3B1X2hvdGFkZCAgICAgICAgY3B1X2FkZDsKICAgICAgICAgc3RydWN0IHhlbnBm
X21lbV9ob3RhZGQgICAgICAgIG1lbV9hZGQ7CisgICAgICAgIHN0cnVjdCB4ZW5wZl9jb3JlX3Bh
cmtpbmcgICAgICBjb3JlX3Bhcmtpbmc7CiAgICAgICAgIHVpbnQ4X3QgICAgICAgICAgICAgICAg
ICAgICAgICBwYWRbMTI4XTsKICAgICB9IHU7CiB9Owo=

--_002_DE8DF0795D48FD4CA783C40EC829233509D8A4SHSMSX101ccrcorpi_--
