Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759952Ab0FQMyP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 08:54:15 -0400
Received: from coyote.quickmin.net ([217.14.112.24]:50600 "EHLO
	coyote.quickmin.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753402Ab0FQMyO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 08:54:14 -0400
Comment: DomainKeys? See http://antispam.yahoo.com/domainkeys
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=default; d=telemotive.de;
  b=FvZNL/l9TUHFO7VKY7qJ7iv6x6OCfCiqsxBElVV1ueYteUy5r03j0Pc7GUhvfzaqm3xqWpR14eooj1yC4A0nLGXo7beW0fKrCrSqw6dwxG0MfmWodiK+kNZ7p6FiaO5OQMzDu3Tgaz40ZrWC4AsMv7gRRznFBBDKUJHowKQvlmg=  ;
From: Roman Fietze <roman.fietze@telemotive.de>
Organization: Telemotive AG
To: Wan ZongShun <mcuos.com@gmail.com>
Subject: Re: [rtc-linux] [PATCH] isl12022: added Intersil ISL12022 RTC
User-Agent: KMail/1.13.3 (Linux/2.6.31.12-0.2-default; KDE/4.4.3; x86_64; ; )
Cc: rtc-linux@googlegroups.com, Alessandro Zummo <a.zummo@towertech.it>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel" <linux-kernel@vger.kernel.org>
References: <201006171123.31484.roman.fietze@telemotive.de> <AANLkTilPqFdeMLSabEkrwIQieJU0vhLnSBVe5_LH8x0G@mail.gmail.com>
In-Reply-To: <AANLkTilPqFdeMLSabEkrwIQieJU0vhLnSBVe5_LH8x0G@mail.gmail.com>
MIME-Version: 1.0
Message-ID: <201006171454.07593.roman.fietze@telemotive.de>
Date: Thu, 17 Jun 2010 14:54:06 +0200
X-MIMETrack: Itemize by SMTP Server on muc/Telemotive(Release 8.0.2FP1|January 12, 2009) at
 17.06.2010 14:54:08,
	Serialize by Router on muc/Telemotive(Release 8.0.2FP1|January 12, 2009) at
 17.06.2010 14:54:09,
	Serialize complete at 17.06.2010 14:54:09
Content-Transfer-Encoding: 7bit
Content-Type: multipart/signed;
  boundary="nextPart58038543.sL3kjBc6Sc";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart58038543.sL3kjBc6Sc
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

Hallo Wan,

Thanks for the review. I added an second patch here with the proposed
changes. Should I better provide an all-in-one patch instead?

On Thursday 17 June 2010 12:28:11 Wan ZongShun wrote:

> There is no need to print your private driver info in Kernel, please
> get rid of it.

Ok, I thought its good habit, just copied that 1:1 from rtc-pcf8563.c
as well as the stuff with the check for ->rtc beeing zero and the
order of the module macros. I can of course also provide a patch for
rtc-pcf8563.c with the same changes.


=46rom 134f8488933f723489d5cf244c0b54bde1ce3622 Mon Sep 17 00:00:00 2001
=46rom: Roman Fietze <roman.fietze@telemotive.de>
Date: Thu, 17 Jun 2010 14:45:36 +0200
Subject: [PATCH] rtc-isl12022: omit checking ->rtc in remove function, reor=
der module macros

=2D isl12022->rtc cannot be NULL inside isl12022_remove
=2D move up module init and exit macros
=2D be less verbose inside probe function

Signed-off-by: Roman Fietze <roman.fietze@telemotive.de>
=2D--
 drivers/rtc/rtc-isl12022.c |   14 +++++---------
 1 files changed, 5 insertions(+), 9 deletions(-)

diff --git a/drivers/rtc/rtc-isl12022.c b/drivers/rtc/rtc-isl12022.c
index e0a340f..293d2c1 100644
=2D-- a/drivers/rtc/rtc-isl12022.c
+++ b/drivers/rtc/rtc-isl12022.c
@@ -236,8 +236,6 @@ static int isl12022_probe(struct i2c_client *client,
=20
 	int ret =3D 0;
=20
=2D	dev_dbg(&client->dev, "%s\n", __func__);
=2D
 	if (!i2c_check_functionality(client->adapter, I2C_FUNC_I2C))
 		return -ENODEV;
=20
@@ -245,7 +243,7 @@ static int isl12022_probe(struct i2c_client *client,
 	if (!isl12022)
 		return -ENOMEM;
=20
=2D	dev_info(&client->dev, "chip found, driver version " DRV_VERSION "\n");
+	dev_dbg(&client->dev, "chip found, driver version " DRV_VERSION "\n");
=20
 	i2c_set_clientdata(client, isl12022);
=20
@@ -269,9 +267,7 @@ static int isl12022_remove(struct i2c_client *client)
 {
 	struct isl12022 *isl12022 =3D i2c_get_clientdata(client);
=20
=2D	if (isl12022->rtc)
=2D		rtc_device_unregister(isl12022->rtc);
=2D
+	rtc_device_unregister(isl12022->rtc);
 	kfree(isl12022);
=20
 	return 0;
@@ -303,10 +299,10 @@ static void __exit isl12022_exit(void)
 	i2c_del_driver(&isl12022_driver);
 }
=20
+module_init(isl12022_init);
+module_exit(isl12022_exit);
+
 MODULE_AUTHOR("roman.fietze@telemotive.de");
 MODULE_DESCRIPTION("ISL 12022 RTC driver");
 MODULE_LICENSE("GPL");
 MODULE_VERSION(DRV_VERSION);
=2D
=2Dmodule_init(isl12022_init);
=2Dmodule_exit(isl12022_exit);
=2D-=20
1.7.1




Roman

=2D-=20
Roman Fietze                Telemotive AG B=C3=BCro M=C3=BChlhausen
Breitwiesen                              73347 M=C3=BChlhausen
Tel.: +49(0)7335/18493-45        http://www.telemotive.de

Amtsgericht Ulm                                HRB 541321
Vorstand:
Peter Kersten, Markus Fischer, Franz Diller, Markus Stolz

--nextPart58038543.sL3kjBc6Sc
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.15 (GNU/Linux)

iEUEABECAAYFAkwaGu8ACgkQp5XY/BK//MJSQQCXZJbm+HWy+hDxlLa0u15UqF1A
1QCggcXBP0GQ03/JxbzyTLHLVmjzVPc=
=eQcS
-----END PGP SIGNATURE-----

--nextPart58038543.sL3kjBc6Sc--
