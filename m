Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755894Ab2K2Dkw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 22:40:52 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:38132 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755493Ab2K2Dkv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 22:40:51 -0500
Date: Thu, 29 Nov 2012 14:40:42 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bill Pemberton <wfp5p@virginia.edu>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Vinod Koul <vinod.koul@intel.com>
Subject: linux-next: manual merge of the driver-core tree with the slave-dma
 tree
Message-Id: <20121129144042.add4ee11c35fa8d5f5876282@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__29_Nov_2012_14_40_42_+1100_CWuimHv0eOj9=B4_"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__29_Nov_2012_14_40_42_+1100_CWuimHv0eOj9=B4_
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

Today's linux-next merge of the driver-core tree got a conflict in
drivers/dma/dw_dmac.c between commit c4cabfced23f ("dmaengine: dw_dmac:
Enhance device tree support") from the slave-dma tree and commit
463a1f8b3cee ("dma: remove use of __devinit") from the driver-core tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/dma/dw_dmac.c
index 2c8096d,8f0b111..0000000
--- a/drivers/dma/dw_dmac.c
+++ b/drivers/dma/dw_dmac.c
@@@ -1500,92 -1462,7 +1500,92 @@@ static void dw_dma_off(struct dw_dma *d
  		dw->chan[i].initialized =3D false;
  }
 =20
 +#ifdef CONFIG_OF
 +static struct dw_dma_platform_data *
 +__devinit dw_dma_parse_dt(struct platform_device *pdev)
 +{
 +	struct device_node *sn, *cn, *np =3D pdev->dev.of_node;
 +	struct dw_dma_platform_data *pdata;
 +	struct dw_dma_slave *sd;
 +	u32 tmp, arr[4];
 +
 +	if (!np) {
 +		dev_err(&pdev->dev, "Missing DT data\n");
 +		return NULL;
 +	}
 +
 +	pdata =3D devm_kzalloc(&pdev->dev, sizeof(*pdata), GFP_KERNEL);
 +	if (!pdata)
 +		return NULL;
 +
 +	if (of_property_read_u32(np, "nr_channels", &pdata->nr_channels))
 +		return NULL;
 +
 +	if (of_property_read_bool(np, "is_private"))
 +		pdata->is_private =3D true;
 +
 +	if (!of_property_read_u32(np, "chan_allocation_order", &tmp))
 +		pdata->chan_allocation_order =3D (unsigned char)tmp;
 +
 +	if (!of_property_read_u32(np, "chan_priority", &tmp))
 +		pdata->chan_priority =3D tmp;
 +
 +	if (!of_property_read_u32(np, "block_size", &tmp))
 +		pdata->block_size =3D tmp;
 +
 +	if (!of_property_read_u32(np, "nr_masters", &tmp)) {
 +		if (tmp > 4)
 +			return NULL;
 +
 +		pdata->nr_masters =3D tmp;
 +	}
 +
 +	if (!of_property_read_u32_array(np, "data_width", arr,
 +				pdata->nr_masters))
 +		for (tmp =3D 0; tmp < pdata->nr_masters; tmp++)
 +			pdata->data_width[tmp] =3D arr[tmp];
 +
 +	/* parse slave data */
 +	sn =3D of_find_node_by_name(np, "slave_info");
 +	if (!sn)
 +		return pdata;
 +
 +	/* calculate number of slaves */
 +	tmp =3D of_get_child_count(sn);
 +	if (!tmp)
 +		return NULL;
 +
 +	sd =3D devm_kzalloc(&pdev->dev, sizeof(*sd) * tmp, GFP_KERNEL);
 +	if (!sd)
 +		return NULL;
 +
 +	pdata->sd =3D sd;
 +	pdata->sd_count =3D tmp;
 +
 +	for_each_child_of_node(sn, cn) {
 +		sd->dma_dev =3D &pdev->dev;
 +		of_property_read_string(cn, "bus_id", &sd->bus_id);
 +		of_property_read_u32(cn, "cfg_hi", &sd->cfg_hi);
 +		of_property_read_u32(cn, "cfg_lo", &sd->cfg_lo);
 +		if (!of_property_read_u32(cn, "src_master", &tmp))
 +			sd->src_master =3D tmp;
 +
 +		if (!of_property_read_u32(cn, "dst_master", &tmp))
 +			sd->dst_master =3D tmp;
 +		sd++;
 +	}
 +
 +	return pdata;
 +}
 +#else
 +static inline struct dw_dma_platform_data *
 +dw_dma_parse_dt(struct platform_device *pdev)
 +{
 +	return NULL;
 +}
 +#endif
 +
- static int __devinit dw_probe(struct platform_device *pdev)
+ static int dw_probe(struct platform_device *pdev)
  {
  	struct dw_dma_platform_data *pdata;
  	struct resource		*io;

--Signature=_Thu__29_Nov_2012_14_40_42_+1100_CWuimHv0eOj9=B4_
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQttk6AAoJEECxmPOUX5FEHw8P/1Nx7z6wQel3D+CHMcTHMoxE
spaO1eEdybG30chDKTDlTjNKyh1gTI2ixZwF7vOH0mJxnn9jkDqq6r4jUlakiFIO
HLsSrNWaiXZquQljkjwqbbm3zXSh4wN460OtfgkpwQJ1mnyb4NyIt2Num15ee39S
MmwlOJFjpdEmo3o1Vgob7gKAl/2tHnl1iSW8NomDugBZo47y3dIxR9bqTN/s8Nlq
+yZPjsdslgIsKNcFOS7N5/oDX9O1/GMBFWJ7M40nvsmTkwY3SEpH7F9Ihh/G8+ix
pUcml2d1dRu8FNO1kaDSgGAARTIWVyMKuRcvl9pITrqh1PaQN2Nb/DL0A8Q3brj7
OMO2OsZjhupmv6judKVmJDp5qN/OMiHUt5uNHUX/ce2C5THhJwp1OoLHEmlv0kRs
eV1518IDnF91LMVXHM8JWv6iahcKy5c/QJqp7oTIx9TA+5M5YYdWWj0oYyHKIxeO
Qi/vJPXxiVk6uE82Ek+8qBMlnGK4oSC0M+60nUxkRErJakcsJN/XLhwO2Wt+P5Od
6IV4WMO7z6hlo9aG+ELqzpiNqzpSes5ByJuT31zyovb+9gP5hhe88FAYG1bLfL6o
tIqQ9zE+qlBP41S33LpPxjPgOTDufUCWytGK/uq78PeS/jazmy2yBUK8k22YA6PK
dU2i1yJF4jNG/qdanCAf
=O3kl
-----END PGP SIGNATURE-----

--Signature=_Thu__29_Nov_2012_14_40_42_+1100_CWuimHv0eOj9=B4_--
