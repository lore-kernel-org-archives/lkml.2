Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752540Ab1HHJzZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 05:55:25 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:47848 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751255Ab1HHJzW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 05:55:22 -0400
Date: Mon, 8 Aug 2011 11:55:17 +0200
From: Tejun Heo <tj@kernel.org>
To: Avi Kivity <avi@redhat.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: percpu crash on NetBurst
Message-ID: <20110808095517.GH23937@htj.dyndns.org>
References: <4E3EB013.5000001@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E3EB013.5000001@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Avi.

On Sun, Aug 07, 2011 at 06:32:35PM +0300, Avi Kivity wrote:
> qemu, under some conditions (-cpu host or -cpu kvm64), erroneously
> passes family=15 as the virtual cpuid.  This causes a BUG() in
> percpu code during late boot:
> 
> ------------[ cut here ]------------
> kernel BUG at mm/percpu.c:577!

This means that free_percpu() was passed a pointer which doesn't point
to the start of an allocated area.  ie. the caller is trying to free
invalid pointer.  Hmmmm... from the backtrace, it seems to be caused
by super_block->s_files.  Weird.

>  [<ffffffff811060cc>] free_percpu+0x8c/0x140
>  [<ffffffff811462a5>] __put_super+0x45/0x80
>  [<ffffffff811463d5>] put_super+0x25/0x40
>  [<ffffffff8114651a>] deactivate_locked_super+0x5a/0x70
>  [<ffffffff81146f0e>] deactivate_super+0x4e/0x70
>  [<ffffffff811614e5>] mntput_no_expire+0xb5/0x100
>  [<ffffffff8116154f>] mntput+0x1f/0x30
>  [<ffffffff81245855>] mq_put_mnt+0x15/0x20
>  [<ffffffff81245f77>] put_ipc_ns+0x47/0xa0
>  [<ffffffff81080232>] free_nsproxy+0x42/0x90
>  [<ffffffff81080440>] switch_task_namespaces+0x50/0x60
>  [<ffffffff81080460>] exit_task_namespaces+0x10/0x20
>  [<ffffffff8105d29c>] do_exit+0x46c/0x870
>  [<ffffffff8105da02>] do_group_exit+0x42/0xa0
>  [<ffffffff8105da77>] sys_exit_group+0x17/0x20
>  [<ffffffff81521382>] system_call_fastpath+0x16/0x1b
> Code: e7 41 89 54 24 14 e8 f2 fd ff ff 5b 41 5c 41 5d 41 5e 5d c3 31
> f6 31 db e9 f5 fe ff ff 45 31 ed 31 c9 31 db e9 02 ff ff ff 0f 0b
> <0f> 0b 55 48 89 e5 48 83 ec 20 48 89 5d e0 4c 89 65 e8 4c 89 6d
> RIP  [<ffffffff8110603e>] pcpu_free_area+0x17e/0x180
>  RSP <ffff880001cabd18>
> ---[ end trace 87bc11c05d27169e ]---
> 
> I traced this to the kernel cpuid code determining the cache line size:
> 
> arch/x86/kernel/cpu/intel.c:
> 
>     if (c->x86 == 15)
>         c->x86_cache_alignment = c->x86_clflush_size * 2;
> 
> If I comment out this code, the kernel boots and all is well.
> 
> I suspect that the percpu code sometimes uses x86_cache_alignment
> and sometimes some hardcoded macro; I saw some negative elements of
> chunk->map[].

The negative elements indicate allocated areas.

> All this applies to v3.0; current upstream (c2f340a69ca) fails even
> worse, haven't yet determined exactly why.
> 
> I'm surprised this hasn't been reported before; Ingo, don't you have
> family=15 hosts in your test farm?

Hmmm... I can't trigger the problem w/ kvm64 (I tried mounting and
unmounting filesystems but it worked okay) and am quite skeptical this
is a wide spread problem given that the percpu core code is used very
widely and hasn't seen a lot of changes lately.  Is there anything
specific you need to do to trigger the condition?  Can you try to
print out the s_files addresses being allocated and freed?

Thanks.

-- 
tejun
