Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756568Ab0CVVh4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 17:37:56 -0400
Received: from gate.lvk.cs.msu.su ([158.250.17.1]:52716 "EHLO
	mail.lvk.cs.msu.su" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756482Ab0CVVhy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 17:37:54 -0400
X-Spam-ASN: 
Date: Tue, 23 Mar 2010 00:37:47 +0300
From: Alexander Gordeev <lasaine@lvk.cs.msu.su>
To: john stultz <johnstul@us.ibm.com>
Cc: linux-kernel@vger.kernel.org, linuxpps@ml.enneenne.com,
       "Nikita V. Youshchenko" <yoush@cs.msu.su>, stas@lvk.cs.msu.su,
       Rodolfo Giometti <giometti@enneenne.com>
Subject: Re: [PATCHv2 0/6] pps: time synchronization over LPT
Message-ID: <20100323003747.35ea417a@tornado.gnet>
In-Reply-To: <1269291710.3283.11.camel@localhost.localdomain>
References: <cover.1267008049.git.lasaine@lvk.cs.msu.su>
	<1f1b08da1003081925p61a810e4v96be56640287d61@mail.gmail.com>
	<20100322234201.73ffc06a@tornado.gnet>
	<1269291710.3283.11.camel@localhost.localdomain>
Organization: LVK
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA256;
 boundary="Sig_/RAQ+6UlVCFwCC8B0k/Ci0zw"; protocol="application/pgp-signature"
X-AV-Checked: ClamAV using ClamSMTP
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/RAQ+6UlVCFwCC8B0k/Ci0zw
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

=D0=92 Mon, 22 Mar 2010 14:01:50 -0700
john stultz <johnstul@us.ibm.com> =D0=BF=D0=B8=D1=88=D0=B5=D1=82:

> On Mon, 2010-03-22 at 23:42 +0300, Alexander Gordeev wrote:
> > Hi John,
> >=20
> > Sorry for the delay...
> >=20
> > =D0=92 Mon, 8 Mar 2010 19:25:07 -0800
> > john stultz <johnstul@us.ibm.com> =D0=BF=D0=B8=D1=88=D0=B5=D1=82:
> >=20
> > > On Wed, Feb 24, 2010 at 4:28 AM, Alexander Gordeev
> > > <lasaine@lvk.cs.msu.su> wrote:
> > > > This patchset is tested against the vanilla 2.6.32.9 kernel.
> > > > But we are actually using it on 2.6.31.12-rt20 rt-preempt
> > > > kernel most of the time. Also there is a version which should
> > > > be applied on top of LinuxPPS out of tree patches (i.e. all
> > > > clients and low-level irq timestamps stuff). Those who are
> > > > interested in other versions of the patchset can find them in
> > > > my git repository:
> > > > http://lvk.cs.msu.su/~lasaine/timesync/linux-2.6-timesync.git
> > > >
> > > > There is one problem however: hardpps() works bad when used on
> > > > top of 2.6.33-rc* with CONFIG_NO_HZ enabled. The reason for
> > > > this is commit a092ff0f90cae22b2ac8028ecd2c6f6c1a9e4601.
> > > > Without it hardpps() is able to sync to 1us precision in about
> > > > 10 seconds. With it
> > >=20
> > > Uh. Not sure I see right off why the logarithmic time accumulation
> > > would give you troubles. Its actually there to try to fix a
> > > couple of NTP issues that cropped up when the accumulation
> > > interval was pushed out to 2HZ with CONFIG_NO_HZ.
> >=20
> > Yes, I know. I guess (based on the commit log and other sources)
> > that this change was added to make chrony work better on tickless
> > kernel. So chrony corrects the time using only frequency
> > corrections?
>=20
> I'm not super familiar with chrony, but from talking with folks who
> work on it, it doesn't use the doesn't use the kernel pll, and
> instead uses old oneshot mode.=20
>=20
> So yea, the logarithmic accumulation did help chrony as well as other
> users of adjtimex that expected to be able to make HZ granular
> adjustments.=20
>=20
>=20
> > My approach is different: use time_offset t remove the phase error
> > and adjust time_freq to remove frequency error.
>=20
> This sounds much closer to how NTP does it.
> So are you using the kernel PLL? or just singleshot for the offset?

It's very close a singleshot adjustment, but it uses time_offset instead
of time_adjust. This code does the trick:

static inline s64 ntp_offset_chunk(s64 offset)
{
	if (time_status & STA_PPSTIME && time_status & STA_PPSSIGNAL)
		return offset;
	else
		return shift_right(offset, SHIFT_PLL + time_constant);
}

So when kernel consumer is active, the whole time_offset is applied
immediately.

> > > Do you have any extra insight here as to whats going on with your
> > > code?   The only thing I could guess would be second_overflow() is
> > > happening closer to the actual overflow, but maybe less
> > > regularly? But again, I'm not sure how this would be drastically
> > > different then before with the 2HZ accumulation period.
> >=20
> > I still can't find this out (partially because I'm too busy with
> > other tasks). The new code seems ok to mee. time_offset is added at
> > second_overflow as usual. Maybe the problem is with the frequency
> > correction. I'm going to run some tests that should show where the
> > problem is: in the phase or freq correction.
>=20
> Yea, you can play with things on the kernel side by setting
> NTP_INTERVAL_FREQ to 2 in include/linux/timex.h to move back to the
> coarser granularity (while preserving the logarithmic accumulation).

Great, thanks for the point! Didn't think of it.

> Do let me know if you find anything here.

Sure!

--=20
  Alexander

--Sig_/RAQ+6UlVCFwCC8B0k/Ci0zw
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBCAAGBQJLp+MrAAoJEElrwznyooJbE8AH/RYLPpLUHMwu1eU8kHibgLKU
IUSW0uOLDHqmAB0Id1Pzf6atcHHkOo3vm5uoKKM0bQ41xH3FpJsSGPULBrwqGDjk
g5jDMdhyM1VTu1BWg5LsTJzOVLX74K8nVjya+8WWYL4f4q2NwxWGKLQ5CwtO8VRD
1ER3kuR0/hl0yat+89/06S/AU9SsOsWltUdqDeHregJiVrF0d9w5KX8TQWRi5dzo
i9lzDwP4z/atuN1eJkx0hS0nIjJyPy+HaPdsN33R0aJK5yluqQtaltofTjpaTp9A
jrBj4ayH3kbtstZMNdJSM98WUAVFZdgPk4ohWx8BN7dbOdKIKSY1L9n80t6dKb4=
=CSNZ
-----END PGP SIGNATURE-----

--Sig_/RAQ+6UlVCFwCC8B0k/Ci0zw--
