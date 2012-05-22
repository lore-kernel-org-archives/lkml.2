Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756411Ab2EVQkj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 12:40:39 -0400
Received: from www.linutronix.de ([62.245.132.108]:39235 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756226Ab2EVQkZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 12:40:25 -0400
Date: Tue, 22 May 2012 18:40:21 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Steven Rostedt <rostedt@goodmis.org>
cc: LKML <linux-kernel@vger.kernel.org>, RT <linux-rt-users@vger.kernel.org>,
        Clark Williams <williams@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [RFC][PATCH RT] rwsem_rt: Another (more sane) approach to mulit
 reader rt locks
In-Reply-To: <1337701801.13348.56.camel@gandalf.stny.rr.com>
Message-ID: <alpine.LFD.2.02.1205221803290.3231@ionos>
References: <1337090625.14207.304.camel@gandalf.stny.rr.com>  <alpine.LFD.2.02.1205221553400.3231@ionos> <1337701801.13348.56.camel@gandalf.stny.rr.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 May 2012, Steven Rostedt wrote:
> On Tue, 2012-05-22 at 17:26 +0200, Thomas Gleixner wrote:
> > On Tue, 15 May 2012, Steven Rostedt wrote:
> > > +struct rw_semaphore {
> > > +	int			initialized;
> > > +	struct __rw_semaphore	lock[NR_CPUS];
> > 
> > So that will blow up every rw_semaphore user by
> > 
> >    NR_CPUS * sizeof(struct __rw_semaphore)
> > 
> > With lockdep off thats: NR_CPUS * 48
> > 
> > With lockdep on thats:  NR_CPUS * 128 + NR_CPUS * 8 (__key)
> > 
> > So for NR_CPUS=64 that's 3072 or 8704 Bytes.
> 
> For a box that has 64 CPUS, 8k should be nothing (even for every task).
> But then again, NR_CPUS is compile time option. It would be nice if we
> could make NR_CPUS just what was actually available :-/

We are talking about inodes not tasks. My 32 core machine has

 ext4_inode_cache  1997489
 xfs_inode          838780

and those are not my largest filesytem. So I pretty much care whether
my inode cache eats 20 GB or 2 GB of RAM. And so does every one else
with a machine with large filesystems. 

Even if I compile the kernel with NR_CPUS=32 then it's still 11GB
vs. 2GB.

> > So we trade massive memory waste for how much performance? 
> 
> We could always make this an option. I may be able to also do linker
> tricks to make it a boot time option where the memory is allocated in
> sections that can be freed if the option is not enabled. Just a thought,
> I know this is making it more complex than necessary.

Oh yes, we all know your affinity to the most complex solutions. :)

> > We really need numbers for various scenarios. There are applications
> > which are pretty mmap heavy and it would really surprise me when
> > taking NR_CPUS locks in one go is not going to cause a massive
> > overhead.
> 
> Well, it doesn't take NR_CPUS locks, it takes possible_cpus() locks,
> which may be much smaller. As a compiled time NR_CPUS=64 running on a
> box with just 4 cpus will do a loop of 4 and not 64.

Then let's talk about 32 cores, which is what I have and not really an
exotic machine anymore. 
 
> I'm all for benchmarks. But right now, making all readers pass through a
> single mutex is a huge bottle neck for a lot of loads. Yes, they are
> mostly Java loads, but for some strange reason, our customers seems to
> like to run Java on our RT kernel :-p

I'm well aware that mmap_sem is a PITA but replacing one nightmare
with the next one is not the best approach.

Thanks,

	tglx
