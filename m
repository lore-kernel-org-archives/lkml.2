Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1768682Ab2KOSl3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 13:41:29 -0500
Received: from bureau82.ns.utoronto.ca ([128.100.132.182]:34304 "EHLO
	bureau82.ns.utoronto.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1768466Ab2KOSl1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 13:41:27 -0500
X-Greylist: delayed 5674 seconds by postgrey-1.27 at vger.kernel.org; Thu, 15 Nov 2012 13:41:27 EST
Message-ID: <50A52133.9050204@cs.utoronto.ca>
Date: Thu, 15 Nov 2012 12:06:59 -0500
From: Ryan Johnson <ryan.johnson@cs.utoronto.ca>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:16.0) Gecko/20121026 Thunderbird/16.0.2
MIME-Version: 1.0
To: General Discussion of SQLite Database <sqlite-users@sqlite.org>
CC: Vladislav Bolkhovitin <vst@vlnb.net>,
        Nico Williams <nico@cryptonector.com>, linux-fsdevel@vger.kernel.org,
        "Theodore Ts'o" <tytso@mit.edu>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Richard Hipp <drh@hwaci.com>
Subject: Re: [sqlite] light weight write barriers
References: <CALwJ=MzHjAOs4J4kGH6HLdwP8E88StDWyAPVumNg9zCWpS9Tdg@mail.gmail.com>	<m2fw5mtffg.fsf_-_@firstfloor.org>	<CABK4GYNKF6LCgsQ5SN+dATtRm-0Qh_QmNdqZqZcj6S98z+ofXg@mail.gmail.com>	<5086F5A7.9090406@vlnb.net>	<20121025051445.GA9860@thunk.org>	<508B3EED.2080003@vlnb.net>	<20121027044456.GA2764@thunk.org>	<5090532D.4050902@vlnb.net>	<20121031095404.0ac18a4b@pyramind.ukuu.org.uk>	<5092D90F.7020105@vlnb.net>	<20121101212418.140e3a82@pyramind.ukuu.org.uk>	<50931601.4060102@symas.com>	<20121102123359.2479a7dc@pyramind.ukuu.org.uk>	<50A1C15E.2080605@vlnb.net>	<20121113174000.6457a68b@pyramind.ukuu.org.uk> <CAK3OfOgK7a9+g-KU8v5-b2d+8-vLb75kuKKQnPK-zeFV1fLmxw@mail.gmail.com> <50A442AF.9020407@vlnb.net>
In-Reply-To: <50A442AF.9020407@vlnb.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14/11/2012 8:17 PM, Vladislav Bolkhovitin wrote:
> Nico Williams, on 11/13/2012 02:13 PM wrote:
>> declaring groups of internally-unordered writes where the groups are
>> ordered with respect to each other... is practically the same as
>> barriers.
>
> Which barriers? Barriers meaning cache flush or barriers meaning 
> commands order, or barriers meaning both?
>
> There's no such thing as "barrier". It is fully artificial 
> abstraction. After all, at the bottom of your stack, you will have to 
> translate it either to cache flush, or commands order enforcement, or 
> both.
Isn't that  why we *have* "the stack" in the first place? So apps 
*don't* have to worry about how the OS implements an artificial (= 
high-level and portable) abstraction on a given device?

>
> Are you going to invent 3 types of barriers?
One will do, it just needs to be a good one.

Maybe I'm missing something here, so I'm going to back up a bit and 
recap what I understand.

The filesystem abstracts the concept of encoding patterns of bits in 
some physical media (data), and making it easy to find and retrieve 
those bits later (metadata, incl. file name). When users read(), they 
expect to see whatever they most recently sent to write(). They also 
expect that what they write will still be there later,  in spite of any 
failure that leaves the disk itself intact.

Operating systems cheat by not actually writing to disk -- for 
performance reasons -- and users are (mostly, usually) OK with that, 
because the performance gains are so attractive and things usually work 
out anyway. Disks cheat too, in the same way and for the same reason.

The cheating works great most of the time, but breaks down -- badly -- 
if we actually care about what is on disk after a crash (or if we use a 
network filesystem). Enough people do care that fsync() was added to the 
toolbox. It is defined to transfer "all modified in-core data of the 
file referred to by the file descriptor fd to the disk device" and 
"blocks until the device reports that the transfer has completed" 
(quoting from the fsync(2) man page). Translation: "Stop cheating. Make 
sure the stuff I already wrote actually got written. And tell the disk 
to stop cheating, too."

Problem is, this definition is asymmetric: it says what happens to 
writes issued before the fsync, but nothing about those issued after the 
fsync starts and before it returns [1]. The reader has to assume  
fsync() makes no promises whatsoever about these later writes: making 
fsync capture them exposes callers of fsync() to DoS attacks, and them 
from reaching disk until all outstanding fsync calls complete would add 
complexity the spec doesn't currently demand, leading to understandable 
reluctance by kernel devs to code it up. Unfortunately, we're left with 
the filesystem equivalent of what we in the database world call 
"eventual consistency" -- easy to implement, nice and fast, but very 
difficult to write reliable code against unless you're willing to pay 
the cost of being fully synchronous, all the time. Having tried that for 
a few years, many people are "returning" to better-specified concurrency 
models, trading some amount of performance for comfort that the app will 
at least work predictably when things go wrong in strange and 
unanticipated ways.

The request, then, is to tighten up fsync semantics in two conceptually 
straightforward ways [2]: First, guarantee that later writes to an fd do 
not hit disk until earlier calls to fsync() complete. Second, make the 
call asynchronous. That's all.

Note that both changes are necessary. The improved ordering semantic 
useless by itself, because it's still not safe to request a blocking 
fsync from one thread and and then let other threads continue issuing 
writes: there's a race between broadcasting that fsync has begun and 
issuing the actual syscall that begins it. An asynchronous fsync is also 
useless by itself, because it only benefits uncoordinated writes (which 
evidently don't care what data actually reaches disk anyway).

The easiest way to implement this fsync would involve three things:
1. Schedule writes for all dirty pages in the fs cache that belong to 
the affected file, wait for the device to report success, issue a cache 
flush to the device (or request ordering commands, if available) to make 
it tell the truth, and wait for the device to report success. AFAIK this 
already happens, but without taking advantage of any request ordering 
commands.
2. The requesting thread returns as soon as the kernel has identified 
all data that will be written back. This is new, but pretty similar to 
what AIO already does.
3. No write is allowed to enqueue any requests at the device that 
involve the same file, until all outstanding fsync complete [3]. This is 
new.

The performance hit for #1 can be reduced significantly if the storage 
hardware at hand happens to support some form of request ordering. The 
amount of reduction could vary greatly depending on how sophisticated 
such request ordering is, and how much effort the kernel and/or device 
driver are willing to work for it. In any case, fsync should already do 
this [4].

The performance hit for #3 can be minimized by buffering small or 
otherwise convenient writes in the fs cache and letting the call return 
immediately, as usual. The corresponding pages just have to be marked in 
some way to prevent them from being written back too soon. Sequence 
numbers work well for this sort of thing. Big requests may have to 
block, but they probably would have anyway, if the buffer cache couldn't 
absorb them. As with #1, fancy command ordering capabilities in the 
underlying device just allow additional performance optimizations.

A carefully-written app (e.g. free of I/O races) would do pretty well 
with this extended fsync, certainly far better than the current state of 
the art allows.

Note that this still offers no protection for reads: no matter how many 
times a thread issues fsync(), it still risks reading non-durable data 
because reads are not ordered wrt either writes or fsync. That's not the 
problem we're trying to solve, though.

Please feel free to point out where I've gone wrong, but this just 
doesn't look like as complex or crazy an idea as you make it out to be.

[1] Maybe posix.1-1001 is more specific, but it's not publicly available 
that I could see.

[2] I'm fully aware that implementing the request might require 
significant -- perhaps even unreasonably complex -- changes to the way 
the kernel currently does things (though I do doubt it). That's not a 
good excuse to claim the idea itself is unreasonably complex or 
ill-specified. Just say that it's not a good fit for the current code base.

[3]  Another concern is whether fsync calls operate on the file or a 
particular fd. What if a process opens the same file multiple times, or 
multiple processes have fds pointing to the same file (whether by open 
or fork)? I would argue for file-level barriers, because it leads to a 
vastly simpler design (the fs cache doesn't track which process wrote 
what via what fd). Besides, no app that cares about what ends up on disk 
will allow uncoordinated writes anyway, so why do extra work just to 
ensure I/O races stay fast?

[4] Really, device support for request ordering commands is a bit of a 
red herring: the only way it helps significantly is if (a) the storage 
device has a massive cache compared to the fs cache, (b) it allows I/O 
scheduling to reduce latency of reads and/or writes (which fsync should 
do already, and which matters little for flash), and (c) a logging 
filesystem is not being used (else it's all sequential writes anyway). 
In other words, it can help performance a bit but has little other 
impact on what is essentially a software matter.

>
>> There's a lot to be said for simplicity... as long as the system is
>> not so simple as to not work at all.
>>
>> My p.o.v. is that a filesystem write barrier is effectively the same
>> as fsync() with the ability to return sooner (before writes hit stable
>> storage) when the filesystem and hardware support on-disk layouts and
>> primitives which can be used to order writes preceding and succeeding
>> the barrier.
>
> Your mistake is that you are considering barriers as something real, 
> which can do something real for you, while it is just a artificial 
> abstraction apparently invented by people with limited knowledge how 
> storage works, hence having very foggy vision how barriers supposed to 
> be processed by it. A simple wrong answer.
Storage: Accepts writes and ostensibly makes them available via reads 
even after power failures. Reorders requests nearly arbitrarily and lies 
about whether writes actually took effect, unless you issue appropriate 
cache flushing and/or request ordering commands (and sometimes even 
then, if it was a cheap consumer drive).

OS: Accepts writes and ostensibly makes them available via reads even 
after power failures, reboots, etc. Reorders requests nearly arbitrarily 
and lies about whether writes actually took effect, unless you issue a 
stop-the-world, one-sided write barrier lovingly known as fsync 
(assuming the actually disk listens when you tell it to stop cheating).

Wish: a two-sided write barrier that not only ensures previously-issued 
writes complete before it reports success, but also prevents 
later-issued writes from completing while it is in progress, giving a 
reasonably simple way to enforce some ordering of writes in the system. 
Can be implemented entirely in software, as the latter has full control 
over which requests it chooses to schedule at the device, and also 
decides whether to block the requesting thread or not. Can be made 
virtually as fast as current writes, by maintaining a little extra 
information in the fs cache.

Please, enlighten me: in what way does my limited knowledge of storage, 
or my foggy vision of what is desired, make this feature impossible to 
implement or useless if implemented?

>
> Generally, you can invent any abstraction convenient for you, but 
> farther your abstractions from reality of your hardware => less you 
> will get from it with bigger effort.
>
> There are no barriers in Linux and not going to be. Accept it. And 
> start instead thinking about offload capabilities your storage can 
> offer to you.
Apologies if this comes off as flame-bait, but I start to wonder whose 
abstraction is broken here...

What I understand the above to mean is: "Linux file system abstractions 
are too far from the reality of storage hardware, so it takes lots of 
effort to accomplish little [in the way of enforcing write ordering]. 
Accept it. And start thinking instead about talking directly to a 
storage controller that offers proper write barriers."

I hope I misread what you said, because that's a depressing thing to 
hear from your OS.

Ryan

