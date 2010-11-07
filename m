Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753418Ab0KGV1y (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Nov 2010 16:27:54 -0500
Received: from serrano.cc.columbia.edu ([128.59.29.6]:33231 "EHLO
	serrano.cc.columbia.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753194Ab0KGV1x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Nov 2010 16:27:53 -0500
Message-ID: <4CD71A6B.3020905@cs.columbia.edu>
Date: Sun, 07 Nov 2010 16:30:19 -0500
From: Oren Laadan <orenl@cs.columbia.edu>
Organization: Columbia University
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Lightning/1.0b1 Thunderbird/3.0.10
MIME-Version: 1.0
To: Gene Cooperman <gene@ccs.neu.edu>
CC: Kapil Arya <kapil@ccs.neu.edu>, Tejun Heo <tj@kernel.org>,
        ksummit-2010-discuss@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, hch@lst.de
Subject: Re: [Ksummit-2010-discuss] checkpoint-restart: naked patch
References: <Pine.LNX.4.64.1011021530470.12128@takamine.ncl.cs.columbia.edu> <4CD08419.5050803@kernel.org> <AANLkTinOg6n3ZA+0gHzw9LouRuUmJ7DJwHtABRy5c=gM@mail.gmail.com> <4CD26948.7050009@kernel.org> <20101104164401.GC10656@sundance.ccs.neu.edu> <4CD3CE29.2010105@kernel.org> <AANLkTimDXKsBCxbsEOfgkYV2R8FK=bhFdmx9UQow5hqp@mail.gmail.com> <4CD5DCE3.3000109@cs.columbia.edu> <20101107194222.GG31077@sundance.ccs.neu.edu>
In-Reply-To: <20101107194222.GG31077@sundance.ccs.neu.edu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-No-Spam-Score: Local
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 11/07/2010 02:42 PM, Gene Cooperman wrote:
> I'd like to add a few clafifications, below, about DMTCP concerning
> Oren's comments.  I'd also like to point out that we've had about 100
> downloads per month from sourceforge (and some interesting use cases
> from end users) over the last year (although the sourceforge numbers
> do go up and down :-) ).  In general, I think we'll all understand the
> situation better after having had the opportunity to talk offline.
> Below are some clarifications about DMTCP.
> ===
>
>> For example, in your example, you'd need to wrap the library calls
>> (e.g. of MPI implementation) and replaced them to use TCP/IP or
>> infiniband. Wrapping on system calls won't help you.
>
> We do not put any wrappers around MPI library calls.  MPI calls things
> like open, close, connect, listen, execve({"ssh", ...}, ...), etc.
> At this time, DMTCP adds wrappers _only_ around calls to libc.so
> and libpthread.so .  This is sufficient to checkpoint a distributed
> computation like MPI.

Of course. And you don't need syscall virtualization for this.
Zap did it already many years ago :)  Only problem with the above
is that, conveniently enough, you _left out_ the context:

 >> For example,
 >> if a distributed computation runs over infiniband, can we migrate to 
a TCP/IP
 >> cluster. For this, one needs the flexibility of wrappers around 
system calls.

Do you also support checkpoint a distributed app that uses an
infiniband MPI stack and restart it with a TCP based MPI stack ?
Can you do it with only syscall wrapping and without knowledge
on the MPI implementation and some MPI-specific logic in the
wrappers ?   I'm curious how you do that without wrapping around
MPI calls, or without an c/r-aware implementation of MPI.

Again, this is unrelated to how you do the core c/r work. I think
we both agree that _this_ kind of app-wrappers/app-awareness is
useful for certain uses of c/r.

[snip]

>> So I'll repeat the question I asked there: is re-reimplementing
>> chunks of kernel functionality and all namespaces in userspace
>> the way to go ?
>
> If you're referring to interposition here, that takes place essentially
> in the wrappers, and the wrappers are only 3000 lines of code in DMTCP.
> Also, I don't believe that we're "re-implementing chunks of kernel
> functionality", but let's continue that discussion offline.

The interposition itself is relatively simple (though not atomic).
The problem is the logic to "spy" on and "lie" to the applications.
Examples: saving ptrace state, saving FD_CLOEXEC flag, correctly
maintaining a userspace pid-ns, etc.

[...]

>
>> ... (yes, transparent means that
>> it does not require LD_PRELOAD or collaboration of the application!
>> nor does it require userspace virtualizations of so many things
>> already provided by the kernel today), more generic, more flexible,
>> provides more guarantees, cover more types or states of resources,
>> and can perform significantly better.
>
> I still haven't understood why you object to the DMTCP use of LD_PRELOAD.
> How will the user app ever know that we used LD_PRELOAD, since we remove
> LD_PRELOAD from the environment before the user app libraries and main
> can begin?  And, if you really object to LD_PRELOAD, then there are
> other ways to capture control.  Similarly, I'll have to understand better

I don't object to it per se - it's actually pretty useful oftentimes.
But in our context, it has limitations. For example, it does not
cover static applications, nor apps that call syscalls directly
using int 0x80. Also, it conflicts with LD_PRELOAD possibly needed
for other software (like valgrind) - for which again you would need
yet another per-app wrapper, at the very least.

> what you mean by the _collaboration of the application_.  DMTCP operates
> on unmodified application binaries.

I mean that the applications needs to be scheduled and to run to
participate in its own checkpoint. You use syscall interposition
and signals games to do exactly that - gain control over the app
and run your library's code. This has at least three negatives:
first, some apps don't want to or can't run - e.g. ptraced, or
swapped (think incremental checkpoint: why swap everything in ?!);
Second, the coordination can take significant time, especially if
many tasks/threads and resources are involved; Third, it modifies
the state of the app - if something goes wrong while you use c/r
to migrate an app, you impact the app.

(While 'ptrace' relieves you from the need for "collaboration"
of processes, but doesn't address the other problems and adds
its own issues).

> Basically, if _transparent_ means
> that one is not allowed to use anything at all from userland, then I
> agree with you that no userland checkpointing can ever be transparent.
> But, I think that's a biased definition of _transparent_.  :-)

"Transparent" c/r means "invisible" to the user/apps, i.e. that
you don't restrict the user or the app in what they do and how
they do it.

Did you ever try to 'ltrace skype' ?  there exists useful and
popular software that doesn't like being spied after...

Oren.
