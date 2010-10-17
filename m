Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932788Ab0JQUmr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Oct 2010 16:42:47 -0400
Received: from smtp.seznam.cz ([77.75.76.43]:60952 "EHLO smtp.seznam.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932733Ab0JQUmq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Oct 2010 16:42:46 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=beta; d=post.cz;
	h=X-Seznam-DomainKeys:X-Seznam-SPF:X-Virus-Info:Received:From:To:Date:MIME-Version:Subject:Message-ID:Priority:In-reply-to:References:X-mailer:Content-type:Content-transfer-encoding:Content-description:X-Smtpd:X-Seznam-User:X-Session:X-Country:X-QM-Mark;
	b=HXvI3jbkWr+2Bgxei6xSJ7yymLGcpA66iz2ZifQPKWOdIczLF6bq6ZSN+yvez4apy
	Sk0yOdkh+tJtZT0SP0bHh1Sl+tcvke5iGT51BQKrMB0AaEZRyUyvKsxXoDfE40FdRg6
	IJe94hHmycUvnyTGeraPVyHh9CYxVUtkIslHGVQ=
X-Seznam-DomainKeys: unknown
X-Seznam-SPF: neutral
X-Virus-Info: is OK
From: "Frantisek Rysanek" <Frantisek.Rysanek@post.cz>
To: linux-kernel@vger.kernel.org
Date: Sun, 17 Oct 2010 22:42:42 +0200
MIME-Version: 1.0
Subject: Re: setitimer vs. threads: SIGALRM returned to which thread? (process master or individual child)
Message-ID: <4CBB7BE2.24747.162F3513@Frantisek.Rysanek.post.cz>
In-reply-to: <alpine.LFD.2.00.1004120000330.18009@localhost.localdomain>
References: <4BBFA0C6.2610.2C4FFE@Frantisek.Rysanek.post.cz>, <87d3y5btdk.fsf@basil.nowhere.org>, <alpine.LFD.2.00.1004120000330.18009@localhost.localdomain>
X-mailer: Pegasus Mail for Windows (4.41)
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7BIT
Content-description: Mail message body
X-Smtpd: 1.2.14@16206
X-Seznam-User: frantisek.rysanek@post.cz
X-Session: 5410
X-Country: CZ
X-QM-Mark: email-qm1<525361190>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Everyone,

apologies for following up on a thread after half a year :-)
I'm not gonna pretend it took me half a year to discover the points 
presented below - I just got buried by a dumptruck of other stuff,
then did my homework, and then couldn't find the time to post my 
follow-up...
Before this LKML thread, I couldn't find this sort of information 
anywhere (anywhere except for the source code itself). Maybe I didn't 
look into enough places where Google cannot see... anyway, I guess 
it's worth leaving a trace about the things I've learned, at a 
relevant place for the cyber crawlers to find it - for the benefit of 
future wondering apprentices who come after me.
So here it goes...

On 12 Apr 2010 at 0:09, Thomas Gleixner wrote:
> 
> Just use the right flags when creating the posix
> timer. posix timers support per thread delivery of a signal, i.e. you
> can use the same signal for all threads.
> 
>    sigev.sigev_notify = SIGEV_THREAD_ID | SIGEV_SIGNAL;
>    sigev.sigev_signo = YOUR_SIGNAL;
>    sigev.sigev_notify_thread_id = gettid();
>    timer_create(CLOCK_MONOTONIC, &sigev, &timer);
> 
> That signal for that timer will not be delivered to any other thread
> than the one specified in sigev.sigev_notify_thread_id as long as that
> thread has not exited w/o canceling the timer.
>
Thanks for that gem of ultra-compact yet precise information :-)
It does work precisely as advertised after all - except that for me, 
it was not without further homework.

I have to confess that when writing code in user space, I'm a bit 
ignorant of details - such as, whether it's bare kernel syscalls or 
some higher-level glibc abstraction that I'm talking to.
This snippet gave me a neat lesson in that particular "grey" area :-)
Well I shouldn't be surprised, if I ask kernel people, that I obtain 
a response in kernel terms :-)

I first pasted your code snippet into my program verbatim.
Followed by some timer_settime() of course...
It took a little bit of massage to get it to compile - such as, glibc 
didn't offer me a member called sigev_notify_thread_id, but I figured 
(by analogy with other macros in the relevant header) that it was 
pointing to a member called _tid in a union inside struct sigevent, 
as declared in /usr/include/bits/siginfo.h. I merely added 
#define sigev_notify_thread_id _sigev_un._tid
just below my #defines on top of the relevant C file.
Next, I couldn't find gettid() anywhere within the libraries (nothing 
to link to in user space) - so I decided to instead use 
 * the pthread_t provided by pthread_create(). *
After all, in LinuxThreads in the old days, pthread_t and pid_t were 
the same.

Guess what happened :-)
At a first run, I got an immediate SIGSEGV.

What ho? Let's ask GDB for some advice...
Hmm... timer_settime() segfaulting? Why? Old libc?
Tried compiling on a much newer distro, with the same result.
Google suggested that I was submitting a 0 for the timer_t...
How could that happen? Well maybe I should check the return value 
from timer_create(), and try perror(errno), right?
Uh oh, that was correct, timer_create() returns EINVAL.
Why is that?
(...shuffling the various parameters, trying CLOCK_MONOTONIC instead 
of CLOCK_REALTIME, googling some more...)
Found an old e-mail thread from back in 2005, suggesting in vague 
terms that timer_create(SIGEV_THREAD_ID) really still woked with 
PID's, rather than TID's, and that the per-thread logic is somehow 
completely bogus and void... so, reluctantly, I tried 
_tid = getpid() instead of  "pthread_t my_thr_ID". That worked to the 
extent that timer_create() didn't yell and timer_settime() did set up 
a timer - except that of course the SIGALARM got again delivered to 
the process master thread. Ah well... now, why on earth is there 
something called a _tid, embedded in the struct sigevent?
Time to take a dive into more source code, right?

I happened to have the source code of Libc 2.6 lying around, so I 
looked at that. And Linux 2.6.35.7.
The code did try my mediocre coding & code reading skills, but 
finally it started to dawn on me. I tried further googling more about 
the precise mapping between NPTL and the Linux kernel threading 
arrangement, and found nothing other than the usual PR factoids (N:1 
vs. M:N vs. 1:1) - which meant I really had to find out the hard way 
= by reading the code :-)

It turns out that:

NPTL (a part of Libc in the user space) uses something called "struct 
pthread" internally. It is declared in some private header inside the 
glibc source code (namely nptl/descr.h), but not in the public 
headers that end up in the systemwide /usr/include. The "pthread_t" 
that gets passed around among the various pthread_create() et al. 
library functions, although it looks like an opaque "unsigned int" or 
what on the outside, is really assigned the value of a 
struct pthread *
(pointer to the NPTL-private pthread struct). Outside of the glibc 
source tree, you don't know that such a struct exists, and you have 
no chance to access its internal members, such as the one called 
pid_t tid.

Within the kernel, it seems that the processes or threads behind the 
NPTL's threading model are called just a "task". Each task is 
described by an instance of a uniform "struct task_struct", declared 
in $KERNEL_SRC/include/linux/sched.h. Each task has its own pid (and 
this one is a genuine integer). Interesting point: struct task_struct 
contains a member called
struct task_struct* group_leader;

And that's it. In the kernel space, there's a group of mostly equal 
tasks who have a leader. This group and their leader correspond to a 
user-space NPTL process containing several lightweight threads. The 
kernel-space PID of the task group leader is equal to the user-space 
PID, used to refer to the whole multi-threaded process.

Okay... so how do we get our hands on the back-end "tid" (really a 
PID in kernel vocabulary) of a single user-space thread? We already 
know that we need a function called gettid(). It turns out that this 
is a syscall, implemented in the kernel, even known to glibc, but not 
exported by glibc to the user space. In the kernel space, 
interestingly this syscall is implemented in a file called 
kernel/timer.c (I'd expect it in kernel/pid.c or maybe 
kernel/sched.c) - well maybe the choice of translation unit hints at 
the practical use of this syscall :-) If you follow gettid(), through 
an inline function called task_pid_vnr(), all the way to 
__task_pid_nr_ns(PIDTYPE_PID), you'll find out that indeed this stack 
of calls will retrieve task->pid (and the function __task_pid_nr_ns 
also mentions task->group_leader in a different context).

So essentially in the user space (using glibc) you have a choice 
whether to
1) copy and paste the declaration of "struct pthread" from your glibc 
version's source code into your program, or "publish" the relevant 
header, or some such
2) call the gettid() syscall (in)directly. 

I chose the latter option. In my program, I added
#include <sys/syscall.h>
#define gettid() syscall(__NR_gettid)
...all of the gears can be found in the public headers.
This way of invoking a syscall by the generic syscall() function and 
the integer syscall number, is called an "indirect" invocation of a 
syscall, and can only be used for syscalls with simple argument sets, 
which luckily is the case of gettid().

So yes, I can have my cake and eat it too.
I can deliver timer-based SIGALRM directly to a particular user-space 
thread, without "rethrowing" via the process master or another 
dedicated "signal dispatch" thread.
Only to get my hands on the "tid" (really the PID of a kernel-space 
task corresponding to my user-space thread), I have to call a Linux 
syscall fairly explicitly. It feels like less of a sin than accessing 
some private (however obvious) struct under the hood of glibc/NPTL.
Calling gettid() directly doesn't seem "posixly correct", but it 
would appear that neither is SIGEV_THREAD_ID (what use would that be, 
without a possibility to get your hands on the internal TID?)
The important point for me is that it gets the job done, over a wide 
range of glibc and kernel versions.

It's been an exciting adventure. The kernel guts around pid.c and 
sched.c are a fantastic read - the code is almost amazingly clean and 
straight-forward, split into neat small functions. An interesting 
discovery after all the past claims that programming language purity 
and beauty doesn't mix well with system-level programming :-)

Thanks for your time and attention...

Frank Rysanek

