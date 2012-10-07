Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752271Ab2JGBrt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Oct 2012 21:47:49 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:58009 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750860Ab2JGBrr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Oct 2012 21:47:47 -0400
Message-ID: <1349574442.16173.82.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [ 110/180] ext4: dont let i_reserved_meta_blocks go negative
From: Ben Hutchings <ben@decadent.org.uk>
To: Brian Foster <bfoster@redhat.com>
Cc: Theodore Tso <tytso@mit.edu>, Willy Tarreau <w@1wt.eu>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Date: Sun, 07 Oct 2012 02:47:22 +0100
In-Reply-To: <506ECB8F.80509@redhat.com>
References: <6a854f579a99b4fe2efaca1057e8ae22@local>
	 <20121001225202.266707400@1wt.eu> <20121004215528.GK13292@decadent.org.uk>
	 <506ECB8F.80509@redhat.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-gNJd6pIzGjCKzKuiOXKR"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-gNJd6pIzGjCKzKuiOXKR
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2012-10-05 at 07:59 -0400, Brian Foster wrote:
> On 10/04/2012 05:55 PM, Ben Hutchings wrote:
> > On Tue, Oct 02, 2012 at 12:53:47AM +0200, Willy Tarreau wrote:
> >> 2.6.32-longterm review patch.  If anyone has any objections, please le=
t me know.
> >>
> >> ------------------
> >>
> >> From: Brian Foster <bfoster@redhat.com>
> >>
> >> commit 97795d2a5b8d3c8dc4365d4bd3404191840453ba upstream.
> >>
> >> If we hit a condition where we have allocated metadata blocks that
> >> were not appropriately reserved, we risk underflow of
> >> ei->i_reserved_meta_blocks.  In turn, this can throw
> >> sbi->s_dirtyclusters_counter significantly out of whack and undermine
> >> the nondelalloc fallback logic in ext4_nonda_switch().  Warn if this
> >> occurs and set i_allocated_meta_blocks to avoid this problem.
> >>
> >> This condition is reproduced by xfstests 270 against ext2 with
> >> delalloc enabled:
> >>
> >> Mar 28 08:58:02 localhost kernel: [  171.526344] EXT4-fs (loop1): dela=
yed block allocation failed for inode 14 at logical offset 64486 with max b=
locks 64 with error -28
> >> Mar 28 08:58:02 localhost kernel: [  171.526346] EXT4-fs (loop1): This=
 should not happen!! Data will be lost
> >>
> >> 270 ultimately fails with an inconsistent filesystem and requires an
> >> fsck to repair.  The cause of the error is an underflow in
> >> ext4_da_update_reserve_space() due to an unreserved meta block
> >> allocation.
> > [...]
> >> +	if (unlikely(ei->i_allocated_meta_blocks > ei->i_reserved_meta_block=
s)) {
> >> +		ext4_msg(inode->i_sb, KERN_NOTICE, "%s: ino %lu, allocated %d "
> >> +			 "with only %d reserved metadata blocks\n", __func__,
> >> +			 inode->i_ino, ei->i_allocated_meta_blocks,
> >> +			 ei->i_reserved_meta_blocks);
> >> +		WARN_ON(1);
> >> +		ei->i_allocated_meta_blocks =3D ei->i_reserved_meta_blocks;
> >> +	}
> > [...]
> > =20
> > This seems to be working around a bug elsewhere.  Has the underlying
> > bug been fixed in mainline yet?
> >=20
>=20
> Yes, the bug was fixed in:
>=20
> 03179fe92318e7934c180d96f12eff2cb36ef7b6
> ext4: undo ext4_calc_metadata_amount if we fail to claim space

OK, and that's been applied to stable as:

3.2: d9af293 ext4: undo ext4_calc_metadata_amount if we fail to claim space
3.4: c0ce1fd ext4: undo ext4_calc_metadata_amount if we fail to claim space
3.5: 564dfa3 ext4: undo ext4_calc_metadata_amount if we fail to claim space

Presumably it will need some backporting for older versions.

Ben.

--=20
Ben Hutchings
You can't have everything.  Where would you put it?

--=-gNJd6pIzGjCKzKuiOXKR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUHDfKue/yOyVhhEJAQovgA/+J8NsrqN9Cax6yD2pAQ+5meY9k5TqkcOf
UnTZB3ov7tcYtJ0Wl5yVT+Xlkrt4mAGLSXgEaK5hqCEwkjj3hOy5d2WHjnXwZnDi
zpxQr59+n/EW0iWjN6seNHUphlfkKxefsL3pOrostMstcyV1ZHjvU9ZgtjvicItl
2QV5sGhLnEfez/AXssvX1/m5nZrWO9x+Td3K29s9DN3czsBiptZlPKjkjs+wpS0j
fygmQVyi0r0f9dLH2WQm8c+DsXsDorDZZktf67M8r17JFL+vAJ+ZAVVEHp/6wn8R
cXC0bhm0jyNnuC0xSH3LDG+pOM5Ffpf7XWF30rP8lUpaV2FIfdeHoqtNvUdstB0V
RPb2kr6Eu0Xucwve5KSsluO37N1Fwihu1q6eMwP4QKQgprMp0WZ//OHpf5sAApQs
R9/rJGpwVvd1QgkiNZjvT300mpYUPnUsrm5u1Le9dwKHYGXR1KE0Ej71QeO66fOm
SESEbpzs0ZgDbpFjyqYq07tBlioh6ZBFzVLt+bpMQdIVun5DYb4KLqXV4NL67gnQ
wTJm5brLhzXilPtQnCrYbSG6SkH310bm9w5qqggUzY08iHVjcsiX6opX7utTmGZp
I7/sPh4tU9F9/arxIAFTNU32oRhgy7d2/TwXHXExIlaOANklHu+D9KUxvcGOjRkw
9MaCVryBNgc=
=TvPH
-----END PGP SIGNATURE-----

--=-gNJd6pIzGjCKzKuiOXKR--
