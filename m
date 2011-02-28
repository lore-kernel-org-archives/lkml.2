Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753890Ab1B1QbF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 11:31:05 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:51333 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751690Ab1B1QbC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 11:31:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=fA6e7o7ALqm8z0AjSsb6cszhLuR+ORokKOgcNv9Ob6uAttwXATdzrLlv2wowI4imPb
         b6tM9N6+Wozh9f/A0DeT/Dz66QqsikTWbsSYSVuhdpHJa72vlN8IMiirvGbpiJo2YP7H
         S1LOciPfE34lShiLhIWcmsMej6kXToFEFd9FE=
Date: Mon, 28 Feb 2011 18:29:09 +0200
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Andreas =?iso-8859-1?Q?Bie=DFmann?= <andreas.devel@googlemail.com>
Cc: linux-kernel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] fs-writeback: fix NULL pointer dereference in
 __mark_inode_dirty
Message-ID: <20110228162909.GB4675@swordfish.minsk.epam.com>
References: <1298906733-31427-1-git-send-email-biessmann@corscience.de>
 <20110228154314.GA4675@swordfish.minsk.epam.com>
 <4D6BC666.4010603@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="b5gNqxB1S1yM7hjW"
Content-Disposition: inline
In-Reply-To: <4D6BC666.4010603@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--b5gNqxB1S1yM7hjW
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On (02/28/11 16:59), Andreas Bie=DFmann wrote:
> Dear Sergey Senozhatsky,
>=20
> Am 28.02.2011 16:43, schrieb Sergey Senozhatsky:
> > On (02/28/11 16:25), Andreas Bie=DFmann wrote:
>=20
> >> The reference to sb->s_bdi may be deleted from mmc_blk_remove() ->
> >> del_gendisk() -> unlink_gendisk() -> bdi_unregister() -> bdi_prune_sb(=
) while
> >> another instance try to write some data to the device.
> >>
> >> Signed-off-by: Andreas Bie=DFmann <biessmann@corscience.de>
> >> ---
> >>  fs/fs-writeback.c |    3 +++
> >>  1 files changed, 3 insertions(+), 0 deletions(-)
> >>
> >> diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
> >> index cdbf7ac..96b4b25 100644
> >> --- a/fs/fs-writeback.c
> >> +++ b/fs/fs-writeback.c
> >> @@ -1047,6 +1047,9 @@ void __mark_inode_dirty(struct inode *inode, int=
 flags)
> >>  		if (!was_dirty) {
> >>  			bdi =3D inode_to_bdi(inode);
> >> =20
> >> +			if (!bdi)
> >> +				goto out;
> >> +
> >>  			if (bdi_cap_writeback_dirty(bdi)) {
> >>  				WARN(!test_bit(BDI_registered, &bdi->state),
> >>  				     "bdi-%s not registered\n", bdi->name);
> >=20
> > Hello,
> > I had something very similar to this some time ago
> > https://lkml.org/lkml/2010/12/9/436
>=20
> Sorry, I did not see that patch.
>
No problem :-)
=20
> > However, I'm not sure that this check is sufficient.
>=20
> Why are you think this is not sufficient?
> If an instance try to write that specific inode to an physical device
> which is not longer available how should we react then?
>=20

I think the path which `kills' the device should take care of that.
Otherwise, IMHO, we have:
- ok, we're falling on line 42 -- let's fix line 42

ignoring the fact that there are reasons which led to faulty line 42,
which are, for example:
#0=20
 604     spin_lock(&sb_lock);
 605     list_for_each_entry(sb, &super_blocks, s_list) {
 606         if (sb->s_bdi =3D=3D bdi)
 607             sb->s_bdi =3D NULL;
 608     }
 609     spin_unlock(&sb_lock);

#1 bdi_prune_sb                                        =20
#2 bdi_unregister               =20
#3 del_gendisk                  =20

Of course, I may be wrong.


> Another solution could be to clean up all instances referring to that
> superblock in del_/unlink_gendisk(). But I think to check the return of
> inode_to_bdi() is needed in any case.
>=20


	Sergey

--b5gNqxB1S1yM7hjW
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iJwEAQECAAYFAk1rzVUACgkQfKHnntdSXjSn1gP/fTZKLBKHKPn7Q5Om6E2ysfSY
ijAoOJMFzsPjPsfpk/bDNkDnyQ6b99dktDga3j8QcxkexN5AN7PbmGRGOBfEh8Pr
IHxyBTTVnVC36j5dSa+/w0XymepWeyJ2uPiMoKp6s+Cunnaob1x8uZ7rddAsESH/
Br5dvW1uJLqO4bigntA=
=9+gG
-----END PGP SIGNATURE-----

--b5gNqxB1S1yM7hjW--
