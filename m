Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751476Ab1GTMgF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jul 2011 08:36:05 -0400
Received: from merlin.infradead.org ([205.233.59.134]:59205 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751006Ab1GTMgD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jul 2011 08:36:03 -0400
Subject: Re: [PATCH tip/core/urgent 1/7] rcu: decrease rcu_report_exp_rnp
 coupling with scheduler
From: Peter Zijlstra <peterz@infradead.org>
To: Ed Tomlinson <edt@aei.ca>
Cc: paulmck@linux.vnet.ibm.com, linux-kernel@vger.kernel.org, mingo@elte.hu,
        laijs@cn.fujitsu.com, dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org, greearb@candelatech.com
In-Reply-To: <201107200723.33819.edt@aei.ca>
References: <20110720001738.GA16369@linux.vnet.ibm.com>
	 <1311129618.5345.2.camel@twins> <20110720045414.GC2400@linux.vnet.ibm.com>
	 <201107200723.33819.edt@aei.ca>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 20 Jul 2011 14:35:20 +0200
Message-ID: <1311165320.5345.77.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-07-20 at 07:23 -0400, Ed Tomlinson wrote:
> [    3.553004]  [<ffffffff8104b06a>] warn_slowpath_null+0x1a/0x20
> [    3.553004]  [<ffffffff810bb479>] __rcu_read_unlock+0xc9/0x120
> [    3.553004]  [<ffffffff8103fed8>] cpuacct_charge+0xc8/0xe0
> [    3.553004]  [<ffffffff8103fe58>] ? cpuacct_charge+0x48/0xe0
> [    3.553004]  [<ffffffff810326b7>] ? task_of+0x97/0xd0
> [    3.553004]  [<ffffffff81040ef5>] update_curr+0x1a5/0x210
> [    3.553004]  [<ffffffff81576d78>] ? preempt_schedule_irq+0x68/0xa0
> [    3.553004]  [<ffffffff810419e0>] put_prev_task_fair+0x110/0x120
> [    3.553004]  [<ffffffff81575f3a>] schedule+0x1da/0xc50
> [    3.553004]  [<ffffffff81576d72>] ? preempt_schedule_irq+0x62/0xa0
> [    3.553004]  [<ffffffff81576d78>] preempt_schedule_irq+0x68/0xa0
> [    3.553004]  [<ffffffff8157a316>] retint_kernel+0x26/0x30
> [    3.553004]  [<ffffffff810da494>] ? ftrace_likely_update+0x14/0x20
> [    3.553004]  [<ffffffff810bb4ab>] __rcu_read_unlock+0xfb/0x120
> [    3.553004]  [<ffffffff810f8190>] find_get_page+0x170/0x190 

Ok, so we're running some task that does rcu_read_unlock(), right in the
middle of __rcu_read_unlock() we get preempted, the scheduler calls
rcu_note_context_switch()->rcu_preempt_note_context_switch() which sets
->rcu_read_unlock_special |= UNLOCK_BLOCKED.

Then before finishing the context switch, the cpuacct muck uses rcu, and
its rcu_read_unlock() triggers __rcu_read_unlock() and goes bang.

That rcu usage isn't new, that's been there since March 2009.

AFAICT even .39 should suffer from this particular issue, or am I
missing something here.. Paul?
