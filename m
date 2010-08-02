Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753009Ab0HBHDs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 03:03:48 -0400
Received: from mail.lang.hm ([64.81.33.126]:51111 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752555Ab0HBHDq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 03:03:46 -0400
Date: Mon, 2 Aug 2010 00:02:04 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Florian Mickler <florian@mickler.org>
cc: Arjan van de Ven <arjan@infradead.org>, paulmck@linux.vnet.ibm.com,
        "Ted Ts'o" <tytso@mit.edu>, linux-pm@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, arve@android.com, mjg59@srcf.ucam.org,
        pavel@ucw.cz, rjw@sisk.pl, stern@rowland.harvard.edu,
        swetland@google.com, peterz@infradead.org, tglx@linutronix.de,
        alan@lxorguk.ukuu.org.uk
Subject: Re: Attempted summary of suspend-blockers LKML thread
In-Reply-To: <20100802085332.23dd22f6@schatten.dmk.lab>
Message-ID: <alpine.DEB.2.00.1008012355210.25170@asgard.lang.hm>
References: <20100731175841.GA9367@linux.vnet.ibm.com> <20100731215214.2543c07e@infradead.org> <20100801054816.GI2470@linux.vnet.ibm.com> <20100731230101.7cc1d8c7@infradead.org> <20100801191228.GL2470@linux.vnet.ibm.com> <20100801204026.GH31324@thunk.org>
 <20100802030304.GU2470@linux.vnet.ibm.com> <20100801210548.23f77ff6@infradead.org> <alpine.DEB.2.00.1008012153300.25170@asgard.lang.hm> <20100802074429.73a9dfd9@schatten.dmk.lab> <alpine.DEB.2.00.1008012303160.25170@asgard.lang.hm> <20100802084003.1c4c2bdb@schatten.dmk.lab>
 <20100802085332.23dd22f6@schatten.dmk.lab>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2 Aug 2010, Florian Mickler wrote:

> On Mon, 2 Aug 2010 08:40:03 +0200
> Florian Mickler <florian@mickler.org> wrote:
>
>> On Sun, 1 Aug 2010 23:06:08 -0700 (PDT)
>> david@lang.hm wrote:
>>
>>> On Mon, 2 Aug 2010, Florian Mickler wrote:
>>>
>>>> On Sun, 1 Aug 2010 22:06:34 -0700 (PDT)
>>>> david@lang.hm wrote:
>>>>
>>>>> On Sun, 1 Aug 2010, Arjan van de Ven wrote:
>>>>>
>>>>>> I'm a little worried that this whole "I need to block suspend" is
>>>>>> temporary. Yes today there is silicon from ARM and Intel where suspend
>>>>>> is a heavy operation, yet at the same time it's not all THAT heavy
>>>>>> anymore.... at least on the Intel side it's good enough to use pretty
>>>>>> much all the time (when the screen is off for now, but that's a memory
>>>>>> controller issue more than anything else). I'm pretty sure the ARM guys
>>>>>> will not be far behind.
>>>>>
>>>>> remember that this 'block suspend' is really 'block overriding the fact
>>>>> that there are still runable processes and suspending anyway"
>>>>>
>>>>> having it labeled as 'suspend blocker' or even 'wakelock' makes it sound
>>>>> as if it blocks any attempt to suspend, and I'm not sure that's what's
>>>>> really intended. Itsounds like the normal syspend process would continue
>>>>> to work, just this 'ignore if these other apps are busy' mode of operation
>>>>> would not work.
>>>>>
>>>>> which makes me wonder, would it be possible to tell the normal idle
>>>>> detection mechanism to ignore specific processes when deciding if it
>>>>> should suspend or not? how about only considering processes in one cgroup
>>>>> when deciding to suspend and ignoring all others?
>>>>>
>>>>> David Lang
>>>>
>>>> We then get again to the "runnable tasks" problem that was
>>>> discussed earlier... the system get's "deadlock-prone" if a subset of
>>>> tasks is not run.
>>>> Interprocess dependencies are not so easy to get right in general.
>>>
>>> I'm not suggesting that you don't run the 'untrusted' tasks, just that you
>>> don't consider them when deciding if the system can suspend or not. if the
>>> system is awake, everything runs, if the system is idle (except for the
>>> activity of the 'untrusted' tasks) you suspend normally.
>>>
>>> David Lang
>>
>> Ah, yes. Sorry. It's pretty early in the morning over here, I don't
>> seem to have my eyes fully opened yet... A "ignore-these-processes"
>> cgroup could probably work... It would have the advantage of not having
>> to maintain a special purpose API....
>>
>>
>> Cheers,
>> Flo
>>
>
> Thinking about it.. I don't know much about cgroups, but I think a
> process can only be in one cgroup at a time. So you'd need to provide
>
> a) a way to race free migrate them to the "suspend block" cgroup (or
> dropping them out of the "ignore" cgroup)

why does it need to be race free? being in transition is going to be 
logically the same as being in the other group.

it's not like applications will be moving back and forth between the two 
groups is it? I expect that this would be a one-time thing at startup.

> b) you can't use cgroup for other purposes anymore. I.e. if you want to
> have 2 groups that each only have half of the memory available, how
> would you then integrate the cgroup-ignore-for-idle-approach with this?

two answers to this

1. does this matter? do you really need to combine this 'suspend, even if 
there are processes trying to run' with other cgroup limitations?

2. who says that this must be limited to one cgroup? a cgroup can have 
several different flags/limits set on it, so why can't one of them be this 
'ignore for suspend' flag?

these seem like simple issues, what I don't know is if it's possible for 
the process that controlls suspend to follow such a flag without major 
surgury on it's innards (if it can, this seems like a easy win, but I can 
imagine internal designs where the software just knows that _something_ is 
trying to run and would have a very hard time figuring out what)

David Lang
