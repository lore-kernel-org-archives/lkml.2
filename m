Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756053Ab2EaRcY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 13:32:24 -0400
Received: from mga03.intel.com ([143.182.124.21]:50509 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754728Ab2EaRcW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 13:32:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208,223";a="106369706"
From: "Liu, Jinsong" <jinsong.liu@intel.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Borislav Petkov <bp@amd64.org>, "Luck, Tony" <tony.luck@intel.com>,
        "'xen-devel@lists.xensource.com'" <xen-devel@lists.xensource.com>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/3] X86, MCE, AMD: Adjust initcall sequence for xen
Thread-Topic: [PATCH 2/3] X86, MCE, AMD: Adjust initcall sequence for xen
Thread-Index: Ac0/U1N3hg23ys/+REik1lYOKQOUiw==
Date: Thu, 31 May 2012 17:32:18 +0000
Message-ID: <DE8DF0795D48FD4CA783C40EC82923351FFB5F@SHSMSX101.ccr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: multipart/mixed;
	boundary="_002_DE8DF0795D48FD4CA783C40EC82923351FFB5FSHSMSX101ccrcorpi_"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--_002_DE8DF0795D48FD4CA783C40EC82923351FFB5FSHSMSX101ccrcorpi_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

>From bd14e0b1f0bf4586d03cc1fc810606d2ef2c1076 Mon Sep 17 00:00:00 2001
From: Liu, Jinsong <jinsong.liu@intel.com>
Date: Fri, 1 Jun 2012 08:30:21 +0800
Subject: [PATCH 2/3] X86, MCE, AMD: Adjust initcall sequence for xen

there are 3 funcs which need to be _initcalled in a logic sequence:
1. xen_late_init_mcelog
2. mcheck_init_device
3. threshold_init_device

xen_late_init_mcelog must register xen_mce_chrdev_device before
native mce_chrdev_device registration if running under xen platform;

mcheck_init_device should be inited before threshold_init_device to
initialize mce_device, otherwise a NULL ptr dereference will cause panic.

so we use following _initcalls
1. device_initcall(xen_late_init_mcelog);
2. device_initcall_sync(mcheck_init_device);
3. late_initcall(threshold_init_device);

when running under xen, the initcall order is 1,2,3;
on baremetal, we skip 1 and we do only 2 and 3.

Reported-by: Borislav Petkov <bp@amd64.org>
Suggested-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Acked-and-tested-by: Borislav Petkov <borislav.petkov@amd.com>
Signed-off-by: Liu, Jinsong <jinsong.liu@intel.com>
---
 arch/x86/kernel/cpu/mcheck/mce_amd.c |   22 +++++++++++++++++++++-
 1 files changed, 21 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce_amd.c b/arch/x86/kernel/cpu/mch=
eck/mce_amd.c
index f4873a6..be52744 100644
--- a/arch/x86/kernel/cpu/mcheck/mce_amd.c
+++ b/arch/x86/kernel/cpu/mcheck/mce_amd.c
@@ -777,4 +777,24 @@ static __init int threshold_init_device(void)
=20
 	return 0;
 }
-device_initcall(threshold_init_device);
+/*
+ * there are 3 funcs which need to be _initcalled in a logic sequence:
+ * 1. xen_late_init_mcelog
+ * 2. mcheck_init_device
+ * 3. threshold_init_device
+ *
+ * xen_late_init_mcelog must register xen_mce_chrdev_device before
+ * native mce_chrdev_device registration if running under xen platform;
+ *
+ * mcheck_init_device should be inited before threshold_init_device to
+ * initialize mce_device, otherwise a NULL ptr dereference will cause pani=
c.
+ *
+ * so we use following _initcalls
+ * 1. device_initcall(xen_late_init_mcelog);
+ * 2. device_initcall_sync(mcheck_init_device);
+ * 3. late_initcall(threshold_init_device);
+ *
+ * when running under xen, the initcall order is 1,2,3;
+ * on baremetal, we skip 1 and we do only 2 and 3.
+ */
+late_initcall(threshold_init_device);
--=20
1.7.1

--_002_DE8DF0795D48FD4CA783C40EC82923351FFB5FSHSMSX101ccrcorpi_
Content-Type: application/octet-stream;
	name="0002-X86-MCE-AMD-Adjust-initcall-sequence-for-xen.patch"
Content-Description: 0002-X86-MCE-AMD-Adjust-initcall-sequence-for-xen.patch
Content-Disposition: attachment;
	filename="0002-X86-MCE-AMD-Adjust-initcall-sequence-for-xen.patch";
	size=2379; creation-date="Thu, 31 May 2012 17:10:05 GMT";
	modification-date="Fri, 01 Jun 2012 00:43:22 GMT"
Content-Transfer-Encoding: base64

RnJvbSBiZDE0ZTBiMWYwYmY0NTg2ZDAzY2MxZmM4MTA2MDZkMmVmMmMxMDc2IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBMaXUsIEppbnNvbmcgPGppbnNvbmcubGl1QGludGVsLmNvbT4K
RGF0ZTogRnJpLCAxIEp1biAyMDEyIDA4OjMwOjIxICswODAwClN1YmplY3Q6IFtQQVRDSCAyLzNd
IFg4NiwgTUNFLCBBTUQ6IEFkanVzdCBpbml0Y2FsbCBzZXF1ZW5jZSBmb3IgeGVuCgp0aGVyZSBh
cmUgMyBmdW5jcyB3aGljaCBuZWVkIHRvIGJlIF9pbml0Y2FsbGVkIGluIGEgbG9naWMgc2VxdWVu
Y2U6CjEuIHhlbl9sYXRlX2luaXRfbWNlbG9nCjIuIG1jaGVja19pbml0X2RldmljZQozLiB0aHJl
c2hvbGRfaW5pdF9kZXZpY2UKCnhlbl9sYXRlX2luaXRfbWNlbG9nIG11c3QgcmVnaXN0ZXIgeGVu
X21jZV9jaHJkZXZfZGV2aWNlIGJlZm9yZQpuYXRpdmUgbWNlX2NocmRldl9kZXZpY2UgcmVnaXN0
cmF0aW9uIGlmIHJ1bm5pbmcgdW5kZXIgeGVuIHBsYXRmb3JtOwoKbWNoZWNrX2luaXRfZGV2aWNl
IHNob3VsZCBiZSBpbml0ZWQgYmVmb3JlIHRocmVzaG9sZF9pbml0X2RldmljZSB0bwppbml0aWFs
aXplIG1jZV9kZXZpY2UsIG90aGVyd2lzZSBhIE5VTEwgcHRyIGRlcmVmZXJlbmNlIHdpbGwgY2F1
c2UgcGFuaWMuCgpzbyB3ZSB1c2UgZm9sbG93aW5nIF9pbml0Y2FsbHMKMS4gZGV2aWNlX2luaXRj
YWxsKHhlbl9sYXRlX2luaXRfbWNlbG9nKTsKMi4gZGV2aWNlX2luaXRjYWxsX3N5bmMobWNoZWNr
X2luaXRfZGV2aWNlKTsKMy4gbGF0ZV9pbml0Y2FsbCh0aHJlc2hvbGRfaW5pdF9kZXZpY2UpOwoK
d2hlbiBydW5uaW5nIHVuZGVyIHhlbiwgdGhlIGluaXRjYWxsIG9yZGVyIGlzIDEsMiwzOwpvbiBi
YXJlbWV0YWwsIHdlIHNraXAgMSBhbmQgd2UgZG8gb25seSAyIGFuZCAzLgoKUmVwb3J0ZWQtYnk6
IEJvcmlzbGF2IFBldGtvdiA8YnBAYW1kNjQub3JnPgpTdWdnZXN0ZWQtYnk6IEtvbnJhZCBSemVz
enV0ZWsgV2lsayA8a29ucmFkLndpbGtAb3JhY2xlLmNvbT4KQWNrZWQtYW5kLXRlc3RlZC1ieTog
Qm9yaXNsYXYgUGV0a292IDxib3Jpc2xhdi5wZXRrb3ZAYW1kLmNvbT4KU2lnbmVkLW9mZi1ieTog
TGl1LCBKaW5zb25nIDxqaW5zb25nLmxpdUBpbnRlbC5jb20+Ci0tLQogYXJjaC94ODYva2VybmVs
L2NwdS9tY2hlY2svbWNlX2FtZC5jIHwgICAyMiArKysrKysrKysrKysrKysrKysrKystCiAxIGZp
bGVzIGNoYW5nZWQsIDIxIGluc2VydGlvbnMoKyksIDEgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0
IGEvYXJjaC94ODYva2VybmVsL2NwdS9tY2hlY2svbWNlX2FtZC5jIGIvYXJjaC94ODYva2VybmVs
L2NwdS9tY2hlY2svbWNlX2FtZC5jCmluZGV4IGY0ODczYTYuLmJlNTI3NDQgMTAwNjQ0Ci0tLSBh
L2FyY2gveDg2L2tlcm5lbC9jcHUvbWNoZWNrL21jZV9hbWQuYworKysgYi9hcmNoL3g4Ni9rZXJu
ZWwvY3B1L21jaGVjay9tY2VfYW1kLmMKQEAgLTc3Nyw0ICs3NzcsMjQgQEAgc3RhdGljIF9faW5p
dCBpbnQgdGhyZXNob2xkX2luaXRfZGV2aWNlKHZvaWQpCiAKIAlyZXR1cm4gMDsKIH0KLWRldmlj
ZV9pbml0Y2FsbCh0aHJlc2hvbGRfaW5pdF9kZXZpY2UpOworLyoKKyAqIHRoZXJlIGFyZSAzIGZ1
bmNzIHdoaWNoIG5lZWQgdG8gYmUgX2luaXRjYWxsZWQgaW4gYSBsb2dpYyBzZXF1ZW5jZToKKyAq
IDEuIHhlbl9sYXRlX2luaXRfbWNlbG9nCisgKiAyLiBtY2hlY2tfaW5pdF9kZXZpY2UKKyAqIDMu
IHRocmVzaG9sZF9pbml0X2RldmljZQorICoKKyAqIHhlbl9sYXRlX2luaXRfbWNlbG9nIG11c3Qg
cmVnaXN0ZXIgeGVuX21jZV9jaHJkZXZfZGV2aWNlIGJlZm9yZQorICogbmF0aXZlIG1jZV9jaHJk
ZXZfZGV2aWNlIHJlZ2lzdHJhdGlvbiBpZiBydW5uaW5nIHVuZGVyIHhlbiBwbGF0Zm9ybTsKKyAq
CisgKiBtY2hlY2tfaW5pdF9kZXZpY2Ugc2hvdWxkIGJlIGluaXRlZCBiZWZvcmUgdGhyZXNob2xk
X2luaXRfZGV2aWNlIHRvCisgKiBpbml0aWFsaXplIG1jZV9kZXZpY2UsIG90aGVyd2lzZSBhIE5V
TEwgcHRyIGRlcmVmZXJlbmNlIHdpbGwgY2F1c2UgcGFuaWMuCisgKgorICogc28gd2UgdXNlIGZv
bGxvd2luZyBfaW5pdGNhbGxzCisgKiAxLiBkZXZpY2VfaW5pdGNhbGwoeGVuX2xhdGVfaW5pdF9t
Y2Vsb2cpOworICogMi4gZGV2aWNlX2luaXRjYWxsX3N5bmMobWNoZWNrX2luaXRfZGV2aWNlKTsK
KyAqIDMuIGxhdGVfaW5pdGNhbGwodGhyZXNob2xkX2luaXRfZGV2aWNlKTsKKyAqCisgKiB3aGVu
IHJ1bm5pbmcgdW5kZXIgeGVuLCB0aGUgaW5pdGNhbGwgb3JkZXIgaXMgMSwyLDM7CisgKiBvbiBi
YXJlbWV0YWwsIHdlIHNraXAgMSBhbmQgd2UgZG8gb25seSAyIGFuZCAzLgorICovCitsYXRlX2lu
aXRjYWxsKHRocmVzaG9sZF9pbml0X2RldmljZSk7Ci0tIAoxLjcuMQoK

--_002_DE8DF0795D48FD4CA783C40EC82923351FFB5FSHSMSX101ccrcorpi_--
