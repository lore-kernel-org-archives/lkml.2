Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030866Ab2CVDEd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 23:04:33 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:40171 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758913Ab2CVDET (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 23:04:19 -0400
Date: Thu, 22 Mar 2012 14:04:10 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Artem Bityutskiy <dedekind1@gmail.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alexandre Bounine <alexandre.bounine@idt.com>,
        Vinod Koul <vinod.koul@intel.com>, Huang Shijie <b32955@freescale.com>
Subject: linux-next: manual merge of the l2-mtd tree with the slave-dma tree
Message-Id: <20120322140410.2f9af2f25906a3cdc9497d72@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta6 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__22_Mar_2012_14_04_10_+1100_8uGYuAeZUMil2qHI"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__22_Mar_2012_14_04_10_+1100_8uGYuAeZUMil2qHI
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Artem,

Today's linux-next merge of the l2-mtd tree got a conflict in
drivers/mtd/nand/gpmi-nand/gpmi-lib.c between commit 16052827d98f
("dmaengine/dma_slave: introduce inline wrappers") from the slave-dma
tree and commit c790d78c631f ("mxs-dma : rewrite the last parameter of
mxs_dma_prep_slave_sg()") from the l2-mtd tree.

I fixed it up (see below) and can carry the fix as necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/mtd/nand/gpmi-nand/gpmi-lib.c
index 590dd5c,c34dab1..0000000
--- a/drivers/mtd/nand/gpmi-nand/gpmi-lib.c
+++ b/drivers/mtd/nand/gpmi-nand/gpmi-lib.c
@@@ -848,7 -848,10 +848,9 @@@ int gpmi_send_command(struct gpmi_nand_
 =20
  	sg_init_one(sgl, this->cmd_buffer, this->command_length);
  	dma_map_sg(this->dev, sgl, 1, DMA_TO_DEVICE);
- 	desc =3D dmaengine_prep_slave_sg(channel, sgl, 1, DMA_MEM_TO_DEV, 1);
 -	desc =3D channel->device->device_prep_slave_sg(channel,
 -				sgl, 1, DMA_MEM_TO_DEV,
++	desc =3D dmaengine_prep_slave_sg(channel, sgl, 1, DMA_MEM_TO_DEV,
+ 				DMA_PREP_INTERRUPT | DMA_CTRL_ACK);
+=20
  	if (!desc) {
  		pr_err("step 2 error\n");
  		return -1;
@@@ -888,8 -892,9 +890,9 @@@ int gpmi_send_data(struct gpmi_nand_dat
 =20
  	/* [2] send DMA request */
  	prepare_data_dma(this, DMA_TO_DEVICE);
 -	desc =3D channel->device->device_prep_slave_sg(channel, &this->data_sgl,
 +	desc =3D dmaengine_prep_slave_sg(channel, &this->data_sgl,
- 						1, DMA_MEM_TO_DEV, 1);
+ 					1, DMA_MEM_TO_DEV,
+ 					DMA_PREP_INTERRUPT | DMA_CTRL_ACK);
  	if (!desc) {
  		pr_err("step 2 error\n");
  		return -1;
@@@ -924,8 -929,9 +927,9 @@@ int gpmi_read_data(struct gpmi_nand_dat
 =20
  	/* [2] : send DMA request */
  	prepare_data_dma(this, DMA_FROM_DEVICE);
 -	desc =3D channel->device->device_prep_slave_sg(channel, &this->data_sgl,
 +	desc =3D dmaengine_prep_slave_sg(channel, &this->data_sgl,
- 					1, DMA_DEV_TO_MEM, 1);
+ 					1, DMA_DEV_TO_MEM,
+ 					DMA_PREP_INTERRUPT | DMA_CTRL_ACK);
  	if (!desc) {
  		pr_err("step 2 error\n");
  		return -1;
@@@ -970,8 -976,10 +974,9 @@@ int gpmi_send_page(struct gpmi_nand_dat
  	pio[4] =3D payload;
  	pio[5] =3D auxiliary;
 =20
 -	desc =3D channel->device->device_prep_slave_sg(channel,
 -					(struct scatterlist *)pio,
 +	desc =3D dmaengine_prep_slave_sg(channel, (struct scatterlist *)pio,
- 					ARRAY_SIZE(pio), DMA_TRANS_NONE, 0);
+ 					ARRAY_SIZE(pio), DMA_TRANS_NONE,
+ 					DMA_CTRL_ACK);
  	if (!desc) {
  		pr_err("step 2 error\n");
  		return -1;
@@@ -1033,9 -1041,10 +1038,10 @@@ int gpmi_read_page(struct gpmi_nand_dat
  	pio[3] =3D geo->page_size;
  	pio[4] =3D payload;
  	pio[5] =3D auxiliary;
 -	desc =3D channel->device->device_prep_slave_sg(channel,
 +	desc =3D dmaengine_prep_slave_sg(channel,
  					(struct scatterlist *)pio,
- 					ARRAY_SIZE(pio), DMA_TRANS_NONE, 1);
+ 					ARRAY_SIZE(pio), DMA_TRANS_NONE,
+ 					DMA_PREP_INTERRUPT | DMA_CTRL_ACK);
  	if (!desc) {
  		pr_err("step 2 error\n");
  		return -1;
@@@ -1052,9 -1061,11 +1058,11 @@@
  		| BF_GPMI_CTRL0_ADDRESS(address)
  		| BF_GPMI_CTRL0_XFER_COUNT(geo->page_size);
  	pio[1] =3D 0;
+ 	pio[2] =3D 0; /* clear GPMI_HW_GPMI_ECCCTRL, disable the BCH. */
 -	desc =3D channel->device->device_prep_slave_sg(channel,
 +	desc =3D dmaengine_prep_slave_sg(channel,
- 				(struct scatterlist *)pio, 2,
- 				DMA_TRANS_NONE, 1);
+ 				(struct scatterlist *)pio, 3,
+ 				DMA_TRANS_NONE,
+ 				DMA_PREP_INTERRUPT | DMA_CTRL_ACK);
  	if (!desc) {
  		pr_err("step 3 error\n");
  		return -1;

--Signature=_Thu__22_Mar_2012_14_04_10_+1100_8uGYuAeZUMil2qHI
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPapaqAAoJEECxmPOUX5FEUbIP/1ZpRfu4Q4qVZwvb8MG4zgpH
CmBvokAJkzbemQI7NcXQ3dfgsXNWDet+8q8sgXn+aK2CYkFOc8+m8q09bNClOkD7
aD6/7tDh2YirZ6eGselZMFf9DV8oHg4CuytnBIqmlNZpAg6pynzJupZUgg8SCbQm
RvmbpdAHET2HKdLRaAHxgavOjCRLyTZbQRm6OxEUWwT5nUKgbvv329Os5pX8eNAd
ZWUKIkWc0KlMLaOXmx47EZES0ItW/gaCtNEAnMrDiASLEOeNoBxw0EbJ4+o8t4uE
wCq0qNFTT0eU8Mv5K9jJVySfW63qzzJHKQZ4oKRgj3x6xyB6qVrNKjlJrbcnSRJr
zW/3O6n0TYDIQEV4iLB1uERLJheDZXdVPnwfM0/SWrFKtpUt2TRZGujzefYMnMOh
sDElXds8+gmPn84OEX+OH2vlSinjzDMKO2M6wHIl92hHajmuWtmy4Uo7WLCHrh+s
ROopCtDU/1oEphrDYIQpOZowD7RvbJPso+66umbJA3kwBVjrY41bgFarel+Co8Kn
XJcWN/G0hcSYABpvIuCkzHYaA06oThwmokxZEeMccMsDDE7m158y5NpmfQ86OA6W
aaNEip/rwaVjPQuoz52UbrzaBaollklDLDaysnzAmFWAhHtV9Dbnfb2wsR1IOEXQ
d3Y/mK4oQw8+wNqfcoMo
=pUpG
-----END PGP SIGNATURE-----

--Signature=_Thu__22_Mar_2012_14_04_10_+1100_8uGYuAeZUMil2qHI--
