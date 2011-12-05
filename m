Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755961Ab1LESmW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 13:42:22 -0500
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:60699 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755611Ab1LESmV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 13:42:21 -0500
Date: Mon, 5 Dec 2011 19:42:16 +0100
From: Borislav Petkov <bp@amd64.org>
To: Ewan Higgs <ewan_higgs@yahoo.co.uk>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Yaroslav Fedevych <jaroslaw.fedewicz@gmail.com>
Subject: Re: [Bug?] Machine hangs, rtl8192se possible cause
Message-ID: <20111205184216.GC31275@gere.osrc.amd.com>
References: <1323109235.85169.YahooMailNeo@web24612.mail.ird.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1323109235.85169.YahooMailNeo@web24612.mail.ird.yahoo.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 05, 2011 at 06:20:35PM +0000, Ewan Higgs wrote:
> Hello LKML,
> I appear to be having trouble which resembles Jaroslaw Fedewicz's problems with the rtl8192se driver from August[1]. I was curious if there was progress on the problem and what I might be able to do to help.
> 
> Multiple times a day, my machine hangs with the most recent activity in the syslog being a disconnect, a reconnect, and then a root cron job which accesses the network. Sometimes I get a kernel BUG trace from corrupt memory. syslog also reports that the most recent thing before the memory corruption was the disconnect and reconnect.
> 
> Here are some examples of the syslog details from a hang (with some judicious cutting) [3].
> 
> Here's another hang I had later in the day: [4]

Well,

if it is rtl8192se, a nasty hang got fixed recently and the fix is in
the wireless-testing tree:

git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-testing.git

It should be e55b32c110b025ce07b40227f620e99700bf8741

[..]

> Dec  5 14:54:56 scarlet kernel: [11015.129050] /build/buildd-linux-2.6_3.1.1-1-amd64-A9YWBe/linux-2.6-3.1.1/debian/build/source_amd64_none/mm/memory.c:414: bad pmd ffff880232daa180(0000000232dac077).

This looks nasty but it could be caused by the proprietary nvidia
module. You could try running without it to see whether the random
corruptions go away.

> Dec  5 14:54:56 scarlet kernel: [11015.129168] ------------[ cut here ]------------
> Dec  5 14:54:56 scarlet kernel: [11015.129177] kernel BUG at /build/buildd-linux-2.6_3.1.1-1-amd64-A9YWBe/linux-2.6-3.1.1/debian/build/source_amd64_none/mm/mmap.c:2274!
> Dec  5 14:54:56 scarlet kernel: [11015.129186] invalid opcode: 0000 [#1] SMP 
> Dec  5 14:54:56 scarlet kernel: [11015.129194] CPU 4 
> Dec  5 14:54:56 scarlet kernel: [11015.129197] Modules linked in: nls_utf8 nls_cp437 vfat fat cryptd aes_x86_64 aes_generic ip6table_filter ip6_tables iptable_filter ip_tables ebtable_nat ebtables x_tables parport_pc ppdev lp parport bnep powernow_k8 rfcomm mperf bluetooth cpufreq_userspace cpufreq_stats cpufreq_powersave cpufreq_conservative crc16 binfmt_misc fuse nfsd nfs lockd fscache auth_rpcgss nfs_acl sunrpc firewire_sbp2 loop kvm_amd kvm snd_hda_codec_hdmi joydev nvidia(P) snd_hda_codec_realtek snd_hda_intel snd_hda_codec arc4 snd_pcm_oss snd_hwdep snd_mixer_oss snd_pcm snd_seq_midi snd_rawmidi snd_seq_midi_event snd_seq rtl8192se rtlwifi mac80211 snd_timer snd_seq_device sp5100_tco snd psmouse pcspkr edac_core soundcore evdev serio_raw cfg80211 i2c_piix4 edac_mce_amd snd_page_alloc k10temp i2c_core rfkill asus_atk0110 processor wmi button thermal_sys ext3 jbd mbcache btrfs zlib_deflate crc32c libcrc32c dm_mod usb_storage uas sr_mod usbhid hid
>  cdrom sd_mod ata_generic crc_t10dif ohci_hcd xhci_hcd pata_jmic
> Dec  5 14:54:56 scarlet kernel: ron firewire_ohci ehci_hcd r8169 pata_atiixp mii firewire_core crc_itu_t ahci libahci usbcore libata scsi_mod [last unloaded: scsi_wait_scan]
> Dec  5 14:54:56 scarlet kernel: [11015.129374] 
> Dec  5 14:54:56 scarlet kernel: [11015.129381] Pid: 16269, comm: sh Tainted: P           O 3.1.0-1-amd64 #1 System manufacturer System Product Name/M4A89TD PRO USB3
> Dec  5 14:54:56 scarlet kernel: [11015.129395] RIP: 0010:[<ffffffff810d02be>]  [<ffffffff810d02be>] exit_mmap+0xd6/0xe1
> Dec  5 14:54:56 scarlet kernel: [11015.129412] RSP: 0018:ffff880232da3c58  EFLAGS: 00010202
> Dec  5 14:54:56 scarlet kernel: [11015.129419] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000008
> Dec  5 14:54:56 scarlet kernel: [11015.129426] RDX: 0000000000000072 RSI: ffff8800bc802768 RDI: 0000000000000282
> Dec  5 14:54:56 scarlet kernel: [11015.129432] RBP: ffff88041e210c00 R08: 0000000000000000 R09: fffffffffffffff9
> Dec  5 14:54:56 scarlet kernel: [11015.129439] R10: ffff880232da3c58 R11: ffff880232da3c58 R12: 00007fffce2d3000
> Dec  5 14:54:56 scarlet kernel: [11015.129445] R13: ffff88041dd53d80 R14: ffff88041e210c00 R15: 0000000000000004
> Dec  5 14:54:56 scarlet kernel: [11015.129454] FS:  00002ac2c657bb20(0000) GS:ffff88042fd00000(0000) knlGS:0000000000000000
> Dec  5 14:54:56 scarlet kernel: [11015.129461] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> Dec  5 14:54:56 scarlet kernel: [11015.129467] CR2: 00002af4791f2520 CR3: 0000000232f63000 CR4: 00000000000006e0
> Dec  5 14:54:56 scarlet kernel: [11015.129474] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> Dec  5 14:54:56 scarlet kernel: [11015.129480] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> Dec  5 14:54:56 scarlet kernel: [11015.129488] Process sh (pid: 16269, threadinfo ffff880232da2000, task ffff8802410e8730)
> Dec  5 14:54:56 scarlet kernel: [11015.129493] Stack:
> Dec  5 14:54:56 scarlet kernel: [11015.129497]  ffff88041e210c00 000000014009ef44 ffff880232da3c70 0000000000000000
> Dec  5 14:54:56 scarlet kernel: [11015.129511]  0000000800000000 ffffea000e5ce140 ffffea000e5ce178 ffffea000e5bc080
> Dec  5 14:54:56 scarlet kernel: [11015.129522]  ffffea000e6d81b0 ffffea000e6dc158 ffffea000e5d4d50 ffffea000ea6a4a0
> Dec  5 14:54:56 scarlet kernel: [11015.129533] Call Trace:
> Dec  5 14:54:56 scarlet kernel: [11015.129545]  [<ffffffff81043574>] ? mmput+0x56/0xf8
> Dec  5 14:54:56 scarlet kernel: [11015.129555]  [<ffffffff810f8bf7>] ? flush_old_exec+0x4b0/0x5a1
> Dec  5 14:54:56 scarlet kernel: [11015.129567]  [<ffffffff8112cfe3>] ? load_elf_binary+0x2b0/0x1761
> Dec  5 14:54:56 scarlet kernel: [11015.129581]  [<ffffffffa0fdb8ac>] ? load_misc_binary+0x6e/0x2e4 [binfmt_misc]
> Dec  5 14:54:56 scarlet kernel: [11015.129590]  [<ffffffff810f80ec>] ? get_arg_page+0x7a/0xbf
> Dec  5 14:54:56 scarlet kernel: [11015.129601]  [<ffffffff8103538b>] ? should_resched+0x5/0x23
> Dec  5 14:54:56 scarlet kernel: [11015.129611]  [<ffffffff8132c02f>] ? _cond_resched+0x7/0x1c
> Dec  5 14:54:56 scarlet kernel: [11015.129619]  [<ffffffff810f8165>] ? get_user_arg_ptr.isra.20+0x34/0x48
> Dec  5 14:54:56 scarlet kernel: [11015.129629]  [<ffffffff8103538b>] ? should_resched+0x5/0x23
> Dec  5 14:54:56 scarlet kernel: [11015.129638]  [<ffffffff810f85a7>] ? search_binary_handler+0xa7/0x237
> Dec  5 14:54:56 scarlet kernel: [11015.129647]  [<ffffffff8112cd33>] ? load_elf_library+0x228/0x228
> Dec  5 14:54:56 scarlet kernel: [11015.129656]  [<ffffffff810f9306>] ? do_execve_common.isra.26+0x1d2/0x2d1
> Dec  5 14:54:56 scarlet kernel: [11015.129673]  [<ffffffff810148ba>] ? sys_execve+0x3f/0x54
> Dec  5 14:54:56 scarlet kernel: [11015.129682]  [<ffffffff811a277d>] ? __put_user_4+0x1d/0x30
> Dec  5 14:54:56 scarlet kernel: [11015.129692]  [<ffffffff8133272c>] ? stub_execve+0x6c/0xc0
> Dec  5 14:54:56 scarlet kernel: [11015.129699] Code: d5 9c ff ff 4c 89 e2 31 f6 48 89 e7 e8 d0 97 ff ff 48 89 df e8 bf eb ff ff 48 85 c0 48 89 c3 75 f0 48 83 bd d8 00 00 00 00 74 02 <0f> 0b 48 83 c4 70 5b 5d 41 5c c3 55 48 89 fd 53 48 89 f3 48 83 
> Dec  5 14:54:56 scarlet kernel: [11015.129772] RIP  [<ffffffff810d02be>] exit_mmap+0xd6/0xe1
> Dec  5 14:54:56 scarlet kernel: [11015.129781]  RSP <ffff880232da3c58>
> Dec  5 14:54:56 scarlet kernel: [11015.129788] ---[ end trace d35d20c63f7f9c1b ]---
> Dec  5 14:54:56 scarlet kernel: [11015.148797] BUG: unable to handle kernel NULL pointer dereference at 000000000000000c
> Dec  5 14:54:56 scarlet kernel: [11015.148812] IP: [<ffffffff810dae06>] valid_swaphandles+0x65/0xd5
> Dec  5 14:54:56 scarlet kernel: [11015.148828] PGD 22dc6c067 PUD 234fa3067 PMD 0 
> Dec  5 14:54:56 scarlet kernel: [11015.148838] Oops: 0000 [#2] SMP 
> Dec  5 14:54:56 scarlet kernel: [11015.148847] CPU 4 
> Dec  5 14:54:56 scarlet kernel: [11015.148850] Modules linked in: nls_utf8 nls_cp437 vfat fat cryptd aes_x86_64 aes_generic ip6table_filter ip6_tables iptable_filter ip_tables eb
> table_nat ebtables x_tables parport_pc ppdev lp parport bnep powernow_k8 rfcomm mperf bluetooth cpufreq_userspace cpufreq_stats cpufreq_powersave cpufreq_conservative crc16 binfm
> t_misc fuse nfsd nfs lockd fscache auth_rpcgss nfs_acl sunrpc firewire_sbp2 loop kvm_amd kvm snd_hda_codec_hdmi joydev nvidia(P) snd_hda_codec_realtek snd_hda_intel snd_hda_codec arc4 snd_pcm_oss snd_hwdep snd_mixer_oss snd_pcm snd_seq_midi snd_rawmidi snd_seq_midi_event snd_seq rtl8192se rtlwifi mac80211 snd_timer snd_seq_device sp5100_tco snd psmouse pcspkr edac_core soundcore evdev serio_raw cfg80211 i2c_piix4 edac_mce_amd snd_page_alloc k10temp i2c_core rfkill asus_atk0110 processor wmi button thermal_sys ext3 jbd mbcache btrfs zlib_deflate crc32c libcrc32c dm_mod usb_storage uas sr_mod usbhid hid cdrom sd_mod ata_generic crc_t10dif ohci_hcd xhci_hcd pata_jmic
> Dec  5 14:54:56 scarlet kernel: ron firewire_ohci ehci_hcd r8169 pata_atiixp mii firewire_core crc_itu_t ahci libahci usbcore libata scsi_mod [last unloaded: scsi_wait_scan]
> Dec  5 14:54:56 scarlet kernel: [11015.149025] 
> Dec  5 14:54:56 scarlet kernel: [11015.149032] Pid: 16271, comm: sh Tainted: P      D    O 3.1.0-1-amd64 #1 System manufacturer System Product Name/M4A89TD PRO USB3
> Dec  5 14:54:56 scarlet kernel: [11015.149044] RIP: 0010:[<ffffffff810dae06>]  [<ffffffff810dae06>] valid_swaphandles+0x65/0xd5
> Dec  5 14:54:56 scarlet kernel: [11015.149056] RSP: 0000:ffff880230117d38  EFLAGS: 00010246
> Dec  5 14:54:56 scarlet kernel: [11015.149062] RAX: 0000000000000e0c RBX: 0000000000000001 RCX: 0000000000000003
> Dec  5 14:54:56 scarlet kernel: [11015.149069] RDX: 0000000000000e0c RSI: ffff880230117d70 RDI: ffffffff817d2270
> Dec  5 14:54:56 scarlet kernel: [11015.149075] RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000028
> Dec  5 14:54:56 scarlet kernel: [11015.149082] R10: 00002b6fba94ae90 R11: 00002b6fba94ae90 R12: 0000000000000000
> Dec  5 14:54:56 scarlet kernel: [11015.149088] R13: ffff880230117d70 R14: 0000000000000008 R15: 00000000000200da
> Dec  5 14:54:56 scarlet kernel: [11015.149096] FS:  00002b6fbac67b20(0000) GS:ffff88042fd00000(0000) knlGS:0000000000000000
> Dec  5 14:54:56 scarlet kernel: [11015.149103] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> Dec  5 14:54:56 scarlet kernel: [11015.149109] CR2: 000000000000000c CR3: 0000000232f63000 CR4: 00000000000006e0
> Dec  5 14:54:56 scarlet kernel: [11015.149116] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> Dec  5 14:54:56 scarlet kernel: [11015.149123] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> Dec  5 14:54:56 scarlet kernel: [11015.149130] Process sh (pid: 16271, threadinfo ffff880230116000, task ffff880256b6cfa0)
> Dec  5 14:54:56 scarlet kernel: [11015.149135] Stack:
> Dec  5 14:54:56 scarlet kernel: [11015.149139]  4000000000000000 4000000000000000 00002b6fba9253c0 ffff8802b6d0b3f8
> Dec  5 14:54:56 scarlet kernel: [11015.149151]  00002b6fba9253c0 ffffffff810d842a ffffffff810edf8b ffff8802449b4440
> Dec  5 14:54:56 scarlet kernel: [11015.149162]  0000000000000001 ffff8802b6d0b3f8 ffff880232daa928 00002b6fba9253c0
> Dec  5 14:54:56 scarlet kernel: [11015.149173] Call Trace:
> Dec  5 14:54:56 scarlet kernel: [11015.149184]  [<ffffffff810d842a>] ? swapin_readahead+0x2f/0x99
> Dec  5 14:54:56 scarlet kernel: [11015.149194]  [<ffffffff810edf8b>] ? try_get_mem_cgroup_from_mm+0x28/0x32
> Dec  5 14:54:56 scarlet kernel: [11015.149205]  [<ffffffff810cbb41>] ? handle_pte_fault+0x347/0x79f
> Dec  5 14:54:56 scarlet kernel: [11015.149214]  [<ffffffff810c8ffd>] ? set_pmd+0x5/0x8
> Dec  5 14:54:56 scarlet kernel: [11015.149223]  [<ffffffff810ca0b0>] ? __pte_alloc+0x87/0x11e
> Dec  5 14:54:56 scarlet kernel: [11015.149232]  [<ffffffff810c908d>] ? pte_offset_kernel+0x16/0x35
> Dec  5 14:54:56 scarlet kernel: [11015.149242]  [<ffffffff813302c0>] ? do_page_fault+0x312/0x337
> Dec  5 14:54:56 scarlet kernel: [11015.149250]  [<ffffffff810cf4a6>] ? vma_link+0x6d/0x8b
> Dec  5 14:54:56 scarlet kernel: [11015.149258]  [<ffffffff810d07ad>] ? do_brk+0x22d/0x280
> Dec  5 14:54:56 scarlet kernel: [11015.149266]  [<ffffffff8132d8f5>] ? page_fault+0x25/0x30
> Dec  5 14:54:56 scarlet kernel: [11015.149272] Code: 80 22 7d 81 48 89 eb b8 01 00 00 00 48 d3 eb d3 e0 48 d3 e3 48 98 4c 8d 34 03 48 85 db b8 01 00 00 00 48 0f 44 d8 e8 00 25 25 00 
> Dec  5 14:54:56 scarlet kernel: [11015.149347] RIP  [<ffffffff810dae06>] valid_swaphandles+0x65/0xd5
> Dec  5 14:54:56 scarlet kernel: [11015.149355]  RSP <ffff880230117d38>
> Dec  5 14:54:56 scarlet kernel: [11015.149359] CR2: 000000000000000c
> Dec  5 14:54:56 scarlet kernel: [11015.149366] ---[ end trace d35d20c63f7f9c1c ]---
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

HTH.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
