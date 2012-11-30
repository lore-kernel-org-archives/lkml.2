Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758226Ab2K3MpL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 07:45:11 -0500
Received: from cantor2.suse.de ([195.135.220.15]:39399 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756630Ab2K3MpI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 07:45:08 -0500
Date: Fri, 30 Nov 2012 13:45:06 +0100
From: Michal Hocko <mhocko@suse.cz>
To: azurIt <azurit@pobox.sk>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        cgroups mailinglist <cgroups@vger.kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH for 3.2.34] memcg: do not trigger OOM from
 add_to_page_cache_locked
Message-ID: <20121130124506.GH29317@dhcp22.suse.cz>
References: <20121123074023.GA24698@dhcp22.suse.cz>
 <20121123102137.10D6D653@pobox.sk>
 <20121123100438.GF24698@dhcp22.suse.cz>
 <20121125011047.7477BB5E@pobox.sk>
 <20121125120524.GB10623@dhcp22.suse.cz>
 <20121125135542.GE10623@dhcp22.suse.cz>
 <20121126013855.AF118F5E@pobox.sk>
 <20121126131837.GC17860@dhcp22.suse.cz>
 <20121126132149.GD17860@dhcp22.suse.cz>
 <20121130032918.59B3F780@pobox.sk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121130032918.59B3F780@pobox.sk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 30-11-12 03:29:18, azurIt wrote:
> >Here we go with the patch for 3.2.34. Could you test with this one,
> >please?
> 
> 
> Michal, unfortunately i had to boot to another kernel because the one
> with this patch keeps killing my MySQL server :( it was, probably,
> doing it on OOM in any cgroup - looks like OOM was not choosing
> processes only from cgroup which is out of memory. Here is the log
> from syslog: http://www.watchdog.sk/lkml/oom_mysqld

You are seeing also global OOM:
Nov 30 02:53:56 server01 kernel: [  818.233159] Pid: 9247, comm: apache2 Not tainted 3.2.34-grsec #1
Nov 30 02:53:56 server01 kernel: [  818.233289] Call Trace:
Nov 30 02:53:56 server01 kernel: [  818.233470]  [<ffffffff810cc90e>] dump_header+0x7e/0x1e0
Nov 30 02:53:56 server01 kernel: [  818.233600]  [<ffffffff810cc80f>] ? find_lock_task_mm+0x2f/0x70
Nov 30 02:53:56 server01 kernel: [  818.233721]  [<ffffffff810ccdd5>] oom_kill_process+0x85/0x2a0
Nov 30 02:53:56 server01 kernel: [  818.233842]  [<ffffffff810cd485>] out_of_memory+0xe5/0x200
Nov 30 02:53:56 server01 kernel: [  818.233963]  [<ffffffff8102aa8f>] ? pte_alloc_one+0x3f/0x50
Nov 30 02:53:56 server01 kernel: [  818.234082]  [<ffffffff810cd65d>] pagefault_out_of_memory+0xbd/0x110
Nov 30 02:53:56 server01 kernel: [  818.234204]  [<ffffffff81026ec6>] mm_fault_error+0xb6/0x1a0
Nov 30 02:53:56 server01 kernel: [  818.235886]  [<ffffffff8102739e>] do_page_fault+0x3ee/0x460
Nov 30 02:53:56 server01 kernel: [  818.236006]  [<ffffffff810f3057>] ? vma_merge+0x1f7/0x2c0
Nov 30 02:53:56 server01 kernel: [  818.236124]  [<ffffffff810f35d7>] ? do_brk+0x267/0x400
Nov 30 02:53:56 server01 kernel: [  818.236244]  [<ffffffff812c9a92>] ? gr_learn_resource+0x42/0x1e0
Nov 30 02:53:56 server01 kernel: [  818.236367]  [<ffffffff815b547f>] page_fault+0x1f/0x30
[...]
Nov 30 02:53:56 server01 kernel: [  818.356297] Out of memory: Kill process 2188 (mysqld) score 60 or sacrifice child
Nov 30 02:53:56 server01 kernel: [  818.356493] Killed process 2188 (mysqld) total-vm:3330016kB, anon-rss:864176kB, file-rss:8072kB

Then you also have memcg oom killer:
Nov 30 02:53:56 server01 kernel: [  818.375717] Task in /1037/uid killed as a result of limit of /1037
Nov 30 02:53:56 server01 kernel: [  818.375886] memory: usage 102400kB, limit 102400kB, failcnt 736
Nov 30 02:53:56 server01 kernel: [  818.376008] memory+swap: usage 102400kB, limit 102400kB, failcnt 0

The messages are intermixed and I guess rate limitting jumped in as
well, because I cannot associate all the oom messages to a specific OOM
event.

Anyway your system is under both global and local memory pressure. You
didn't see apache going down previously because it was probably the one
which was stuck and could be killed.
Anyway you need to setup your system more carefully.

> Maybe i should mention that MySQL server has it's own cgroup (called
> 'mysql') but with no limits to any resources.

Where is that group in the hierarchy?
> 
> azurIt
> --
> To unsubscribe from this list: send the line "unsubscribe cgroups" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Michal Hocko
SUSE Labs
