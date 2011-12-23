Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756622Ab1LWKcY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Dec 2011 05:32:24 -0500
Received: from mga11.intel.com ([192.55.52.93]:3174 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753723Ab1LWKcV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Dec 2011 05:32:21 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208,223";a="99639976"
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
Subject: [PATCH 10/10] Xen: update pcpu online/offline logic
Thread-Topic: [PATCH 10/10] Xen: update pcpu online/offline logic
Thread-Index: AczBXiHCEJQO+tSfSs+gjKRmoi953Q==
Date: Fri, 23 Dec 2011 10:32:12 +0000
Message-ID: <DE8DF0795D48FD4CA783C40EC82923359771@SHSMSX101.ccr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: multipart/mixed;
	boundary="_002_DE8DF0795D48FD4CA783C40EC82923359771SHSMSX101ccrcorpint_"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--_002_DE8DF0795D48FD4CA783C40EC82923359771SHSMSX101ccrcorpint_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

>From 1e59d2ec2ff93b42c86d18c7cc9432ca2172a795 Mon Sep 17 00:00:00 2001
From: Liu Jinsong <jinsong.liu@intel.com>
Date: Wed, 14 Dec 2011 21:06:11 +0800
Subject: [PATCH 10/10] Xen: update pcpu online/offline logic

This patch update pcpu online/offline logic.

It closes cpu0's /sys/.../xen_pcpu0/online authority to user.
It also simplifies pcpu sync by removing redundant logic.

Signed-off-by: Liu, Jinsong <jinsong.liu@intel.com>
Signed-off-by: Jiang, Yunhong <yunhong.jiang@intel.com>
---
 drivers/xen/pcpu.c |   71 ++++++++++++++----------------------------------=
----
 1 files changed, 19 insertions(+), 52 deletions(-)

diff --git a/drivers/xen/pcpu.c b/drivers/xen/pcpu.c
index 6d1a770..1d32784 100644
--- a/drivers/xen/pcpu.c
+++ b/drivers/xen/pcpu.c
@@ -24,7 +24,6 @@ static RAW_NOTIFIER_HEAD(xen_pcpu_chain);
=20
 struct xen_pcpus {
 	struct list_head list;
-	int present;
 };
 static struct xen_pcpus xen_pcpus;
=20
@@ -189,9 +188,13 @@ static int pcpu_sysdev_init(struct pcpu *cpu)
 		kfree(cpu);
 		return -1;
 	}
-	sysdev_create_file(&cpu->sysdev, &attr_online);
 	sysdev_create_file(&cpu->sysdev, &attr_apic_id);
 	sysdev_create_file(&cpu->sysdev, &attr_acpi_id);
+
+	/* Not open cpu0 online access to user */
+	if (cpu->sysdev.id)
+		sysdev_create_file(&cpu->sysdev, &attr_online);
+
 	return 0;
 }
=20
@@ -239,17 +242,10 @@ static struct pcpu *init_pcpu(struct xenpf_pcpuinfo *=
info)
 	return pcpu;
 }
=20
-#define PCPU_NO_CHANGE			0
-#define PCPU_ADDED			1
-#define PCPU_ONLINE_OFFLINE		2
-#define PCPU_REMOVED			3
 /*
  * Caller should hold the pcpu lock
- * < 0: Something wrong
- * 0: No changes
- * > 0: State changed
  */
-static struct pcpu *_sync_pcpu(int cpu_num, int *max_id, int *result)
+static int _sync_pcpu(int cpu_num, int *max_id)
 {
 	struct pcpu *pcpu =3D NULL;
 	struct xenpf_pcpuinfo *info;
@@ -259,14 +255,12 @@ static struct pcpu *_sync_pcpu(int cpu_num, int *max_=
id, int *result)
 	};
 	int ret;
=20
-	*result =3D -1;
-
 	info =3D &op.u.pcpu_info;
 	info->xen_cpuid =3D cpu_num;
=20
 	ret =3D HYPERVISOR_dom0_op(&op);
 	if (ret)
-		return NULL;
+		return -1;
=20
 	if (max_id)
 		*max_id =3D op.u.pcpu_info.max_present;
@@ -275,28 +269,24 @@ static struct pcpu *_sync_pcpu(int cpu_num, int *max_=
id, int *result)
=20
 	if (info->flags & XEN_PCPU_FLAGS_INVALID) {
 		/* The pcpu has been removed */
-		*result =3D PCPU_NO_CHANGE;
 		if (pcpu) {
 			raw_notifier_call_chain(&xen_pcpu_chain,
 			  XEN_PCPU_REMOVE,
 			  (void *)(long)pcpu->xen_id);
 			xen_pcpu_free(pcpu);
-			*result =3D PCPU_REMOVED;
 		}
-		return NULL;
+		return 0;
 	}
=20
=20
 	if (!pcpu) {
-		*result =3D PCPU_ADDED;
 		pcpu =3D init_pcpu(info);
 		if (pcpu =3D=3D NULL) {
 			printk(KERN_WARNING "Failed to init pcpu %x\n",
 			  info->xen_cpuid);
-			  *result =3D -1;
+			return -1;
 		}
 	} else {
-		*result =3D PCPU_NO_CHANGE;
 		/*
 		 * Old PCPU is replaced with a new pcpu, this means
 		 * several virq is missed, will it happen?
@@ -307,10 +297,10 @@ static struct pcpu *_sync_pcpu(int cpu_num, int *max_=
id, int *result)
 			pcpu->apic_id =3D info->apic_id;
 			pcpu->acpi_id =3D info->acpi_id;
 		}
-		if (xen_pcpu_online_check(info, pcpu))
-			*result =3D PCPU_ONLINE_OFFLINE;
+		xen_pcpu_online_check(info, pcpu);
 	}
-	return pcpu;
+
+	return 0;
 }
=20
 int xen_pcpu_index(uint32_t id, int is_acpiid)
@@ -353,50 +343,27 @@ static int xen_sync_pcpus(void)
 	/*
 	 * Boot cpu always have cpu_id 0 in xen
 	 */
-	int cpu_num =3D 0, max_id =3D 0, result =3D 0, present =3D 0;
+	int cpu_num =3D 0, max_id =3D 0, ret =3D 0;
 	struct list_head *elem, *tmp;
 	struct pcpu *pcpu;
=20
 	get_pcpu_lock();
=20
-	while ((result >=3D 0) && (cpu_num <=3D max_id)) {
-		pcpu =3D _sync_pcpu(cpu_num, &max_id, &result);
-
-		printk(KERN_DEBUG "sync cpu %x get result %x max_id %x\n",
-			cpu_num, result, max_id);
-
-		switch (result)	{
-		case PCPU_NO_CHANGE:
-			if (pcpu)
-				present++;
-			break;
-		case PCPU_ADDED:
-		case PCPU_ONLINE_OFFLINE:
-			present++;
-		case PCPU_REMOVED:
-			break;
-		default:
-			printk(KERN_WARNING "Failed to sync pcpu %x\n",
-			  cpu_num);
-			break;
-
-		}
+	while (!ret && (cpu_num <=3D max_id)) {
+		ret =3D _sync_pcpu(cpu_num, &max_id);
 		cpu_num++;
 	}
=20
-	if (result < 0) {
+	if (ret < 0) {
 		list_for_each_safe(elem, tmp, &xen_pcpus.list) {
 			pcpu =3D list_entry(elem, struct pcpu, pcpu_list);
 			xen_pcpu_free(pcpu);
 		}
-		present =3D 0;
 	}
=20
-	xen_pcpus.present =3D present;
-
 	put_pcpu_lock();
=20
-	return 0;
+	return ret;
 }
=20
 static void xen_pcpu_dpc(struct work_struct *work)
@@ -436,10 +403,10 @@ static int __init xen_pcpu_init(void)
 	}
=20
 	INIT_LIST_HEAD(&xen_pcpus.list);
-	xen_pcpus.present =3D 0;
=20
 	xen_sync_pcpus();
-	if (xen_pcpus.present > 0)
+
+	if (!list_empty(&xen_pcpus.list))
 		err =3D bind_virq_to_irqhandler(VIRQ_PCPU_STATE,
 			0, xen_pcpu_interrupt, 0, "pcpu", NULL);
 	if (err < 0)
--=20
1.6.5.6

--_002_DE8DF0795D48FD4CA783C40EC82923359771SHSMSX101ccrcorpint_
Content-Type: application/octet-stream;
	name="0010-Xen-update-pcpu-online-offline-logic.patch"
Content-Description: 0010-Xen-update-pcpu-online-offline-logic.patch
Content-Disposition: attachment;
	filename="0010-Xen-update-pcpu-online-offline-logic.patch"; size=4793;
	creation-date="Wed, 14 Dec 2011 15:20:15 GMT";
	modification-date="Wed, 14 Dec 2011 15:03:34 GMT"
Content-Transfer-Encoding: base64

RnJvbSAxZTU5ZDJlYzJmZjkzYjQyYzg2ZDE4YzdjYzk0MzJjYTIxNzJhNzk1IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBMaXUgSmluc29uZyA8amluc29uZy5saXVAaW50ZWwuY29tPgpE
YXRlOiBXZWQsIDE0IERlYyAyMDExIDIxOjA2OjExICswODAwClN1YmplY3Q6IFtQQVRDSCAxMC8x
MF0gWGVuOiB1cGRhdGUgcGNwdSBvbmxpbmUvb2ZmbGluZSBsb2dpYwoKVGhpcyBwYXRjaCB1cGRh
dGUgcGNwdSBvbmxpbmUvb2ZmbGluZSBsb2dpYy4KCkl0IGNsb3NlcyBjcHUwJ3MgL3N5cy8uLi4v
eGVuX3BjcHUwL29ubGluZSBhdXRob3JpdHkgdG8gdXNlci4KSXQgYWxzbyBzaW1wbGlmaWVzIHBj
cHUgc3luYyBieSByZW1vdmluZyByZWR1bmRhbnQgbG9naWMuCgpTaWduZWQtb2ZmLWJ5OiBMaXUs
IEppbnNvbmcgPGppbnNvbmcubGl1QGludGVsLmNvbT4KU2lnbmVkLW9mZi1ieTogSmlhbmcsIFl1
bmhvbmcgPHl1bmhvbmcuamlhbmdAaW50ZWwuY29tPgotLS0KIGRyaXZlcnMveGVuL3BjcHUuYyB8
ICAgNzEgKysrKysrKysrKysrKystLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LQogMSBmaWxlcyBjaGFuZ2VkLCAxOSBpbnNlcnRpb25zKCspLCA1MiBkZWxldGlvbnMoLSkKCmRp
ZmYgLS1naXQgYS9kcml2ZXJzL3hlbi9wY3B1LmMgYi9kcml2ZXJzL3hlbi9wY3B1LmMKaW5kZXgg
NmQxYTc3MC4uMWQzMjc4NCAxMDA2NDQKLS0tIGEvZHJpdmVycy94ZW4vcGNwdS5jCisrKyBiL2Ry
aXZlcnMveGVuL3BjcHUuYwpAQCAtMjQsNyArMjQsNiBAQCBzdGF0aWMgUkFXX05PVElGSUVSX0hF
QUQoeGVuX3BjcHVfY2hhaW4pOwogCiBzdHJ1Y3QgeGVuX3BjcHVzIHsKIAlzdHJ1Y3QgbGlzdF9o
ZWFkIGxpc3Q7Ci0JaW50IHByZXNlbnQ7CiB9Owogc3RhdGljIHN0cnVjdCB4ZW5fcGNwdXMgeGVu
X3BjcHVzOwogCkBAIC0xODksOSArMTg4LDEzIEBAIHN0YXRpYyBpbnQgcGNwdV9zeXNkZXZfaW5p
dChzdHJ1Y3QgcGNwdSAqY3B1KQogCQlrZnJlZShjcHUpOwogCQlyZXR1cm4gLTE7CiAJfQotCXN5
c2Rldl9jcmVhdGVfZmlsZSgmY3B1LT5zeXNkZXYsICZhdHRyX29ubGluZSk7CiAJc3lzZGV2X2Ny
ZWF0ZV9maWxlKCZjcHUtPnN5c2RldiwgJmF0dHJfYXBpY19pZCk7CiAJc3lzZGV2X2NyZWF0ZV9m
aWxlKCZjcHUtPnN5c2RldiwgJmF0dHJfYWNwaV9pZCk7CisKKwkvKiBOb3Qgb3BlbiBjcHUwIG9u
bGluZSBhY2Nlc3MgdG8gdXNlciAqLworCWlmIChjcHUtPnN5c2Rldi5pZCkKKwkJc3lzZGV2X2Ny
ZWF0ZV9maWxlKCZjcHUtPnN5c2RldiwgJmF0dHJfb25saW5lKTsKKwogCXJldHVybiAwOwogfQog
CkBAIC0yMzksMTcgKzI0MiwxMCBAQCBzdGF0aWMgc3RydWN0IHBjcHUgKmluaXRfcGNwdShzdHJ1
Y3QgeGVucGZfcGNwdWluZm8gKmluZm8pCiAJcmV0dXJuIHBjcHU7CiB9CiAKLSNkZWZpbmUgUENQ
VV9OT19DSEFOR0UJCQkwCi0jZGVmaW5lIFBDUFVfQURERUQJCQkxCi0jZGVmaW5lIFBDUFVfT05M
SU5FX09GRkxJTkUJCTIKLSNkZWZpbmUgUENQVV9SRU1PVkVECQkJMwogLyoKICAqIENhbGxlciBz
aG91bGQgaG9sZCB0aGUgcGNwdSBsb2NrCi0gKiA8IDA6IFNvbWV0aGluZyB3cm9uZwotICogMDog
Tm8gY2hhbmdlcwotICogPiAwOiBTdGF0ZSBjaGFuZ2VkCiAgKi8KLXN0YXRpYyBzdHJ1Y3QgcGNw
dSAqX3N5bmNfcGNwdShpbnQgY3B1X251bSwgaW50ICptYXhfaWQsIGludCAqcmVzdWx0KQorc3Rh
dGljIGludCBfc3luY19wY3B1KGludCBjcHVfbnVtLCBpbnQgKm1heF9pZCkKIHsKIAlzdHJ1Y3Qg
cGNwdSAqcGNwdSA9IE5VTEw7CiAJc3RydWN0IHhlbnBmX3BjcHVpbmZvICppbmZvOwpAQCAtMjU5
LDE0ICsyNTUsMTIgQEAgc3RhdGljIHN0cnVjdCBwY3B1ICpfc3luY19wY3B1KGludCBjcHVfbnVt
LCBpbnQgKm1heF9pZCwgaW50ICpyZXN1bHQpCiAJfTsKIAlpbnQgcmV0OwogCi0JKnJlc3VsdCA9
IC0xOwotCiAJaW5mbyA9ICZvcC51LnBjcHVfaW5mbzsKIAlpbmZvLT54ZW5fY3B1aWQgPSBjcHVf
bnVtOwogCiAJcmV0ID0gSFlQRVJWSVNPUl9kb20wX29wKCZvcCk7CiAJaWYgKHJldCkKLQkJcmV0
dXJuIE5VTEw7CisJCXJldHVybiAtMTsKIAogCWlmIChtYXhfaWQpCiAJCSptYXhfaWQgPSBvcC51
LnBjcHVfaW5mby5tYXhfcHJlc2VudDsKQEAgLTI3NSwyOCArMjY5LDI0IEBAIHN0YXRpYyBzdHJ1
Y3QgcGNwdSAqX3N5bmNfcGNwdShpbnQgY3B1X251bSwgaW50ICptYXhfaWQsIGludCAqcmVzdWx0
KQogCiAJaWYgKGluZm8tPmZsYWdzICYgWEVOX1BDUFVfRkxBR1NfSU5WQUxJRCkgewogCQkvKiBU
aGUgcGNwdSBoYXMgYmVlbiByZW1vdmVkICovCi0JCSpyZXN1bHQgPSBQQ1BVX05PX0NIQU5HRTsK
IAkJaWYgKHBjcHUpIHsKIAkJCXJhd19ub3RpZmllcl9jYWxsX2NoYWluKCZ4ZW5fcGNwdV9jaGFp
biwKIAkJCSAgWEVOX1BDUFVfUkVNT1ZFLAogCQkJICAodm9pZCAqKShsb25nKXBjcHUtPnhlbl9p
ZCk7CiAJCQl4ZW5fcGNwdV9mcmVlKHBjcHUpOwotCQkJKnJlc3VsdCA9IFBDUFVfUkVNT1ZFRDsK
IAkJfQotCQlyZXR1cm4gTlVMTDsKKwkJcmV0dXJuIDA7CiAJfQogCiAKIAlpZiAoIXBjcHUpIHsK
LQkJKnJlc3VsdCA9IFBDUFVfQURERUQ7CiAJCXBjcHUgPSBpbml0X3BjcHUoaW5mbyk7CiAJCWlm
IChwY3B1ID09IE5VTEwpIHsKIAkJCXByaW50ayhLRVJOX1dBUk5JTkcgIkZhaWxlZCB0byBpbml0
IHBjcHUgJXhcbiIsCiAJCQkgIGluZm8tPnhlbl9jcHVpZCk7Ci0JCQkgICpyZXN1bHQgPSAtMTsK
KwkJCXJldHVybiAtMTsKIAkJfQogCX0gZWxzZSB7Ci0JCSpyZXN1bHQgPSBQQ1BVX05PX0NIQU5H
RTsKIAkJLyoKIAkJICogT2xkIFBDUFUgaXMgcmVwbGFjZWQgd2l0aCBhIG5ldyBwY3B1LCB0aGlz
IG1lYW5zCiAJCSAqIHNldmVyYWwgdmlycSBpcyBtaXNzZWQsIHdpbGwgaXQgaGFwcGVuPwpAQCAt
MzA3LDEwICsyOTcsMTAgQEAgc3RhdGljIHN0cnVjdCBwY3B1ICpfc3luY19wY3B1KGludCBjcHVf
bnVtLCBpbnQgKm1heF9pZCwgaW50ICpyZXN1bHQpCiAJCQlwY3B1LT5hcGljX2lkID0gaW5mby0+
YXBpY19pZDsKIAkJCXBjcHUtPmFjcGlfaWQgPSBpbmZvLT5hY3BpX2lkOwogCQl9Ci0JCWlmICh4
ZW5fcGNwdV9vbmxpbmVfY2hlY2soaW5mbywgcGNwdSkpCi0JCQkqcmVzdWx0ID0gUENQVV9PTkxJ
TkVfT0ZGTElORTsKKwkJeGVuX3BjcHVfb25saW5lX2NoZWNrKGluZm8sIHBjcHUpOwogCX0KLQly
ZXR1cm4gcGNwdTsKKworCXJldHVybiAwOwogfQogCiBpbnQgeGVuX3BjcHVfaW5kZXgodWludDMy
X3QgaWQsIGludCBpc19hY3BpaWQpCkBAIC0zNTMsNTAgKzM0MywyNyBAQCBzdGF0aWMgaW50IHhl
bl9zeW5jX3BjcHVzKHZvaWQpCiAJLyoKIAkgKiBCb290IGNwdSBhbHdheXMgaGF2ZSBjcHVfaWQg
MCBpbiB4ZW4KIAkgKi8KLQlpbnQgY3B1X251bSA9IDAsIG1heF9pZCA9IDAsIHJlc3VsdCA9IDAs
IHByZXNlbnQgPSAwOworCWludCBjcHVfbnVtID0gMCwgbWF4X2lkID0gMCwgcmV0ID0gMDsKIAlz
dHJ1Y3QgbGlzdF9oZWFkICplbGVtLCAqdG1wOwogCXN0cnVjdCBwY3B1ICpwY3B1OwogCiAJZ2V0
X3BjcHVfbG9jaygpOwogCi0Jd2hpbGUgKChyZXN1bHQgPj0gMCkgJiYgKGNwdV9udW0gPD0gbWF4
X2lkKSkgewotCQlwY3B1ID0gX3N5bmNfcGNwdShjcHVfbnVtLCAmbWF4X2lkLCAmcmVzdWx0KTsK
LQotCQlwcmludGsoS0VSTl9ERUJVRyAic3luYyBjcHUgJXggZ2V0IHJlc3VsdCAleCBtYXhfaWQg
JXhcbiIsCi0JCQljcHVfbnVtLCByZXN1bHQsIG1heF9pZCk7Ci0KLQkJc3dpdGNoIChyZXN1bHQp
CXsKLQkJY2FzZSBQQ1BVX05PX0NIQU5HRToKLQkJCWlmIChwY3B1KQotCQkJCXByZXNlbnQrKzsK
LQkJCWJyZWFrOwotCQljYXNlIFBDUFVfQURERUQ6Ci0JCWNhc2UgUENQVV9PTkxJTkVfT0ZGTElO
RToKLQkJCXByZXNlbnQrKzsKLQkJY2FzZSBQQ1BVX1JFTU9WRUQ6Ci0JCQlicmVhazsKLQkJZGVm
YXVsdDoKLQkJCXByaW50ayhLRVJOX1dBUk5JTkcgIkZhaWxlZCB0byBzeW5jIHBjcHUgJXhcbiIs
Ci0JCQkgIGNwdV9udW0pOwotCQkJYnJlYWs7Ci0KLQkJfQorCXdoaWxlICghcmV0ICYmIChjcHVf
bnVtIDw9IG1heF9pZCkpIHsKKwkJcmV0ID0gX3N5bmNfcGNwdShjcHVfbnVtLCAmbWF4X2lkKTsK
IAkJY3B1X251bSsrOwogCX0KIAotCWlmIChyZXN1bHQgPCAwKSB7CisJaWYgKHJldCA8IDApIHsK
IAkJbGlzdF9mb3JfZWFjaF9zYWZlKGVsZW0sIHRtcCwgJnhlbl9wY3B1cy5saXN0KSB7CiAJCQlw
Y3B1ID0gbGlzdF9lbnRyeShlbGVtLCBzdHJ1Y3QgcGNwdSwgcGNwdV9saXN0KTsKIAkJCXhlbl9w
Y3B1X2ZyZWUocGNwdSk7CiAJCX0KLQkJcHJlc2VudCA9IDA7CiAJfQogCi0JeGVuX3BjcHVzLnBy
ZXNlbnQgPSBwcmVzZW50OwotCiAJcHV0X3BjcHVfbG9jaygpOwogCi0JcmV0dXJuIDA7CisJcmV0
dXJuIHJldDsKIH0KIAogc3RhdGljIHZvaWQgeGVuX3BjcHVfZHBjKHN0cnVjdCB3b3JrX3N0cnVj
dCAqd29yaykKQEAgLTQzNiwxMCArNDAzLDEwIEBAIHN0YXRpYyBpbnQgX19pbml0IHhlbl9wY3B1
X2luaXQodm9pZCkKIAl9CiAKIAlJTklUX0xJU1RfSEVBRCgmeGVuX3BjcHVzLmxpc3QpOwotCXhl
bl9wY3B1cy5wcmVzZW50ID0gMDsKIAogCXhlbl9zeW5jX3BjcHVzKCk7Ci0JaWYgKHhlbl9wY3B1
cy5wcmVzZW50ID4gMCkKKworCWlmICghbGlzdF9lbXB0eSgmeGVuX3BjcHVzLmxpc3QpKQogCQll
cnIgPSBiaW5kX3ZpcnFfdG9faXJxaGFuZGxlcihWSVJRX1BDUFVfU1RBVEUsCiAJCQkwLCB4ZW5f
cGNwdV9pbnRlcnJ1cHQsIDAsICJwY3B1IiwgTlVMTCk7CiAJaWYgKGVyciA8IDApCi0tIAoxLjYu
NS42Cgo=

--_002_DE8DF0795D48FD4CA783C40EC82923359771SHSMSX101ccrcorpint_--
