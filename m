Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934489Ab1CYDj7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 23:39:59 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:63898 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934462Ab1CYDj6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 23:39:58 -0400
X-Authority-Analysis: v=1.1 cv=ZtuXOl23UuD1yoJUTgnZ6i6Z5VPlPhPMWCeUNtN8OGA= c=1 sm=0 a=XYJHFtupD_QA:10 a=a_0UJ9UWJWAA:10 a=kj9zAlcOel0A:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=TSbVqHtbAAAA:8 a=VwQbUJbxAAAA:8 a=t2a0Rbk5Ja5_2aurBaoA:9 a=7wvJrl-H63FsLXifnlEA:7 a=YV0487cVG8eFByzl1K6uDU64TIEA:4 a=CjuIK1q_8ugA:10 a=LI9Vle30uBYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Date: Thu, 24 Mar 2011 23:39:57 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Tejun Heo <tj@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Chris Mason <chris.mason@oracle.com>, linux-kernel@vger.kernel.org,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/2] mutex: Apply adaptive spinning on mutex_trylock()
Message-ID: <20110325033956.GB9313@home.goodmis.org>
References: <20110323153727.GB12003@htj.dyndns.org>
 <20110324094119.GD12038@htj.dyndns.org>
 <20110324094151.GE12038@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110324094151.GE12038@htj.dyndns.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 24, 2011 at 10:41:51AM +0100, Tejun Heo wrote:
> Adaptive owner spinning used to be applied only to mutex_lock().  This
> patch applies it also to mutex_trylock().
> 
> btrfs has developed custom locking to avoid excessive context switches
> in its btree implementation.  Generally, doing away with the custom
> implementation and just using the mutex shows better behavior;
> however, there's an interesting distinction in the custom implemention
> of trylock.  It distinguishes between simple trylock and tryspin,
> where the former just tries once and then fail while the latter does
> some spinning before giving up.
> 
> Currently, mutex_trylock() doesn't use adaptive spinning.  It tries
> just once.  I got curious whether using adaptive spinning on
> mutex_trylock() would be beneficial and it seems so, for btrfs anyway.
> 
> The following results are from "dbench 50" run on an opteron two
> socket eight core machine with 4GiB of memory and an OCZ vertex SSD.
> During the run, disk stays mostly idle and all CPUs are fully occupied
> and the difference in locking performance becomes quite visible.
> 
> SIMPLE is with the locking simplification patch[1] applied.  i.e. it
> basically just uses mutex.  SPIN is with this patch applied on top -
> mutex_trylock() uses adaptive spinning.
> 
>         USER   SYSTEM   SIRQ    CXTSW  THROUGHPUT
>  SIMPLE 61107  354977    217  8099529  845.100 MB/sec
>  SPIN   63140  364888    214  6840527  879.077 MB/sec
> 
> On various runs, the adaptive spinning trylock consistently posts
> higher throughput.  The amount of difference varies but it outperforms
> consistently.
> 
> In general, using adaptive spinning on trylock makes sense as trylock
> failure usually leads to costly unlock-relock sequence.
> 
> [1] http://article.gmane.org/gmane.comp.file-systems.btrfs/9658
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>

I'm curious about the effects that this has on those places that do:

again:
	mutex_lock(A);
	if (mutex_trylock(B)) {
		mutex_unlock(A);
		goto again;


Where the normal locking order is:
 B -> A

If another location does:

	mutex_lock(B);
	[...]
	mutex_lock(A);

But another process has A already, and is running, it may spin waiting
for A as A's owner is still running.

But now, mutex_trylock(B) becomes a spinner too, and since the B's owner
is running (spinning on A) it will spin as well waiting for A's owner to
release it. Unfortunately, A's owner is also spinning waiting for B to
release it.

If both A and B's owners are real time tasks, then boom! deadlock.

-- Steve

