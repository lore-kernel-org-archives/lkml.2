Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756630Ab1JQXGg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 19:06:36 -0400
Received: from cantor2.suse.de ([195.135.220.15]:58881 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754524Ab1JQXGe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 19:06:34 -0400
Date: Tue, 18 Oct 2011 10:06:20 +1100
From: NeilBrown <neilb@suse.de>
To: John Stultz <john.stultz@linaro.org>
Cc: Alan Stern <stern@rowland.harvard.edu>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux PM list <linux-pm@vger.kernel.org>,
        mark gross <markgross@thegnar.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH 2/2] PM / Sleep: Introduce cooperative
 suspend/hibernate mode
Message-ID: <20111018100620.6334eb1d@notabene.brown>
In-Reply-To: <1318887801.3125.122.camel@work-vm>
References: <Pine.LNX.4.44L0.1110171417070.1749-100000@iolanthe.rowland.org>
	<1318878529.3125.80.camel@work-vm>
	<20111018081948.7f354fc6@notabene.brown>
	<1318887801.3125.122.camel@work-vm>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.22.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/xy+IggH2DsN8as2NRUY=STk"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/xy+IggH2DsN8as2NRUY=STk
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 17 Oct 2011 14:43:21 -0700 John Stultz <john.stultz@linaro.org> wro=
te:

> On Tue, 2011-10-18 at 08:19 +1100, NeilBrown wrote:
> > On Mon, 17 Oct 2011 12:08:49 -0700 John Stultz <john.stultz@linaro.org>=
 wrote:

> > Here I see you probably meant "efficient".  Can that be quantified?  Do=
 you
> > have a target latency for getting into suspend, and measurements that s=
how
> > you regularly missing this target?
> > I am reminded of what Donald Knuth reportedly said about premature
> > optimisation.
>=20
> That is a fair point. I think the Android guys have better sense of the
> specifics for suspend latency that they use. But just to get a sense of
> it, on one Android board I've used, the system resumes and suspends for
> each keystroke over the serial line.

Cool!

>=20
> >> There is a userland PM daemon. Its responsible for both suspending the
> > > system, *and* handing all wakeup events.
> > >=20
> > > Normal wakeup consumers open wakeup devices with a special library wh=
ich
> > > passes the open request through the PM daemon. The PM daemon opens the
> > > device and provides a pipe fd back to the application, and basically
> > > acts as a middle-man.
> >=20
> > There is certainly merit in the idea but I think the pipes just get in =
the
> > way.
> >=20
> > How about having both the PM daemon and the application listening on th=
e same
> > FD.  The app sends the FD to the PM daemon on the same Unix domain sock=
et
> > which is used to request suspend/resume handshaking.
> >=20
> > The PM daemon never reads from the FD.  It only passes it to
> > poll/select/whatever.
> >=20
> > When poll says  the FD is ready, the daemon initiated the handshake wit=
h the
> > app to make sure that it has consumed the event.  If none of the FDs are
> > ready for read and no process is blocking suspend, then the daemon is f=
ree to
> > enter suspend.
>=20
> So this is starting to sound pretty interesting!
>=20
> I think you can drop the handshaking on suspend as well, because you can
> consider the read() on the application side to mark that the event is
> consumed. The application can flag to the pm daemon to inhibit suspend
> after a select, but prior to reading.
>=20
> Does that make sense to you?
>=20
> This would both avoid the extra context switching to pass the event
> over, and avoids the need to schedule everyone before suspending.=20

I'm not sure if you are saying something different to me or not.

In my proposal we do avoid the handshake and context switch unless the fd is
readable when the daemon tries to suspend - and that should be the uncommon
case.
Avoiding some handshake is not possible when the fd is readable.
You could still have an implicit handshake were the daemon knows the app
hasn't handled the event yet because it hasn't read, and the app gets a
stay-awake lock before reading.  However
1/ there is still a handshake and probably a context switch - it is just
   less explicit
2/ the server needs to wait for "fd is not readable" and we don't have an
   interface for that.
   I guess the server could assume that if an fd is readable, then a
   stay-awake request will be made, so it waits for the stay-awake request.
   That feels a little bit fragile, but it might work and it could end up
   being a little more efficient - it would need careful analysis and proba=
bly
   some experimentation to be sure.

So yes - maybe it makes sense, but it needs a concrete implementation to
provide proper review.

NeilBrown

--Sig_/xy+IggH2DsN8as2NRUY=STk
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTpy09Dnsnt1WYoG5AQJCXw//Uujo/08tq2TVqgAnflk0+cL1F06AnEhb
puGT0LASHWr6SFfmpBopoXLYEImBLJf0To5EcuGU3GNaQxs0PpZqaCicW06vTLIp
MBasTfGJ/Vqn6BxQ4U+/ENmxgYPuG7hlLwSdj1euISDk4b/q9R7TQVTX2uIn+U22
5UnfZjFfB5xcKM7kyTdXtiFivUjGiwe86iTd3A48ieCKLvq5R4DzRC3JaKQe6dlR
FgRcrzNgrbD/ptEbWzEomvOqSyHlH72wXy6JL9Mq45+T58MhfSR3YF0WUnEMsREc
/XH6jAi0dMCtU6YF1qLeyX6Ejac29RjucOWAbxRCcLxrOEIZxvVTCkX2cESnjfze
rZvGPFAwwoL93nFhKZ8tsJ4Ok3CQ3zNRN8Jo4WrZHT5dbGIfxzGe3dX9U7ghEOwB
6jdmvhmgIKMW6RROSqP2t51iDfHz5/mAeyxdV8y+2ZKXD/LZHsKvGhXca7zTLjjx
PGA9VQ3B0GLfhtkRE22WB/ZolHKSAZ34ykuoYpqg1zv3kqIGI8noen8FZnI70P/Z
Gpg6WCm6iU//PVhVurY+1J8Pa9etBX9ECeojiEP1haGMXDiR7uAFBHxMOyigQtvc
5rb7c+iQ6pXcfRLFXmDJ1EQJ5/Xu0xqUo6jxk3M1NdYhMFks5TikzH3fG0lsKYot
3/miBCmaGEQ=
=T7V+
-----END PGP SIGNATURE-----

--Sig_/xy+IggH2DsN8as2NRUY=STk--
