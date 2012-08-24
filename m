Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964811Ab2HXOjZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 10:39:25 -0400
Received: from mga01.intel.com ([192.55.52.88]:9488 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759544Ab2HXOjV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 10:39:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,304,1344236400"; 
   d="asc'?scan'208,223";a="213473508"
Message-ID: <1345819407.2848.319.camel@sauron.fi.intel.com>
Subject: Re: [PATCH] drivers/mtd/devices/spear_smi.c: use devm_ functions
 consistently
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Stefan Roese <sr@denx.de>
Cc: Julia Lawall <Julia.Lawall@lip6.fr>, Shiraz Hashim <shiraz.hashim@st.com>,
        David Woodhouse <dwmw2@infradead.org>, kernel-janitors@vger.kernel.org,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Date: Fri, 24 Aug 2012 17:43:27 +0300
In-Reply-To: <50377E38.1040701@denx.de>
References: <1344112598-1051-1-git-send-email-Julia.Lawall@lip6.fr>
	 <1345808104.2848.285.camel@sauron.fi.intel.com> <50377E38.1040701@denx.de>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-/dTG7MKRI3+2+fkfYs+G"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-/dTG7MKRI3+2+fkfYs+G
Content-Type: multipart/mixed; boundary="=-/74K4N44AkpYrLXJDpCI"


--=-/74K4N44AkpYrLXJDpCI
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2012-08-24 at 15:14 +0200, Stefan Roese wrote:
> On 08/24/2012 01:35 PM, Artem Bityutskiy wrote:
> >> @@ -1073,21 +1043,13 @@ static int __devexit spear_smi_remove(struct p=
latform_device *pdev)
> >>  		ret =3D mtd_device_unregister(&flash->mtd);
> >>  		if (ret)
> >>  			dev_err(&pdev->dev, "error removing mtd\n");
> >> -
> >> -		iounmap(flash->base_addr);
> >> -		kfree(flash);
> >>  	}
> >> =20
> >>  	irq =3D platform_get_irq(pdev, 0);
> >> -	free_irq(irq, dev);
> >=20
> > I guess 'platform_get_irq()' should be killed as well? Stefan, this is
> > strange code - we get irq, without checking for error, and then free it=
?
> > What is the rationale?
>=20
> Yes, this seems bogus. platform_get_irq() definitely should be removed
> from spear_smi_remove().

OK, thanks, I've massaged Julia's patch and pushed the following (also
attached) to l2-mtd.git, compile-tested only.

=46rom d44ab8be1a01b83c744d8077a54064e179b0e2b8 Mon Sep 17 00:00:00 2001
From: Julia Lawall <Julia.Lawall@lip6.fr>
Date: Sat, 4 Aug 2012 22:36:38 +0200
Subject: [PATCH] mtd: spear_smi: use devm_ functions consistently

Use devm_kzalloc for all calls to kzalloc and not just the first.  Use devm
functions for other allocations as well.

Move the call to platform_get_resource(pdev, IORESOURCE_MEM, 0) closer to
where its result is passed to devm_request_and_ioremap to make the lack of
need for a NULL test more evident.

The semantic match that finds the inconsistency is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@
@@

*devm_kzalloc(...)
...
*kzalloc(...)
// </smpl>

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>
Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
---
 drivers/mtd/devices/spear_smi.c |   83 +++++++++--------------------------=
----
 1 file changed, 18 insertions(+), 65 deletions(-)

diff --git a/drivers/mtd/devices/spear_smi.c b/drivers/mtd/devices/spear_sm=
i.c
index 421bc65..dcc3c95 100644
--- a/drivers/mtd/devices/spear_smi.c
+++ b/drivers/mtd/devices/spear_smi.c
@@ -827,7 +827,7 @@ static int spear_smi_setup_banks(struct platform_device=
 *pdev,
 	if (!flash_info)
 		return -ENODEV;
=20
-	flash =3D kzalloc(sizeof(*flash), GFP_ATOMIC);
+	flash =3D devm_kzalloc(&pdev->dev, sizeof(*flash), GFP_ATOMIC);
 	if (!flash)
 		return -ENOMEM;
 	flash->bank =3D bank;
@@ -838,15 +838,13 @@ static int spear_smi_setup_banks(struct platform_devi=
ce *pdev,
 	flash_index =3D spear_smi_probe_flash(dev, bank);
 	if (flash_index < 0) {
 		dev_info(&dev->pdev->dev, "smi-nor%d not found\n", bank);
-		ret =3D flash_index;
-		goto err_probe;
+		return flash_index;
 	}
 	/* map the memory for nor flash chip */
-	flash->base_addr =3D ioremap(flash_info->mem_base, flash_info->size);
-	if (!flash->base_addr) {
-		ret =3D -EIO;
-		goto err_probe;
-	}
+	flash->base_addr =3D devm_ioremap(&pdev->dev, flash_info->mem_base,
+					flash_info->size);
+	if (!flash->base_addr)
+		return -EIO;
=20
 	dev->flash[bank] =3D flash;
 	flash->mtd.priv =3D dev;
@@ -888,17 +886,10 @@ static int spear_smi_setup_banks(struct platform_devi=
ce *pdev,
 					count);
 	if (ret) {
 		dev_err(&dev->pdev->dev, "Err MTD partition=3D%d\n", ret);
-		goto err_map;
+		return ret;
 	}
=20
 	return 0;
-
-err_map:
-	iounmap(flash->base_addr);
-
-err_probe:
-	kfree(flash);
-	return ret;
 }
=20
 /**
@@ -942,13 +933,6 @@ static int __devinit spear_smi_probe(struct platform_d=
evice *pdev)
 		}
 	}
=20
-	smi_base =3D platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!smi_base) {
-		ret =3D -ENODEV;
-		dev_err(&pdev->dev, "invalid smi base address\n");
-		goto err;
-	}
-
 	irq =3D platform_get_irq(pdev, 0);
 	if (irq < 0) {
 		ret =3D -ENODEV;
@@ -956,26 +940,20 @@ static int __devinit spear_smi_probe(struct platform_=
device *pdev)
 		goto err;
 	}
=20
-	dev =3D kzalloc(sizeof(*dev), GFP_ATOMIC);
+	dev =3D devm_kzalloc(&pdev->dev, sizeof(*dev), GFP_ATOMIC);
 	if (!dev) {
 		ret =3D -ENOMEM;
 		dev_err(&pdev->dev, "mem alloc fail\n");
 		goto err;
 	}
=20
-	smi_base =3D request_mem_region(smi_base->start, resource_size(smi_base),
-			pdev->name);
-	if (!smi_base) {
-		ret =3D -EBUSY;
-		dev_err(&pdev->dev, "request mem region fail\n");
-		goto err_mem;
-	}
+	smi_base =3D platform_get_resource(pdev, IORESOURCE_MEM, 0);
=20
-	dev->io_base =3D ioremap(smi_base->start, resource_size(smi_base));
+	dev->io_base =3D devm_request_and_ioremap(&pdev->dev, smi_base);
 	if (!dev->io_base) {
 		ret =3D -EIO;
-		dev_err(&pdev->dev, "ioremap fail\n");
-		goto err_ioremap;
+		dev_err(&pdev->dev, "devm_request_and_ioremap fail\n");
+		goto err;
 	}
=20
 	dev->pdev =3D pdev;
@@ -991,17 +969,18 @@ static int __devinit spear_smi_probe(struct platform_=
device *pdev)
 		dev->num_flashes =3D MAX_NUM_FLASH_CHIP;
 	}
=20
-	dev->clk =3D clk_get(&pdev->dev, NULL);
+	dev->clk =3D devm_clk_get(&pdev->dev, NULL);
 	if (IS_ERR(dev->clk)) {
 		ret =3D PTR_ERR(dev->clk);
-		goto err_clk;
+		goto err;
 	}
=20
 	ret =3D clk_prepare_enable(dev->clk);
 	if (ret)
-		goto err_clk_prepare_enable;
+		goto err;
=20
-	ret =3D request_irq(irq, spear_smi_int_handler, 0, pdev->name, dev);
+	ret =3D devm_request_irq(&pdev->dev, irq, spear_smi_int_handler, 0,
+			       pdev->name, dev);
 	if (ret) {
 		dev_err(&dev->pdev->dev, "SMI IRQ allocation failed\n");
 		goto err_irq;
@@ -1024,18 +1003,9 @@ static int __devinit spear_smi_probe(struct platform=
_device *pdev)
 	return 0;
=20
 err_bank_setup:
-	free_irq(irq, dev);
 	platform_set_drvdata(pdev, NULL);
 err_irq:
 	clk_disable_unprepare(dev->clk);
-err_clk_prepare_enable:
-	clk_put(dev->clk);
-err_clk:
-	iounmap(dev->io_base);
-err_ioremap:
-	release_mem_region(smi_base->start, resource_size(smi_base));
-err_mem:
-	kfree(dev);
 err:
 	return ret;
 }
@@ -1049,11 +1019,8 @@ err:
 static int __devexit spear_smi_remove(struct platform_device *pdev)
 {
 	struct spear_smi *dev;
-	struct spear_smi_plat_data *pdata;
 	struct spear_snor_flash *flash;
-	struct resource *smi_base;
-	int ret;
-	int i, irq;
+	int ret, i;
=20
 	dev =3D platform_get_drvdata(pdev);
 	if (!dev) {
@@ -1061,8 +1028,6 @@ static int __devexit spear_smi_remove(struct platform=
_device *pdev)
 		return -ENODEV;
 	}
=20
-	pdata =3D dev_get_platdata(&pdev->dev);
-
 	/* clean up for all nor flash */
 	for (i =3D 0; i < dev->num_flashes; i++) {
 		flash =3D dev->flash[i];
@@ -1073,21 +1038,9 @@ static int __devexit spear_smi_remove(struct platfor=
m_device *pdev)
 		ret =3D mtd_device_unregister(&flash->mtd);
 		if (ret)
 			dev_err(&pdev->dev, "error removing mtd\n");
-
-		iounmap(flash->base_addr);
-		kfree(flash);
 	}
=20
-	irq =3D platform_get_irq(pdev, 0);
-	free_irq(irq, dev);
-
 	clk_disable_unprepare(dev->clk);
-	clk_put(dev->clk);
-	iounmap(dev->io_base);
-	kfree(dev);
-
-	smi_base =3D platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	release_mem_region(smi_base->start, resource_size(smi_base));
 	platform_set_drvdata(pdev, NULL);
=20
 	return 0;
--=20
1.7.10.4

--=20
Best Regards,
Artem Bityutskiy

--=-/74K4N44AkpYrLXJDpCI
Content-Disposition: attachment;
	filename="0001-mtd-spear_smi-use-devm_-functions-consistently.patch"
Content-Type: text/x-patch;
	name="0001-mtd-spear_smi-use-devm_-functions-consistently.patch";
	charset="UTF-8"
Content-Transfer-Encoding: base64

RnJvbSBkNDRhYjhiZTFhMDFiODNjNzQ0ZDgwNzdhNTQwNjRlMTc5YjBlMmI4IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQ0KRnJvbTogSnVsaWEgTGF3YWxsIDxKdWxpYS5MYXdhbGxAbGlwNi5mcj4N
CkRhdGU6IFNhdCwgNCBBdWcgMjAxMiAyMjozNjozOCArMDIwMA0KU3ViamVjdDogW1BBVENIXSBt
dGQ6IHNwZWFyX3NtaTogdXNlIGRldm1fIGZ1bmN0aW9ucyBjb25zaXN0ZW50bHkNCg0KVXNlIGRl
dm1fa3phbGxvYyBmb3IgYWxsIGNhbGxzIHRvIGt6YWxsb2MgYW5kIG5vdCBqdXN0IHRoZSBmaXJz
dC4gIFVzZSBkZXZtDQpmdW5jdGlvbnMgZm9yIG90aGVyIGFsbG9jYXRpb25zIGFzIHdlbGwuDQoN
Ck1vdmUgdGhlIGNhbGwgdG8gcGxhdGZvcm1fZ2V0X3Jlc291cmNlKHBkZXYsIElPUkVTT1VSQ0Vf
TUVNLCAwKSBjbG9zZXIgdG8NCndoZXJlIGl0cyByZXN1bHQgaXMgcGFzc2VkIHRvIGRldm1fcmVx
dWVzdF9hbmRfaW9yZW1hcCB0byBtYWtlIHRoZSBsYWNrIG9mDQpuZWVkIGZvciBhIE5VTEwgdGVz
dCBtb3JlIGV2aWRlbnQuDQoNClRoZSBzZW1hbnRpYyBtYXRjaCB0aGF0IGZpbmRzIHRoZSBpbmNv
bnNpc3RlbmN5IGlzIGFzIGZvbGxvd3M6DQooaHR0cDovL2NvY2NpbmVsbGUubGlwNi5mci8pDQoN
Ci8vIDxzbXBsPg0KQEANCkBADQoNCipkZXZtX2t6YWxsb2MoLi4uKQ0KLi4uDQoqa3phbGxvYygu
Li4pDQovLyA8L3NtcGw+DQoNClNpZ25lZC1vZmYtYnk6IEp1bGlhIExhd2FsbCA8SnVsaWEuTGF3
YWxsQGxpcDYuZnI+DQpTaWduZWQtb2ZmLWJ5OiBBcnRlbSBCaXR5dXRza2l5IDxhcnRlbS5iaXR5
dXRza2l5QGxpbnV4LmludGVsLmNvbT4NCi0tLQ0KIGRyaXZlcnMvbXRkL2RldmljZXMvc3BlYXJf
c21pLmMgfCAgIDgzICsrKysrKysrKy0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLQ0KIDEg
ZmlsZSBjaGFuZ2VkLCAxOCBpbnNlcnRpb25zKCspLCA2NSBkZWxldGlvbnMoLSkNCg0KZGlmZiAt
LWdpdCBhL2RyaXZlcnMvbXRkL2RldmljZXMvc3BlYXJfc21pLmMgYi9kcml2ZXJzL210ZC9kZXZp
Y2VzL3NwZWFyX3NtaS5jDQppbmRleCA0MjFiYzY1Li5kY2MzYzk1IDEwMDY0NA0KLS0tIGEvZHJp
dmVycy9tdGQvZGV2aWNlcy9zcGVhcl9zbWkuYw0KKysrIGIvZHJpdmVycy9tdGQvZGV2aWNlcy9z
cGVhcl9zbWkuYw0KQEAgLTgyNyw3ICs4MjcsNyBAQCBzdGF0aWMgaW50IHNwZWFyX3NtaV9zZXR1
cF9iYW5rcyhzdHJ1Y3QgcGxhdGZvcm1fZGV2aWNlICpwZGV2LA0KIAlpZiAoIWZsYXNoX2luZm8p
DQogCQlyZXR1cm4gLUVOT0RFVjsNCiANCi0JZmxhc2ggPSBremFsbG9jKHNpemVvZigqZmxhc2gp
LCBHRlBfQVRPTUlDKTsNCisJZmxhc2ggPSBkZXZtX2t6YWxsb2MoJnBkZXYtPmRldiwgc2l6ZW9m
KCpmbGFzaCksIEdGUF9BVE9NSUMpOw0KIAlpZiAoIWZsYXNoKQ0KIAkJcmV0dXJuIC1FTk9NRU07
DQogCWZsYXNoLT5iYW5rID0gYmFuazsNCkBAIC04MzgsMTUgKzgzOCwxMyBAQCBzdGF0aWMgaW50
IHNwZWFyX3NtaV9zZXR1cF9iYW5rcyhzdHJ1Y3QgcGxhdGZvcm1fZGV2aWNlICpwZGV2LA0KIAlm
bGFzaF9pbmRleCA9IHNwZWFyX3NtaV9wcm9iZV9mbGFzaChkZXYsIGJhbmspOw0KIAlpZiAoZmxh
c2hfaW5kZXggPCAwKSB7DQogCQlkZXZfaW5mbygmZGV2LT5wZGV2LT5kZXYsICJzbWktbm9yJWQg
bm90IGZvdW5kXG4iLCBiYW5rKTsNCi0JCXJldCA9IGZsYXNoX2luZGV4Ow0KLQkJZ290byBlcnJf
cHJvYmU7DQorCQlyZXR1cm4gZmxhc2hfaW5kZXg7DQogCX0NCiAJLyogbWFwIHRoZSBtZW1vcnkg
Zm9yIG5vciBmbGFzaCBjaGlwICovDQotCWZsYXNoLT5iYXNlX2FkZHIgPSBpb3JlbWFwKGZsYXNo
X2luZm8tPm1lbV9iYXNlLCBmbGFzaF9pbmZvLT5zaXplKTsNCi0JaWYgKCFmbGFzaC0+YmFzZV9h
ZGRyKSB7DQotCQlyZXQgPSAtRUlPOw0KLQkJZ290byBlcnJfcHJvYmU7DQotCX0NCisJZmxhc2gt
PmJhc2VfYWRkciA9IGRldm1faW9yZW1hcCgmcGRldi0+ZGV2LCBmbGFzaF9pbmZvLT5tZW1fYmFz
ZSwNCisJCQkJCWZsYXNoX2luZm8tPnNpemUpOw0KKwlpZiAoIWZsYXNoLT5iYXNlX2FkZHIpDQor
CQlyZXR1cm4gLUVJTzsNCiANCiAJZGV2LT5mbGFzaFtiYW5rXSA9IGZsYXNoOw0KIAlmbGFzaC0+
bXRkLnByaXYgPSBkZXY7DQpAQCAtODg4LDE3ICs4ODYsMTAgQEAgc3RhdGljIGludCBzcGVhcl9z
bWlfc2V0dXBfYmFua3Moc3RydWN0IHBsYXRmb3JtX2RldmljZSAqcGRldiwNCiAJCQkJCWNvdW50
KTsNCiAJaWYgKHJldCkgew0KIAkJZGV2X2VycigmZGV2LT5wZGV2LT5kZXYsICJFcnIgTVREIHBh
cnRpdGlvbj0lZFxuIiwgcmV0KTsNCi0JCWdvdG8gZXJyX21hcDsNCisJCXJldHVybiByZXQ7DQog
CX0NCiANCiAJcmV0dXJuIDA7DQotDQotZXJyX21hcDoNCi0JaW91bm1hcChmbGFzaC0+YmFzZV9h
ZGRyKTsNCi0NCi1lcnJfcHJvYmU6DQotCWtmcmVlKGZsYXNoKTsNCi0JcmV0dXJuIHJldDsNCiB9
DQogDQogLyoqDQpAQCAtOTQyLDEzICs5MzMsNiBAQCBzdGF0aWMgaW50IF9fZGV2aW5pdCBzcGVh
cl9zbWlfcHJvYmUoc3RydWN0IHBsYXRmb3JtX2RldmljZSAqcGRldikNCiAJCX0NCiAJfQ0KIA0K
LQlzbWlfYmFzZSA9IHBsYXRmb3JtX2dldF9yZXNvdXJjZShwZGV2LCBJT1JFU09VUkNFX01FTSwg
MCk7DQotCWlmICghc21pX2Jhc2UpIHsNCi0JCXJldCA9IC1FTk9ERVY7DQotCQlkZXZfZXJyKCZw
ZGV2LT5kZXYsICJpbnZhbGlkIHNtaSBiYXNlIGFkZHJlc3NcbiIpOw0KLQkJZ290byBlcnI7DQot
CX0NCi0NCiAJaXJxID0gcGxhdGZvcm1fZ2V0X2lycShwZGV2LCAwKTsNCiAJaWYgKGlycSA8IDAp
IHsNCiAJCXJldCA9IC1FTk9ERVY7DQpAQCAtOTU2LDI2ICs5NDAsMjAgQEAgc3RhdGljIGludCBf
X2RldmluaXQgc3BlYXJfc21pX3Byb2JlKHN0cnVjdCBwbGF0Zm9ybV9kZXZpY2UgKnBkZXYpDQog
CQlnb3RvIGVycjsNCiAJfQ0KIA0KLQlkZXYgPSBremFsbG9jKHNpemVvZigqZGV2KSwgR0ZQX0FU
T01JQyk7DQorCWRldiA9IGRldm1fa3phbGxvYygmcGRldi0+ZGV2LCBzaXplb2YoKmRldiksIEdG
UF9BVE9NSUMpOw0KIAlpZiAoIWRldikgew0KIAkJcmV0ID0gLUVOT01FTTsNCiAJCWRldl9lcnIo
JnBkZXYtPmRldiwgIm1lbSBhbGxvYyBmYWlsXG4iKTsNCiAJCWdvdG8gZXJyOw0KIAl9DQogDQot
CXNtaV9iYXNlID0gcmVxdWVzdF9tZW1fcmVnaW9uKHNtaV9iYXNlLT5zdGFydCwgcmVzb3VyY2Vf
c2l6ZShzbWlfYmFzZSksDQotCQkJcGRldi0+bmFtZSk7DQotCWlmICghc21pX2Jhc2UpIHsNCi0J
CXJldCA9IC1FQlVTWTsNCi0JCWRldl9lcnIoJnBkZXYtPmRldiwgInJlcXVlc3QgbWVtIHJlZ2lv
biBmYWlsXG4iKTsNCi0JCWdvdG8gZXJyX21lbTsNCi0JfQ0KKwlzbWlfYmFzZSA9IHBsYXRmb3Jt
X2dldF9yZXNvdXJjZShwZGV2LCBJT1JFU09VUkNFX01FTSwgMCk7DQogDQotCWRldi0+aW9fYmFz
ZSA9IGlvcmVtYXAoc21pX2Jhc2UtPnN0YXJ0LCByZXNvdXJjZV9zaXplKHNtaV9iYXNlKSk7DQor
CWRldi0+aW9fYmFzZSA9IGRldm1fcmVxdWVzdF9hbmRfaW9yZW1hcCgmcGRldi0+ZGV2LCBzbWlf
YmFzZSk7DQogCWlmICghZGV2LT5pb19iYXNlKSB7DQogCQlyZXQgPSAtRUlPOw0KLQkJZGV2X2Vy
cigmcGRldi0+ZGV2LCAiaW9yZW1hcCBmYWlsXG4iKTsNCi0JCWdvdG8gZXJyX2lvcmVtYXA7DQor
CQlkZXZfZXJyKCZwZGV2LT5kZXYsICJkZXZtX3JlcXVlc3RfYW5kX2lvcmVtYXAgZmFpbFxuIik7
DQorCQlnb3RvIGVycjsNCiAJfQ0KIA0KIAlkZXYtPnBkZXYgPSBwZGV2Ow0KQEAgLTk5MSwxNyAr
OTY5LDE4IEBAIHN0YXRpYyBpbnQgX19kZXZpbml0IHNwZWFyX3NtaV9wcm9iZShzdHJ1Y3QgcGxh
dGZvcm1fZGV2aWNlICpwZGV2KQ0KIAkJZGV2LT5udW1fZmxhc2hlcyA9IE1BWF9OVU1fRkxBU0hf
Q0hJUDsNCiAJfQ0KIA0KLQlkZXYtPmNsayA9IGNsa19nZXQoJnBkZXYtPmRldiwgTlVMTCk7DQor
CWRldi0+Y2xrID0gZGV2bV9jbGtfZ2V0KCZwZGV2LT5kZXYsIE5VTEwpOw0KIAlpZiAoSVNfRVJS
KGRldi0+Y2xrKSkgew0KIAkJcmV0ID0gUFRSX0VSUihkZXYtPmNsayk7DQotCQlnb3RvIGVycl9j
bGs7DQorCQlnb3RvIGVycjsNCiAJfQ0KIA0KIAlyZXQgPSBjbGtfcHJlcGFyZV9lbmFibGUoZGV2
LT5jbGspOw0KIAlpZiAocmV0KQ0KLQkJZ290byBlcnJfY2xrX3ByZXBhcmVfZW5hYmxlOw0KKwkJ
Z290byBlcnI7DQogDQotCXJldCA9IHJlcXVlc3RfaXJxKGlycSwgc3BlYXJfc21pX2ludF9oYW5k
bGVyLCAwLCBwZGV2LT5uYW1lLCBkZXYpOw0KKwlyZXQgPSBkZXZtX3JlcXVlc3RfaXJxKCZwZGV2
LT5kZXYsIGlycSwgc3BlYXJfc21pX2ludF9oYW5kbGVyLCAwLA0KKwkJCSAgICAgICBwZGV2LT5u
YW1lLCBkZXYpOw0KIAlpZiAocmV0KSB7DQogCQlkZXZfZXJyKCZkZXYtPnBkZXYtPmRldiwgIlNN
SSBJUlEgYWxsb2NhdGlvbiBmYWlsZWRcbiIpOw0KIAkJZ290byBlcnJfaXJxOw0KQEAgLTEwMjQs
MTggKzEwMDMsOSBAQCBzdGF0aWMgaW50IF9fZGV2aW5pdCBzcGVhcl9zbWlfcHJvYmUoc3RydWN0
IHBsYXRmb3JtX2RldmljZSAqcGRldikNCiAJcmV0dXJuIDA7DQogDQogZXJyX2Jhbmtfc2V0dXA6
DQotCWZyZWVfaXJxKGlycSwgZGV2KTsNCiAJcGxhdGZvcm1fc2V0X2RydmRhdGEocGRldiwgTlVM
TCk7DQogZXJyX2lycToNCiAJY2xrX2Rpc2FibGVfdW5wcmVwYXJlKGRldi0+Y2xrKTsNCi1lcnJf
Y2xrX3ByZXBhcmVfZW5hYmxlOg0KLQljbGtfcHV0KGRldi0+Y2xrKTsNCi1lcnJfY2xrOg0KLQlp
b3VubWFwKGRldi0+aW9fYmFzZSk7DQotZXJyX2lvcmVtYXA6DQotCXJlbGVhc2VfbWVtX3JlZ2lv
bihzbWlfYmFzZS0+c3RhcnQsIHJlc291cmNlX3NpemUoc21pX2Jhc2UpKTsNCi1lcnJfbWVtOg0K
LQlrZnJlZShkZXYpOw0KIGVycjoNCiAJcmV0dXJuIHJldDsNCiB9DQpAQCAtMTA0OSwxMSArMTAx
OSw4IEBAIGVycjoNCiBzdGF0aWMgaW50IF9fZGV2ZXhpdCBzcGVhcl9zbWlfcmVtb3ZlKHN0cnVj
dCBwbGF0Zm9ybV9kZXZpY2UgKnBkZXYpDQogew0KIAlzdHJ1Y3Qgc3BlYXJfc21pICpkZXY7DQot
CXN0cnVjdCBzcGVhcl9zbWlfcGxhdF9kYXRhICpwZGF0YTsNCiAJc3RydWN0IHNwZWFyX3Nub3Jf
Zmxhc2ggKmZsYXNoOw0KLQlzdHJ1Y3QgcmVzb3VyY2UgKnNtaV9iYXNlOw0KLQlpbnQgcmV0Ow0K
LQlpbnQgaSwgaXJxOw0KKwlpbnQgcmV0LCBpOw0KIA0KIAlkZXYgPSBwbGF0Zm9ybV9nZXRfZHJ2
ZGF0YShwZGV2KTsNCiAJaWYgKCFkZXYpIHsNCkBAIC0xMDYxLDggKzEwMjgsNiBAQCBzdGF0aWMg
aW50IF9fZGV2ZXhpdCBzcGVhcl9zbWlfcmVtb3ZlKHN0cnVjdCBwbGF0Zm9ybV9kZXZpY2UgKnBk
ZXYpDQogCQlyZXR1cm4gLUVOT0RFVjsNCiAJfQ0KIA0KLQlwZGF0YSA9IGRldl9nZXRfcGxhdGRh
dGEoJnBkZXYtPmRldik7DQotDQogCS8qIGNsZWFuIHVwIGZvciBhbGwgbm9yIGZsYXNoICovDQog
CWZvciAoaSA9IDA7IGkgPCBkZXYtPm51bV9mbGFzaGVzOyBpKyspIHsNCiAJCWZsYXNoID0gZGV2
LT5mbGFzaFtpXTsNCkBAIC0xMDczLDIxICsxMDM4LDkgQEAgc3RhdGljIGludCBfX2RldmV4aXQg
c3BlYXJfc21pX3JlbW92ZShzdHJ1Y3QgcGxhdGZvcm1fZGV2aWNlICpwZGV2KQ0KIAkJcmV0ID0g
bXRkX2RldmljZV91bnJlZ2lzdGVyKCZmbGFzaC0+bXRkKTsNCiAJCWlmIChyZXQpDQogCQkJZGV2
X2VycigmcGRldi0+ZGV2LCAiZXJyb3IgcmVtb3ZpbmcgbXRkXG4iKTsNCi0NCi0JCWlvdW5tYXAo
Zmxhc2gtPmJhc2VfYWRkcik7DQotCQlrZnJlZShmbGFzaCk7DQogCX0NCiANCi0JaXJxID0gcGxh
dGZvcm1fZ2V0X2lycShwZGV2LCAwKTsNCi0JZnJlZV9pcnEoaXJxLCBkZXYpOw0KLQ0KIAljbGtf
ZGlzYWJsZV91bnByZXBhcmUoZGV2LT5jbGspOw0KLQljbGtfcHV0KGRldi0+Y2xrKTsNCi0JaW91
bm1hcChkZXYtPmlvX2Jhc2UpOw0KLQlrZnJlZShkZXYpOw0KLQ0KLQlzbWlfYmFzZSA9IHBsYXRm
b3JtX2dldF9yZXNvdXJjZShwZGV2LCBJT1JFU09VUkNFX01FTSwgMCk7DQotCXJlbGVhc2VfbWVt
X3JlZ2lvbihzbWlfYmFzZS0+c3RhcnQsIHJlc291cmNlX3NpemUoc21pX2Jhc2UpKTsNCiAJcGxh
dGZvcm1fc2V0X2RydmRhdGEocGRldiwgTlVMTCk7DQogDQogCXJldHVybiAwOw0KLS0gDQoxLjcu
MTAuNA0KDQo=


--=-/74K4N44AkpYrLXJDpCI--

--=-/dTG7MKRI3+2+fkfYs+G
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJQN5MPAAoJECmIfjd9wqK0a8MQAItWdhIIBdtKpmdLgZOkIt6Z
LuWGAfdZ7ulpa33pL4j13I+++FCmVYty97lO4Ph1GApghxDlUMfqYdKkbPG2iMI0
5L0/gxqK0mduiM4JAlEi9UaftB6EOOdry8SS3zmpD8niu16Nje+2EImcqZawYYX5
RB3wpSlzqnrs+9gJQLizcSnB863t9JnqOLZOnKwwcSdlvUA/GDH8Ja2YM3Iqm1po
eJLyye7Z44ViB0/maY7gwUJIA5tiSKXcyK4YqyaeVUd102m5QN6aYHey1+SlrLN+
KBkOJZH10Bkji7Ot6r+PJU8k/d3b3OnsCOjIYJOj/01q/bM8vJHj3UIazjJTyEle
wKjTMj1Y5kC0MRHcvJ8shrF750A0iwlE3ar4kzC/bqkzxWFHYeEJ+IbnROwX7u7C
rz5bSGjg0J1mFa6aNFQET+eas3wJShV/wLtS1MaJnp6cHUdXi5vfgdd6aZUBUa3P
K7dmXyn0CQn91zhyugsjWtcsf6ajY0xAuSpTypAS2kTFMn58L5WDQXT4h254dPPS
QylxdpjGRdITqDaEuAXlwBz/3TT4F1/TeHrqDCZCWjXIs3jq/sjQWqqEWXYOhCNg
1w5ahXCyaflxAP6Th8Evz1CTjcbsAFL5B7IeB6yoycSc1gawiVhIAf4OZxvt6nA7
IWtmc3T41/YN6Pj3v4hs
=F4/D
-----END PGP SIGNATURE-----

--=-/dTG7MKRI3+2+fkfYs+G--

