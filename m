Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754932Ab0IYTC5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Sep 2010 15:02:57 -0400
Received: from mondschein.lichtvoll.de ([194.150.191.11]:55027 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751448Ab0IYTC4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Sep 2010 15:02:56 -0400
From: Martin Steigerwald <Martin@lichtvoll.de>
To: linux-pm@lists.linux-foundation.org
Subject: Re: [linux-pm] [PATCH] Hibernate: Implement readahead when resuming
Date: Sat, 25 Sep 2010 21:02:41 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.36-rc5-tp42-hibernate-accel-vmembase-0-00135-gd4e7490-dirty; KDE/4.5.1; i686; ; )
Cc: Nigel Cunningham <nigel@tuxonice.net>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        LKML <linux-kernel@vger.kernel.org>,
        "TuxOnIce-devel" <tuxonice-devel@tuxonice.net>
References: <1285416056-9735-1-git-send-email-nigel@tuxonice.net> <1285416056-9735-2-git-send-email-nigel@tuxonice.net> (sfid-20100925_155139_503661_B410FD8E)
In-Reply-To: <1285416056-9735-2-git-send-email-nigel@tuxonice.net>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1313157.oMaPXLOUAa";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201009252102.52401.Martin@lichtvoll.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1313157.oMaPXLOUAa
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

Hi Nigel and Rafael,

Am Samstag 25 September 2010 schrieb Nigel Cunningham:
> Add support for submitting reads before they're needed. This greatly
> improves the speed of resuming:
>=20
> From
>=20
> PM: Image read at 66 MB/s.
>=20
> to
>=20
> PM: Image read at 229 MB/s.
>=20
> ...and removes the need for the sync_read flag.

So

martin@shambhala:~/Computer/Shambhala/Kernel/2.6.36/tuxonice-head> git=20
branch -av | grep for-rafael
* for-rafael                      d4e7490 Hibernate: Implement readahead=20
when resuming
  remotes/origin/for-rafael       d4e7490 Hibernate: Implement readahead=20
when resuming

martin@shambhala:~> cat /proc/version
Linux version 2.6.36-rc5-tp42-hibernate-accel-vmembase-0-00135-gd4e7490-
dirty (martin@shambhala) (gcc version 4.4.5 20100728 (prerelease) (Debian=20
4.4.4-8) ) #1 PREEMPT Sat Sep 25 18:02:02 CEST 2010

basically seems to work.

But

> Signed-off-by: Nigel Cunningham <nigel@tuxonice.net>
> ---
>  kernel/power/block_io.c |   97
> ++++++++++++++++++++++++++++++++++++++++++++--- kernel/power/power.h =20
>  |    4 --
>  kernel/power/snapshot.c |    5 --
>  kernel/power/swap.c     |    2 -
>  4 files changed, 91 insertions(+), 17 deletions(-)
>=20
> diff --git a/kernel/power/block_io.c b/kernel/power/block_io.c
> index fc2e05d..5a13f80 100644
> --- a/kernel/power/block_io.c
> +++ b/kernel/power/block_io.c
[...]
> +	if (!offset) {
> +		printk("Offset zero - no more readahead.\n");
> +		more_readahead =3D 0;
> +		return 0;
> +	}
> +
> +	printk("(1) Submitting readahead of sector %llu to page %p.\n",
> +			offset, ra_page);

and

> +	if (!readahead_list_head) {
> +		printk("No readahead left. Returning -EFAULT.\n");
>  		return -EFAULT;
> -	return hib_bio_read_page(offset, buf, sync);
> +	}
> +
> +	printk("Waiting on readahead of page %p.\n", readahead_list_head);

should be made optional - activatable via a debug switch - before this=20
gets merged, cause it displays a lots of these on resuming which takes=20
some time in itself.

I tried 5 times:

=2D one with just kdm started worked nicely and really rather fast!

=2D four with a full blown KDE 4.5.1 session with OpenGL compositing
  - one seemed to hang prior to reinitializing the Radeon KMS DRM setup
  - three other worked just fine

I do not think that the hang is related to your changes, Nigel. The kernel=
=20
remained stuck at the lower initial resolution and didn't seem to=20
initialize the radeon KMS framebuffers at 1400x1050 properly. I didn't see=
=20
this with 2.6.35 and userspace software suspend.

Writing and reading seems to be way faster than with userspace software=20
suspend, I didn't compare with unpatched in kernel suspend. But I do not=20
seem to get any numbers printed:

shambhala:~> grep "Image read" /var/log/syslog
shambhala:~#1> dmesg | grep "Image read"       =20
shambhala:~#1> dmesg | grep "Image writ"
shambhala:~#1> grep "Image writ" /var/log/syslog
shambhala:~#1>

The machine seems to return more quickly to an usable state. Does in=20
kernel suspend save larger images? I am especially surprised as I use=20
compression with userspace software suspend which I thought should speed=20
up writing the image. It feels that in kernel suspend with patches from=20
you, Nigel, seems to outdo userspace software suspend by quite some=20
margin.

I have a quite high setting for userspace software suspend image size:

  1 # /etc/uswsusp.conf(8) -- Configuration file for s2disk/s2both=B7
  2 resume device =3D /dev/sda2
  3 compress =3D y
  4 early writeout =3D y
  5 image size =3D 1500
  6 shutdown method =3D halt

Still the machine crawls on resume for about 30 seconds or a minute before=
=20
coming into a usable state. With patched in kernel suspend this wait for=20
responsivity seems to have cut down to about 10-15 seconds.

Please note: I didn't actually measure anything of this, this is just=20
subjective impressions so far. Before measuring, I think I should disable=20
those debug outputs I mentioned above ;).

The ThinkPad T42 I am testing on has 2 GiB RAM. Swap is about 4 GB.

No long term observations so far. I will report how it goes.

Thanks,
=2D-=20
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7

--nextPart1313157.oMaPXLOUAa
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAkyeR1IACgkQmRvqrKWZhMdC+wCfVV8f+o/T7Hh2kzqYhVUXL37I
o4EAnRXD2niVcszug7n8wAC3iJzwFzuM
=BA9W
-----END PGP SIGNATURE-----

--nextPart1313157.oMaPXLOUAa--
