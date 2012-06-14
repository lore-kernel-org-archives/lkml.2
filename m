Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756107Ab2FNM4a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 08:56:30 -0400
Received: from mga02.intel.com ([134.134.136.20]:8006 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756050Ab2FNM4U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 08:56:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208,223";a="157563078"
From: "Liu, Jinsong" <jinsong.liu@intel.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] xen/mce: add .poll method for mcelog device driver
Thread-Topic: [PATCH] xen/mce: add .poll method for mcelog device driver
Thread-Index: AQHNSZLddQXy2gd5YkW4phd9182UzZb5g2gwgABBt3A=
Date: Thu, 14 Jun 2012 12:55:48 +0000
Message-ID: <DE8DF0795D48FD4CA783C40EC82923352321AB@SHSMSX101.ccr.corp.intel.com>
References: <DE8DF0795D48FD4CA783C40EC8292335228748@SHSMSX101.ccr.corp.intel.com>
 <20120612124015.GB559@phenom.dumpdata.com>
 <20120613182458.GA5813@phenom.dumpdata.com> 
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: multipart/mixed;
	boundary="_002_DE8DF0795D48FD4CA783C40EC82923352321ABSHSMSX101ccrcorpi_"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--_002_DE8DF0795D48FD4CA783C40EC82923352321ABSHSMSX101ccrcorpi_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

>>=20
>> So another bug which is that mcelog is spinning at 100% CPU (and
>> only under Xen).=20
>>=20
>> It seems to be doing:
>>=20
>> ppoll([{fd=3D4, events=3DPOLLIN}, {fd=3D3, events=3DPOLLIN}], 2, NULL, [=
], 8)
>> =3D 1 ([{fd=3D3, revents=3DPOLLIN}]) read(3, "", 2816)
>> =3D 0
>> ppoll([{fd=3D4, events=3DPOLLIN}, {fd=3D3, events=3DPOLLIN}], 2, NULL, [=
], 8)
>> =3D 1 ([{fd=3D3, revents=3DPOLLIN}]) read(3, "", 2816)
>>=20
>> constantly.
>=20
> I will debug it. I have try at my platform, but fail to reproduce it.
> (You still use the config you send me last time, right?) Would you
> tell me your step?=20
>=20
> Thanks,
> Jinsong

Have a look at it, it caused by NULL .poll method.
Attached is the patch to fix this bug, but I cannot reproduce the bug at my=
 platform, so would you please help me to test it at your side?

Thanks,
Jinsong

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>From fb664590ce4198539d96b6bc245c5d70cc079129 Mon Sep 17 00:00:00 2001
From: Liu, Jinsong <jinsong.liu@intel.com>
Date: Fri, 15 Jun 2012 04:16:52 +0800
Subject: [PATCH] xen/mce: add .poll method for mcelog device driver

If a driver leaves its poll method NULL, the device is assumed to
be both readable and writable without blocking.

This patch add .poll method to xen mcelog device driver, so that
when mcelog use system calls like ppoll or select, it would be
blocked when no data available, and avoid spinning at CPU.

Reported-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: Liu, Jinsong <jinsong.liu@intel.com>
---
 drivers/xen/mcelog.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/drivers/xen/mcelog.c b/drivers/xen/mcelog.c
index 804aa3c..c0b39c9 100644
--- a/drivers/xen/mcelog.c
+++ b/drivers/xen/mcelog.c
@@ -41,6 +41,7 @@
 #include <linux/miscdevice.h>
 #include <linux/uaccess.h>
 #include <linux/capability.h>
+#include <linux/poll.h>
=20
 #include <xen/interface/xen.h>
 #include <xen/events.h>
@@ -135,6 +136,14 @@ out:
 	return err ? err : buf - ubuf;
 }
=20
+static unsigned int xen_mce_chrdev_poll(struct file *file, poll_table *wai=
t)
+{
+	if (xen_mcelog.next)
+		return POLLIN | POLLRDNORM;
+
+	return 0;
+}
+
 static long xen_mce_chrdev_ioctl(struct file *f, unsigned int cmd,
 				unsigned long arg)
 {
@@ -166,6 +175,7 @@ static const struct file_operations xen_mce_chrdev_ops =
=3D {
 	.open			=3D xen_mce_chrdev_open,
 	.release		=3D xen_mce_chrdev_release,
 	.read			=3D xen_mce_chrdev_read,
+	.poll			=3D xen_mce_chrdev_poll,
 	.unlocked_ioctl		=3D xen_mce_chrdev_ioctl,
 	.llseek			=3D no_llseek,
 };
--=20
1.7.1

--_002_DE8DF0795D48FD4CA783C40EC82923352321ABSHSMSX101ccrcorpi_
Content-Type: application/octet-stream;
	name="0001-xen-mce-add-.poll-method-for-mcelog-device-driver.patch"
Content-Description: 0001-xen-mce-add-.poll-method-for-mcelog-device-driver.patch
Content-Disposition: attachment;
	filename="0001-xen-mce-add-.poll-method-for-mcelog-device-driver.patch";
	size=1677; creation-date="Thu, 14 Jun 2012 12:49:08 GMT";
	modification-date="Thu, 14 Jun 2012 20:35:18 GMT"
Content-Transfer-Encoding: base64

RnJvbSBmYjY2NDU5MGNlNDE5ODUzOWQ5NmI2YmMyNDVjNWQ3MGNjMDc5MTI5IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBMaXUsIEppbnNvbmcgPGppbnNvbmcubGl1QGludGVsLmNvbT4K
RGF0ZTogRnJpLCAxNSBKdW4gMjAxMiAwNDoxNjo1MiArMDgwMApTdWJqZWN0OiBbUEFUQ0hdIHhl
bi9tY2U6IGFkZCAucG9sbCBtZXRob2QgZm9yIG1jZWxvZyBkZXZpY2UgZHJpdmVyCgpJZiBhIGRy
aXZlciBsZWF2ZXMgaXRzIHBvbGwgbWV0aG9kIE5VTEwsIHRoZSBkZXZpY2UgaXMgYXNzdW1lZCB0
bwpiZSBib3RoIHJlYWRhYmxlIGFuZCB3cml0YWJsZSB3aXRob3V0IGJsb2NraW5nLgoKVGhpcyBw
YXRjaCBhZGQgLnBvbGwgbWV0aG9kIHRvIHhlbiBtY2Vsb2cgZGV2aWNlIGRyaXZlciwgc28gdGhh
dAp3aGVuIG1jZWxvZyB1c2Ugc3lzdGVtIGNhbGxzIGxpa2UgcHBvbGwgb3Igc2VsZWN0LCBpdCB3
b3VsZCBiZQpibG9ja2VkIHdoZW4gbm8gZGF0YSBhdmFpbGFibGUsIGFuZCBhdm9pZCBzcGlubmlu
ZyBhdCBDUFUuCgpSZXBvcnRlZC1ieTogS29ucmFkIFJ6ZXN6dXRlayBXaWxrIDxrb25yYWQud2ls
a0BvcmFjbGUuY29tPgpTaWduZWQtb2ZmLWJ5OiBMaXUsIEppbnNvbmcgPGppbnNvbmcubGl1QGlu
dGVsLmNvbT4KLS0tCiBkcml2ZXJzL3hlbi9tY2Vsb2cuYyB8ICAgMTAgKysrKysrKysrKwogMSBm
aWxlcyBjaGFuZ2VkLCAxMCBpbnNlcnRpb25zKCspLCAwIGRlbGV0aW9ucygtKQoKZGlmZiAtLWdp
dCBhL2RyaXZlcnMveGVuL21jZWxvZy5jIGIvZHJpdmVycy94ZW4vbWNlbG9nLmMKaW5kZXggODA0
YWEzYy4uYzBiMzljOSAxMDA2NDQKLS0tIGEvZHJpdmVycy94ZW4vbWNlbG9nLmMKKysrIGIvZHJp
dmVycy94ZW4vbWNlbG9nLmMKQEAgLTQxLDYgKzQxLDcgQEAKICNpbmNsdWRlIDxsaW51eC9taXNj
ZGV2aWNlLmg+CiAjaW5jbHVkZSA8bGludXgvdWFjY2Vzcy5oPgogI2luY2x1ZGUgPGxpbnV4L2Nh
cGFiaWxpdHkuaD4KKyNpbmNsdWRlIDxsaW51eC9wb2xsLmg+CiAKICNpbmNsdWRlIDx4ZW4vaW50
ZXJmYWNlL3hlbi5oPgogI2luY2x1ZGUgPHhlbi9ldmVudHMuaD4KQEAgLTEzNSw2ICsxMzYsMTQg
QEAgb3V0OgogCXJldHVybiBlcnIgPyBlcnIgOiBidWYgLSB1YnVmOwogfQogCitzdGF0aWMgdW5z
aWduZWQgaW50IHhlbl9tY2VfY2hyZGV2X3BvbGwoc3RydWN0IGZpbGUgKmZpbGUsIHBvbGxfdGFi
bGUgKndhaXQpCit7CisJaWYgKHhlbl9tY2Vsb2cubmV4dCkKKwkJcmV0dXJuIFBPTExJTiB8IFBP
TExSRE5PUk07CisKKwlyZXR1cm4gMDsKK30KKwogc3RhdGljIGxvbmcgeGVuX21jZV9jaHJkZXZf
aW9jdGwoc3RydWN0IGZpbGUgKmYsIHVuc2lnbmVkIGludCBjbWQsCiAJCQkJdW5zaWduZWQgbG9u
ZyBhcmcpCiB7CkBAIC0xNjYsNiArMTc1LDcgQEAgc3RhdGljIGNvbnN0IHN0cnVjdCBmaWxlX29w
ZXJhdGlvbnMgeGVuX21jZV9jaHJkZXZfb3BzID0gewogCS5vcGVuCQkJPSB4ZW5fbWNlX2NocmRl
dl9vcGVuLAogCS5yZWxlYXNlCQk9IHhlbl9tY2VfY2hyZGV2X3JlbGVhc2UsCiAJLnJlYWQJCQk9
IHhlbl9tY2VfY2hyZGV2X3JlYWQsCisJLnBvbGwJCQk9IHhlbl9tY2VfY2hyZGV2X3BvbGwsCiAJ
LnVubG9ja2VkX2lvY3RsCQk9IHhlbl9tY2VfY2hyZGV2X2lvY3RsLAogCS5sbHNlZWsJCQk9IG5v
X2xsc2VlaywKIH07Ci0tIAoxLjcuMQoK

--_002_DE8DF0795D48FD4CA783C40EC82923352321ABSHSMSX101ccrcorpi_--
