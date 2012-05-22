Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759752Ab2EVPuE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 11:50:04 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:19273 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759542Ab2EVPuD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 11:50:03 -0400
X-Authority-Analysis: v=2.0 cv=cssZYiEi c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=huzqtivG31QA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=ayC55rCoAAAA:8 a=L_W2xmv51hjfQBbxzoEA:9 a=GFt9mRCT0RRRLBWr7nQA:7 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1337701801.13348.56.camel@gandalf.stny.rr.com>
Subject: Re: [RFC][PATCH RT] rwsem_rt: Another (more sane) approach to mulit
 reader rt locks
From: Steven Rostedt <rostedt@goodmis.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, RT <linux-rt-users@vger.kernel.org>,
        Clark Williams <williams@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>
Date: Tue, 22 May 2012 11:50:01 -0400
In-Reply-To: <alpine.LFD.2.02.1205221553400.3231@ionos>
References: <1337090625.14207.304.camel@gandalf.stny.rr.com>
	 <alpine.LFD.2.02.1205221553400.3231@ionos>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-05-22 at 17:26 +0200, Thomas Gleixner wrote:
> On Tue, 15 May 2012, Steven Rostedt wrote:
> > +struct rw_semaphore {
> > +	int			initialized;
> > +	struct __rw_semaphore	lock[NR_CPUS];
> 
> So that will blow up every rw_semaphore user by
> 
>    NR_CPUS * sizeof(struct __rw_semaphore)
> 
> With lockdep off thats: NR_CPUS * 48
> 
> With lockdep on thats:  NR_CPUS * 128 + NR_CPUS * 8 (__key)
> 
> So for NR_CPUS=64 that's 3072 or 8704 Bytes.

For a box that has 64 CPUS, 8k should be nothing (even for every task).
But then again, NR_CPUS is compile time option. It would be nice if we
could make NR_CPUS just what was actually available :-/


> 
> That'll make e.g. XFS happy. xfs_inode has two rw_sems.
> 
> sizeof(xfs_inode) in mainline is:  856 bytes
> 
> sizeof(xfs_inode) on RT is:       1028 bytes
> 
> But with your change it would goto (NR_CPUS = 64):
> 
>     1028 - 96 + 2 * 3072 =        7076 bytes
> 
> That's almost an order of magnitude!
> 
> NFS has an rwsem in the inode as well, and ext4 has two.
> 
> So we trade massive memory waste for how much performance? 

We could always make this an option. I may be able to also do linker
tricks to make it a boot time option where the memory is allocated in
sections that can be freed if the option is not enabled. Just a thought,
I know this is making it more complex than necessary.

> 
> We really need numbers for various scenarios. There are applications
> which are pretty mmap heavy and it would really surprise me when
> taking NR_CPUS locks in one go is not going to cause a massive
> overhead.

Well, it doesn't take NR_CPUS locks, it takes possible_cpus() locks,
which may be much smaller. As a compiled time NR_CPUS=64 running on a
box with just 4 cpus will do a loop of 4 and not 64.


I'm all for benchmarks. But right now, making all readers pass through a
single mutex is a huge bottle neck for a lot of loads. Yes, they are
mostly Java loads, but for some strange reason, our customers seems to
like to run Java on our RT kernel :-p

-- Steve


