Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758719Ab1ENTGs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 May 2011 15:06:48 -0400
Received: from gwu.lbox.cz ([62.245.111.132]:47693 "EHLO gwu.lbox.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757904Ab1ENTGq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 May 2011 15:06:46 -0400
Date: Sat, 14 May 2011 21:04:23 +0200
From: Nikola Ciprich <nikola.ciprich@linuxbox.cz>
To: Willy Tarreau <w@1wt.eu>
Cc: Faidon Liambotis <paravoid@debian.org>, linux-kernel@vger.kernel.org,
        stable@kernel.org, seto.hidetoshi@jp.fujitsu.com,
        =?iso-8859-1?Q?Herv=E9?= Commowick <hcommowick@exosec.fr>,
        Randy Dunlap <rdunlap@xenotime.net>, Greg KH <greg@kroah.com>,
        Ben Hutchings <ben@decadent.org.uk>,
        Apollon Oikonomopoulos <apoikos@gmail.com>, chronidev@gmail.com
Subject: Re: 2.6.32.21 - uptime related crashes?
Message-ID: <20110514190423.GA2264@nik-comp.lan>
References: <20110428082625.GA23293@pcnci.linuxbox.cz> <20110428183434.GG30645@1wt.eu> <20110429100200.GB23293@pcnci.linuxbox.cz> <20110430093605.GA10529@1wt.eu> <20110430173905.GA25641@tty.gr> <20110430201436.GF10529@1wt.eu>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Qxx1br4bt0+wmkIi"
Content-Disposition: inline
In-Reply-To: <20110430201436.GF10529@1wt.eu>
"X-PGP-Key: http://nik.lbox.cz/downloads/nikola.ciprich.asc"
User-Agent: Mutt/1.5.19 (2009-01-05)
X-Antivirus: on lbxovapx by Kaspersky antivirus, 5118768 records (last update: 20110514)
X-Spam-Score: N/A (trusted relay)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Qxx1br4bt0+wmkIi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello gentlemans,
Nicolas, thanks for further report, it contradicts my theory that problem o=
ccured somewhere during 2.6.32.16.
Now I think I know why several of my other machines running 2.6.32.x for lo=
ng time didn't crashed:

I checked bugzilla entry for (I believe the same) problem here:
https://bugzilla.kernel.org/show_bug.cgi?id=3D16991
and Peter Zijlstra asked there, whether reporters systems were running some=
 RT tasks. Then I realised that all of my four crashed boxes were pacemaker=
/corosync clusters and pacemaker uses lots of RT priority tasks. So I belie=
ve this is important, and might be reason why other machines seem to be run=
ning rock solid - they are not running any RT tasks.
It also might help with hunting this bug. Is somebody of You also running s=
ome RT priority tasks on inflicted systems, or problem also occured without=
 it?
Cheers!
n.

PS: Hidetoshi-san - btw, (late) thanks for Your reply and confirmation that=
 Your patch should not be the cause of this problem. I'm now sure it must h=
ave emerged sooner, and I'm sorry for this false accusation :)

On Sat, Apr 30, 2011 at 10:14:36PM +0200, Willy Tarreau wrote:
> Hi Faidon,
>=20
> On Sat, Apr 30, 2011 at 08:39:05PM +0300, Faidon Liambotis wrote:
> > If I may add some, hopefully useful, information to the thread:
> >=20
> > At work we have an HP c7000 blade enclosure. It's populated with 8 ProL=
iant
> > BL460c G1 (Xeon E5405, constant_tsc but not nonstop_tsc) and 4 ProLiant=
=20
> > BL460c
> > G6 (Xeon E5504, constant_tsc + nonstop_tsc). All were booted at the sam=
e day
> > with Debian's 2.6.32-23~bpo50+1 kernel, i.e. upstream 2.6.32.21.
> >=20
> > We too experienced problems with just the G6 blades at near 215 days=20
> > uptime (on the 19th of April), all at the same time. From our=20
> > investigation, it seems that their cpu_clocks jumped suddenly far in th=
e=20
> > future and then almost immediately rolled over due to wrapping around=
=20
> > 64-bits.
> >=20
> > Although all of their (G6s) clocks wrapped around *at the same time*, o=
nly=20
> > one
> > of them actually crashed at the time, with a second one crashing just a=
 few
> > days later, on the 28th.
> >=20
> > Three of them had the following on their logs:
> > Apr 18 20:56:07 hn-05 kernel: [17966378.581971] tap0: no IPv6 routers=
=20
> > present
> > Apr 19 10:15:42 hn-05 kernel: [18446743935.365550] BUG: soft lockup - C=
PU#4=20
> > stuck for 17163091968s! [kvm:25913]
> > [...]
> > Apr 19 10:15:42 hn-05 kernel: [18446743935.447275]  [<ffffffff81010b42>=
] ?=20
> > system_call_fastpath+0x16/0x1b
> > Apr 19 10:18:32 hn-05 kernel: [   31.587025] bond0.13: received packet =
with=20
> > own address as source address
> > (full oops at the end of this mail)
> >=20
> > Note that the 17163091968s time stuck was *the same* (+/- 1s) in *all
> > three of them*.
> >=20
> > What's also very strange, although we're not very sure if related, is
> > that when we took the first line of the above log entry and substracted
> > 17966378.581971 from Apr 18 20:56:07, this resulted in a boot-time that
> > differed several hours from the actual boot time (the latter being
> > verified both with syslog and /proc/bstat's btime, which were both in
> > agreement). This was verified post-mortem too, with the date checked to
> > be correct.
>=20
> Well, your report is by far the most complete of our 3 since you managed
> to get this trace of wraping time.
>=20
> I don't know if it means anything to anyone, but 17163091968 is exactly
> 0x3FF000000, or 1023*2^24. Too round to be a coincidence. This number
> of seconds corresponds to 1000 * 2^32 jiffies at 250 Hz.
>=20
> > IOW, we have some serious clock drift (calcuated it at runtime to
> > ~0.1s/min) on these machines that hasn't been made apparent probably
> > since they all run NTP. Moreover, we also saw that drift on other
> > machines (1U, different vendor, different data center, E5520 CPUs) but
> > not with the G1 blades. Our investigation showed that the drift is there
> > constantly (it's not a one-time event) but we're not really sure if it's
> > related with the Apr 18th jump event.  Note that the drift is there even
> > if we boot with "clocksource=3Dhpet" but disappears when booted with
> > "notsc". Also note that we've verified with 2.6.38 and the drift is
> > still there.
> >=20
> > Regards,
> > Faidon
> >=20
> > 1: The full backtrace is:
> > Apr 18 20:56:07 hn-05 kernel: [17966378.581971] tap0: no IPv6 routers=
=20
> > present
> > Apr 19 06:25:02 hn-05 kernel: imklog 3.18.6, log source =3D /proc/kmsg=
=20
> > started.
> > Apr 19 10:15:42 hn-05 kernel: [18446743935.365550] BUG: soft lockup - C=
PU#4=20
> > stuck for 17163091968s! [kvm:25913]
> > Apr 19 10:15:42 hn-05 kernel: [18446743935.447056] Modules linked in:=
=20
> > xt_pkttype ext2 tun kvm_intel kvm nf_conntrack_ipv6 ip6table_filter=20
> > ip6_tables xt_tcpudp nf_conntrack_ipv4 nf_
> > defrag_ipv4 xt_state nf_conntrack iptable_filter ip_tables x_tables 802=
1q=20
> > garp bridge stp bonding dm_round_robin dm_multipath scsi_dh ipmi_powero=
ff=20
> > ipmi_devintf loop snd_pcm snd_ti
> > mer snd soundcore bnx2x psmouse snd_page_alloc serio_raw sd_mod crc_t10=
dif=20
> > hpilo ipmi_si ipmi_msghandler container evdev crc32c pcspkr shpchp=20
> > pci_hotplug libcrc32c power_meter mdio
> > button processor ext3 jbd mbcache dm_mirror dm_region_hash dm_log=20
> > dm_snapshot dm_mod usbhid hid cciss ehci_hcd uhci_hcd qla2xxx=20
> > scsi_transport_fc usbcore nls_base tg3 libphy scsi_
> > tgt scsi_mod thermal fan thermal_sys [last unloaded: scsi_wait_scan]
> > Apr 19 10:15:42 hn-05 kernel: [18446743935.447111] CPU 4:
> > Apr 19 10:15:42 hn-05 kernel: [18446743935.447112] Modules linked in:=
=20
> > xt_pkttype ext2 tun kvm_intel kvm nf_conntrack_ipv6 ip6table_filter=20
> > ip6_tables xt_tcpudp nf_conntrack_ipv4 nf_
> > defrag_ipv4 xt_state nf_conntrack iptable_filter ip_tables x_tables 802=
1q=20
> > garp bridge stp bonding dm_round_robin dm_multipath scsi_dh ipmi_powero=
ff=20
> > ipmi_devintf loop snd_pcm snd_timer snd soundcore bnx2x psmouse=20
> > snd_page_alloc serio_raw sd_mod crc_t10dif hpilo ipmi_si ipmi_msghandle=
r=20
> > container evdev crc32c pcspkr shpchp pci_hotplug libcrc32c power_meter =
mdio=20
> > button processor ext3 jbd mbcache dm_mirror dm_region_hash dm_log=20
> > dm_snapshot dm_mod usbhid hid cciss ehci_hcd uhci_hcd qla2xxx=20
> > scsi_transport_fc usbcore nls_base tg3 libphy scsi_tgt scsi_mod thermal=
 fan=20
> > thermal_sys [last unloaded: scsi_wait_scan]
> > Apr 19 10:15:42 hn-05 kernel: [18446743935.447154] Pid: 25913, comm: kv=
m=20
> > Not tainted 2.6.32-bpo.5-amd64 #1 ProLiant BL460c G6
> > Apr 19 10:15:42 hn-05 kernel: [18446743935.447157] RIP:=20
> > 0010:[<ffffffffa02e209a>]  [<ffffffffa02e209a>]=20
> > kvm_arch_vcpu_ioctl_run+0x785/0xa44 [kvm]
> > Apr 19 10:15:42 hn-05 kernel: [18446743935.447177] RSP:=20
> > 0018:ffff88070065fd38  EFLAGS: 00000202
> > Apr 19 10:15:42 hn-05 kernel: [18446743935.447179] RAX: ffff88070065ffd=
8=20
> > RBX: ffff8804154ba860 RCX: ffff8804154ba860
> > Apr 19 10:15:42 hn-05 kernel: [18446743935.447182] RDX: ffff8804154ba8b=
9=20
> > RSI: ffff81004c818b10 RDI: ffff8100291a7d48
> > Apr 19 10:15:42 hn-05 kernel: [18446743935.447184] RBP: ffffffff8101166=
e=20
> > R08: 0000000000000000 R09: 0000000000000000
> > Apr 19 10:15:42 hn-05 kernel: [18446743935.447187] R10: 00007f1b2a2af07=
8=20
> > R11: ffffffff802f3405 R12: 0000000000000001
> > Apr 19 10:15:42 hn-05 kernel: [18446743935.447189] R13: 00000000154ba8b=
8=20
> > R14: ffff8804136ac000 R15: ffff8804154bbd48
> > Apr 19 10:15:42 hn-05 kernel: [18446743935.447192] FS: =20
> > 0000000042cbb950(0000) GS:ffff88042e440000(0000) knlGS:0000000000000000
> > Apr 19 10:15:42 hn-05 kernel: [18446743935.447195] CS:  0010 DS: 002b E=
S:=20
> > 002b CR0: 0000000080050033
> > Apr 19 10:15:42 hn-05 kernel: [18446743935.447197] CR2: 000000000000000=
8=20
> > CR3: 0000000260c41000 CR4: 00000000000026e0
> > Apr 19 10:15:42 hn-05 kernel: [18446743935.447200] DR0: 000000000000000=
0=20
> > DR1: 0000000000000000 DR2: 0000000000000000
> > Apr 19 10:15:42 hn-05 kernel: [18446743935.447202] DR3: 000000000000000=
0=20
> > DR6: 00000000ffff0ff0 DR7: 0000000000000400
> > Apr 19 10:15:42 hn-05 kernel: [18446743935.447205] Call Trace:
> > Apr 19 10:15:42 hn-05 kernel: [18446743935.447215]  [<ffffffffa02e2004>=
] ?=20
> > kvm_arch_vcpu_ioctl_run+0x6ef/0xa44 [kvm]
> > Apr 19 10:15:42 hn-05 kernel: [18446743935.447224]  [<ffffffff8100f79c>=
] ?=20
> > __switch_to+0x285/0x297
> > Apr 19 10:15:42 hn-05 kernel: [18446743935.447231]  [<ffffffffa02d49d1>=
] ?=20
> > kvm_vcpu_ioctl+0xf1/0x4e6 [kvm]
> > Apr 19 10:15:42 hn-05 kernel: [18446743935.447237]  [<ffffffff810240da>=
] ?=20
> > lapic_next_event+0x18/0x1d
> > Apr 19 10:15:42 hn-05 kernel: [18446743935.447245]  [<ffffffff8106fb77>=
] ?=20
> > tick_dev_program_event+0x2d/0x95
> > Apr 19 10:15:42 hn-05 kernel: [18446743935.447251]  [<ffffffff81047e29>=
] ?=20
> > finish_task_switch+0x3a/0xaf
> > Apr 19 10:15:42 hn-05 kernel: [18446743935.447258]  [<ffffffff810f9f5a>=
] ?=20
> > vfs_ioctl+0x21/0x6c
> > Apr 19 10:15:42 hn-05 kernel: [18446743935.447261]  [<ffffffff810fa4a8>=
] ?=20
> > do_vfs_ioctl+0x48d/0x4cb
> > Apr 19 10:15:42 hn-05 kernel: [18446743935.447268]  [<ffffffff81063fcd>=
] ?=20
> > sys_timer_settime+0x233/0x283
> > Apr 19 10:15:42 hn-05 kernel: [18446743935.447272]  [<ffffffff810fa537>=
] ?=20
> > sys_ioctl+0x51/0x70
> > Apr 19 10:15:42 hn-05 kernel: [18446743935.447275]  [<ffffffff81010b42>=
] ?=20
> > system_call_fastpath+0x16/0x1b
> > Apr 19 10:18:32 hn-05 kernel: [   31.587025] bond0.13: received packet =
with=20
> > own address as source address
>=20
> Regards,
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

--Qxx1br4bt0+wmkIi
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk3O0jcACgkQ3xdJJrLygV4BXQCdEOXmxQAg4pxq68mcjvyr4vii
8TQAmwQ5Q8tlsr08XOOkTWkIB3ICsPoB
=oTEu
-----END PGP SIGNATURE-----

--Qxx1br4bt0+wmkIi--
