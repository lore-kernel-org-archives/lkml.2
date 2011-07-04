Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753828Ab1GDH1o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jul 2011 03:27:44 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:61488 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751335Ab1GDH1k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jul 2011 03:27:40 -0400
MIME-Version: 1.0
Date: Mon, 4 Jul 2011 15:27:39 +0800
Message-ID: <CAM2zO=AEHu9+z8ebdyocwiyr2fThbAC6On4dbbVD00x6VJmXEg@mail.gmail.com>
Subject: [PATCH] SAMPLES: kprobe_example: make it more easy to use
From: Yong Zhang <yong.zhang0@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: ananth@in.ibm.com
Content-Type: multipart/mixed; boundary=000e0cd1d16e59861404a7394de6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--000e0cd1d16e59861404a7394de6
Content-Type: text/plain; charset=UTF-8

From: Yong Zhang <yong.zhang0@gmail.com>
Subject: [PATCH] SAMPLES: kprobe_example: make it more easy to use

Add parameter 'func' and 'offset' to it, thus make it more easy
to kprobe certain offset/function.

Also print the next PC in post_handler(), thus we can ealily
tell if there is something is wrong when kprobe fails. This
is inspirited by a bug which explores an issue on POWERPC-32
when intruction is emulated: https://lkml.org/lkml/2011/6/24/53

Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>
---

Attach it too since webmail may mangle it.

 samples/kprobes/kprobe_example.c |   31 ++++++++++++++++++++++---------
 1 files changed, 22 insertions(+), 9 deletions(-)

diff --git a/samples/kprobes/kprobe_example.c b/samples/kprobes/kprobe_example.c
index ebf5e0c..bbae5f4 100644
--- a/samples/kprobes/kprobe_example.c
+++ b/samples/kprobes/kprobe_example.c
@@ -13,11 +13,18 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/kprobes.h>
+#include <linux/limits.h>
+
+static char func_name[NAME_MAX] = "do_fork";
+module_param_string(func, func_name, NAME_MAX, S_IRUGO);
+MODULE_PARM_DESC(func, "Function to kprobe");
+
+static unsigned int offset;
+module_param(offset, uint, S_IRUGO);
+MODULE_PARM_DESC(offset, "Function offset to kprobe");

 /* For each probe you need to allocate a kprobe structure */
-static struct kprobe kp = {
-	.symbol_name	= "do_fork",
-};
+static struct kprobe kp;

 /* kprobe pre_handler: called just before the probed instruction is executed */
 static int handler_pre(struct kprobe *p, struct pt_regs *regs)
@@ -47,16 +54,20 @@ static void handler_post(struct kprobe *p, struct
pt_regs *regs,
 				unsigned long flags)
 {
 #ifdef CONFIG_X86
-	printk(KERN_INFO "post_handler: p->addr = 0x%p, flags = 0x%lx\n",
-		p->addr, regs->flags);
+	printk(KERN_INFO "post_handler: p->addr = 0x%p, ip = %lx,"
+			" flags = 0x%lx\n",
+		p->addr, regs->ip, regs->flags);
 #endif
 #ifdef CONFIG_PPC
-	printk(KERN_INFO "post_handler: p->addr = 0x%p, msr = 0x%lx\n",
-		p->addr, regs->msr);
+	printk(KERN_INFO "post_handler: p->addr = 0x%p, nip = 0x%lx,"
+			" msr = 0x%lx\n",
+		p->addr, regs->nip, regs->msr);
+	dump_stack();
 #endif
 #ifdef CONFIG_MIPS
-	printk(KERN_INFO "post_handler: p->addr = 0x%p, status = 0x%lx\n",
-		p->addr, regs->cp0_status);
+	printk(KERN_INFO "post_handler: p->addr = 0x%p, epc = 0x%lx,"
+			" status = 0x%lx\n",
+		p->addr, regs->cp0_epc, regs->cp0_status);
 #endif
 }

@@ -76,6 +87,8 @@ static int handler_fault(struct kprobe *p, struct
pt_regs *regs, int trapnr)
 static int __init kprobe_init(void)
 {
 	int ret;
+	kp.symbol_name = func_name;
+	kp.offset = offset;
 	kp.pre_handler = handler_pre;
 	kp.post_handler = handler_post;
 	kp.fault_handler = handler_fault;
-- 
1.7.4.1

--000e0cd1d16e59861404a7394de6
Content-Type: text/x-patch; charset=US-ASCII; 
	name="0001-SAMPLES-kprobe_example-make-it-more-easy-to-use.patch"
Content-Disposition: attachment; 
	filename="0001-SAMPLES-kprobe_example-make-it-more-easy-to-use.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gpp3wtby0

RnJvbSA0NjFjMTc0ZmFhNzRmMTBkMGYyZGYyODI0NzcwOWJkNjdlNmM5MzMzIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBZb25nIFpoYW5nIDx5b25nLnpoYW5nMEBnbWFpbC5jb20+CkRh
dGU6IE1vbiwgNCBKdWwgMjAxMSAxNToxMjozNiArMDgwMApTdWJqZWN0OiBbUEFUQ0hdIFNBTVBM
RVM6IGtwcm9iZV9leGFtcGxlOiBtYWtlIGl0IG1vcmUgZWFzeSB0byB1c2UKCkFkZCBwYXJhbWV0
ZXIgJ2Z1bmMnIGFuZCAnb2Zmc2V0JyB0byBpdCwgdGh1cyBtYWtlIGl0IG1vcmUgZWFzeQp0byBr
cHJvYmUgY2VydGFpbiBvZmZzZXQvZnVuY3Rpb24uCgpBbHNvIHByaW50IHRoZSBuZXh0IFBDIGlu
IHBvc3RfaGFuZGxlcigpLCB0aHVzIHdlIGNhbiBlYWxpbHkKdGVsbCBpZiB0aGVyZSBpcyBzb21l
dGhpbmcgaXMgd3Jvbmcgd2hlbiBrcHJvYmUgZmFpbHMuIFRoaXMKaXMgaW5zcGlyaXRlZCBieSBh
IGJ1ZyB3aGljaCBleHBsb3JlcyBhbiBpc3N1ZSBvbiBQT1dFUlBDLTMyCndoZW4gaW50cnVjdGlv
biBpcyBlbXVsYXRlZDogaHR0cHM6Ly9sa21sLm9yZy9sa21sLzIwMTEvNi8yNC81MwoKU2lnbmVk
LW9mZi1ieTogWW9uZyBaaGFuZyA8eW9uZy56aGFuZzBAZ21haWwuY29tPgotLS0KIHNhbXBsZXMv
a3Byb2Jlcy9rcHJvYmVfZXhhbXBsZS5jIHwgICAzMSArKysrKysrKysrKysrKysrKysrKysrLS0t
LS0tLS0tCiAxIGZpbGVzIGNoYW5nZWQsIDIyIGluc2VydGlvbnMoKyksIDkgZGVsZXRpb25zKC0p
CgpkaWZmIC0tZ2l0IGEvc2FtcGxlcy9rcHJvYmVzL2twcm9iZV9leGFtcGxlLmMgYi9zYW1wbGVz
L2twcm9iZXMva3Byb2JlX2V4YW1wbGUuYwppbmRleCBlYmY1ZTBjLi5iYmFlNWY0IDEwMDY0NAot
LS0gYS9zYW1wbGVzL2twcm9iZXMva3Byb2JlX2V4YW1wbGUuYworKysgYi9zYW1wbGVzL2twcm9i
ZXMva3Byb2JlX2V4YW1wbGUuYwpAQCAtMTMsMTEgKzEzLDE4IEBACiAjaW5jbHVkZSA8bGludXgv
a2VybmVsLmg+CiAjaW5jbHVkZSA8bGludXgvbW9kdWxlLmg+CiAjaW5jbHVkZSA8bGludXgva3By
b2Jlcy5oPgorI2luY2x1ZGUgPGxpbnV4L2xpbWl0cy5oPgorCitzdGF0aWMgY2hhciBmdW5jX25h
bWVbTkFNRV9NQVhdID0gImRvX2ZvcmsiOworbW9kdWxlX3BhcmFtX3N0cmluZyhmdW5jLCBmdW5j
X25hbWUsIE5BTUVfTUFYLCBTX0lSVUdPKTsKK01PRFVMRV9QQVJNX0RFU0MoZnVuYywgIkZ1bmN0
aW9uIHRvIGtwcm9iZSIpOworCitzdGF0aWMgdW5zaWduZWQgaW50IG9mZnNldDsKK21vZHVsZV9w
YXJhbShvZmZzZXQsIHVpbnQsIFNfSVJVR08pOworTU9EVUxFX1BBUk1fREVTQyhvZmZzZXQsICJG
dW5jdGlvbiBvZmZzZXQgdG8ga3Byb2JlIik7CiAKIC8qIEZvciBlYWNoIHByb2JlIHlvdSBuZWVk
IHRvIGFsbG9jYXRlIGEga3Byb2JlIHN0cnVjdHVyZSAqLwotc3RhdGljIHN0cnVjdCBrcHJvYmUg
a3AgPSB7Ci0JLnN5bWJvbF9uYW1lCT0gImRvX2ZvcmsiLAotfTsKK3N0YXRpYyBzdHJ1Y3Qga3By
b2JlIGtwOwogCiAvKiBrcHJvYmUgcHJlX2hhbmRsZXI6IGNhbGxlZCBqdXN0IGJlZm9yZSB0aGUg
cHJvYmVkIGluc3RydWN0aW9uIGlzIGV4ZWN1dGVkICovCiBzdGF0aWMgaW50IGhhbmRsZXJfcHJl
KHN0cnVjdCBrcHJvYmUgKnAsIHN0cnVjdCBwdF9yZWdzICpyZWdzKQpAQCAtNDcsMTYgKzU0LDIw
IEBAIHN0YXRpYyB2b2lkIGhhbmRsZXJfcG9zdChzdHJ1Y3Qga3Byb2JlICpwLCBzdHJ1Y3QgcHRf
cmVncyAqcmVncywKIAkJCQl1bnNpZ25lZCBsb25nIGZsYWdzKQogewogI2lmZGVmIENPTkZJR19Y
ODYKLQlwcmludGsoS0VSTl9JTkZPICJwb3N0X2hhbmRsZXI6IHAtPmFkZHIgPSAweCVwLCBmbGFn
cyA9IDB4JWx4XG4iLAotCQlwLT5hZGRyLCByZWdzLT5mbGFncyk7CisJcHJpbnRrKEtFUk5fSU5G
TyAicG9zdF9oYW5kbGVyOiBwLT5hZGRyID0gMHglcCwgaXAgPSAlbHgsIgorCQkJIiBmbGFncyA9
IDB4JWx4XG4iLAorCQlwLT5hZGRyLCByZWdzLT5pcCwgcmVncy0+ZmxhZ3MpOwogI2VuZGlmCiAj
aWZkZWYgQ09ORklHX1BQQwotCXByaW50ayhLRVJOX0lORk8gInBvc3RfaGFuZGxlcjogcC0+YWRk
ciA9IDB4JXAsIG1zciA9IDB4JWx4XG4iLAotCQlwLT5hZGRyLCByZWdzLT5tc3IpOworCXByaW50
ayhLRVJOX0lORk8gInBvc3RfaGFuZGxlcjogcC0+YWRkciA9IDB4JXAsIG5pcCA9IDB4JWx4LCIK
KwkJCSIgbXNyID0gMHglbHhcbiIsCisJCXAtPmFkZHIsIHJlZ3MtPm5pcCwgcmVncy0+bXNyKTsK
KwlkdW1wX3N0YWNrKCk7CiAjZW5kaWYKICNpZmRlZiBDT05GSUdfTUlQUwotCXByaW50ayhLRVJO
X0lORk8gInBvc3RfaGFuZGxlcjogcC0+YWRkciA9IDB4JXAsIHN0YXR1cyA9IDB4JWx4XG4iLAot
CQlwLT5hZGRyLCByZWdzLT5jcDBfc3RhdHVzKTsKKwlwcmludGsoS0VSTl9JTkZPICJwb3N0X2hh
bmRsZXI6IHAtPmFkZHIgPSAweCVwLCBlcGMgPSAweCVseCwiCisJCQkiIHN0YXR1cyA9IDB4JWx4
XG4iLAorCQlwLT5hZGRyLCByZWdzLT5jcDBfZXBjLCByZWdzLT5jcDBfc3RhdHVzKTsKICNlbmRp
ZgogfQogCkBAIC03Niw2ICs4Nyw4IEBAIHN0YXRpYyBpbnQgaGFuZGxlcl9mYXVsdChzdHJ1Y3Qg
a3Byb2JlICpwLCBzdHJ1Y3QgcHRfcmVncyAqcmVncywgaW50IHRyYXBucikKIHN0YXRpYyBpbnQg
X19pbml0IGtwcm9iZV9pbml0KHZvaWQpCiB7CiAJaW50IHJldDsKKwlrcC5zeW1ib2xfbmFtZSA9
IGZ1bmNfbmFtZTsKKwlrcC5vZmZzZXQgPSBvZmZzZXQ7CiAJa3AucHJlX2hhbmRsZXIgPSBoYW5k
bGVyX3ByZTsKIAlrcC5wb3N0X2hhbmRsZXIgPSBoYW5kbGVyX3Bvc3Q7CiAJa3AuZmF1bHRfaGFu
ZGxlciA9IGhhbmRsZXJfZmF1bHQ7Ci0tIAoxLjcuNC4xCgo=
--000e0cd1d16e59861404a7394de6--
