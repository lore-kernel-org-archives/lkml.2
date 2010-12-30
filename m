Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753144Ab0L3XSe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Dec 2010 18:18:34 -0500
Received: from piggy.rz.tu-ilmenau.de ([141.24.4.8]:33250 "EHLO
	piggy.rz.tu-ilmenau.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752450Ab0L3XSd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Dec 2010 18:18:33 -0500
Date: Fri, 31 Dec 2010 00:17:55 +0100
From: "Mario 'BitKoenig' Holbe" <Mario.Holbe@TU-Ilmenau.DE>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Matt Mackall <mpm@selenic.com>, Herbert Xu <herbert@gondor.hengli.com.au>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.37-rc7: Regression: b43: crashes in hwrng_register()
Message-ID: <20101230231754.GA28335@darkside.kls.lan>
Mail-Followup-To: Mario 'BitKoenig' Holbe <Mario.Holbe@TU-Ilmenau.DE>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Matt Mackall <mpm@selenic.com>,
	Herbert Xu <herbert@gondor.hengli.com.au>,
	LKML <linux-kernel@vger.kernel.org>
References: <4D1A8200.4010609@lwfinger.net>
 <20101229195440.GD5838@darkside.kls.lan>
 <4D1BD2B0.4020101@lwfinger.net>
 <20101230012003.GA2665@darkside.kls.lan>
 <4D1BF056.3060909@lwfinger.net>
 <20101230143406.GA23219@darkside.kls.lan>
 <4D1CD161.4040107@lwfinger.net>
 <20101230204522.GC23219@darkside.kls.lan>
 <4D1D0C61.9050800@lwfinger.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="K8nIJk4ghYZn606h"
Content-Disposition: inline
In-Reply-To: <4D1D0C61.9050800@lwfinger.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--K8nIJk4ghYZn606h
Content-Type: multipart/mixed; boundary="17pEHd4RhPHOinZp"
Content-Disposition: inline


--17pEHd4RhPHOinZp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Dec 30, 2010 at 04:49:05PM -0600, Larry Finger wrote:
> Added the two listed maintainers for hardware randon-number generators and
> dropped the wireless and b43 lists.
>=20
> Matt and Herbert:
>=20
> There is a regression in 2.6.37-rcX relative to 2.6.36. The problem shows=
 as the
> following kernel BUG:
> [   30.313362] BUG: unable to handle kernel paging request at 60870667
> [   30.313372] IP: [<f8f4e3df>] hwrng_register+0x5f/0x14d [rng_core]
>=20
> Mario's box with this fault has two RNG devices - b43 and the one provide=
d by
> via-rng. Experimentation has shown that if b43 is registered first, then =
there
> is no problem; however if via-rng is first, then the above BUG is trigger=
ed when
> b43 registers its hardware rng. This problem is a regression in that one =
of the
> changes in 2.6.37 has b43 registering its rng later in the startup sequen=
ce.
=2E..
> Do you see any problems in the code in drivers/net/wireless/b43/main.c or
> drivers/char/hw_random/via-rng.c. As the latter seems to make b43 fail, I=
 am
> suspecting via-rng, but I have no proof.

I believe I can confirm the bug does not directly belong to b43:
I created a second via-rng driver (just copied via-rng.c to via-rng2.c
and changed the via_rng.name) and modprobed it. I blacklisted b43 to
keep it out of the game.

Virtually the same crash dump as with b43 shows up when I modprobe
via-rng2 after via-rng is loaded already.

Attached is a dmesg excerpt from a 2.6.37-rc7 kernel built with Larrys
hwrng_debug patch applied (which basically calls dump_stack() in
hwrng_register()).

objdump of hw_random/core.o:

00000380 <hwrng_register>:
hwrng_register():
/tmp/1/linux-source-2.6.37-rc7/drivers/char/hw_random/core.c:299
 380:   56                      push   %esi
=2E..
/tmp/1/linux-source-2.6.37-rc7/drivers/char/hw_random/core.c:315
 3d9:   8b 76 1c                mov    0x1c(%esi),%esi
 3dc:   83 ee 1c                sub    $0x1c,%esi
prefetch():
/tmp/1/linux-source-2.6.37-rc7/arch/x86/include/asm/processor.h:837
 3df:   8b 46 1c                mov    0x1c(%esi),%eax
 3e2:   8d 74 26 00             lea    0x0(%esi,%eiz,1),%esi
hwrng_register():
/tmp/1/linux-source-2.6.37-rc7/drivers/char/hw_random/core.c:315
 3e6:   81 fe f8 ff ff ff       cmp    $0xfffffff8,%esi

hw_random/core.c:
   313          /* Must not register two RNGs with the same name. */
   314          err =3D -EEXIST;
   315          list_for_each_entry(tmp, &rng_list, list) {
   316                  if (strcmp(tmp->name, rng->name) =3D=3D 0)
   317                          goto out_unlock;
   318          }


Larry: Thanks for your help!


regards
   Mario
--=20
Goethe war nicht gerne Minister. Er beschaeftigte sich lieber geistig.
                                            -- Lukasburger Stilblueten

--17pEHd4RhPHOinZp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="2.6.37-rc7+via-rng2.dmesg"
Content-Transfer-Encoding: quoted-printable

[   11.746521] VIA RNG detected
[   11.746526] Calling hwrng_register
[   11.746533] Pid: 770, comm: modprobe Not tainted 2.6.37-rc7-self #5
[   11.746536] Call Trace:
[   11.746546]  [<f90ed3ac>] ? hwrng_register+0x2c/0x14d [rng_core]
[   11.746554]  [<f90fa023>] ? mod_init+0x23/0x3b [via_rng]
[   11.746564]  [<c1003069>] ? do_one_initcall+0x68/0x10f
[   11.746574]  [<c105f0d3>] ? sys_init_module+0xca5/0xe36
[   11.746602]  [<c1008b1f>] ? sysenter_do_call+0x12/0x28
=2E..
[  106.660466] VIA RNG detected
[  106.660471] Calling hwrng_register
[  106.660478] Pid: 2673, comm: modprobe Not tainted 2.6.37-rc7-self #5
[  106.660482] Call Trace:
[  106.660500]  [<f90ed3ac>] ? hwrng_register+0x2c/0x14d [rng_core]
[  106.660510]  [<f830e023>] ? mod_init+0x23/0x3b [via_rng2]
[  106.660520]  [<c1003069>] ? do_one_initcall+0x68/0x10f
[  106.660532]  [<c105f0d3>] ? sys_init_module+0xca5/0xe36
[  106.660600]  [<c1008b1f>] ? sysenter_do_call+0x12/0x28
[  106.660630] BUG: unable to handle kernel paging request at 7268d4f3
[  106.660640] IP: [<f90ed3df>] hwrng_register+0x5f/0x14d [rng_core]
[  106.660658] *pdpt =3D 0000000033c0a001 *pde =3D 0000000000000000=20
[  106.660670] Oops: 0000 [#1] SMP=20
[  106.660678] last sysfs file: /sys/module/rng_core/initstate
[  106.660687] Modules linked in: via_rng2(+) uinput via drm rfcomm sco bne=
p l2cap crc16 parport_pc ppdev lp parport sbs sbshc power_meter pci_slot he=
d fan container acpi_cpufreq mperf cpufreq_conservative cpufreq_userspace c=
pufreq_stats cpufreq_powersave dm_crypt fuse loop eeprom via_cputemp i2c_de=
v nvram padlock_aes aes_i586 aes_generic padlock_sha sha256_generic sha1_ge=
neric via_rng rng_core msr cpuid snd_hda_codec_realtek snd_hda_intel snd_hd=
a_codec snd_hwdep snd_pcm_oss snd_mixer_oss joydev snd_pcm snd_seq_midi snd=
_rawmidi snd_seq_midi_event snd_seq snd_timer snd_seq_device snd uvcvideo v=
ideodev v4l1_compat btusb ideapad_laptop soundcore video tpm_tis bluetooth =
psmouse i2c_viapro pcspkr tpm battery ac tpm_bios i2c_core evdev serio_raw =
power_supply snd_page_alloc output processor rfkill shpchp wmi pci_hotplug =
button ext3 jbd mbcache raid10 raid456 async_raid6_recov async_pq raid6_pq =
async_xor xor async_memcpy async_tx raid1 raid0 multipath linear md_mod dm_=
mirror dm_region_hash dm_log dm_mod btrfs zlib_deflate crc32c libcrc32c sd_=
mod crc_t10dif ata_generic pata_via libata ssb uhci_hcd via_sdmmc ehci_hcd =
usbcore scsi_mod tg3 pcmcia mmc_core pcmcia_core libphy thermal thermal_sys=
 nls_base [last unloaded: scsi_wait_scan]
[  106.660952]=20
[  106.660963] Pid: 2673, comm: modprobe Not tainted 2.6.37-rc7-self #5 Mou=
tCook/20021,2959
[  106.660975] EIP: 0060:[<f90ed3df>] EFLAGS: 00010216 CPU: 0
[  106.660987] EIP is at hwrng_register+0x5f/0x14d [rng_core]
[  106.660996] EAX: ffffffff EBX: f829e26c ECX: f90ed589 EDX: f829e267
[  106.661006] ESI: 7268d4d7 EDI: f3c7eac0 EBP: f830e000 ESP: f72b9f14
[  106.661015]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
[  106.661025] Process modprobe (pid: 2673, ti=3Df72b8000 task=3Df3ce30c0 t=
ask.ti=3Df72b8000)
[  106.661033] Stack:
[  106.661037]  ffffffed 00000000 f830e023 f829e226 f829e290 c1003069 00000=
000 f829e290
[  106.661055]  00000000 f3c7eac0 00000001 c105f0d3 00000017 f829e2d8 00000=
00a f829ac04
[  106.661072]  f3c7eac0 00000025 f829e3e0 f829a000 000010d4 f829a86c f829a=
788 f829ae7c
[  106.661090] Call Trace:
[  106.661102]  [<f830e023>] ? mod_init+0x23/0x3b [via_rng2]
[  106.661114]  [<c1003069>] ? do_one_initcall+0x68/0x10f
[  106.661126]  [<c105f0d3>] ? sys_init_module+0xca5/0xe36
[  106.661188]  [<c1008b1f>] ? sysenter_do_call+0x12/0x28
[  106.661195] Code: 1b c8 8b 35 1c d6 0e f9 59 83 ee 1c eb 1d 8b 13 8b 06 =
e8 84 16 06 c8 85 c0 75 0a be ef ff ff ff e9 d3 00 00 00 8b 76 1c 83 ee 1c =
<8b> 46 1c 0f 18 00 90 81 fe 00 d6 0e f9 75 d4 83 3d 2c d8 0e f9=20
[  106.661280] EIP: [<f90ed3df>] hwrng_register+0x5f/0x14d [rng_core] SS:ES=
P 0068:f72b9f14
[  106.661300] CR2: 000000007268d4f3
[  106.661309] ---[ end trace 4fa39662da4e519f ]---

--17pEHd4RhPHOinZp--

--K8nIJk4ghYZn606h
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEVAwUBTR0TIhS+e2HeSPbpAQJJ6ggAkttoDFSFupSh+Hn+Iw6jR+cm0ipThVUI
PTOBQ8D3gvQ/sxNXzFub1FoaYjYkVpmkLS0bCDhB8rhrrw5QpBIzBBubaO0LQloR
odDnDkKjTji/xlhFTrXmPvArAryAINSXGWSDe0hY7GQ9oNNfX0JBgWerUBsoTTaZ
Pvd+DYg92bZidnBxAVUj3ez2OpB2IlDmPOBVs6roN40q8nHvmPTXVD69k2PrnRSo
eaN0YkcX+D+UoE+qmcRZMNxWqB8bd/TSMI6t/GdEMxIW+bB0ca4k6joyFQaeromN
1Iu3cmaEnrea+EfL5nVAi4zz0d4++vbAKZeojyHgy6TiwQekcQLQYw==
=EilK
-----END PGP SIGNATURE-----

--K8nIJk4ghYZn606h--
