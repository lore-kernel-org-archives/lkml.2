Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760087Ab0HEKUH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 06:20:07 -0400
Received: from gate.lvk.cs.msu.su ([158.250.17.1]:59187 "EHLO
	mail.lvk.cs.msu.su" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752995Ab0HEKUA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 06:20:00 -0400
X-Spam-ASN: 
Date: Thu, 5 Aug 2010 14:19:51 +0400
From: Alexander Gordeev <lasaine@lvk.cs.msu.su>
To: Vitezslav Samel <vitezslav@samel.cz>
Cc: linux-kernel@vger.kernel.org, "Nikita V. Youshchenko" <yoush@cs.msu.su>,
        linuxpps@ml.enneenne.com, Rodolfo Giometti <giometti@enneenne.com>,
        john stultz <johnstul@us.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        Joonwoo Park <joonwpark81@gmail.com>
Subject: Re: [PATCHv3 03/16] pps: fix race in PPS_FETCH handler
Message-ID: <20100805141951.2cce9490@desktopvm.lvknet>
In-Reply-To: <20100805051929.GA14413@pc11.op.pod.cz>
References: <cover.1280952801.git.lasaine@lvk.cs.msu.su>
	<033148d225d9e4929fcc02ed8de0fcfa3637cffe.1280952801.git.lasaine@lvk.cs.msu.su>
	<20100805051929.GA14413@pc11.op.pod.cz>
Organization: LVK
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA256;
 boundary="Sig_/xOAAmwDBGFir88wDEbDw3LY"; protocol="application/pgp-signature"
X-AV-Checked: ClamAV using ClamSMTP
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/xOAAmwDBGFir88wDEbDw3LY
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi Vitezslav,

=D0=92 Thu, 5 Aug 2010 07:19:29 +0200
Vitezslav Samel <vitezslav@samel.cz> =D0=BF=D0=B8=D1=88=D0=B5=D1=82:

> On Thu, Aug 05, 2010 at 01:06:40AM +0400, Alexander Gordeev wrote:
> > There was a race in PPS_FETCH ioctl handler when several processes want
> > to obtain PPS data simultaneously using sleeping PPS_FETCH. They all
> > sleep most of the time in the system call.
> > With the old approach when the first process waiting on the pps queue
> > is waken up it makes new system call right away and zeroes pps->go. So
> > other processes continue to sleep. This is a clear race condition
> > because of the global 'go' variable.
> > With the new approach pps->last_ev holds some value increasing at each
> > PPS event. PPS_FETCH ioctl handler saves current value to the local
> > variable at the very beginning so it can safely check that there is a
> > new event by just comparing both variables.
> >=20
> > Signed-off-by: Alexander Gordeev <lasaine@lvk.cs.msu.su>
> > ---
> >  drivers/pps/kapi.c         |    4 ++--
> >  drivers/pps/pps.c          |   10 +++++++---
> >  include/linux/pps_kernel.h |    2 +-
> >  3 files changed, 10 insertions(+), 6 deletions(-)
> >=20
> > diff --git a/drivers/pps/kapi.c b/drivers/pps/kapi.c
> > index 55f3961..3f89f5e 100644
> > --- a/drivers/pps/kapi.c
> > +++ b/drivers/pps/kapi.c
> > @@ -326,8 +326,8 @@ void pps_event(int source, struct pps_ktime *ts, in=
t event, void *data)
> > =20
> >  	/* Wake up if captured something */
> >  	if (captured) {
> > -		pps->go =3D ~0;
> > -		wake_up_interruptible(&pps->queue);
> > +		pps->last_ev++;
> > +		wake_up_interruptible_all(&pps->queue);
>=20
>   What happens if pps->last_ev overflows? Seems to me it would freeze
> pps.

Yes, it will freeze the fds (if they don't use timeouts). But in normal
circumstances, i.e. when pps_event is called twice a second, it will
overflow after ~68 years of uninterrupted work. Well, it's the same
kind of problem as an overflow of struct timespec. I thought it's not
actually a problem. Should I use u64 instead of unsigned int or add a
runtime check somewhere?

--=20
  Alexander

--Sig_/xOAAmwDBGFir88wDEbDw3LY
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iQEcBAEBCAAGBQJMWpBHAAoJEElrwznyooJbC6EH/jkb0IGYAMlwF1zTq13EWhfF
V1Zm2Klx8tOx55yY5C2NRvrBnLb3gdRqpGCmyDu1dcq5qTQVVj9boxOcsSRaYJch
WY/9YBZKI3hAeQxu83Rbmc+VEUBZZJtHq+9l6GOP2vmQ+39QaqHclAtm7C2QHf0u
LTrUqvWElOTCjfwg5n98zYoGUhd3k8fDlehY2X5bNqhQ222rIn2cszMxyN0r5QuT
ae70dMZCYz6TqaMuznO6YiiVcmgYtpaZPSpqMk6CtmJfSqJYGCHlD9ubEGZpQJYx
iERf0Yqcibsff2Uz0S3uB8RxNNJ8tvxY8PB5cRutyxY6tUjHyqz+6n1T9+2qYPo=
=ymnn
-----END PGP SIGNATURE-----

--Sig_/xOAAmwDBGFir88wDEbDw3LY--
