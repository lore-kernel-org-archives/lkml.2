Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758002Ab2EaM7k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 08:59:40 -0400
Received: from mga03.intel.com ([143.182.124.21]:30865 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757119Ab2EaM7i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 08:59:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208,223";a="149923914"
From: "Liu, Jinsong" <jinsong.liu@intel.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Borislav Petkov <bp@amd64.org>
CC: "Luck, Tony" <tony.luck@intel.com>,
        "'xen-devel@lists.xensource.com'" <xen-devel@lists.xensource.com>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/2] initcall sequence adjust for 3 funcs
Thread-Topic: [PATCH 2/2] initcall sequence adjust for 3 funcs
Thread-Index: Ac0/LSitwQZF+TuLSC6cC99wrIYZ3A==
Date: Thu, 31 May 2012 12:59:05 +0000
Message-ID: <DE8DF0795D48FD4CA783C40EC82923351FEE95@SHSMSX101.ccr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: multipart/mixed;
	boundary="_002_DE8DF0795D48FD4CA783C40EC82923351FEE95SHSMSX101ccrcorpi_"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--_002_DE8DF0795D48FD4CA783C40EC82923351FEE95SHSMSX101ccrcorpi_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

>From eb5ff1bef5dd3116fa2624b594b853e9334ccbce Mon Sep 17 00:00:00 2001
From: root <root@ljsromley.bj.intel.com>
Date: Fri, 1 Jun 2012 03:56:25 +0800
Subject: [PATCH 2/2] initcall sequence adjust for 3 funcs

there are 3 funcs need to be _initcalled in a logic sequence:
1. xen_late_init_mcelog
2. mcheck_init_device
3. threshold_init_device

xen_late_init_mcelog need register xen_mce_chrdev_device before
native mce_chrdev_device registeration if running under xen platform;

mcheck_init_device should be inited before threshold_init_device to
initialize mce_device, otherwise a NULL pointer would occur and panic.

so we use following _initcalls
1. device_initcall(xen_late_init_mcelog);
2. device_initcall_sync(mcheck_init_device);
3. late_initcall(threshold_init_device);

when running under xen platform, 1,2,3 would take effect;
when running under baremetal, 2,3 would take effect;

Reported-by: Borislav Petkov <bp@amd64.org>
Suggested-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: Liu, Jinsong <jinsong.liu@intel.com>
---
 arch/x86/kernel/cpu/mcheck/mce_amd.c |   22 +++++++++++++++++++++-
 1 files changed, 21 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce_amd.c b/arch/x86/kernel/cpu/mch=
eck/mce_amd.c
index f4873a6..6647858 100644
--- a/arch/x86/kernel/cpu/mcheck/mce_amd.c
+++ b/arch/x86/kernel/cpu/mcheck/mce_amd.c
@@ -777,4 +777,24 @@ static __init int threshold_init_device(void)
=20
 	return 0;
 }
-device_initcall(threshold_init_device);
+/*
+ * there are 3 funcs need to be _initcalled in a logic sequence:
+ * 1. xen_late_init_mcelog
+ * 2. mcheck_init_device
+ * 3. threshold_init_device
+ *
+ * xen_late_init_mcelog need register xen_mce_chrdev_device before
+ * native mce_chrdev_device registeration if running under xen platform;
+ *
+ * mcheck_init_device should be inited before threshold_init_device to
+ * initialize mce_device, otherwise a NULL pointer would occur and panic.
+ *
+ * so we use following _initcalls
+ * 1. device_initcall(xen_late_init_mcelog);
+ * 2. device_initcall_sync(mcheck_init_device);
+ * 3. late_initcall(threshold_init_device);
+ *
+ * when running under xen platform, 1,2,3 would take effect;
+ * when running under baremetal, 2,3 would take effect;
+ */
+late_initcall(threshold_init_device);
--=20
1.7.1

--_002_DE8DF0795D48FD4CA783C40EC82923351FEE95SHSMSX101ccrcorpi_
Content-Type: application/octet-stream;
	name="0002-initcall-sequence-adjust-for-3-funcs.patch"
Content-Description: 0002-initcall-sequence-adjust-for-3-funcs.patch
Content-Disposition: attachment;
	filename="0002-initcall-sequence-adjust-for-3-funcs.patch"; size=2307;
	creation-date="Thu, 31 May 2012 12:54:12 GMT";
	modification-date="Thu, 31 May 2012 20:49:24 GMT"
Content-Transfer-Encoding: base64

RnJvbSBlYjVmZjFiZWY1ZGQzMTE2ZmEyNjI0YjU5NGI4NTNlOTMzNGNjYmNlIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiByb290IDxyb290QGxqc3JvbWxleS5iai5pbnRlbC5jb20+CkRh
dGU6IEZyaSwgMSBKdW4gMjAxMiAwMzo1NjoyNSArMDgwMApTdWJqZWN0OiBbUEFUQ0ggMi8yXSBp
bml0Y2FsbCBzZXF1ZW5jZSBhZGp1c3QgZm9yIDMgZnVuY3MKCnRoZXJlIGFyZSAzIGZ1bmNzIG5l
ZWQgdG8gYmUgX2luaXRjYWxsZWQgaW4gYSBsb2dpYyBzZXF1ZW5jZToKMS4geGVuX2xhdGVfaW5p
dF9tY2Vsb2cKMi4gbWNoZWNrX2luaXRfZGV2aWNlCjMuIHRocmVzaG9sZF9pbml0X2RldmljZQoK
eGVuX2xhdGVfaW5pdF9tY2Vsb2cgbmVlZCByZWdpc3RlciB4ZW5fbWNlX2NocmRldl9kZXZpY2Ug
YmVmb3JlCm5hdGl2ZSBtY2VfY2hyZGV2X2RldmljZSByZWdpc3RlcmF0aW9uIGlmIHJ1bm5pbmcg
dW5kZXIgeGVuIHBsYXRmb3JtOwoKbWNoZWNrX2luaXRfZGV2aWNlIHNob3VsZCBiZSBpbml0ZWQg
YmVmb3JlIHRocmVzaG9sZF9pbml0X2RldmljZSB0bwppbml0aWFsaXplIG1jZV9kZXZpY2UsIG90
aGVyd2lzZSBhIE5VTEwgcG9pbnRlciB3b3VsZCBvY2N1ciBhbmQgcGFuaWMuCgpzbyB3ZSB1c2Ug
Zm9sbG93aW5nIF9pbml0Y2FsbHMKMS4gZGV2aWNlX2luaXRjYWxsKHhlbl9sYXRlX2luaXRfbWNl
bG9nKTsKMi4gZGV2aWNlX2luaXRjYWxsX3N5bmMobWNoZWNrX2luaXRfZGV2aWNlKTsKMy4gbGF0
ZV9pbml0Y2FsbCh0aHJlc2hvbGRfaW5pdF9kZXZpY2UpOwoKd2hlbiBydW5uaW5nIHVuZGVyIHhl
biBwbGF0Zm9ybSwgMSwyLDMgd291bGQgdGFrZSBlZmZlY3Q7CndoZW4gcnVubmluZyB1bmRlciBi
YXJlbWV0YWwsIDIsMyB3b3VsZCB0YWtlIGVmZmVjdDsKClJlcG9ydGVkLWJ5OiBCb3Jpc2xhdiBQ
ZXRrb3YgPGJwQGFtZDY0Lm9yZz4KU3VnZ2VzdGVkLWJ5OiBLb25yYWQgUnplc3p1dGVrIFdpbGsg
PGtvbnJhZC53aWxrQG9yYWNsZS5jb20+ClNpZ25lZC1vZmYtYnk6IExpdSwgSmluc29uZyA8amlu
c29uZy5saXVAaW50ZWwuY29tPgotLS0KIGFyY2gveDg2L2tlcm5lbC9jcHUvbWNoZWNrL21jZV9h
bWQuYyB8ICAgMjIgKysrKysrKysrKysrKysrKysrKysrLQogMSBmaWxlcyBjaGFuZ2VkLCAyMSBp
bnNlcnRpb25zKCspLCAxIGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2FyY2gveDg2L2tlcm5l
bC9jcHUvbWNoZWNrL21jZV9hbWQuYyBiL2FyY2gveDg2L2tlcm5lbC9jcHUvbWNoZWNrL21jZV9h
bWQuYwppbmRleCBmNDg3M2E2Li42NjQ3ODU4IDEwMDY0NAotLS0gYS9hcmNoL3g4Ni9rZXJuZWwv
Y3B1L21jaGVjay9tY2VfYW1kLmMKKysrIGIvYXJjaC94ODYva2VybmVsL2NwdS9tY2hlY2svbWNl
X2FtZC5jCkBAIC03NzcsNCArNzc3LDI0IEBAIHN0YXRpYyBfX2luaXQgaW50IHRocmVzaG9sZF9p
bml0X2RldmljZSh2b2lkKQogCiAJcmV0dXJuIDA7CiB9Ci1kZXZpY2VfaW5pdGNhbGwodGhyZXNo
b2xkX2luaXRfZGV2aWNlKTsKKy8qCisgKiB0aGVyZSBhcmUgMyBmdW5jcyBuZWVkIHRvIGJlIF9p
bml0Y2FsbGVkIGluIGEgbG9naWMgc2VxdWVuY2U6CisgKiAxLiB4ZW5fbGF0ZV9pbml0X21jZWxv
ZworICogMi4gbWNoZWNrX2luaXRfZGV2aWNlCisgKiAzLiB0aHJlc2hvbGRfaW5pdF9kZXZpY2UK
KyAqCisgKiB4ZW5fbGF0ZV9pbml0X21jZWxvZyBuZWVkIHJlZ2lzdGVyIHhlbl9tY2VfY2hyZGV2
X2RldmljZSBiZWZvcmUKKyAqIG5hdGl2ZSBtY2VfY2hyZGV2X2RldmljZSByZWdpc3RlcmF0aW9u
IGlmIHJ1bm5pbmcgdW5kZXIgeGVuIHBsYXRmb3JtOworICoKKyAqIG1jaGVja19pbml0X2Rldmlj
ZSBzaG91bGQgYmUgaW5pdGVkIGJlZm9yZSB0aHJlc2hvbGRfaW5pdF9kZXZpY2UgdG8KKyAqIGlu
aXRpYWxpemUgbWNlX2RldmljZSwgb3RoZXJ3aXNlIGEgTlVMTCBwb2ludGVyIHdvdWxkIG9jY3Vy
IGFuZCBwYW5pYy4KKyAqCisgKiBzbyB3ZSB1c2UgZm9sbG93aW5nIF9pbml0Y2FsbHMKKyAqIDEu
IGRldmljZV9pbml0Y2FsbCh4ZW5fbGF0ZV9pbml0X21jZWxvZyk7CisgKiAyLiBkZXZpY2VfaW5p
dGNhbGxfc3luYyhtY2hlY2tfaW5pdF9kZXZpY2UpOworICogMy4gbGF0ZV9pbml0Y2FsbCh0aHJl
c2hvbGRfaW5pdF9kZXZpY2UpOworICoKKyAqIHdoZW4gcnVubmluZyB1bmRlciB4ZW4gcGxhdGZv
cm0sIDEsMiwzIHdvdWxkIHRha2UgZWZmZWN0OworICogd2hlbiBydW5uaW5nIHVuZGVyIGJhcmVt
ZXRhbCwgMiwzIHdvdWxkIHRha2UgZWZmZWN0OworICovCitsYXRlX2luaXRjYWxsKHRocmVzaG9s
ZF9pbml0X2RldmljZSk7Ci0tIAoxLjcuMQoK

--_002_DE8DF0795D48FD4CA783C40EC82923351FEE95SHSMSX101ccrcorpi_--
