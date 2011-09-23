Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752925Ab1IWJzr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Sep 2011 05:55:47 -0400
Received: from cantor2.suse.de ([195.135.220.15]:34047 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752734Ab1IWJzp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Sep 2011 05:55:45 -0400
Date: Fri, 23 Sep 2011 19:55:36 +1000
From: NeilBrown <neilb@suse.de>
To: "Daniel P. Berrange" <berrange@redhat.com>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] md: don't delay reboot by 1 second if no MD devices
 exist
Message-ID: <20110923195536.257bad23@notabene.brown>
In-Reply-To: <1316770845-18171-1-git-send-email-berrange@redhat.com>
References: <1316770845-18171-1-git-send-email-berrange@redhat.com>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.22.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/BKKfOMB1q5Z9mX17=o=z6qf"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/BKKfOMB1q5Z9mX17=o=z6qf
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 23 Sep 2011 10:40:45 +0100 "Daniel P. Berrange" <berrange@redhat.co=
m>
wrote:

> From: "Daniel P. Berrange" <berrange@redhat.com>
>=20
> The md_notify_reboot() method includes a call to mdelay(1000),
> to deal with "exotic SCSI devices" which are too volatile on
> reboot. The delay is unconditional. Even if the machine does
> not have any block devices, let alone MD devices, the kernel
> shutdown sequence is slowed down.
>=20
> 1 second does not matter much with physical hardware, but with
> certain virtualization use cases any wasted time in the bootup
> & shutdown sequence counts for alot.
>=20
> * drivers/md/md.c: md_notify_reboot() - only impose a delay if
>   there was at least one MD device to be stopped during reboot
>=20
> Signed-off-by: Daniel P. Berrange <berrange@redhat.com>

queued for next merge window .... or maybe even next -rc if I'm feeling
brave.

Thanks,
NeilBrown


> ---
>  drivers/md/md.c |    8 ++++++--
>  1 files changed, 6 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 5404b22..ef7ad8d 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -8059,12 +8059,13 @@ static int md_notify_reboot(struct notifier_block=
 *this,
>  {
>  	struct list_head *tmp;
>  	mddev_t *mddev;
> +	int need_delay =3D 0;
> =20
>  	if ((code =3D=3D SYS_DOWN) || (code =3D=3D SYS_HALT) || (code =3D=3D SY=
S_POWER_OFF)) {
> =20
>  		printk(KERN_INFO "md: stopping all md devices.\n");
> =20
> -		for_each_mddev(mddev, tmp)
> +		for_each_mddev(mddev, tmp) {
>  			if (mddev_trylock(mddev)) {
>  				/* Force a switch to readonly even array
>  				 * appears to still be in use.  Hence
> @@ -8073,13 +8074,16 @@ static int md_notify_reboot(struct notifier_block=
 *this,
>  				md_set_readonly(mddev, 100);
>  				mddev_unlock(mddev);
>  			}
> +			need_delay =3D 1;
> +		}
>  		/*
>  		 * certain more exotic SCSI devices are known to be
>  		 * volatile wrt too early system reboots. While the
>  		 * right place to handle this issue is the given
>  		 * driver, we do want to have a safe RAID driver ...
>  		 */
> -		mdelay(1000*1);
> +		if (need_delay)
> +			mdelay(1000*1);
>  	}
>  	return NOTIFY_DONE;
>  }


--Sig_/BKKfOMB1q5Z9mX17=o=z6qf
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iD8DBQFOfFeYG5fc6gV+Wb0RAlLVAJ9GL54CCnheoOIcMD3ekFh7IjW0bwCfRxLE
y1M5+jG85oQnyKmFOR/eiak=
=mgGx
-----END PGP SIGNATURE-----

--Sig_/BKKfOMB1q5Z9mX17=o=z6qf--
