Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755567Ab1JTAN5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 20:13:57 -0400
Received: from unicorn.mansr.com ([78.86.181.103]:53109 "EHLO
	unicorn.mansr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751010Ab1JTAN4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 20:13:56 -0400
From: =?iso-8859-1?Q?M=E5ns_Rullg=E5rd?= <mans@mansr.com>
To: Tim Bird <tim.bird@am.sony.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "linux-arm-kernel\@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Arnd Bergmann <arnd@arndb.de>, Andi Kleen <andi@firstfloor.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/3] ARM 4Kstacks: introduction
References: <4E9E0B71.9020708@am.sony.com>
	<20111019073547.GR21648@n2100.arm.linux.org.uk>
	<4E9F5F1B.1020106@am.sony.com>
Date: Thu, 20 Oct 2011 01:13:54 +0100
In-Reply-To: <4E9F5F1B.1020106@am.sony.com> (Tim Bird's message of "Wed, 19
	Oct 2011 16:36:59 -0700")
Message-ID: <yw1xvcrkr03h.fsf@unicorn.mansr.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tim Bird <tim.bird@am.sony.com> writes:

> On 10/19/2011 12:35 AM, Russell King - ARM Linux wrote:
>> On Tue, Oct 18, 2011 at 04:27:45PM -0700, Tim Bird wrote:
>>> I'm about to submit a set of patches (really pretty small)
>>> to add 4K stack support to ARM (defaulted to 'N').
>>>
>>> This has been kicking around in my Sony tree for a few years,
>>> and it's about time to mainline it.  The first patch is
>>> the actual 4KSTACKS patch.  See subsequent patches
>>> for tools to help with stack reduction to avoid the problems
>>> that apparently led to the removal of this feature on x86.
>> 
>> This isn't a good idea - if the feature has been abandoned on x86,
>> people aren't going to be soo concerned about the stack usage of
>> each function.  They're going to accept that there's more stack
>> space available, and we'll see code paths that start expecting that.
>
> Well, the difference in size is not an order of magnitude.  Current
> stacks are only twice as big as what this feature optionally allows.
> So people really shouldn't go crazy with their stack usage.
>
> Granted we're already seeing a bit of stack bloat, but IMHO this should
> be nipped in the bud.  If the stack grows a lot more, it will likely
> need to shift to 16K, which would REALLY be costly on machines
> with lots of threads and low memory.

In binary, 8k is an order of magnitude greater than 4k.  Having suffered
the consequences of 4k stacks on x86, I have to side with those
reluctant to include this.

> I don't want to give up on a small-footprint Linux so easily,
> and the discipline for keeping stacks small is probably good
> for code hygiene anyway.

I see your point of view, but an optional setting available only on an
architecture not used by the majority is probably not going to have much
of an impact on code hygiene.

4k stacks were tried, and the conclusion was that too much of the kernel
simply cannot work within so small a space.  Maintaining a list of safe
(or unsafe) combinations is probably not feasible either.

>> If we switch to 4K stacks, the problems of stack usage become ours.
>> Do we have the capacity to be able to address these issues as they
>> crop up?
>
> Since it's optional, it would become the problem of the people
> who actually use the option.  If you think tracking down stack
> abusers is going to be a pain, just don't do it.

It will still be one more thing to sanity check in every bug report.
The end result will be more crashes going ignored due to lacking
information, and I don't think that's a good thing.

> If I do it, and get pushback, then I'll make the case to individual
> function authors, and we'll see what happens from there.  As it is,
> this patch has been useful for me, and continues to be useful
> even in the current kernel version, with no other changes
> required in mainline.
>
> Having said this, I've written a tool to rather easily identify
> the functions which use the most stack, and so far the routines
> I've looked at have had rather simple solutions.  It almost always
> boils down to a single big data item on the stack.

Chasing heavy stack consumers is of course always a good thing, whatever
the stack size.

> I can understand if people don't want to take patches which
> unconditionally limit their stack usage - especially if there's
> a performance impact. But I don't see much rationale for not
> limiting their stack usage conditionally (that is, do something
> slightly different on #ifdef CONFIG_4KSTACKS).  If people
> object to even that, then I'll maintain those patches out of
> tree, if they're really needed.

Having such a conditional increases the maintenance burden for that
function.  Changes will be made without testing the 4k alternative,
which sooner or later will break, possibly in subtle ways.

> Once again, our products work even without such patches now,
> based on the configs we're using and the user-space we're running.
> Note that this is defaulted to 'N', so no one should be negatively
> affected unless they opt in.
>
> So, I understand your point.  I would, however, like to have
> this patch applied, and then deal with any problems as they
> come up, rather than preemptively kill the feature on speculative
> problems.

An option that will probably, let's be realistic, only be used by you
doesn't really belong in mainline.  You are essentially asking everybody
else to carry the burden of supporting something only you seem to need.

-- 
Måns Rullgård
mans@mansr.com
