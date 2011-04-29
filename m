Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758170Ab1D2KEn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 06:04:43 -0400
Received: from gw3.lbox.cz ([62.245.111.133]:33192 "EHLO pcnci.linuxbox.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751886Ab1D2KEl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 06:04:41 -0400
Date: Fri, 29 Apr 2011 12:02:00 +0200
From: Nikola Ciprich <nikola.ciprich@linuxbox.cz>
To: Willy Tarreau <w@1wt.eu>
Cc: linux-kernel mlist <linux-kernel@vger.kernel.org>,
        linux-stable mlist <stable@kernel.org>,
        =?iso-8859-1?Q?Herv=E9?= Commowick <hcommowick@exosec.fr>,
        seto.hidetoshi@jp.fujitsu.com
Subject: Re: [stable] 2.6.32.21 - uptime related crashes?
Message-ID: <20110429100200.GB23293@pcnci.linuxbox.cz>
References: <20110428082625.GA23293@pcnci.linuxbox.cz> <20110428183434.GG30645@1wt.eu>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="O5XBE6gyVG5Rl6Rj"
Content-Disposition: inline
In-Reply-To: <20110428183434.GG30645@1wt.eu>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--O5XBE6gyVG5Rl6Rj
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

(another CC added)

Hello Willy!

I made some statistics of our servers regarding kernel version and uptime.
Here are some my thoughts:
- I'm 100% sure this problem wasn't present in kernels <=3D 2.6.30.x (we've=
 got a lot of boxes with uptimes >600days)
- I'm 90% sure this problem also wasn't present in 2.6.32.16 (we've got 6 b=
oxes running for 235 to 280days)

What I'm not sure is, whether this is present in 2.6.19, I have:
2 boxes running 2.6.32.19 for 238days and one 2.6.32.20 for 216days.
I also have a bunch ov 2.6.32.23 boxes, which are now getting close to 200d=
ays uptime.
But I suspect this really is first problematic version, more on it later.=
=20
First regarding Your question about CONFIG_HZ - we use 250HZ setting, which=
 leads me to following:
250 * 60 * 60 * 24 * 199 =3D 4298400000 which is value a little over 2**32!=
 So maybe some unsingned long variable
might overflow? Does this make sense?

And to my suspicion about 2.6.32.19, there is one commit which maybe is rel=
ated:

commit 0cf55e1ec08bb5a22e068309e2d8ba1180ab4239
Author: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Date:   Wed Dec 2 17:28:07 2009 +0900

    sched, cputime: Introduce thread_group_times()
   =20
    This is a real fix for problem of utime/stime values decreasing
    described in the thread:
   =20
       http://lkml.org/lkml/2009/11/3/522
   =20
    Now cputime is accounted in the following way:
   =20
     - {u,s}time in task_struct are increased every time when the thread
       is interrupted by a tick (timer interrupt).
   =20
     - When a thread exits, its {u,s}time are added to signal->{u,s}time,
       after adjusted by task_times().
   =20
     - When all threads in a thread_group exits, accumulated {u,s}time
       (and also c{u,s}time) in signal struct are added to c{u,s}time
       in signal struct of the group's parent.
=2E
=2E
=2E

I haven't studied this into detail yet, but it seems to me it might really =
be related. Hidetoshi-san - do You have some opinion about this?
Could this somehow either create or invoke the problem with overflow of som=
e variable which would lead to division by zero or similar problems?

Any other thoughts?

best regards

nik





On Thu, Apr 28, 2011 at 08:34:34PM +0200, Willy Tarreau wrote:
> Hello Nikola,
>=20
> On Thu, Apr 28, 2011 at 10:26:25AM +0200, Nikola Ciprich wrote:
> > Hello everybody,
> >=20
> > I'm trying to solve strange issue, today, my fourth machine running 2.6=
=2E32.21 just crashed. What makes the cases similar, apart fromn same kerne=
l version is that all boxes had very similar uptimes: 214, 216, 216, and 22=
4 days. This might just be a coincidence, but I think this might be importa=
nt.
>=20
> Interestingly, one of our customers just had two machines who crashed
> yesterday after 212 days and 212+20h respectively. They were running
> debian's 2.6.32-bpo.5-amd64 which is based on 2.6.32.23 AIUI.
>=20
> The crash looks very similar to the following bug which we have updated :
>=20
>    https://bugzilla.kernel.org/show_bug.cgi?id=3D16991
>=20
> (bugzilla doesn't appear to respond as I'm posting this mail).
>=20
> The top of your ouput is missing. In our case as in the reports on the bug
> above, there was a divide by zero error. Did you happen to spot this one
> too, or do you just not know ? I observe "divide_error+0x15/0x20" in one
> of your reports, so it's possible that it matches the same pattern at lea=
st
> for one trace. Just in case, it would be nice to feed the bugzilla entry
> above.
>=20
> > Unfortunately I only have backtraces of two crashes (and those are trim=
med, sorry), and they do not look as similar as I'd like, but still maybe t=
here is something in common:
> >=20
> > [<ffffffff81120cc7>] pollwake+0x57/0x60=20
> > [<ffffffff81046720>] ? default_wake_function+0x0/0x10=20
> > [<ffffffff8103683a>] __wake_up_common+0x5a/0x90=20
> > [<ffffffff8103a313>] __wake_up+0x43/0x70=20
> > [<ffffffffa0321573>] process_masterspan+0x643/0x670 [dahdi]=20
> > [<ffffffffa0326595>] coretimer_func+0x135/0x1d0 [dahdi]=20
> > [<ffffffff8105d74d>] run_timer_softirq+0x15d/0x320=20
> > [<ffffffffa0326460>] ? coretimer_func+0x0/0x1d0 [dahdi]=20
> > [<ffffffff8105690c>] __do_softirq+0xcc/0x220=20
> > [<ffffffff8100c40c>] call_softirq+0x1c/0x30=20
> > [<ffffffff8100e3ba>] do_softirq+0x4a/0x80=20
> > [<ffffffff810567c7>] irq_exit+0x87/0x90=20
> > [<ffffffff8100d7b7>] do_IRQ+0x77/0xf0=20
> > [<ffffffff8100bc53>] ret_from_intr+0x0/Oxa=20
> > <EUI> [<ffffffffa019e556>] ? acpi_idle_enter_bm+0x273/0x2a1 [processor]=
=20
> > [<ffffffffa019e54c>] ? acpi_idle_enter_bm+0x269/0x2a1 [processor]=20
> > [<ffffffff81280095>] ? cpuidle_idle_call+0xa5/0x150=20
> > [<ffffffff8100a18f>] ? cpu_idle+0x4f/0x90=20
> > [<ffffffff81323c95>] ? rest_init+0x75/0x80=20
> > [<ffffffff81582d7f>] ? start_kernel+0x2ef/0x390=20
> > [<ffffffff81582271>] ? x86_64_start_reservations+0x81/0xc0=20
> > [<ffffffff81582386>] ? x86_64_start_kernel+0xd6/0x100=20
> >=20
> > this box (actually two of the crashed ones) is using dahdi_dummy module=
 to generate timing for asterisk SW pbx, so maybe it's related to it.
> >=20
> >=20
> > [<ffffffff810a5063>] handle_IRQ_event+0x63/0x1c0
> > [<ffffffff810a71ae>] handle_edge_irq+0xce/0x160
> > [<ffffffff8100e1bf>] handle_irq+0x1f/0x30                              =
                                                                           =
                                    =20
> > [<ffffffff8100d7ae>] do_IRQ+0x6e/0xf0
> > [<ffffffff8100bc53>] ret_from_intr+0x0/Oxa
> > <EUI> [<ffffffff8133?f?f>] ? _spin_un1ock_irq+0xf/0x40
> > [<ffffffff81337f79>] ? _spin_un1ock_irq+0x9/0x40
> > [<ffffffff81064b9a>] ? exit_signals+0x8a/0x130
> > [<ffffffff8105372e>] ? do_exit+0x7e/0x7d0
> > [<ffffffff8100f8a7>] ? oops_end+0xa7/0xb0
> > [<ffffffff8100faa6>] ? die+0x56/0x90
> > [<ffffffff8100c810>] ? do_trap+0x130/0x150
> > [<ffffffff8100ccca>] ? do_divide_error+0x8a/0xa0
> > [<ffffffff8103d227>] ? find_busiest_group+0x3d7/0xa00
> > [<ffffffff8104400b>] ? cpuacct_charge+0x6b/0x90
> > [<ffffffff8100c045>] ? divide_error+0x15/0x20
> > [<ffffffff8103d227>] ? find_busiest_group+0x3d7/0xa00
> > [<ffffffff8103cfff>] ? find_busiest_group+0x1af/0xa00
> > [<ffffffff81335483>] ? thread_return+0x4ce/0x7bb
> > [<ffffffff8133bec5>] ? do_nanosleep+0x75/0x30
> > [<ffffffff810?1?4e>] ? hrtimer_nanosleep+0x9e/0x120
> > [<ffffffff810?08f0>] ? hrtimer_wakeup+0x0/0x30
> > [<ffffffff810?183f>] ? sys_nanosleep+0x6f/0x80
> >=20
> > another two don't use it. only similarity I see here is that it seems t=
o be IRQ handling related, but both issues don't have anything in common.
> > Does anybody have an idea on where should I look? Of course I should up=
date all those boxes to (at least) latest 2.6.32.x, and I'll do it for sure=
, but still I'd first like to know where the problem was, and if it has bee=
n fixed, or how to fix it...
> > I'd be gratefull for any help...
>=20
> There were quite a bunch of scheduler updates recently. We may be lucky a=
nd
> hope for the bug to have vanished with the changes, but we may as well see
> the same crash in 7 months :-/
>=20
> My coworker Herv=E9 (CC'd) who worked on the issue suggests that we might=
 have
> something which goes wrong past a certain uptime (eg: 212 days), which ne=
eds
> a special event to be triggered (I/O, process exiting, etc...). I think t=
his
> makes quite some sense.
>=20
> Could you check your CONFIG_HZ so that we could convert those uptimes to
> jiffies ? Maybe this will ring a bell in someone's head :-/
>=20
> Best regards,
> Willy
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>=20

--=20
-------------------------------------
Ing. Nikola CIPRICH
LinuxBox.cz, s.r.o.
28. rijna 168, 709 01 Ostrava

tel.:   +420 596 603 142
fax:    +420 596 621 273
mobil:  +420 777 093 799
www.linuxbox.cz

mobil servis: +420 737 238 656
email servis: servis@linuxbox.cz
-------------------------------------

--O5XBE6gyVG5Rl6Rj
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk26jJgACgkQ3xdJJrLygV6KWACePCuy+eWmXmsDA0Apw7HZAl9g
YykAoOGhMD98AetpnQ3XNplMvy7s2eJW
=FWBn
-----END PGP SIGNATURE-----

--O5XBE6gyVG5Rl6Rj--
