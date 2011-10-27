Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753347Ab1J0NQ5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Oct 2011 09:16:57 -0400
Received: from esgaroth.petrovitsch.at ([78.47.184.11]:2583 "EHLO
	esgaroth.petrovitsch.priv.at" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752747Ab1J0NQ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Oct 2011 09:16:56 -0400
X-DKIM: Sendmail DKIM Filter v2.8.3 unknown-host p9RDGJMv017716
Subject: Re: Question on Memory Leak: very tough problem
From: Bernd Petrovitsch <bernd@petrovitsch.priv.at>
To: Sri Ram Vemulpali <sri.ram.gmu06@gmail.com>
Cc: Kernel-newbies <kernelnewbies@nl.linux.org>,
        linux-kernel-mail <linux-kernel@vger.kernel.org>,
        kernelnewbies <Kernelnewbies@kernelnewbies.org>
Date: Thu, 27 Oct 2011 15:16:20 +0200
In-Reply-To: <CALyraeOO2DHrS1oh0FLG11XuxEvMzgJ+MRRrxwXx+vLTxbuDYg@mail.gmail.com>
References: <CALyraeOO2DHrS1oh0FLG11XuxEvMzgJ+MRRrxwXx+vLTxbuDYg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1319721383.5546.61.camel@thorin>
Mime-Version: 1.0
X-DCC--Metrics: esgaroth.petrovitsch.priv.at; whitelist
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

On Mit, 2011-10-26 at 23:20 -0400, Sri Ram Vemulpali wrote:
> I have very difficult problem I am working on to figure out where the
> memory leak is in my system. Sometimes it shows up and sometimes it
> reveals very slowly (I mean increments very slowly). This is dependent
> on system load, if the system is in very high load, then leak is very
> fast. We tried solving this problem from many dimensions, but no
> success.
> 
> After quite sometime, we started using valgrind to capture the memory
> leak. The funny thing is the leak disappears once we start running our
> application on top of valgrind.

You do speak of an user-space application?

> So, we cannot capture leak using valgrind. We came to conclusion that,
> since valgrind serializes the allocations (leak disappears), we
> thought this might be result of race conditions, that
> resulted from system high load (by the way ours is multi threaded
> system). We run system without valgrind we see the memory leak.

That really smells like a race condition. So you should make sure that
you got the synchronization between the threads correct and also the
pointer handling in your application. The memory leak seems to be either
a forgotten free() or an overwritten already allocated pointer as in
----  snip ----
void whatever(....)
{
	static void *p = NULL;
	if (p == NULL) {
		p = malloc(12345);
	}
}
----  snip ----
If that function is called in 2 threads in parallel and a task switch
occurs after the check for NULL and before the assignment afterwards,
you've got a memory leak.

That pattern works (at least) also for global pointers and pointers in
shared data structures.

> The question is, is it true that valgrind serializes the mem
> allocations. Does this happen to anyone disappearing the leak when
> used valgrind.

The manual page of malloc() doesn't mentions anything on threads so I
assume that malloc() is synchronized with itself (read: it is
thread-safe) and free(),realloc(),calloc(),strdup(), and all similar
functions.

Apart from valgrind, there are other memory debugging libs out there
(e.g. dmalloc) which may have far less impact on the systems
performance.
Depending on the skill, time and desperation level, building an
(somewhat old) gcc with an applied "bounds-checking" patch may help more
(but you may also run in Heisenberg-problems ....).

	Bernd
-- 
Bernd Petrovitsch                  Email : bernd@petrovitsch.priv.at
                     LUGA : http://www.luga.at

