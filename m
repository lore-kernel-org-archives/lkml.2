Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751834Ab1AaACI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Jan 2011 19:02:08 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:59522 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750968Ab1AaACG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Jan 2011 19:02:06 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Mon, 31 Jan 2011 08:55:47 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "hannes@cmpxchg.org" <hannes@cmpxchg.org>,
        "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>
Subject: Re: [BUGFIX][PATCH 0/4] Fixes for memcg with THP
Message-Id: <20110131085547.960f6702.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <AANLkTiktzgxEVROyB=-0ZNq5xzao1Q-Cu3xpGqhx0gxm@mail.gmail.com>
References: <20110128122229.6a4c74a2.kamezawa.hiroyu@jp.fujitsu.com>
	<AANLkTiktzgxEVROyB=-0ZNq5xzao1Q-Cu3xpGqhx0gxm@mail.gmail.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 29 Jan 2011 18:17:56 +0530
Balbir Singh <balbir@linux.vnet.ibm.com> wrote:

> On Fri, Jan 28, 2011 at 8:52 AM, KAMEZAWA Hiroyuki
> <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> >
> > On recent -mm, when I run make -j 8 under 200M limit of memcg, as
> > ==
> > # mount -t cgroup none /cgroup/memory -o memory
> > # mkdir /cgroup/memory/A
> > # echo 200M > /cgroup/memory/A/memory.limit_in_bytes
> > # echo $$ > /cgroup/memory/A/tasks
> > # make -j 8 kernel
> > ==
> >
> > I see hangs with khugepaged. That's because memcg's memory reclaim
> > routine doesn't handle HUGE_PAGE request in proper way. And khugepaged
> > doesn't know about memcg.
> >
> > This patch set is for fixing above hang. Patch 1-3 seems obvious and
> > has the same concept as patches in RHEL.
> 
> Do you have any backtraces? Are they in the specific patches?
> 

Jan 18 10:28:29 rhel6-test kernel: [56245.286007] INFO: rcu_sched_state detected stall on CPU 0
(t=60000 jiffies)
Jan 18 10:28:29 rhel6-test kernel: [56245.286007] sending NMI to all CPUs:
Jan 18 10:28:29 rhel6-test kernel: [56245.286007] NMI backtrace for cpu 0
Jan 18 10:28:29 rhel6-test kernel: [56245.286007] CPU 0

Jan 18 10:28:29 rhel6-test kernel: [56245.286007]  [<ffffffff8102a04e>] arch_trigger_all_cpu_bac
ktrace+0x5e/0xa0
Jan 18 10:28:29 rhel6-test kernel: [56245.286007]  [<ffffffff810bca09>] __rcu_pending+0x169/0x3b
0
Jan 18 10:28:29 rhel6-test kernel: [56245.286007]  [<ffffffff8108a250>] ? tick_sched_timer+0x0/0
xc0
Jan 18 10:28:29 rhel6-test kernel: [56245.286007]  [<ffffffff810bccbc>] rcu_check_callbacks+0x6c
/0x120
Jan 18 10:28:29 rhel6-test kernel: [56245.286007]  [<ffffffff810689a8>] update_process_times+0x4
8/0x90
Jan 18 10:28:29 rhel6-test kernel: [56245.286007]  [<ffffffff8108a2b6>] tick_sched_timer+0x66/0x
c0
Jan 18 10:28:29 rhel6-test kernel: [56245.286007]  [<ffffffff8107ede0>] __run_hrtimer+0x90/0x1e0
Jan 18 10:28:29 rhel6-test kernel: [56245.286007]  [<ffffffff81032db9>] ? kvm_clock_get_cycles+0
x9/0x10
Jan 18 10:28:29 rhel6-test kernel: [56245.286007]  [<ffffffff8107f1be>] hrtimer_interrupt+0xde/0
x240
Jan 18 10:28:29 rhel6-test kernel: [56245.286007]  [<ffffffff8155268b>] smp_apic_timer_interrupt
+0x6b/0x9b
Jan 18 10:28:29 rhel6-test kernel: [56245.286007]  [<ffffffff8100c9d3>] apic_timer_interrupt+0x13/0x20
Jan 18 10:28:29 rhel6-test kernel: [56245.286007]  <EOI>
Jan 18 10:28:29 rhel6-test kernel: [56245.286007]  [<ffffffff810a726a>] ? res_counter_charge+0xda/0x100
Jan 18 10:28:29 rhel6-test kernel: [56245.286007]  [<ffffffff81145459>] __mem_cgroup_try_charge+0x199/0x5d0
Jan 18 10:28:29 rhel6-test kernel: [56245.286007]  [<ffffffff811463b5>] mem_cgroup_newpage_charge+0x45/0x50
Jan 18 10:28:29 rhel6-test kernel: [56245.286007]  [<ffffffff8113dbd4>] khugepaged+0x924/0x1430
Jan 18 10:28:29 rhel6-test kernel: [56245.286007]  [<ffffffff8107af00>] ? autoremove_wake_function+0x0/0x40
Jan 18 10:28:29 rhel6-test kernel: [56245.286007]  [<ffffffff8113d2b0>] ? khugepaged+0x0/0x1430
Jan 18 10:28:29 rhel6-test kernel: [56245.286007]  [<ffffffff8107a8b6>] kthread+0x96/0xa0
Jan 18 10:28:29 rhel6-test kernel: [56245.286007]  [<ffffffff8100ce24>] kernel_thread_helper+0x4/0x10
Jan 18 10:28:29 rhel6-test kernel: [56245.286007]  [<ffffffff8107a820>] ? kthread+0x0/0xa0
Jan 18 10:28:29 rhel6-test kernel: [56245.286007]  [<ffffffff8100ce20>] ? kernel_thread_helper+0x0/0x10

Thanks,
-Kame

