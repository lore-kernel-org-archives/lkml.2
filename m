Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756827Ab1JQXgk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 19:36:40 -0400
Received: from cantor2.suse.de ([195.135.220.15]:59750 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751106Ab1JQXgi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 19:36:38 -0400
Date: Tue, 18 Oct 2011 10:36:31 +1100
From: NeilBrown <neilb@suse.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux PM list <linux-pm@vger.kernel.org>,
        mark gross <markgross@thegnar.org>,
        LKML <linux-kernel@vger.kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [RFC][PATCH 0/2] PM / Sleep: Extended control of
 suspend/hibernate interfaces
Message-ID: <20111018103631.6943a97a@notabene.brown>
In-Reply-To: <201110180002.30932.rjw@sisk.pl>
References: <201110132145.42270.rjw@sisk.pl>
	<201110160010.40639.rjw@sisk.pl>
	<20111017104827.52a90114@notabene.brown>
	<201110180002.30932.rjw@sisk.pl>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.22.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/ktZ.zXLGi5OT06u77BdegUx"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/ktZ.zXLGi5OT06u77BdegUx
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 18 Oct 2011 00:02:30 +0200 "Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> On Monday, October 17, 2011, NeilBrown wrote:
> > On Sun, 16 Oct 2011 00:10:40 +0200 "Rafael J. Wysocki" <rjw@sisk.pl> wr=
ote:
> ...
> > >=20
> > > >  But I think it is very wrong to put some hack in the kernel like y=
our
> > > >    suspend_mode =3D disabled
> > >=20
> > > Why is it wrong and why do you think it is a "hack"?
> >=20
> > I think it is a "hack" because it is addressing a specific complaint ra=
ther
> > than fixing a real problem.
>=20
> I wonder why you think that there's no real problem here.
>=20
> The problem I see is that multiple processes can use the suspend/hibernate
> interfaces pretty much at the same time (not exactly in parallel, becuase
> there's some locking in there, but very well there may be two different
> processes operating /sys/power/state independently of each other), while
> the /sys/power/wakeup_count interface was designed with the assumption th=
at
> there will be only one such process in mind.

Multiple process can write to your mail box at the same time.  But some how
they don't.  This isn't because the kernel enforces anything, but because a=
ll
the relevant programs have an agreed protocol by which they arbitrate acces=
s.
One upon a time this involved creating a lock file with O_CREAT|O_EXCL.
These days it is fcntl locking.  But it is still advisory.

In the same way - we stop multiple processes from suspending/hibernating at
the same time by having an agreed protocol by which they share access to the
resource.  The kernel does not need to be explicitly involved in this.

...

> > > Well, I used to think that it's better to do things in user space.  H=
ence,
> > > the hibernate user space interface that's used by many people.  And my
> > > experience with that particular thing made me think that doing things=
 in
> > > the kernel may actually work better, even if they _can_ be done in us=
er space.
> > >=20
> > > Obviously, that doesn't apply to everything, but sometimes it simply =
is worth
> > > discussing (if not trying).  If it doesn't work out, then fine, let's=
 do it
> > > differently, but I'm really not taking the "this should be done in us=
er space"
> > > argument at face value any more.  Sorry about that.
> >=20
> > :-)  I have had similar mixed experiences.   Sometimes it can be a lot =
easier
> > to get things working if it is all in the kernel.
> > But I think that doing things in user-space leads to a lot more flexibi=
lity.
> > Once you have the interfaces and designs worked out you can then start =
doing
> > more interesting things and experimenting with ideas more easily.
> >=20
> > In this case, I think the *only* barrier to a simple solution in user-s=
pace
> > is the pre-existing software that uses the 'old' kernel interface.  It =
seems
> > that interfacing with that is as easy as adding a script or two to pm-u=
tils.
>=20
> Well, assuming that we're only going to address the systems that use PM u=
tils.

I suspect (and claim without proof :-) that any system will have some single
user-space thing that is responsible for initiating suspend.
Every time I look at one I see a whole host of things that need to be done
just before suspend, and other things just after resume.
They used to be in /etc/apm/event.d.  Now there are
in /usr/lib/pm-utils/sleep.d.  I think they were in /etc/acpid once.
I've seen one thing that uses shared-library modules instead of shell scrip=
ts
on the basis that it avoids forking and goes fast (and it probably does).
But I doubt there is any interesting system where writing to /sys/power/sta=
te
is the *only* thing you need to do for a clean suspend.
So all systems will have some user-space infrastructure to support suspend,
and we just need to hook in to that.


>=20
> > With that problem solved, experimenting is much easier in user-space th=
an in
> > the kernel.
>=20
> Somehow, I'm not exactly sure if we should throw all kernel-based solutio=
ns away
> just yet.

My rule-of-thumb is that we should reserve kernel space for when
  a/ it cannot be done in user space
  b/ it cannot be done efficient in user space
  c/ it cannot be done securely in user space

I don't think any of those have been demonstrated yet.  If/when they are it
would be good to get those kernel-based solutions out of the draw (so yes:
keep them out of the rubbish bin).

So I'd respond with "I'm not at all sure that we should throw away an
all-userspace solution just yet".  Particularly because many of us seem to
still be working to understand what all the issues really are.

NeilBrown


--Sig_/ktZ.zXLGi5OT06u77BdegUx
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTpy7/znsnt1WYoG5AQLm2Q/8CuX5fCkLv2o77EKEMV/A85m2zpXk+rFd
Z7zBOA1kbysPUm6bUy4LGtKRw9HIRLylLJyYF3jW+rGcax0DAVxmbsMFB5NYqEJ7
v9XNLAB4oM+NvKX8t5j49sdQdXPsUNjSi5xz4DyMgA5hNVQBKE+BVVEN2nEt5h6+
MQsZQ9i9cz58DidpK2ui1RmPbd7q4xNJRAba2pCd80VqZzrMdQnFie9BUN2B8o9q
rhHNYkdlw1fMcop9o/CMu991dTIo3Gks9/NXXeNTcpct10Gw9DLN4xeOf1kWWfZc
eowWIu78wiS+PCI9Xpx2b++p9XzacVNdp9z9t3yE1fPQERQMe+OOzMcchyeeStMS
ojUqDvPpCwHSnUjdyrYiZUUZQCkRdpMZboWllyq8EGT3YLt5z33BPYzcFmbU7/Sj
8mulVjQwHg7pCEFDEjUGa14sQpDLA5zIaUoM+Qz4PR0R8Grq8WeRjpeKGeevRCO2
umpNP/3L/NSJnisF1tdQmZPyxFhM9w5Ct1UOnCQE97wfffNooty3VUly8QbrvlMQ
OrGJj5OLykwSRk5XljUHH5eT+oGRG4EbYaxv3+fX3FS9cYd0fJY/tuDYepqQ/dIS
usVWb29l/pRQqxkH0rhm8Qqg2kBVXr//75yTJjsGxkHmgJPCoBrS2LGRGP33Zqb9
ZVCJfy22O/8=
=DZh3
-----END PGP SIGNATURE-----

--Sig_/ktZ.zXLGi5OT06u77BdegUx--
