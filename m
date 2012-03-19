Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932269Ab2CSDdt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Mar 2012 23:33:49 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:40058 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932111Ab2CSDds (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Mar 2012 23:33:48 -0400
Date: Mon, 19 Mar 2012 14:33:35 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Chris Ball <cjb@laptop.org>
Subject: linux-next: manual merge of the pm tree with the mmc tree
Message-Id: <20120319143335.8b31091f03de60e41987efde@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta6 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__19_Mar_2012_14_33_35_+1100_0dpypry1YMU0rzV8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__19_Mar_2012_14_33_35_+1100_0dpypry1YMU0rzV8
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Rafael,

Today's linux-next merge of the pm tree got a conflict in
drivers/mmc/host/tmio_mmc_pio.c between commit 4d741159c282 ("mmc:
tmio_mmc: support the generic MMC GPIO card hotplug helper") from the mmc
tree and commit c419e611c3c5 ("tmio_mmc / PM: Use PM QoS latency
constraint") from the pm tree.

Just context changes.  I fixed it up (see below) and can carry the fix as
necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/mmc/host/tmio_mmc_pio.c
index e476baf1,e219889..0000000
--- a/drivers/mmc/host/tmio_mmc_pio.c
+++ b/drivers/mmc/host/tmio_mmc_pio.c
@@@ -996,20 -983,22 +999,22 @@@ EXPORT_SYMBOL(tmio_mmc_host_probe)
  void tmio_mmc_host_remove(struct tmio_mmc_host *host)
  {
  	struct platform_device *pdev =3D host->pdev;
 +	struct tmio_mmc_data *pdata =3D host->pdata;
 +	struct mmc_host *mmc =3D host->mmc;
 =20
 -	/*
 -	 * We don't have to manipulate pdata->power here: if there is a card in
 -	 * the slot, the runtime PM is active and our .runtime_resume() will not
 -	 * be run. If there is no card in the slot and the platform can suspend
 -	 * the controller, the runtime PM is suspended and pdata->power =3D=3D f=
alse,
 -	 * so, our .runtime_resume() will not try to detect a card in the slot.
 -	 */
 -	if (host->pdata->flags & TMIO_MMC_HAS_COLD_CD
 -		|| host->mmc->caps & MMC_CAP_NEEDS_POLL
 -		|| host->mmc->caps & MMC_CAP_NONREMOVABLE)
 +	if (pdata->flags & TMIO_MMC_USE_GPIO_CD)
 +		/*
 +		 * This means we can miss a card-eject, but this is anyway
 +		 * possible, because of delayed processing of hotplug events.
 +		 */
 +		mmc_cd_gpio_free(mmc);
 +
 +	if (!host->native_hotplug)
  		pm_runtime_get_sync(&pdev->dev);
 =20
+ 	dev_pm_qos_hide_latency_limit(&pdev->dev);
+=20
 -	mmc_remove_host(host->mmc);
 +	mmc_remove_host(mmc);
  	cancel_work_sync(&host->done);
  	cancel_delayed_work_sync(&host->delayed_reset_work);
  	tmio_mmc_release_dma(host);

--Signature=_Mon__19_Mar_2012_14_33_35_+1100_0dpypry1YMU0rzV8
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPZqkPAAoJEECxmPOUX5FElskP/R1h9PSl/b9g+FZkKci5tscJ
ojnuvdTmuORZ0dV9SPVPT7JZLjCdGwT9bzpe+fce5zMN+STXZiGRc83/UuZu/NLX
+zRkCpM64plGFquHKBixOhVgyG3rps1VcnCrR0ZPDUHukCZqLpgmUqZ0BJCMrTiF
7px6bc+B/YvsDExwF3yzUkn/jiYLnbY5N7QLvtAcIM+AG7yTLY561D5IKqWgUcjH
axpLab9YxRHDo4bsfDfROC9dz12FbcbgqV4Alo94/CLj3r1EMkfLhW+ua2UGGdn/
UeasFY6WHHn1yWYn0AAi9pFwNbBCuDJ/4vpKFYlhDshFWsS2j9du++Np726m2oef
sdUOtI5/5z5tKGOfwo7Cbwls4YTuICbLz0mnZWj1zplhHH4vdMVhTTJqUQvDLWv1
CJroDxSz9NykKGDBu1asHzxhy0kcEtJRZGTWaqqWQh1C25eD5rQd0Vjpo7A9aApb
k1MXUeqphXMj0uHDmjhlzWXgXoW85IneCroWmX2R3ytS9/W48/dloHji4sDJmbEJ
qGhU8SVnTDgoSOHfnX+rse1+vJuVG7rf99r77wxFv2HnAh4eK+aL6dKDUerst/d5
QDlUpnFGvKwbCv8ruWzNQXC1Xj62twNlrQLb+D9oUS4MyFg5dGhALokQVNS8R41J
FYjg8M061RDmxwuy2SfI
=IKg+
-----END PGP SIGNATURE-----

--Signature=_Mon__19_Mar_2012_14_33_35_+1100_0dpypry1YMU0rzV8--
