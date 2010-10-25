Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932787Ab0JYTBb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 15:01:31 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:59326 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759406Ab0JYTBa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 15:01:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=FBV57gdzq1BYuPs+uBit7W4Di3g+ExmoE9EtFZ8o5D/i2OTSPAlwfsUrzakDHd/6Gu
         hkNvLsuR8+eh9T/38KUM3H87IoZri978dIf6Sm93UdSHQL3KRbiajKPhFk15DRJCbudo
         0TnnKoJQKj0gZ33hf0JLqd0NNjMnpTkx6VmYw=
MIME-Version: 1.0
Date: Mon, 25 Oct 2010 14:01:29 -0500
Message-ID: <AANLkTimmAhZAZHoyWhfUC1eLXFs77tD-aWsN_mpRexFh@mail.gmail.com>
Subject: linux thread scheduling (on multi-socket nehalem)?
From: Matt Garman <matthew.garman@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello list,

Can someone give a general explanation of how Linux's
thread-scheduling algorithm works?  Or provide a link to a document
that describes it?  I've searched the web, but can't find any recent
documents.  In particular, the question I am trying to answer is: does
Linux generally try spread threads out as far as possible across
physical CPU cores, or try to keep them close together?  Furthermore,
have their been any changes to this strategy recently ("recent" as in
the last few years)?  And how is this behavior affected when running
on the Intel Nehalem-based CPUs (if at all)?

I ask because I have a program that displays very different
performance characteristics from one kernel to the next.  The two
kernels I am looking at are the CentOS 4.x (RHEL4) and CentOS 5.x
(RHEL5) kernels on a dual-socket Nehalem (Xeon 5500/Xeon 5600)
machines.  Basically, the program is a pipeline, which has three
threads and two queues (a detailed description is below).  The program
was run on two different architectures (multi socket Core2-based Xeons
vs multi socket Nehalems), and two different kernels (RHEL4 vs RHEL5).
 So, four total tests.  The service time for a message averaged about
20 microseconds (with low variance) in all cases *except* RHEL5 +
Nehalem.  In that case, service time varied wildly, anywhere from 50
microseconds to over 100.  However, I could "fix" this by either using
taskset on the commandline (or sched_setaffinity() in the program) to
bind the threads to the *same physical socket*.  Even more curious, I
could *not* replicate the poor behavior on RHEL4+Nehalem by
deliberately putting the threads on different physical sockets.

So it's clear to me that something changed with regards to thread
scheduling on Nehalem between these two kernels.  I realize these are
vendor-specific kernels, but I'm hoping someone on this list can speak
to this behavior.  Someone suggested to me that the Linux kernel
thread scheduling strategy is to place threads as far apart as
possible.  That is fine, but I would like to confirm it.  But that
does not explain the fact that I can't replicate the wacky behavior on
RHEL4+Nehalem.

Here is a description of my "pipeline" program.  The timestamp deltas
are the "service time" I refer to above.

Thread 1: in a continuous loop, about every 1--3 milliseconds:
    - takes a timestamp using gettimeofday()
    - creates an object about 100 bytes in size
    - stores the timestamp in the object
    - pushes the object into a thread-safe queue, called Queue A

Thread 2: in a continuous loop:
    - pulls objects off of Queue A (waits on a condition variable)
    - does some processing (a basic CRC calculation, works on fixed
static, data, takes about 10 microseconds)
    - creates a new object about 200 bytes in size
    - copies the timestamp from the dequeued object to the new object
    - deletes the dequeued object
    - pushes the new object into another thread-safe queue, called Queue B

Thread 3: in a continuous loop:
    - pulls object off of Queue B (waits on a condition variable)
    - takes a timestamp using gettimeofday()
    - writes the delta of the two timestamps to a fixed, pre-allocated array
    - delete the dequeued object
    - after a fixed number of objects are processed (usually 25,000),
generate statistics on the timestamp deltas

Thank you,
Matt
