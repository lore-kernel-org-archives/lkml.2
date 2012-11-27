Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757693Ab2K0BFq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 20:05:46 -0500
Received: from cantor2.suse.de ([195.135.220.15]:51522 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754842Ab2K0BFp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 20:05:45 -0500
Date: Tue, 27 Nov 2012 12:05:28 +1100
From: NeilBrown <neilb@suse.de>
To: Torsten Kaiser <just.for.lkml@googlemail.com>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Hang in md-raid1 with 3.7-rcX
Message-ID: <20121127120528.637099aa@notabene.brown>
In-Reply-To: <CAPVoSvQNVnz=NrkNaZ4G_k76WuVaAJ24uEXkAyJvDNLHHPs1Kw@mail.gmail.com>
References: <CAPVoSvQNVnz=NrkNaZ4G_k76WuVaAJ24uEXkAyJvDNLHHPs1Kw@mail.gmail.com>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/+/BvzJH0uc1Pxr2lWE/tfst"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/+/BvzJH0uc1Pxr2lWE/tfst
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sat, 24 Nov 2012 10:18:44 +0100 Torsten Kaiser
<just.for.lkml@googlemail.com> wrote:

> After my system got stuck with 3.7.0-rc2 as reported in
> http://marc.info/?l=3Dlinux-kernel&m=3D135142236520624 LOCKDEP seem to
> blame XFS, because it found 2 possible deadlocks. But after these
> locking issues where fixed, my system got stuck again with 3.7.0-rc6
> as reported in http://marc.info/?l=3Dlinux-kernel&m=3D135344072325490
> Dave Chinner thinks its an issue within md, that it gets stuck and
> that will then prevent any further xfs activity, and that I should
> report it to the raid mailing list.
>=20
> The issue seems to be that multiple processes (kswapd0, xfsaild/md4
> and flush-9:4) get stuck in md_super_wait() like this:
> [<ffffffff816b1224>] schedule+0x24/0x60
> [<ffffffff814f9dad>] md_super_wait+0x4d/0x80
> [<ffffffff8105ca30>] ? __init_waitqueue_head+0x60/0x60
> [<ffffffff81500753>] bitmap_unplug+0x173/0x180
> [<ffffffff810b6acf>] ? write_cache_pages+0x12f/0x420
> [<ffffffff810b6700>] ? set_page_dirty_lock+0x60/0x60
> [<ffffffff814e8eb8>] raid1_unplug+0x98/0x110
> [<ffffffff81278a6d>] blk_flush_plug_list+0xad/0x240
> [<ffffffff81278c13>] blk_finish_plug+0x13/0x50
>=20
> The full hung-tasks stack traces and the output from SysRq+W can be
> found at http://marc.info/?l=3Dlinux-kernel&m=3D135344072325490 or in the
> LKML thread 'Hang in XFS reclaim on 3.7.0-rc3'.

Yes, it does look like an md bug....
Can you test to see if this fixes it?

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 636bae0..a0f7309 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -963,7 +963,7 @@ static void raid1_unplug(struct blk_plug_cb *cb, bool f=
rom_schedule)
 	struct r1conf *conf =3D mddev->private;
 	struct bio *bio;
=20
-	if (from_schedule) {
+	if (from_schedule || current->bio_list) {
 		spin_lock_irq(&conf->device_lock);
 		bio_list_merge(&conf->pending_bio_list, &plug->pending);
 		conf->pending_count +=3D plug->pending_cnt;

>=20
> I tried to understand how this could happen, but I don't see anything
> wrong. Only that md_super_wait() looks like an open coded version of
> __wait_event() and could be replaced by using it.

yeah.  md_super_wait was much more complex back when we had to support
barrier operations.  When they were removed it was simplified a lot and as
you say it could be simplifier further.  Patches welcome.


>=20
> http://marc.info/?l=3Dlinux-raid&m=3D135283030027665 looks like the same
> issue, but using ext4 instead of xfs.

yes, sure does.

>=20
> My setup wrt. md is two normal sata disks on a normal ahci controller
> (AMD SB850 southbridge).
> Both disks are divided into 4 partitions and each one assembled into a
> separate raid1.
> One (md5) is used for swap, the others hold xfs filesystems for /boot/
> (md4), / (md6) and /home/ (md7).
>=20
> I will try to provide any information you ask, but I can't reproduce
> the hang on demand so gathering more information about that state is
> not so easy, but I will try.

I'm fairly confident the above patch will fixes it, and in any case it fixes
a real bug.  So if you could just run with it and confirm in a week or so
that the problem hasn't recurred, that might have to do.

Thanks,
NeilBrown


--Sig_/+/BvzJH0uc1Pxr2lWE/tfst
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBULQR2Tnsnt1WYoG5AQJCIhAAmtFKz8Fh6BeQx0r4Wdatdr+eGCpLDkt6
Hp82o28Azli95SU1yL+IPvpDeeCnQxY7yrjJ88wviyVwQvauNxszd3xPWvBkIELf
EODvyeaizVOPWQLR0m34b/YcjvOHsG+xbicToh/PuECnbk3Q0GIDrXkLsCHknRpo
esyJEK5j4TiTROeoBwzSnczvAazi3zCksvGFZmoZwLIziykFkNF4Jt+HZk5tz5Oq
Z6BVQCkw7OPhuhvYe/RNMOYBtGIUjuCL+5wjKAhs0B//cQFNzw4aYIjt6uK5/x6d
jLnLf77OL9m2+IWk63Jo11X/NHjx5S2OEE9SQA5QU2bRrMpoHVKwpVtTFhTkuXJp
rlcrD6g7TBZThcuzX8L1jqlJQ8LvSZKZ74CUhuUkW7RiBcPxxYNETN7C65BbW9Wr
NmqXnLnoutg6BnP5TCx/4d5nXZQmgz5oke92/NjATYSQdyZD66TJvOEGdBkwy89J
qwTYsODiQwj7VDquF8lbiJaR5WDcKKGtRCSDEE5vumicfv5vyPNmEETqFIe+Xb7h
dzGV6CsAH/Bq+EPhaaiTMhbF/IkzmHuc3r1T/myEcrcHSu979ydolxtDc3UtgdbM
3eimczCOXEEUNAHbxZI2mJ1HHEaGiXM/cyrST3lZH5kztq7Fdsug7j3xV93UtFF3
xlOG9iE7SfI=
=a2JU
-----END PGP SIGNATURE-----

--Sig_/+/BvzJH0uc1Pxr2lWE/tfst--
