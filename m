Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757215Ab0FOKUv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 06:20:51 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:44895 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757049Ab0FOKUt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 06:20:49 -0400
Message-ID: <4C1753F6.3080106@pengutronix.de>
Date: Tue, 15 Jun 2010 12:20:38 +0200
From: Marc Kleine-Budde <mkl@pengutronix.de>
Organization: Pengutronix
User-Agent: Thunderbird 2.0.0.24 (X11/20100317)
MIME-Version: 1.0
To: "Ben Dooks (embedded platforms)" <ben-linux@fluff.org>
CC: Marc Kleine-Budde <mkl@pengutronix.de>, Sascha Hauer <sha@pengutronix.de>,
       linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH V2] i2c-imx: do not allow interruptions when waiting for I2C
 to complete (resend)
X-Enigmail-Version: 0.95.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig3D1DC01A74CB43C625E9F994"
X-SA-Exim-Connect-IP: 2001:6f8:1178:4:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig3D1DC01A74CB43C625E9F994
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

The i2c_imx_trx_complete() function is using
wait_event_interruptible_timeout() to wait for the I2C controller to
signal that it has completed an I2C bus operation. If the process that
causes the I2C operation receives a signal, the wait will be
interrupted, returning an error. It is better to let the I2C operation
finished before handling the signal (i.e. returning into userspace).

It is safe to use wait_event_timeout() instead, because the timeout
will allow the process to exit if the I2C bus hangs. It's also better
to allow the I2C operation to finish, because unacknowledged I2C
operations can cause the I2C bus to hang.

Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Reviewed-by: Wolfram Sang <w.sang@pengutronix.de>
---

V2: Remove check for "result < 0" as commented by Wolfram Sang.

 drivers/i2c/busses/i2c-imx.c |    9 +++------
 1 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/i2c/busses/i2c-imx.c b/drivers/i2c/busses/i2c-imx.c
index d1ff940..58df809 100644
--- a/drivers/i2c/busses/i2c-imx.c
+++ b/drivers/i2c/busses/i2c-imx.c
@@ -161,13 +161,10 @@ static int i2c_imx_trx_complete(struct
imx_i2c_struct *i2c_imx)
 {
 	int result;

-	result =3D wait_event_interruptible_timeout(i2c_imx->queue,
+	result =3D wait_event_timeout(i2c_imx->queue,
 		i2c_imx->i2csr & I2SR_IIF, HZ / 10);

-	if (unlikely(result < 0)) {
-		dev_dbg(&i2c_imx->adapter.dev, "<%s> result < 0\n", __func__);
-		return result;
-	} else if (unlikely(!(i2c_imx->i2csr & I2SR_IIF))) {
+	if (unlikely(!(i2c_imx->i2csr & I2SR_IIF))) {
 		dev_dbg(&i2c_imx->adapter.dev, "<%s> Timeout\n", __func__);
 		return -ETIMEDOUT;
 	}
@@ -295,7 +292,7 @@ static irqreturn_t i2c_imx_isr(int irq, void *dev_id)=

 		i2c_imx->i2csr =3D temp;
 		temp &=3D ~I2SR_IIF;
 		writeb(temp, i2c_imx->base + IMX_I2C_I2SR);
-		wake_up_interruptible(&i2c_imx->queue);
+		wake_up(&i2c_imx->queue);
 		return IRQ_HANDLED;
 	}

--=20
1.7.1


--------------enig3D1DC01A74CB43C625E9F994
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAkwXU/sACgkQjTAFq1RaXHOY2gCdEu745+5db/OFd2wvoWW0AFzp
ejEAn0QA+T5EqPgHpDUMPnhMb0fJ56sY
=m7zX
-----END PGP SIGNATURE-----

--------------enig3D1DC01A74CB43C625E9F994--
