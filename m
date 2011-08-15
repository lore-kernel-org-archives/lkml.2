Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752511Ab1HOSTe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 14:19:34 -0400
Received: from smtp-out.google.com ([74.125.121.67]:12726 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751492Ab1HOSTd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 14:19:33 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:date:from:x-x-sender:to:cc:subject:
	in-reply-to:message-id:references:user-agent:mime-version:content-type:x-system-of-record;
	b=JU/bIu7Y+XpWXm1Q/L9eISjkNQukAle2IcAG+zIqXuNr0fILZWYp2jECqLi+UZ82+
	MgUEfOKRLQUrteR1R7v6Q==
Date: Mon, 15 Aug 2011 11:18:46 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@sister.anvils
To: Justin Piszcz <jpiszcz@lucidpixels.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: kernel 3.0: BUG: soft lockup: find_get_pages+0x51/0x110
In-Reply-To: <alpine.DEB.2.02.1108151241370.32349@p34.internal.lan>
Message-ID: <alpine.LSU.2.00.1108151109240.1524@sister.anvils>
References: <alpine.DEB.2.02.1108151241370.32349@p34.internal.lan>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 Aug 2011, Justin Piszcz wrote:
> Hello,
> 
> What causes this(?) -- am I out of memory(?) or is this a kernel bug?

It would be a kernel bug to lock up even if you are out of memory.

It does look like you're under memory pressure, but I don't see any OOM.

Is this something you've noticed just once, or does it happen repeatedly?

Does it always hit somewhere in find_get_pages(), or does the loop span
wider than that?

I'm answering out of interest in find_get_pages(): which does contain
a number of gotos which could result in endless looping; except that
they're all supposed to be for very transitory conditions which a
second glance at the RCU-protected tree should correct.

But if a radix_tree node got corrupted, then yes, it could loop forever.

If it's repeatable, please try again with slab poisoning (and frame
pointers) enabled?

Hugh

> 
> [104147.717815] BUG: soft lockup - CPU#13 stuck for 23s! [kswapd0:934]
> [104147.717820] Modules linked in: dm_mod tcp_diag parport_pc ppdev lp
> parport inet_diag ub pl2303 ftdi_sio snd_usb_audio snd_pcm_oss snd_mixer_oss
> snd_pcm snd_page_alloc snd_hwdep snd_usbmidi_lib snd_seq_dummy snd_seq_oss
> snd_seq_midi snd_rawmidi snd_seq_midi_event snd_seq snd_timer snd_seq_device
> snd soundcore usbserial cdc_acm nouveau serio_raw ttm drm_kms_helper drm
> agpgart i2c_algo_bit mxm_wmi wmi i7core_edac edac_core video
> [104147.717872] CPU 13 [104147.717874] Modules linked in: dm_mod tcp_diag
> parport_pc ppdev lp parport inet_diag ub pl2303 ftdi_sio snd_usb_audio
> snd_pcm_oss snd_mixer_oss snd_pcm snd_page_alloc snd_hwdep snd_usbmidi_lib
> snd_seq_dummy snd_seq_oss snd_seq_midi snd_rawmidi snd_seq_midi_event
> snd_seq snd_timer snd_seq_device snd soundcore usbserial cdc_acm nouveau
> serio_raw ttm drm_kms_helper drm agpgart i2c_algo_bit mxm_wmi wmi
> i7core_edac edac_core video
> [104147.717916] [104147.717921] Pid: 934, comm: kswapd0 Not tainted 3.0.0 #4
> Supermicro X8DTH-i/6/iF/6F/X8DTH
> [104147.717928] RIP: 0010:[<ffffffff81081f71>]  [<ffffffff81081f71>]
> find_get_pages+0x51/0x110
> [104147.717940] RSP: 0018:ffff880626127ba0  EFLAGS: 00000246
> [104147.717944] RAX: ffff8800b5e94d10 RBX: ffff880626127b68 RCX:
> 000000000000000e
> [104147.717948] RDX: 0000000000000003 RSI: 0000000000000000 RDI:
> ffffea001b29c8e8
> [104147.717952] RBP: 0000000000000cd7 R08: 0000000000000001 R09:
> ffffea001acce040
> [104147.717955] R10: 0000000000000001 R11: ffff8800ad03b930 R12:
> ffffffff815b47ce
> [104147.717959] R13: ffffea001ec13740 R14: ffff880626127dc0 R15:
> ffffffff81087ce4
> [104147.717964] FS:  0000000000000000(0000) GS:ffff88063fce0000(0000)
> knlGS:0000000000000000
> [104147.717969] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> [104147.717973] CR2: 000000007ddf2000 CR3: 0000000001843000 CR4:
> 00000000000006e0
> [104147.717976] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
> 0000000000000000
> [104147.717979] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7:
> 0000000000000400
> [104147.717983] Process kswapd0 (pid: 934, threadinfo ffff880626126000, task
> ffff880626125810)
> [104147.717986] Stack:
> [104147.717988]  0000000000000001 ffffffff810807fe ffff8800463ed6d8
> ffff880626127c10
> [104147.717998]  00000000000000a9 ffffffffffffffff ffff8800463ed6d8
> ffffea001ec13740
> [104147.718007]  0000000000000002 ffffffff81089e15 0000000000000cd7
> ffffffff8108b905
> [104147.718015] Call Trace:
> [104147.718023]  [<ffffffff810807fe>] ? __delete_from_page_cache+0x3e/0xe0
> [104147.718030]  [<ffffffff81089e15>] ? pagevec_lookup+0x15/0x20
> [104147.718036]  [<ffffffff8108b905>] ? invalidate_mapping_pages+0x55/0x130
> [104147.718045]  [<ffffffff810d6835>] ? shrink_icache_memory+0x2c5/0x310
> [104147.718052]  [<ffffffff8108c254>] ? shrink_slab+0x104/0x170
> [104147.718058]  [<ffffffff8108eda2>] ? balance_pgdat+0x492/0x600
> [104147.718064]  [<ffffffff8108efbc>] ? kswapd+0xac/0x250
> [104147.718071]  [<ffffffff81050fd0>] ? abort_exclusive_wait+0xb0/0xb0
> [104147.718077]  [<ffffffff8108ef10>] ? balance_pgdat+0x600/0x600
> [104147.718082]  [<ffffffff8105082e>] ? kthread+0x7e/0x90
> [104147.718090]  [<ffffffff815b4e14>] ? kernel_thread_helper+0x4/0x10
> [104147.718096]  [<ffffffff810507b0>] ? kthread_worker_fn+0x120/0x120
> [104147.718102]  [<ffffffff815b4e10>] ? gs_change+0xb/0xb
> [104147.718105] Code: e7 e8 f4 8b 25 00 85 c0 89 c1 0f 84 ba 00 00 00 49 89
> df 31 d2 45 31 f6 66 90 49 8b 07 48 8b 38 48 85 ff 74 3a 40 f6 c7 01 75 57
> <8b> 77 08 85 f6 74 ee 44 8d 46 01 89 f0 4c 8d 4f 08 f0 44 0f b1
> [104147.718149] Call Trace:
> [104147.718155]  [<ffffffff810807fe>] ? __delete_from_page_cache+0x3e/0xe0
> [104147.718161]  [<ffffffff81089e15>] ? pagevec_lookup+0x15/0x20
> [104147.718167]  [<ffffffff8108b905>] ? invalidate_mapping_pages+0x55/0x130
> [104147.718174]  [<ffffffff810d6835>] ? shrink_icache_memory+0x2c5/0x310
> [104147.718180]  [<ffffffff8108c254>] ? shrink_slab+0x104/0x170
> [104147.718186]  [<ffffffff8108eda2>] ? balance_pgdat+0x492/0x600
> [104147.718193]  [<ffffffff8108efbc>] ? kswapd+0xac/0x250
> [104147.718199]  [<ffffffff81050fd0>] ? abort_exclusive_wait+0xb0/0xb0
> [104147.718206]  [<ffffffff8108ef10>] ? balance_pgdat+0x600/0x600
> [104147.718211]  [<ffffffff8105082e>] ? kthread+0x7e/0x90
> [104147.718217]  [<ffffffff815b4e14>] ? kernel_thread_helper+0x4/0x10
> [104147.718224]  [<ffffffff810507b0>] ? kthread_worker_fn+0x120/0x120
> [104147.718229]  [<ffffffff815b4e10>] ? gs_change+0xb/0xb
> 
> Justin.
