Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756784Ab0DIUEZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Apr 2010 16:04:25 -0400
Received: from smtp.seznam.cz ([77.75.72.43]:39821 "EHLO smtp.seznam.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755895Ab0DIUEX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Apr 2010 16:04:23 -0400
X-Greylist: delayed 929 seconds by postgrey-1.27 at vger.kernel.org; Fri, 09 Apr 2010 16:04:23 EDT
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=beta; d=post.cz;
	h=Received:From:To:Date:MIME-Version:Subject:Message-ID:Priority:X-mailer:Content-type:Content-transfer-encoding:Content-description:X-Smtpd:X-Seznam-User:X-QM-Mark;
	b=KTEogqo3jttXSefY+jPL+P1BErcYWo478yXPPF+08pHjwuQEtcbwBc3zrizxqbn2G
	V5ZTmmHqEPUlTT3yjwhorDklfh9nSerGMey8p6UBjAVF+KP2y22ZqgtkRPikwSxIUVW
	Ol7BWg79d/W6kEB4tyLXPocQEQrtdMFkVUygqp8=
From: "Frantisek Rysanek" <Frantisek.Rysanek@post.cz>
To: linux-kernel@vger.kernel.org
Date: Fri, 09 Apr 2010 21:48:54 +0200
MIME-Version: 1.0
Subject: setitimer vs. threads: SIGALRM returned to which thread? (process master or individual child)
Message-ID: <4BBFA0C6.2610.2C4FFE@Frantisek.Rysanek.post.cz>
X-mailer: Pegasus Mail for Windows (4.41)
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7BIT
Content-description: Mail message body
X-Smtpd: 1.1.7@13984
X-Seznam-User: frantisek.rysanek@post.cz
X-QM-Mark: email-qm1<530314671>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear everyone,

I hope I'm not way too much off topic in this list... specifically, I 
hope the issue takes place in the kernel, as opposed to the user-
space part of NPTL that ships with libc, distroes etc.
At the same time, I feel shame for asking this noob question in the 
very LKML - except that there doesn't seem to be a better place to 
ask... :->

Some years ago, I've written a couple programs that tend to use the 
setitimer() syscall in a threaded environment, making use of its 
special property at the time: setitimer() had per-thread granularity. 
It used to deliver a SIGALRM from the timer to the particular thread 
that called setitimer(). I believe that was around RH8 to Fedora 5.

Recently I've recompiled the programs on a newer distro (Fedora 10) 
and voila: setitimer() now yields a SIGALRM to the program's master 
thread, no matter what child thread called setitimer()...

Based on further reading, I assume this is related to making the NPTL 
more POSIX-compliant. The latter is a correct POSIX behavior, the 
former was not. See "man pthreads", and under the NPTL heading, 
find a note saying
"Threads do not share interval timers (fixed in kernel 2.6.12)."

Yes, it used to be quite a relief to have Linux do the management of 
timers for me. Now I have two options to choose from:
1) write my own "timer queueing" (timekeeping) code to order the 
timers for me in the master thread
2) find another function, similar to setitimer(), that would function 
the way setitimer() used to work in the old days...

Obviously option #2 is much easier for me to abuse :-)
Such as, does select() work in the desired per-thread way?
In the app that I'm trying to update right now, I have a serial 
device open per thread, and I need to detect character timeouts 
(frame breaks).
But I have other apps where I have a *myriad* of stand-alone timers, 
not related to a "file descriptor like" device of any kind, 
generating "spurious events" for me, used to propel a bunch of 
threads doing some polling on various dumb "networked" devices 
(external bus slaves)...

For a moment I was wondering how complex the relevant kernel patch 
was, how difficult it would be to revert it - but then again such a 
revert might disrupt various other pieces of user-space code in my 
distro, so it's probably not such a good idea anyway :-) Also, if I 
resort to patching my kernel, it makes my user-space code fairly non-
portable to other people's machines. Let alone the bulk of code 
evolution in Linux kernel timekeeping and process management since 
2.6.12, overlaying the original patch.
AIX appears to have ITMER_REAL_TH [sob]. Not that I'm going to try 
AIX for this particular reason :-)

Wouldn't it be in fact more straightforward and "cheaper" (in terms 
of processing overhead) to have the timers thread-aware? If I just 
call a setitimer() in each thread, that requires some number of 
ioctl() calls. Now if I need to do my own timekeeping (event 
queueing) in user space, I'll probably need to call getitimer() or 
gettimeofday() ahead of every setitimer(), every time a thread needs 
to set a timer. Not sure about the required number of pointer 
indirections in the kernel for either case :-)

I understand that POSIX compliance is a good thing, for portability 
reasons. At the same time, resorting to per-process granularity of 
timers somehow "feels backwards" - from thread awareness, back to the 
old "no threads" UNIX world. It seems to remind me of the occasional 
debate whether GCC extensions to standard C are a good thing to use, 
or whether they should be avoided...

I haven't found much debate about this "timers vs. threads 
granularity" point in mailinglist archives or on the web.
Any further hints/pointers/kicks in the right direction/recommended 
reading are welcome :-)
If you've read this far, thanks for your time...

Frank Rysanek

