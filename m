Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751427Ab0FHEQU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jun 2010 00:16:20 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:41074 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751033Ab0FHEQS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jun 2010 00:16:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=XiP+ZLbxwWO0cbVybH7erISZNfH9up3JI9MO30+S1flIqXGfir5KRT94v4ta8SGtJX
         jlfxg/CtOOuvWPVwvIk6Nncp89WFZqL6jOeLVRleZEKBr2qOtn0qR5PtI1AENR7knhLZ
         VHXZYNsgHs9i1kTjkTfeip3BT7IzG+NUn05N4=
MIME-Version: 1.0
In-Reply-To: <20100608001929.GF2387@linux.vnet.ibm.com>
References: <AANLkTin2pPqOUx--9fIX3BH3e-cU6oCRufijcx_4ozx5@mail.gmail.com>
	<20100608001929.GF2387@linux.vnet.ibm.com>
Date: Tue, 8 Jun 2010 00:16:16 -0400
Message-ID: <AANLkTikl13cJNuU32JzRarrUnoh5DYHr-Tbnv9B-UjsG@mail.gmail.com>
Subject: Re: 2.6.35-rc2-git1 - include/linux/cgroup.h:534 invoked 
	rcu_dereference_check() without protection!
From: Miles Lane <miles.lane@gmail.com>
To: paulmck@linux.vnet.ibm.com
Cc: Vivek Goyal <vgoyal@redhat.com>, Eric Paris <eparis@redhat.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>, nauman@google.com,
       eric.dumazet@gmail.com, netdev@vger.kernel.org,
       Jens Axboe <jens.axboe@oracle.com>,
       Gui Jianfeng <guijianfeng@cn.fujitsu.com>,
       Li Zefan <lizf@cn.fujitsu.com>,
       Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 7, 2010 at 8:19 PM, Paul E. McKenney
<paulmck@linux.vnet.ibm.com> wrote:
> On Mon, Jun 07, 2010 at 02:14:25PM -0400, Miles Lane wrote:
>> Hi All,
>>
>> I just reproduced a warning I reported quite a while ago.  Is a patch
>> for this in the pipeline?
>
> I proposed a patch, thinking that it was a false positive.  Peter Zijlstra
> pointed out that there was a real race, and proposed an alternative patch,
> which may be found at http://lkml.org/lkml/2010/4/22/603.
>
> Could you please test Peter's patch and let us know if it cures the problem?
>
>                                                        Thanx, Paul
>
>> [    0.167267] [ INFO: suspicious rcu_dereference_check() usage. ]
>> [    0.167396] ---------------------------------------------------
>> [    0.167526] include/linux/cgroup.h:534 invoked
>> rcu_dereference_check() without protection!
>> [    0.167728]
>> [    0.167729] other info that might help us debug this:
>> [    0.167731]
>> [    0.168092]
>> [    0.168093] rcu_scheduler_active = 1, debug_locks = 1
>> [    0.168337] no locks held by watchdog/0/5.
>> [    0.168462]
>> [    0.168463] stack backtrace:
>> [    0.168704] Pid: 5, comm: watchdog/0 Not tainted 2.6.35-rc2-git1 #8
>> [    0.168834] Call Trace:
>> [    0.168965]  [<ffffffff81064e9c>] lockdep_rcu_dereference+0x9d/0xa5
>> [    0.169100]  [<ffffffff8102c1ce>] task_subsys_state+0x59/0x70
>> [    0.169232]  [<ffffffff8103189b>] __sched_setscheduler+0x19d/0x2f8
>> [    0.169365]  [<ffffffff8102a5ef>] ? need_resched+0x1e/0x28
>> [    0.169497]  [<ffffffff813c7d01>] ? schedule+0x586/0x619
>> [    0.169628]  [<ffffffff81081c33>] ? watchdog+0x0/0x8c
>> [    0.169758]  [<ffffffff81031a11>] sched_setscheduler+0xe/0x10
>> [    0.169889]  [<ffffffff81081c5d>] watchdog+0x2a/0x8c
>> [    0.170010]  [<ffffffff81081c33>] ? watchdog+0x0/0x8c
>> [    0.170141]  [<ffffffff81054a82>] kthread+0x89/0x91
>> [    0.170274]  [<ffffffff81003054>] kernel_thread_helper+0x4/0x10
>> [    0.170405]  [<ffffffff813ca480>] ? restore_args+0x0/0x30
>> [    0.170536]  [<ffffffff810549f9>] ? kthread+0x0/0x91
>> [    0.170667]  [<ffffffff81003050>] ? kernel_thread_helper+0x0/0x10
>> [    0.176751] lockdep: fixing up alternatives.
>

With the patch, I get:

[    0.151274] [ INFO: suspicious rcu_dereference_check() usage. ]
[    0.151390] ---------------------------------------------------
[    0.151520] include/linux/cgroup.h:534 invoked
rcu_dereference_check() without protection!
[    0.151723]
[    0.151724] other info that might help us debug this:
[    0.151726]
[    0.151999]
[    0.151999] rcu_scheduler_active = 1, debug_locks = 1
[    0.151999] 2 locks held by kthreadd/10:
[    0.151999]  #0:  (key){......}, at: [<ffffffff81036578>] complete+0x1c/0x4e
[    0.151999]  #1:  (&rq->lock){-.-...}, at: [<ffffffff81037875>]
select_task_rq_fair+0x21f/0x791
[    0.151999]
[    0.151999] stack backtrace:
[    0.151999] Pid: 10, comm: kthreadd Not tainted 2.6.35-rc2-git1 #11
[    0.151999] Call Trace:
[    0.151999]  [<ffffffff81070a45>] lockdep_rcu_dereference+0x9d/0xa5
[    0.151999]  [<ffffffff8103675e>] task_subsys_state+0x59/0x70
[    0.151999]  [<ffffffff8103799a>] select_task_rq_fair+0x344/0x791
[    0.151999]  [<ffffffff81037335>] ? task_rq_lock+0x68/0x9d
[    0.151999]  [<ffffffff811d62f3>] ? do_raw_spin_lock+0x79/0x13e
[    0.151999]  [<ffffffff81037335>] ? task_rq_lock+0x68/0x9d
[    0.151999]  [<ffffffff8103ac1e>] select_task_rq+0x13/0x44
[    0.151999]  [<ffffffff810417c3>] try_to_wake_up+0xf2/0x37d
[    0.151999]  [<ffffffff81041a5b>] default_wake_function+0xd/0xf
[    0.151999]  [<ffffffff81034272>] __wake_up_common+0x49/0x7f
[    0.151999]  [<ffffffff81036596>] complete+0x3a/0x4e
[    0.151999]  [<ffffffff8105b598>] ? worker_thread+0x0/0x3a7
[    0.151999]  [<ffffffff8105f7d0>] kthread+0x73/0x91
[    0.151999]  [<ffffffff8100aba4>] kernel_thread_helper+0x4/0x10
[    0.151999]  [<ffffffff813e3694>] ? restore_args+0x0/0x30
[    0.151999]  [<ffffffff8105f75d>] ? kthread+0x0/0x91
[    0.151999]  [<ffffffff8100aba0>] ? kernel_thread_helper+0x0/0x10
