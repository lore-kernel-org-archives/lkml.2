Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752505Ab1LEByk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Dec 2011 20:54:40 -0500
Received: from cantor2.suse.de ([195.135.220.15]:50405 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751412Ab1LEByj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Dec 2011 20:54:39 -0500
Date: Mon, 5 Dec 2011 12:54:16 +1100
From: NeilBrown <neilb@suse.de>
To: Chris Ball <cjb@laptop.org>
Cc: linux-mmc@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>,
        Daniel Drake <dsd@laptop.org>, Ohad Ben-Cohen <ohad@wizery.com>
Subject: [PATCH] mmc/sdio: don't allow interface to runtime-suspend until
 probe is finished.
Message-ID: <20111205125416.6093ecd8@notabene.brown>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.22.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/Qv6gNZygOwNSHf3dW5E4.L2"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/Qv6gNZygOwNSHf3dW5E4.L2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable


Greetings.

 I've been chasing down a problem with the SDIO-attached wifi card in the
 GTA04 (www.gta04.org).
 The problem seems very similar to that described in=20

    http://www.mail-archive.com/linux-mmc@vger.kernel.org/msg04289.html

 as referenced in:

commit 08da834a24312157f512224691ad1fddd11c1073
Author: Daniel Drake <dsd@laptop.org>
Date:   Wed Jul 20 17:39:22 2011 +0100

    mmc: enable runtime PM by default


and if I revert that commit so that runtime PM is not enabled the problem
goes away.

(The wifi chip is a libertas_sdio supported chip connected to an mmc
interface on an omap3, and has a separate regulator for power supply, plus a
GPIO pin for reset, just like in the email thread.  The problem is
exemplified by:
[   64.643981] libertas_sdio: probe of mmc1:0001:1 failed with error -16
).

I finally managed to track down exactly what was happening - runtime PM was
putting the interface to sleep before the SDIO functions were probed so
initialising them failed.

This patch fixes it and seem to be 'correct'.

Please consider applying.

Thanks,
NeilBrown

From: NeilBrown <neilb@suse.de>
Date: Mon, 5 Dec 2011 11:34:47 +1100
Subject: [PATCH] mmc/sdio: don't allow interface to runtime-suspend until
 probe is finished.

mmc_attach_sdio currently enables runtime power management on
the mmc interface before it completes the probe of functions.
This means that it might be asleep during the probe and the probe
will fail.

In particular, if 'drivers_autoprobe' is enabled on the mmc bus, then
device_attach() will be called by bus_probe_device() from device_add()
and it will pm_runtime_get_noresume()/pm_runtime_put_sync().

As runtime power management this the device is running
(pm_runtime_set_active() in mmc_attach_sdio()) and rtpm is enabled
(pm_runtime_enable()), the pm_runtime_put_sync() call puts the mmc
interface to sleep, so function probing fails.

So this patch moves the call to pm_runtime_enable to after all the
calls to sdio_add_func.

Signed-off-by: NeilBrown <neilb@suse.de>

diff --git a/drivers/mmc/core/sdio.c b/drivers/mmc/core/sdio.c
index 3ab565e..c0c83f6 100644
--- a/drivers/mmc/core/sdio.c
+++ b/drivers/mmc/core/sdio.c
@@ -811,11 +811,6 @@ int mmc_attach_sdio(struct mmc_host *host)
 		err =3D pm_runtime_set_active(&card->dev);
 		if (err)
 			goto remove;
-
-		/*
-		 * Enable runtime PM for this card
-		 */
-		pm_runtime_enable(&card->dev);
 	}
=20
 	/*
@@ -858,6 +853,12 @@ int mmc_attach_sdio(struct mmc_host *host)
 	}
=20
 	mmc_claim_host(host);
+	if (host->caps & MMC_CAP_POWER_OFF_CARD) {
+		/*
+		 * Enable runtime PM for this card
+		 */
+		pm_runtime_enable(&card->dev);
+	}
 	return 0;
=20
=20

--Sig_/Qv6gNZygOwNSHf3dW5E4.L2
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTtwkSDnsnt1WYoG5AQKe/A//WQPKkx7JT4WLTWdkmN/P2wHuEMSrFKw7
SaHrzD8cBrQM4b/ZcXK26oqcxyuKf7AhqhpssRU18njPrMOn6OlF6WBpZ0WVrrhX
HSpZ1uylYarlpjWnCQO38XEdfoc4y+smk7bNLLNu/0zJAqvXAA61TJAmKBdbEUQk
wrN7LoHEZiXAqHRODlz1oIUn25VXBWaZIrMlEJJM5GxNmxPq076bEOmOfwCAA7d0
7cSJ3U1vZMQr9881bXviTiganOkPy3irkkx07cEJ/AqTdSkPMNWt7SsfmvUTBygq
BpPZSg72Rga2nj26GKzrgSPkp/9gh8gD9fiOlrsKCuXSpBOGyUUP3zIDpZSmCMK4
pmYeyoZ4neDYvweHjy250LWsbKhhbIJ2zgDc7Y3tEgLk2NGIxAXsG7NPvoQ5ZZ64
3t6spGdDzwG7RLG3cu5RGyRU8uNli5UbOcSUhZHdou4XQzF36KyP9OrZVU99E2oj
wozcFKkv4VElO1w0gZA5PNIwCzs5F09CpghpMnfz1+zrU+YkXNfOMSWHgD6CvvPZ
WIr9sFrHM/WRyMkzb+RoRVIDnruHFaq9pyslZVSPFUsQ6IsznF+Nc+t6ssMGjTFs
G6u4cYgjD8nBt1W/KZv1BG78anCUK4hTZZEkuHxXvv03/i+33YvttDGW1BjxMH/S
5QErcuzYOmE=
=ESbI
-----END PGP SIGNATURE-----

--Sig_/Qv6gNZygOwNSHf3dW5E4.L2--
