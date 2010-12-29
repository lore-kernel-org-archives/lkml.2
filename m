Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752678Ab0L2TzK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Dec 2010 14:55:10 -0500
Received: from piggy.rz.tu-ilmenau.de ([141.24.4.8]:45307 "EHLO
	piggy.rz.tu-ilmenau.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752440Ab0L2TzB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Dec 2010 14:55:01 -0500
Date: Wed, 29 Dec 2010 20:54:40 +0100
From: "Mario 'BitKoenig' Holbe" <Mario.Holbe@TU-Ilmenau.DE>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: LKML <linux-kernel@vger.kernel.org>,
        wireless <linux-wireless@vger.kernel.org>,
        b43-dev <b43-dev@lists.infradead.org>
Subject: Re: 2.6.37-rc7: Regression: b43: crashes in hwrng_register()
Message-ID: <20101229195440.GD5838@darkside.kls.lan>
Mail-Followup-To: Mario 'BitKoenig' Holbe <Mario.Holbe@TU-Ilmenau.DE>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	LKML <linux-kernel@vger.kernel.org>,
	wireless <linux-wireless@vger.kernel.org>,
	b43-dev <b43-dev@lists.infradead.org>
References: <4D1A8200.4010609@lwfinger.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="4ZLFUWh1odzi/v6L"
Content-Disposition: inline
In-Reply-To: <4D1A8200.4010609@lwfinger.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--4ZLFUWh1odzi/v6L
Content-Type: multipart/mixed; boundary="A6N2fC+uXW/VQSAv"
Content-Disposition: inline


--A6N2fC+uXW/VQSAv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello Larry,

On Tue, Dec 28, 2010 at 06:34:08PM -0600, Larry Finger wrote:
> Mario Holbe wrote:
> > on 2.6.37-rc7 the b43 driver crashes in hwrng_register(). This makes the
=2E..
> > This issue does also exist in 2.6.37-rc5.
> > This issue does not exist in 2.6.36.2.
=2E..
> > [ 29.868632] BUG: unable to handle kernel paging request at 907cde0c
> > [ 29.868640] IP: [<f8d543cc>] hwrng_register+0x4c/0x139 [rng_core]
=2E..
> > [ 29.868884] Call Trace:
> > [ 29.868909] [<f8e5a870>] ? b43_wireless_core_init+0xd0c/0xdd6 [b43]
>=20
> I almost missed this posting.

You're welcome :)

> Please post wireless problems with
> linux-wireless@vger.kernel.org for better visibility.

Sorry and thanks for completing the CC: list.

> I have a BCM4312 (14e4:4315) on a netbook that does not have this problem=
, thus
> I will have to rely on your debugging. An additional difficulty is that t=
he only
> changes to b43 between 2.6.36 and 2.6.37 are adding an additional PCI ID,=
 some
> fixes to the SDIO driver, and some code for an 802.11n device. None of th=
ese
> should affect your 802.11 b/g unit.
>=20
> Is it possible for you to bisect between 2.6.36 and 2.6.37-rc5? I wish I =
could
> suggest some way to minimize the number of commits and builds, but the pr=
oblem
> could be anywhere.

To be honest, I never bisected such a huge amount of commits before and
I'm somewhat afraid of doing it.

However, I think I'm able to nail the issue down to:
commit 84c164a34ffe67908a932a2d641ec1a80c2d5435 which went to 2.6.37-rc1.
Author: John W. Linville <linville@tuxdriver.com>
Date:   Fri Aug 6 15:31:45 2010 -0400

    b43: move hwrng registration driver to wireless core initialization

Message-ID: <1281126412-5089-1-git-send-email-linville@tuxdriver.com>
http://marc.info/?l=3Dlinux-wireless&m=3D128112658829379&w=3D2

I did 2 things:
1. I (manually) reverted 84c164a34ffe67908a932a2d641ec1a80c2d5435 from
   2.6.37-rc7: The crash disappears, b43 is useable.
2. I added 84c164a34ffe67908a932a2d641ec1a80c2d5435 to 2.6.36.2: The
   crash shows up as with vanilla 2.6.37-rc7.

I'm not sure why this is not reproducible for you, probably it has
something to do with the VIA Nano having a second HW-RNG driven by
via-rng. I experienced crashes in the past with earlier kernels when I
tried to move RNGs around via /sys/devices/virtual/misc/hw_random, but
never took the time to trace them down since I just got it working :)

Oh, I'm still able to trigger a crash with
$ cat /sys/devices/virtual/misc/hw_random/rng_available
on 2.6.37-rc7 without 84c164a34ffe67908a932a2d641ec1a80c2d5435 as well
as on vanilla 2.6.36.2. Probably this is (better) reproducible for you?

I suspect both (the 84c164a34ffe67908a932a2d641ec1a80c2d5435 crash as
well as the cat rng_available crash) having something to do with a
partially uninitialized rng-struct, or better: parts of the rng-struct
that are free()d too early (i.e. within its lifetime).


regards
   Mario
--=20
Doing it right is no excuse for not meeting the schedule.
                                -- Plant Manager, Delphi Corporation

--A6N2fC+uXW/VQSAv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="2.6.36.2.rng_available-crash.dmesg"
Content-Transfer-Encoding: quoted-printable

[  389.303538] BUG: unable to handle kernel paging request at 288dcb5b
[  389.303553] IP: [<f8dda34c>] hwrng_attr_available_show+0x5c/0x90 [rng_co=
re]
[  389.303582] *pde =3D 00000000=20
[  389.303591] Oops: 0000 [#1] SMP=20
[  389.303599] last sysfs file: /sys/devices/virtual/misc/hw_random/rng_ava=
ilable
[  389.303609] Modules linked in: uinput via drm sco bnep rfcomm l2cap crc1=
6 parport_pc ppdev lp parport sbs sbshc power_meter pci_slot hed fan contai=
ner acpi_cpufreq mperf cpufreq_conservative cpufreq_userspace cpufreq_stats=
 cpufreq_powersave dm_crypt fuse loop eeprom via_cputemp i2c_dev nvram padl=
ock_aes aes_i586 aes_generic padlock_sha sha256_generic sha1_generic via_rn=
g msr cpuid snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_hwdep snd=
_pcm_oss snd_mixer_oss snd_pcm arc4 joydev ecb snd_seq_midi b43 rng_core sn=
d_rawmidi snd_seq_midi_event mac80211 snd_seq uvcvideo video snd_timer cfg8=
0211 snd_seq_device videodev v4l1_compat ideapad_laptop snd btusb i2c_viapr=
o led_class sparse_keymap bluetooth tpm_tis tpm wmi output i2c_core battery=
 tpm_bios shpchp processor ac soundcore rfkill pcspkr pci_hotplug snd_page_=
alloc psmouse button serio_raw evdev ext3 jbd mbcache raid10 raid456 async_=
raid6_recov async_pq raid6_pq async_xor xor async_memcpy async_tx raid1 rai=
d0 multipath linear md_mod dm_mirror dm_region_hash dm_log dm_mod btrfs zli=
b_deflate crc32c libcrc32c sd_mod crc_t10dif ata_generic pata_via libata uh=
ci_hcd ehci_hcd ssb scsi_mod usbcore tg3 via_sdmmc pcmcia mmc_core libphy t=
hermal thermal_sys pcmcia_core nls_base [last unloaded: scsi_wait_scan]
[  389.303871]=20
[  389.303882] Pid: 3004, comm: cat Not tainted 2.6.36.2 #1 MoutCook/20021,=
2959
[  389.303893] EIP: 0060:[<f8dda34c>] EFLAGS: 00010216 CPU: 0
[  389.303908] EIP is at hwrng_attr_available_show+0x5c/0x90 [rng_core]
[  389.303918] EAX: f5da2000 EBX: 288dcb3f ECX: 00000ff1 EDX: f8dda571
[  389.303928] ESI: f5da2000 EDI: 0000000d EBP: 00000fff ESP: f6841f30
[  389.303937]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
[  389.303948] Process cat (pid: 3004, ti=3Df6840000 task=3Df5c9f180 task.t=
i=3Df6840000)
[  389.303955] Stack:
[  389.303960]  f8dda618 fffffffb f8dda2f0 c12b1834 c11bd17e f5ccaf40 f69fe=
330 f6841f9c
[  389.303978] <0> c10f8244 f5d9bcc0 f5ccaf54 f69c7e08 09a66000 00008000 f5=
d9bcc0 09a66000
[  389.303997] <0> c10f81b8 f6841f9c c10b7774 f6841f9c c1282259 f5d9bcc0 ff=
fffff7 09a66000
[  389.304015] Call Trace:
[  389.304015]  [<f8dda2f0>] ? hwrng_attr_available_show+0x0/0x90 [rng_core]
[  389.304015]  [<c11bd17e>] ? dev_attr_show+0x16/0x32
[  389.304015]  [<c10f8244>] ? sysfs_read_file+0x8c/0xf5
[  389.304015]  [<c10f81b8>] ? sysfs_read_file+0x0/0xf5
[  389.304015]  [<c10b7774>] ? vfs_read+0x7c/0xd6
[  389.304015]  [<c1282259>] ? do_page_fault+0x26d/0x2cf
[  389.304015]  [<c10b7861>] ? sys_read+0x3c/0x60
[  389.304015]  [<c1002f1f>] ? sysenter_do_call+0x12/0x28
[  389.304015] Code: e9 89 f0 29 f9 e8 ef 63 36 c8 8b 03 e8 60 64 36 c8 89 =
e9 ba 71 a5 dd f8 8d 3c 38 89 f0 29 f9 47 e8 d4 63 36 c8 8b 5b 1c 83 eb 1c =
<8b> 43 1c 0f 18 00 90 81 fb d0 a5 dd f8 75 c3 b9 ff 0f 00 00 ba=20
[  389.304015] EIP: [<f8dda34c>] hwrng_attr_available_show+0x5c/0x90 [rng_c=
ore] SS:ESP 0068:f6841f30
[  389.304015] CR2: 00000000288dcb5b
[  389.304311] ---[ end trace a1f28568aee0d057 ]---

--A6N2fC+uXW/VQSAv--

--4ZLFUWh1odzi/v6L
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEVAwUBTRuSABS+e2HeSPbpAQKQuQf/WyjEGm9+kdAjBNSrNTRM1J2+tzhus5EY
9HTyiT38O6ItgdYcuI4w+XlZlw5h2uP9S2P5e+dLTeqs50HQqTn/gap/8z8fsxAV
3z+Y//tnhk0Hij9TOkxds8IwuAHj5S2fyK8iXWJzV1F7LO4iZgs4VuzY3uHkIZNI
GhgUU5KS+a8LO+ICQRFb+rsnxYLHBaqut9XL8L9LfBNshdCo7AEjcSzjk/YAOtNC
umWa4zwdOwAzL+piyGWI84xmFqnnt852/p8PQ9ct7G/xKD1LdOYN5CcF4ZQv7G4G
SdzLQnU/o5TwX6l3fCYNe9Wxzl17dLK7STtQSICCF+zPGkJu0BnF/g==
=O6GG
-----END PGP SIGNATURE-----

--4ZLFUWh1odzi/v6L--
