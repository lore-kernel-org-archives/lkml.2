Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755172Ab1JWIWM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Oct 2011 04:22:12 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42404 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754978Ab1JWIWB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Oct 2011 04:22:01 -0400
Date: Sun, 23 Oct 2011 19:21:47 +1100
From: NeilBrown <neilb@suse.de>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: John Stultz <john.stultz@linaro.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        mark gross <markgross@thegnar.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: lsusd - The Linux SUSpend Daemon
Message-ID: <20111023192147.49413485@notabene.brown>
In-Reply-To: <Pine.LNX.4.44L0.1110212125020.8657-100000@netrider.rowland.org>
References: <20111022093436.0742176c@notabene.brown>
	<Pine.LNX.4.44L0.1110212125020.8657-100000@netrider.rowland.org>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.22.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/r+_.p0unpi80DPjoRQ_sOU_"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/r+_.p0unpi80DPjoRQ_sOU_
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 21 Oct 2011 22:00:13 -0400 (EDT) Alan Stern
<stern@rowland.harvard.edu> wrote:

> On Sat, 22 Oct 2011, NeilBrown wrote:
>=20
> > > >     It uses files in /var/run/suspend for all communication.
> > >=20
> > > I'm not so keen on using files for communication.  At best, they are
> > > rather awkward for two-way messaging.  If you really want to use them,
> > > then at least put them on a non-backed filesystem, like something und=
er
> > > /dev.
> >=20
> > Isn't /var/run a tmpfs filesystem?  It should be.
> > Surely /run is, so in the new world order the files should probably go
> > there.   But that is just a detail.
>=20
> On my Fedora-14 systems there is no /run, and /var/run is a regular=20
> directory in a regular filesystem.
>=20
> > I like files...  I particularly like 'flock' to block suspend.   The
> > rest.... whatever..
> > With files, you only need a context switch when there is real communica=
tion.
> > With sockets, every message sent must be read so there will be a context
> > switch.
> >=20
> > Maybe we could do something with futexes...
>=20
> Not easily -- as far as I can tell, futexes enjoy relatively little=20
> support.  In any case, they provide the same service as a mutex, which=20
> means you'd have to build a shared lock on top of them.
>=20
> > > >     lsusd does not try to be event-loop based because:
> > > >       - /sys/power/wakeup_count is not pollable.  This could probab=
ly be
> > > >         'fixed' but I want code to work with today's kernel.  It wi=
ll probably
> > >=20
> > > Why does this matter?
> >=20
> > In my mind an event based program should never block.  Every action sho=
uld be
> > non-blocking and only taken when 'poll' says it can.
> > Reading /sys/power/wakeup_count can be read non-blocking, but you canno=
t find
> > out when it is sensible to try to read it again.  So it doesn't fit.
>=20
> There shouldn't be any trouble about making wakeup_count pollable.  It
> also would need to respect nonblocking reads, which it currently does=20
> not do.

Hmm.. you are correct.  I wonder why I thought it did support non-blocking
reads...
I guess it was the code for handling an interrupted system call.

I feel a bit uncomfortable with the idea of sysfs files that block but I
don't think I can convincingly argue against it.
A non-blocking flag could be passed in, but it would be a very messy change=
 -
lots of function call signatures changing needlessly:  we would need a flag
to the 'show' method ... or add a 'show_nonblock' method which would also be
ugly.


But I think there is a need to block - if there is an in-progress event then
it must be possible to wait for it to complete as it may not be visible to
userspace until then.
We could easily enable 'poll' for wakeup_count and then make it always
non-blocking, but I'm not really sure I want to require programs to use pol=
l,
only to allow them.  And without using poll there is no way to wait.

As wakeup_count really has to be single-access we could possibly fudge
something by remembering the last value read (like we remember the last val=
ue
written).

- if the current count is different from the last value read, then return
  it even if there are in-progress events.
- if the current count is the same as the last value read, then block until
  there are no in-progress events and return the new value.
- enable sysfs_poll on wakeup_count by calling sysfs_notify_dirent at the
  end of wakeup_source_deactivated .... or calling something in
  kernel/power/main.c which calls that.  However we would need to make
  sysfs_notify_dirent a lot lighter weight first.  Maybe I should do that.

Then a process that uses 'poll' could avoid reading wakeup_count except when
it has changed, and then it won't block.  And a process that doesn't use po=
ll
can block by simply reading twice - either explicitly or by going around a=
=20
   read then write and it fails
loop a second time.

I'm not sure I'm completely comfortable with that, but it is the best I cou=
ld
come up with.


>=20
> At the worst, you could always have a separate thread to read=20
> wakeup_count.

Maybe.  I'm tempted simply not to worry about the short delay after all, but
the moment I do that, someone will use a wakeup_source to disable suspend
for a longer period of time (just like I suggested) and suddenly it won't be
a short delay after all.

>=20
> > > >       - I cannot get an event notification when a lock is removed f=
rom a
> > > >         file. :-(  And I think locks are an excellent light-weight
> > > >         mechanism for blocking suspend.
> > >=20
> > > Except for this one drawback.  Socket connections are superior in tha=
t=20
> > > regard.
> >=20
> > I'm very happy for someone else write an all-socket based daemon.
>=20
> Hmmm...  Maybe I'll take you up on that.
>=20
>=20
> > > >       lsused will send a 'S' message to the client and await an 'R'=
 reply
> > > >       (S =3D=3D suspend, R =3D=3D ready).  When all replies are in,=
 lsused will
> > > >       allow the suspend to complete.  When it does (or aborts), it =
will send
> > > >       'A' (awake) to those clients to which it sent 'S'.
> > >=20
> > > But not to the client which failed to send an 'R'?
> >=20
> > Every client must send an R before suspend can continue.
>=20
> I was referring to the case where you abort before receiving an 'R'. =20
> The current suspend attempt will fail, but then what happens during the
> next attempt?

There is no situation in which I abort before receiving an 'R'.
I wait until all 'R's are in until I even check if an abort was requested.


NeilBrown



Sample untested patch to allow non-blocking reads and poll on wakeup_count.

diff --git a/drivers/base/power/wakeup.c b/drivers/base/power/wakeup.c
index 84f7c7d..54543ba 100644
--- a/drivers/base/power/wakeup.c
+++ b/drivers/base/power/wakeup.c
@@ -44,6 +44,8 @@ static void split_counters(unsigned int *cnt, unsigned in=
t *inpr)
=20
 /* A preserved old value of the events counter. */
 static unsigned int saved_count;
+/* Record last value that was read from events counter. */
+static unsigned int last_read_count;
=20
 static DEFINE_SPINLOCK(events_lock);
=20
@@ -410,6 +412,7 @@ static void wakeup_source_deactivate(struct wakeup_sour=
ce *ws)
 {
 	ktime_t duration;
 	ktime_t now;
+	unsigned int comb;
=20
 	ws->relax_count++;
 	/*
@@ -440,7 +443,10 @@ static void wakeup_source_deactivate(struct wakeup_sou=
rce *ws)
 	 * Increment the counter of registered wakeup events and decrement the
 	 * couter of wakeup events in progress simultaneously.
 	 */
-	atomic_add(MAX_IN_PROGRESS, &combined_event_count);
+	comb =3D atomic_add_return(MAX_IN_PROGRESS, &combined_event_count);
+
+	if ((comb >> IN_PROGRESS_BITS) =3D=3D last_read_count + 1)
+		wakeup_count_changed();
 }
=20
 /**
@@ -624,15 +630,24 @@ bool pm_get_wakeup_count(unsigned int *count)
=20
 	for (;;) {
 		split_counters(&cnt, &inpr);
-		if (inpr =3D=3D 0 || signal_pending(current))
+		if (inpr =3D=3D 0 || cnt !=3D last_read_count)
 			break;
+		if (signal_pending(current))
+			return false;
 		pm_wakeup_update_hit_counts();
 		schedule_timeout_interruptible(msecs_to_jiffies(TIMEOUT));
 	}
=20
+	last_read_count =3D cnt;
+	/* If cnt has just changed, then last_read_count will be a bit
+	 * old, so we won't block on the next read, only the one after.
+	 * However this ensures wakeup_source_deactivate doesn't
+	 * miss out on calling wakeup_count_changed() on a change.
+	 */
+	smp_wmb();
 	split_counters(&cnt, &inpr);
 	*count =3D cnt;
-	return !inpr;
+	return true;
 }
=20
 /**
diff --git a/fs/sysfs/file.c b/fs/sysfs/file.c
index 1ad8c93..41361ba 100644
--- a/fs/sysfs/file.c
+++ b/fs/sysfs/file.c
@@ -444,18 +444,19 @@ static unsigned int sysfs_poll(struct file *filp, pol=
l_table *wait)
=20
 void sysfs_notify_dirent(struct sysfs_dirent *sd)
 {
-	struct sysfs_open_dirent *od;
-	unsigned long flags;
+	if (sd->s_attr.open) {
+		struct sysfs_open_dirent *od;
+		unsigned long flags;
+		spin_lock_irqsave(&sysfs_open_dirent_lock, flags);
=20
-	spin_lock_irqsave(&sysfs_open_dirent_lock, flags);
+		od =3D sd->s_attr.open;
+		if (od) {
+			atomic_inc(&od->event);
+			wake_up_interruptible(&od->poll);
+		}
=20
-	od =3D sd->s_attr.open;
-	if (od) {
-		atomic_inc(&od->event);
-		wake_up_interruptible(&od->poll);
+		spin_unlock_irqrestore(&sysfs_open_dirent_lock, flags);
 	}
-
-	spin_unlock_irqrestore(&sysfs_open_dirent_lock, flags);
 }
 EXPORT_SYMBOL_GPL(sysfs_notify_dirent);
=20
diff --git a/include/linux/suspend.h b/include/linux/suspend.h
index 6bbcef2..e42b7f9 100644
--- a/include/linux/suspend.h
+++ b/include/linux/suspend.h
@@ -296,6 +296,7 @@ extern bool events_check_enabled;
 extern bool pm_wakeup_pending(void);
 extern bool pm_get_wakeup_count(unsigned int *count);
 extern bool pm_save_wakeup_count(unsigned int count);
+extern void wakeup_count_changed(void);
 #else /* !CONFIG_PM_SLEEP */
=20
 static inline int register_pm_notifier(struct notifier_block *nb)
diff --git a/kernel/power/main.c b/kernel/power/main.c
index 6c601f8..6b3cd80 100644
--- a/kernel/power/main.c
+++ b/kernel/power/main.c
@@ -231,6 +231,8 @@ power_attr(state);
  * are any wakeup events detected after 'wakeup_count' was written to.
  */
=20
+struct sysfs_dirent *wakeup_count_dirent;
+
 static ssize_t wakeup_count_show(struct kobject *kobj,
 				struct kobj_attribute *attr,
 				char *buf)
@@ -253,6 +255,12 @@ static ssize_t wakeup_count_store(struct kobject *kobj,
 	return -EINVAL;
 }
=20
+void wakeup_count_change(void)
+{
+	if (wakeup_count_dirent)
+		sysfs_notify_dirent(wakeup_count_dirent);
+}
+
 power_attr(wakeup_count);
 #endif /* CONFIG_PM_SLEEP */
=20
@@ -342,7 +350,11 @@ static int __init pm_init(void)
 	power_kobj =3D kobject_create_and_add("power", NULL);
 	if (!power_kobj)
 		return -ENOMEM;
-	return sysfs_create_group(power_kobj, &attr_group);
+	error =3D sysfs_create_group(power_kobj, &attr_group);
+#ifdef CONFIG_PM_SLEEP
+	wakeup_count_dirent =3D sysfs_get_dirent(power_kobj->sd, NULL, "wakeup_co=
unt");
+#endif
+	return error;
 }
=20
 core_initcall(pm_init);




--Sig_/r+_.p0unpi80DPjoRQ_sOU_
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIUAwUBTqPOpTnsnt1WYoG5AQL4lg/4i2+ezogzDgzvKmEfynmN6htHx3CH418h
RtLgOj/INAefldEqsqX0R59zPe/X3tlErF7oCPjvbA4aerocQxUMzZwnt+NWbn5l
ps1aSRdoXKUfcn42ZC/7G9aTcnkcmyAoqLPR+80kKd2hVX41VSLvJ8M8L+Mto6Lb
9mL3uk5WVf1FKlo0Og7Ep58dDFXcbA1SEttOIpxTkf/l1DW6vcPzBm0OGW0Bne9d
rSBLKXIHZ6PLZmydVO8YtSnAS4y7PvjA/7wz7ly4/YqrBU8n7Zx5Kzv8UdBqRd+y
XQ4teS9Ny5kW+GQt+U8TubQIMgjqRUxRaG1CCCs+K4pUOcfCPtN20IsOnxreVkg1
MY4pRT+LSg+T2ELv5h0FwFMScXmTfo90E4NPrwZ0NFGtc6btZz0onf3r8Q9Ru1Mj
hux9bfjHyjCLxTL++kZLlKg3FJQPUCQBHfJ9kar3LHrNWwIAdt4zm6e3e81dS5+O
mkJgzUBfIhcCW4mOga20uEdMer1+wzFF0N9M01XRDGR8Y26ApP6Nt4VS2bTVe3rF
EbdeorG9A/nmDPtrjAKY7UoU3BeZxhxIlM6JGapCNLbFAQdeTYVqId60ABJEriM4
UM/T17S6KfikaavErJPug8vxAbAr5GIlTnjeIUO7DQb4eQJryz8o8ODcYss2p65A
/JPPOK5/Xg==
=JEtr
-----END PGP SIGNATURE-----

--Sig_/r+_.p0unpi80DPjoRQ_sOU_--
