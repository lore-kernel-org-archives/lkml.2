Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753236Ab2DARyJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2012 13:54:09 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:41156 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751769Ab2DARyH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2012 13:54:07 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.02.1204011935190.2542@ionos>
References: <1333228972-4594-1-git-send-email-levinsasha928@gmail.com> <alpine.LFD.2.02.1204011935190.2542@ionos>
From: Sasha Levin <levinsasha928@gmail.com>
Date: Sun, 1 Apr 2012 19:53:45 +0200
Message-ID: <CA+1xoqeTJu-uaaOCek5Y5ZKam83ePoRNFdxLcqdonYxok-BkhA@mail.gmail.com>
Subject: Re: [PATCH] debugobjects: Use GFP_ATOMIC to allocate when initializing
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 1, 2012 at 7:36 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> On Sat, 31 Mar 2012, Sasha Levin wrote:
>
>> During the init stage, we have only 1 cpu and run with IRQs disabled,
>> we can't allocate with GFP_KERNEL.
>>
>> This also fixes the related warning on boot.
>
> Hrmm. This should not be the case. In early boot GFP_KERNEL
> allocations should not trigger a warning when interrupts are
> disabled. Which kind of warning are you observing ?

There were two, both pointing at the same WARN(). I don't have the
first one which was fixed in this patch handy, but the second one is:

[    0.000000] WARNING: at kernel/lockdep.c:2739
lockdep_trace_alloc+0x11f/0x130()
[    0.000000] Pid: 0, comm: swapper/0 Not tainted
3.3.0-next-20120330-sasha-dirty #40
[    0.000000] Call Trace:
[    0.000000]  [<ffffffff810b4175>] warn_slowpath_common+0x75/0xb0
[    0.000000]  [<ffffffff810b41c5>] warn_slowpath_null+0x15/0x20
[    0.000000]  [<ffffffff8111999f>] lockdep_trace_alloc+0x11f/0x130
[    0.000000]  [<ffffffff81182e0c>] __alloc_pages_nodemask+0x9c/0x260
[    0.000000]  [<ffffffff826bcea7>] ? retint_restore_args+0x6/0x13
[    0.000000]  [<ffffffff811cc2cd>] kmemcheck_alloc_shadow+0x4d/0xf0
[    0.000000]  [<ffffffff811c5597>] allocate_slab+0x197/0x270
[    0.000000]  [<ffffffff811c569b>] new_slab+0x2b/0x190
[    0.000000]  [<ffffffff811c7e7a>] ? __slab_alloc+0x5a/0x6b0
[    0.000000]  [<ffffffff811c82b3>] __slab_alloc+0x493/0x6b0
[    0.000000]  [<ffffffff81114f61>] ? trace_hardirqs_off_caller+0xe1/0x150
[    0.000000]  [<ffffffff81886f1d>] ? trace_hardirqs_off_thunk+0x3a/0x3c
[    0.000000]  [<ffffffff8395eb55>] ?
debug_objects_replace_static_objects+0x2a/0x1f5
[    0.000000]  [<ffffffff8395eb55>] ?
debug_objects_replace_static_objects+0x2a/0x1f5
[    0.000000]  [<ffffffff811c900e>] kmem_cache_alloc+0x17e/0x1a0
[    0.000000]  [<ffffffff8395eb55>]
debug_objects_replace_static_objects+0x2a/0x1f5
[    0.000000]  [<ffffffff8395ed59>] debug_objects_mem_init+0x39/0x68
[    0.000000]  [<ffffffff8392af65>] start_kernel+0x33a/0x3f8
[    0.000000]  [<ffffffff8392aa13>] ? kernel_init+0x280/0x280
[    0.000000]  [<ffffffff8392a2b6>] x86_64_start_reservations+0xa1/0xa6
[    0.000000]  [<ffffffff8392a410>] x86_64_start_kernel+0x155/0x164
[    0.000000] ---[ end trace a7919e7f17c0a725 ]---
