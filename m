Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752312Ab2GTFCt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2012 01:02:49 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:60496 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751449Ab2GTFCr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2012 01:02:47 -0400
Date: Fri, 20 Jul 2012 15:02:37 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alan Cox <alan@linux.intel.com>
Subject: linux-next: build failure after merge of the final tree (tty tree
 related)
Message-Id: <20120720150237.af0d271624511fc18705f287@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__20_Jul_2012_15_02_37_+1000_ULKuZ18NR9lLw03S"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__20_Jul_2012_15_02_37_+1000_ULKuZ18NR9lLw03S
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the final tree, today's linux-next build (powerpc
allyesconfig) failed like this:

drivers/usb/serial/console.c: In function 'usb_console_setup':
drivers/usb/serial/console.c:168:16: error: invalid type argument of '->' (=
have 'struct ktermios')
drivers/usb/serial/console.c:169:4: error: incompatible type for argument 1=
 of 'tty_termios_encode_baud_rate'
include/linux/tty.h:449:13: note: expected 'struct ktermios *' but argument=
 is of type 'struct ktermios'

Caused by commit adc8d746caa6 ("tty: move the termios object into the
tty").  Hopefully this is the last of them.

I have added the following fix patch for today:

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Fri, 20 Jul 2012 14:58:31 +1000
Subject: [PATCH] tty: fix up usb serial console for termios change.

fixes these errors:

drivers/usb/serial/console.c: In function 'usb_console_setup':
drivers/usb/serial/console.c:168:16: error: invalid type argument of '->' (=
have 'struct ktermios')
drivers/usb/serial/console.c:169:4: error: incompatible type for argument 1=
 of 'tty_termios_encode_baud_rate'
include/linux/tty.h:449:13: note: expected 'struct ktermios *' but argument=
 is of type 'struct ktermios'

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 drivers/usb/serial/console.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/serial/console.c b/drivers/usb/serial/console.c
index b9cca6d..9a56428 100644
--- a/drivers/usb/serial/console.c
+++ b/drivers/usb/serial/console.c
@@ -165,8 +165,8 @@ static int usb_console_setup(struct console *co, char *=
options)
 		}
=20
 		if (serial->type->set_termios) {
-			tty->termios->c_cflag =3D cflag;
-			tty_termios_encode_baud_rate(tty->termios, baud, baud);
+			tty->termios.c_cflag =3D cflag;
+			tty_termios_encode_baud_rate(&tty->termios, baud, baud);
 			memset(&dummy, 0, sizeof(struct ktermios));
 			serial->type->set_termios(tty, port, &dummy);
=20
--=20
1.7.10.280.gaa39

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__20_Jul_2012_15_02_37_+1000_ULKuZ18NR9lLw03S
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQCOZtAAoJEECxmPOUX5FEx+UP/2+Fow6D7PWdvZ11gR0LtVtg
eWHm0yVjFS2TTuZAn7mWcSI9NvDGY3lq+37hl26G45EVpXqcAd1KNr0FQOgAr3Mq
UqNAu/oThdJPKekosREDihGKURylLX/5M4iPAiYSkMRz9cZrkr/BwYAq+c7Or6nA
QzK5fijpyquQD/0+UO4tFxuNLlkh/P0S2qCQTRGdmqvLsZxscwSiM//acwuO/x+3
oXlaxkMnTwW1T+wKjP7cjn7jnIhuz5zqOQ7fMHMenlUa87/kau/ihWUlHfNeFtR3
LfKlujqep0Fb4CUxJyUoYHioL9k13HhFBOQuYwDyAuYzyE2glJn4n5kMUfpRZy5y
sHsIBnPuGr+tgDj1HiXL04KzAKe3rVdZzMeRLnUXbs8WMgFxUUiME9e+pN2Otl+j
GkOIPMxJoi1BxSQ7bmU4qEr1W0thyDMhNBRXKgyC8WOEU/RHZh288h6vX0cGgBoB
6o7GjSP4Y0k52vOLG8GX/VAQDNSpCvjNGbrim7WL0S9l0gkfa4ujJWcrzOsK5J9g
rTOGT76S4zQuogL6eT4ayk/5EvfY1A4qWLDqmkpVdZBGL26H9QuzzGzrhJxei7yo
ckAlqfvrm2AfmyUEuYVh7cOdMyaynDuIeTsvLohWgRnSndEAKeEm+RvEhw8ajuoD
tcV9ny0kAgx4M2ifT0mo
=SSKd
-----END PGP SIGNATURE-----

--Signature=_Fri__20_Jul_2012_15_02_37_+1000_ULKuZ18NR9lLw03S--
