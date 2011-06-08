Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754754Ab1FHI2g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 04:28:36 -0400
Received: from na3sys009aog102.obsmtp.com ([74.125.149.69]:55616 "EHLO
	na3sys009aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752830Ab1FHI2e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 04:28:34 -0400
Date: Wed, 8 Jun 2011 11:28:28 +0300
From: Felipe Balbi <balbi@ti.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Guillaume Chazarain <guichaz@gmail.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, gregkh@suse.de,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Felipe Balbi <balbi@ti.com>, Tejun Heo <tj@kernel.org>
Subject: Re: tty breakage in X (Was: tty vs workqueue oddities)
Message-ID: <20110608082827.GE11187@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1306999045.29297.55.camel@pasglop>
 <1307003821.29297.77.camel@pasglop>
 <20110602110727.7343782b@lxorguk.ukuu.org.uk>
 <1307062574.29297.204.camel@pasglop>
 <1307081874.23876.14.camel@pasglop>
 <1307084189.23876.19.camel@pasglop>
 <BANLkTim6VsynZHLagcu9Xo3EjsUz=54dYA@mail.gmail.com>
 <BANLkTikJJfyo-eExZYN4iZUO+RrkgPmX4A@mail.gmail.com>
 <BANLkTi=fX8dwfZ53O7E4HX-RsL6bQ=hqWQ@mail.gmail.com>
 <BANLkTikt1ZZNC1YffT_bRAX6GwjWDk_T3Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="r7U+bLA8boMOj+mD"
Content-Disposition: inline
In-Reply-To: <BANLkTikt1ZZNC1YffT_bRAX6GwjWDk_T3Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--r7U+bLA8boMOj+mD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Jun 07, 2011 at 07:44:48PM -0700, Linus Torvalds wrote:
> On Mon, Jun 6, 2011 at 7:24 AM, Guillaume Chazarain <guichaz@gmail.com> w=
rote:
> >
> > After reverting http://git.kernel.org/linus/a5660b4 "tty: fix endless
> > work loop when the buffer fills up" I cannot reproduce the hangs on
> > SMP anymore but it brings back the busy loop on UP.
>=20
> Hmm. The n_tty layer has some rather distressing locking, and doesn't
> lock "tty->receive_room" changes at all, for example (and uses
> multiple locks for some other things).
>=20
> It may well be that there is some SMP race there. The n_tty line
> discipline has its own locking for its counts, and the tty buffer code
> has its own locking, and "receive_room" kind o fends up being in the
> middle between them.
>=20
> The sad part is that the patch that made receive_buf() return the
> amout of bytes received was actually trying to do the right thing, it
> just did it entirely in the wrong way (re-introducing the crazy
> re-arming of the workqueue from within itself, and using all the wrong
> sign issues).

yeah sorry about that. I originally wrote that patch over one year ago
and had to send it three times until it was finally noticed. Then I had
to do a quick rebase and things went pretty bad.

Should've checked better and forget about loosing another merge window.

> I'd love to get rid of receive_room entirely - and just letting the
> tty line discipline handler say how much it actually received. in
> other words, having receive_buf() just tell us how much it used, and
> not looking at receive_room in the caller is absolutely the right
> thing.

that was the idea, unfortunately I missed the last part. Sorry about
that.

--=20
balbi

--r7U+bLA8boMOj+mD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJN7zKqAAoJEAv8Txj19kN1/04H/3J3r+uKxCrlWN2bKRVbdw3L
aLI5hZ9xpPUzBqdvG5+RLd3Ecvwlk8M+ICEGpZg6H3Awl7H9jDeObdPl/NK38+Ex
qKokPx68hsvF7CWuSZIgSaKVBc7X++LIvtpc4gtuXzBulxK+82GEg3U+xtAXXk6G
HGQQSf+IdVB4Qe4M5U7LlwlMue1I4M7ocUBXQARzrGQACI/F+srygzL4sCy9c5BT
KzlgzhTs5GZuH031+R0vrLjWWs399PTSnze+lWcQMdPoRb+ztDqBTNpqg9B+Zadp
kvCyO6Cu/hC710EL+cpeLgI880w4cv292SX8iHrLaA7Y2KzfVihdTJ+d0fwZCBg=
=Lw/5
-----END PGP SIGNATURE-----

--r7U+bLA8boMOj+mD--
