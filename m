Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751771Ab1GXRSg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jul 2011 13:18:36 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:41671 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751424Ab1GXRS2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jul 2011 13:18:28 -0400
Message-ID: <4E2C53E0.3020400@gmail.com>
Date: Sun, 24 Jul 2011 11:18:24 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Anton Blanchard <anton@samba.org>, Paul Mackerras <paulus@samba.org>,
        linux-perf-users@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        linuxppc-dev@lists.ozlabs.org
Subject: Re: perf PPC: kernel panic with callchains and context switch events
References: <4E274F5F.7000604@gmail.com>
In-Reply-To: <4E274F5F.7000604@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/20/2011 03:57 PM, David Ahern wrote:
> I am hoping someone familiar with PPC can help understand a panic that
> is generated when capturing callchains with context switch events.
> 
> Call trace is below. The short of it is that walking the callchain
> generates a page fault. To handle the page fault the mmap_sem is needed,
> but it is currently held by setup_arg_pages. setup_arg_pages calls
> shift_arg_pages with the mmap_sem held. shift_arg_pages then calls
> move_page_tables which has a cond_resched at the top of its for loop. If
> the cond_resched() is removed from move_page_tables everything works
> beautifully - no panics.
> 
> So, the question: is it normal for walking the stack to trigger a page
> fault on PPC? The panic is not seen on x86 based systems.

Can anyone confirm whether page faults while walking the stack are
normal for PPC? We really want to use the context switch event with
callchains and need to understand whether this behavior is normal. Of
course if it is normal, a way to address the problem without a panic
will be needed.

Thanks,
David

> 
>  [<b0180e00>]rb_erase+0x1b4/0x3e8
>  [<b00430f4>]__dequeue_entity+0x50/0xe8
>  [<b0043304>]set_next_entity+0x178/0x1bc
>  [<b0043440>]pick_next_task_fair+0xb0/0x118
>  [<b02ada80>]schedule+0x500/0x614
>  [<b02afaa8>]rwsem_down_failed_common+0xf0/0x264
>  [<b02afca0>]rwsem_down_read_failed+0x34/0x54
>  [<b02aed4c>]down_read+0x3c/0x54
>  [<b0023b58>]do_page_fault+0x114/0x5e8
>  [<b001e350>]handle_page_fault+0xc/0x80
>  [<b0022dec>]perf_callchain+0x224/0x31c
>  [<b009ba70>]perf_prepare_sample+0x240/0x2fc
>  [<b009d760>]__perf_event_overflow+0x280/0x398
>  [<b009d914>]perf_swevent_overflow+0x9c/0x10c
>  [<b009db54>]perf_swevent_ctx_event+0x1d0/0x230
>  [<b009dc38>]do_perf_sw_event+0x84/0xe4
>  [<b009dde8>]perf_sw_event_context_switch+0x150/0x1b4
>  [<b009de90>]perf_event_task_sched_out+0x44/0x2d4
>  [<b02ad840>]schedule+0x2c0/0x614
>  [<b0047dc0>]__cond_resched+0x34/0x90
>  [<b02adcc8>]_cond_resched+0x4c/0x68
>  [<b00bccf8>]move_page_tables+0xb0/0x418
>  [<b00d7ee0>]setup_arg_pages+0x184/0x2a0
>  [<b0110914>]load_elf_binary+0x394/0x1208
>  [<b00d6e28>]search_binary_handler+0xe0/0x2c4
>  [<b00d834c>]do_execve+0x1bc/0x268
>  [<b0015394>]sys_execve+0x84/0xc8
>  [<b001df10>]ret_from_syscall+0x0/0x3c
> 
> Thanks,
> David
