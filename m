Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752280Ab1HXXDJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 19:03:09 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36244 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750751Ab1HXXDH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 19:03:07 -0400
Date: Wed, 24 Aug 2011 16:02:51 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-pm@lists.linux-foundation.org, Nick Piggin <npiggin@kernel.dk>
Subject: Re: [BUG] Soft-lockup during cpu-hotplug in VFS callpaths
Message-Id: <20110824160251.3b8ba1f6.akpm@linux-foundation.org>
In-Reply-To: <4E550057.9070609@linux.vnet.ibm.com>
References: <4E550057.9070609@linux.vnet.ibm.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Aug 2011 19:14:55 +0530
"Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com> wrote:

> Hi,
> 
> While running stressful cpu hotplug tests along with kernel compilation
> running in background, soft-lockups are detected on multiple CPUs.
> Sometimes this also leads to hard lockups and kernel panic.
> All the soft-lockups seem to occur at vfsmount_lock_local_cpu() or other VFS
> callpaths.
> 
> 
> [37108.410813] BUG: soft lockup - CPU#5 stuck for 22s! [cc1:29669]
> <snip>
> [37108.694781] Call Trace:
> [37108.697306]  [<ffffffff81199e70>] ? vfsmount_lock_local_lock_cpu+0x70/0x70
> [37108.704258]  [<ffffffff81187cb5>] path_init+0x315/0x400
> [37108.709558]  [<ffffffff8127c398>] ? __raw_spin_lock_init+0x38/0x70
> [37108.715812]  [<ffffffff8118961c>] path_openat+0x8c/0x3f0
> [37108.721203]  [<ffffffff81012129>] ? sched_clock+0x9/0x10
> [37108.726597]  [<ffffffff8109416d>] ? sched_clock_cpu+0xcd/0x110
> [37108.732508]  [<ffffffff810a178d>] ? trace_hardirqs_off+0xd/0x10
> [37108.738498]  [<ffffffff8109421f>] ? local_clock+0x6f/0x80
> [37108.743970]  [<ffffffff81189a99>] do_filp_open+0x49/0xa0
> [37108.749362]  [<ffffffff811982f3>] ? alloc_fd+0xc3/0x210
> [37108.754665]  [<ffffffff8152584b>] ? _raw_spin_unlock+0x2b/0x40
> [37108.760575]  [<ffffffff811982f3>] ? alloc_fd+0xc3/0x210
> [37108.765875]  [<ffffffff81179607>] do_sys_open+0x107/0x1e0
> [37108.771352]  [<ffffffff810d610f>] ? audit_syscall_entry+0x1bf/0x1f0
> [37108.777695]  [<ffffffff81179720>] sys_open+0x20/0x30
> [37108.782741]  [<ffffffff8152e202>] system_call_fastpath+0x16/0x1b
> 
> Kernel version: 3.0.1, 3.0.3
> Hardware: Dual socket quad-core hyper-threaded Intel x86 machine
> Scenario:
> (a) Stressful cpu hotplug tests + kernel compilation
> 
> (b) IRQ balancing had been disabled and all the IRQs  were made to be
>     routed to CPU 0 (except the ones that couldn't be routed).
> 
> (c) Lockdep was enabled during kernel configuration.
> 
> Steps (b) and (c) were done to dig deeper into the issue. However the same
> issue was observed by just doing step (a).
> 
> Definitely there seems to be a race condition occurring here, because this
> issue is hit after sometime, after starting the tests. And the time it
> takes to hit the issue increases as we increase the number of debug print
> statements. In some cases (especially when the number of debug print
> statements were quite high), the stress on the machine had to be increased
> in order to hit the issue within measurable time. In my tests, a maximum
> of about 2 to 2.5 hours was sufficient, to hit this bug.
> 
> Please find the console log attached with this mail.
> 
> Any ideas on how to go about fixing this bug?

It's probably a bug in the core brlock implementation.  I don't know
who would work on fixing that.

