Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750930Ab0DWEAe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 00:00:34 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:53447 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750722Ab0DWEAd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 00:00:33 -0400
Message-ID: <4BD11BCD.4070409@cn.fujitsu.com>
Date: Fri, 23 Apr 2010 12:02:21 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: Balbir Singh <balbir@linux.vnet.ibm.com>,
       Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Subject: Re: [BUGFIX][PATCH] memcg rcu lock fix in swap code (Was Re: [BUG]
 an RCU warning in memcg
References: <4BD10D59.9090504@cn.fujitsu.com>	<20100423121424.ae47efcb.kamezawa.hiroyu@jp.fujitsu.com>	<4BD118E2.7080307@cn.fujitsu.com>	<4BD11A24.2070500@cn.fujitsu.com> <20100423125043.b3b964cd.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20100423125043.b3b964cd.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KAMEZAWA Hiroyuki wrote:
> On Fri, 23 Apr 2010 11:55:16 +0800
> Li Zefan <lizf@cn.fujitsu.com> wrote:
> 
>> Li Zefan wrote:
>>> KAMEZAWA Hiroyuki wrote:
>>>> On Fri, 23 Apr 2010 11:00:41 +0800
>>>> Li Zefan <lizf@cn.fujitsu.com> wrote:
>>>>
>>>>> with CONFIG_PROVE_RCU=y, I saw this warning, it's because
>>>>> css_id() is not under rcu_read_lock().
>>>>>
>>>> Ok. Thank you for reporting.
>>>> This is ok ? 
>>> Yes, and I did some more simple tests on memcg, no more warning
>>> showed up.
>>>
>> oops, after trigging oom, I saw 2 more warnings:
>>
> 
> ok, I will update.  thank you.
> 

one more:

===================================================
[ INFO: suspicious rcu_dereference_check() usage. ]
---------------------------------------------------
kernel/cgroup.c:4438 invoked rcu_dereference_check() without protection!

other info that might help us debug this:


rcu_scheduler_active = 1, debug_locks = 1
3 locks held by bash/2270:
 #0:  (cgroup_mutex){+.+.+.}, at: [<c049ab37>] cgroup_lock_live_group+0x17/0x30
 #1:  (&mm->mmap_sem){++++++}, at: [<c0517302>] mem_cgroup_can_attach+0xb2/0x130
 #2:  (&(&mm->page_table_lock)->rlock){+.+.-.}, at: [<c0513c23>] mem_cgroup_count_precharge_pte_range+0x93/0x130

stack backtrace:
Pid: 2270, comm: bash Not tainted 2.6.34-rc5-tip+ #14
Call Trace:
 [<c083c636>] ? printk+0x1d/0x1f
 [<c0480744>] lockdep_rcu_dereference+0x94/0xb0
 [<c049d6ed>] css_id+0x5d/0x60
 [<c051373f>] is_target_pte_for_mc+0x16f/0x1c0
 [<c083f46b>] ? _raw_spin_lock+0x6b/0x80
 [<c0513c4d>] mem_cgroup_count_precharge_pte_range+0xbd/0x130
 [<c0513b90>] ? mem_cgroup_count_precharge_pte_range+0x0/0x130
 [<c05030bd>] walk_page_range+0x25d/0x3f0
 [<c0517344>] mem_cgroup_can_attach+0xf4/0x130
 [<c0513b90>] ? mem_cgroup_count_precharge_pte_range+0x0/0x130
 [<c0517250>] ? mem_cgroup_can_attach+0x0/0x130
 [<c049e000>] cgroup_attach_task+0x70/0x280
 [<c049e633>] cgroup_tasks_write+0x63/0x1c0
 [<c049e660>] ? cgroup_tasks_write+0x90/0x1c0
 [<c049d515>] cgroup_file_write+0x1f5/0x230
 [<c0842f90>] ? do_page_fault+0x0/0x500
 [<c047107b>] ? up_read+0x1b/0x30
 [<c0843195>] ? do_page_fault+0x205/0x500
 [<c051a8c4>] vfs_write+0xa4/0x1a0
 [<c049d320>] ? cgroup_file_write+0x0/0x230
 [<c051b3f6>] sys_write+0x46/0x70
 [<c0403090>] sysenter_do_call+0x12/0x36
