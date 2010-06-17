Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754579Ab0FQGn3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 02:43:29 -0400
Received: from casper.infradead.org ([85.118.1.10]:34116 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752174Ab0FQGn2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 02:43:28 -0400
Date: Wed, 16 Jun 2010 23:43:03 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Maxim Levitsky <maximlevitsky@gmail.com>,
       Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
       Jiri Slaby <jslaby@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cpuidle: avoid using smp_processor_id() in preemptible
 code (nr_iowait_cpu) v4
Message-ID: <20100616234303.584c13c2@infradead.org>
In-Reply-To: <20100617062950.GA3979@swordfish>
References: <20100614140941.GA3581@swordfish.minsk.epam.com>
	<20100614073853.6fa2f91f@infradead.org>
	<20100614145439.GA3448@swordfish.minsk.epam.com>
	<20100614080154.7d6a71fc@infradead.org>
	<20100614151735.GB3448@swordfish.minsk.epam.com>
	<20100614204021.52c50cdc@infradead.org>
	<20100615061927.GA3312@swordfish>
	<20100615072435.5a47d850@infradead.org>
	<20100615145029.GB3967@swordfish.minsk.epam.com>
	<20100615080808.6286448b@infradead.org>
	<20100617062950.GA3979@swordfish>
Organization: Intel
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Jun 2010 09:29:50 +0300
Sergey Senozhatsky <sergey.senozhatsky@gmail.com> wrote:

> Fix
>    
>  BUG: using smp_processor_id() in preemptible [00000000] code:
> s2disk/3392 caller is nr_iowait_cpu+0xe/0x1e
>  Pid: 3392, comm: s2disk Not tainted 2.6.35-rc3-dbg-00106-ga75e02b #2
>  Call Trace:
>  [<c1184c55>] debug_smp_processor_id+0xa5/0xbc
>  [<c10282a5>] nr_iowait_cpu+0xe/0x1e
>  [<c104ab7c>] update_ts_time_stats+0x32/0x6c
>  [<c104ac73>] get_cpu_idle_time_us+0x36/0x58
>  [<c124229b>] get_cpu_idle_time+0x12/0x74   
>  [<c1242963>] cpufreq_governor_dbs+0xc3/0x2dc
>  [<c1240437>] __cpufreq_governor+0x51/0x85   
>  [<c1241190>] __cpufreq_set_policy+0x10c/0x13d
>  [<c12413d3>] cpufreq_add_dev_interface+0x212/0x233
>  [<c1241b1e>] ? handle_update+0x0/0xd
>  [<c1241a18>] cpufreq_add_dev+0x34b/0x35a
>  [<c103c973>] ? schedule_delayed_work_on+0x11/0x13
>  [<c12c14db>] cpufreq_cpu_callback+0x59/0x63
>  [<c1042f39>] notifier_call_chain+0x26/0x48 
>  [<c1042f7d>] __raw_notifier_call_chain+0xe/0x10
>  [<c102efb9>] __cpu_notify+0x15/0x29
>  [<c102efda>] cpu_notify+0xd/0xf
>  [<c12bfb30>] _cpu_up+0xaf/0xd2 
>  [<c12b3ad4>] enable_nonboot_cpus+0x3d/0x94
>  [<c1055eef>] hibernation_snapshot+0x104/0x1a2
>  [<c1058b49>] snapshot_ioctl+0x24b/0x53e
>  [<c1028ad1>] ? sub_preempt_count+0x7c/0x89
>  [<c10ab91d>] vfs_ioctl+0x2e/0x8c
>  [<c10588fe>] ? snapshot_ioctl+0x0/0x53e
>  [<c10ac2c7>] do_vfs_ioctl+0x42f/0x45a  
>  [<c10a0ba5>] ? fsnotify_modify+0x4f/0x5a
>  [<c11e9dc3>] ? tty_write+0x0/0x1d0
>  [<c10a12d6>] ? vfs_write+0xa2/0xda
>  [<c10ac333>] sys_ioctl+0x41/0x62  
>  [<c10027d3>] sysenter_do_call+0x12/0x2d
> 
> The initial fix was to use get_cpu/put_cpu in nr_iowait_cpu.  However,
> Arjan stated that "the bug is that it needs to be nr_iowait_cpu(int
> cpu)".
> 
> This patch introduces nr_iowait_cpu(int cpu) and changes to its
> callers.
> 
> Arjan also pointed out that we can't use get_cpu/put_cpu in
> update_ts_time_stats since we "pick the current cpu, rather than the
> one denoted by ts" in that case. To match given *ts and cpu denoted
> by *ts we use new field in the struct tick_sched: int cpu.
> 
> Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>

Acked-by: Arjan van de Ven <arjan@linux.intel.com>


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
