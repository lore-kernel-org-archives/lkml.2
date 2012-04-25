Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757964Ab2DYCk4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 22:40:56 -0400
Received: from cantor2.suse.de ([195.135.220.15]:48236 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754157Ab2DYCkz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 22:40:55 -0400
Date: Wed, 25 Apr 2012 12:40:49 +1000
From: NeilBrown <neilb@suse.de>
To: Evgeniy@suse.de, "Polyakov <zbr"@ioremap.net
Cc: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org
Subject: [PATCH 1/2] ARM: omap_hdq: Fix some error/debug handling.
Message-ID: <20120425124049.188bad16@notabene.brown>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/1I0tc=q.QZU8f8WnjxmOv83"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/1I0tc=q.QZU8f8WnjxmOv83
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable


- some debug messages missed spaces.  The did this because they
  broke a string onto 2 lines - badly.  That practice is currently
  out of favour, so join the two strings together, insert the space,
  and put newlines elsewhere.
- sometimes no error was returned when it should have been
- sometimes a message is printed when there is no error, rather
  than when there is one.

Signed-off-by: NeilBrown <neilb@suse.de>
---
 drivers/w1/masters/omap_hdq.c |   29 +++++++++++++++++------------
 1 file changed, 17 insertions(+), 12 deletions(-)

diff --git a/drivers/w1/masters/omap_hdq.c b/drivers/w1/masters/omap_hdq.c
index 5ef385b..3356d75 100644
--- a/drivers/w1/masters/omap_hdq.c
+++ b/drivers/w1/masters/omap_hdq.c
@@ -180,14 +180,16 @@ static int hdq_write_byte(struct hdq_data *hdq_data, =
u8 val, u8 *status)
 		hdq_data->hdq_irqstatus, OMAP_HDQ_TIMEOUT);
 	if (ret =3D=3D 0) {
 		dev_dbg(hdq_data->dev, "TX wait elapsed\n");
+		ret =3D -ETIMEDOUT;
 		goto out;
 	}
=20
 	*status =3D hdq_data->hdq_irqstatus;
 	/* check irqstatus */
 	if (!(*status & OMAP_HDQ_INT_STATUS_TXCOMPLETE)) {
-		dev_dbg(hdq_data->dev, "timeout waiting for"
-			"TXCOMPLETE/RXCOMPLETE, %x", *status);
+		dev_dbg(hdq_data->dev,
+			"timeout waiting for TXCOMPLETE/RXCOMPLETE, %x",
+			*status);
 		ret =3D -ETIMEDOUT;
 		goto out;
 	}
@@ -197,8 +199,9 @@ static int hdq_write_byte(struct hdq_data *hdq_data, u8=
 val, u8 *status)
 			OMAP_HDQ_CTRL_STATUS_GO,
 			OMAP_HDQ_FLAG_CLEAR, &tmp_status);
 	if (ret) {
-		dev_dbg(hdq_data->dev, "timeout waiting GO bit"
-			"return to zero, %x", tmp_status);
+		dev_dbg(hdq_data->dev,
+			"timeout waiting GO bit return to zero, %x",
+			tmp_status);
 	}
=20
 out:
@@ -340,8 +343,9 @@ static int omap_hdq_break(struct hdq_data *hdq_data)
 			OMAP_HDQ_CTRL_STATUS_GO, OMAP_HDQ_FLAG_CLEAR,
 			&tmp_status);
 	if (ret)
-		dev_dbg(hdq_data->dev, "timeout waiting INIT&GO bits"
-			"return to zero, %x", tmp_status);
+		dev_dbg(hdq_data->dev,
+			"timeout waiting INIT&GO bits return to zero, %x",
+			tmp_status);
=20
 out:
 	mutex_unlock(&hdq_data->hdq_mutex);
@@ -385,8 +389,9 @@ static int hdq_read_byte(struct hdq_data *hdq_data, u8 =
*val)
 		status =3D hdq_data->hdq_irqstatus;
 		/* check irqstatus */
 		if (!(status & OMAP_HDQ_INT_STATUS_RXCOMPLETE)) {
-			dev_dbg(hdq_data->dev, "timeout waiting for"
-				"RXCOMPLETE, %x", status);
+			dev_dbg(hdq_data->dev,
+				"timeout waiting for RXCOMPLETE, %x",
+				status);
 			ret =3D -ETIMEDOUT;
 			goto out;
 		}
@@ -396,7 +401,7 @@ static int hdq_read_byte(struct hdq_data *hdq_data, u8 =
*val)
 out:
 	mutex_unlock(&hdq_data->hdq_mutex);
 rtn:
-	return 0;
+	return ret;
=20
 }
=20
@@ -469,8 +474,8 @@ static int omap_hdq_put(struct hdq_data *hdq_data)
 		return -EINTR;
=20
 	if (0 =3D=3D hdq_data->hdq_usecount) {
-		dev_dbg(hdq_data->dev, "attempt to decrement use count"
-			"when it is zero");
+		dev_dbg(hdq_data->dev,
+			"attempt to decrement use count when it is zero");
 		ret =3D -EINVAL;
 	} else {
 		hdq_data->hdq_usecount--;
@@ -540,7 +545,7 @@ static void omap_w1_write_byte(void *_hdq, u8 byte)
 	mutex_unlock(&hdq_data->hdq_mutex);
=20
 	ret =3D hdq_write_byte(hdq_data, byte, &status);
-	if (ret =3D=3D 0) {
+	if (ret < 0) {
 		dev_dbg(hdq_data->dev, "TX failure:Ctrl status %x\n", status);
 		return;
 	}
--=20
1.7.10


--Sig_/1I0tc=q.QZU8f8WnjxmOv83
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT5dkMTnsnt1WYoG5AQJX6Q/+INsrJFhBmOZYO1/jIvDXFXz1vRYxwQbH
Gs31SDte8B//ibi3LmM7OwIXezWuwxFcaOruTiNqOoCX0tIa8+sY85GcqDtaglgg
FUeE8cLg4mxwH1fPxxDNM1Uy63S9fx5lbVqkPuuh1/lqZUoKzHXAvepULM0kTtOz
CDrAjD42Vq8dvsI9vh6wyuyog9DoT9n93s3oD/LN7nZ/ctelIoPtT7BxLwXWjndM
19rJev4MXtWJ9jrhU0wGKwfb9sbYR6q5Ugq9AAFdp3p5OpY9zbXWei2oZdVEHq+r
3SPxsNbqEL3zGNc8O5m6vzrZ+ZcGDLsQbeILVecNk1W+4tnxLL+zRwuhOuoIOpSE
3ZVa1jLqS8GjqeGDMt5j6GAGzzoU2qKWDlnoFLz90Iq4Y7M9jqX8aUwddvnmIWXA
ZJZDYPLmG6RjNMljSMQbanxzlHIfhlSAK1EnBEzFXWUe4MokSrQiiYTJg3Hylsj3
2c0t7E4ve3VuB0+mZCYZmI55kn/PCqPiGz6rk6m6tTlNXDi3b/PQsrMNGjF0BRKh
e2GYy5Whb6Ll0i1r0nyzTUlhh+9DejUiGwjb+rniyo8vFFeLKxZVCPfqCoI06OiI
5hS1OaNh1LXSzX2J2GY0WMbXzcXPzfA5yEoIXc4EVgTkD6qcVQylTRDk/BYPvhsv
6A12Hjfzl8U=
=P8TQ
-----END PGP SIGNATURE-----

--Sig_/1I0tc=q.QZU8f8WnjxmOv83--
