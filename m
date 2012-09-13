Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753302Ab2IMGOd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 02:14:33 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:60790 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751011Ab2IMGOb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 02:14:31 -0400
Date: Thu, 13 Sep 2012 16:14:17 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jiri Slaby <jslaby@suse.cz>,
        Jens Taprogge <jens.taprogge@taprogge.org>,
        Samuel Iglesias Gonsalvez <siglesias@igalia.com>
Subject: linux-next: manual merge of the staging tree with the tty tree
Message-Id: <20120913161417.e863926832ccf8a2e1ca1f2a@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__13_Sep_2012_16_14_17_+1000_j5_nkXyj3Ap11UcZ"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__13_Sep_2012_16_14_17_+1000_j5_nkXyj3Ap11UcZ
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

Today's linux-next merge of the staging tree got a conflict in
drivers/staging/ipack/devices/ipoctal.c between commit 734cc1783816
("TTY: use tty_port_register_device") from the tty tree and commit
2afb41d9d30d ("Staging: ipack/devices/ipoctal: Check tty_register_device
return value") from the staging tree.

I fixed it up (I think - see below) and can carry the fix as necessary
(no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/staging/ipack/devices/ipoctal.c
index a68d981,0292364..0000000
--- a/drivers/staging/ipack/devices/ipoctal.c
+++ b/drivers/staging/ipack/devices/ipoctal.c
@@@ -490,19 -417,27 +417,27 @@@ static int ipoctal_inst_slot(struct ipo
  	ipoctal->tty_drv =3D tty;
 =20
  	for (i =3D 0; i < NR_CHANNELS; i++) {
- 		tty_port_init(&ipoctal->tty_port[i]);
- 		tty_port_alloc_xmit_buf(&ipoctal->tty_port[i]);
- 		ipoctal->tty_port[i].ops =3D &ipoctal_tty_port_ops;
-=20
- 		ipoctal_reset_stats(&ipoctal->chan_stats[i]);
- 		ipoctal->nb_bytes[i] =3D 0;
- 		init_waitqueue_head(&ipoctal->queue[i]);
-=20
- 		spin_lock_init(&ipoctal->lock[i]);
- 		ipoctal->pointer_read[i] =3D 0;
- 		ipoctal->pointer_write[i] =3D 0;
- 		ipoctal->nb_bytes[i] =3D 0;
- 		tty_port_register_device(&ipoctal->tty_port[i], tty, i, NULL);
+ 		struct device *tty_dev;
+=20
+ 		channel =3D &ipoctal->channel[i];
+ 		tty_port_init(&channel->tty_port);
+ 		tty_port_alloc_xmit_buf(&channel->tty_port);
+ 		channel->tty_port.ops =3D &ipoctal_tty_port_ops;
+=20
+ 		ipoctal_reset_stats(&channel->stats);
+ 		channel->nb_bytes =3D 0;
+ 		init_waitqueue_head(&channel->queue);
+=20
+ 		spin_lock_init(&channel->lock);
+ 		channel->pointer_read =3D 0;
+ 		channel->pointer_write =3D 0;
+ 		channel->nb_bytes =3D 0;
 -		tty_dev =3D tty_register_device(tty, i, NULL);
++		tty_dev =3D tty_port_register_device(&channel->tty_port, tty, i, NULL);
+ 		if (IS_ERR(tty_dev)) {
+ 			dev_err(&ipoctal->dev->dev, "Failed to register tty device.\n");
+ 			continue;
+ 		}
+ 		dev_set_drvdata(tty_dev, channel);
 =20
  		/*
  		 * Enable again the RX. TX will be enabled when
@@@ -613,23 -529,17 +529,17 @@@ static void ipoctal_set_termios(struct=20
  	unsigned char mr1 =3D 0;
  	unsigned char mr2 =3D 0;
  	unsigned char csr =3D 0;
- 	unsigned int channel =3D tty->index;
- 	struct ipoctal *ipoctal =3D tty->driver_data;
+ 	struct ipoctal_channel *channel =3D tty->driver_data;
  	speed_t baud;
 =20
 -	cflag =3D tty->termios->c_cflag;
 +	cflag =3D tty->termios.c_cflag;
 =20
  	/* Disable and reset everything before change the setup */
- 	ipoctal_write_io_reg(ipoctal, &ipoctal->chan_regs[channel].u.w.cr,
- 			     CR_DISABLE_RX | CR_DISABLE_TX);
- 	ipoctal_write_cr_cmd(ipoctal, &ipoctal->chan_regs[channel].u.w.cr,
- 			     CR_CMD_RESET_RX);
- 	ipoctal_write_cr_cmd(ipoctal, &ipoctal->chan_regs[channel].u.w.cr,
- 			     CR_CMD_RESET_TX);
- 	ipoctal_write_cr_cmd(ipoctal, &ipoctal->chan_regs[channel].u.w.cr,
- 			     CR_CMD_RESET_ERR_STATUS);
- 	ipoctal_write_cr_cmd(ipoctal, &ipoctal->chan_regs[channel].u.w.cr,
- 			     CR_CMD_RESET_MR);
+ 	iowrite8(CR_DISABLE_RX | CR_DISABLE_TX, &channel->regs->w.cr);
+ 	iowrite8(CR_CMD_RESET_RX, &channel->regs->w.cr);
+ 	iowrite8(CR_CMD_RESET_TX, &channel->regs->w.cr);
+ 	iowrite8(CR_CMD_RESET_ERR_STATUS, &channel->regs->w.cr);
+ 	iowrite8(CR_CMD_RESET_MR, &channel->regs->w.cr);
 =20
  	/* Set Bits per chars */
  	switch (cflag & CSIZE) {

--Signature=_Thu__13_Sep_2012_16_14_17_+1000_j5_nkXyj3Ap11UcZ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQUXm5AAoJEECxmPOUX5FElxIP/i5YbA70l4y/PlJnBI0NpusX
7cQOd9Q+Xltr4WIrImJH2ej9UBH03XTFbRbjoxbYVjv8w5QyNgtnGcQ9dJmxdWTs
KYH0KhdNu34BhzOuitydbTIwLg1AymCsQFFbkzazaKL9aME3ZrtwN2wBdQ4sJD2B
7t92C3p+zcuXhVLHAoglXFj+2AGg0CCyscF/hMaGkSQNayd77dJt8oyP7UuayVfh
/9rUMudOCjwoHMCxUDMK4DwbaqIjTvLXg3Hy80H8O4mE35acJDXxb3VB2I96bAmC
AQ/zwj0OgZkC+v4q7X8NGlk9sceqINd/rNDyR40H+9w+TNTAKIZSpNpHn/OYtQ8z
SbW6FPVK26Sc17NqttgwuC66fbmTir9ZP71oKayxvN8fcaymClxtDliPlHKwmewB
qbildXB6KviCUHKn0sHHg+IrnYs0eMfdjP87BwO9eyNxLWZrhsHeJ7vNWJFyjS7d
R441jVbtxKWnFff4hNIvdGybVpyQkzHwYPPXfN8n0aNMQwE/MW0Lps+gmEf4o/Ws
BmVusCPxkMq4FIk8xXy9vyojL0Wc2R0ITjTEyvDdh0oaSI5uuNC2mMqNh6ZQCxWJ
5wnfmvDCexsA2ehegySUShWP9DQkvmgcaBDjmgb5BkfZ2YF8TFmwcBrud8/KbSS9
7cuJ2hJW2RjGsowbjT+m
=2Yhd
-----END PGP SIGNATURE-----

--Signature=_Thu__13_Sep_2012_16_14_17_+1000_j5_nkXyj3Ap11UcZ--
