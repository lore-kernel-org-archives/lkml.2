Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932149Ab0KVPBj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Nov 2010 10:01:39 -0500
Received: from gate.lvk.cs.msu.su ([158.250.17.1]:40492 "EHLO
	mail.lvk.cs.msu.su" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756093Ab0KVPBi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Nov 2010 10:01:38 -0500
X-Spam-ASN: 
Date: Mon, 22 Nov 2010 18:01:23 +0300
From: Alexander Gordeev <lasaine@lvk.cs.msu.su>
To: Rodolfo Giometti <giometti@enneenne.com>
Cc: linux-kernel@vger.kernel.org, "Nikita V. Youshchenko" <yoush@cs.msu.su>,
        linuxpps@ml.enneenne.com, Greg Kroah-Hartman <gregkh@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>
Subject: Re: [PATCHv4 05/17] pps: access pps device by direct pointer
Message-ID: <20101122180123.03690b6d@desktopvm.lvknet>
In-Reply-To: <20101121082658.GL13356@enneenne.com>
References: <cover.1290087473.git.lasaine@lvk.cs.msu.su>
	<57dad12253191b67a6a08bb9c464bd54e70e52a3.1290087479.git.lasaine@lvk.cs.msu.su>
	<20101120154416.GX13356@enneenne.com>
	<20101121013327.01bc9a86@apollo.gnet>
	<20101121082658.GL13356@enneenne.com>
Organization: LVK
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA256;
 boundary="Sig_/kQ081pVvdb.9VCUwGASYvHV"; protocol="application/pgp-signature"
X-AV-Checked: ClamAV using ClamSMTP
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/kQ081pVvdb.9VCUwGASYvHV
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

=D0=92 Sun, 21 Nov 2010 09:26:58 +0100
Rodolfo Giometti <giometti@enneenne.com> =D0=BF=D0=B8=D1=88=D0=B5=D1=82:

> On Sun, Nov 21, 2010 at 01:33:27AM +0300, Alexander Gordeev wrote:
> > > > -	if (ret < 0) {
> > > > +	if (pps =3D=3D NULL) {
> > > >  		pr_err("cannot register PPS source \"%s\"\n", info.path);
> > > > -		return ret;
> > > > +		return -ENOMEM;
> > > >  	}
> > > > -	tty->disc_data =3D (void *)(long)ret;
> > > > +
> > > > +	spin_lock_irq(&pps_ldisc_lock);
> > > > +	tty->disc_data =3D pps;
> > > > +	spin_unlock_irq(&pps_ldisc_lock);
> > >=20
> > > Maybe this lock is useless... however, are we sure that before setting
> > > tty->disc_data to pps its value is null? Otherwise the dcd_change may
> > > be called with an oops! We cannot control serial port IRQ
> > > generation... :-/
> >=20
> > No, locking here is necessary.
> > There is only one problem this spinlock protects us from: current tty
> > code neither disables interrupts nor doesn't ensure there are no
> > references to PPS ldisc from uart_handle_dcd_change() before closing it
> > (and removing PPS source). It relies on flushing workqueue and disabling
> > input. It worked good this way until dcd_change() was added which
> > doesn't use workqueues and is called in atomic context so can't lock
> > on mutex.
> >=20
> > Imagine that (on SMP system) uart_handle_dcd_change() could obtain a
> > reference to ldisc and call dcd_change() until actually calling
> > pps_event(); then on another processor all the path from
> > tty_ldisc_halt() until tty_ldisc_stop() is executed. And then
> > pps_event() is called with illegal pps pointer.
> >=20
> > I just thought you are right that disc_data can be set not NULL by
> > another ldisc and it's a problem. But actually I just realised how to
> > fix it completely. :)
> >=20
> > I just have to add a spinlock to tty_struct, lock all the
> > uart_handle_dcd_change() with it and add a "barrier" between
> > tty_ldisc_halt() and tty_ldisc_close() i.e. just that:
> >=20
> > ...
> > spin_lock_irq();
> > spin_unlock_irq();
> > ...
> >=20
> > This "barrier" will ensure that there is no references to ldisc from
> > uart_handle_dcd_change(). It won't be able to obtain a new reference
> > after tty_ldisc_halt() so will become completely sane. Not disabling
> > interrupts won't be a problem because it won't be able to obtain an
> > ldisc reference until tty_ldisc_enable() which is called only after the
> > new ldisc is fully functional. If it's our ldisc than it will have both
> > dcd_change defined and a valid pps pointer. If it's not our ldisc it
> > won't have both so uart_handle_dcd_change() won't call dcd_change() at
> > all.
> >=20
> > I think I'll do that as a separate patch.
>=20
> Excuse me but IMHO you should solve all your problems if you do the lock =
into
> pps_tty_init/cleanup instead of into pps_tty_open/close.
>=20
>    spin_lock_irq();
>            err =3D tty_register_ldisc(N_PPS, &pps_ldisc_ops);
>            if (err)
>                    pr_err("can't register PPS line discipline\n");
>            else
>                    pr_info("PPS line discipline registered\n");
>    spin_unlock_irq();
>=20
> And the same into cleanup.

Sorry, I don't understand how this is supposed to help. Anyway, a new
patch is underway.

--=20
  Alexander

--Sig_/kQ081pVvdb.9VCUwGASYvHV
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBCAAGBQJM6oXEAAoJEElrwznyooJbT90H/jYjmidzmYDW0m6fL0LB//Ol
xUjn2xfFti7C7hu6UeNxrhBtF9bbtbBOa5WKNIwpPWlwQFaUJod6kXgQV5p9R0m1
J2q8AN7OW9+IFUpCZNnUpntcapYKCMd76sThMz6fY+qxwnXc5HIrLy62Q7+SHu4y
B9qf6XPUvBhNXGxBk3voz4KpJs79qzptvH+f+oGKaljpX0bXI6OFC9gWOX9RJhHe
CiH9gG8SGPf3zpkP6vHyATI/b0y5GzcdAfhds7EHxQGNPLxu1l0k1YOtLdzwCDir
V+nd0bRt93ByB3imSsCuDwrDK4LfEMrQ4V75Gu1Awb9agic2eJLhERuHXiND1kI=
=f/QJ
-----END PGP SIGNATURE-----

--Sig_/kQ081pVvdb.9VCUwGASYvHV--
