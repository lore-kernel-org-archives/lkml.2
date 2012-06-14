Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756496Ab2FNRTS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 13:19:18 -0400
Received: from mga09.intel.com ([134.134.136.24]:16610 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756475Ab2FNRTQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 13:19:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208,223";a="157667828"
From: "Liu, Jinsong" <jinsong.liu@intel.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] xen/mce: add .poll method for mcelog device driver
Thread-Topic: [PATCH] xen/mce: add .poll method for mcelog device driver
Thread-Index: AQHNSZLddQXy2gd5YkW4phd9182UzZb5g2gwgABBt3CAAEm98A==
Date: Thu, 14 Jun 2012 17:19:13 +0000
Message-ID: <DE8DF0795D48FD4CA783C40EC8292335233036@SHSMSX101.ccr.corp.intel.com>
References: <DE8DF0795D48FD4CA783C40EC8292335228748@SHSMSX101.ccr.corp.intel.com>
 <20120612124015.GB559@phenom.dumpdata.com>
 <20120613182458.GA5813@phenom.dumpdata.com>  
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: multipart/mixed;
	boundary="_002_DE8DF0795D48FD4CA783C40EC8292335233036SHSMSX101ccrcorpi_"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--_002_DE8DF0795D48FD4CA783C40EC8292335233036SHSMSX101ccrcorpi_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Liu, Jinsong wrote:
>>> So another bug which is that mcelog is spinning at 100% CPU (and
>>> only under Xen).=20
>>>=20
>>> It seems to be doing:
>>>=20
>>> ppoll([{fd=3D4, events=3DPOLLIN}, {fd=3D3, events=3DPOLLIN}], 2, NULL, =
[],
>>> 8) =3D 1 ([{fd=3D3, revents=3DPOLLIN}]) read(3, "", 2816)
>>> =3D 0
>>> ppoll([{fd=3D4, events=3DPOLLIN}, {fd=3D3, events=3DPOLLIN}], 2, NULL, =
[],
>>> 8) =3D 1 ([{fd=3D3, revents=3DPOLLIN}]) read(3, "", 2816)
>>>=20
>>> constantly.
>>=20
>> I will debug it. I have try at my platform, but fail to reproduce it.
>> (You still use the config you send me last time, right?) Would you
>> tell me your step?=20
>>=20
>> Thanks,
>> Jinsong
>=20
> Have a look at it, it caused by NULL .poll method.
> Attached is the patch to fix this bug, but I cannot reproduce the bug
> at my platform, so would you please help me to test it at your side?=20
>=20

Ah I know how you trigger the bug - you run mcelog as daemon ... then spinn=
ing at CPU.
I update my patch as attached, and test at my platform OK now.

Thanks,
Jinsong

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>From 771bf5835a1ed9e439c7da289cb3a72ee8c9bd02 Mon Sep 17 00:00:00 2001
From: Liu, Jinsong <jinsong.liu@intel.com>
Date: Fri, 15 Jun 2012 09:03:39 +0800
Subject: [PATCH] xen/mce: add .poll method for mcelog device driver

If a driver leaves its poll method NULL, the device is assumed to
be both readable and writable without blocking.

This patch add .poll method to xen mcelog device driver, so that
when mcelog use system calls like ppoll or select, it would be
blocked when no data available, and avoid spinning at CPU.

Reported-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: Liu, Jinsong <jinsong.liu@intel.com>
---
 drivers/xen/mcelog.c |   18 ++++++++++++++++++
 1 files changed, 18 insertions(+), 0 deletions(-)

diff --git a/drivers/xen/mcelog.c b/drivers/xen/mcelog.c
index 804aa3c..8feee08 100644
--- a/drivers/xen/mcelog.c
+++ b/drivers/xen/mcelog.c
@@ -41,6 +41,8 @@
 #include <linux/miscdevice.h>
 #include <linux/uaccess.h>
 #include <linux/capability.h>
+#include <linux/poll.h>
+#include <linux/sched.h>
=20
 #include <xen/interface/xen.h>
 #include <xen/events.h>
@@ -67,6 +69,8 @@ static DEFINE_SPINLOCK(xen_mce_chrdev_state_lock);
 static int xen_mce_chrdev_open_count;	/* #times opened */
 static int xen_mce_chrdev_open_exclu;	/* already open exclusive? */
=20
+static DECLARE_WAIT_QUEUE_HEAD(xen_mce_chrdev_wait);
+
 static int xen_mce_chrdev_open(struct inode *inode, struct file *file)
 {
 	spin_lock(&xen_mce_chrdev_state_lock);
@@ -135,6 +139,16 @@ out:
 	return err ? err : buf - ubuf;
 }
=20
+static unsigned int xen_mce_chrdev_poll(struct file *file, poll_table *wai=
t)
+{
+	poll_wait(file, &xen_mce_chrdev_wait, wait);
+
+	if (xen_mcelog.next)
+		return POLLIN | POLLRDNORM;
+
+	return 0;
+}
+
 static long xen_mce_chrdev_ioctl(struct file *f, unsigned int cmd,
 				unsigned long arg)
 {
@@ -166,6 +180,7 @@ static const struct file_operations xen_mce_chrdev_ops =
=3D {
 	.open			=3D xen_mce_chrdev_open,
 	.release		=3D xen_mce_chrdev_release,
 	.read			=3D xen_mce_chrdev_read,
+	.poll			=3D xen_mce_chrdev_poll,
 	.unlocked_ioctl		=3D xen_mce_chrdev_ioctl,
 	.llseek			=3D no_llseek,
 };
@@ -329,6 +344,9 @@ static void xen_mce_work_fn(struct work_struct *work)
 		pr_err(XEN_MCELOG
 		       "Failed to handle nonurgent mc_info queue.\n");
=20
+	/* wake processes polling /dev/mcelog */
+	wake_up_interruptible(&xen_mce_chrdev_wait);
+
 	mutex_unlock(&mcelog_lock);
 }
 static DECLARE_WORK(xen_mce_work, xen_mce_work_fn);
--=20
1.7.1

--_002_DE8DF0795D48FD4CA783C40EC8292335233036SHSMSX101ccrcorpi_
Content-Type: application/octet-stream;
	name="0001-xen-mce-add-.poll-method-for-mcelog-device-driver.patch"
Content-Description: 0001-xen-mce-add-.poll-method-for-mcelog-device-driver.patch
Content-Disposition: attachment;
	filename="0001-xen-mce-add-.poll-method-for-mcelog-device-driver.patch";
	size=2464; creation-date="Thu, 14 Jun 2012 17:13:03 GMT";
	modification-date="Fri, 15 Jun 2012 01:06:00 GMT"
Content-Transfer-Encoding: base64

RnJvbSA3NzFiZjU4MzVhMWVkOWU0MzljN2RhMjg5Y2IzYTcyZWU4YzliZDAyIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBMaXUsIEppbnNvbmcgPGppbnNvbmcubGl1QGludGVsLmNvbT4K
RGF0ZTogRnJpLCAxNSBKdW4gMjAxMiAwOTowMzozOSArMDgwMApTdWJqZWN0OiBbUEFUQ0hdIHhl
bi9tY2U6IGFkZCAucG9sbCBtZXRob2QgZm9yIG1jZWxvZyBkZXZpY2UgZHJpdmVyCgpJZiBhIGRy
aXZlciBsZWF2ZXMgaXRzIHBvbGwgbWV0aG9kIE5VTEwsIHRoZSBkZXZpY2UgaXMgYXNzdW1lZCB0
bwpiZSBib3RoIHJlYWRhYmxlIGFuZCB3cml0YWJsZSB3aXRob3V0IGJsb2NraW5nLgoKVGhpcyBw
YXRjaCBhZGQgLnBvbGwgbWV0aG9kIHRvIHhlbiBtY2Vsb2cgZGV2aWNlIGRyaXZlciwgc28gdGhh
dAp3aGVuIG1jZWxvZyB1c2Ugc3lzdGVtIGNhbGxzIGxpa2UgcHBvbGwgb3Igc2VsZWN0LCBpdCB3
b3VsZCBiZQpibG9ja2VkIHdoZW4gbm8gZGF0YSBhdmFpbGFibGUsIGFuZCBhdm9pZCBzcGlubmlu
ZyBhdCBDUFUuCgpSZXBvcnRlZC1ieTogS29ucmFkIFJ6ZXN6dXRlayBXaWxrIDxrb25yYWQud2ls
a0BvcmFjbGUuY29tPgpTaWduZWQtb2ZmLWJ5OiBMaXUsIEppbnNvbmcgPGppbnNvbmcubGl1QGlu
dGVsLmNvbT4KLS0tCiBkcml2ZXJzL3hlbi9tY2Vsb2cuYyB8ICAgMTggKysrKysrKysrKysrKysr
KysrCiAxIGZpbGVzIGNoYW5nZWQsIDE4IGluc2VydGlvbnMoKyksIDAgZGVsZXRpb25zKC0pCgpk
aWZmIC0tZ2l0IGEvZHJpdmVycy94ZW4vbWNlbG9nLmMgYi9kcml2ZXJzL3hlbi9tY2Vsb2cuYwpp
bmRleCA4MDRhYTNjLi44ZmVlZTA4IDEwMDY0NAotLS0gYS9kcml2ZXJzL3hlbi9tY2Vsb2cuYwor
KysgYi9kcml2ZXJzL3hlbi9tY2Vsb2cuYwpAQCAtNDEsNiArNDEsOCBAQAogI2luY2x1ZGUgPGxp
bnV4L21pc2NkZXZpY2UuaD4KICNpbmNsdWRlIDxsaW51eC91YWNjZXNzLmg+CiAjaW5jbHVkZSA8
bGludXgvY2FwYWJpbGl0eS5oPgorI2luY2x1ZGUgPGxpbnV4L3BvbGwuaD4KKyNpbmNsdWRlIDxs
aW51eC9zY2hlZC5oPgogCiAjaW5jbHVkZSA8eGVuL2ludGVyZmFjZS94ZW4uaD4KICNpbmNsdWRl
IDx4ZW4vZXZlbnRzLmg+CkBAIC02Nyw2ICs2OSw4IEBAIHN0YXRpYyBERUZJTkVfU1BJTkxPQ0so
eGVuX21jZV9jaHJkZXZfc3RhdGVfbG9jayk7CiBzdGF0aWMgaW50IHhlbl9tY2VfY2hyZGV2X29w
ZW5fY291bnQ7CS8qICN0aW1lcyBvcGVuZWQgKi8KIHN0YXRpYyBpbnQgeGVuX21jZV9jaHJkZXZf
b3Blbl9leGNsdTsJLyogYWxyZWFkeSBvcGVuIGV4Y2x1c2l2ZT8gKi8KIAorc3RhdGljIERFQ0xB
UkVfV0FJVF9RVUVVRV9IRUFEKHhlbl9tY2VfY2hyZGV2X3dhaXQpOworCiBzdGF0aWMgaW50IHhl
bl9tY2VfY2hyZGV2X29wZW4oc3RydWN0IGlub2RlICppbm9kZSwgc3RydWN0IGZpbGUgKmZpbGUp
CiB7CiAJc3Bpbl9sb2NrKCZ4ZW5fbWNlX2NocmRldl9zdGF0ZV9sb2NrKTsKQEAgLTEzNSw2ICsx
MzksMTYgQEAgb3V0OgogCXJldHVybiBlcnIgPyBlcnIgOiBidWYgLSB1YnVmOwogfQogCitzdGF0
aWMgdW5zaWduZWQgaW50IHhlbl9tY2VfY2hyZGV2X3BvbGwoc3RydWN0IGZpbGUgKmZpbGUsIHBv
bGxfdGFibGUgKndhaXQpCit7CisJcG9sbF93YWl0KGZpbGUsICZ4ZW5fbWNlX2NocmRldl93YWl0
LCB3YWl0KTsKKworCWlmICh4ZW5fbWNlbG9nLm5leHQpCisJCXJldHVybiBQT0xMSU4gfCBQT0xM
UkROT1JNOworCisJcmV0dXJuIDA7Cit9CisKIHN0YXRpYyBsb25nIHhlbl9tY2VfY2hyZGV2X2lv
Y3RsKHN0cnVjdCBmaWxlICpmLCB1bnNpZ25lZCBpbnQgY21kLAogCQkJCXVuc2lnbmVkIGxvbmcg
YXJnKQogewpAQCAtMTY2LDYgKzE4MCw3IEBAIHN0YXRpYyBjb25zdCBzdHJ1Y3QgZmlsZV9vcGVy
YXRpb25zIHhlbl9tY2VfY2hyZGV2X29wcyA9IHsKIAkub3BlbgkJCT0geGVuX21jZV9jaHJkZXZf
b3BlbiwKIAkucmVsZWFzZQkJPSB4ZW5fbWNlX2NocmRldl9yZWxlYXNlLAogCS5yZWFkCQkJPSB4
ZW5fbWNlX2NocmRldl9yZWFkLAorCS5wb2xsCQkJPSB4ZW5fbWNlX2NocmRldl9wb2xsLAogCS51
bmxvY2tlZF9pb2N0bAkJPSB4ZW5fbWNlX2NocmRldl9pb2N0bCwKIAkubGxzZWVrCQkJPSBub19s
bHNlZWssCiB9OwpAQCAtMzI5LDYgKzM0NCw5IEBAIHN0YXRpYyB2b2lkIHhlbl9tY2Vfd29ya19m
bihzdHJ1Y3Qgd29ya19zdHJ1Y3QgKndvcmspCiAJCXByX2VycihYRU5fTUNFTE9HCiAJCSAgICAg
ICAiRmFpbGVkIHRvIGhhbmRsZSBub251cmdlbnQgbWNfaW5mbyBxdWV1ZS5cbiIpOwogCisJLyog
d2FrZSBwcm9jZXNzZXMgcG9sbGluZyAvZGV2L21jZWxvZyAqLworCXdha2VfdXBfaW50ZXJydXB0
aWJsZSgmeGVuX21jZV9jaHJkZXZfd2FpdCk7CisKIAltdXRleF91bmxvY2soJm1jZWxvZ19sb2Nr
KTsKIH0KIHN0YXRpYyBERUNMQVJFX1dPUksoeGVuX21jZV93b3JrLCB4ZW5fbWNlX3dvcmtfZm4p
OwotLSAKMS43LjEKCg==

--_002_DE8DF0795D48FD4CA783C40EC8292335233036SHSMSX101ccrcorpi_--
