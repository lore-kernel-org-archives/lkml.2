Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756467Ab2HOUqo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 16:46:44 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43017 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754152Ab2HOUqm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 16:46:42 -0400
Date: Thu, 16 Aug 2012 06:46:31 +1000
From: NeilBrown <neilb@suse.de>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [v2.6.34-stable 035/165] md: Fix handling for devices from 2TB
 to 4TB in 0.90 metadata.
Message-ID: <20120816064631.61c7026d@notabene.brown>
In-Reply-To: <1345060109-9187-36-git-send-email-paul.gortmaker@windriver.com>
References: <1345060109-9187-1-git-send-email-paul.gortmaker@windriver.com>
	<1345060109-9187-36-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/yCrcw3A+UgzW5GzTFY2gt4+"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/yCrcw3A+UgzW5GzTFY2gt4+
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 15 Aug 2012 15:46:19 -0400 Paul Gortmaker
<paul.gortmaker@windriver.com> wrote:

> From: NeilBrown <neilb@suse.de>
>=20
>                    -------------------
>     This is a commit scheduled for the next v2.6.34 longterm release.
>     http://git.kernel.org/?p=3Dlinux/kernel/git/paulg/longterm-queue-2.6.=
34.git
>     If you see a problem with using this for longterm, please comment.

This patch fixes one problem but unfortunately introduces another.
The patch for that 'other' should get sent to linus in the next day or so
after it has had a chance to sit in -next for a bit.

It can be found at:
 http://neil.brown.name/git?p=3Dmd;a=3Dcommitdiff;h=3D30b798a352052b07c9249=
56dda4ce720b00af711

you could either add that patch, or drop this patch until the next cycle.

Thanks,
NeilBrown

>                    -------------------
>=20
> commit 27a7b260f71439c40546b43588448faac01adb93 upstream.
>=20
> 0.90 metadata uses an unsigned 32bit number to count the number of
> kilobytes used from each device.
> This should allow up to 4TB per device.
> However we multiply this by 2 (to get sectors) before casting to a
> larger type, so sizes above 2TB get truncated.
>=20
> Also we allow rdev->sectors to be larger than 4TB, so it is possible
> for the array to be resized larger than the metadata can handle.
> So make sure rdev->sectors never exceeds 4TB when 0.90 metadata is in
> used.
>=20
> Also the sanity check at the end of super_90_load should include level
> 1 as it used ->size too. (RAID0 and Linear don't use ->size at all).
>=20
> Reported-by: Pim Zandbergen <P.Zandbergen@macroscoop.nl>
> Signed-off-by: NeilBrown <neilb@suse.de>
> Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
> ---
>  drivers/md/md.c | 12 ++++++++++--
>  1 file changed, 10 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index d26df7f..4788c82 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -985,8 +985,11 @@ static int super_90_load(mdk_rdev_t *rdev, mdk_rdev_=
t *refdev, int minor_version
>  			ret =3D 0;
>  	}
>  	rdev->sectors =3D rdev->sb_start;
> +	/* Limit to 4TB as metadata cannot record more than that */
> +	if (rdev->sectors >=3D (2ULL << 32))
> +		rdev->sectors =3D (2ULL << 32) - 2;
> =20
> -	if (rdev->sectors < sb->size * 2 && sb->level > 1)
> +	if (rdev->sectors < ((sector_t)sb->size) * 2 && sb->level >=3D 1)
>  		/* "this cannot possibly happen" ... */
>  		ret =3D -EINVAL;
> =20
> @@ -1021,7 +1024,7 @@ static int super_90_validate(mddev_t *mddev, mdk_rd=
ev_t *rdev)
>  		mddev->clevel[0] =3D 0;
>  		mddev->layout =3D sb->layout;
>  		mddev->raid_disks =3D sb->raid_disks;
> -		mddev->dev_sectors =3D sb->size * 2;
> +		mddev->dev_sectors =3D ((sector_t)sb->size) * 2;
>  		mddev->events =3D ev1;
>  		mddev->bitmap_info.offset =3D 0;
>  		mddev->bitmap_info.default_offset =3D MD_SB_BYTES >> 9;
> @@ -1260,6 +1263,11 @@ super_90_rdev_size_change(mdk_rdev_t *rdev, sector=
_t num_sectors)
>  	rdev->sb_start =3D calc_dev_sboffset(rdev->bdev);
>  	if (!num_sectors || num_sectors > rdev->sb_start)
>  		num_sectors =3D rdev->sb_start;
> +	/* Limit to 4TB as metadata cannot record more than that.
> +	 * 4TB =3D=3D 2^32 KB, or 2*2^32 sectors.
> +	 */
> +	if (num_sectors >=3D (2ULL << 32))
> +		num_sectors =3D (2ULL << 32) - 2;
>  	md_super_write(rdev->mddev, rdev, rdev->sb_start, rdev->sb_size,
>  		       rdev->sb_page);
>  	md_super_wait(rdev->mddev);


--Sig_/yCrcw3A+UgzW5GzTFY2gt4+
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBUCwKpznsnt1WYoG5AQKkfg//d6hSLzF+JegXtloVBF3QSxCxtm41SZjB
tAuyPjKNLrtMerFJb/HPvfTcN4ya3hY9HTv8PVYm7N83KFzTQYynkoLHuMpzk4QB
p93h2uoOdBA8R3VvNuYSDG+s5cWjm1uZ86c1L1ApTGJHSAZK0mQiYzizDaBmyO02
d9BVNXHEoidZLGJUoV44syeTPvEyEvANsZtMXjfFm6BMskqSSHoKmKmlkCGftNp1
e5kLgBorOmv0+SZLJFv1hMpYumSK4xdsfUnaIvUepOQ4cxUZiCCSDJUBaGkF9BUj
UYSwmScsm+in413BCDV0csvIfbMpeal/AbGw6Y2eIwgrYk0hbgxpDR6j8CG53IAS
9quxp7v/TQcMRj2dgIHn0slltLnHq9fTsfj0NtrJ9BKbbKwBtd7KbZ4EbbMv30xM
faTECV5GkYaP7yrmFP9I6YW1c76qgxc4SrEZGAQHvMNCgH1n2DbpGyWhM2es5YYQ
76pq/7gJTz88V0OSZCf/1jqZdfgxomI8LQGbsWP5kad5PuE7BZ9a0aNemk4MGWH8
urbOy8MbsYUh5kYGERVAVcLD8MpBggda7CFLpU9r3ODqmmsZhy8FaAdS3dHe5XTM
FCz1UuVITEGs61Uj564CWxhVwaG2M3FFge/O7eXMkLQaszSVRBsWh/zmALXypaZn
QKV/kAsSXbg=
=Tnr5
-----END PGP SIGNATURE-----

--Sig_/yCrcw3A+UgzW5GzTFY2gt4+--
