Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754052Ab0C2QLc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 12:11:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57561 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753012Ab0C2QLb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 12:11:31 -0400
Message-ID: <4BB0D11A.607@redhat.com>
Date: Mon, 29 Mar 2010 12:11:06 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Lightning/1.0b2pre Thunderbird/3.0.1
MIME-Version: 1.0
To: Kent Overstreet <kent.overstreet@gmail.com>
CC: linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>
Subject: Re: KVM bug, git bisected
References: <4BADFD74.8060904@gmail.com>
In-Reply-To: <4BADFD74.8060904@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/27/2010 08:43 AM, Kent Overstreet wrote:
> commit 5beb49305251e5669852ed541e8e2f2f7696c53e
> Author: Rik van Riel <riel@redhat.com>
> Date: Fri Mar 5 13:42:07 2010 -0800
>
> mm: change anon_vma linking to fix multi-process server scalability issue
>
> I get this when starting kvm. The warning hasn't caused me problems, but
> I've also been getting a scheduling while atomic panic when I start kvm
> that I can only reproduce when I don't want to. It's definitely config
> dependent, I'd guess preempt might have something to do with it.

 From your trace, it looks like mm_take_all_locks is taking close
to 256 locks, which is where the preempt_count could overflow into
the softirq count.

Since kvm-qemu is exec'd, I am guessing you have a very large
number of VMAs in your qemu process.  Is that correct?

Peter, would it be safe to increase PREEMPT_BITS to eg. 10?

> [ 44.418510] ------------[ cut here ]------------
> [ 44.418554] WARNING: at kernel/sched.c:3554 add_preempt_count+0x9c/0xa0()
> [ 44.418591] Hardware name: P5K-E
> [ 44.418623] Modules linked in:
> [ 44.418686] Pid: 1486, comm: kvm Not tainted 2.6.33 #31
> [ 44.418721] Call Trace:
> [ 44.418765] [<ffffffff8107d7bb>] warn_slowpath_common+0x7b/0xc0
> [ 44.418810] [<ffffffff8107d814>] warn_slowpath_null+0x14/0x20
> [ 44.418854] [<ffffffff8168ef8c>] add_preempt_count+0x9c/0xa0
> [ 44.418898] [<ffffffff8168b5cb>] _raw_spin_lock+0x1b/0x40
> [ 44.418943] [<ffffffff8113115a>] mm_take_all_locks+0x11a/0x160
> [ 44.418988] [<ffffffff8114749b>] do_mmu_notifier_register+0x7b/0x1d0
> [ 44.419032] [<ffffffff81147623>] mmu_notifier_register+0x13/0x20
> [ 44.419078] [<ffffffff81006618>] kvm_dev_ioctl+0x238/0x490
> [ 44.419122] [<ffffffff8168ee59>] ? sub_preempt_count+0x9/0xa0
> [ 44.419167] [<ffffffff8116d32d>] vfs_ioctl+0x3d/0xd0
> [ 44.419209] [<ffffffff8116d888>] do_vfs_ioctl+0x88/0x570
> [ 44.419252] [<ffffffff8168eef9>] ? add_preempt_count+0x9/0xa0
> [ 44.419294] [<ffffffff8116ddf1>] sys_ioctl+0x81/0xa0
> [ 44.419336] [<ffffffff8103509b>] system_call_fastpath+0x16/0x1b
> [ 44.419378] ---[ end trace 34e3b440ad5088d0 ]---


