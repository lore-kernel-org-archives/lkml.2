Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755984Ab2F2BdY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 21:33:24 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:34786 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754465Ab2F2BdW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 21:33:22 -0400
Date: Fri, 29 Jun 2012 11:33:10 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg Ungerer <gerg@snapgear.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Steven King <sfking@fdwdc.com>
Subject: linux-next: manual merge of the m68knommu tree with Linus' tree
Message-Id: <20120629113310.e578f61aa71e9350a3596833@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__29_Jun_2012_11_33_10_+1000_3MPnUikOMb5.3s/R"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__29_Jun_2012_11_33_10_+1000_3MPnUikOMb5.3s/R
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

Today's linux-next merge of the m68knommu tree got a conflict in
arch/m68k/platform/coldfire/clk.c between commit 19a1d332cc8c
("m68knommu: define a local devm_clk_get() function") from Linus' tree
and commit a0412a2ddaa3 ("m68knommu: Add support for the Coldfire
m5441x") from the m68knommu tree.

I fixed it up (I think - see below) and can carry the fix as necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/m68k/platform/coldfire/clk.c
index 44da406,d96405c..0000000
--- a/arch/m68k/platform/coldfire/clk.c
+++ b/arch/m68k/platform/coldfire/clk.c
@@@ -43,10 -49,102 +49,107 @@@ unsigned long clk_get_rate(struct clk *
  }
  EXPORT_SYMBOL(clk_get_rate);
 =20
 +struct clk *devm_clk_get(struct device *dev, const char *id)
 +{
 +	return NULL;
 +}
 +EXPORT_SYMBOL(devm_clk_get);
 +
+ #else
+ static DEFINE_SPINLOCK(clk_lock);
+=20
+ struct clk *clk_get(struct device *dev, const char *id)
+ {
+ 	const char *clk_name =3D dev ? dev_name(dev) : id ? id : NULL;
+ 	struct clk *clk;
+ 	unsigned i;
+=20
+ 	for (i =3D 0; (clk =3D mcf_clks[i]) !=3D NULL; ++i)
+ 		if (!strcmp(clk->name, clk_name))
+ 			return clk;
+ 	pr_warn("clk_get: didn't find clock %s\n", clk_name);
+ 	return ERR_PTR(-ENOENT);
+ }
+ EXPORT_SYMBOL(clk_get);
+=20
+ int clk_enable(struct clk *clk)
+ {
+ 	unsigned long flags;
+ 	spin_lock_irqsave(&clk_lock, flags);
+ 	if ((clk->enabled++ =3D=3D 0) && clk->clk_ops)
+ 		clk->clk_ops->enable(clk);
+ 	spin_unlock_irqrestore(&clk_lock, flags);
+=20
+ 	return 0;
+ }
+ EXPORT_SYMBOL(clk_enable);
+=20
+ void clk_disable(struct clk *clk)
+ {
+ 	unsigned long flags;
+ 	spin_lock_irqsave(&clk_lock, flags);
+ 	if ((--clk->enabled =3D=3D 0) && clk->clk_ops)
+ 		clk->clk_ops->disable(clk);
+ 	spin_unlock_irqrestore(&clk_lock, flags);
+ }
+ EXPORT_SYMBOL(clk_disable);
+=20
+ void clk_put(struct clk *clk)
+ {
+ 	if (clk->enabled !=3D 0)
+ 		pr_warn("clk_put %s still enabled\n", clk->name);
+ }
+ EXPORT_SYMBOL(clk_put);
+=20
+ unsigned long clk_get_rate(struct clk *clk)
+ {
+ 	return clk->rate;
+ }
+ EXPORT_SYMBOL(clk_get_rate);
+=20
 -
  /************************************************************************=
***/
+=20
+ void __clk_init_enabled(struct clk *clk)
+ {
+ 	clk->enabled =3D 1;
+ 	clk->clk_ops->enable(clk);
+ }
+=20
+ void __clk_init_disabled(struct clk *clk)
+ {
+ 	clk->enabled =3D 0;
+ 	clk->clk_ops->disable(clk);
+ }
+=20
+ static void __clk_enable0(struct clk *clk)
+ {
+ 	__raw_writeb(clk->slot, MCFPM_PPMCR0);
+ }
+=20
+ static void __clk_disable0(struct clk *clk)
+ {
+ 	__raw_writeb(clk->slot, MCFPM_PPMSR0);
+ }
+=20
+ struct clk_ops clk_ops0 =3D {
+ 	.enable		=3D __clk_enable0,
+ 	.disable	=3D __clk_disable0,
+ };
+=20
+ #ifdef MCFPM_PPMCR1
+ static void __clk_enable1(struct clk *clk)
+ {
+ 	__raw_writeb(clk->slot, MCFPM_PPMCR1);
+ }
+=20
+ static void __clk_disable1(struct clk *clk)
+ {
+ 	__raw_writeb(clk->slot, MCFPM_PPMSR1);
+ }
+=20
+ struct clk_ops clk_ops1 =3D {
+ 	.enable		=3D __clk_enable1,
+ 	.disable	=3D __clk_disable1,
+ };
+ #endif /* MCFPM_PPMCR1 */
+ #endif /* MCFPM_PPMCR0 */

--Signature=_Fri__29_Jun_2012_11_33_10_+1000_3MPnUikOMb5.3s/R
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJP7QXWAAoJEECxmPOUX5FE4JkP+gMk24MGNfr3QI6VPYDg2t+r
fmA0y2WkyZfUpGqBWYK6TVBMohqYzNmacXYtI6nP/2XUiSkTwbqPGpFdZp+bgv1h
KeOYCuNaQbXqjHU/FfrrBRuRiQ0dLLBMRFY29tZ+NdW69B3ykyDoUZMYjDxY3I7i
uN+C5kbhiAZBY5i22XiZfCZ/0rKEgmgf4RR0I0Nn2OS5xW15e1PXgNPtlXlEkncD
Imm4fDq3UR5Ucs566PtTVwnUMWcObUZ/80qVcgpeIBo3qnbic7r1NAfTCfEK5r+F
8u6oJRRuO6P3ynZxFBZ9bTsXs8dye2sMTrQzR/AqQyfNQcLVqvDs1m1gbYj1FuKa
TzkIh75FeKV6poUKnZD7K1mMK919NxR/5FK2nulpthsd68LYEH5PK6zOp0YRWDfQ
bBIwNpm/AwLlsShxDLGwJQPPKNxzDh/bajfiNsmrBBK5bckMSm7pBvPmavKyrcZk
tXIrnBgbjvLndQPzczQuGTrPlka0VEsInM7jbiE+kQAzBsxhNE87aKu4F9xHs/HT
EMMul92vdnonSS/RL0qhZtXdBxlAjUvrwWteGdSGjTRRtxsTreQzv4h0t1E4thXw
Y+epQW2OXKafB3CYux2nWTSmhifCZ1jgVOOoznxpCEFyHOlGPgxfm7nn60pFAIU+
ppXd/slnWsINfCiOx61g
=9ZN/
-----END PGP SIGNATURE-----

--Signature=_Fri__29_Jun_2012_11_33_10_+1000_3MPnUikOMb5.3s/R--
