Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754458Ab1J1Ccf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Oct 2011 22:32:35 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:52816 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752853Ab1J1Cce (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Oct 2011 22:32:34 -0400
Message-ID: <4EAA14A1.5060204@cn.fujitsu.com>
Date: Fri, 28 Oct 2011 10:34:09 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, eric.dumazet@gmail.com,
        shaohua.li@intel.com, ak@linux.intel.com, mhocko@suse.cz,
        alex.shi@intel.com, efault@gmx.de, linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL rcu/next] RCU commits for 3.1
References: <20110930204503.GA32687@linux.vnet.ibm.com> <20111001152514.GA16930@elte.hu> <20111003055302.GA23527@elte.hu> <20111003161335.GA2403@linux.vnet.ibm.com> <20111004074637.GA14061@elte.hu> <20111024100501.GA24913@linux.vnet.ibm.com> <20111024114806.GA3340@linux.vnet.ibm.com> <20111026203020.GA10285@elte.hu> <20111027075901.GB2313@linux.vnet.ibm.com> <20111027080016.GA16885@elte.hu>
In-Reply-To: <20111027080016.GA16885@elte.hu>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-10-28 10:30:34,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-10-28 10:30:37,
	Serialize complete at 2011-10-28 10:30:37
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>
>>>> And I cannot reproduce after merging into 3.1.  :-(
>>>
>>> Here's another one i just got with latest -tip:
>>>
>>> PM: Adding info for No Bus:vcsa2
>>>
>>> ===============================
>>> [ INFO: suspicious RCU usage. ]
>>> -------------------------------
>>> include/linux/cgroup.h:548 suspicious rcu_dereference_check() usage!
>>>
>>> other info that might help us debug this:
>>>
>>>
>>> rcu_scheduler_active = 1, debug_locks = 0
>>> 1 lock held by true/655:
>>>  #0:  (&sig->cred_guard_mutex){+.+.+.}, at: [<810d1bd7>] prepare_bprm_creds+0x27/0x70
>>>
>>> stack backtrace:
>>> Pid: 655, comm: true Not tainted 3.1.0-tip-01868-g1271bd2-dirty #161079
>>> Call Trace:
>>>  [<81abe239>] ? printk+0x18/0x1a
>>>  [<81064920>] lockdep_rcu_suspicious+0xc0/0xd0
>>>  [<8108aa02>] perf_event_enable_on_exec+0x1d2/0x1e0
>>>  [<81063764>] ? __lock_release+0x54/0xb0
>>>  [<8108cca8>] perf_event_comm+0x18/0x60
>>>  [<810d1abd>] ? set_task_comm+0x5d/0x80

void set_task_comm(struct task_struct *tsk, char *buf)
{
        task_lock(tsk);
	...
        task_unlock(tsk);
        perf_event_comm(tsk);
}

see, perf_event_comm() is called after releasing task_lock.

perf_event_comm()
  perf_event_enable_on_exec()
    perf_cgroup_sched_out()
      perf_cgroup_from_task()
        task_subsys_state()

No proper lock is held, hence the warning.

>>>  [<81af622d>] ? _raw_spin_unlock+0x1d/0x40
>>>  [<810d1ac4>] set_task_comm+0x64/0x80
>>>  [<810d25fd>] setup_new_exec+0xbd/0x1d0
>>>  [<810d1b61>] ? flush_old_exec+0x81/0xa0
>>>  [<8110753e>] load_elf_binary+0x28e/0xa00
>>>  [<810d2101>] ? search_binary_handler+0xd1/0x1d0
>>>  [<81063764>] ? __lock_release+0x54/0xb0
>>>  [<811072b0>] ? load_elf_library+0x260/0x260
>>>  [<810d2108>] search_binary_handler+0xd8/0x1d0
>>>  [<810d2060>] ? search_binary_handler+0x30/0x1d0
>>>  [<810d242f>] do_execve_common+0x22f/0x2a0
>>>  [<810d24b2>] do_execve+0x12/0x20
>>>  [<81009592>] sys_execve+0x32/0x70
>>>  [<81af7752>] ptregs_execve+0x12/0x20
>>>  [<81af76d4>] ? sysenter_do_call+0x12/0x36
>>>
>>> Note that the backtrace suggests that perf was used - and indeed on 
>>> that testbox i have this in rc.local:
>>>
>>> /home/mingo/bin/perf stat true &
>>>
>>> ... which i forgot about, completely.
>>>
>>> If you try 'perf stat true' can you trigger the warning perhaps?
>>
>> Ah!  I will install this into my KVM image and see what happens.
>> Your /home/mingo/bin/perf is a script that does "perf stat true"
>> in a loop?
> 
> no, it's just plain 'perf' installed locally.
> 
