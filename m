Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758622Ab1ENQea (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 May 2011 12:34:30 -0400
Received: from one.firstfloor.org ([213.235.205.2]:51032 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753459Ab1ENQe3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 May 2011 12:34:29 -0400
Date: Sat, 14 May 2011 18:34:24 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
        libc-alpha@sourceware.org, Andi Kleen <ak@linux.intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 4/5] Add a sysconf syscall
Message-ID: <20110514163424.GU6008@one.firstfloor.org>
References: <1305329059-2017-1-git-send-email-andi@firstfloor.org> <1305329059-2017-5-git-send-email-andi@firstfloor.org> <20110514065752.GA8827@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110514065752.GA8827@elte.hu>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> What glibc does (opening /proc/stat) is rather stupid, but i think your syscall 

I don't think it has any other choice today. So if anything is "stupid"
it is the kernel for not providing efficient interfaces for this.

> Note that these are mostly constant or semi-constant values that are updated 
> very rarely:

That's not true. Most of them are dynamic. Take a look at the patch.
Also several of those have changed recently.

> If glibc is stupid and reads /proc/stat to receive something it could cache or 
> mmap() itself then hey, did you consider fixing glibc or creating a sane libc? 
Caching doesn't help when you have a workload that exec()s a lot.
Also some of these values can change at runtime.

> If we *really* want to offer kernel help for these values even then your 
> solution is still wrong: then the proper solution would be to define a standard 
> *data* structure and map it as a vsyscall *data* page - essentially a 
> kernel-guaranteed data mmap(), with no extra syscall needed!

That's quite complicted because several of those are dynamically computed
based on other values. Sometimes they are also not tied to the mm_struct -- like
the vsyscall is. For example some of the rlimits are per task, not VM.
Basically your proposal doesn't interact well with clone().

Even if we ignored that semantic problem it would need another writable page 
per task because the values cannot be shared.

Also I never liked the idea of having more writable pages per task,
It increases the memory footprint of a single process more. Given a 4K
page is not a lot, but lots of 4K pages add up. Some workloads like
to have lots of small processes and I think that's a valuable use
case Linux should stay lean and efficient at.

[OK in theory one could do COW for the page and share it but that would
get really complicated]

I also don't think it's THAT performance critical to justify the vsyscall. 
The simple syscall is already orders of magnitude faster than /proc, and 
seems to solve the performance problems we've seen completely. 

It's also simple and straight forward and simple to userstand and maintain.
I doubt any of that would apply to a vsyscall solution.

I don't think the additional effort for a vsyscall would be worth
it at this point, unless there's some concrete example that would
justify it. Even then it wouldn't work for some of the values.

Also a vsyscall doesn't help on non x86 anyways.

As for efficiency: I thought about doing a batched interface where
the user could pass in an array of values to fill in. But at least for the 
workloads I looked at the application usually calls sysconf() where
the array size would be always 1. And that's the standard interface.
This might be still worth doing, but I would like to see a concrete
use case first.

> That could have other uses as well in the future.

Hmm for what?

Note we already have a fast mechanism to pass some thing to glibc
in the aux vector. 

> 
> That way it would much faster than your current code btw.
> 
> So unless there are some compelling arguments in favor of sys_sysconf() that i 
> missed, i have to NAK this:

Well see above for lots of reasons you missed. They are understandable
mistakes for someone who first looks at the problem though. I'll 
attempt to improve the documentation next time.

-Andi
