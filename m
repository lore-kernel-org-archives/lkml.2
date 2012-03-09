Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758834Ab2CITAl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 14:00:41 -0500
Received: from mail1.windriver.com ([147.11.146.13]:57617 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752092Ab2CITAj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 14:00:39 -0500
Date: Fri, 9 Mar 2012 13:00:09 -0600
From: Peter Seebach <peter.seebach@windriver.com>
To: Ingo Molnar <mingo@elte.hu>
CC: Arnaldo Carvalho de Melo <acme@redhat.com>,
        Anton Blanchard <anton@samba.org>, <paulus@samba.org>,
        <peterz@infradead.org>, <dsahern@gmail.com>, <fweisbec@gmail.com>,
        <yanmin_zhang@linux.intel.com>, <emunson@mgebm.net>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] perf: Incorrect use of snprintf results in SEGV
Message-ID: <20120309130009.1b1fc742@wrlaptop>
In-Reply-To: <20120308074837.GE20784@elte.hu>
References: <20120307114249.44275ca3@kryten>
	<20120307010904.GE5656@infradead.org>
	<20120306192912.59811e3e@wrlaptop>
	<20120307203725.GA4333@elte.hu>
	<20120307151951.7e84adb6@wrlaptop>
	<20120308074837.GE20784@elte.hu>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.24.4; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 Mar 2012 08:48:37 +0100
Ingo Molnar <mingo@elte.hu> wrote:
> Erm. Doing:
> 
> 	+= snprintf(...);
> 
> is a *very* common pattern within the kernel. It occurs more 
> than a thousand times - i.e. about 25% of all snprintf uses 
> (~5000 instances) within the kernel does care about the return 
> value.
> 
> I found only a single case that did a reallocation if the buffer 
> did not fit. Lets assume that I missed some and there's 4 
> altogether.

I came back to this, because I totally thought I saw one of the horse's
legs twitch out of the corner of my eye.

See, after this conversation, I decided to go audit some of my code,
and sure enough, I found a similar pattern -- I found a couple of
places where my code had this idiom, and did not reallocate.

And in both cases, it was *a bug* that the code did not attempt to
reallocate.

This led me to reevaluate my assumptions.  It appears to me that if you
have a buffer of a given size, and for some reason you have more data
than will fit in the buffer, you have four options:

1.  Scribble outside the buffer.
2.  Truncate the data.
3.  Reallocate a larger buffer.
4.  Report a failure.

In userspace code, I think it is probably nearly always an error to
truncate rather than reallocating.  I can't think of a case where
truncating would be better.  Reporting a failure may be reasonable in
some cases.

In the kernel, that's going to be a harder call -- there are probably
circumstances where reallocating is impractical.  But casually browsing
through the many cases where no attempt is made to reallocate, I
frequently find myself thinking "boy, truncating that would sorta suck."

The assumption that code reflects intended use is a completely
reasonable one, but on evaluating the code not for what it does, but
for what it probably ought to do, I find that there are many more cases
where the correct answer should be "get a larger buffer" rather than
"discard data or possibly cut off halfway through a word".

And in userspace, I don't think I've yet found a case where
reallocating isn't the right call.  (The C library was not really
designed with kernel requirements, such as the possibility that
allocation might not be an option, in mind.)

So I think a sample of how snprintf() *is* used is not the right way to
determine the "common" use case to design for.  So far as I can tell,
in nearly all cases you need to know whether snprintf needed more
space, and you probably *want* to know how much more it needed;
otherwise, you are silently producing corrupted data.  And indeed, most
of the APIs I checked that aren't correctly checking whether snprintf
wanted to overflow are, as a result, potentially returning bogus data.

For a specific example, consider mm/mempolicy.c:

        if (flags & MPOL_MODE_FLAGS) {
                if (buffer + maxlen < p + 2)
                        return -ENOSPC;
                *p++ = '=';
                /*
                 * Currently, the only defined flags are mutually
                exclusive */
                if (flags & MPOL_F_STATIC_NODES)
                        p += snprintf(p, buffer + maxlen - p, "static");
	...

This code clearly takes great care to ensure that it returns -ENOSPC
if there isn't enough space, but does not check that the result of the
snprintf call was in range.  Failure to check this is a bug.  Because
the code is full of other careful checks, it won't result in
scribbling, but it could result in returning a buffer which ends with
"=sta" and reporting too high a length for it.

So studying the code has left me convinced that the snprintf()
interface is the right interface, and that the usage errors
you've identified are bugs, not because snprintf() returns the wrong
value, but because they are failures to check for a condition which
needs to be handled.

-s
-- 
Listen, get this.  Nobody with a good compiler needs to be justified.
