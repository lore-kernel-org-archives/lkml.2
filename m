Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752149Ab2IMNYO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 09:24:14 -0400
Received: from roc.holo.8d.com ([64.254.227.115]:44317 "EHLO roc.holo.8d.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751224Ab2IMNYM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 09:24:12 -0400
Message-ID: <5051DE77.2060305@8d.com>
Date: Thu, 13 Sep 2012 09:24:07 -0400
From: =?ISO-8859-1?Q?Rapha=EBl_Ass=E9nat?= <raph@8d.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.5) Gecko/20120624 Icedove/10.0.5
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Evgeniy Polyakov <zbr@ioremap.net>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] 1-Wire: Add support for the maxim ds1825 temperature
 sensor
References: <20120816165639.GB22993@renkinjitsu.usine.8d.com> <20120818094818.GA11844@ioremap.net> <20120905210758.GD27262@kroah.com> <20120906182524.GA5237@ioremap.net> <20120910233849.GA25405@kroah.com>
In-Reply-To: <20120910233849.GA25405@kroah.com>
X-Enigmail-Version: 1.4.1
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig9835504E2FE7285A7C13E4E4"
X-Spam-Score: -2.6
X-Spam-Report: -2.6 points, 5.0 required autolearn=ham
	-2.6 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig9835504E2FE7285A7C13E4E4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hello Greg,

On 10/09/12 07:38 PM, Greg KH wrote:
> On Thu, Sep 06, 2012 at 10:25:24PM +0400, Evgeniy Polyakov wrote:
>> Hi
>>
>> On Wed, Sep 05, 2012 at 02:07:58PM -0700, Greg KH (greg@kroah.com) wro=
te:
>>>> Greg, please pull it into your tree
>>>> Acked-by: Evgeniy Polyakov <zbr@ioremap.net>
>>>
>>> I can't seem to find the original patch here, can someone please rese=
nd
>>> it to me, with Evgeniy's ack added to it so I can apply it?
>>
>> Here is patchwork link
>> Do you need it with my ack?
>>
>> https://patchwork.kernel.org/patch/1272361/
>=20
> That link doesn't have a signed-off-by: from the original author.
>=20
> Raphael, can you resend this to me with your signed-off-by: and
> Evgeniy's acked-by added?

Certainly, here is the patch with the Signed-off-by and Acked-by lines ad=
ded.

---

This patch adds support for maxim ds1825 based 1-wire temperature sensors=
=2E

Signed-off-by: Raphael Assenat <raph@8d.com>
Acked-by: Evgeniy Polyakov <zbr@ioremap.net>

diff --git a/Documentation/w1/slaves/w1_therm b/Documentation/w1/slaves/w=
1_therm
index 0403aaa..874a8ca 100644
--- a/Documentation/w1/slaves/w1_therm
+++ b/Documentation/w1/slaves/w1_therm
@@ -3,6 +3,7 @@ Kernel driver w1_therm
=20
 Supported chips:
   * Maxim ds18*20 based temperature sensors.
+  * Maxim ds1825 based temperature sensors.
=20
 Author: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
=20
@@ -15,6 +16,7 @@ supported family codes:
 W1_THERM_DS18S20	0x10
 W1_THERM_DS1822		0x22
 W1_THERM_DS18B20	0x28
+W1_THERM_DS1825		0x3B
=20
 Support is provided through the sysfs w1_slave file.  Each open and
 read sequence will initiate a temperature conversion then provide two
diff --git a/drivers/w1/slaves/w1_therm.c b/drivers/w1/slaves/w1_therm.c
index ff29ae7..b34bf1d 100644
--- a/drivers/w1/slaves/w1_therm.c
+++ b/drivers/w1/slaves/w1_therm.c
@@ -91,6 +91,11 @@ static struct w1_family w1_therm_family_DS28EA00 =3D {=

 	.fops =3D &w1_therm_fops,
 };
=20
+static struct w1_family w1_therm_family_DS1825 =3D {
+	.fid =3D W1_THERM_DS1825,
+	.fops =3D &w1_therm_fops,
+};
+
 struct w1_therm_family_converter
 {
 	u8			broken;
@@ -120,6 +125,10 @@ static struct w1_therm_family_converter w1_therm_fam=
ilies[] =3D {
 		.f		=3D &w1_therm_family_DS28EA00,
 		.convert	=3D w1_DS18B20_convert_temp
 	},
+	{
+		.f		=3D &w1_therm_family_DS1825,
+		.convert	=3D w1_DS18B20_convert_temp
+	}
 };
=20
 static inline int w1_DS18B20_convert_temp(u8 rom[9])
diff --git a/drivers/w1/w1_family.h b/drivers/w1/w1_family.h
index 874aeb0..b998c30 100644
--- a/drivers/w1/w1_family.h
+++ b/drivers/w1/w1_family.h
@@ -38,6 +38,7 @@
 #define W1_EEPROM_DS2431	0x2D
 #define W1_FAMILY_DS2760	0x30
 #define W1_FAMILY_DS2780	0x32
+#define W1_THERM_DS1825		0x3B
 #define W1_FAMILY_DS2781	0x3D
 #define W1_THERM_DS28EA00	0x42
=20


--------------enig9835504E2FE7285A7C13E4E4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlBR3ncACgkQu3aLmFcr6L3iBgCgrdu0nhbE7SQ7zYXq3OSu80lu
9AEAoJx4fYeDm3qaM/rkmg5t5oufMQHu
=lA46
-----END PGP SIGNATURE-----

--------------enig9835504E2FE7285A7C13E4E4--
