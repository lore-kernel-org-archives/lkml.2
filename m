Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755691Ab0KXWif (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 17:38:35 -0500
Received: from gate.lvk.cs.msu.su ([158.250.17.1]:44688 "EHLO
	mail.lvk.cs.msu.su" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752227Ab0KXWie (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 17:38:34 -0500
X-Spam-ASN: 
Date: Thu, 25 Nov 2010 01:38:12 +0300
From: Alexander Gordeev <lasaine@lvk.cs.msu.su>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org, "Nikita V\. Youshchenko" <yoush@cs.msu.su>,
        linuxpps@ml.enneenne.com, Rodolfo Giometti <giometti@enneenne.com>,
        Greg Kroah-Hartman <gregkh@suse.de>, Arnd Bergmann <arnd@arndb.de>,
        Al Viro <viro@zeniv.linux.org.uk>, Nick Piggin <npiggin@kernel.dk>,
        "Alan \"I must be out of my tree\" Cox" <alan@linux.intel.com>,
        Jason Wessel <jason.wessel@windriver.com>,
        Philippe Langlais <philippe.langlais@stericsson.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCHv5 05/17] tty: don't allow ldisc dcd_change() after ldisc
 halt
Message-ID: <20101125013812.0dc828ad@tornado.gnet>
In-Reply-To: <20101124164329.75368d71@lxorguk.ukuu.org.uk>
References: <cover.1290599843.git.lasaine@lvk.cs.msu.su>
	<48e935cac42ae455e2ef8fc45f7eef7631eece6b.1290599844.git.lasaine@lvk.cs.msu.su>
	<20101124164329.75368d71@lxorguk.ukuu.org.uk>
Organization: LVK
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA256;
 boundary="Sig_/lmq.G5t7zRcFeD7RE3ZRdmC"; protocol="application/pgp-signature"
X-AV-Checked: ClamAV using ClamSMTP
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/lmq.G5t7zRcFeD7RE3ZRdmC
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

=D0=92 Wed, 24 Nov 2010 16:43:29 +0000
Alan Cox <alan@lxorguk.ukuu.org.uk> =D0=BF=D0=B8=D1=88=D0=B5=D1=82:

> On Wed, 24 Nov 2010 19:15:43 +0300
> Alexander Gordeev <lasaine@lvk.cs.msu.su> wrote:
>=20
> > There was a possibility that uart_handle_dcd_change() could obtain a
> > reference to ldisc while running in parallel with tty_set_ldisc() on
> > different CPU but call dcd_change() operation after
> > tty_ldisc_close() which is incorrect.
>=20
> How can this occur ?
>=20
>=20
> > +	spin_lock_irqsave(&tty->dcd_change_lock, flags);
> > +
> > +	ld =3D tty_ldisc_ref(tty);
>=20
> What is the expecting lock ordering rule here ?
>=20
>=20
>=20
> I don't see why this patch is needed. You've got an ldisc ref from
> tty_ldisc_ref, until you drop that ldisc ref you are fine. If for some
> reason that is not the case then there is a bug in the ldisc code.

Yes, indeed, it's a bug. Please consider the following example:

     CPU1                                      CPU2
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D
uart_handle_dcd_change() {		tty_set_ldisc() {
  ld =3D tty_ldisc_ref(...)			  ...
  ...					  tty_ldisc_halt(...)
  ...					  ...
  ...					  tty_ldisc_close(...)
  if (ld && ld->ops->dcd_change)	  ...
    ld->ops->dcd_change(...);		  ...
  ...					  tty_ldisc_open(...)
}					}

I think that semantically ldisc ops should never be called before open
or after close. This situation is possible because tty_ldisc_halt() only
ensures that no more references are taken. This is ok for everything
except dcd_change() because it cleans up workqueue and doesn't accept
any more data. dcd_change() is a different story because it doesn't use
workqueues.

I think tty code is exactly the right place to fix this bug; this is
what my patch is for.

--=20
  Alexander

--Sig_/lmq.G5t7zRcFeD7RE3ZRdmC
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBCAAGBQJM7ZPUAAoJEElrwznyooJb7EQH/0whH/4r4XnvZGPySTYD+VRv
jGctZ5BIpcDEfISL8/shfRny2pt+zzBDZp8U6o7USO7y+J7XtCj6neqqABPdQ6YQ
CiDhqKVm3XdXVQUrKjmDm686WC9i1d1h+6/whiomQd2dyJqAtc+CVwDCPWd+iqRd
wv0ESBxm/P6Kry4br3LLhUIGn40OsTdIuVj0YRcHhMfqg8sdz1tNRYEfP6LWNoiM
4o+0BQwFwoQYFxtz6zLWcArExoEwM6T9r9QPaOGVkqfWClDmzWqjJOlbr+Wsc+fJ
jxQy3jHJK9BN0MdR40my5/tVbkdRy1ST5W5w+L+6wcYhL908Zos2ryhxVyAA5YU=
=9SqJ
-----END PGP SIGNATURE-----

--Sig_/lmq.G5t7zRcFeD7RE3ZRdmC--
