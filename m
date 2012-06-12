Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751171Ab2FLEHW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 00:07:22 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:36801 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750861Ab2FLEHV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 00:07:21 -0400
Date: Tue, 12 Jun 2012 14:07:11 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Giuseppe CAVALLARO <peppe.cavallaro@st.com>,
        David Miller <davem@davemloft.net>, <netdev@vger.kernel.org>,
        Viresh Kumar <viresh.kumar@st.com>
Subject: linux-next: manual merge of the akpm tree with the net tree
Message-Id: <20120612140711.ef9b97ee55147328a784def7@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta7 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__12_Jun_2012_14_07_11_+1000_IVIL8vRsiTQ8xWCe"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__12_Jun_2012_14_07_11_+1000_IVIL8vRsiTQ8xWCe
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

Today's linux-next merge of the akpm tree got a conflict in
drivers/net/ethernet/stmicro/stmmac/stmmac.h between commit 33d5e332b9c5
("stmmac: fix driver built w/ w/o both pci and platf modules") from the
net tree and commit "net/stmmac: remove conditional compilation of clk
code" from the akpm tree.

Just context changes.  I fixed it up (see below) and can carry the fix as
necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/net/ethernet/stmicro/stmmac/stmmac.h
index 94b21b4,8e1a43b..0000000
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac.h
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac.h
@@@ -104,99 -103,3 +102,59 @@@ int stmmac_dvr_remove(struct net_devic
  struct stmmac_priv *stmmac_dvr_probe(struct device *device,
  				     struct plat_stmmacenet_data *plat_dat,
  				     void __iomem *addr);
 +
- #ifdef CONFIG_HAVE_CLK
- static inline int stmmac_clk_enable(struct stmmac_priv *priv)
- {
- 	if (!IS_ERR(priv->stmmac_clk))
- 		return clk_enable(priv->stmmac_clk);
-=20
- 	return 0;
- }
-=20
- static inline void stmmac_clk_disable(struct stmmac_priv *priv)
- {
- 	if (IS_ERR(priv->stmmac_clk))
- 		return;
-=20
- 	clk_disable(priv->stmmac_clk);
- }
- static inline int stmmac_clk_get(struct stmmac_priv *priv)
- {
- 	priv->stmmac_clk =3D clk_get(priv->device, NULL);
-=20
- 	if (IS_ERR(priv->stmmac_clk))
- 		return PTR_ERR(priv->stmmac_clk);
-=20
- 	return 0;
- }
- #else
- static inline int stmmac_clk_enable(struct stmmac_priv *priv)
- {
- 	return 0;
- }
- static inline void stmmac_clk_disable(struct stmmac_priv *priv)
- {
- }
- static inline int stmmac_clk_get(struct stmmac_priv *priv)
- {
- 	return 0;
- }
- #endif /* CONFIG_HAVE_CLK */
-=20
-=20
 +#ifdef CONFIG_STMMAC_PLATFORM
 +extern struct platform_driver stmmac_pltfr_driver;
 +static inline int stmmac_register_platform(void)
 +{
 +	int err;
 +
 +	err =3D platform_driver_register(&stmmac_pltfr_driver);
 +	if (err)
 +		pr_err("stmmac: failed to register the platform driver\n");
 +
 +	return err;
 +}
 +static inline void stmmac_unregister_platform(void)
 +{
 +	platform_driver_register(&stmmac_pltfr_driver);
 +}
 +#else
 +static inline int stmmac_register_platform(void)
 +{
 +	pr_debug("stmmac: do not register the platf driver\n");
 +
 +	return -EINVAL;
 +}
 +static inline void stmmac_unregister_platform(void)
 +{
 +}
 +#endif /* CONFIG_STMMAC_PLATFORM */
 +
 +#ifdef CONFIG_STMMAC_PCI
 +extern struct pci_driver stmmac_pci_driver;
 +static inline int stmmac_register_pci(void)
 +{
 +	int err;
 +
 +	err =3D pci_register_driver(&stmmac_pci_driver);
 +	if (err)
 +		pr_err("stmmac: failed to register the PCI driver\n");
 +
 +	return err;
 +}
 +static inline void stmmac_unregister_pci(void)
 +{
 +	pci_unregister_driver(&stmmac_pci_driver);
 +}
 +#else
 +static inline int stmmac_register_pci(void)
 +{
 +	pr_debug("stmmac: do not register the PCI driver\n");
 +
 +	return -EINVAL;
 +}
 +static inline void stmmac_unregister_pci(void)
 +{
 +}
 +#endif /* CONFIG_STMMAC_PCI */

--Signature=_Tue__12_Jun_2012_14_07_11_+1000_IVIL8vRsiTQ8xWCe
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJP1sBvAAoJEECxmPOUX5FE1skP/0P6fgcSbZnLtJDgUlrw+lUQ
sU2LAnXv1R4lWES8Pm6HshtGRFBIFWoBjbysM6/eGmg8Pcg5hBTDo0E99rMN579z
cEFomXpOjhkYyulGSVZxAX9MQFtNYWkySSo5pLNUtRS0e6MVi0n4Dx/U6iJvYd0D
FKP1QpagI2aixCMmx1GEovo6BE5nc9AbfK25gz/8pXjABl1qH2qB88FgVrbyzYf0
XmAUNUjSO/bgneg3LrNknmww/lJ+YFHRZx3RODiVtPTDuSCop7IdWFZYDRd9EPzu
6R6bDb/AvZEOg7TwNDAqXmjcv0PtDJBuquEBEgBpW4oHBP1pi+6IlKHpj+waZbJR
ks82e06zJWPcdqa+zqQVOskg0uX0JwiyZ/KpCchC5oAks9/vS8lVEKIWmvV6mDc+
fSyoIr/FaqMC90N1oxY8Um86S1kmymhpEtnINkM9caI87PO3xa+hFhKdnXBXE2Mm
N0SyuSif++w/3uuUPR1bdyxWu84iY5jfWieTdwy3ifnMp9bjd2MOFhmuq8nPFNs5
SGSFG8sKZ+GF3xNDwnql+3cHQJtIWhiTTGJoI9jLOqWapT5yovSiVU9Wf/pr9EQA
IkoVzWVsGR/1U7JLfIba1HbENLgwDhVHvOZfPQYhzjCq+u4UD8YhjlSu9QfwHL8D
e64dyyH4dD4J8Pov+3Nv
=JUda
-----END PGP SIGNATURE-----

--Signature=_Tue__12_Jun_2012_14_07_11_+1000_IVIL8vRsiTQ8xWCe--
