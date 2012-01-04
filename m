Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755636Ab2ADBU5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jan 2012 20:20:57 -0500
Received: from cantor2.suse.de ([195.135.220.15]:45809 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754125Ab2ADBUz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jan 2012 20:20:55 -0500
Date: Wed, 4 Jan 2012 12:20:40 +1100
From: NeilBrown <neilb@suse.de>
To: John Stultz <john.stultz@linaro.org>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Sander Eikelenboom <linux@eikelenboom.it>, stefan.bader@canonical.com,
        rjw@sisk.pl, Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org
Subject: Re: Regression: ONE CPU fails bootup at Re: [3.2.0-RC7] BUG: unable
 to handle kernel NULL pointer dereference at 0000000000000598 [   
 1.478005] IP: [<ffffffff8107a6c4>] queue_work_on+0x4/0x30
Message-ID: <20120104122040.5a0fa6a3@notabene.brown>
In-Reply-To: <1325638380.3037.69.camel@work-vm>
References: <1599287628.20120103171351@eikelenboom.it>
	<20120103190754.GA27651@phenom.dumpdata.com>
	<1325632188.3037.59.camel@work-vm>
	<20120104113155.27bf6e46@notabene.brown>
	<1325638380.3037.69.camel@work-vm>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/F9IINQDRN2H/ZM.sJw1r4gA"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/F9IINQDRN2H/ZM.sJw1r4gA
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 03 Jan 2012 16:53:00 -0800 John Stultz <john.stultz@linaro.org> wro=
te:

> On Wed, 2012-01-04 at 11:31 +1100, NeilBrown wrote:
> > On Tue, 03 Jan 2012 15:09:48 -0800 John Stultz <john.stultz@linaro.org>=
 wrote:
> > > >From the stack trace, we've kicked off a rtc_timer_do_work, probably
> > > from the rtc_initialize_alarm() schedule_work call added in Neil's
> > > patch.  From there, we call __rtc_set_alarm -> cmos_set_alarm ->
> > > cmos_rq_disable -> cmos_checkintr -> rtc_update_irq -> schedule_work.
> > >=20
> > > So, what it looks to me is that in cmos_checkintr, we grab the cmos->=
rtc
> > > and pass that along. Unfortunately, since the cmos->rtc value isn't s=
et
> > > until after rtc_device_register() returns its null at that point. So
> > > your patch isn't really fixing the issue, but just reducing the race
> > > window for the second cpu to schedule the work.
> > >=20
> > > Sigh. I'd guess dropping the schedule_work call from
> > > rtc_initialize_alarm() is the right approach (see below). When review=
ing
> > > Neil's patch it seemed like a good idea there, but it seems off to me
> > > now.
> > >=20
> > > Neil, any thoughts on the following? Can you expand on the condition =
you
> > > were worried about in around that call?
> >=20
> > If you set an alarm in the future, then shutdown and boot again after t=
hat
> > time, then you will end up with a timer_queue node which is in the past.
>=20
> Thanks for explaining this again.
>=20
> Hrm. It seems the easy answer is to simply not add alarms that are in
> the past.  Further, I'm a bit perplexed, as if they are in the past, the
> enabled flag shouldn't be set.   __rtc_read_alarm() does check the
> current time, so maybe we can make sure we don't return old values? I
> guess I assumed __rtc_read_alarm() avoided returning stale values, but
> apparently not.

That would probably be a more robust approach.  Also it might make sense to
clean out old alarms whenever we are about to add a new one.

>=20
> > When this happens the queue gets stuck.  That entry-in-the-past won't g=
et
> > removed until and interrupt happens and an interrupt won't happen becau=
se the
> > RTC only triggers an interrupt when the alarm is "now".
> >=20
> > So you'll find that e.g. "hwclock" will always tell you that 'select' t=
imed
> > out.
> >=20
> > So we force the interrupt work to happen at the start just in case.
>=20
> Unfortunately its too early.=20
>=20
> > Did you see my proposed patch which converted those calls to do the work
> > in-process rather than passing it to a worker-thread?  I think that is a
> > clean fix.
>=20
> I don't think I saw it today. Was it from before the holidays?

About 4 hours ago:
  Subject: Re: Patch Upstream: rtc: Expire alarms after the time is set.

>=20
> Even so, at this point, I don't know if we have enough time for testing,
> so I'm thinking we either just drop the problematic sched_work call or
> revert the whole thing and try again for 3.3

I wouldn't object to that.  The bug only triggers in unusual circumstances
and is quite easy to work around so it is safer  to wait until we have a
really good fix.

Thanks,
NeilBrown


>=20
> thanks
> -john
>=20


--Sig_/F9IINQDRN2H/ZM.sJw1r4gA
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTwOpaDnsnt1WYoG5AQKc2RAAngrKjRK2FVip8Q8HFStx3Q/15lVsLHKx
7IFCfh7LbYBGRS/ra4Cp33hvwMTmG8/et5o0WmCW7cXCp0izSL3AKAi9e50xjqKf
gbBHbTRGCYw+DNJYTNzPwko6Znx7/yrPgwW1YQR48qr0G+lrlj4KjugDv1431r9n
GkoCoyuCzye65tY/D3u4nca8RTrcgQnDzIzglxkEebjVqkSZNlDN416YFFSkIIjx
IWEx2PeZ8RxyESKL31kcJLKLnCnsjmvSlv/Z1AzfNagdomKI40wPOVU97JiUxOEu
rbwBX0PNyY3uHimaFxuaHg0nfv+COx5zvpeToR+Tsw2N5lHrShpK9uV7z2nyt7zI
vx9Bonf/h0PuBILEgGT3tl+xepswmSS3uLIJTPFv4joXwLLJ74O73rIlUvdJyIZ5
cwztAhV7Vjwc6V9e0bTJtczj5PglhendxUE7+/FDFLVf0ZMo3DdaJK2oifzboF6s
Klo1E5ulB6024aiHoVpANJ3xvO3/jFq5OXIcVuTTpcdfdd0OdwCqPixJBhWvvNPY
XYn805n+IqWo8s4zqxugAdVgQjYsuAafyUK/yx1zy7o7+kukt138fRWITLazrtqa
NYMpxdJZyJS1cSee1JOlsl5IkzQb+268eoexnMMJrJ8Hpdb9vpmG8aTkPcq9vRtw
xhDSJKqjfzk=
=XCnD
-----END PGP SIGNATURE-----

--Sig_/F9IINQDRN2H/ZM.sJw1r4gA--
