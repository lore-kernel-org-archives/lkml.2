Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754938Ab1B1Pnd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 10:43:33 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:59883 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754609Ab1B1Pnc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 10:43:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=CGtTy4u4gSZ8IuPohURKDhOrTOdAAhjT0Uzbo/6+fXLNESuxZT5us7OFqTD5EXIgbh
         FfGhOydzl8Mg1GPpE98oyvWfPbyLAzL6QY3PARm0QpwzBmJVhf0K2nNGoE444BbKq/2q
         F5l4dNLo5uhF1vken+4uWrl6g/VnVvoVK6B2E=
Date: Mon, 28 Feb 2011 17:43:14 +0200
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Andreas =?iso-8859-1?Q?Bie=DFmann?= <biessmann@corscience.de>
Cc: linux-kernel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] fs-writeback: fix NULL pointer dereference in
 __mark_inode_dirty
Message-ID: <20110228154314.GA4675@swordfish.minsk.epam.com>
References: <1298906733-31427-1-git-send-email-biessmann@corscience.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="G4iJoqBmSsgzjUCe"
Content-Disposition: inline
In-Reply-To: <1298906733-31427-1-git-send-email-biessmann@corscience.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--G4iJoqBmSsgzjUCe
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On (02/28/11 16:25), Andreas Bie=DFmann wrote:
> This patch fixes a kernel NULL pointer dereference as mentioned in this l=
og:
>=20
> ---8<---
> [   43.044000] mmc0: card c556 removed
> [   43.059000] mmcblk0: error -123 sending status comand
> [   43.064000] mmcblk0: error -123 sending read/write command, response 0=
x0, card status 0x0
> [   43.089000] mmcblk0: error -123 requesting status
> [   43.096000] end_request: I/O error, dev mmcblk0, sector 1667989
> <snip repeated error>
> [   43.830000] end_request: I/O error, dev mmcblk0, sector 1667988
> [   44.679000] Unable to handle kernel NULL pointer dereference at virtua=
l address 00000010
> [   44.688000] ptbr =3D 93ec0000 pgd =3D 93ebf000
> [   44.692000] Oops: Kernel access of bad area, sig: 11 [#1]
> [   44.692000] FRAME_POINTER chip: 0x01f:0x1e82 rev 2
> [   44.692000] Modules linked in:
> [   44.692000] PC is at __mark_inode_dirty+0x8a/0x11c
> [   44.692000] LR is at __mark_inode_dirty+0x7c/0x11c
> <snip stack trace>
> [   44.692000] Call trace:
> [   44.692000]  [<900780a4>] file_update_time+0x96/0xaa
> [   44.692000]  [<9005439a>] __generic_file_aio_write+0x212/0x330
> [   44.692000]  [<900544f4>] generic_file_aio_write+0x3c/0x74
> [   44.692000]  [<9006b82c>] do_sync_readv_writev+0x68/0x90
> [   44.692000]  [<9006b8c0>] do_readv_writev+0x6c/0x108
> [   44.692000]  [<9006b98a>] vfs_writev+0x2e/0x34
> [   44.692000]  [<9006be60>] sys_writev+0x2c/0x4c
> [   44.692000]  [<90023132>] syscall_return+0x0/0x12
> [   44.692000]
> --->8---
>=20
> The reference to sb->s_bdi may be deleted from mmc_blk_remove() ->
> del_gendisk() -> unlink_gendisk() -> bdi_unregister() -> bdi_prune_sb() w=
hile
> another instance try to write some data to the device.
>=20
> Signed-off-by: Andreas Bie=DFmann <biessmann@corscience.de>
> ---
>  fs/fs-writeback.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
>=20
> diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
> index cdbf7ac..96b4b25 100644
> --- a/fs/fs-writeback.c
> +++ b/fs/fs-writeback.c
> @@ -1047,6 +1047,9 @@ void __mark_inode_dirty(struct inode *inode, int fl=
ags)
>  		if (!was_dirty) {
>  			bdi =3D inode_to_bdi(inode);
> =20
> +			if (!bdi)
> +				goto out;
> +
>  			if (bdi_cap_writeback_dirty(bdi)) {
>  				WARN(!test_bit(BDI_registered, &bdi->state),
>  				     "bdi-%s not registered\n", bdi->name);

Hello,
I had something very similar to this some time ago
https://lkml.org/lkml/2010/12/9/436

However, I'm not sure that this check is sufficient.


	Sergey

--G4iJoqBmSsgzjUCe
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iJwEAQECAAYFAk1rwpIACgkQfKHnntdSXjSUbQQA05S8quxALit1QLn+m1rp7X1I
7tWe4SV/ovYOp9hJqtu87PQvZ6Z7Y5ZwEtZX7xgpqvq8C8fVE0PPGMOZcAICT2Cb
DKuKy29XrpOfoiMu38gfT8l77lNFXhzPnJKEEArVp4cCr33NCtE8/C5dm8kdze//
79NhhfeF6KGkPdktlGg=
=3Ra8
-----END PGP SIGNATURE-----

--G4iJoqBmSsgzjUCe--
