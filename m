Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753013Ab1GECAc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jul 2011 22:00:32 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:64282 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752926Ab1GECAa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jul 2011 22:00:30 -0400
MIME-Version: 1.0
In-Reply-To: <20110704101422.GA9308@in.ibm.com>
References: <CAM2zO=AEHu9+z8ebdyocwiyr2fThbAC6On4dbbVD00x6VJmXEg@mail.gmail.com>
	<20110704101422.GA9308@in.ibm.com>
Date: Tue, 5 Jul 2011 10:00:29 +0800
Message-ID: <CAM2zO=Csp3EvEQKoxZuKJzdWbsCexV-YYjxoaUefYSHawRmEDA@mail.gmail.com>
Subject: Re: [PATCH] SAMPLES: kprobe_example: make it more easy to use
From: Yong Zhang <yong.zhang0@gmail.com>
To: ananth@in.ibm.com
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: multipart/mixed; boundary=20cf30549ff12b416d04a748d9b3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--20cf30549ff12b416d04a748d9b3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 4, 2011 at 6:14 PM, Ananth N Mavinakayanahalli
<ananth@in.ibm.com> wrote:
> On Mon, Jul 04, 2011 at 03:27:39PM +0800, Yong Zhang wrote:
>> From: Yong Zhang <yong.zhang0@gmail.com>
>> Subject: [PATCH] SAMPLES: kprobe_example: make it more easy to use
>
> ...
>
>> - =C2=A0 =C2=A0 printk(KERN_INFO "post_handler: p->addr =3D 0x%p, flags =
=3D 0x%lx\n",
>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 p->addr, regs->flags);
>> + =C2=A0 =C2=A0 printk(KERN_INFO "post_handler: p->addr =3D 0x%p, ip =3D=
 %lx,"
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
" flags =3D 0x%lx\n",
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 p->addr, regs->ip, regs->fla=
gs);
>
> You are probably better off using the instruction_pointer(regs) helper
> here and elsewhere..

Ah, good to know this wrapper :)

Updated like below:
---
From: Yong Zhang <yong.zhang0@gmail.com>
Subject: [PATCH V2] SAMPLES: kprobe_example: make it more easy to use

Add parameter 'func' and 'offset' to it, thus make it more easy
to kprobe certain offset/function.

Also print the next PC in post_handler(), thus we can ealily
tell if there is something is wrong when kprobe fails. This
is inspirited by a bug which explores an issue on POWERPC-32
when intruction is emulated: https://lkml.org/lkml/2011/6/24/53

Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>
---
Changes from V1:
  Using wrapper function instruction_pointer() to get next PC.

 samples/kprobes/kprobe_example.c |   37 +++++++++++++++++++++++++---------=
---
 1 files changed, 25 insertions(+), 12 deletions(-)

diff --git a/samples/kprobes/kprobe_example.c b/samples/kprobes/kprobe_exam=
ple.c
index ebf5e0c..8394e98 100644
--- a/samples/kprobes/kprobe_example.c
+++ b/samples/kprobes/kprobe_example.c
@@ -13,11 +13,18 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/kprobes.h>
+#include <linux/limits.h>
+
+static char func_name[NAME_MAX] =3D "do_fork";
+module_param_string(func, func_name, NAME_MAX, S_IRUGO);
+MODULE_PARM_DESC(func, "Function to kprobe");
+
+static unsigned int offset;
+module_param(offset, uint, S_IRUGO);
+MODULE_PARM_DESC(offset, "Function offset to kprobe");

 /* For each probe you need to allocate a kprobe structure */
-static struct kprobe kp =3D {
-	.symbol_name	=3D "do_fork",
-};
+static struct kprobe kp;

 /* kprobe pre_handler: called just before the probed instruction is execut=
ed */
 static int handler_pre(struct kprobe *p, struct pt_regs *regs)
@@ -25,17 +32,17 @@ static int handler_pre(struct kprobe *p, struct
pt_regs *regs)
 #ifdef CONFIG_X86
 	printk(KERN_INFO "pre_handler: p->addr =3D 0x%p, ip =3D %lx,"
 			" flags =3D 0x%lx\n",
-		p->addr, regs->ip, regs->flags);
+		p->addr, instruction_pointer(regs), regs->flags);
 #endif
 #ifdef CONFIG_PPC
 	printk(KERN_INFO "pre_handler: p->addr =3D 0x%p, nip =3D 0x%lx,"
 			" msr =3D 0x%lx\n",
-		p->addr, regs->nip, regs->msr);
+		p->addr, instruction_pointer(regs), regs->msr);
 #endif
 #ifdef CONFIG_MIPS
 	printk(KERN_INFO "pre_handler: p->addr =3D 0x%p, epc =3D 0x%lx,"
 			" status =3D 0x%lx\n",
-		p->addr, regs->cp0_epc, regs->cp0_status);
+		p->addr, instruction_pointer(regs), regs->cp0_status);
 #endif

 	/* A dump_stack() here will give a stack backtrace */
@@ -47,16 +54,20 @@ static void handler_post(struct kprobe *p, struct
pt_regs *regs,
 				unsigned long flags)
 {
 #ifdef CONFIG_X86
-	printk(KERN_INFO "post_handler: p->addr =3D 0x%p, flags =3D 0x%lx\n",
-		p->addr, regs->flags);
+	printk(KERN_INFO "post_handler: p->addr =3D 0x%p, ip =3D %lx,"
+			" flags =3D 0x%lx\n",
+		p->addr, instruction_pointer(regs), regs->flags);
 #endif
 #ifdef CONFIG_PPC
-	printk(KERN_INFO "post_handler: p->addr =3D 0x%p, msr =3D 0x%lx\n",
-		p->addr, regs->msr);
+	printk(KERN_INFO "post_handler: p->addr =3D 0x%p, nip =3D 0x%lx,"
+			" msr =3D 0x%lx\n",
+		p->addr, instruction_pointer(regs), regs->msr);
+	dump_stack();
 #endif
 #ifdef CONFIG_MIPS
-	printk(KERN_INFO "post_handler: p->addr =3D 0x%p, status =3D 0x%lx\n",
-		p->addr, regs->cp0_status);
+	printk(KERN_INFO "post_handler: p->addr =3D 0x%p, epc =3D 0x%lx,"
+			" status =3D 0x%lx\n",
+		p->addr, instruction_pointer(regs), regs->cp0_status);
 #endif
 }

@@ -76,6 +87,8 @@ static int handler_fault(struct kprobe *p, struct
pt_regs *regs, int trapnr)
 static int __init kprobe_init(void)
 {
 	int ret;
+	kp.symbol_name =3D func_name;
+	kp.offset =3D offset;
 	kp.pre_handler =3D handler_pre;
 	kp.post_handler =3D handler_post;
 	kp.fault_handler =3D handler_fault;
--=20
1.7.4.1

--20cf30549ff12b416d04a748d9b3
Content-Type: text/x-patch; charset=US-ASCII; 
	name="0001-SAMPLES-kprobe_example-make-it-more-easy-to-use.patch"
Content-Disposition: attachment; 
	filename="0001-SAMPLES-kprobe_example-make-it-more-easy-to-use.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gpq7oo4c0

RnJvbSAxYzU2MDE4ZTc3YTViM2UxM2MzOTQ4YTc0YTc0NDJkMTAzMmE2ZWM4IE1vbiBTZXAgMTcg
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
a3Byb2Jlcy9rcHJvYmVfZXhhbXBsZS5jIHwgICAzNyArKysrKysrKysrKysrKysrKysrKysrKysr
LS0tLS0tLS0tLS0tCiAxIGZpbGVzIGNoYW5nZWQsIDI1IGluc2VydGlvbnMoKyksIDEyIGRlbGV0
aW9ucygtKQoKZGlmZiAtLWdpdCBhL3NhbXBsZXMva3Byb2Jlcy9rcHJvYmVfZXhhbXBsZS5jIGIv
c2FtcGxlcy9rcHJvYmVzL2twcm9iZV9leGFtcGxlLmMKaW5kZXggZWJmNWUwYy4uODM5NGU5OCAx
MDA2NDQKLS0tIGEvc2FtcGxlcy9rcHJvYmVzL2twcm9iZV9leGFtcGxlLmMKKysrIGIvc2FtcGxl
cy9rcHJvYmVzL2twcm9iZV9leGFtcGxlLmMKQEAgLTEzLDExICsxMywxOCBAQAogI2luY2x1ZGUg
PGxpbnV4L2tlcm5lbC5oPgogI2luY2x1ZGUgPGxpbnV4L21vZHVsZS5oPgogI2luY2x1ZGUgPGxp
bnV4L2twcm9iZXMuaD4KKyNpbmNsdWRlIDxsaW51eC9saW1pdHMuaD4KKworc3RhdGljIGNoYXIg
ZnVuY19uYW1lW05BTUVfTUFYXSA9ICJkb19mb3JrIjsKK21vZHVsZV9wYXJhbV9zdHJpbmcoZnVu
YywgZnVuY19uYW1lLCBOQU1FX01BWCwgU19JUlVHTyk7CitNT0RVTEVfUEFSTV9ERVNDKGZ1bmMs
ICJGdW5jdGlvbiB0byBrcHJvYmUiKTsKKworc3RhdGljIHVuc2lnbmVkIGludCBvZmZzZXQ7Citt
b2R1bGVfcGFyYW0ob2Zmc2V0LCB1aW50LCBTX0lSVUdPKTsKK01PRFVMRV9QQVJNX0RFU0Mob2Zm
c2V0LCAiRnVuY3Rpb24gb2Zmc2V0IHRvIGtwcm9iZSIpOwogCiAvKiBGb3IgZWFjaCBwcm9iZSB5
b3UgbmVlZCB0byBhbGxvY2F0ZSBhIGtwcm9iZSBzdHJ1Y3R1cmUgKi8KLXN0YXRpYyBzdHJ1Y3Qg
a3Byb2JlIGtwID0gewotCS5zeW1ib2xfbmFtZQk9ICJkb19mb3JrIiwKLX07CitzdGF0aWMgc3Ry
dWN0IGtwcm9iZSBrcDsKIAogLyoga3Byb2JlIHByZV9oYW5kbGVyOiBjYWxsZWQganVzdCBiZWZv
cmUgdGhlIHByb2JlZCBpbnN0cnVjdGlvbiBpcyBleGVjdXRlZCAqLwogc3RhdGljIGludCBoYW5k
bGVyX3ByZShzdHJ1Y3Qga3Byb2JlICpwLCBzdHJ1Y3QgcHRfcmVncyAqcmVncykKQEAgLTI1LDE3
ICszMiwxNyBAQCBzdGF0aWMgaW50IGhhbmRsZXJfcHJlKHN0cnVjdCBrcHJvYmUgKnAsIHN0cnVj
dCBwdF9yZWdzICpyZWdzKQogI2lmZGVmIENPTkZJR19YODYKIAlwcmludGsoS0VSTl9JTkZPICJw
cmVfaGFuZGxlcjogcC0+YWRkciA9IDB4JXAsIGlwID0gJWx4LCIKIAkJCSIgZmxhZ3MgPSAweCVs
eFxuIiwKLQkJcC0+YWRkciwgcmVncy0+aXAsIHJlZ3MtPmZsYWdzKTsKKwkJcC0+YWRkciwgaW5z
dHJ1Y3Rpb25fcG9pbnRlcihyZWdzKSwgcmVncy0+ZmxhZ3MpOwogI2VuZGlmCiAjaWZkZWYgQ09O
RklHX1BQQwogCXByaW50ayhLRVJOX0lORk8gInByZV9oYW5kbGVyOiBwLT5hZGRyID0gMHglcCwg
bmlwID0gMHglbHgsIgogCQkJIiBtc3IgPSAweCVseFxuIiwKLQkJcC0+YWRkciwgcmVncy0+bmlw
LCByZWdzLT5tc3IpOworCQlwLT5hZGRyLCBpbnN0cnVjdGlvbl9wb2ludGVyKHJlZ3MpLCByZWdz
LT5tc3IpOwogI2VuZGlmCiAjaWZkZWYgQ09ORklHX01JUFMKIAlwcmludGsoS0VSTl9JTkZPICJw
cmVfaGFuZGxlcjogcC0+YWRkciA9IDB4JXAsIGVwYyA9IDB4JWx4LCIKIAkJCSIgc3RhdHVzID0g
MHglbHhcbiIsCi0JCXAtPmFkZHIsIHJlZ3MtPmNwMF9lcGMsIHJlZ3MtPmNwMF9zdGF0dXMpOwor
CQlwLT5hZGRyLCBpbnN0cnVjdGlvbl9wb2ludGVyKHJlZ3MpLCByZWdzLT5jcDBfc3RhdHVzKTsK
ICNlbmRpZgogCiAJLyogQSBkdW1wX3N0YWNrKCkgaGVyZSB3aWxsIGdpdmUgYSBzdGFjayBiYWNr
dHJhY2UgKi8KQEAgLTQ3LDE2ICs1NCwyMCBAQCBzdGF0aWMgdm9pZCBoYW5kbGVyX3Bvc3Qoc3Ry
dWN0IGtwcm9iZSAqcCwgc3RydWN0IHB0X3JlZ3MgKnJlZ3MsCiAJCQkJdW5zaWduZWQgbG9uZyBm
bGFncykKIHsKICNpZmRlZiBDT05GSUdfWDg2Ci0JcHJpbnRrKEtFUk5fSU5GTyAicG9zdF9oYW5k
bGVyOiBwLT5hZGRyID0gMHglcCwgZmxhZ3MgPSAweCVseFxuIiwKLQkJcC0+YWRkciwgcmVncy0+
ZmxhZ3MpOworCXByaW50ayhLRVJOX0lORk8gInBvc3RfaGFuZGxlcjogcC0+YWRkciA9IDB4JXAs
IGlwID0gJWx4LCIKKwkJCSIgZmxhZ3MgPSAweCVseFxuIiwKKwkJcC0+YWRkciwgaW5zdHJ1Y3Rp
b25fcG9pbnRlcihyZWdzKSwgcmVncy0+ZmxhZ3MpOwogI2VuZGlmCiAjaWZkZWYgQ09ORklHX1BQ
QwotCXByaW50ayhLRVJOX0lORk8gInBvc3RfaGFuZGxlcjogcC0+YWRkciA9IDB4JXAsIG1zciA9
IDB4JWx4XG4iLAotCQlwLT5hZGRyLCByZWdzLT5tc3IpOworCXByaW50ayhLRVJOX0lORk8gInBv
c3RfaGFuZGxlcjogcC0+YWRkciA9IDB4JXAsIG5pcCA9IDB4JWx4LCIKKwkJCSIgbXNyID0gMHgl
bHhcbiIsCisJCXAtPmFkZHIsIGluc3RydWN0aW9uX3BvaW50ZXIocmVncyksIHJlZ3MtPm1zcik7
CisJZHVtcF9zdGFjaygpOwogI2VuZGlmCiAjaWZkZWYgQ09ORklHX01JUFMKLQlwcmludGsoS0VS
Tl9JTkZPICJwb3N0X2hhbmRsZXI6IHAtPmFkZHIgPSAweCVwLCBzdGF0dXMgPSAweCVseFxuIiwK
LQkJcC0+YWRkciwgcmVncy0+Y3AwX3N0YXR1cyk7CisJcHJpbnRrKEtFUk5fSU5GTyAicG9zdF9o
YW5kbGVyOiBwLT5hZGRyID0gMHglcCwgZXBjID0gMHglbHgsIgorCQkJIiBzdGF0dXMgPSAweCVs
eFxuIiwKKwkJcC0+YWRkciwgaW5zdHJ1Y3Rpb25fcG9pbnRlcihyZWdzKSwgcmVncy0+Y3AwX3N0
YXR1cyk7CiAjZW5kaWYKIH0KIApAQCAtNzYsNiArODcsOCBAQCBzdGF0aWMgaW50IGhhbmRsZXJf
ZmF1bHQoc3RydWN0IGtwcm9iZSAqcCwgc3RydWN0IHB0X3JlZ3MgKnJlZ3MsIGludCB0cmFwbnIp
CiBzdGF0aWMgaW50IF9faW5pdCBrcHJvYmVfaW5pdCh2b2lkKQogewogCWludCByZXQ7CisJa3Au
c3ltYm9sX25hbWUgPSBmdW5jX25hbWU7CisJa3Aub2Zmc2V0ID0gb2Zmc2V0OwogCWtwLnByZV9o
YW5kbGVyID0gaGFuZGxlcl9wcmU7CiAJa3AucG9zdF9oYW5kbGVyID0gaGFuZGxlcl9wb3N0Owog
CWtwLmZhdWx0X2hhbmRsZXIgPSBoYW5kbGVyX2ZhdWx0OwotLSAKMS43LjQuMQoK
--20cf30549ff12b416d04a748d9b3--
