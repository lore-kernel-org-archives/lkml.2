Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753364Ab0HRNwV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 09:52:21 -0400
Received: from smtp2-g21.free.fr ([212.27.42.2]:56477 "EHLO smtp2-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752752Ab0HRNwS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 09:52:18 -0400
From: Raphael Manfredi <Raphael_Manfredi@pobox.com>
To: linux-kernel@vger.kernel.org
Subject: [2.6.35.2] Scheduling bug on SMP
X-Mailer: MH [version 6.8]
Organization: Home, Grenoble, France
Date: Wed, 18 Aug 2010 15:52:09 +0200
Message-ID: <18963.1282139529@nice.ram.loc>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With 2.6.35.2 (and 2.6.34.4), I'm getting random errors like the following
when heavily loading a dual-core x86 system (Celeron E3300).

Reverting to 2.6.33.7 (with the same kernel configuration) works fine and
the system is very stable.

Here are the kernel bugs reported through syslog:

[ 1251.253401] BUG: scheduling while atomic: make/2887/0x10000001
[ 1251.253406] Modules linked in: binfmt_misc ppdev acpi_cpufreq mperf fbcon tileblit font bitblit softcursor snd_hda_codec_realtek i915 snd_hda_intel snd_hda_codec snd_hwdep drm_kms_helper snd_pcm_oss snd_mixer_oss snd_pcm drm snd_seq_dummy joydev usbhid psmouse i2c_algo_bit cfbcopyarea serio_raw snd_seq_oss snd_seq_midi hid snd_rawmidi video output cfbimgblt intel_agp cfbfillrect r8169 agpgart snd_seq_midi_event snd_seq mii lp snd_timer snd_seq_device snd soundcore snd_page_alloc asus_atk0110 parport
[ 1251.253444] Pid: 2887, comm: make Not tainted 2.6.35.2 #1
[ 1251.253446] Call Trace:
[ 1251.253453]  [<c0134fae>] __schedule_bug+0x5e/0x70
[ 1251.253457]  [<c0563437>] schedule+0x727/0x770
[ 1251.253462]  [<c01c885d>] ? __alloc_pages_nodemask+0xed/0x600
[ 1251.253465]  [<c0563582>] _cond_resched+0x32/0x50
[ 1251.253470]  [<c01e2b8e>] anon_vma_prepare+0x1e/0x110
[ 1251.253473]  [<c01deaed>] expand_downwards+0x1d/0x160
[ 1251.253476]  [<c0128f7b>] ? pte_alloc_one+0x3b/0x50
[ 1251.253479]  [<c01dec3d>] expand_stack+0xd/0x10
[ 1251.253481]  [<c01dca8f>] handle_mm_fault+0xa2f/0xa90
[ 1251.253484]  [<c01d9255>] ? follow_page+0x65/0x2a0
[ 1251.253487]  [<c01dcbf6>] __get_user_pages+0x106/0x3d0
[ 1251.253490]  [<c01dcf60>] get_user_pages+0x50/0x60
[ 1251.253493]  [<c02042c2>] get_arg_page+0x52/0xb0
[ 1251.253497]  [<c033714b>] ? strnlen_user+0x2b/0x60
[ 1251.253499]  [<c02043f7>] copy_strings+0xd7/0x190
[ 1251.253502]  [<c02044d9>] copy_strings_kernel+0x29/0x40
[ 1251.253505]  [<c0205e4a>] do_execve+0x19a/0x2c0
[ 1251.253507]  [<c033727a>] ? strncpy_from_user+0x3a/0x70
[ 1251.253511]  [<c0109c17>] sys_execve+0x37/0x70
[ 1251.253514]  [<c01030e2>] ptregs_execve+0x12/0x20
[ 1251.253516]  [<c0103017>] ? sysenter_do_call+0x12/0x22
[ 1251.427545] BUG: scheduling while atomic: make/2998/0x10000001
[ 1251.427549] Modules linked in: binfmt_misc ppdev acpi_cpufreq mperf fbcon tileblit font bitblit softcursor snd_hda_codec_realtek i915 snd_hda_intel snd_hda_codec snd_hwdep drm_kms_helper snd_pcm_oss snd_mixer_oss snd_pcm drm snd_seq_dummy joydev usbhid psmouse i2c_algo_bit cfbcopyarea serio_raw snd_seq_oss snd_seq_midi hid snd_rawmidi video output cfbimgblt intel_agp cfbfillrect r8169 agpgart snd_seq_midi_event snd_seq mii lp snd_timer snd_seq_device snd soundcore snd_page_alloc asus_atk0110 parport
[ 1251.427585] Pid: 2998, comm: make Not tainted 2.6.35.2 #1
[ 1251.427587] Call Trace:
[ 1251.427594]  [<c0134fae>] __schedule_bug+0x5e/0x70
[ 1251.427599]  [<c0563437>] schedule+0x727/0x770
[ 1251.427603]  [<c01c885d>] ? __alloc_pages_nodemask+0xed/0x600
[ 1251.427606]  [<c0563582>] _cond_resched+0x32/0x50
[ 1251.427610]  [<c01e2b8e>] anon_vma_prepare+0x1e/0x110
[ 1251.427613]  [<c01deaed>] expand_downwards+0x1d/0x160
[ 1251.427616]  [<c0128f7b>] ? pte_alloc_one+0x3b/0x50
[ 1251.427619]  [<c01dec3d>] expand_stack+0xd/0x10
[ 1251.427621]  [<c01dca8f>] handle_mm_fault+0xa2f/0xa90
[ 1251.427624]  [<c01d9255>] ? follow_page+0x65/0x2a0
[ 1251.427627]  [<c01dcbf6>] __get_user_pages+0x106/0x3d0
[ 1251.427630]  [<c01dcf60>] get_user_pages+0x50/0x60
[ 1251.427633]  [<c02042c2>] get_arg_page+0x52/0xb0
[ 1251.427637]  [<c033714b>] ? strnlen_user+0x2b/0x60
[ 1251.427639]  [<c02043f7>] copy_strings+0xd7/0x190
[ 1251.427642]  [<c02044d9>] copy_strings_kernel+0x29/0x40
[ 1251.427645]  [<c0205e4a>] do_execve+0x19a/0x2c0
[ 1251.427647]  [<c033727a>] ? strncpy_from_user+0x3a/0x70
[ 1251.427651]  [<c0109c17>] sys_execve+0x37/0x70
[ 1251.427653]  [<c01030e2>] ptregs_execve+0x12/0x20
[ 1251.427656]  [<c0103017>] ? sysenter_do_call+0x12/0x22
[ 1251.427676] ------------[ cut here ]------------
kernel BUG at arch/x86/mm/highmem_32.c:45!
[ 1251.427680] invalid opcode: 0000 [#1] SMP 
[ 1251.427683] last sysfs file: /sys/devices/virtual/block/md0/stat
[ 1251.427685] Modules linked in: binfmt_misc ppdev acpi_cpufreq mperf fbcon tileblit font bitblit softcursor snd_hda_codec_realtek i915 snd_hda_intel snd_hda_codec snd_hwdep drm_kms_helper snd_pcm_oss snd_mixer_oss snd_pcm drm snd_seq_dummy joydev usbhid psmouse i2c_algo_bit cfbcopyarea serio_raw snd_seq_oss snd_seq_midi hid snd_rawmidi video output cfbimgblt intel_agp cfbfillrect r8169 agpgart snd_seq_midi_event snd_seq mii lp snd_timer snd_seq_device snd soundcore snd_page_alloc asus_atk0110 parport
[ 1251.427713] 
[ 1251.427715] Pid: 3000, comm: sh Not tainted 2.6.35.2 #1 P5KPL-AM SE/System Product Name
[ 1251.427718] EIP: 0060:[<c012a6c7>] EFLAGS: 00210286 CPU: 1
kmap_atomic_prot+0xc7/0xd0
[ 1251.427723] EAX: c2b99420 EBX: dcc27163 ECX: 00000163 EDX: c082ee78
[ 1251.427725] ESI: 00000017 EDI: 0000001b EBP: f531ce14 ESP: f531ce04
[ 1251.427727]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
[ 1251.427729] Process sh (pid: 3000, ti=f531c000 task=f64032c0 task.ti=f531c000)
[ 1251.427730] Stack:
[ 1251.427732]  fffff000 f57d4f78 00000017 bffffff3 f531ce1c c012a6e3 f531ce70 c01dc0fa
[ 1251.427736] <0> 00000001 c300a2dc f531ceec 00000080 f4a74b00 00000000 f6ce3a9c 00000001
[ 1251.427742] <0> f531ce70 c01d9255 f477ca80 f5754bfc f477b6c0 00000001 bffffff3 f477b6c0
[ 1251.427747] Call Trace:
kmap_atomic+0x13/0x20
[ 1251.427753]  [<c01dc0fa>] ? handle_mm_fault+0x9a/0xa90
[ 1251.427756]  [<c01d9255>] ? follow_page+0x65/0x2a0
[ 1251.427759]  [<c01dcbf6>] ? __get_user_pages+0x106/0x3d0
[ 1251.427762]  [<c01dcf60>] ? get_user_pages+0x50/0x60
[ 1251.427765]  [<c02042c2>] ? get_arg_page+0x52/0xb0
[ 1251.427767]  [<c033714b>] ? strnlen_user+0x2b/0x60
[ 1251.427770]  [<c02043f7>] ? copy_strings+0xd7/0x190
[ 1251.427773]  [<c02044d9>] ? copy_strings_kernel+0x29/0x40
[ 1251.427775]  [<c0205e4a>] ? do_execve+0x19a/0x2c0
[ 1251.427778]  [<c0565fc3>] ? error_code+0x73/0x80
[ 1251.427781]  [<c033727a>] ? strncpy_from_user+0x3a/0x70
[ 1251.427784]  [<c0109c17>] ? sys_execve+0x37/0x70
[ 1251.427786]  [<c01030e2>] ? ptregs_execve+0x12/0x20
[ 1251.427789]  [<c0103017>] ? sysenter_do_call+0x12/0x22
[ 1251.427790] Code: cb 83 e1 01 8b 35 c0 69 8a c0 74 06 23 1d 3c 88 78 c0 29 f0 83 c7 46 c1 f8 05 c1 e0 0c 09 d8 89 02 8b 45 f0 c1 e7 0c 29 f8 eb 85 <0f> 0b eb fe 90 8d 74 26 00 55 89 e5 0f 1f 44 00 00 8b 0d 04 a0 
kmap_atomic_prot+0xc7/0xd0 SS:ESP 0068:f531ce04
[ 1251.427824] ---[ end trace 7c1512c76d3a2aa1 ]---
[ 1251.427828] note: sh[3000] exited with preempt_count 1
[ 1251.427838] ------------[ cut here ]------------
kernel BUG at arch/x86/mm/highmem_32.c:45!
[ 1251.427841] invalid opcode: 0000 [#2] SMP 

Any clue on what's going on?

Raphael

