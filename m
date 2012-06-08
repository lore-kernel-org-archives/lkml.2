Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934159Ab2FHJhU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 05:37:20 -0400
Received: from mga03.intel.com ([143.182.124.21]:40040 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759779Ab2FHJhS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 05:37:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208,223";a="109492289"
From: "Liu, Jinsong" <jinsong.liu@intel.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Borislav Petkov <bp@amd64.org>, "Luck, Tony" <tony.luck@intel.com>,
        "'xen-devel@lists.xensource.com'" <xen-devel@lists.xensource.com>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>
Subject: [PATCH] xen/mce: Add mutex lock and buffer to avoid sleep in atomic
 context
Thread-Topic: [PATCH] xen/mce: Add mutex lock and buffer to avoid sleep in
 atomic context
Thread-Index: Ac1FWkRWxEyD+XUzS/eqorQpXCRDrw==
Date: Fri, 8 Jun 2012 09:37:06 +0000
Message-ID: <DE8DF0795D48FD4CA783C40EC8292335221654@SHSMSX101.ccr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: multipart/mixed;
	boundary="_002_DE8DF0795D48FD4CA783C40EC8292335221654SHSMSX101ccrcorpi_"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--_002_DE8DF0795D48FD4CA783C40EC8292335221654SHSMSX101ccrcorpi_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

>From a9c5f29330a056291356b912816b5b2e0e061a30 Mon Sep 17 00:00:00 2001
From: Liu, Jinsong <jinsong.liu@intel.com>
Date: Sat, 9 Jun 2012 00:56:46 +0800
Subject: [PATCH] xen/mce: Add mutex lock and buffer to avoid sleep in atomi=
c context

copy_to_user might sleep and print a stack trace if it is executed
in an atomic spinlock context. This patch add a mutex lock and a
buffer to avoid the case.

Reported-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: Liu, Jinsong <jinsong.liu@intel.com>
---
 drivers/xen/mcelog.c |   20 ++++++++++++++++----
 1 files changed, 16 insertions(+), 4 deletions(-)

diff --git a/drivers/xen/mcelog.c b/drivers/xen/mcelog.c
index 72e87d2..4046f01 100644
--- a/drivers/xen/mcelog.c
+++ b/drivers/xen/mcelog.c
@@ -56,12 +56,14 @@ static struct mcinfo_logical_cpu *g_physinfo;
 static uint32_t ncpus;
=20
 static DEFINE_SPINLOCK(mcelog_lock);
+static DEFINE_MUTEX(xen_mce_chrdev_read_mutex);
=20
 static struct xen_mce_log xen_mcelog =3D {
 	.signature	=3D XEN_MCE_LOG_SIGNATURE,
 	.len		=3D XEN_MCE_LOG_LEN,
 	.recordlen	=3D sizeof(struct xen_mce),
 };
+static struct xen_mce_log xen_mcelog_u;
=20
 static DEFINE_SPINLOCK(xen_mce_chrdev_state_lock);
 static int xen_mce_chrdev_open_count;	/* #times opened */
@@ -99,6 +101,10 @@ static int xen_mce_chrdev_release(struct inode *inode, =
struct file *file)
 	return 0;
 }
=20
+/*
+ * copy_to_user might sleep and print a stack trace
+ * if it is executed in an atomic spinlock context
+ */
 static ssize_t xen_mce_chrdev_read(struct file *filp, char __user *ubuf,
 				size_t usize, loff_t *off)
 {
@@ -106,9 +112,15 @@ static ssize_t xen_mce_chrdev_read(struct file *filp, =
char __user *ubuf,
 	unsigned num;
 	int i, err;
=20
+	mutex_lock(&xen_mce_chrdev_read_mutex);
+
 	spin_lock(&mcelog_lock);
+	memcpy(&xen_mcelog_u, &xen_mcelog, sizeof(struct xen_mce_log));
=20
 	num =3D xen_mcelog.next;
+	memset(xen_mcelog.entry, 0, num * sizeof(struct xen_mce));
+	xen_mcelog.next =3D 0;
+	spin_unlock(&mcelog_lock);
=20
 	/* Only supports full reads right now */
 	err =3D -EINVAL;
@@ -117,20 +129,20 @@ static ssize_t xen_mce_chrdev_read(struct file *filp,=
 char __user *ubuf,
=20
 	err =3D 0;
 	for (i =3D 0; i < num; i++) {
-		struct xen_mce *m =3D &xen_mcelog.entry[i];
+		struct xen_mce *m =3D &xen_mcelog_u.entry[i];
=20
 		err |=3D copy_to_user(buf, m, sizeof(*m));
 		buf +=3D sizeof(*m);
 	}
=20
-	memset(xen_mcelog.entry, 0, num * sizeof(struct xen_mce));
-	xen_mcelog.next =3D 0;
+	memset(xen_mcelog_u.entry, 0, num * sizeof(struct xen_mce));
+	xen_mcelog_u.next =3D 0;
=20
 	if (err)
 		err =3D -EFAULT;
=20
 out:
-	spin_unlock(&mcelog_lock);
+	mutex_unlock(&xen_mce_chrdev_read_mutex);
=20
 	return err ? err : buf - ubuf;
 }
--=20
1.7.1

--_002_DE8DF0795D48FD4CA783C40EC8292335221654SHSMSX101ccrcorpi_
Content-Type: application/octet-stream;
	name="0001-xen-mce-Add-mutex-lock-and-buffer-to-avoid-sleep-in-.patch"
Content-Description: 0001-xen-mce-Add-mutex-lock-and-buffer-to-avoid-sleep-in-.patch
Content-Disposition: attachment;
	filename="0001-xen-mce-Add-mutex-lock-and-buffer-to-avoid-sleep-in-.patch";
	size=2676; creation-date="Fri, 08 Jun 2012 09:28:53 GMT";
	modification-date="Fri, 08 Jun 2012 17:07:04 GMT"
Content-Transfer-Encoding: base64

RnJvbSBhOWM1ZjI5MzMwYTA1NjI5MTM1NmI5MTI4MTZiNWIyZTBlMDYxYTMwIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBMaXUsIEppbnNvbmcgPGppbnNvbmcubGl1QGludGVsLmNvbT4K
RGF0ZTogU2F0LCA5IEp1biAyMDEyIDAwOjU2OjQ2ICswODAwClN1YmplY3Q6IFtQQVRDSF0geGVu
L21jZTogQWRkIG11dGV4IGxvY2sgYW5kIGJ1ZmZlciB0byBhdm9pZCBzbGVlcCBpbiBhdG9taWMg
Y29udGV4dAoKY29weV90b191c2VyIG1pZ2h0IHNsZWVwIGFuZCBwcmludCBhIHN0YWNrIHRyYWNl
IGlmIGl0IGlzIGV4ZWN1dGVkCmluIGFuIGF0b21pYyBzcGlubG9jayBjb250ZXh0LiBUaGlzIHBh
dGNoIGFkZCBhIG11dGV4IGxvY2sgYW5kIGEKYnVmZmVyIHRvIGF2b2lkIHRoZSBjYXNlLgoKUmVw
b3J0ZWQtYnk6IEtvbnJhZCBSemVzenV0ZWsgV2lsayA8a29ucmFkLndpbGtAb3JhY2xlLmNvbT4K
U2lnbmVkLW9mZi1ieTogTGl1LCBKaW5zb25nIDxqaW5zb25nLmxpdUBpbnRlbC5jb20+Ci0tLQog
ZHJpdmVycy94ZW4vbWNlbG9nLmMgfCAgIDIwICsrKysrKysrKysrKysrKystLS0tCiAxIGZpbGVz
IGNoYW5nZWQsIDE2IGluc2VydGlvbnMoKyksIDQgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEv
ZHJpdmVycy94ZW4vbWNlbG9nLmMgYi9kcml2ZXJzL3hlbi9tY2Vsb2cuYwppbmRleCA3MmU4N2Qy
Li40MDQ2ZjAxIDEwMDY0NAotLS0gYS9kcml2ZXJzL3hlbi9tY2Vsb2cuYworKysgYi9kcml2ZXJz
L3hlbi9tY2Vsb2cuYwpAQCAtNTYsMTIgKzU2LDE0IEBAIHN0YXRpYyBzdHJ1Y3QgbWNpbmZvX2xv
Z2ljYWxfY3B1ICpnX3BoeXNpbmZvOwogc3RhdGljIHVpbnQzMl90IG5jcHVzOwogCiBzdGF0aWMg
REVGSU5FX1NQSU5MT0NLKG1jZWxvZ19sb2NrKTsKK3N0YXRpYyBERUZJTkVfTVVURVgoeGVuX21j
ZV9jaHJkZXZfcmVhZF9tdXRleCk7CiAKIHN0YXRpYyBzdHJ1Y3QgeGVuX21jZV9sb2cgeGVuX21j
ZWxvZyA9IHsKIAkuc2lnbmF0dXJlCT0gWEVOX01DRV9MT0dfU0lHTkFUVVJFLAogCS5sZW4JCT0g
WEVOX01DRV9MT0dfTEVOLAogCS5yZWNvcmRsZW4JPSBzaXplb2Yoc3RydWN0IHhlbl9tY2UpLAog
fTsKK3N0YXRpYyBzdHJ1Y3QgeGVuX21jZV9sb2cgeGVuX21jZWxvZ191OwogCiBzdGF0aWMgREVG
SU5FX1NQSU5MT0NLKHhlbl9tY2VfY2hyZGV2X3N0YXRlX2xvY2spOwogc3RhdGljIGludCB4ZW5f
bWNlX2NocmRldl9vcGVuX2NvdW50OwkvKiAjdGltZXMgb3BlbmVkICovCkBAIC05OSw2ICsxMDEs
MTAgQEAgc3RhdGljIGludCB4ZW5fbWNlX2NocmRldl9yZWxlYXNlKHN0cnVjdCBpbm9kZSAqaW5v
ZGUsIHN0cnVjdCBmaWxlICpmaWxlKQogCXJldHVybiAwOwogfQogCisvKgorICogY29weV90b191
c2VyIG1pZ2h0IHNsZWVwIGFuZCBwcmludCBhIHN0YWNrIHRyYWNlCisgKiBpZiBpdCBpcyBleGVj
dXRlZCBpbiBhbiBhdG9taWMgc3BpbmxvY2sgY29udGV4dAorICovCiBzdGF0aWMgc3NpemVfdCB4
ZW5fbWNlX2NocmRldl9yZWFkKHN0cnVjdCBmaWxlICpmaWxwLCBjaGFyIF9fdXNlciAqdWJ1ZiwK
IAkJCQlzaXplX3QgdXNpemUsIGxvZmZfdCAqb2ZmKQogewpAQCAtMTA2LDkgKzExMiwxNSBAQCBz
dGF0aWMgc3NpemVfdCB4ZW5fbWNlX2NocmRldl9yZWFkKHN0cnVjdCBmaWxlICpmaWxwLCBjaGFy
IF9fdXNlciAqdWJ1ZiwKIAl1bnNpZ25lZCBudW07CiAJaW50IGksIGVycjsKIAorCW11dGV4X2xv
Y2soJnhlbl9tY2VfY2hyZGV2X3JlYWRfbXV0ZXgpOworCiAJc3Bpbl9sb2NrKCZtY2Vsb2dfbG9j
ayk7CisJbWVtY3B5KCZ4ZW5fbWNlbG9nX3UsICZ4ZW5fbWNlbG9nLCBzaXplb2Yoc3RydWN0IHhl
bl9tY2VfbG9nKSk7CiAKIAludW0gPSB4ZW5fbWNlbG9nLm5leHQ7CisJbWVtc2V0KHhlbl9tY2Vs
b2cuZW50cnksIDAsIG51bSAqIHNpemVvZihzdHJ1Y3QgeGVuX21jZSkpOworCXhlbl9tY2Vsb2cu
bmV4dCA9IDA7CisJc3Bpbl91bmxvY2soJm1jZWxvZ19sb2NrKTsKIAogCS8qIE9ubHkgc3VwcG9y
dHMgZnVsbCByZWFkcyByaWdodCBub3cgKi8KIAllcnIgPSAtRUlOVkFMOwpAQCAtMTE3LDIwICsx
MjksMjAgQEAgc3RhdGljIHNzaXplX3QgeGVuX21jZV9jaHJkZXZfcmVhZChzdHJ1Y3QgZmlsZSAq
ZmlscCwgY2hhciBfX3VzZXIgKnVidWYsCiAKIAllcnIgPSAwOwogCWZvciAoaSA9IDA7IGkgPCBu
dW07IGkrKykgewotCQlzdHJ1Y3QgeGVuX21jZSAqbSA9ICZ4ZW5fbWNlbG9nLmVudHJ5W2ldOwor
CQlzdHJ1Y3QgeGVuX21jZSAqbSA9ICZ4ZW5fbWNlbG9nX3UuZW50cnlbaV07CiAKIAkJZXJyIHw9
IGNvcHlfdG9fdXNlcihidWYsIG0sIHNpemVvZigqbSkpOwogCQlidWYgKz0gc2l6ZW9mKCptKTsK
IAl9CiAKLQltZW1zZXQoeGVuX21jZWxvZy5lbnRyeSwgMCwgbnVtICogc2l6ZW9mKHN0cnVjdCB4
ZW5fbWNlKSk7Ci0JeGVuX21jZWxvZy5uZXh0ID0gMDsKKwltZW1zZXQoeGVuX21jZWxvZ191LmVu
dHJ5LCAwLCBudW0gKiBzaXplb2Yoc3RydWN0IHhlbl9tY2UpKTsKKwl4ZW5fbWNlbG9nX3UubmV4
dCA9IDA7CiAKIAlpZiAoZXJyKQogCQllcnIgPSAtRUZBVUxUOwogCiBvdXQ6Ci0Jc3Bpbl91bmxv
Y2soJm1jZWxvZ19sb2NrKTsKKwltdXRleF91bmxvY2soJnhlbl9tY2VfY2hyZGV2X3JlYWRfbXV0
ZXgpOwogCiAJcmV0dXJuIGVyciA/IGVyciA6IGJ1ZiAtIHVidWY7CiB9Ci0tIAoxLjcuMQoK

--_002_DE8DF0795D48FD4CA783C40EC8292335221654SHSMSX101ccrcorpi_--
