Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753153Ab0LaC3Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Dec 2010 21:29:24 -0500
Received: from piggy.rz.tu-ilmenau.de ([141.24.4.8]:52445 "EHLO
	piggy.rz.tu-ilmenau.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752993Ab0LaC3W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Dec 2010 21:29:22 -0500
Date: Fri, 31 Dec 2010 03:25:51 +0100
From: "Mario 'BitKoenig' Holbe" <Mario.Holbe@TU-Ilmenau.DE>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Herbert Xu <herbert@gondor.hengli.com.au>, Matt Mackall <mpm@selenic.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Harald Welte <HaraldWelte@viatech.com>,
        Michal Ludvig <michal@logix.cz>
Subject: Re: 2.6.37-rc7: Regression: b43: crashes in hwrng_register()
Message-ID: <20101231022550.GA2512@darkside.kls.lan>
Mail-Followup-To: Mario 'BitKoenig' Holbe <Mario.Holbe@TU-Ilmenau.DE>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Herbert Xu <herbert@gondor.hengli.com.au>,
	Matt Mackall <mpm@selenic.com>, LKML <linux-kernel@vger.kernel.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Harald Welte <HaraldWelte@viatech.com>,
	Michal Ludvig <michal@logix.cz>
References: <20101229195440.GD5838@darkside.kls.lan>
 <4D1BD2B0.4020101@lwfinger.net>
 <20101230012003.GA2665@darkside.kls.lan>
 <4D1BF056.3060909@lwfinger.net>
 <20101230143406.GA23219@darkside.kls.lan>
 <4D1CD161.4040107@lwfinger.net>
 <20101230204522.GC23219@darkside.kls.lan>
 <4D1D0C61.9050800@lwfinger.net>
 <20101231003735.GA24101@gondor.apana.org.au>
 <4D1D27E7.7030301@lwfinger.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="TakKZr9L6Hm6aLOc"
Content-Disposition: inline
In-Reply-To: <4D1D27E7.7030301@lwfinger.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--TakKZr9L6Hm6aLOc
Content-Type: multipart/mixed; boundary="d6Gm4EdcadzBjdND"
Content-Disposition: inline


--d6Gm4EdcadzBjdND
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Dec 30, 2010 at 06:46:31PM -0600, Larry Finger wrote:
> On 12/30/2010 06:37 PM, Herbert Xu wrote:
> > My suspicion is that VIA's xstore is writing more than 4 bytes as
> > the list pointer happens to lie immediately after rng->priv which
> > is where xstore is writing to.
> >=20
> > Harald, do you know whether this is documented or is this a known
> > errata item?
>=20
> The following patch should be able to test if xstore is overwriting the l=
ist
> pointer.

Confirmed. No crashes with the junk buffer in action.
I applied both patches (dump_stack() in hwrng_register() and junk[]
after priv data) to vanilla 2.6.37-rc7 and tested both: via-rng and my
via+rng2 as well as via-rng and b43-rng - no crashes. The (previously
also crashing) `cat rng_available' does survive as well:

$ cat /sys/devices/virtual/misc/hw_random/rng_available
via b43_phy0 via2=20
$=20

Attached 2 dmesg excerpts.


regards & g'nite
   Mario
--=20
Tower: "Say fuelstate." Pilot: "Fuelstate."
Tower: "Say again." Pilot: "Again."
Tower: "Arghl, give me your fuel!" Pilot: "Sorry, need it by myself..."

--d6Gm4EdcadzBjdND
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="2.6.37-rc7+via-rng2.dmesg"

[   11.606134] VIA RNG detected
[   11.606139] Calling hwrng_register
[   11.606145] Pid: 752, comm: modprobe Not tainted 2.6.37-rc7-self #1
[   11.606149] Call Trace:
[   11.606159]  [<f90c33ac>] ? hwrng_register+0x2c/0x14d [rng_core]
[   11.606167]  [<f90d0023>] ? mod_init+0x23/0x3b [via_rng]
[   11.606176]  [<c1003069>] ? do_one_initcall+0x68/0x10f
[   11.606186]  [<c105f0d3>] ? sys_init_module+0xca5/0xe36
[   11.606214]  [<c1008b1f>] ? sysenter_do_call+0x12/0x28
...
[   92.687121] VIA RNG detected
[   92.687126] Calling hwrng_register
[   92.687132] Pid: 2698, comm: modprobe Not tainted 2.6.37-rc7-self #1
[   92.687136] Call Trace:
[   92.687152]  [<f90c33ac>] ? hwrng_register+0x2c/0x14d [rng_core]
[   92.687161]  [<f8274023>] ? mod_init+0x23/0x3b [via_rng2]
[   92.687171]  [<c1003069>] ? do_one_initcall+0x68/0x10f
[   92.687181]  [<c105f0d3>] ? sys_init_module+0xca5/0xe36
[   92.687227]  [<c1008b1f>] ? sysenter_do_call+0x12/0x28

--d6Gm4EdcadzBjdND
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="2.6.37-rc7+via-rng2+b43.dmesg"

[   11.686811] VIA RNG detected
[   11.686816] Calling hwrng_register
[   11.686822] Pid: 807, comm: modprobe Not tainted 2.6.37-rc7-self #1
[   11.686826] Call Trace:
[   11.686839]  [<f8fb23ac>] ? hwrng_register+0x2c/0x14d [rng_core]
[   11.686847]  [<f923f023>] ? mod_init+0x23/0x3b [via_rng]
[   11.686856]  [<c1003069>] ? do_one_initcall+0x68/0x10f
[   11.686867]  [<c105f0d3>] ? sys_init_module+0xca5/0xe36
[   11.686897]  [<c1008b1f>] ? sysenter_do_call+0x12/0x28
...
[   29.964239] b43-pci-bridge 0000:02:00.0: PCI: Disallowing DAC for device
[   29.964251] b43-phy0: DMA mask fallback from 64-bit to 32-bit
[   29.984626] Calling hwrng_register
[   29.984640] Pid: 1550, comm: NetworkManager Not tainted 2.6.37-rc7-self #1
[   29.984648] Call Trace:
[   29.984688]  [<f8fb23ac>] ? hwrng_register+0x2c/0x14d [rng_core]
[   29.984729]  [<f8ffe879>] ? b43_wireless_core_init+0xd12/0xddf [b43]
[   29.984759]  [<f8ffed73>] ? b43_op_start+0xf8/0x142 [b43]
[   29.984796]  [<f8d463da>] ? cfg80211_netdev_notifier_call+0x342/0x355 [cfg80211]
[   29.984853]  [<f8f1a889>] ? ieee80211_do_open+0xed/0x45f [mac80211]
[   29.984886]  [<f8f19e7a>] ? ieee80211_check_concurrent_iface+0x1c/0x135 [mac80211]
[   29.984908]  [<c1203247>] ? __dev_open+0x7d/0xa7
[   29.984922]  [<c1201c10>] ? __dev_change_flags+0x9a/0x10d
[   29.984934]  [<c120319f>] ? dev_change_flags+0x10/0x3b
[   29.984949]  [<c120d207>] ? do_setlink+0x23e/0x532
[   29.984965]  [<c120d5cb>] ? rtnl_setlink+0xd0/0xe1
[   29.984986]  [<c114f000>] ? clear_user+0x2b/0x43
[   29.984997]  [<c120d4fb>] ? rtnl_setlink+0x0/0xe1
[   29.985008]  [<c120cd32>] ? rtnetlink_rcv_msg+0x186/0x19c
[   29.985020]  [<c120cbac>] ? rtnetlink_rcv_msg+0x0/0x19c
[   29.985034]  [<c121bda8>] ? netlink_rcv_skb+0x2d/0x72
[   29.985046]  [<c120cba6>] ? rtnetlink_rcv+0x18/0x1e
[   29.985056]  [<c121bbfc>] ? netlink_unicast+0xba/0x10e
[   29.985068]  [<c121c700>] ? netlink_sendmsg+0x23d/0x256
[   29.985082]  [<c11f53a6>] ? __sock_sendmsg+0x48/0x4e
[   29.985093]  [<c11f560f>] ? sock_sendmsg+0x78/0x8f
[   29.985105]  [<c11f560f>] ? sock_sendmsg+0x78/0x8f
[   29.985119]  [<c10cf5dd>] ? d_kill+0x38/0x3d
[   29.985137]  [<c11fd48c>] ? verify_iovec+0x3d/0x79
[   29.985147]  [<c11f5e0d>] ? sys_sendmsg+0x15f/0x1c1
[   29.985159]  [<c11f5a44>] ? sockfd_lookup_light+0x13/0x3f
[   29.985170]  [<c11f60a5>] ? sys_sendto+0xfd/0x121
[   29.985182]  [<c11f996b>] ? sk_prot_alloc+0x62/0xd6
[   29.985195]  [<c10079ee>] ? __switch_to+0x6f/0xe2
[   29.985213]  [<c129ced6>] ? schedule+0x579/0x5b6
[   29.985225]  [<c11f5ca3>] ? sys_recvmsg+0x3c/0x47
[   29.985236]  [<c11f707d>] ? sys_socketcall+0x17f/0x1cb
[   29.985249]  [<c1008b1f>] ? sysenter_do_call+0x12/0x28
[   29.987285] ADDRCONF(NETDEV_UP): wlan0: link is not ready
...
[   99.003298] VIA RNG detected
[   99.003303] Calling hwrng_register
[   99.003309] Pid: 2797, comm: modprobe Not tainted 2.6.37-rc7-self #1
[   99.003313] Call Trace:
[   99.003332]  [<f8fb23ac>] ? hwrng_register+0x2c/0x14d [rng_core]
[   99.003341]  [<f8281023>] ? mod_init+0x23/0x3b [via_rng2]
[   99.003350]  [<c1003069>] ? do_one_initcall+0x68/0x10f
[   99.003360]  [<c105f0d3>] ? sys_init_module+0xca5/0xe36
[   99.003403]  [<c1008b1f>] ? sysenter_do_call+0x12/0x28

--d6Gm4EdcadzBjdND--

--TakKZr9L6Hm6aLOc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEVAwUBTR0/LhS+e2HeSPbpAQKS6wf/YPz29XP5ZZdQKfTXlhxCxv6iVUkiUFr9
s/ivtGOaguWH7m5rlgRx/oJlh5eSKElvg3RbUl6wu4ibHTXjD8M52Hn1onPg+u2w
uPXxUv+7Pl/GxEyFfGUvTO+t5EMaayFpkVlFi0vHR9PGzWkbhku0iQKELwYsgObL
VNXsw7I75zJNIqPpw2gaLRxWMtEFIC8qM1ZNr+xIDFuBhXdU8TfYBeRvTdDtkXPp
gmbKN63m5Hiojrovryhz37p6hhKvPcU/y1+48yqdCLU7ht83mYjChQTGcoJxKGbe
RXBqKpZSp3hC33w0YS/Psvn2X7HTTJ7oOXhwOdnJQbtktD3tw+E6Ug==
=9hHs
-----END PGP SIGNATURE-----

--TakKZr9L6Hm6aLOc--
