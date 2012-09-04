Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757629Ab2IDTRu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 15:17:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19247 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752589Ab2IDTRs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 15:17:48 -0400
Date: Tue, 4 Sep 2012 16:17:37 -0300
From: Flavio Leitner <fbl@redhat.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: lkml <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        WANG Cong <xiyou.wangcong@gmail.com>, Tejun Heo <tj@kernel.org>,
        ianfang.cn@gmail.com, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: kexec/kdump kernel fails to start
Message-ID: <20120904161737.358d51ad@obelix.rh>
In-Reply-To: <CAE9FiQUEHbDySWHWFj6kW=HGLR0vkbaJWRq+7kMMHGhBm8e08A@mail.gmail.com>
References: <20120904143215.5bbbb2a4@obelix.rh>
	<CAE9FiQUEHbDySWHWFj6kW=HGLR0vkbaJWRq+7kMMHGhBm8e08A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 4 Sep 2012 12:02:00 -0700
Yinghai Lu <yinghai@kernel.org> wrote:

> On Tue, Sep 4, 2012 at 10:32 AM, Flavio Leitner <fbl@redhat.com> wrote:
> > Hi folks,
> >
> > I have system that no longer boots kdump kernel. Basically,
> >
> > # echo c > /proc/sysrq-trigger
> >
> > to dump a vmcore doesn't work. It just hangs after showing the usual
> > panic messages. I've bisected the problem and the commit introducing
> > the issue is the one below.
> >
> > Any idea?
> >
> > commit 722bc6b16771ed80871e1fd81c86d3627dda2ac8
> > Author: WANG Cong <xiyou.wangcong@gmail.com>  2012-03-05 20:05:13
> > Committer: Ingo Molnar <mingo@elte.hu>  2012-03-06 05:38:26
> > Parent: 550cf00dbc8ee402bef71628cb71246493dd4500 (Merge tag 'mmc-fixes-for-3.3' of git://git.kernel.org/pub/scm/linux/kernel/git/cjb/mmc)
> > Child:  a6fca40f1d7f3e232c9de27c1cebbb9f787fbc4f (x86, tlb: Switch cr3 in leave_mm() only when needed)
> > Branches: master, remotes/origin/master
> > Follows: v3.3-rc6
> > Precedes: v3.5-rc1
> >
> >     x86/mm: Fix the size calculation of mapping tables
> >
> >     For machines that enable PSE, the first 2/4M memory region still uses
> >     4K pages, so needs more PTEs in this case, but
> >     find_early_table_space() doesn't count this.
> >
> >     This patch fixes it.
> >
> >     The bug was found via code review, no misbehavior of the kernel
> >     was observed.
> 
> maybe just revert the offending commit?

I don't know where the 4K pages were noticed. Here is the
dmesg output passing 'debug':

[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] last_pfn = 0xbf800 max_arch_pfn = 0x400000000
[    0.000000] initial memory mapped : 0 - 20000000
[    0.000000] Base memory trampoline at [ffff880000098000] 98000 size 20480
[    0.000000] init_memory_mapping: 0000000000000000-00000000bf800000
[    0.000000]  0000000000 - 00bf800000 page 2M
[    0.000000] kernel direct mapping tables up to bf800000 @ 1fa00000-20000000
[    0.000000] init_memory_mapping: 0000000100000000-0000000440000000
[    0.000000]  0100000000 - 0440000000 page 2M
[    0.000000] kernel direct mapping tables up to 440000000 @ bdaab000-bf4bd000
[    0.000000] RAMDISK: 352c8000 - 3695c000

so, it appears that on my system, the pages are 2M.
I will try moving the extra accounting to be inside of CONFIG_X86_32.

fbl
