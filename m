Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755374Ab0IBOSX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 10:18:23 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:41960 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755204Ab0IBOSW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 10:18:22 -0400
X-Authority-Analysis: v=1.1 cv=F68j8apdn+AYvba2s2WjKYIAmW276Pjvg9wPu/ZwFig= c=1 sm=0 a=bNcLrQAqZ4kA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=ds3YjM0wM7eqGDWzylgA:9 a=tYyCDeUA8rL8wIPnenkA:7 a=tHZS5p4dJpNNp7vDerA0qkPi4nQA:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: [RFD][checkpatch] warnings on space in front of labels
From: Steven Rostedt <rostedt@goodmis.org>
To: Andy Whitcroft <apw@canonical.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Thu, 02 Sep 2010 10:18:18 -0400
Message-ID: <1283437098.2356.135.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andy,

There's a new warning that I've seen lately. It is about complaining
about spaces starting on a new line.

WARNING: please, no space for starting a line, 
				excluding comments
#90: FILE: trace-read.c:612:
+ again:$


Comments are currently the exception, but I would also like to add
labels too.

I always do labels as:

	[...]
	goto out;
	[...]
 out:
^
space


I do this because of patches. The patches that we use show the function
that the change is in. This is extremely helpful. But it fails when
there's a label in the function that starts on the first column, because
the patch will reference the label instead of the function.  If that
label is used in several functions, it makes it difficult to figure out
exactly what the patch is changing, and thus, it makes it harder to
review.

Doing a: git grep '^again:' to find such examples I found an example in
kernel/sched_clock.c

static u64 sched_clock_remote(struct sched_clock_data *scd)
{
	struct sched_clock_data *my_scd = this_scd();
	u64 this_clock, remote_clock;
	u64 *ptr, old_val, val;

	sched_clock_local(my_scd);
again:
	this_clock = my_scd->clock;
	remote_clock = scd->clock;

Doing a git blame, I see there was a change after this label. Doing a
git show on that commit I have:

git show 152f9d0710a62708710161bce1b29fa8292c8c11

which has:

--- a/kernel/sched_clock.c
+++ b/kernel/sched_clock.c
@@ -127,7 +127,7 @@ again:
        clock = wrap_max(clock, min_clock);
        clock = wrap_min(clock, max_clock);
 
-       if (cmpxchg(&scd->clock, old_clock, clock) != old_clock)
+       if (cmpxchg64(&scd->clock, old_clock, clock) != old_clock)
                goto again;
 
        return clock;
@@ -163,7 +163,7 @@ again:
                val = remote_clock;
        }
 
-       if (cmpxchg(ptr, old_val, val) != old_val)
+       if (cmpxchg64(ptr, old_val, val) != old_val)
                goto again;
 
        return val;



Notice the @@ again: in the header of the sections. This bothers me
because it makes it harder to review. If the 'again:' labels had a space
in front, the patch would have looked like this:

--- a/kernel/sched_clock.c
+++ b/kernel/sched_clock.c
@@ -127,7 +127,7 @@ static u64 sched_clock_local(struct sched_clock_data *scd)
        clock = wrap_max(clock, min_clock);
        clock = wrap_min(clock, max_clock);
 
-       if (cmpxchg(&scd->clock, old_clock, clock) != old_clock)
+       if (cmpxchg64(&scd->clock, old_clock, clock) != old_clock)
                goto again;
 
        return clock;
@@ -163,7 +163,7 @@ static u64 sched_clock_remote(struct sched_clock_data *scd)
                val = remote_clock;
        }
 
-       if (cmpxchg(ptr, old_val, val) != old_val)
+       if (cmpxchg64(ptr, old_val, val) != old_val)
                goto again;
 
        return val;


In fact, the first version looked like it changed only one function.
With the added space, it shows that it changed two functions.

I really prefer the space in front of the label. In fact, I think it
should be the default.

But could we at least remove the warning for spaces in front of labels?

What do others think?

Thanks,

-- Steve


