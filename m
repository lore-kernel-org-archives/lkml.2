Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755575Ab0LHUV3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 15:21:29 -0500
Received: from mail.sf-mail.de ([62.27.20.61]:55257 "EHLO mail.sf-mail.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755381Ab0LHUV2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 15:21:28 -0500
X-Greylist: delayed 389 seconds by postgrey-1.27 at vger.kernel.org; Wed, 08 Dec 2010 15:21:27 EST
From: Rolf Eike Beer <eike-kernel@sf-tec.de>
To: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 5/8] scsi: fix TUR error handling in sr_media_change()
Date: Wed, 8 Dec 2010 21:14:40 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.34.7-0.5-desktop; KDE/4.5.3; i686; ; )
Cc: jeff@garzik.org, linux-ide@vger.kernel.org, axboe@kernel.dk,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        kay.sievers@vrfy.org, jack@suse.cz,
        James.Bottomley@hansenpartnership.com
References: <1291838262-21274-1-git-send-email-tj@kernel.org> <1291838262-21274-6-git-send-email-tj@kernel.org>
In-Reply-To: <1291838262-21274-6-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart3076944.NXSmOvlDyz";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201012082114.41509.eike-kernel@sf-tec.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart3076944.NXSmOvlDyz
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Tejun Heo wrote:

> --- a/drivers/scsi/sr.c
> +++ b/drivers/scsi/sr.c
> @@ -214,13 +214,17 @@ static int sr_media_change(struct cdrom_device_info
> *cdi, int slot)
>=20
>  	sshdr =3D  kzalloc(sizeof(*sshdr), GFP_KERNEL);
>  	retval =3D sr_test_unit_ready(cd->device, sshdr);
> -	if (retval || (scsi_sense_valid(sshdr) &&
> -		       /* 0x3a is medium not present */
> -		       sshdr->asc =3D=3D 0x3a)) {
> -		/* Media not present or unable to test, unit probably not
> -		 * ready. This usually means there is no disc in the drive.
> -		 * Mark as changed, and we will figure it out later once
> -		 * the drive is available again.
> +	/*
> +	 * Media is considered to be present if TUR succeeds or fails with
> +	 * sense data indicating something other than media-not-present
> +	 * (ASC 0x3a).
> +	 */
> +	if (!scsi_status_is_good(retval) &&
> +	    (!scsi_sense_valid(sshdr) || sshdr->asc =3D=3D 0x3a)) {
> +		/*
> +		 * Probably not media in the device.  Mark as changed, and
> +		 * we will figure it out later once the drive is available
> +		 * again.

"Probably no media ..."?

Eike

--nextPart3076944.NXSmOvlDyz
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.15 (GNU/Linux)

iEYEABECAAYFAkz/5zEACgkQXKSJPmm5/E4RIwCgmLecVbJQphEZPlyM+labK9/2
ybIAnAxCKEHzpksGxmq+XOHz9DSlTTi8
=/66e
-----END PGP SIGNATURE-----

--nextPart3076944.NXSmOvlDyz--
