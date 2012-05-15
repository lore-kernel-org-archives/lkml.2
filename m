Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757532Ab2EOHwS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 03:52:18 -0400
Received: from mga01.intel.com ([192.55.52.88]:43618 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756851Ab2EOHwQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 03:52:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="asc'?scan'208";a="153063860"
Message-ID: <1337068543.2528.143.camel@sauron.fi.intel.com>
Subject: Re: [PATCH] MTD: LPC32xx SLC NAND driver
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Roland Stigge <stigge@antcom.de>, Bastian Hecht <hechtb@googlemail.com>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Huang Shijie <b32955@freescale.com>, Lei Wen <leiwen@marvell.com>
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        dwmw2@infradead.org, kevin.wells@nxp.com, srinivas.bakki@nxp.com,
        linux-arm-kernel@lists.infradead.org
Date: Tue, 15 May 2012 10:55:43 +0300
In-Reply-To: <1336829386-23301-1-git-send-email-stigge@antcom.de>
References: <1336829386-23301-1-git-send-email-stigge@antcom.de>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-BUTr4U2qvF8OaNVex7Q2"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-BUTr4U2qvF8OaNVex7Q2
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

I am CCing few other guys who take care of several drivers which use
similar way of busy-waiting - probably you could change it?

Bastian: drivers/mtd/nand/sh_flctl.c
Lars-Peter: drivers/mtd/nand/jz4740_nand.c
Huang: drivers/mtd/nand/gpmi-nand/gpmi-lib.c
Lei Wen: drivers/mtd/nand/pxa3xx_nand.c

On Sat, 2012-05-12 at 15:29 +0200, Roland Stigge wrote:
> +       /*
> +        * The DMA is finished, but the NAND controller may still have
> +        * buffered data. Wait until all the data is sent.
> +        */
> +       timeout =3D LPC32XX_DMA_SIMPLE_TIMEOUT;
> +       while ((readl(SLC_STAT(host->io_base)) & SLCSTAT_DMA_FIFO)
> +              && (timeout > 0))
> +               timeout--;
> +       if (!timeout) {
> +               dev_err(mtd->dev.parent, "FIFO held data too long\n");
> +               status =3D -EIO;
> +       }=20

I know the MTD tree is full of this, but this is bad, I think. The
timeout should be time-backed, not CPU-cycles-backed.

I do not know the best way to do this, hopefully someone in the arm list
could suggest, but the following pattern is at least better:


/* Chip reaction time timeout in milliseconds */
#define LPC32XX_DMA_TIMEOUT 100

timeout =3D loops_per_jiffy * msecs_to_jiffies(LPC32XX_DMA_TIMEOUT);

while ((readl(...)) && timeout-- > 0)
	cpu_relax();

if (!timeout)
	error;


So basically I turned your hard-coded iterations count into a time-based
timeout. I also used cpu_relax() which is commonly used in tight-loops
like this. Here is a piece of documentation about cpu_relax():

"
The right way to perform a busy wait is:

    while (my_variable !=3D what_i_want)
        cpu_relax();

The cpu_relax() call can lower CPU power consumption or yield to a
hyperthreaded twin processor; it also happens to serve as a compiler
barrier, so, once again, volatile is unnecessary.  Of course, busy-
waiting is generally an anti-social act to begin with.
"

--=20
Best Regards,
Artem Bityutskiy

--=-BUTr4U2qvF8OaNVex7Q2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJPsgv/AAoJECmIfjd9wqK0kHMQAKVtllaa4HiixNCsPIC+QKdN
jrONKGOnOZSuXrAL4DStVWwbij4E2u7RvdoPI4egWXgfe4xhr8HN70PyYxDbTBr3
29qHm0f3GfBzfZH/VTsFkvih7webx3vVbFii26rbMiQn2AISvmBFduHA+krmECO3
iJ0O2QAGn7iP6STTcdMuFKff91efFiWWi4PXqLKISh6EpuVJmteHGbWr6JG99m3g
PzGDbovdQRibMaPJoruEcna6VI9hodMW3WEf02LCJFBVwZvU9UbG/A9j6sFVo4p6
5iQebBK7GTvF/66UHsjgoJRD2395Lt+Di6ukF+7tlVQREHIc1OR35JUy05D/SZyd
q26gxEHrVj7qH+dHArwtw3Zl3Ba+UJJpLG9QJTfZbp/FIuDxrotgb+4tQl7CsyLf
VD8FL6xCN1NPovTwotBULY+7EkarhqjQAjc4efS2pfHUf8SjasJjZWEaSvID7JOq
4yJXkMZ0E/le5/FrFpeBPfpiKKeD5nRJsY6BB8QsNhHMiaNTn8mSmSzIUvug9ScG
CCdz9lOM/9cvk83GE9M44koT5R0J1MaMrySe5JQ49ssRSVG1u2FnsEkt5Om2qV/V
sNcRj/M+5ZJyN11KBJPh8LdyEGcM+h2+gUl8+XuSq8s9d3fQgMKQZKebvUKnOQgM
m2gUm+QepsF1x1AtA1nE
=J9oH
-----END PGP SIGNATURE-----

--=-BUTr4U2qvF8OaNVex7Q2--

