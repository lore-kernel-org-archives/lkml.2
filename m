Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761215Ab2EQHSW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 03:18:22 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:52069 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761171Ab2EQHSU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 03:18:20 -0400
Date: Thu, 17 May 2012 17:18:10 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>, Olof Johansson <olof@lixom.net>,
        Arnd Bergmann <arnd@arndb.de>, <linux-arm-kernel@lists.infradead.org>,
        Viresh Kumar <viresh.kumar@st.com>
Subject: linux-next: manual merge of the akpm tree with the arm-soc tree
Message-Id: <20120517171810.64d248977f410292c18086cd@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta7 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__17_May_2012_17_18_10_+1000_XO26TdLPITRQ2MIB"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__17_May_2012_17_18_10_+1000_XO26TdLPITRQ2MIB
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

Today's linux-next merge of the akpm tree got a conflict in
drivers/ata/sata_mv.c between commit eee989902aab ("ARM: Orion: SATA: Add
per channel clk/clkdev support") from the arm-soc tree and commit
"ata/sata_mv: remove conditional compilation of clk code" from the akpm
tree.

I fixed it up (see below) and can carry the fix as necessary.

[I used the arm-soc version with all the conditionals on CONFIG_HAVE_CLK
removed.]

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/ata/sata_mv.c
index 24712ad,37503b8..0000000
--- a/drivers/ata/sata_mv.c
+++ b/drivers/ata/sata_mv.c
@@@ -551,10 -551,7 +551,8 @@@ struct mv_host_priv=20
  	u32			irq_mask_offset;
  	u32			unmask_all_irqs;
 =20
- #if defined(CONFIG_HAVE_CLK)
  	struct clk		*clk;
 +	struct clk              **port_clks;
- #endif
  	/*
  	 * These consistent DMA memory pools give us guaranteed
  	 * alignment for hardware-accessed data structures,
@@@ -4028,9 -4025,6 +4026,7 @@@ static int mv_platform_probe(struct pla
  	struct resource *res;
  	int n_ports =3D 0;
  	int rc;
- #if defined(CONFIG_HAVE_CLK)
 +	int port;
- #endif
 =20
  	ata_print_version_once(&pdev->dev, DRV_VERSION);
 =20
@@@ -4058,13 -4052,6 +4054,11 @@@
 =20
  	if (!host || !hpriv)
  		return -ENOMEM;
- #if defined(CONFIG_HAVE_CLK)
 +	hpriv->port_clks =3D devm_kzalloc(&pdev->dev,
 +					sizeof(struct clk *) * n_ports,
 +					GFP_KERNEL);
 +	if (!hpriv->port_clks)
 +		return -ENOMEM;
- #endif
  	host->private_data =3D hpriv;
  	hpriv->n_ports =3D n_ports;
  	hpriv->board_idx =3D chip_soc;
@@@ -4074,21 -4061,11 +4068,19 @@@
  				   resource_size(res));
  	hpriv->base -=3D SATAHC0_REG_BASE;
 =20
- #if defined(CONFIG_HAVE_CLK)
  	hpriv->clk =3D clk_get(&pdev->dev, NULL);
  	if (IS_ERR(hpriv->clk))
 -		dev_notice(&pdev->dev, "cannot get clkdev\n");
 +		dev_notice(&pdev->dev, "cannot get optional clkdev\n");
  	else
 -		clk_enable(hpriv->clk);
 +		clk_prepare_enable(hpriv->clk);
 +
 +	for (port =3D 0; port < n_ports; port++) {
 +		char port_number[16];
 +		sprintf(port_number, "%d", port);
 +		hpriv->port_clks[port] =3D clk_get(&pdev->dev, port_number);
 +		if (!IS_ERR(hpriv->port_clks[port]))
 +			clk_prepare_enable(hpriv->port_clks[port]);
 +	}
- #endif
 =20
  	/*
  	 * (Re-)program MBUS remapping windows if we are asked to.
@@@ -4115,18 -4092,10 +4107,16 @@@
  		return 0;
 =20
  err:
- #if defined(CONFIG_HAVE_CLK)
  	if (!IS_ERR(hpriv->clk)) {
 -		clk_disable(hpriv->clk);
 +		clk_disable_unprepare(hpriv->clk);
  		clk_put(hpriv->clk);
  	}
 +	for (port =3D 0; port < n_ports; port++) {
 +		if (!IS_ERR(hpriv->port_clks[port])) {
 +			clk_disable_unprepare(hpriv->port_clks[port]);
 +			clk_put(hpriv->port_clks[port]);
 +		}
 +	}
- #endif
 =20
  	return rc;
  }
@@@ -4142,24 -4111,13 +4132,20 @@@
  static int __devexit mv_platform_remove(struct platform_device *pdev)
  {
  	struct ata_host *host =3D platform_get_drvdata(pdev);
- #if defined(CONFIG_HAVE_CLK)
  	struct mv_host_priv *hpriv =3D host->private_data;
 +	int port;
- #endif
  	ata_host_detach(host);
 =20
- #if defined(CONFIG_HAVE_CLK)
  	if (!IS_ERR(hpriv->clk)) {
 -		clk_disable(hpriv->clk);
 +		clk_disable_unprepare(hpriv->clk);
  		clk_put(hpriv->clk);
  	}
 +	for (port =3D 0; port < host->n_ports; port++) {
 +		if (!IS_ERR(hpriv->port_clks[port])) {
 +			clk_disable_unprepare(hpriv->port_clks[port]);
 +			clk_put(hpriv->port_clks[port]);
 +		}
 +	}
- #endif
  	return 0;
  }
 =20

--Signature=_Thu__17_May_2012_17_18_10_+1000_XO26TdLPITRQ2MIB
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPtKYyAAoJEECxmPOUX5FES3IP/RbTkMl+/aBmq340NXVwnBVY
K9bwX9axjkRKVNFmFeKylvNeB/rEdzGIAO/zYZLpr22xBruu6Qr2L6jCKfiQw3xy
ykYSpWKs+Q960rVun55VSYZAH+sfdIzGAMYXBUSBSusHllC1mZ/114UAcmBlFuZR
9/7PiuJ7lYEX0RwXafUnEZwzm8l9sRkgDjWojm08lCEPBXvp34vrY611wu2QoLuA
MwmgTT/X1xHulue7dyU+mmgWS0M1PTZms3d5l8TqvX+h3Mgp5HfaHBEPxLBEjfdn
BXZWK08Oi+iOn50CU5AIkunkjJ7vEQXHFWDhgZlkkV7iX8vXnt2PUhv4CyPZON2Y
FjcTu0AUjcgMogzNCRC8mRxKMVigbTC9uFaX3hNI6mXJXiUWDFm874PkwLrFtLtG
zf1wHe40XWoiibAoOQ3okS4BntXxEQwOeilAusBtW3FTrAyaCzLWFI9fvi6wTC64
dgc8yfMukrbd2WLV9mJ/Shls9QN/q0n+F7/4CUXLbiCzASxQQQ0vuGQBwrJljPfl
29uUOJmQg0iK+uyVKqjzX6MxzTvxfLMMO61hl9g8qkcdd05pop9sVH4f3K+KvBPg
DXUBK94QpifktM/Q0dFUyW2mqfNGV4vLl1aw91onRtC1EWgfNp8eDVF6rA8flxd7
ivfA7OfRbZ4oBy90ShKE
=j58C
-----END PGP SIGNATURE-----

--Signature=_Thu__17_May_2012_17_18_10_+1000_XO26TdLPITRQ2MIB--
