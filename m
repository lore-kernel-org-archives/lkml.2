Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758780Ab2DYCVu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 22:21:50 -0400
Received: from cantor2.suse.de ([195.135.220.15]:47876 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757963Ab2DYCVs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 22:21:48 -0400
Date: Wed, 25 Apr 2012 12:21:39 +1000
From: NeilBrown <neilb@suse.de>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] Input: twl4030 power button: don't lose presses on resume
Message-ID: <20120425122139.512c6890@notabene.brown>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_//bb2q48H3UBxAsEvlKIkE+m"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_//bb2q48H3UBxAsEvlKIkE+m
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable


If we press and release the power button before the press interrupt is
handled - as can happen on resume - we lose the press event so the
release event is ignored and we don't know what happened to cause the
wakeup.

So make sure that each interrupt handled does generate an event.
Because twl4030 queues interrupt events we will see two interrupts
for a press-release even if we handle the first one later.  This means
that such a sequence will be reported as two button presses.  This
is unfortunate but is better than no button presses.
Possibly we could set the PENDDIS_MASK to disable queuing of
interrupts, but that might adversely affect other interrupt sources.

Signed-off-by: NeilBrown <neilb@suse.de>

diff --git a/drivers/input/misc/twl4030-pwrbutton.c b/drivers/input/misc/tw=
l4030-pwrbutton.c
index 38e4b50..7ea0ea8 100644
--- a/drivers/input/misc/twl4030-pwrbutton.c
+++ b/drivers/input/misc/twl4030-pwrbutton.c
@@ -42,7 +42,19 @@ static irqreturn_t powerbutton_irq(int irq, void *_pwr)
 	err =3D twl_i2c_read_u8(TWL4030_MODULE_PM_MASTER, &value,
 				STS_HW_CONDITIONS);
 	if (!err)  {
-		input_report_key(pwr, KEY_POWER, value & PWR_PWRON_IRQ);
+		int val =3D !!(value & PWR_PWRON_IRQ);
+
+		/* We got an interrupt, so we must see a change.
+		 * Because the TWL4030 queues pending interrupts to a depth
+		 * of 2, we end up seeing two key presses as there can
+		 * be two interrupts processed while the key appears to
+		 * be up.  This could be fixed by setting PNEDDIS_MASK
+		 * in PWR_SIH_CTRL in twl4030-irq.c.
+		 */
+		input_report_key(pwr, KEY_POWER, !val);
+		input_sync(pwr);
+
+		input_report_key(pwr, KEY_POWER, val);
 		input_sync(pwr);
 	} else {
 		dev_err(pwr->dev.parent, "twl4030: i2c error %d while reading"

--Sig_//bb2q48H3UBxAsEvlKIkE+m
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT5dfsznsnt1WYoG5AQJHTQ/+Iu3lt65ETh/nlDYmGRtFRRWl3hyk936C
kiQvvb31CzX5gopT40iQC2754KcVrHnOBC3OnWCDpmpAc6lqq+o40ysRbvhsdPzP
UMgzYs71TEKHxP0IsPr0yd667uXkcofUtifrsdO+bgYfDd/Vmw0kiDzYZYGkwY54
M5E+wY4aYK2GPGaG9WsXHdCQOtCJiIybAVF1aOK5vjh87x9o0j0i8Ylhsp2G+1Xy
2X7nriqi3A3v/nh9ASmlGmZMBAgILYY8tjMB77pj2V51SWK1Mk5Dnhnu63vOnRn/
tGKAmeJK8ybZhTFlXctS2mwhbpYNQGTUuQVYds0sdZ6xjgDPA3XtOB8GfYjYBsSs
CUDOtb7odecrHPnOko1w4I7JarP0zF3NbtpiCR3hhnYO4Eb3FBP83I3JW0KChCJd
kdJQopaYcaCG3xMURannZPrErCxTK7xrSyA0AUbID973rQn1kqZqJ7Bwy0l6icbI
LDycMp11P4JPrfuR97yJv300Z/zqA751NPoufnQjiDIB3mMW5mHQX0o70+W9v6pu
8PwtxG5K8GmboHuFrWFQBw1f4euc9f2D/JqaNvc6AxBF0bg+ajAElOq33h33qftX
LWCRItSoT1SL7tMFmKqB1swpeNZgTyPEz1OcNAhBhFyh84CN7E4jANmrKiUCZqaQ
BOp8C5yj9pU=
=5scQ
-----END PGP SIGNATURE-----

--Sig_//bb2q48H3UBxAsEvlKIkE+m--
