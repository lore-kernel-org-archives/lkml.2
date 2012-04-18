Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751256Ab2DRF3k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 01:29:40 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:52629 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750730Ab2DRF3j convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 01:29:39 -0400
MIME-Version: 1.0
In-Reply-To: <20120417164503.GA27031@linux.vnet.ibm.com>
References: <CA+1xoqdJjTe+BMe_ebMBSg57gs2FA60T_0WKhrHvfDoE8AvCuw@mail.gmail.com>
 <20120417150556.GB2404@linux.vnet.ibm.com> <CA+1xoqc=ssJmfMTogN8H_8yqNXys8-yJbx7=XVVSN3CvOPcyWA@mail.gmail.com>
 <20120417155316.GE2404@linux.vnet.ibm.com> <20120417164503.GA27031@linux.vnet.ibm.com>
From: Sasha Levin <levinsasha928@gmail.com>
Date: Wed, 18 Apr 2012 07:29:19 +0200
Message-ID: <CA+1xoqc9ETMg3WxbNg_+KzEeYFVEgSwpWNPCdhEMDW2P=vQ+nQ@mail.gmail.com>
Subject: Re: New RCU related warning due to rcu_preempt_depth() changes
To: paulmck@linux.vnet.ibm.com
Cc: Dave Jones <davej@redhat.com>,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 17, 2012 at 6:45 PM, Paul E. McKenney
<paulmck@linux.vnet.ibm.com> wrote:
> On Tue, Apr 17, 2012 at 08:53:16AM -0700, Paul E. McKenney wrote:
>> On Tue, Apr 17, 2012 at 05:36:59PM +0200, Sasha Levin wrote:
>> > On Tue, Apr 17, 2012 at 5:05 PM, Paul E. McKenney
>> > <paulmck@linux.vnet.ibm.com> wrote:
>> > > On Tue, Apr 17, 2012 at 10:42:47AM +0200, Sasha Levin wrote:
>> > >> Hi Paul,
>> > >>
>> > >> It looks like commit 7298b03 ("rcu: Move __rcu_read_lock() and
>> > >> __rcu_read_unlock() to per-CPU variables") is causing the following
>> > >> warning (I've added the extra fields on the second line):
>> > >>
>> > >> [   77.330920] BUG: sleeping function called from invalid context at
>> > >> mm/memory.c:3933
>> > >> [   77.336571] in_atomic(): 0, irqs_disabled(): 0, preempt count: 0,
>> > >> preempt offset: 0, rcu depth: 1, pid: 5669, name: trinity
>> > >> [   77.344135] no locks held by trinity/5669.
>> > >> [   77.349644] Pid: 5669, comm: trinity Tainted: G        W
>> > >> 3.4.0-rc3-next-20120417-sasha-dirty #83
>> > >> [   77.354401] Call Trace:
>> > >> [   77.355956]  [<ffffffff810e83f3>] __might_sleep+0x1f3/0x210
>> > >> [   77.358811]  [<ffffffff81198eaf>] might_fault+0x2f/0xa0
>> > >> [   77.361997]  [<ffffffff810e3228>] schedule_tail+0x88/0xb0
>> > >> [   77.364671]  [<ffffffff826a01d3>] ret_from_fork+0x13/0x80
>> > >>
>> > >> As you can see, rcu_preempt_depth() returns 1 when running in that
>> > >> context, which looks pretty odd.
>> > >
>> > > Ouch!!!
>> > >
>> > > So it looks like I missed a place where I need to save and restore
>> > > the new per-CPU rcu_read_lock_nesting and rcu_read_unlock_special
>> > > variables.  My (probably hopelessly naive) guess is that I need to add
>> > > a rcu_switch_from() and rcu_switch_to() into schedule_tail(), but to
>> > > make rcu_switch_from() take the task_struct pointer as an argument,
>> > > passing in prev.
>> > >
>> > > Does this make sense, or am I still missing something here?
>> >
>> > I've let the test run for a bit more, and it appears that I'm getting
>> > this warning from lots of different sources, would this
>> > schedule_tail() fix all of them?
>>
>> If I understand the failure correctly, yes.  If the task switches without
>> RCU paying attention, the nesting count for both the outgoing and the
>> incoming tasks can get messed up.  The messed-up counts could easily
>> cause problems downstream.
>>
>> Of course, there might well be additional bugs.
>>
>> I will put a speculative patch together and send it along.
>
> And here it is, testing just started.
>
>                                                        Thanx, Paul
>
> ------------------------------------------------------------------------
>
> rcu: Add RCU context switching to schedule_tail()
>
> The new rcu_read_lock_nesting and rcu_read_unlock_special per-CPU
> variables must be saved and restored at every context switch, including
> those involving schedule_tail().  This commit therefore adds the saving
> and restoring to schedul_tail().
>
> Reported-by: Sasha Levin <levinsasha928@gmail.com>
> Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
>

Looks good here.

Thanks.
