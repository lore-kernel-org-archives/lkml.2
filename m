Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751981Ab2GBALK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2012 20:11:10 -0400
Received: from cantor2.suse.de ([195.135.220.15]:58342 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751095Ab2GBALH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2012 20:11:07 -0400
Date: Mon, 2 Jul 2012 10:10:57 +1000
From: NeilBrown <neilb@suse.de>
To: Colin Cross <ccross@android.com>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Andrew Boie <andrew.p.boie@intel.com>, arve@android.com,
        rebecca@android.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] bcb: Android bootloader control block driver
Message-ID: <20120702101057.2a8dd6a6@notabene.brown>
In-Reply-To: <CAMbhsRRUs1tHQ+DfWzhKE6M47+Rqu0uB4hQgX7d7ZGzaZi9uyw@mail.gmail.com>
References: <1340998590-23042-1-git-send-email-andrew.p.boie@intel.com>
	<20120630032333.GB3972@kroah.com>
	<CAMbhsRSYL3oE_mbdjyNbV453DddPNUyJBU2eLJhUNaASF1+MtA@mail.gmail.com>
	<20120630041928.GA1816@kroah.com>
	<CAMbhsRRUs1tHQ+DfWzhKE6M47+Rqu0uB4hQgX7d7ZGzaZi9uyw@mail.gmail.com>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/zvViaEiHQ4TqlyRciy.uA2y"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/zvViaEiHQ4TqlyRciy.uA2y
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On Fri, 29 Jun 2012 21:37:36 -0700 Colin Cross <ccross@android.com> wrote:

> What's the point of the existing syscall option if it doesn't work on
> all platforms, or at least all platforms that want to support it?  It
> doesn't make sense to me to use REBOOT2 on some SoCs because they
> happen to use something that userspace cannot access, but use direct
> access from userspace and a different reboot syscall option on other
> SoCs.
>=20
> >> <snip>
> >>
> >> >>
> >> >> diff --git a/drivers/staging/android/Kconfig b/drivers/staging/andr=
oid/Kconfig
> >> >> index 9a99238..c30fd20 100644
> >> >> --- a/drivers/staging/android/Kconfig
> >> >> +++ b/drivers/staging/android/Kconfig
> >> >> @@ -78,6 +78,17 @@ config ANDROID_INTF_ALARM_DEV
> >> >> =A0 =A0 =A0 =A0 elapsed realtime, and a non-wakeup alarm on the mon=
otonic clock.
> >> >> =A0 =A0 =A0 =A0 Also exports the alarm interface to user-space.
> >> >>
> >> >> +config BOOTLOADER_CONTROL
> >> >> + =A0 =A0 tristate "Bootloader Control Block module"
> >> >> + =A0 =A0 default n
> >> >> + =A0 =A0 help
> >> >> + =A0 =A0 =A0 This driver installs a reboot hook, such that if rebo=
ot() is invoked
> >> >> + =A0 =A0 =A0 with a string argument NNN, "bootonce-NNN" is copied =
to the command
> >> >> + =A0 =A0 =A0 field in the Bootloader Control Block on the /misc pa=
rtition, to be
> >> >> + =A0 =A0 =A0 read by the bootloader. If the string matches one of =
the boot labels
> >> >> + =A0 =A0 =A0 defined in its configuration, it will boot once into =
that label. The
> >> >> + =A0 =A0 =A0 device and partition number are specified on the kern=
el command line.
> >> >> +
> >> >> =A0endif # if ANDROID
> >> >>
> >> >> =A0endmenu
> >>
> >> Most of this driver is not unique to Android.
> >
> > Do any other systems use it?
>=20
> None that I'm aware of, but REBOOT2 existed long before Android, so I
> assume something must have used it.

Dangerous that - making assumptions.

I've just spent a while hunting though the code and the history.
The LINUX_REBOOT_CMD_RESTART2 option to sys_reboot - which is the only one
that uses the the 'arg' option - was added in 2.1.30.  This was the same ti=
me
that reboot notifiers were added and there seem to be steps towards a more
generic "machine_restart" call.
No code actually *used* the arg.

Looking through current code is rather time consuming as you have to follow
several levels of indirection to find code that might actually use the arg,
but I spend a while looking, trying to cover samples for all archs and driv=
er
classes (there are lots of watchdogs -  I didn't check them all).
I only found *1* instance of code which actually used the arg.
This is arch/alpha/kernel/process.c which tests if the arg is NULL, and
selects between a "cold bootstrap" and a "warm bootstrap".

I think we would be well served by a patch that just removes it.  Or at
least, that ignores the value of the arg and just passes NULL or (void*)1.
And definitely don't pass it to the reboot notifiers - no code uses it ther=
e.

I can certainly see value in having a standard interface to say "the next
reboot should boot 'foo' rather than the default".  I don't think there is
any real need for the kernel to provide that interface.

I would suggest that you create
    /sbin/next-boot-image
(or some better name), which gets a different program installed depending on
what boot loader is in use.  Then your libcutils can just

  system("/sbin/next-boot-image foo")
  reboot(LINUX_REBOOT_CMD_RESTART);

and work on all platforms.
(Or use a loadable module, or a binder RPC to some service, or dbus or smoke
signals or whatever).

NeilBrown


--Sig_/zvViaEiHQ4TqlyRciy.uA2y
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT/DnETnsnt1WYoG5AQKokg//WGBqzT71UGjQTvKn0pMrBcY7IJ6XCvZh
ujimBGRcs/Qyck4fx0eCTUW4zrDbDEZn0z835u1SVWbdLpRQmCbTcR4chvcqOcbX
sggv52+JDYPBeJjlBx6NDBw+5hEyebRtyYSBlSt1cDvSwaCCvdZj5n6GqCPDWTTT
6n/QR6GEdVv0Eat2sGiMhiLezDGPCEY1OLvWVVRb60In+R6tN87mxJuaDh8Z9lXd
2n/03poQ+aI+TodCBZv+V89a1EVCIy+AdOzLk1GcmNdoXGQLYjFqbTDfGxOjjj64
ea8KcsY5V+9/jIyflNzSsUmZxkcWDcPXlr5KRBKSvxo5yX3Asuu8tCNbnf4sM82y
+U67SiNee5MvK6iKfzCHQaPZsFsJNEfWwKiouvRLZzN597yZlGaVfnteZTIM4ME3
r5EvCgnTMAQXizz83ku/cMJq3OsSJuN6b3xNay6xsRraN3Z8uB0v43sV7YzGbOO9
r2htlaECDzsN8kDIszJon54rz4D9URKSCdkx0eYdfRnyRpXhiJ/yWEEJrO9sF3+o
Q9vIBs9V2qSthRgBtge2XtfiDCU91K4Iea2vBbDii2qsyrLTUCik/ANUmWMNUZeW
/RfdjncD4n4dV+Mr7+Vax8XCjBWs1NtgKofHiGRJ0Pv2pZE8PWYOP59wcfOg0AEL
dPgRmn2AcxE=
=2fET
-----END PGP SIGNATURE-----

--Sig_/zvViaEiHQ4TqlyRciy.uA2y--
