Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753364Ab0L1LUM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Dec 2010 06:20:12 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:47078 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752972Ab0L1LUK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Dec 2010 06:20:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Xg159jMKs6oY9snyzVE1ALgEKhIIzVada3O8pxdwj/Deia//O7ocABBpMKWImRWmv/
         AIGzoGuZQ7lscEZXUaAN742iZWLwRSd/lkOzgEH1fFj12zghj9YWzYhA3OZkGGqLFWfA
         U8464lLbn9Nq9aYaKPloz1TGb0N3LFYTRjrqo=
Date: Tue, 28 Dec 2010 12:20:00 +0100
From: Richard Cochran <richardcochran@gmail.com>
To: John Stultz <john.stultz@linaro.org>
Cc: linux-kernel@vger.kernel.org, Richard Cochran <richard.cochran@omicron.at>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 0/3] Cleanup ADJ_SETOFFSET patch
Message-ID: <20101228112000.GA17470@riccoc20.at.omicron.at>
References: <1293493244-17583-1-git-send-email-john.stultz@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1293493244-17583-1-git-send-email-john.stultz@linaro.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 27, 2010 at 03:40:41PM -0800, John Stultz wrote:
> I was looking to queue Richard's ADJ_SETOFFSET patch to see
> if it could be merged into -tip for 2.6.38, but on second 
> glance I noticed the ugly local_irq_disable bits as well
> as the fact that adding the offset uses a gettime/add/settime
> pattern which will also add a small error as the action isn't
> atomic.
> 
> So I implemented a timekeeping function to add a fixed offset:
> timekeeping_inject_offset(), and reworked Richard's code to
> make use of it.

Okay, so you added an optimized version of do_settimeofday() for
jumping the clock. It certainly helps the code in do_adjtimex(), but
it also (nearly) duplicates do_settimeofday(). I guess you will not
mind having to maintain both code paths...

> Richard: Any objection here? Mind testing this with the rest
> of your patch queue?

Well, you have uncovered a problem.

The code I offered was broken to begin with, but I think your patch is
also troubled. The timespec is awkwardly split into seconds and
nanoseconds, and I think that arithmetic using timespecs is not well
defined. Or perhaps only I am confused by it all.

The problem seems to be, how can a timespec have a sign?

The exisiting code seems to assume that a timespec can only have the
sign in one field. In other words, if tv_sec is non-zero, then tv_nsec
must be non-negative. (I added a check for this into my patch).

I took a second look at ktime_add() vs. timespec_add() and discovered
a problems both. Consider the following test code:

static void kt_add(struct timespec now, struct timespec adj)
{
	ktime_t delta, kt;
	struct timespec ts;
	delta = timespec_to_ktime(adj);
	kt = timespec_to_ktime(now);
	kt = ktime_add(kt, delta);
	ts = ktime_to_timespec(kt);
	pr_err("kt add: {%ld,%ld} + {%ld,%ld} = {%ld,%ld}\n",
	       now.tv_sec, now.tv_nsec,
	       adj.tv_sec, adj.tv_nsec,
	       ts.tv_sec, ts.tv_nsec);
}

static void ts_add(struct timespec now, struct timespec adj)
{
	struct timespec ts;
	ts = timespec_add(now, adj);
	pr_err("ts add: {%ld,%ld} + {%ld,%ld} = {%ld,%ld}\n",
	       now.tv_sec, now.tv_nsec,
	       adj.tv_sec, adj.tv_nsec,
	       ts.tv_sec, ts.tv_nsec);
}

There are (at least) four cases to consider:

1. adj > 1.0

   kt add: {2,0} + {1,100} = {3,100}                                               
   ts add: {2,0} + {1,100} = {3,100}                                               

2. adj < -1.0

   kt add: {2,0} + {-1,100} = {1,100}                                              
   ts add: {2,0} + {-1,100} = {1,100}                                              

3. 0 < adj < 1.0

   kt add: {2,0} + {0,100} = {2,100}                                               
   ts add: {2,0} + {0,100} = {2,100}                                               

4. -1.0 < adj < 0

   kt add: {2,0} + {0,-100} = {6,294967196}                                        
   ts add: {2,0} + {0,-100} = {1,999999900}                                        

Case 2 fails for both functions.
Case 4 fails when using ktime_add().

So it seems that I have now way to correctly encode a negative offset
less than -1.0 into a timespec. Perhaps we could specify new rules for
timespecs.

1. Time Values:
   If tv_sec is non-zero, then tv_nsec must be non-negative.

2. Time Deltas:
   The sign of tv_sec and tv_nsec must be the same.

In any case, I would like you help in clarifying all of this...

Thanks,

Richard
