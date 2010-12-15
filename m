Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753428Ab0LOQNw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 11:13:52 -0500
Received: from gate.lvk.cs.msu.su ([158.250.17.1]:58713 "EHLO
	mail.lvk.cs.msu.su" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751861Ab0LOQNu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 11:13:50 -0500
X-Spam-ASN: 
Date: Wed, 15 Dec 2010 19:13:39 +0300
From: Alexander Gordeev <lasaine@lvk.cs.msu.su>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Alan Cox <alan@linux.intel.com>, linux-kernel@vger.kernel.org,
        "Nikita V\. Youshchenko" <yoush@cs.msu.su>, linuxpps@ml.enneenne.com,
        Rodolfo Giometti <giometti@enneenne.com>,
        Greg Kroah-Hartman <gregkh@suse.de>, Arnd Bergmann <arnd@arndb.de>,
        Al Viro <viro@zeniv.linux.org.uk>, Nick Piggin <npiggin@kernel.dk>,
        Jason Wessel <jason.wessel@windriver.com>,
        Philippe Langlais <philippe.langlais@stericsson.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCHv5 05/17] tty: don't allow ldisc dcd_change() after ldisc
 halt
Message-ID: <20101215191339.6e6f8ac0@desktopvm.lvknet>
In-Reply-To: <20101125140354.27ffca55@lxorguk.ukuu.org.uk>
References: <cover.1290599843.git.lasaine@lvk.cs.msu.su>
	<48e935cac42ae455e2ef8fc45f7eef7631eece6b.1290599844.git.lasaine@lvk.cs.msu.su>
	<20101124164329.75368d71@lxorguk.ukuu.org.uk>
	<20101125013812.0dc828ad@tornado.gnet>
	<20101124223600.5eb8476f@bob.linux.org.uk>
	<20101125163035.3105747b@desktopvm.lvknet>
	<20101125140354.27ffca55@lxorguk.ukuu.org.uk>
Organization: LVK
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA256;
 boundary="Sig_/ELSuFOy=vPO_KCFLYu.Jpju"; protocol="application/pgp-signature"
X-AV-Checked: ClamAV using ClamSMTP
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/ELSuFOy=vPO_KCFLYu.Jpju
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi,

Very sorry for the long delay.

=D0=92 Thu, 25 Nov 2010 14:03:54 +0000
Alan Cox <alan@lxorguk.ukuu.org.uk> =D0=BF=D0=B8=D1=88=D0=B5=D1=82:

> > Didn't know that current design is crap. :)
>=20
> It's based on the old big kernel lock and it has lots of horrors when
> used from interrupt paths as a result. A big chunk of it can in time I
> think move to just having a per tty ldisc lock that covers all changes
> etc, but we aren't there yet.
>=20
> > Ok, I think I'll add a new waitqueue and a new bit (TTY_LDISC_NOREF)
>=20
> We've got the wait queue already
>=20
> My first guess would be something like
>=20
> static struct tty_ldisc *tty_ldisc_irqget(struct tty_struct *tty)
> {
>         unsigned long flags;
>         struct tty_ldisc *ld;
>   =20
>         spin_lock_irqsave(&tty_ldisc_lock, flags);
>         ld =3D NULL;
>         if (test_bit(TTY_LDISC, &tty->flags)) {
>                 ld =3D get_ldisc(tty->ldisc);
> 		WARN_ON(test_and_set_bit(TTY_LDISC_IRQ, &tty->flags));
> 	}
>         spin_unlock_irqrestore(&tty_ldisc_lock, flags);
>         return ld;
> }
>=20
> static struct tty_ldisc *tty_ldisc_irqput(struct tty_ldisc *ld)
> {
> 	clear_bit(TTY_LDISC_IRQ, &tty->flags);
> 	tty_ldisc_put(ld);
> }
>=20
> (and I think you can then wait on tty_ldisc_idle for the flag to go clear
> after clearing TTY_LDISC)
>=20
> It might be better to make it a count of course in case there are later
> multiple users of this ?

I've just checked the code from v2.6.37 release candidates and found
that the problem is already completely fixed there with the revoking of
tty_ldisc_idle and tty_ldisc_wait_idle() in 100eeae2. :)

Sorry for the fuzz. The discussed patched is not needed any more and
will be dropped.

--=20
  Alexander

--Sig_/ELSuFOy=vPO_KCFLYu.Jpju
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBCAAGBQJNCOkzAAoJEElrwznyooJbMnEIAIjKp7tCMSt3p6Mb4H9D4XU/
iF5+Pm0Z+k9BOtJ79t6UykTfVq1bRraIKK02B0EioKH7PKWxZaUGSiJvOFeyA60T
ZGBDOp1RnXWR1IS5ZWAp0qgRtiH23JlD3jT4CQPrY6dp4FN8BGolv8lsoQrsjAvV
5rCa/db2R4voxDPn/zZavbukIP7OMRNdKYnXCmq9KzCA7r7umpZvwffy8PT0oRD4
uSH4jdlF7AznpZL7M20cSXJxL7PQ0K167x9lnuMQ8Rn3zs040AC7VcnhmLVDuVs/
uk5vNWVyQkxPaN+AD1SIbTZCvn8KczMHhDrUtFEAfMxKeJwEXuJHYqwYmerPI+4=
=yc1K
-----END PGP SIGNATURE-----

--Sig_/ELSuFOy=vPO_KCFLYu.Jpju--
