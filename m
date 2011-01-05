Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753214Ab1AEXbV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 18:31:21 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:33250 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752934Ab1AEXbU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 18:31:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:from:date:x-google-sender-auth:message-id
         :subject:to:cc:content-type;
        b=ZIf97V9vanIVIxoQ9kfkyJVeDkmeSr+LR44pZyCZUJlFhuhmM1hKutLYMTnMKrCY6V
         hiTy5V2b1OfWXNgE+pJKEMIUazw9KbQkTIFFH8hwU12/EilBtQQykKKebPGFuuFAhYeY
         uwc5790gFG4GpOM1n/toX5J9eJa+fMF3hFFpg=
MIME-Version: 1.0
From: Brice Arnould <unbrice@vleu.net>
Date: Thu, 6 Jan 2011 00:30:49 +0100
X-Google-Sender-Auth: gL35CY-WtnyccO0U9zyewF_kHLs
Message-ID: <AANLkTi=i=gp36q2dBxK93QHqsGWUvSefTUSK5Kuq72Mf@mail.gmail.com>
Subject: Microbenchmarking userspace synchronisation primitives
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, corentin.chary@gmail.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I was microbenchmarking synchronisation primitives, and got very
surprising results. Among other things, it seems to be cheaper to
synchronize two processes (with a pipe) than it is to synchronize two
threads of the same process. Also the benchmark runs faster when it's
constrained to a single CPU with sched_setaffinity() which I think
might indicate a suboptimal scheduling.
The experience is as follow : A first process (or thread) transmits an
integer to a second process (or thread) via a pipe (or via shared
memory). This second process (or thread) answers back with the integer
multiplied by two. The first process (or thread) then checks that the
multiplication was correct.
A single run of that experience is called an exchange. The
microbenchmark consists in many exchanges.

The average number of exchanges per second is as follow :
- Processes synchronized by a pipe          : 059171 exchanges/second
- Threads synchronized by a pipe            : 031746 exchanges/second
- (Threads synchronized by a pthread_barrier: 017825 exchanges/second)

Kernel : 2.6.35-24-generic #42-Ubuntu SMP
CPU    : Intel Core 2 Duo CPU T8100 @ 2.10GHz (in 32 bit mode)
Code   : git://github.com/unbrice/20110103_lkml_bench.git
         Build with "make"
         Run like "./rpc-piped_thread 1000000 1"
         or "./rpc-piped_process 1000000 1"
libc   : Glibc 2.12.1-0ubuntu10

I was expecting that performance would vary with the different
synchronization primitives. And it seems plausible that
pthread_barrier being more "generic" (because it allows for
synchronizing more than one thread) it should be slower.
I was however surprised to see that synchronizing two threads of a
single process via a pipe is slower than synchronizing two processes
via a pipe. If I'm not misinterpreting perf(1), almost all the time is
spent in try_to_wake_up so the cause might be there.

While trying to find an explanation for this behavior, I forced the
threads and processes to run on a CPU of my choice using
sched_setaffinity().
When forcing the threads and process on different CPUs, the results
were as before.
When forcing the threads and process on a single CPU, performance
increased and processes stayed ahead of threads :
- Processes synchronized by a pipe          : 401606 exchanges/second
- Threads synchronized by a pipe            : 177304 exchanges/second
- (Threads synchronized by a pthread_barrier: 087032 exchanges/second)

If I'm not misinterpreting perf(1), those difference might be related
to a decreasing number of cache misses (from ~25k to ~13k).

Those numbers defy my understanding of what should be happening, which
is why I'm humbly asking for a hint or a pointer to an explanation.
I'm also hoping that the possible scheduler's suboptimal behavior can
be worked upon by competent gurus, but acknowledge that this may not
be usefull because we are just speaking of a microbenchmark.
Also I think that I am going to be in similar situation with real
application (AIs in the context of an AI contest). Do you have any
suggestion wrt performances of that kind of applications ?

Thank you in advance,
Brice
