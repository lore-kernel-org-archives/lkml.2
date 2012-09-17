Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753949Ab2IQHhN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 03:37:13 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:47869 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751912Ab2IQHhL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 03:37:11 -0400
Date: Mon, 17 Sep 2012 17:37:06 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jiri Slaby <jslaby@suse.cz>,
        Samuel Iglesias Gonsalvez <siglesias@igalia.com>
Subject: linux-next: manual merge of the staging tree with the tty tree
Message-Id: <20120917173706.44575edebd95adaebe557b67@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__17_Sep_2012_17_37_06_+1000_y8eEsHjPxA10PMxv"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__17_Sep_2012_17_37_06_+1000_y8eEsHjPxA10PMxv
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

Today's linux-next merge of the staging tree got a conflict in
drivers/staging/ipack/devices/ipoctal.c between commit 734cc1783816
("TTY: use tty_port_register_device") from the tty tree and commit
d04600679ba0 ("Staging: ipack/devices/ipoctal: simplify ipoctal_write_tty
()") from the staging tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/staging/ipack/devices/ipoctal.c
index a68d981,2cdbf28..0000000
--- a/drivers/staging/ipack/devices/ipoctal.c
+++ b/drivers/staging/ipack/devices/ipoctal.c
@@@ -490,19 -429,26 +429,26 @@@ static int ipoctal_inst_slot(struct ipo
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
@@@ -613,23 -540,17 +540,17 @@@ static void ipoctal_set_termios(struct=20
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

--Signature=_Mon__17_Sep_2012_17_37_06_+1000_y8eEsHjPxA10PMxv
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQVtMiAAoJEECxmPOUX5FEd38QAI9D0Wi94yPDgrA4Fl2NHPA2
kFnso9WisDM8tHw3HZXfWrtmCRD6uQvjLgNAyxKSDIcsM6/PjduvybpBLOBOjPYO
P9Xmn7AI+HDFW2ubScbczYL6PQ7l0eGDS0at2VpZ+f/txZVNhM45zXMMQSMImJuN
NZA35//fbXaOEzf4IWdLqIGpy10HbqYAxmH8H8O4grcc3grBtXjg/cduBVxvtgTj
C4G6a5ERQekPfI6nueIBzLa5WwfdALeKFx3tbs9/UyTtB85mQ7bPPW03wsgqgZXS
OF09tFRtGYl2PDC/5zWYlSsJY60RxaApBRqQZat09wtJ5umiUrHcw7ose52fxqcd
LCfFF6eLiEYmVOYRwm//sQGx6vSjMJyr2gfX7y43dYlcZKqu9zdWMgjNsNNeBIp6
uF4g7oi4OSBkY7AcZ1uS5r9EWpskTHkiU1bib5vGdFQFs+F0fHKiG4a0B1uKrGDy
bgnzUSPEMxcfbQ7BY7h1WuPipVkFbRTM69Z62LIlBG4MkBp/i9gPA8CnQMokUrGw
abKLmYMiVT/uAwAvjUijKdWLZqTot0OZ/U255VCX36EqKZKGQ7AJ8Lct+bZ92uSg
efgqTmZJMwea2ZacQhafLpuVtY3T5jlAsyAzTUIdf7MdzfC6KjZTqHU7FXhc6FbU
By599gpFrOWShqQp6lyb
=CuQy
-----END PGP SIGNATURE-----

--Signature=_Mon__17_Sep_2012_17_37_06_+1000_y8eEsHjPxA10PMxv--
