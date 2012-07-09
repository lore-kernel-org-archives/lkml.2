Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751937Ab2GIGDZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 02:03:25 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:41185 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751737Ab2GIGDI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 02:03:08 -0400
Date: Mon, 9 Jul 2012 16:02:48 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        <linux-arm-kernel@lists.infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Shawn Guo <shawn.guo@linaro.org>,
        =?UTF-8?B?IkJlbm/DrnQgVGjDqWJhdWRlYXUi?= 
	<benoit.thebaudeau@advansee.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Sascha Hauer <kernel@pengutronix.de>
Subject: linux-next: manual merge of the arm-soc tree with the gpio-lw tree
Message-Id: <20120709160248.c746b4286aa2558160f86571@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__9_Jul_2012_16_02_48_+1000_=cF3KxarBO531fmH"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__9_Jul_2012_16_02_48_+1000_=cF3KxarBO531fmH
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the arm-soc tree got a conflict in
drivers/gpio/gpio-mxc.c between commit fef2bca203e9 ("gpio/mxc: use the
edge_sel feature if available") from the gpio-lw tree and commit
1ab7ef158dfb ("gpio/mxc: move irq_domain_add_legacy call into gpio
driver") from the arm-soc tree.

I fixed it up (I think - see below) and can carry the fix as necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/gpio/gpio-mxc.c
index f45bb54,e5db670..0000000
--- a/drivers/gpio/gpio-mxc.c
+++ b/drivers/gpio/gpio-mxc.c
@@@ -184,19 -160,15 +184,19 @@@ static int gpio_set_irq_type(struct irq
  		edge =3D GPIO_INT_FALL_EDGE;
  		break;
  	case IRQ_TYPE_EDGE_BOTH:
 -		val =3D gpio_get_value(gpio);
 -		if (val) {
 -			edge =3D GPIO_INT_LOW_LEV;
 -			pr_debug("mxc: set GPIO %d to low trigger\n", gpio);
 +		if (GPIO_EDGE_SEL >=3D 0) {
 +			edge =3D GPIO_INT_BOTH_EDGES;
  		} else {
 -			edge =3D GPIO_INT_HIGH_LEV;
 -			pr_debug("mxc: set GPIO %d to high trigger\n", gpio);
 +			val =3D gpio_get_value(gpio);
 +			if (val) {
 +				edge =3D GPIO_INT_LOW_LEV;
 +				pr_debug("mxc: set GPIO %d to low trigger\n", gpio);
 +			} else {
 +				edge =3D GPIO_INT_HIGH_LEV;
 +				pr_debug("mxc: set GPIO %d to high trigger\n", gpio);
 +			}
- 			port->both_edges |=3D 1 << (gpio & 31);
++			port->both_edges |=3D 1 << gpio_idx;
  		}
 -		port->both_edges |=3D 1 << gpio_idx;
  		break;
  	case IRQ_TYPE_LEVEL_LOW:
  		edge =3D GPIO_INT_LOW_LEV;
@@@ -208,24 -180,11 +208,24 @@@
  		return -EINVAL;
  	}
 =20
 -	reg +=3D GPIO_ICR1 + ((gpio_idx & 0x10) >> 2); /* ICR1 or ICR2 */
 -	bit =3D gpio_idx & 0xf;
 -	val =3D readl(reg) & ~(0x3 << (bit << 1));
 -	writel(val | (edge << (bit << 1)), reg);
 +	if (GPIO_EDGE_SEL >=3D 0) {
 +		val =3D readl(port->base + GPIO_EDGE_SEL);
 +		if (edge =3D=3D GPIO_INT_BOTH_EDGES)
- 			writel(val | (1 << (gpio & 0x1f)),
++			writel(val | (1 << gpio_idx),
 +				port->base + GPIO_EDGE_SEL);
 +		else
- 			writel(val & ~(1 << (gpio & 0x1f)),
++			writel(val & ~(1 << gpio_idx),
 +				port->base + GPIO_EDGE_SEL);
 +	}
 +
 +	if (edge !=3D GPIO_INT_BOTH_EDGES) {
- 		reg +=3D GPIO_ICR1 + ((gpio & 0x10) >> 2); /* lower or upper register */
- 		bit =3D gpio & 0xf;
++		reg +=3D GPIO_ICR1 + ((gpio_idx & 0x10) >> 2); /* ICR1 or ICR2 */
++		bit =3D gpio_idx & 0xf;
 +		val =3D readl(reg) & ~(0x3 << (bit << 1));
 +		writel(val | (edge << (bit << 1)), reg);
 +	}
 +
- 	writel(1 << (gpio & 0x1f), port->base + GPIO_ISR);
+ 	writel(1 << gpio_idx, port->base + GPIO_ISR);
 =20
  	return 0;
  }

--Signature=_Mon__9_Jul_2012_16_02_48_+1000_=cF3KxarBO531fmH
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJP+nQIAAoJEECxmPOUX5FETa4P/As2MbQOqRDrNtn3N3W0kKxZ
Z8uNhxWU7acrMH8DVal5ycpjEqQHahUDm6Co1j6WdbsnbfUY3ofDnaew7WMPugZB
xsleT+mveE1togexsdhKKNihFdguhdjivTpSlmXVJnMDjtzPeIeiimKHa5iEvU3Z
2D9pJ9JhPcEa0AHQhGtm5T584P1RGzwJCx1jpWj6qfOWjOsOXKBGhuFMPR/KRzqL
yZaz0KSxVXymroeC8Czo3e8kHr0VdSovO2mG8g6kYy/CZAGOijSncVPmatz1Pnn5
Yh0gmoFhbdUkT8JgnpFFnFqUf5J12jHrkZK0Vbf9bjYCeEedTXlLcAYckraFO3dH
c9UYkTkUC/j7gaUtpQ7mh4SGYeC7TWEajNQRwZBj/s+7OzFvJuqSZEG+H8vSE3/G
NIZYoUyTk87/PXqOc5oW3RMlLxPBwffZLoro9zb/cLWZ9o96DTFL5J9nxFl2ho7c
dtjvixKJiujVF0MHN2Kv+oEuRZE1oTxO0p5wV1aK4tJftdKe8+FOBwz0602YcvmR
mePbIxKuWmMv/6FatYWxEqgcaheZy1yI6XVJbWQmFdf77Y3nXNagPfVgkKT7agLO
LF6jj+0bMi34lA0vJ6Ee5Gtk/m7nkDjdrKMnyNcPYzII4DSRhEWzTmxgaTEaQ7k2
F6gahvrxUHscAM7oCsH4
=zEoi
-----END PGP SIGNATURE-----

--Signature=_Mon__9_Jul_2012_16_02_48_+1000_=cF3KxarBO531fmH--
