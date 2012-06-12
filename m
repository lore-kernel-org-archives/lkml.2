Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751618Ab2FLHvJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 03:51:09 -0400
Received: from mga14.intel.com ([143.182.124.37]:14978 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750867Ab2FLHvI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 03:51:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208,223";a="111057321"
From: "Liu, Jinsong" <jinsong.liu@intel.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Borislav Petkov <bp@amd64.org>, "Luck, Tony" <tony.luck@intel.com>,
        "'xen-devel@lists.xensource.com'" <xen-devel@lists.xensource.com>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>
Subject: [PATCH] xen/mce: schedule a workqueue to avoid sleep in atomic
 context
Thread-Topic: [PATCH] xen/mce: schedule a workqueue to avoid sleep in atomic
 context
Thread-Index: Ac1IcB2Zmrg1zlUCRGutICBqPpSu9A==
Date: Tue, 12 Jun 2012 07:51:03 +0000
Message-ID: <DE8DF0795D48FD4CA783C40EC8292335228748@SHSMSX101.ccr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: multipart/mixed;
	boundary="_002_DE8DF0795D48FD4CA783C40EC8292335228748SHSMSX101ccrcorpi_"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--_002_DE8DF0795D48FD4CA783C40EC8292335228748SHSMSX101ccrcorpi_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

>From aa2ce7440f16002266dc8464f749992d0c8ac0e5 Mon Sep 17 00:00:00 2001
From: Liu, Jinsong <jinsong.liu@intel.com>
Date: Tue, 12 Jun 2012 23:11:16 +0800
Subject: [PATCH] xen/mce: schedule a workqueue to avoid sleep in atomic con=
text

copy_to_user might sleep and print a stack trace if it is executed
in an atomic spinlock context.

This patch schedule a workqueue for IRQ handler to poll the data,
and use mutex instead of spinlock, so copy_to_user sleep in atomic
context would not occur.

Reported-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Suggested-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: Liu, Jinsong <jinsong.liu@intel.com>
---
 drivers/xen/mcelog.c |   18 +++++++++++-------
 1 files changed, 11 insertions(+), 7 deletions(-)

diff --git a/drivers/xen/mcelog.c b/drivers/xen/mcelog.c
index 72e87d2..804aa3c 100644
--- a/drivers/xen/mcelog.c
+++ b/drivers/xen/mcelog.c
@@ -55,7 +55,7 @@ static struct mc_info g_mi;
 static struct mcinfo_logical_cpu *g_physinfo;
 static uint32_t ncpus;
=20
-static DEFINE_SPINLOCK(mcelog_lock);
+static DEFINE_MUTEX(mcelog_lock);
=20
 static struct xen_mce_log xen_mcelog =3D {
 	.signature	=3D XEN_MCE_LOG_SIGNATURE,
@@ -106,7 +106,7 @@ static ssize_t xen_mce_chrdev_read(struct file *filp, c=
har __user *ubuf,
 	unsigned num;
 	int i, err;
=20
-	spin_lock(&mcelog_lock);
+	mutex_lock(&mcelog_lock);
=20
 	num =3D xen_mcelog.next;
=20
@@ -130,7 +130,7 @@ static ssize_t xen_mce_chrdev_read(struct file *filp, c=
har __user *ubuf,
 		err =3D -EFAULT;
=20
 out:
-	spin_unlock(&mcelog_lock);
+	mutex_unlock(&mcelog_lock);
=20
 	return err ? err : buf - ubuf;
 }
@@ -310,12 +310,11 @@ static int mc_queue_handle(uint32_t flags)
 }
=20
 /* virq handler for machine check error info*/
-static irqreturn_t xen_mce_interrupt(int irq, void *dev_id)
+static void xen_mce_work_fn(struct work_struct *work)
 {
 	int err;
-	unsigned long tmp;
=20
-	spin_lock_irqsave(&mcelog_lock, tmp);
+	mutex_lock(&mcelog_lock);
=20
 	/* urgent mc_info */
 	err =3D mc_queue_handle(XEN_MC_URGENT);
@@ -330,8 +329,13 @@ static irqreturn_t xen_mce_interrupt(int irq, void *de=
v_id)
 		pr_err(XEN_MCELOG
 		       "Failed to handle nonurgent mc_info queue.\n");
=20
-	spin_unlock_irqrestore(&mcelog_lock, tmp);
+	mutex_unlock(&mcelog_lock);
+}
+static DECLARE_WORK(xen_mce_work, xen_mce_work_fn);
=20
+static irqreturn_t xen_mce_interrupt(int irq, void *dev_id)
+{
+	schedule_work(&xen_mce_work);
 	return IRQ_HANDLED;
 }
=20
--=20
1.7.1

--_002_DE8DF0795D48FD4CA783C40EC8292335228748SHSMSX101ccrcorpi_
Content-Type: application/octet-stream;
	name="0001-xen-mce-schedule-a-workqueue-to-avoid-sleep-in-atomi.patch"
Content-Description: 0001-xen-mce-schedule-a-workqueue-to-avoid-sleep-in-atomi.patch
Content-Disposition: attachment;
	filename="0001-xen-mce-schedule-a-workqueue-to-avoid-sleep-in-atomi.patch";
	size=2441; creation-date="Tue, 12 Jun 2012 07:45:53 GMT";
	modification-date="Tue, 12 Jun 2012 15:39:38 GMT"
Content-Transfer-Encoding: base64

RnJvbSBhYTJjZTc0NDBmMTYwMDIyNjZkYzg0NjRmNzQ5OTkyZDBjOGFjMGU1IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBMaXUsIEppbnNvbmcgPGppbnNvbmcubGl1QGludGVsLmNvbT4K
RGF0ZTogVHVlLCAxMiBKdW4gMjAxMiAyMzoxMToxNiArMDgwMApTdWJqZWN0OiBbUEFUQ0hdIHhl
bi9tY2U6IHNjaGVkdWxlIGEgd29ya3F1ZXVlIHRvIGF2b2lkIHNsZWVwIGluIGF0b21pYyBjb250
ZXh0Cgpjb3B5X3RvX3VzZXIgbWlnaHQgc2xlZXAgYW5kIHByaW50IGEgc3RhY2sgdHJhY2UgaWYg
aXQgaXMgZXhlY3V0ZWQKaW4gYW4gYXRvbWljIHNwaW5sb2NrIGNvbnRleHQuCgpUaGlzIHBhdGNo
IHNjaGVkdWxlIGEgd29ya3F1ZXVlIGZvciBJUlEgaGFuZGxlciB0byBwb2xsIHRoZSBkYXRhLAph
bmQgdXNlIG11dGV4IGluc3RlYWQgb2Ygc3BpbmxvY2ssIHNvIGNvcHlfdG9fdXNlciBzbGVlcCBp
biBhdG9taWMKY29udGV4dCB3b3VsZCBub3Qgb2NjdXIuCgpSZXBvcnRlZC1ieTogS29ucmFkIFJ6
ZXN6dXRlayBXaWxrIDxrb25yYWQud2lsa0BvcmFjbGUuY29tPgpTdWdnZXN0ZWQtYnk6IEtvbnJh
ZCBSemVzenV0ZWsgV2lsayA8a29ucmFkLndpbGtAb3JhY2xlLmNvbT4KU2lnbmVkLW9mZi1ieTog
TGl1LCBKaW5zb25nIDxqaW5zb25nLmxpdUBpbnRlbC5jb20+Ci0tLQogZHJpdmVycy94ZW4vbWNl
bG9nLmMgfCAgIDE4ICsrKysrKysrKysrLS0tLS0tLQogMSBmaWxlcyBjaGFuZ2VkLCAxMSBpbnNl
cnRpb25zKCspLCA3IGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2RyaXZlcnMveGVuL21jZWxv
Zy5jIGIvZHJpdmVycy94ZW4vbWNlbG9nLmMKaW5kZXggNzJlODdkMi4uODA0YWEzYyAxMDA2NDQK
LS0tIGEvZHJpdmVycy94ZW4vbWNlbG9nLmMKKysrIGIvZHJpdmVycy94ZW4vbWNlbG9nLmMKQEAg
LTU1LDcgKzU1LDcgQEAgc3RhdGljIHN0cnVjdCBtY19pbmZvIGdfbWk7CiBzdGF0aWMgc3RydWN0
IG1jaW5mb19sb2dpY2FsX2NwdSAqZ19waHlzaW5mbzsKIHN0YXRpYyB1aW50MzJfdCBuY3B1czsK
IAotc3RhdGljIERFRklORV9TUElOTE9DSyhtY2Vsb2dfbG9jayk7CitzdGF0aWMgREVGSU5FX01V
VEVYKG1jZWxvZ19sb2NrKTsKIAogc3RhdGljIHN0cnVjdCB4ZW5fbWNlX2xvZyB4ZW5fbWNlbG9n
ID0gewogCS5zaWduYXR1cmUJPSBYRU5fTUNFX0xPR19TSUdOQVRVUkUsCkBAIC0xMDYsNyArMTA2
LDcgQEAgc3RhdGljIHNzaXplX3QgeGVuX21jZV9jaHJkZXZfcmVhZChzdHJ1Y3QgZmlsZSAqZmls
cCwgY2hhciBfX3VzZXIgKnVidWYsCiAJdW5zaWduZWQgbnVtOwogCWludCBpLCBlcnI7CiAKLQlz
cGluX2xvY2soJm1jZWxvZ19sb2NrKTsKKwltdXRleF9sb2NrKCZtY2Vsb2dfbG9jayk7CiAKIAlu
dW0gPSB4ZW5fbWNlbG9nLm5leHQ7CiAKQEAgLTEzMCw3ICsxMzAsNyBAQCBzdGF0aWMgc3NpemVf
dCB4ZW5fbWNlX2NocmRldl9yZWFkKHN0cnVjdCBmaWxlICpmaWxwLCBjaGFyIF9fdXNlciAqdWJ1
ZiwKIAkJZXJyID0gLUVGQVVMVDsKIAogb3V0OgotCXNwaW5fdW5sb2NrKCZtY2Vsb2dfbG9jayk7
CisJbXV0ZXhfdW5sb2NrKCZtY2Vsb2dfbG9jayk7CiAKIAlyZXR1cm4gZXJyID8gZXJyIDogYnVm
IC0gdWJ1ZjsKIH0KQEAgLTMxMCwxMiArMzEwLDExIEBAIHN0YXRpYyBpbnQgbWNfcXVldWVfaGFu
ZGxlKHVpbnQzMl90IGZsYWdzKQogfQogCiAvKiB2aXJxIGhhbmRsZXIgZm9yIG1hY2hpbmUgY2hl
Y2sgZXJyb3IgaW5mbyovCi1zdGF0aWMgaXJxcmV0dXJuX3QgeGVuX21jZV9pbnRlcnJ1cHQoaW50
IGlycSwgdm9pZCAqZGV2X2lkKQorc3RhdGljIHZvaWQgeGVuX21jZV93b3JrX2ZuKHN0cnVjdCB3
b3JrX3N0cnVjdCAqd29yaykKIHsKIAlpbnQgZXJyOwotCXVuc2lnbmVkIGxvbmcgdG1wOwogCi0J
c3Bpbl9sb2NrX2lycXNhdmUoJm1jZWxvZ19sb2NrLCB0bXApOworCW11dGV4X2xvY2soJm1jZWxv
Z19sb2NrKTsKIAogCS8qIHVyZ2VudCBtY19pbmZvICovCiAJZXJyID0gbWNfcXVldWVfaGFuZGxl
KFhFTl9NQ19VUkdFTlQpOwpAQCAtMzMwLDggKzMyOSwxMyBAQCBzdGF0aWMgaXJxcmV0dXJuX3Qg
eGVuX21jZV9pbnRlcnJ1cHQoaW50IGlycSwgdm9pZCAqZGV2X2lkKQogCQlwcl9lcnIoWEVOX01D
RUxPRwogCQkgICAgICAgIkZhaWxlZCB0byBoYW5kbGUgbm9udXJnZW50IG1jX2luZm8gcXVldWUu
XG4iKTsKIAotCXNwaW5fdW5sb2NrX2lycXJlc3RvcmUoJm1jZWxvZ19sb2NrLCB0bXApOworCW11
dGV4X3VubG9jaygmbWNlbG9nX2xvY2spOworfQorc3RhdGljIERFQ0xBUkVfV09SSyh4ZW5fbWNl
X3dvcmssIHhlbl9tY2Vfd29ya19mbik7CiAKK3N0YXRpYyBpcnFyZXR1cm5fdCB4ZW5fbWNlX2lu
dGVycnVwdChpbnQgaXJxLCB2b2lkICpkZXZfaWQpCit7CisJc2NoZWR1bGVfd29yaygmeGVuX21j
ZV93b3JrKTsKIAlyZXR1cm4gSVJRX0hBTkRMRUQ7CiB9CiAKLS0gCjEuNy4xCgo=

--_002_DE8DF0795D48FD4CA783C40EC8292335228748SHSMSX101ccrcorpi_--
