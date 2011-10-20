Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755798Ab1JTBIp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 21:08:45 -0400
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:51100 "EHLO
	TX2EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753379Ab1JTBIo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 21:08:44 -0400
X-SpamScore: -20
X-BigFish: VPS-20(zzbb2dK9371Kc89bh1418M1432N98dKzz1202hzz8275bhz2fh668h839h93fh61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:160.33.98.74;KIP:(null);UIP:(null);IPVD:NLI;H:mail7.fw-bc.sony.com;RD:mail7.fw-bc.sony.com;EFVD:NLI
X-FB-SS: 0,
Message-ID: <4E9F7483.9050608@am.sony.com>
Date: Wed, 19 Oct 2011 18:08:19 -0700
From: Tim Bird <tim.bird@am.sony.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.12) Gecko/20100907 Fedora/3.0.7-1.fc12 Thunderbird/3.0.7
MIME-Version: 1.0
To: =?UTF-8?B?TcOlbnMgUnVsbGfDpXJk?= <mans@mansr.com>
CC: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Arnd Bergmann <arnd@arndb.de>,
        linux kernel <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>, Thomas Gleixner <tglx@linutronix.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 0/3] ARM 4Kstacks: introduction
References: <4E9E0B71.9020708@am.sony.com>	<20111019073547.GR21648@n2100.arm.linux.org.uk>	<4E9F5F1B.1020106@am.sony.com> <yw1xvcrkr03h.fsf@unicorn.mansr.com>
In-Reply-To: <yw1xvcrkr03h.fsf@unicorn.mansr.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: am.sony.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/19/2011 05:13 PM, � wrote:
> Tim Bird <tim.bird@am.sony.com> writes:
>> Well, the difference in size is not an order of magnitude.  Current
>> stacks are only twice as big as what this feature optionally allows.
>> So people really shouldn't go crazy with their stack usage.
>>
>> Granted we're already seeing a bit of stack bloat, but IMHO this should
>> be nipped in the bud.  If the stack grows a lot more, it will likely
>> need to shift to 16K, which would REALLY be costly on machines
>> with lots of threads and low memory.
> 
> In binary, 8k is an order of magnitude greater than 4k.
Touche' ;-)

> Having suffered
> the consequences of 4k stacks on x86, I have to side with those
> reluctant to include this.

Can you please provide more detail on what consequences
you suffered?  I think it would help the discussion.

If you had some examples where the burden of supporting 4K stacks
was onerous, that would be useful.  I know that defaulting it to
'Y' introduced lots of subtle bugs that desktop users had issues
with.  The situation is completely different in deeply embedded,
because our user-space is completely constrained and controlled.

Also, there are a now a plethora of stack depth monitoring, guarding,
and reporting tools already in mainline, some of which weren't
there during the painful era.

>> I don't want to give up on a small-footprint Linux so easily,
>> and the discipline for keeping stacks small is probably good
>> for code hygiene anyway.
> 
> I see your point of view, but an optional setting available only on an
> architecture not used by the majority is probably not going to have much
> of an impact on code hygiene.
> 
> 4k stacks were tried, and the conclusion was that too much of the kernel
> simply cannot work within so small a space.  Maintaining a list of safe
> (or unsafe) combinations is probably not feasible either.

That's not what was in the message of the commit that removed them
on x86.  Instead it was conjecture about high numbers of threads
being only applicable to x86_64.

Are you basing the conclusion above on conjecture or measurement?  In
my configuration, the worst code paths are using approximately 2K of
stack most of the time, and peak out at about 2.5K.

>>> If we switch to 4K stacks, the problems of stack usage become ours.
>>> Do we have the capacity to be able to address these issues as they
>>> crop up?
>>
>> Since it's optional, it would become the problem of the people
>> who actually use the option.  If you think tracking down stack
>> abusers is going to be a pain, just don't do it.
> 
> It will still be one more thing to sanity check in every bug report.
> The end result will be more crashes going ignored due to lacking
> information, and I don't think that's a good thing.

I don't think mainline is overwhelmed with bug reports from
embedded developers.  Most of the time, embedded devs are so far behind
in kernel version that they can't reasonably (and don't) report many
bugs found. (I know that this is not helping my case, but I'm trying to be
honest here.)

If 4K stacks were being turned on for the general population of Linux
users, then I would agree with you.  But this will likely only be
turned on by a few people, in controlled situations. If you think
tainting the kernel would help with the bug reporting, I'd be
OK with that.  We could introduce a "crazy embedded config - you're
on your own" taint flag.

> 
>> If I do it, and get pushback, then I'll make the case to individual
>> function authors, and we'll see what happens from there.  As it is,
>> this patch has been useful for me, and continues to be useful
>> even in the current kernel version, with no other changes
>> required in mainline.
>>
>> Having said this, I've written a tool to rather easily identify
>> the functions which use the most stack, and so far the routines
>> I've looked at have had rather simple solutions.  It almost always
>> boils down to a single big data item on the stack.
> 
> Chasing heavy stack consumers is of course always a good thing, whatever
> the stack size.
> 
>> I can understand if people don't want to take patches which
>> unconditionally limit their stack usage - especially if there's
>> a performance impact. But I don't see much rationale for not
>> limiting their stack usage conditionally (that is, do something
>> slightly different on #ifdef CONFIG_4KSTACKS).  If people
>> object to even that, then I'll maintain those patches out of
>> tree, if they're really needed.
> 
> Having such a conditional increases the maintenance burden for that
> function.  Changes will be made without testing the 4k alternative,
> which sooner or later will break, possibly in subtle ways.

Which will affect no one but those who opt in.  I just don't
think the maintenance burden will be that big.  (At least,
no one need be bothered by this, unless contacted by someone
who cares.)

>> Once again, our products work even without such patches now,
>> based on the configs we're using and the user-space we're running.
>> Note that this is defaulted to 'N', so no one should be negatively
>> affected unless they opt in.
>>
>> So, I understand your point.  I would, however, like to have
>> this patch applied, and then deal with any problems as they
>> come up, rather than preemptively kill the feature on speculative
>> problems.
> 
> An option that will probably, let's be realistic, only be used by you
> doesn't really belong in mainline.  You are essentially asking everybody
> else to carry the burden of supporting something only you seem to need.

I'm not so sure that I'm the only one interested in this.
I'll ask around and see if I can find others.  I'll have
a good chance at ELC Europe next week.

But in general this attitude is really depressing.  I can
remember when support for niche use cases was considered good.
I understand the tradeoff if the maintenance burden is high,
but I'm not convinced it is.  I don't expect anyone to
proactively guard against or remedy stack depth issues.  But if
they'd be open to accepting patches from those who care, that'd
be nice.

If you're saying that Linux is only for use on general purpose
platforms, and deeply embedded doesn't matter, I think that's sad.
 -- Tim

=============================
Tim Bird
Architecture Group Chair, CE Workgroup of the Linux Foundation
Senior Staff Engineer, Sony Network Entertainment
=============================

