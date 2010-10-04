Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751453Ab0JDCnB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Oct 2010 22:43:01 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:37529 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751248Ab0JDCnA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Oct 2010 22:43:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=l2nrjBD+80Z5/9z3n08bsQblIKoNaP/4z9Id80MdLMIf8DNgEziaOa3LBBGBGTKIzi
         C9YvVeWrLruLRjM/uyzzns9bTsqMJAVdX89W+wZFA4oAK9Rbgtlif/wTpWGFxFe+arRa
         /rQnmt3H8MK5sqJgNv+qT0Z3LNXQGV7t5oJYU=
Date: Sun, 3 Oct 2010 19:42:57 -0700
From: Brian Harring <ferringb@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: richard.rojfors@pelagicore.com
Subject: [PATCH] tsc2007: suppress successive pen down states to avoid
 false reads
Message-ID: <20101004024257.GA24952@hrair>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ikeVEW9yuYc//A+q"
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ikeVEW9yuYc//A+q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

For the russellville platform, this makes the tsc2007 actually usable.

This patch has been kicking around MeeGo 1.0 for a while; not sure why it n=
ever
made it's way to upstream, but pushing it up that way now.

Signed-off-by: Brian Harring <ferringb@gmail.com>
---
 drivers/input/touchscreen/tsc2007.c |   68 ++++++++++++++++++++++++++-----=
----
 1 files changed, 51 insertions(+), 17 deletions(-)

diff --git a/drivers/input/touchscreen/tsc2007.c b/drivers/input/touchscree=
n/tsc2007.c
index be23780..05314fd 100644
--- a/drivers/input/touchscreen/tsc2007.c
+++ b/drivers/input/touchscreen/tsc2007.c
@@ -29,6 +29,7 @@
=20
 #define TS_POLL_DELAY			1 /* ms delay between samples */
 #define TS_POLL_PERIOD			1 /* ms delay between samples */
+#define TS_SLOW_POLL_PERIOD		20 /* ms delay between pen down check */
=20
 #define TSC2007_MEASURE_TEMP0		(0x0 << 4)
 #define TSC2007_MEASURE_AUX		(0x2 << 4)
@@ -77,6 +78,7 @@ struct tsc2007 {
 	u16			x_plate_ohms;
=20
 	bool			pendown;
+	bool			ignore_next_irq;
 	int			irq;
=20
 	int			(*get_pendown_state)(void);
@@ -228,14 +230,39 @@ static void tsc2007_work(struct work_struct *work)
 	if (ts->pendown)
 		schedule_delayed_work(&ts->work,
 				      msecs_to_jiffies(TS_POLL_PERIOD));
-	else
-		enable_irq(ts->irq);
+	else {
+		/* if we don't have the get pen down state callback we
+		 * ignore the next IRQ because it is provoked when we checked
+		 * the touch pressure.
+		 * If the user really touches the screen we will get a new
+		 * interrupt anyway so it is safe to ignore it
+		 *
+		 * This is basically implementing this part of the manual:
+		 * "In both cases previously listed, it is recommended that
+		 *  whenever the host writes to the TSC2007, the master
+		 *  processor masks the interrupt associated to PENIRQ.
+		 *  This masking prevents false triggering of interrupts when
+		 *  the PENIRQ line is disabled in the cases previously listed."
+		 */
+		if (!ts->get_pendown_state)
+			ts->ignore_next_irq =3D true;
+		if (ts->irq)
+			enable_irq(ts->irq);
+		else
+			schedule_delayed_work(&ts->work,
+					msecs_to_jiffies(TS_SLOW_POLL_PERIOD));
+	}
 }
=20
 static irqreturn_t tsc2007_irq(int irq, void *handle)
 {
 	struct tsc2007 *ts =3D handle;
=20
+	if (ts->ignore_next_irq) {
+		ts->ignore_next_irq =3D false;
+		return IRQ_HANDLED;
+	}
+
 	if (!ts->get_pendown_state || likely(ts->get_pendown_state())) {
 		disable_irq_nosync(ts->irq);
 		schedule_delayed_work(&ts->work,
@@ -250,15 +277,18 @@ static irqreturn_t tsc2007_irq(int irq, void *handle)
=20
 static void tsc2007_free_irq(struct tsc2007 *ts)
 {
-	free_irq(ts->irq, ts);
-	if (cancel_delayed_work_sync(&ts->work)) {
-		/*
-		 * Work was pending, therefore we need to enable
-		 * IRQ here to balance the disable_irq() done in the
-		 * interrupt handler.
-		 */
-		enable_irq(ts->irq);
-	}
+	if (ts->irq) {
+		free_irq(ts->irq, ts);
+		if (cancel_delayed_work_sync(&ts->work)) {
+			/*
+			 * Work was pending, therefore we need to enable
+			 * IRQ here to balance the disable_irq() done in the
+			 * interrupt handler.
+			 */
+			enable_irq(ts->irq);
+		}
+	} else
+		cancel_delayed_work_sync(&ts->work);
 }
=20
 static int __devinit tsc2007_probe(struct i2c_client *client,
@@ -312,12 +342,16 @@ static int __devinit tsc2007_probe(struct i2c_client =
*client,
 	if (pdata->init_platform_hw)
 		pdata->init_platform_hw();
=20
-	err =3D request_irq(ts->irq, tsc2007_irq, 0,
-			client->dev.driver->name, ts);
-	if (err < 0) {
-		dev_err(&client->dev, "irq %d busy?\n", ts->irq);
-		goto err_free_mem;
-	}
+
+	if (ts->irq) {
+		err =3D request_irq(ts->irq, tsc2007_irq, 0,
+				client->dev.driver->name, ts);
+		if (err < 0) {
+			dev_err(&client->dev, "irq %d busy?\n", ts->irq);
+			goto err_free_mem;
+		}
+	} else
+		schedule_delayed_work(&ts->work, TS_SLOW_POLL_PERIOD);
=20
 	/* Prepare for touch readings - power down ADC and enable PENIRQ */
 	err =3D tsc2007_xfer(ts, PWRDOWN);
--=20
1.7.2


--ikeVEW9yuYc//A+q
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.15 (GNU/Linux)

iEYEARECAAYFAkypPzEACgkQsiLx3HvNzgfOGACgkuBn3eCDlqNNjtRMfPpiD9LF
5GIAn24X6vGBSVN3fhXTCNFNOfa8AB2U
=UFqm
-----END PGP SIGNATURE-----

--ikeVEW9yuYc//A+q--
