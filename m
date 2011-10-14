Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932488Ab1JNFwX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 01:52:23 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38064 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755107Ab1JNFwV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 01:52:21 -0400
Date: Fri, 14 Oct 2011 16:52:12 +1100
From: NeilBrown <neilb@suse.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux PM list <linux-pm@vger.kernel.org>,
        mark gross <markgross@thegnar.org>,
        LKML <linux-kernel@vger.kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [RFC][PATCH 0/2] PM / Sleep: Extended control of
 suspend/hibernate interfaces
Message-ID: <20111014165212.7929243c@notabene.brown>
In-Reply-To: <201110132145.42270.rjw@sisk.pl>
References: <201110132145.42270.rjw@sisk.pl>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.22.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/+YL_XmwF3xHU7v.NbHTsIDQ"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/+YL_XmwF3xHU7v.NbHTsIDQ
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 13 Oct 2011 21:45:42 +0200 "Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> Hi,
>=20
> There is an ongoing discussion about possible ways to avoid some probles
> related to suspend/hibernate interfaces, such as races with the handling
> of wakeup events (in user space) and (destructive) interference with some
> important system maintenance tasks (such as firmware updates).
>=20
> It follows from this discussion that whatever the kernel has to offer in
> this area is either too complicated to use in practice or inadequate for
> other reasons.  The two use case examples given by John, that is the
> firmware update problem (i.e. system suspend or hibernation should not
> be allowed to happen while the system's firmware is being updated) and the
> backup problem (i.e. is should be possible to wake up the system from
> sleep in the middle of the night via a timer event, create a backup of it
> and make it go to sleep again automatically when the backup is ready
> without implementing the backup feature in a power manager) are quite
> convincing to me, but also it seems to me that previous attempts to
> address them go a bit too far in complexity.  For this reason, I thought
> it might be a good idea to propose a simpler approach.  It is not bullet
> proof, but it should be suitable to address at least those two issues.
>=20
> First, to address the firmware update problem, I think we need a big
> hammer switch allowing a root-owned process to disable/enable all
> suspend/hibernate interfaces.  This is introduced by the first patch in
> the form of a new sysfs attribute, /sys/power/sleep_mode, that can be
> used to disable the suspend/hibernate functionality (it does that with
> the help of the existing wakeup events detection mechanism).
>=20
> Second, to address the backup problem, we need to allow user space
> processes other than the suspend/hibernate process itself to prevent the
> system from being put into sleep states.  A mechanism for that is introdu=
ced
> by the second patch in the form of the /dev/sleepctl special device worki=
ng
> kind of like user space wakelocks on Android (although in a simplified
> fashion).
>=20
> More details are in the changelogs and (of course) in the code itself.
>=20
> The patches haven't been tested (I had tested the first one, but then I m=
ade
> some changes to it afterwards), so most likely there are some bugs in the=
m,
> but I didn't want to lose time on testing things that people may not like
> in principle. :-)
>

Hi Rafael,

 What do you mean by "too complicated to use in practice"?  What is you
 measure for complexity?
 Using suspend in a race-free way is certainly less complex than - for
 example - configuring bluetooth.
 And in what way is it "inadequate for other reasons"? What reasons?


 The only sane way to handle suspend is for any (suitably privileged) proce=
ss
 to be able to request that suspend doesn't happen, and then for one process
 to initiate suspend when no-one is blocking it.

 This is very different from the way it is currently handled were the GUI
 says "Hmm.. I'm not doing anything just now, I think I'll suspend".

 The later simply doesn't scale.  It is broken.  It has to be replaced.
 And it is being replaced.

 gnome-power-manage has a dbus interface on which you can request
 "InhibitInactiveSleep".  Call that will stop gnome-power-manager from
 sleeping (I assume - haven't looked at the code).
 It might not inhibit an explicit request for sleep - in that case it is
 probably broken and needs to be fixed.  But is can be fixed.  Or replaced.

 So if someone is running gnome-power-manager and wants to perform a firmwa=
re
 update, the correct thing to do is to use dbus to disable the inactive sle=
ep.
 If someone is using some other power manager they might need to use some
 other mechanism.  Presumably these things will be standardised at some sta=
ge.

 But I think it is very wrong to put some hack in the kernel like your
   suspend_mode =3D disabled

 just because the user-space community hasn't got its act together yet.

 And if you really need a hammer to stop processes from suspending the syst=
em:

   cat /sys/power/state > /tmp/state
   mount --bind /tmp/state /sys/power/state

 should to it.


 You second patch has little to recommend it either.
 In the first place it seems to be entrenching the notion that timeouts are=
 a
 good and valid way to think about suspend.
 I certainly agree that there are plenty of cases where timeouts are
 important and necessary.  But there are also plenty of cases where you will
 know exactly when you can allow suspend again, and having a timeout there =
is
 just confusing.

 But worse - the mechanism you provide can be trivially implemented using
 unix-domain sockets talking to a suspend-daemon.

 Instead of opening /dev/sleepctl, you connect to /var/run/suspend-daemon/s=
ock
 Instead of ioctl(SLEEPCTL_STAY_AWAKE), you write a number to the socket.
 Instead of ioctl(SLEEPCTL_RELAX), you write zero to the socket.

 All the extra handling you do in the kernel, can easily be done by
 user-space suspend-daemon.



 I really wish I could work out why people find the current mechanism
 "difficult to use".  What exactly is it that is difficult?
 I have describe previously how to build a race-free suspend system.  Which
 bit of that is complicated or hard to achieve?  Or which bit of that cannot
 work the way I claim?  Or which need is not met by my proposals?

 Isn't it much preferable to do this in userspace where people can
 experiment and refine and improve without having to upgrade the kernel?

NeilBrown

--Sig_/+YL_XmwF3xHU7v.NbHTsIDQ
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTpfODDnsnt1WYoG5AQLOFA/8DKQymmdaOhK74H4gIvECeDePS7Dc77Us
edGpct7x/BRC1UHkjIgh0BIlkN/fnpCXLvqtjfMI8N8HZoHu2OWGyBdn9pZkPuxG
vhNDeP06fZzOE051ogUFvE0hpWw1jihGGYnUK17r8B1Rpwve0rNo6KnxcIhkg/tW
AWKJkU5KySQ2yjwZ00wwMJSmMz5g0Ml4Mz7JN2y1hks3meRX0JXKtwusORAhwA7Q
o802vABLEEjok//W71ISp6tqUTiV9y4KjJqjMUX0l5jmAXABb22i/2heOQOAapFq
TzSw9j2RhA+34XJhR1vpacT6X9JoSI0OzZq8euAG5VRP+jup2U6kgvGMvfYwq5rj
axKBdOshmxl/qBTTd11zFcS9a0bRUo3fOWnQou9xaU5iTe4X0eVSAyffn+KyiwU0
US1i3t7OtXf7GWeJK733BvFefZflrpQ9jbe63g/67M3g02Tl960hChrCl0Hh84Fc
wUQrEpoLKn+dpqCAhJaoDt92i6bSkZ71o/B7xTC7ruXSXVPSxU8dof8htG9L1mZD
BDgjFluCtIqmHwShXHzRLg3+TiIiC3O2Vr4fSZi8+F2B+WFvS9MbRV9pvnB+zobm
+sox4JssbH4pUNgOblkigSRyKlpLYIrwXB1vEZK2y4feEtV5m8ZyQiX0qX4iFOaH
HesRsDK4rws=
=k7DF
-----END PGP SIGNATURE-----

--Sig_/+YL_XmwF3xHU7v.NbHTsIDQ--
