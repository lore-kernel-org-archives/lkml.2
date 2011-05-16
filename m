Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755407Ab1EPNhP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 09:37:15 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:32891 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755225Ab1EPNhN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 09:37:13 -0400
Date: Mon, 16 May 2011 15:36:55 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, libc-alpha@sourceware.org,
        Andi Kleen <ak@linux.intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 4/5] Add a sysconf syscall
Message-ID: <20110516133655.GG7128@elte.hu>
References: <1305329059-2017-1-git-send-email-andi@firstfloor.org>
 <1305329059-2017-5-git-send-email-andi@firstfloor.org>
 <20110514065752.GA8827@elte.hu>
 <20110514163424.GU6008@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110514163424.GU6008@one.firstfloor.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andi Kleen <andi@firstfloor.org> wrote:

> > What glibc does (opening /proc/stat) is rather stupid, but i think your 
> > syscall
> 
> I don't think it has any other choice today. [...]

Sure it has a choice: most of the sysconf values are global so creating a 
permanent mmap()-able data in /tmp or elsewhere and mapping it unless it's 
inaccessible isnt that particularly hard to cache most of the system-wide 
constants, now is it?

The CPU count could be updated from CPU hotplug events.

rlimits can be queried using getrlimit().

If at that point glibc said to us: "hey, lets work in making it even faster" 
then there would be no reason for us to criticise glibc. Right now gibc does 
not even *try* to be smart about it.

> [...] So if anything is "stupid" it is the kernel for not providing efficient 
> interfaces for this.
> 
> > Note that these are mostly constant or semi-constant values that are 
> > updated very rarely:
> 
> That's not true. Most of them are dynamic. Take a look at the patch.
> Also several of those have changed recently.

As i said they are mostly constant or semi-constant values that are updated 
very rarely.

If you think that i am wrong then do me the basic courtesy of mentioning the 
examples that you think disprove my claim, instead of broadly pointing me to 
your patch ...

> > If glibc is stupid and reads /proc/stat to receive something it could cache 
> > or mmap() itself then hey, did you consider fixing glibc or creating a sane 
> > libc?
>
> Caching doesn't help when you have a workload that exec()s a lot. Also some 
> of these values can change at runtime.

Here you modify your claim. Now it's not 'dynamic' anymore but 'can change'?

Which one is it now, "mostly constant or semi-constant values that are updated 
very rarely" as i claim, "dynamic" as you first claimed or "can change" as you 
claim here (which is also pretty ambiguous)?

> > If we *really* want to offer kernel help for these values even then your 
> > solution is still wrong: then the proper solution would be to define a 
> > standard *data* structure and map it as a vsyscall *data* page - 
> > essentially a kernel-guaranteed data mmap(), with no extra syscall needed!
> 
> That's quite complicted because several of those are dynamically computed 
> based on other values. Sometimes they are also not tied to the mm_struct -- 
> like the vsyscall is. For example some of the rlimits are per task, not VM. 
> Basically your proposal doesn't interact well with clone().

Threads with different rlimits but shared VM are extreme rarities.

Could we please concentrate on the common case? A '-1' in the data page can let 
the code fall back to some slow path.

Also note that rlimit itself already has an interface to query them: 
getrlimit(). So if you do not want the complexity of caching rlimits in the 
data page you do not have to start with that complexity.

[ But it can be done: modifying the rlimit (which predominantly only happens in 
  the login process) is rare and happens in a parent task. ]

> Even if we ignored that semantic problem it would need another writable page 
> per task because the values cannot be shared.

Sure most of the values can be shared.

Most of them are exactly one of a low number of variants for all tasks in the 
system, for typical Linux bootups. I suspect if the data page was COW-ed but 
inherited across exec() it would behave exactly the way it should be: inherited 
by all tasks but privatized if a task modifies it for itself and all children.

Also, the first step could be simplified by not exposing rlimits - as rlimits 
are already exposed via other channels.

> Also I never liked the idea of having more writable pages per task, [...]

If you limit it to your own faulty implementation then i'm not surprised that 
you do not like it.

> [...] It increases the memory footprint of a single process more. Given a 4K 
> page is not a lot, but lots of 4K pages add up. Some workloads like to have 
> lots of small processes and I think that's a valuable use case Linux should 
> stay lean and efficient at.
> 
> [OK in theory one could do COW for the page and share it but that would get 
> really complicated]

Why would it get complicated? It's not writable to user-space, that's all that 
is special about it.

> I also don't think it's THAT performance critical to justify the vsyscall.

You apparently did not understand the gist of my point: it's the CONCEPT of 
adding a crappy catch-all sysconf() interface that sucks IMHO. It's simply bad 
taste.

If you want to expose data then expose the data intelligently, not some poor 
system call interface that is also slower.

> The simple syscall is already orders of magnitude faster than /proc, and 
> seems to solve the performance problems we've seen completely.

A handful of horse manure is less stinky than a big pile of it, still i wouldnt 
want to eat either.

> It's also simple and straight forward and simple to userstand and maintain. I 
> doubt any of that would apply to a vsyscall solution.

Note: i did not suggest a vsyscall, but a vsyscall *data area*. There's a big 
difference between the two!

It could be passed down to user-space using a new auxiliary entry (see 
fs/binfmt_elf.c), as it's really part of a task's environment conceptually.

> I don't think the additional effort for a vsyscall would be worth it at this 
> point, unless there's some concrete example that would justify it. Even then 
> it wouldn't work for some of the values.
> 
> Also a vsyscall doesn't help on non x86 anyways.

There's nothing x86 about aux entries.

> As for efficiency: I thought about doing a batched interface where
> the user could pass in an array of values to fill in. But at least for the 
> workloads I looked at the application usually calls sysconf() where
> the array size would be always 1. And that's the standard interface.
> This might be still worth doing, but I would like to see a concrete
> use case first.
> 
> > That could have other uses as well in the future.
> 
> Hmm for what?

*Iff* the concensus is that we are fine with a new page per task/thread then we 
could use it for all sorts of nifty things like the current CPU id for example.

> Note we already have a fast mechanism to pass some thing to glibc in the aux 
> vector.

So when you got so far in your reply why did you not delete your above (false) 
outrage about the vsyscall, which i never suggested and which you thus forced 
me to reply to?

> > That way it would much faster than your current code btw.
> > 
> > So unless there are some compelling arguments in favor of sys_sysconf() 
> > that i missed, i have to NAK this:
> 
> Well see above for lots of reasons you missed. They are understandable 
> mistakes for someone who first looks at the problem though. I'll attempt to 
> improve the documentation next time.

I don't think your condescending tone towards me is warranted or fair, i 
offered a fair technical criticism of your patch series. Why are you
attacking me like this?

Thanks,

	Ingo
