Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752733Ab0HKHfr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 03:35:47 -0400
Received: from mail1-relais-roc.national.inria.fr ([192.134.164.82]:14518 "EHLO
	mail1-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752354Ab0HKHfq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 03:35:46 -0400
X-IronPort-AV: E=Sophos;i="4.55,352,1278280800"; 
   d="scan'208";a="65264593"
Message-ID: <4C6252CF.1090100@inria.fr>
Date: Wed, 11 Aug 2010 09:35:43 +0200
From: Tomasz Buchert <Tomasz.Buchert@inria.fr>
User-Agent: Thunderbird 2.0.0.24 (X11/20100411)
MIME-Version: 1.0
To: Matt Helsley <matthltc@us.ibm.com>
CC: Paul Menage <menage@google.com>, Li Zefan <lizf@cn.fujitsu.com>,
        containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cgroup_freezer: Freezing and task move race fix
References: <1281470001-14320-1-git-send-email-tomasz.buchert@inria.fr> <20100810215741.GC2927@count0.beaverton.ibm.com> <4C61D044.2060703@inria.fr> <20100811042738.GH2927@count0.beaverton.ibm.com>
In-Reply-To: <20100811042738.GH2927@count0.beaverton.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matt Helsley a écrit :
> On Wed, Aug 11, 2010 at 12:18:44AM +0200, Tomasz Buchert wrote:
>> Matt Helsley a écrit :
>>> On Tue, Aug 10, 2010 at 09:53:21PM +0200, Tomasz Buchert wrote:
>>>> Writing 'FROZEN' to freezer.state file does not
>>>> forbid the task to be moved away from its cgroup
>>>> (for a very short time). Nevertheless the moved task
>>>> can become frozen OUTSIDE its cgroup which puts
>>>> discussed task in a permanent 'D' state.
>>>>
>>>> This patch forbids migration of either FROZEN
>>>> or FREEZING tasks.
>>>>
>>>> This behavior was observed and easily reproduced on
>>>> a single core laptop. Program and instructions how
>>>> to reproduce the bug can be fetched from:
>>>> http://pentium.hopto.org/~thinred/repos/linux-misc/freezer_bug.c
>>> Thanks for the report and the test code.
>>>
>>> I'm will try to reproduce this race in the next few hours and analyze
>>> it since I'm not sure the patch really fixes the race -- it may only
>>> make the race trigger less frequently.
>>>
>>> At the very least the patch won't break the current code since it's
>>> essentially a more-strict version of is_task_frozen_enough() -- it lets
>>> fewer tasks attach/detach to/from frozen cgroups.
>>>
>>> Cheers,
>>> 	-Matt Helsley
>> Hi Matt!
>> I am a novice if it comes to the kernel and I find the cgroup_freezer
>> code especially complicated, so definetely this may be not enough to fix that.
>> Notice also that if you uncomment the line 55 in my testcase this will also
>> trigger the race! This, however, makes sense since process may not be in the cgroup anymore
>> and consequently won't be thawed.
> 
> OK, I triggered it with that. Interesting.
> 

Good!

>> I think that this patch fixes these problems because it does the flag checking in a right order:
>> first freezing() is used and then frozen() which assures (see frozen_process()) that
>> the race will not happen. Right? :)
> 
> I see what you mean. It still seems like it wouldn't actually fix the race -- just make it
> harder to trigger. I think you're saying this is what happens without the patch:
> 
> Time	"bug" goes through these states		cgroup code checks for these states
> -----------------------------------------------------------------------------------
> |	freezing
> |						is_frozen? Nope.
> |	frozen
> |						is_freezing? Nope.
> |						<move>
> V
> 
My first scenario was a bit different:
Time	"bug" goes through these states		cgroup code checks for these states
-----------------------------------------------------------------------------------
|	freezing
|						is_task_frozen_enough? Nope.
|						<move>
|	frozen
V
but the problem is the same.

> But, without having carefully investigated the details, this could just as easily happen
> with your patch:
> 
> Time	"bug" goes through these states		cgroup code checks for these states
> -----------------------------------------------------------------------------------
> |						is_freezing? Nope.
> |						is_frozen? Nope.
> |	freezing
> |						<move>
> |	frozen
> V
> 

This can't happen as far as I know because there is cgroup_lock around the code in freezer_write()
and freezer_can_attach().
The task can't enter 'freezing' state when can_attach is executed.

> or:
> 
> Time	"bug" goes through these states		cgroup code checks for these states
> -----------------------------------------------------------------------------------
> |						is_freezing? Nope.
> |						is_frozen? Nope.
> |	freezing
> |	frozen
> |						<move>
> V
> 

Same thing here.

> Time	"bug" goes through these states		cgroup code checks for these states
> -----------------------------------------------------------------------------------
> |						is_freezing? Nope.
> |	freezing
> |						is_frozen? Nope.
> |						<move>
> |	frozen
> V
> 

Again.

> or:
> 
> Time	"bug" goes through these states		cgroup code checks for these states
> -----------------------------------------------------------------------------------
> |						is_freezing? Nope.
> |	freezing
> |						is_frozen? Nope.
> |	frozen
> |						<move>
> V
> 
> (even with 1 cpu/core)

Well, once more.

> 
> Your patch only improves things in the sense that it works for the first
> example. We need to prevent the latter cases as well.
> 
> Cheers,
> 	-Matt

What do you think?

Tomasz
