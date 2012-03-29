Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759746Ab2C2U02 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 16:26:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24891 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759152Ab2C2U0Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 16:26:25 -0400
Date: Thu, 29 Mar 2012 16:26:19 -0400
From: Dave Jones <davej@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Theodore Ts'o" <tytso@mit.edu>, Wu Fengguang <fengguang.wu@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: lockups shortly after booting in current git.
Message-ID: <20120329202619.GA14001@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Theodore Ts'o <tytso@mit.edu>,
	Wu Fengguang <fengguang.wu@intel.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <20120329155542.GA31285@redhat.com>
 <CA+55aFxOcMt_mcr+ZYwc-SpKbROnh4Gn7jqrFY_SZcBy1Ev7Qw@mail.gmail.com>
 <20120329182632.GA6891@redhat.com>
 <CA+55aFx-nzGm1ZZD5bNxmPF2orkXc1_4nCE0jdtznz+AqhBx3A@mail.gmail.com>
 <20120329195354.GA11790@redhat.com>
 <CA+55aFxyutCDZhVa8HCu=hpn0454sfoM27Jwh2heCN0cqg5pjA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFxyutCDZhVa8HCu=hpn0454sfoM27Jwh2heCN0cqg5pjA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 29, 2012 at 01:10:21PM -0700, Linus Torvalds wrote:
 > On Thu, Mar 29, 2012 at 12:53 PM, Dave Jones <davej@redhat.com> wrote:
 > >
 > > sysrq-p looks kinda boring. I couldn't get sysrq-l to coincide
 > > with kworker running.
 > 
 > Yeah, none of that looks interesting.
 > 
 > Apparently kworker isn't actually using all CPU after all.

Ok, so progress, kinda.  I can now reproduce it in 10 minutes
just by starting a make -j8 on the kernel, and running fsx in parallel
on the same ssd.

While that's building, I'll click around in firefox, and after a few
minutes, it comes to a standstill. At that point, I can't spawn
new shells. 

kworker does seem to be a red herring. This time, I'm looking at top and..

top - 16:24:02 up 16 min, 10 users,  load average: 11.27, 9.62, 5.58
Tasks: 164 total,   1 running, 163 sleeping,   0 stopped,   0 zombie
Cpu(s):  0.2%us,  3.3%sy,  0.0%ni, 49.1%id, 47.4%wa,  0.0%hi,  0.0%si,  0.0%st
Mem:   3991860k total,  1832652k used,  2159208k free,    67320k buffers
Swap:  6109180k total,        0k used,  6109180k free,   696908k cached

  PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND                                                                                 
 1082 root      20   0  175m  20m 9.9m S  4.6  0.5   1:18.24 Xorg                                                                                    
 2918 davej     20   0 15260 1404 1008 R  1.6  0.0   0:17.23 top                                                                                     
    7 root      -2   0     0    0    0 S  0.3  0.0   0:03.38 rcuc/0                         


Pretty dull. Loadavg is consistent at 11, nothing is making forward progress,
and make/fsx are ignoring ctrl-c/ctrl-z

I had a perf top running in another window. It took doesn't show anything exciting..

  8.83%  [kernel]                            [k] read_hpet
  8.26%  [kernel]                            [k] lock_is_held
  5.53%  [kernel]                            [k] __lock_acquire
  4.71%  [kernel]                            [k] sub_preempt_count
  4.32%  [kernel]                            [k] add_preempt_count
  3.90%  [kernel]                            [k] debug_smp_processor_id
  3.86%  [kernel]                            [k] __module_address
  3.24%  [kernel]                            [k] sched_clock_local
  2.92%  [kernel]                            [k] lock_release
  2.91%  [kernel]                            [k] rcu_lockdep_current_cpu_online
  2.22%  [iwlwifi]                           [k] iwl_trans_pcie_read32
  1.92%  [kernel]                            [k] lock_acquired
  1.84%  [kernel]                            [k] match_held_lock
  1.78%  [kernel]                            [k] rcu_is_cpu_idle
  1.76%  [kernel]                            [k] trace_hardirqs_off_caller
  1.72%  [kernel]                            [k] debug_lockdep_rcu_enabled
  1.70%  [kernel]                            [k] native_read_tsc
  1.62%  [kernel]                            [k] local_clock

I'll go back to trying the bisect now that I know how to reproduce it quickly.
Do you think it might be worth restricting the bisect to fs/ ?
Or shall I just do the whole tree bisect from 3.3 ?

	Dave

