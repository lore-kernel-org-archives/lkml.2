Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755933Ab2BBMEQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 07:04:16 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:39827 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755881Ab2BBMEN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 07:04:13 -0500
Message-ID: <1328184370.28171.175.camel@sauron.fi.intel.com>
Subject: Re: [PATCH] mtd: atmel_nand: fix access to 16 bit NAND devices
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Nicolas Ferre <nicolas.ferre@atmel.com>,
        "Voss, Nikolaus" <N.Voss@weinmann.de>,
        Eric =?ISO-8859-1?Q?B=E9nard?= <eric@eukrea.com>
Cc: "'linux-mtd@lists.infradead.org'" <linux-mtd@lists.infradead.org>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>
Date: Thu, 02 Feb 2012 14:06:10 +0200
In-Reply-To: <4F265B7E.6060806@atmel.com>
References: <201201251217.q0PCHmRe027024@gatekeeper.vosshq.de>
	 <1327670996.26648.43.camel@sauron.fi.intel.com>
	 <EF2E73589CA71846A15D0B2CDF79505D08AD3E5453@wm021.weinmann.com>
	 <4F265B7E.6060806@atmel.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-54rCppJjPQZJ5ATAKunb"
X-Mailer: Evolution 3.2.3 (3.2.3-1.fc16) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-54rCppJjPQZJ5ATAKunb
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2012-01-30 at 09:57 +0100, Nicolas Ferre wrote:
> Artem, do you want me to prepare a patch for reverting initial commit or
> you just need my "Acked-by" (feel free to add though)?

OK, thanks, just pushed this patch to l2-mtd.git and add Cc to -stable,
please, validate.

I'll ask David to merge it to 3.3, but no guarantees - you should ping
him directly if you want this to happen.

URL: http://git.infradead.org/users/dedekind/l2-mtd.git/commit/21c7726c9862=
8016c868d803a2a8e6f2d5702519

From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Date: Thu, 2 Feb 2012 13:54:25 +0200
Subject: [PATCH] Revert "mtd: atmel_nand: optimize read/write buffer functi=
ons"

This reverts commit fb5427508abbd635e877fabdf55795488119c2d6.

The reason is that it breaks 16 bits NAND flash as it was reported by
Nikolaus Voss and confirmed by Eric B=C3=A9nard.

Nicolas Ferre <nicolas.ferre@atmel.com> alco confirmed:
"After double checking with designers, I must admit that I misunderstood
the way of optimizing accesses to SMC. 16 bit nand is not so common
those days..."

Reported-by: Nikolaus Voss <n.voss@weinmann.de>
Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Cc: stable@kernel.org [3.1+]
---
 drivers/mtd/nand/atmel_nand.c |   45 +++++++++++++++++++++++++++++++++++++=
---
 1 files changed, 41 insertions(+), 4 deletions(-)

diff --git a/drivers/mtd/nand/atmel_nand.c b/drivers/mtd/nand/atmel_nand.c
index 4dd056e..35b4fb5 100644
--- a/drivers/mtd/nand/atmel_nand.c
+++ b/drivers/mtd/nand/atmel_nand.c
@@ -161,6 +161,37 @@ static int atmel_nand_device_ready(struct mtd_info *mt=
d)
                 !!host->board->rdy_pin_active_low;
 }
=20
+/*
+ * Minimal-overhead PIO for data access.
+ */
+static void atmel_read_buf8(struct mtd_info *mtd, u8 *buf, int len)
+{
+	struct nand_chip	*nand_chip =3D mtd->priv;
+
+	__raw_readsb(nand_chip->IO_ADDR_R, buf, len);
+}
+
+static void atmel_read_buf16(struct mtd_info *mtd, u8 *buf, int len)
+{
+	struct nand_chip	*nand_chip =3D mtd->priv;
+
+	__raw_readsw(nand_chip->IO_ADDR_R, buf, len / 2);
+}
+
+static void atmel_write_buf8(struct mtd_info *mtd, const u8 *buf, int len)
+{
+	struct nand_chip	*nand_chip =3D mtd->priv;
+
+	__raw_writesb(nand_chip->IO_ADDR_W, buf, len);
+}
+
+static void atmel_write_buf16(struct mtd_info *mtd, const u8 *buf, int len=
)
+{
+	struct nand_chip	*nand_chip =3D mtd->priv;
+
+	__raw_writesw(nand_chip->IO_ADDR_W, buf, len / 2);
+}
+
 static void dma_complete_func(void *completion)
 {
 	complete(completion);
@@ -235,27 +266,33 @@ err_buf:
 static void atmel_read_buf(struct mtd_info *mtd, u8 *buf, int len)
 {
 	struct nand_chip *chip =3D mtd->priv;
+	struct atmel_nand_host *host =3D chip->priv;
=20
 	if (use_dma && len > mtd->oobsize)
 		/* only use DMA for bigger than oob size: better performances */
 		if (atmel_nand_dma_op(mtd, buf, len, 1) =3D=3D 0)
 			return;
=20
-	/* if no DMA operation possible, use PIO */
-	memcpy_fromio(buf, chip->IO_ADDR_R, len);
+	if (host->board->bus_width_16)
+		atmel_read_buf16(mtd, buf, len);
+	else
+		atmel_read_buf8(mtd, buf, len);
 }
=20
 static void atmel_write_buf(struct mtd_info *mtd, const u8 *buf, int len)
 {
 	struct nand_chip *chip =3D mtd->priv;
+	struct atmel_nand_host *host =3D chip->priv;
=20
 	if (use_dma && len > mtd->oobsize)
 		/* only use DMA for bigger than oob size: better performances */
 		if (atmel_nand_dma_op(mtd, (void *)buf, len, 0) =3D=3D 0)
 			return;
=20
-	/* if no DMA operation possible, use PIO */
-	memcpy_toio(chip->IO_ADDR_W, buf, len);
+	if (host->board->bus_width_16)
+		atmel_write_buf16(mtd, buf, len);
+	else
+		atmel_write_buf8(mtd, buf, len);
 }
=20
 /*
--=20
1.7.9

--=20
Best Regards,
Artem Bityutskiy

--=-54rCppJjPQZJ5ATAKunb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJPKnwyAAoJECmIfjd9wqK0l40QAI/DIulYlOSybLLC6ONO+c4d
3EBYSsWJKq3DjLPTuIT5ypSd9Q4V16T8wcXaM3dsq2weNG3dwI2z1K2OYunXNqGW
ieadHTix2yuDjYC1uSqWV9xqcOliWTjNwu08VI/nCIeQ+EPd1L92CYRFpGIMNg1v
1FzcxG/nbD5MlLxaLwsoBZPKv33EoJC6WTXxr38nB3EZSEeJVbgumaj+ihE6v+K/
nEl9sz0bLLCqGHWtNm0/HtFqHoUT6K9ZS/pCO+JJmEzMmYpJmaC2UmFpR4WGyI/g
hhyf3gJILDj1xQSxsHzB5sBB8sTsS0z4Y2N+NmPuptBrTnAiubCN3ubRfP1+0zLo
IFWG+IS0P6wfSva/8K/ERSgKPgBKssvzJoYKSfAF/tYvRh4jvFJ2DDNRI73tBjeE
cr/IJhWN+y54nbM7h/e+c3slh0sn+A69aIxgit4dJDWFa7G2QuDk6483EbFwjway
mU/EgFovAN8xlCi5I5DqexAMu9MMp9AAKachiB+9mhgBrFV3xfvsWUJTRHDqV0Gv
yfqkASnCW/sf9MlHKaTjmdv9ahHua2Q0dGes4xQR5W+rKFEoIcMbw2YLUJftj4FO
KT/qYQYJKOaK4yEnZLYHsB+/02ZqspXRFmwnBahtXLmUWwx09M2OovnLdWxPySFd
okIIPYHN1ujK1BkIO27X
=BmQv
-----END PGP SIGNATURE-----

--=-54rCppJjPQZJ5ATAKunb--

