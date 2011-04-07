Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757188Ab1DGBNW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 21:13:22 -0400
Received: from infernal.debian.net ([87.230.26.131]:59728 "EHLO
	infernal.debian.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757165Ab1DGBNU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 21:13:20 -0400
X-Greylist: delayed 2684 seconds by postgrey-1.27 at vger.kernel.org; Wed, 06 Apr 2011 21:13:20 EDT
Date: Thu, 7 Apr 2011 02:28:33 +0200
From: Andreas Bombe <andreas.bombe@mytum.de>
To: linux-kernel@vger.kernel.org
Subject: OOPS procfs in vma_stop() from bad vma pointer
Message-ID: <20110407002832.GA5185@amos.fritz.box>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So I got this Oops in an x86-64 2.6.38-08569-g16c29da (not the very
latest, so maybe it is known already). It was triggered by Debian's
popularity-contest program that was started from cron. Here it is:

[ 2106.743933] BUG: unable to handle kernel paging request at fffffffffffffff3
[ 2106.744039] IP: [<ffffffff81158b01>] vma_stop.clone.3+0x13/0x2e
[ 2106.744118] PGD 1805067 PUD 1806067 PMD 0 
[ 2106.744180] Oops: 0000 [#1] PREEMPT SMP 
[ 2106.744240] last sysfs file: /sys/devices/pci0000:00/0000:00:1c.5/0000:02:00.0/net/eth0/statistics/collisions
[ 2106.744356] CPU 0 
[ 2106.744381] Modules linked in: acpi_cpufreq mperf cpufreq_powersave cpufreq_stats cpufreq_userspace cpufreq_conservative snd_hrtimer binfmt_misc kvm_intel kvm uinput fuse xfs sha256_generic twofish_generic twofish_x86_64 twofish_common cbc dm_crypt snd_hda_codec_hdmi snd_emu10k1_synth snd_emux_synth snd_seq_virmidi snd_hda_codec_realtek snd_seq_midi_emul snd_emu10k1 snd_hda_intel snd_ac97_codec ac97_bus snd_hda_codec snd_pcm_oss snd_mixer_oss snd_pcm snd_util_mem snd_hwdep snd_seq_midi snd_rawmidi snd_seq_midi_event radeon snd_seq snd_timer snd_seq_device snd ttm intel_agp joydev emu10k1_gp drm_kms_helper processor intel_gtt wacom soundcore i2c_i801 pcspkr gameport evdev snd_page_alloc thermal_sys asus_atk0110 button dm_mod usbhid ahci libahci firewire_ohci atl1e firewire_core libata crc_itu_t uhci_hcd ehci_hcd [last unloaded: scsi_wait_scan]
[ 2106.745580] 
[ 2106.745600] Pid: 5874, comm: popularity-cont Not tainted 2.6.38-08569-g16c29da #64 System manufacturer P5Q/P5Q
[ 2106.745730] RIP: 0010:[<ffffffff81158b01>]  [<ffffffff81158b01>] vma_stop.clone.3+0x13/0x2e
[ 2106.745834] RSP: 0018:ffff8800c9877e48  EFLAGS: 00010286
[ 2106.745897] RAX: 00000000fffffff3 RBX: ffff880129b7fde0 RCX: ffff8800be696900
[ 2106.745979] RDX: ffffffff814169d0 RSI: fffffffffffffff3 RDI: ffff880129b7fdf0
[ 2106.746064] RBP: ffff8800c9877e58 R08: ffff8800be696900 R09: ffff8800c9877e08
[ 2106.746149] R10: 0000000000000001 R11: ffff88012aab2600 R12: ffff8800b65fbe00
[ 2106.746232] R13: ffff8800be696900 R14: fffffffffffffff3 R15: 0000000000000000
[ 2106.746321] FS:  00007f6babc8f700(0000) GS:ffff88012fc00000(0000) knlGS:0000000000000000
[ 2106.746420] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 2106.746488] CR2: fffffffffffffff3 CR3: 0000000036f66000 CR4: 00000000000406f0
[ 2106.746571] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 2106.746654] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[ 2106.746737] Process popularity-cont (pid: 5874, threadinfo ffff8800c9876000, task ffff880127239fb0)
[ 2106.746841] Stack:
[ 2106.746866]  0000000000000004 ffff880129b7fde0 ffff8800c9877e78 ffffffff81158b78
[ 2106.746878]  0000000000000004 0000000000001000 ffff8800c9877ef8 ffffffff8112901f
[ 2106.746878]  0000000000000001 ffff8800fffffff3 0000000000000004 ffff8800be696938
[ 2106.746878] Call Trace:
[ 2106.746878]  [<ffffffff81158b78>] m_stop+0x19/0x2b
[ 2106.746878]  [<ffffffff8112901f>] seq_read+0x23b/0x369
[ 2106.746878]  [<ffffffff8110de6e>] vfs_read+0xa4/0xf7
[ 2106.746878]  [<ffffffff8110f0fe>] ? fget_light+0x3d/0x9b
[ 2106.746878]  [<ffffffff8110df06>] sys_read+0x45/0x69
[ 2106.746878]  [<ffffffff813e2612>] system_call_fastpath+0x16/0x1b
[ 2106.746878] Code: 39 c4 74 05 49 8b 54 24 08 48 89 53 30 41 5d 31 c0 5b 41 5c 41 5d c9 c3 55 48 89 e5 53 48 83 ec 08 48 85 f6 74 1c 48 3b 37 74 17 
[ 2106.746878]  8b 1e 48 8d bb 98 00 00 00 e8 2f 17 f1 ff 48 89 df e8 95 f7 
[ 2106.746878] RIP  [<ffffffff81158b01>] vma_stop.clone.3+0x13/0x2e
[ 2106.746878]  RSP <ffff8800c9877e48>
[ 2106.746878] CR2: fffffffffffffff3
[ 2107.173115] ---[ end trace 8cdfece298b5cc14 ]---


I disassembled vma_stop:
| Dump of assembler code for function vma_stop:
| 91	static void vma_stop(struct proc_maps_private *priv, struct vm_area_struct *vma)
|    0xffffffff81158aee <+0>:	push   %rbp
|    0xffffffff81158aef <+1>:	mov    %rsp,%rbp
|    0xffffffff81158af2 <+4>:	push   %rbx
|    0xffffffff81158af3 <+5>:	sub    $0x8,%rsp
| 
| 92	{
| 93		if (vma && vma != priv->tail_vma) {
|    0xffffffff81158af7 <+9>:	test   %rsi,%rsi
|    0xffffffff81158afa <+12>:	je     0xffffffff81158b18 <vma_stop+42>
|    0xffffffff81158afc <+14>:	cmp    (%rdi),%rsi
|    0xffffffff81158aff <+17>:	je     0xffffffff81158b18 <vma_stop+42>
| 
| 94			struct mm_struct *mm = vma->vm_mm;
|    0xffffffff81158b01 <+19>:	mov    (%rsi),%rbx
Oops here                       ^^^^^^^^^^^^^^^^^^
| 95			up_read(&mm->mmap_sem);
|    0xffffffff81158b04 <+22>:	lea    0x98(%rbx),%rdi
|    0xffffffff81158b0b <+29>:	callq  0xffffffff8106a23f <up_read>
| 
| 96			mmput(mm);
|    0xffffffff81158b10 <+34>:	mov    %rbx,%rdi
|    0xffffffff81158b13 <+37>:	callq  0xffffffff810482ad <mmput>
| 
| 97		}
| 98	}
|    0xffffffff81158b18 <+42>:	pop    %rax
|    0xffffffff81158b19 <+43>:	pop    %rbx
|    0xffffffff81158b1a <+44>:	leaveq 
|    0xffffffff81158b1b <+45>:	retq   
| 
| End of assembler dump.

It looks like vma_stop() got called with -13 as the vma pointer. This is
the first time that happened and I have no way to reproduce it.

-- 
Andreas Bombe
