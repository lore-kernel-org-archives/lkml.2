Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932288Ab0IIXFD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 19:05:03 -0400
Received: from mx.ij.cx ([212.13.201.15]:53612 "EHLO wes.ijneb.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757480Ab0IIXEu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 19:04:50 -0400
Date: Fri, 10 Sep 2010 00:04:31 +0100 (BST)
From: Mark Hills <mark@pogo.org.uk>
To: Peter Zijlstra <peterz@infradead.org>
cc: Balbir Singh <balbir@linux.vnet.ibm.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        linux-kernel@vger.kernel.org
Subject: Re: cgroup: rmdir() does not complete
In-Reply-To: <1284033017.402.8.camel@laptop>
Message-ID: <alpine.NEB.2.01.1009091416100.26432@jrf.vwaro.pbz>
References: <alpine.NEB.2.01.1008261415240.8857@jrf.vwaro.pbz>  <20100827095639.6e7297de.nishimura@mxp.nes.nec.co.jp>  <20100827113506.2bbbb7b9.kamezawa.hiroyu@jp.fujitsu.com>  <20100827123948.b4427a15.nishimura@mxp.nes.nec.co.jp> 
 <20100827144225.3190167a.kamezawa.hiroyu@jp.fujitsu.com>  <alpine.NEB.2.01.1009011200050.6596@jrf.vwaro.pbz>  <20100902084200.e9b773cf.kamezawa.hiroyu@jp.fujitsu.com>  <alpine.NEB.2.01.1009091051400.17759@jrf.vwaro.pbz>  <20100909100909.GM4443@balbir.in.ibm.com>
  <alpine.NEB.2.01.1009091234230.26366@jrf.vwaro.pbz> <1284033017.402.8.camel@laptop>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SA-Exim-Connect-IP: 82.28.218.61
X-SA-Exim-Mail-From: mark@pogo.org.uk
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 9 Sep 2010, Peter Zijlstra wrote:

> On Thu, 2010-09-09 at 12:36 +0100, Mark Hills wrote:
> 
> > I am still finding the problem incredibly hard to reproduce, so I'd like 
> > to observe as much data as possible from the current case before 
> > rebooting. If I could capture some kind of stack trace in the kernel for 
> > the running process that would be great, any suggestions appreciated.
> 
> echo l > /proc/sysrq-trigger

Despite running this many times, I never 'catch' the process on a CPU, 
despite it using 70% in top. But...

> another thing you can do is run something like: perf record -gp $pid
> which will give you a profile of that task.

This is very useful, thanks.

The report on the spinning process (23586) is dominated by calls from 
mem_cgroup_force_empty.

It seems to show lru_add_drain_all and drain_all_stock_sync are causing 
the load (I assume drain_all_stock_sync has been optimised out). But I 
don't think this is as important as what causes the spin.

There are no tasks in the cgroup, but memory usage is non-zero and 
constant. It seems mem_cgroup_force_empty is unable to empty the cgroup in 
this case.

  # cat /cgroup/soaked-23586/tasks
  # cat /cgroup/soaked-23586/memory.usage_in_bytes
  24576
  # cat /cgroup/soaked-23586/memsw.usage_in_bytes
  <hangs>

Here are the first few entries from the perf output, I can provide the 
rest if needed, but all result from mem_cgroup_force_empty.

     8.13%   :23586  [kernel]           [k] _raw_spin_lock_irqsave
             |
             --- _raw_spin_lock_irqsave
                |          
                |--45.14%-- probe_workqueue_insertion
                |          insert_work
                |          |          
                |          |--99.09%-- __queue_work
                |          |          queue_work_on
                |          |          schedule_work_on
                |          |          schedule_on_each_cpu
                |          |          |          
                |          |          |--50.59%-- lru_add_drain_all
                |          |          |          mem_cgroup_force_empty
                |          |          |          mem_cgroup_pre_destroy
                |          |          |          cgroup_rmdir
                |          |          |          vfs_rmdir
                |          |          |          do_rmdir
                |          |          |          sys_rmdir
                |          |          |          system_call_fastpath
                |          |          |          0x3f504d27d7
                |          |          |          0x405687
                |          |          |          0x406ef0
                |          |          |          0x402f31
                |          |          |          0x3f5041eb1d
                |          |          |          
                |          |           --49.41%-- mem_cgroup_force_empty
                |          |                     mem_cgroup_pre_destroy
                |          |                     cgroup_rmdir
                |          |                     vfs_rmdir
                |          |                     do_rmdir
                |          |                     sys_rmdir
                |          |                     system_call_fastpath
                |          |                     0x3f504d27d7
                |          |                     0x405687
                |          |                     0x406ef0
                |          |                     0x402f31
                |          |                     0x3f5041eb1d
                |           --0.91%-- [...]
                |          
                |--22.92%-- mem_cgroup_force_empty
                |          mem_cgroup_pre_destroy
                |          cgroup_rmdir
                |          vfs_rmdir
                |          do_rmdir
                |          sys_rmdir
                |          system_call_fastpath
                |          0x3f504d27d7
                |          0x405687
                |          0x406ef0
                |          0x402f31
                |          0x3f5041eb1d
                |          
                |--8.17%-- __queue_work
                |          queue_work_on
                |          schedule_work_on
                |          schedule_on_each_cpu
                |          |          
                |          |--52.09%-- lru_add_drain_all
                |          |          mem_cgroup_force_empty
                |          |          mem_cgroup_pre_destroy
                |          |          cgroup_rmdir
                |          |          vfs_rmdir
                |          |          do_rmdir
                |          |          sys_rmdir
                |          |          system_call_fastpath
                |          |          0x3f504d27d7
                |          |          0x405687
                |          |          0x406ef0
                |          |          0x402f31
                |          |          0x3f5041eb1d
                |          |          
                |           --47.91%-- mem_cgroup_force_empty
                |                     mem_cgroup_pre_destroy
                |                     cgroup_rmdir
                |                     vfs_rmdir
                |                     do_rmdir
                |                     sys_rmdir
                |                     system_call_fastpath
                |                     0x3f504d27d7
                |                     0x405687
                |                     0x406ef0
                |                     0x402f31
                |                     0x3f5041eb1d
                |          
                |--7.94%-- __wake_up
                |          |          
                |          |--99.71%-- insert_work
                |          |          |          
                |          |          |--97.70%-- __queue_work
                |          |          |          queue_work_on
                |          |          |          schedule_work_on
                |          |          |          schedule_on_each_cpu
                |          |          |          |          
                |          |          |          |--50.59%-- mem_cgroup_force_empty
                |          |          |          |          mem_cgroup_pre_destroy
                |          |          |          |          cgroup_rmdir
                |          |          |          |          vfs_rmdir
                |          |          |          |          do_rmdir
                |          |          |          |          sys_rmdir
                |          |          |          |          system_call_fastpath
                |          |          |          |          0x3f504d27d7
                |          |          |          |          0x405687
                |          |          |          |          0x406ef0
                |          |          |          |          0x402f31
                |          |          |          |          0x3f5041eb1d
                |          |          |          |          
                |          |          |           --49.41%-- lru_add_drain_all
                |          |          |                     mem_cgroup_force_empty
                |          |          |                     mem_cgroup_pre_destroy
                |          |          |                     cgroup_rmdir
                |          |          |                     vfs_rmdir
                |          |          |                     do_rmdir
                |          |          |                     sys_rmdir
                |          |          |                     system_call_fastpath
                |          |          |                     0x3f504d27d7
                |          |          |                     0x405687
                |          |          |                     0x406ef0
                |          |          |                     0x402f31
                |          |          |                     0x3f5041eb1d
                |          |           --2.30%-- [...]
                |           --0.29%-- [...]
                |          
                |--4.35%-- mem_cgroup_pre_destroy
                |          cgroup_rmdir
                |          vfs_rmdir
                |          do_rmdir
                |          sys_rmdir
                |          system_call_fastpath
                |          0x3f504d27d7
                |          0x405687
                |          0x406ef0
                |          0x402f31
                |          0x3f5041eb1d
                 --11.47%-- [...]

     7.25%   :23586  [kernel]           [k] sched_clock_cpu
             |
             --- sched_clock_cpu
                |          
                |--97.11%-- update_rq_clock
                |          |          
                |          |--98.89%-- try_to_wake_up
                |          |          default_wake_function
                |          |          autoremove_wake_function
                |          |          __wake_up_common
                |          |          __wake_up
                |          |          insert_work
                |          |          __queue_work
                |          |          queue_work_on
                |          |          schedule_work_on
                |          |          schedule_on_each_cpu
                |          |          |          
                |          |          |--50.69%-- lru_add_drain_all
                |          |          |          mem_cgroup_force_empty
                |          |          |          mem_cgroup_pre_destroy
                |          |          |          cgroup_rmdir
                |          |          |          vfs_rmdir
                |          |          |          do_rmdir
                |          |          |          sys_rmdir
                |          |          |          system_call_fastpath
                |          |          |          0x3f504d27d7
                |          |          |          0x405687
                |          |          |          0x406ef0
                |          |          |          0x402f31
                |          |          |          0x3f5041eb1d
                |          |          |          
                |          |           --49.31%-- mem_cgroup_force_empty
                |          |                     mem_cgroup_pre_destroy
                |          |                     cgroup_rmdir
                |          |                     vfs_rmdir
                |          |                     do_rmdir
                |          |                     sys_rmdir
                |          |                     system_call_fastpath
                |          |                     0x3f504d27d7
                |          |                     0x405687
                |          |                     0x406ef0
                |          |                     0x402f31
                |          |                     0x3f5041eb1d
                |           --1.11%-- [...]
                 --2.89%-- [...]

     5.54%   :23586  [kernel]           [k] try_to_wake_up
             |
             --- try_to_wake_up
                |          
                |--99.13%-- default_wake_function
                |          autoremove_wake_function
                |          __wake_up_common
                |          __wake_up
                |          insert_work
                |          __queue_work
                |          queue_work_on
                |          schedule_work_on
                |          schedule_on_each_cpu
                |          |          
                |          |--52.03%-- lru_add_drain_all
                |          |          mem_cgroup_force_empty
                |          |          mem_cgroup_pre_destroy
                |          |          cgroup_rmdir
                |          |          vfs_rmdir
                |          |          do_rmdir
                |          |          sys_rmdir
                |          |          system_call_fastpath
                |          |          0x3f504d27d7
                |          |          0x405687
                |          |          0x406ef0
                |          |          0x402f31
                |          |          0x3f5041eb1d
                |          |          
                |           --47.97%-- mem_cgroup_force_empty
                |                     mem_cgroup_pre_destroy
                |                     cgroup_rmdir
                |                     vfs_rmdir
                |                     do_rmdir
                |                     sys_rmdir
                |                     system_call_fastpath
                |                     0x3f504d27d7
                |                     0x405687
                |                     0x406ef0
                |                     0x402f31
                |                     0x3f5041eb1d
                 --0.87%-- [...]

-- 
Mark
