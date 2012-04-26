Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753633Ab2DZDFV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 23:05:21 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33327 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752358Ab2DZDFS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 23:05:18 -0400
Date: Thu, 26 Apr 2012 13:05:03 +1000
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
Message-ID: <20120426130503.7f55415d@notabene.brown>
In-Reply-To: <201204222323.23685.rjw@sisk.pl>
References: <201202070200.55505.rjw@sisk.pl>
	<201202220031.46219.rjw@sisk.pl>
	<201204222319.02228.rjw@sisk.pl>
	<201204222323.23685.rjw@sisk.pl>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/Nvc/92mQeFmJ.OoY60pfJ3r"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/Nvc/92mQeFmJ.OoY60pfJ3r
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Sun, 22 Apr 2012 23:23:23 +0200 "Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> From: "Rafael J. Wysocki" <rjw@sisk.pl>
> To: Linux PM list <linux-pm@vger.kernel.org>
> Cc: LKML <linux-kernel@vger.kernel.org>, Magnus Damm <magnus.damm@gmail.c=
om>, markgross@thegnar.org, Matthew Garrett <mjg@redhat.com>, Greg KH <greg=
kh@linuxfoundation.org>, Arve Hj=C3=B8nnev=C3=A5g <arve@android.com>, John =
Stultz <john.stultz@linaro.org>, Brian Swetland <swetland@google.com>, Neil=
 Brown <neilb@suse.de>, Alan Stern <stern@rowland.harvard.edu>, Dmitry Toro=
khov <dmitry.torokhov@gmail.com>, "Srivatsa S. Bhat" <srivatsa.bhat@linux.v=
net.ibm.com>
> Subject: [RFC][PATCH 6/8] PM / Sleep: Implement opportunistic sleep
> Date: Sun, 22 Apr 2012 23:23:23 +0200
> Sender: linux-kernel-owner@vger.kernel.org
> User-Agent: KMail/1.13.6 (Linux/3.4.0-rc3+; KDE/4.6.0; x86_64; ; )
>=20
> From: Rafael J. Wysocki <rjw@sisk.pl>
>=20
> Introduce a mechanism by which the kernel can trigger global
> transitions to a sleep state chosen by user space if there are no
> active wakeup sources.

Hi Rafael,
 just a few little issues below.  Over all I think that if we have to have
 auto-sleep in the kernel, then this is a good way to do it.

> +static void try_to_suspend(struct work_struct *work)
> +{
> +	unsigned int initial_count, final_count;
> +
> +	if (!pm_get_wakeup_count(&initial_count, true))
> +		goto out;
> +
> +	mutex_lock(&autosleep_lock);
> +
> +	if (!pm_save_wakeup_count(initial_count)) {
> +		mutex_unlock(&autosleep_lock);
> +		goto out;
> +	}
> +
> +	if (autosleep_state =3D=3D PM_SUSPEND_ON) {
> +		mutex_unlock(&autosleep_lock);
> +		return;
> +	}
> +	if (autosleep_state >=3D PM_SUSPEND_MAX)
> +		hibernate();
> +	else
> +		pm_suspend(autosleep_state);
> +
> +	mutex_unlock(&autosleep_lock);
> +
> +	if (!pm_get_wakeup_count(&final_count, false))
> +		goto out;
> +
> +	if (final_count =3D=3D initial_count)
> +		schedule_timeout(HZ / 2);

This doesn't do what you seem to expect it to do.
You need to set current->state to something like TASK_UNINTERRUPTIBLE
before calling schedule_timeout, otherwise it is effectily a no-op.
schedule_timeout_uninterruptible(), for example, will do this for you.

However the value of this isn't clear to me, so a comment would probably be=
 a
good thing.
This continue presumably fires if we wake up without any wakeup sources
being activated.  In that case you want to delay for 500ms - presumably to
avoid a tight suspend/resume loop if something goes wrong?

I have occasionally seen a stray/uninteresting interrupt wake from suspend
immediately after entering suspend and the next attempt succeeds.  Maybe th=
is
is a bug in some driver somewhere, but not a big one.  I think I would rath=
er
in that case that we attempt to re-enter suspend immediately.  Maybe after a
few failed attempts it makes sense to back off.

The other question is: if we want to back-off, is 500ms really enough?  What
will be gained by, or could be achieved in, that time?  An exponential
back-off might be defensible, but I can't see the value of a 500ms fixed
back-off.
However if you can, I'd love to see a comment in there explaining it.


> +
> + out:
> +	queue_up_suspend_work();
> +}
> +


> +
> +int pm_autosleep_set_state(suspend_state_t state)
> +{
> +
> +#ifndef CONFIG_HIBERNATION
> +	if (state >=3D PM_SUSPEND_MAX)
> +		return -EINVAL;
> +#endif
> +
> +	__pm_stay_awake(autosleep_ws);
> +
> +	mutex_lock(&autosleep_lock);
> +
> +	autosleep_state =3D state;
> +
> +	__pm_relax(autosleep_ws);

I'm struggling to see the point of the autosleep_ws.

A suspend cannot actually happen while this code is running (can it?) becau=
se
it will wait for the process to enter the freezer.
So the only effect of this is:
  1/ cause the current auto-sleep cycle to abort and
  2/ maybe add some accounting number is the autosleep_ws.
Is that right?
Which of these is needed?

I would imagine that any process writing to /sys/power/autosleep would be
holding a wakelock, and if it didn't it should expect things to be racy...

Am I missing something?


> +
> +	if (state > PM_SUSPEND_ON)
> +		queue_up_suspend_work();

The test here is superfluous as queue_up_suspend_work() itself tests that
'state' is > PM_SUSPEND_ON.  However maybe it is more readable this way, so=
 I
won't object it you like it.


> +
> +	mutex_unlock(&autosleep_lock);
> +	return 0;
> +}


> @@ -339,7 +359,8 @@ static ssize_t wakeup_count_show(struct
>  {
>  	unsigned int val;
> =20
> -	return pm_get_wakeup_count(&val) ? sprintf(buf, "%u\n", val) : -EINTR;
> +	return pm_get_wakeup_count(&val, true) ?
> +		sprintf(buf, "%u\n", val) : -EINTR;
>  }

I think it would be really nice for user-space auto-suspend if the 'block'
flag to be settable from the O_NONBLOCK setting.  And for poll() to work
on /sys/power/wakeup-count.  However this would require a bit of surgery on
sysfs.  So that is a "maybe later", but having the 'block' flag in there is
a step in the right direction.


> =20
>  static ssize_t wakeup_count_store(struct kobject *kobj,
> @@ -347,15 +368,69 @@ static ssize_t wakeup_count_store(struct
>  				const char *buf, size_t n)
>  {
>  	unsigned int val;
> +	int error;
> +
> +	error =3D pm_autosleep_lock();
> +	if (error)
> +		return error;
> +
> +	if (pm_autosleep_state() > PM_SUSPEND_ON) {
> +		error =3D -EBUSY;
> +		goto out;
> +	}
> =20
>  	if (sscanf(buf, "%u", &val) =3D=3D 1) {
>  		if (pm_save_wakeup_count(val))
>  			return n;

You need a 'pm_autosleep_unlock() in there - or possibly
  error =3D n; goto out;


>  	}
> -	return -EINVAL;
> +	error =3D -EINVAL;
> +
> + out:
> +	pm_autosleep_unlock();
> +	return error;
>  }

>  core_initcall(pm_init);
> Index: linux/drivers/base/power/wakeup.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux.orig/drivers/base/power/wakeup.c
> +++ linux/drivers/base/power/wakeup.c
> @@ -498,8 +498,10 @@ static void wakeup_source_deactivate(str
>  	trace_wakeup_source_deactivate(ws->name, cec);
> =20
>  	split_counters(&cnt, &inpr);
> -	if (!inpr && waitqueue_active(&wakeup_count_wait_queue))
> +	if (!inpr && waitqueue_active(&wakeup_count_wait_queue)) {
>  		wake_up(&wakeup_count_wait_queue);
> +		queue_up_suspend_work();
> +	}

This doesn't look right.  suspend_work always requeues itself unless
autosleep_state =3D=3D PM_SUSPEND_ON, and whenver autosleep_state is set we
already call queue_up_suspend_work().  So there is no need to call it here.

> Index: linux/Documentation/ABI/testing/sysfs-power
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux.orig/Documentation/ABI/testing/sysfs-power
> +++ linux/Documentation/ABI/testing/sysfs-power
> @@ -172,3 +172,20 @@ Description:
> =20
>  		Reading from this file will display the current value, which is
>  		set to 1 MB by default.
> +
> +What:		/sys/power/autosleep
> +Date:		February 2012
> +Contact:	Rafael J. Wysocki <rjw@sisk.pl>
> +Description:
> +		The /sys/power/autosleep file can be written one of the strings

"To the .. file can be written..." or
"The .. file can have written ..." or
"One of the strings returned by (reads from) /sys/power/state can be written
to the file ..."
??
> +		returned by reads from /sys/power/state.  If that happens, a
> +		work item attempting to trigger a transition of the system to
> +		the sleep state represented by that string is queued up.  This
> +		attempt will only succeed if there are no active wakeup sources
> +		in the system at that time.  After evey execution, regardless
                                                   ^^^^
  "every"

> +		of whether or not the attempt to put the system to sleep has
> +		succeeded, the work item requeues itself until user space
> +		writes "off" to /sys/power/autosleep.
> +
> +		Reading from this file causes the last string successfully
> +		written to it to be displayed.
                                    ^^^^^^^^^  "returned".


Thanks,
NeilBrown

--Sig_/Nvc/92mQeFmJ.OoY60pfJ3r
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT5i7Xznsnt1WYoG5AQKLbA//Upu7vNzsbRHTj+lMp0LWpvv+jh3knFAU
TM2JMx/O+vEBo33xq97ReP5F6V5tH9x96X4oyOSREvBF1xLxI+SHjof/NUxo79B8
3gxPGjgb/AJ/BF7GORULAz5jCLvkjAF9Tl8FxbWjv3H/67IR3FSvGnR0rp6EhRUA
OE/qcheV3gU489C/nikw5yJG5C1JsDfC7I7AfdLN0sEWP+fuIQqZKlU9Qn7Cfb7I
0j7OJTq6eTeE7jR10MOH+cOrRw0/uhUW/L+q9gyQBDwW1z2+Nm9qfb5wy71Cvowd
4LgzWnxHrjNFXKLlJTFfKMlmKpcKpFEgiOlcFKEUYCjHTSNrb1AuXATudrizpTrN
2ybfJagsHw6czTvxX7ct4zE5TdhpLr67Mx84VePlSCxU4ls+hegUyjaY1KK8LN+0
5I0yXye8UfwXQjnqYwtFdLXwYhNHMckib1wmkThEN0NFiCIdScW82AMvprjWUvxn
Mr65/A5DQoAQBKiey0QEk5+sEr/HYmPzh9sxpHzDSNPRygf4cVvd2GpLVvkijVX9
QblWMeL8VgLODyb/j1LeyAR3ChMQ05MoGOedscmiLd8MUFrBoz4NChcoo67mbJNr
e5uYXoD49RaqJloXDx9LrDuc7hfOGZa7KRPjyiFJWzG4LxWdV2kNj7Ku/Aq0o0Mp
6XizWiYVyLE=
=/SBY
-----END PGP SIGNATURE-----

--Sig_/Nvc/92mQeFmJ.OoY60pfJ3r--
