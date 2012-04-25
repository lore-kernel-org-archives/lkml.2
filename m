Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758511Ab2DYCl6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 22:41:58 -0400
Received: from cantor2.suse.de ([195.135.220.15]:48271 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754157Ab2DYCl5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 22:41:57 -0400
Date: Wed, 25 Apr 2012 12:41:53 +1000
From: NeilBrown <neilb@suse.de>
To: Evgeniy Polyakov <zbr@ioremap.net>
Cc: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org
Subject: [PATCH 2/2] ARM: omap_hdq: use wait_event_timeout to wait for read
 to complete.
Message-ID: <20120425124153.2afa318b@notabene.brown>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/Byvb+x7.RNoVf8/1eqchkOo"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/Byvb+x7.RNoVf8/1eqchkOo
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable


There is no gain in having a loop - there is no risk of missing the
interrupt with wait_event_timeout.

Signed-off-by: NeilBrown <neilb@suse.de>
---
 drivers/w1/masters/omap_hdq.c |   15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

diff --git a/drivers/w1/masters/omap_hdq.c b/drivers/w1/masters/omap_hdq.c
index 3356d75..eb01c7f 100644
--- a/drivers/w1/masters/omap_hdq.c
+++ b/drivers/w1/masters/omap_hdq.c
@@ -357,7 +357,6 @@ static int hdq_read_byte(struct hdq_data *hdq_data, u8 =
*val)
 {
 	int ret =3D 0;
 	u8 status;
-	unsigned long timeout =3D jiffies + OMAP_HDQ_TIMEOUT;
=20
 	ret =3D mutex_lock_interruptible(&hdq_data->hdq_mutex);
 	if (ret < 0) {
@@ -375,15 +374,13 @@ static int hdq_read_byte(struct hdq_data *hdq_data, u=
8 *val)
 			OMAP_HDQ_CTRL_STATUS_DIR | OMAP_HDQ_CTRL_STATUS_GO,
 			OMAP_HDQ_CTRL_STATUS_DIR | OMAP_HDQ_CTRL_STATUS_GO);
 		/*
-		 * The RX comes immediately after TX. It
-		 * triggers another interrupt before we
-		 * sleep. So we have to wait for RXCOMPLETE bit.
+		 * The RX comes immediately after TX.
 		 */
-		while (!(hdq_data->hdq_irqstatus
-			& OMAP_HDQ_INT_STATUS_RXCOMPLETE)
-			&& time_before(jiffies, timeout)) {
-			schedule_timeout_uninterruptible(1);
-		}
+		wait_event_timeout(hdq_wait_queue,
+				   (hdq_data->hdq_irqstatus
+				    & OMAP_HDQ_INT_STATUS_RXCOMPLETE),
+				   OMAP_HDQ_TIMEOUT);
+
 		hdq_reg_merge(hdq_data, OMAP_HDQ_CTRL_STATUS, 0,
 			OMAP_HDQ_CTRL_STATUS_DIR);
 		status =3D hdq_data->hdq_irqstatus;
--=20
1.7.10


--Sig_/Byvb+x7.RNoVf8/1eqchkOo
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT5dkcTnsnt1WYoG5AQLyPA/8Dz14GgEITah2Dk2eFRof/JyJMi2Vecjj
A5gPDKZSIu2yVsAO1KVYkm8NLLImm2e/KL9ya7RowBmrsZqqSZMcrmu+b2UHhKfy
AdQUEVtuPiIzeNDGDuFtHDfb0kIixyN97EETiLTFqZ2dxbmy9Day0uQVRygUYFKn
iQ1tITYiwC6poWMj0FChYLqMBGMkk3OEgR36tW4r9siY8CKDraM4A7NnDtvtffnP
gGhFGfUXaSKvM9wxTQummuAk8WSeUsTGvc0yImHW0u6FyEuDrpyV6NTlq5YcbRs6
SIS94FWY5Sb96xeD8wCvqcATISfiMsbBBxkbXvSbdmMVtK3ytKcvwSzF4ucPEbd2
3hQc0vexigNsZh0WbIo6+344OOqLjxlYO6P3WIUofBl9HGYDQxqhidfkNQFw9uXT
inRvRYeRqAvAmO8qWvJ0ggrNG+YsdOCUZrEKi18SKyLS51ZiuWi/yoCUZPwTZWYW
bkJxIaH/UwFfDW6ZYqEE/vF/Ft1bAbxCbzScK5dLXVQ06leq4K7xRT0LYN4SkVf8
82+t61g7sjJv9vv1X39Q0huxNRcVokDLSkuOkG5r9zGBSM7PzuUDU4ydtevmmeQk
g7lR07VGbzsIezEEZKCVvtAkbLmbBBMw97++hsIu1nJN7UDh89Kl9BIYkaHXumzT
rW4KydaP84Q=
=IL/C
-----END PGP SIGNATURE-----

--Sig_/Byvb+x7.RNoVf8/1eqchkOo--
