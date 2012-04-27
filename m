Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759506Ab2D0AkO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 20:40:14 -0400
Received: from cantor2.suse.de ([195.135.220.15]:49587 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754072Ab2D0AkJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 20:40:09 -0400
Date: Fri, 27 Apr 2012 10:39:59 +1000
From: NeilBrown <neilb@suse.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux PM list <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Magnus Damm <magnus.damm@gmail.com>, markgross@thegnar.org,
        Matthew Garrett <mjg@redhat.com>, Greg KH <gregkh@linuxfoundation.org>,
        Arve =?ISO-8859-1?Q?Hj=F8nnev=E5g?= <arve@android.com>,
        John Stultz <john.stultz@linaro.org>,
        Brian Swetland <swetland@google.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: Re: [RFC][PATCH 6/8] PM / Sleep: Implement opportunistic sleep
Message-ID: <20120427103959.233cf065@notabene.brown>
In-Reply-To: <201204262352.43254.rjw@sisk.pl>
References: <201202070200.55505.rjw@sisk.pl>
	<201204222323.23685.rjw@sisk.pl>
	<20120426130503.7f55415d@notabene.brown>
	<201204262352.43254.rjw@sisk.pl>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/zZ8/HSS8aFl7XD6NDGYz0+Z"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/zZ8/HSS8aFl7XD6NDGYz0+Z
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Thu, 26 Apr 2012 23:52:42 +0200 "Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> On Thursday, April 26, 2012, NeilBrown wrote:
> > On Sun, 22 Apr 2012 23:23:23 +0200 "Rafael J. Wysocki" <rjw@sisk.pl> wr=
ote:
> >=20
> > > From: "Rafael J. Wysocki" <rjw@sisk.pl>
> > > To: Linux PM list <linux-pm@vger.kernel.org>
> > > Cc: LKML <linux-kernel@vger.kernel.org>, Magnus Damm <magnus.damm@gma=
il.com>, markgross@thegnar.org, Matthew Garrett <mjg@redhat.com>, Greg KH <=
gregkh@linuxfoundation.org>, Arve Hj=C3=B8nnev=C3=A5g <arve@android.com>, J=
ohn Stultz <john.stultz@linaro.org>, Brian Swetland <swetland@google.com>, =
Neil Brown <neilb@suse.de>, Alan Stern <stern@rowland.harvard.edu>, Dmitry =
Torokhov <dmitry.torokhov@gmail.com>, "Srivatsa S. Bhat" <srivatsa.bhat@lin=
ux.vnet.ibm.com>
> > > Subject: [RFC][PATCH 6/8] PM / Sleep: Implement opportunistic sleep
> > > Date: Sun, 22 Apr 2012 23:23:23 +0200
> > > Sender: linux-kernel-owner@vger.kernel.org
> > > User-Agent: KMail/1.13.6 (Linux/3.4.0-rc3+; KDE/4.6.0; x86_64; ; )
> > >=20
> > > From: Rafael J. Wysocki <rjw@sisk.pl>
> > >=20
> > > Introduce a mechanism by which the kernel can trigger global
> > > transitions to a sleep state chosen by user space if there are no
> > > active wakeup sources.
> >=20
> > Hi Rafael,
>=20
> Hi,
>=20
> >  just a few little issues below.  Over all I think that if we have to h=
ave
> >  auto-sleep in the kernel, then this is a good way to do it.
>=20
> Good, we seem to agree in principle, then. :-)
>=20
> > > +static void try_to_suspend(struct work_struct *work)
> > > +{
> > > +	unsigned int initial_count, final_count;
> > > +
> > > +	if (!pm_get_wakeup_count(&initial_count, true))
> > > +		goto out;
> > > +
> > > +	mutex_lock(&autosleep_lock);
> > > +
> > > +	if (!pm_save_wakeup_count(initial_count)) {
> > > +		mutex_unlock(&autosleep_lock);
> > > +		goto out;
> > > +	}
> > > +
> > > +	if (autosleep_state =3D=3D PM_SUSPEND_ON) {
> > > +		mutex_unlock(&autosleep_lock);
> > > +		return;
> > > +	}
> > > +	if (autosleep_state >=3D PM_SUSPEND_MAX)
> > > +		hibernate();
> > > +	else
> > > +		pm_suspend(autosleep_state);
> > > +
> > > +	mutex_unlock(&autosleep_lock);
> > > +
> > > +	if (!pm_get_wakeup_count(&final_count, false))
> > > +		goto out;
> > > +
> > > +	if (final_count =3D=3D initial_count)
> > > +		schedule_timeout(HZ / 2);
> >=20
> > This doesn't do what you seem to expect it to do.
> > You need to set current->state to something like TASK_UNINTERRUPTIBLE
> > before calling schedule_timeout, otherwise it is effectily a no-op.
> > schedule_timeout_uninterruptible(), for example, will do this for you.
>=20
> Right.  I obviously overlooked the missing state change.
>=20
> > However the value of this isn't clear to me, so a comment would probabl=
y be a
> > good thing.
> > This continue presumably fires if we wake up without any wakeup sources
> > being activated.  In that case you want to delay for 500ms - presumably=
 to
> > avoid a tight suspend/resume loop if something goes wrong?
>=20
> Yes.
>=20
> > I have occasionally seen a stray/uninteresting interrupt wake from susp=
end
> > immediately after entering suspend and the next attempt succeeds.  Mayb=
e this
> > is a bug in some driver somewhere, but not a big one.  I think I would =
rather
> > in that case that we attempt to re-enter suspend immediately.  Maybe af=
ter a
> > few failed attempts it makes sense to back off.
>=20
> Perhaps.  We can adjust this particular thing later, I think.
>=20
> > The other question is: if we want to back-off, is 500ms really enough? =
 What
> > will be gained by, or could be achieved in, that time?  An exponential
> > back-off might be defensible, but I can't see the value of a 500ms fixed
> > back-off.
> > However if you can, I'd love to see a comment in there explaining it.
>=20
> Sure.
>=20
> > > +
> > > + out:
> > > +	queue_up_suspend_work();
> > > +}
> > > +
> >=20
> >=20
> > > +
> > > +int pm_autosleep_set_state(suspend_state_t state)
> > > +{
> > > +
> > > +#ifndef CONFIG_HIBERNATION
> > > +	if (state >=3D PM_SUSPEND_MAX)
> > > +		return -EINVAL;
> > > +#endif
> > > +
> > > +	__pm_stay_awake(autosleep_ws);
> > > +
> > > +	mutex_lock(&autosleep_lock);
> > > +
> > > +	autosleep_state =3D state;
> > > +
> > > +	__pm_relax(autosleep_ws);
> >=20
> > I'm struggling to see the point of the autosleep_ws.
> >=20
> > A suspend cannot actually happen while this code is running (can it?) b=
ecause
> > it will wait for the process to enter the freezer.
> > So the only effect of this is:
> >   1/ cause the current auto-sleep cycle to abort and
> >   2/ maybe add some accounting number is the autosleep_ws.
> > Is that right?
> > Which of these is needed?
>=20
> This is to solve a problem when user space attempts to echo "off" to
> /sys/power/autosleep exactly when pm_suspend() is initiated as a part
> of autosleep under the autosleep lock.  In that case, if autosleep_ws is =
not
> there, the process wanting to disable autosleep will have to wait for the
> pm_suspend() to complete (unless it holds a wakelock), which is suboptima=
l.
>=20
> > I would imagine that any process writing to /sys/power/autosleep would =
be
> > holding a wakelock, and if it didn't it should expect things to be racy=
...
> >=20
> > Am I missing something?
>=20
> The assumption above is kind of optimistic in my opinion.  That process
> very well may be a system administrator's bash, for example. :-)

If it is, then presumably the auto-sleep could kick in between any pair of
keystrokes that the sysadmin types.  Or between the final 'enter' and when =
the
write() system call begins.  All that autosleep_ws seems to provide is
certainty that when the write() system call completes, autosleep will be
fully disabled.
I don't think that is really worth anything.

However, something did occur to me that I would like clarified.
What happens if try_to_suspend() gets the autosleep_lock just before
wakeup_count_store(), state_store() or pm_autosleep_set_state()
try to get it?
For pm_autosleep_set_state() the try_to_suspend() attempt will abort because
it is holding autosleep_ws, so it will drop the lock and
pm_autosleep_set_state() will continue happily.
For the other two, what will happen (if there are no active wakesources and
autosleep is enabled).
I'm guessing that try_to_suspend will try to freeze all the process, which
sends a pseudo signal to all processes, so the mutex_lock_interruptible will
fail and the suspend will complete.
Then will the aborted write() system call be re-attempted?

If that is right, then here is a very clear need to autosleep_ws:  it preve=
nts
a deadlock.
So it appears there is a very real need for autosleep_ws that even I can
agree with.  It seems subtle though and could usefully be documented:

/* Note: it is only safe to mutex_lock(&autosleep_lock) if a wakeup_source
 * is active, otherwise a deadlock with try_to_suspend() is possible.
 * Alternatively mutex_lock_interruptible() can be used.  This will then fa=
il
 * if an auto_sleep cycle tries to freeze processes.
 */
static DEFINE_MUTEX(autosleep_lock);

So:
  Reviewed-by: NeilBrown <neilb@suse.de>

Thanks,
NeilBrown

--Sig_/zZ8/HSS8aFl7XD6NDGYz0+Z
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT5nq3znsnt1WYoG5AQJ1CA//TLS82ts6u8Qpap6oRzIgVcnZbVd9SEvL
PjOadjBqC3VCEr7v2yk2mgMarstkUWFkNFbCW92M+c85i1F2EzkwGSkkmXbLRvOz
DGr2PgiyRuFxQSDM31rxuO1i1FUHlKFE7QjRlw6bwESFVflglqDKifxERFq7OkwR
TCjh7adj00hH+W2dosd9dvByyu1k8heW8vVhh1R/UXzm1TMk4AqOXjTfsoAzSAm7
cSlaAEczJAd8ggzj7z3AvjZcbMICgL7UfnHlscrTkn8eDf4LsVDZdTHrmWytsd76
vwkd6kZN82bF0R3UU8lZJvyxyE5NcoO2E0ycuaig15l4u1TDnKs4vrpeeYJhXQcK
7e96RaCVH4LFeu9owgRRio6gmmarvRKPMBVH1lpz2Y3/rDVJ/9aLqphSFh7bRkEk
El768QmRHjEtsp37Xqotk/7/C6fO4w+SumsMqdtxsyFraaw0FjioPe/FzATFa0M1
JrRLix2mtOz4Q/gMuyAqMXdKQxTAY6G8egpv3Cj3GREU+Q4dqOKPqjE4YwwJi4fK
lsVBWR04W6W/w7Ar9aIT8WX+Q5BvdRBOquNwXzlXgC5lhO8ztLfuhAXgAmKcHac/
hbKf8hzXV/clKpeEzHdwep46uPkxKd7WHxPf57gE2kpshNLOg44VxnuFam13GU4a
bul6mBLuGUA=
=lmZF
-----END PGP SIGNATURE-----

--Sig_/zZ8/HSS8aFl7XD6NDGYz0+Z--
