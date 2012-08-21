Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756914Ab2HULNx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 07:13:53 -0400
Received: from na3sys009aog103.obsmtp.com ([74.125.149.71]:57410 "EHLO
	na3sys009aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755278Ab2HULNv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 07:13:51 -0400
Date: Tue, 21 Aug 2012 14:09:52 +0300
From: Felipe Balbi <balbi@ti.com>
To: Felipe Balbi <balbi@ti.com>
Cc: "Shilimkar, Santosh" <santosh.shilimkar@ti.com>, alan@linux.intel.com,
        Tony Lindgren <tony@atomide.com>, Kevin Hilman <khilman@ti.com>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>,
        linux-serial@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Shubhrajyoti Datta <shubhrajyoti@ti.com>
Subject: Re: [RFC/PATCH 10/13] serial: omap: stick to put_autosuspend
Message-ID: <20120821110951.GZ10347@arwen.pp.htv.fi>
Reply-To: balbi@ti.com
References: <1345540555-24359-1-git-send-email-balbi@ti.com>
 <1345540555-24359-11-git-send-email-balbi@ti.com>
 <CAMQu2gzm4z8DbCiz4hOS2nKa2HzNofmp=SPORYEu2Z_H3+JN9Q@mail.gmail.com>
 <20120821105702.GX10347@arwen.pp.htv.fi>
 <CAMQu2gzJ2YksrJKPLNZ9pBoBoSih2Up=isca=X9Wsd5MsnNrTQ@mail.gmail.com>
 <20120821110245.GY10347@arwen.pp.htv.fi>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Ix2jQZQ3wXOip0b1"
Content-Disposition: inline
In-Reply-To: <20120821110245.GY10347@arwen.pp.htv.fi>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Ix2jQZQ3wXOip0b1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Aug 21, 2012 at 02:02:46PM +0300, Felipe Balbi wrote:
> On Tue, Aug 21, 2012 at 04:35:26PM +0530, Shilimkar, Santosh wrote:
> > On Tue, Aug 21, 2012 at 4:27 PM, Felipe Balbi <balbi@ti.com> wrote:
> > > On Tue, Aug 21, 2012 at 04:12:11PM +0530, Shilimkar, Santosh wrote:
> > >> On Tue, Aug 21, 2012 at 2:45 PM, Felipe Balbi <balbi@ti.com> wrote:
> > >> > Everytime we're done using our TTY, we want
> > >> > the pm timer to be reinitilized. By sticking
> > >> > to pm_runtime_pm_autosuspend() we make sure
> > >> > that this will always be the case.
> > >> >
> > >> > Signed-off-by: Felipe Balbi <balbi@ti.com>
> > >> > ---
> > >> >  drivers/tty/serial/omap-serial.c | 33 ++++++++++++++++++++++-----=
------
> > >> >  1 file changed, 22 insertions(+), 11 deletions(-)
> > >> >
> > >> > diff --git a/drivers/tty/serial/omap-serial.c b/drivers/tty/serial=
/omap-serial.c
> > >> > index 6ea24c5..458d77c 100644
> > >> > --- a/drivers/tty/serial/omap-serial.c
> > >> > +++ b/drivers/tty/serial/omap-serial.c
> > >> > @@ -164,7 +164,8 @@ static void serial_omap_enable_ms(struct uart_=
port *port)
> > >> >         pm_runtime_get_sync(up->dev);
> > >> >         up->ier |=3D UART_IER_MSI;
> > >> >         serial_out(up, UART_IER, up->ier);
> > >> > -       pm_runtime_put(up->dev);
> > >> > +       pm_runtime_mark_last_busy(up->dev);
> > >> > +       pm_runtime_put_autosuspend(up->dev);
> > >> >  }
> > >> >
> > >> Can you please expand the change-log a bit ?
> > >> Didn't follow the time re-init part completely.
> > >
> > > It's really just a micro-optimization. The thing is:
> > >
> > > if I call pm_runtime_put(), I will not reinitialize the pm timer to
> > > whatever timeout value I used. This means that pm_runtime_put() could
> > > actually execute right away (if timer was about to expire when I call=
ed
> > > pm_runtime_put()). While this wouldn't cause any issues, it's better =
to
> > > reinitialize the timer and make sure if there's another
> > > read/write/set_termios/whatever coming right after this, UART is still
> > > powered up.
> > >
> > > I mean, it's really just trying to avoid context save & restore when
> > > UART is still under heavy usage.
> > >
> > > Does it make sense ?
> >=20
> > It does. Would be good to add the above description in the change-log.
> > Thanks for clarification.
>=20
> will do, cheers

I have updated my branch like below. Will wait for any other comments
before sending another version.

commit 8ff7ab777d2bf8619328ddd43ddf2f8660dd011f
Author: Felipe Balbi <balbi@ti.com>
Date:   Tue Aug 21 11:45:47 2012 +0300

    serial: omap: stick to put_autosuspend
   =20
    Everytime we're done using our TTY, we want
    the pm timer to be reinitilized. By sticking
    to pm_runtime_pm_autosuspend() we make sure
    that this will always be the case.
   =20
    The idea behind this patch is to make sure we
    will always reinitialize the pm timer so that
    we don't fall into a situation where pm_runtime_put()
    expires right away (if timer was already about to
    expire when we made the call to pm_runtime_put()).
   =20
    While suspending right away wouldn't cause any
    issues, reinitializing the pm timer can help us
    avoiding unnecessary context save & restore
    operations (which are somewhat expensive) if there's
    another read/write/set_termios request coming right
    after. IOW, we are trying to make sure UART is still
    powered up while it's still under heavy usage.
   =20
    Acked-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
    Signed-off-by: Felipe Balbi <balbi@ti.com>

diff --git a/drivers/tty/serial/omap-serial.c b/drivers/tty/serial/omap-ser=
ial.c
index 6ea24c5..458d77c 100644
--- a/drivers/tty/serial/omap-serial.c
+++ b/drivers/tty/serial/omap-serial.c
@@ -164,7 +164,8 @@ static void serial_omap_enable_ms(struct uart_port *por=
t)
 	pm_runtime_get_sync(up->dev);
 	up->ier |=3D UART_IER_MSI;
 	serial_out(up, UART_IER, up->ier);
-	pm_runtime_put(up->dev);
+	pm_runtime_mark_last_busy(up->dev);
+	pm_runtime_put_autosuspend(up->dev);
 }
=20
 static void serial_omap_stop_tx(struct uart_port *port)
@@ -412,7 +413,8 @@ static unsigned int serial_omap_tx_empty(struct uart_po=
rt *port)
 	spin_lock_irqsave(&up->port.lock, flags);
 	ret =3D serial_in(up, UART_LSR) & UART_LSR_TEMT ? TIOCSER_TEMT : 0;
 	spin_unlock_irqrestore(&up->port.lock, flags);
-	pm_runtime_put(up->dev);
+	pm_runtime_mark_last_busy(up->dev);
+	pm_runtime_put_autosuspend(up->dev);
 	return ret;
 }
=20
@@ -424,7 +426,8 @@ static unsigned int serial_omap_get_mctrl(struct uart_p=
ort *port)
=20
 	pm_runtime_get_sync(up->dev);
 	status =3D check_modem_status(up);
-	pm_runtime_put(up->dev);
+	pm_runtime_mark_last_busy(up->dev);
+	pm_runtime_put_autosuspend(up->dev);
=20
 	dev_dbg(up->port.dev, "serial_omap_get_mctrl+%d\n", up->port.line);
=20
@@ -460,7 +463,8 @@ static void serial_omap_set_mctrl(struct uart_port *por=
t, unsigned int mctrl)
 	up->mcr =3D serial_in(up, UART_MCR);
 	up->mcr |=3D mcr;
 	serial_out(up, UART_MCR, up->mcr);
-	pm_runtime_put(up->dev);
+	pm_runtime_mark_last_busy(up->dev);
+	pm_runtime_put_autosuspend(up->dev);
 }
=20
 static void serial_omap_break_ctl(struct uart_port *port, int break_state)
@@ -477,7 +481,8 @@ static void serial_omap_break_ctl(struct uart_port *por=
t, int break_state)
 		up->lcr &=3D ~UART_LCR_SBC;
 	serial_out(up, UART_LCR, up->lcr);
 	spin_unlock_irqrestore(&up->port.lock, flags);
-	pm_runtime_put(up->dev);
+	pm_runtime_mark_last_busy(up->dev);
+	pm_runtime_put_autosuspend(up->dev);
 }
=20
 static int serial_omap_startup(struct uart_port *port)
@@ -575,7 +580,8 @@ static void serial_omap_shutdown(struct uart_port *port)
 	if (serial_in(up, UART_LSR) & UART_LSR_DR)
 		(void) serial_in(up, UART_RX);
=20
-	pm_runtime_put(up->dev);
+	pm_runtime_mark_last_busy(up->dev);
+	pm_runtime_put_autosuspend(up->dev);
 	free_irq(up->port.irq, up);
 }
=20
@@ -846,7 +852,8 @@ serial_omap_set_termios(struct uart_port *port, struct =
ktermios *termios,
 	serial_omap_configure_xonxoff(up, termios);
=20
 	spin_unlock_irqrestore(&up->port.lock, flags);
-	pm_runtime_put(up->dev);
+	pm_runtime_mark_last_busy(up->dev);
+	pm_runtime_put_autosuspend(up->dev);
 	dev_dbg(up->port.dev, "serial_omap_set_termios+%d\n", up->port.line);
 }
=20
@@ -877,7 +884,8 @@ serial_omap_pm(struct uart_port *port, unsigned int sta=
te,
 			pm_runtime_allow(up->dev);
 	}
=20
-	pm_runtime_put(up->dev);
+	pm_runtime_mark_last_busy(up->dev);
+	pm_runtime_put_autosuspend(up->dev);
 }
=20
 static void serial_omap_release_port(struct uart_port *port)
@@ -959,7 +967,8 @@ static void serial_omap_poll_put_char(struct uart_port =
*port, unsigned char ch)
 	pm_runtime_get_sync(up->dev);
 	wait_for_xmitr(up);
 	serial_out(up, UART_TX, ch);
-	pm_runtime_put(up->dev);
+	pm_runtime_mark_last_busy(up->dev);
+	pm_runtime_put_autosuspend(up->dev);
 }
=20
 static int serial_omap_poll_get_char(struct uart_port *port)
@@ -973,7 +982,8 @@ static int serial_omap_poll_get_char(struct uart_port *=
port)
 		return NO_POLL_CHAR;
=20
 	status =3D serial_in(up, UART_RX);
-	pm_runtime_put(up->dev);
+	pm_runtime_mark_last_busy(up->dev);
+	pm_runtime_put_autosuspend(up->dev);
 	return status;
 }
=20
@@ -1305,7 +1315,8 @@ static int serial_omap_probe(struct platform_device *=
pdev)
 	if (ret !=3D 0)
 		goto err_add_port;
=20
-	pm_runtime_put(&pdev->dev);
+	pm_runtime_mark_last_busy(up->dev);
+	pm_runtime_put_autosuspend(up->dev);
 	platform_set_drvdata(pdev, up);
 	return 0;
=20

let me know if your Ack is still valid.

--=20
balbi

--Ix2jQZQ3wXOip0b1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQM2x+AAoJEIaOsuA1yqREdjkP/RHqFlOTq666WdiRRch1VjYq
7WXL3KnqkmYx2ex1er4gJWM7Gw9He901vyRbuvPeX/nhwGIi3m+GDvgejnQwKHIS
H4+uuRfzptjYDOTUZ4+nHkICDaWxadYEEChQ2Xd4EO9dcOu8uDUMizUIyo2l7WDh
QktPGmrrgu3o92sil6yfYEnDrxfo1Yo0ATHUG2e7YI0PN2h+k3t6+N+NWDESbJyA
Fv9nrtlI/LJmhMBnrXguK6rOmcap8phfzO3TawSc8Fpz3B/gq/LajOr2HHxeVuLg
nPHr9Sv4nHJ1vtHJzp3aak8yMfEOnG5L5o/PtQCoI9dGZa5tGVmhdEmK3pRxKbqz
4FfabYWXH+r1wKuSQIFHQkJGAmAxRdzRgTU3MOXmRaouVRj2cC8o597++j1nOFr/
ZKqd3p9/JUKaR7ngMfvlvtxvLlCj1AlZl97iSwbZm+muY5xwdsI65Oe5bdcaCeRN
SUxHJO5U+r6qeE3zBDlZv+N2fsaIa8lx14DzbN3t6tNGPheqABXnvqJag7ZD5rjl
+IQTDVLNUDWgUpQyZYcmQ2VzmLfdqEzLHoLt2NSWDLhgIy6Dl9tyer4bfFNNdnKx
cVd1Mi6xSAivnIZiFZuFbVMu9Ey1QcoLEpwHpY5zjwZ3XweysssFNIxEiMhkALSM
QlbVDv/+w6LUBQBQtz8+
=0AmS
-----END PGP SIGNATURE-----

--Ix2jQZQ3wXOip0b1--
