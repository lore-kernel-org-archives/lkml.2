Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750849Ab0HRCKA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 22:10:00 -0400
Received: from mail.openrapids.net ([64.15.138.104]:34702 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750708Ab0HRCJ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 22:09:56 -0400
Date: Tue, 17 Aug 2010 22:09:53 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, ltt-dev@lists.casi.polymtl.ca,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Christoph Hellwig <hch@lst.de>,
        Li Zefan <lizf@cn.fujitsu.com>, Lai Jiangshan <laijs@cn.fujitsu.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Tom Zanussi <tzanussi@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andi Kleen <andi@firstfloor.org>,
        Alexander Shishkin <virtuoso@slind.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, Imre Deak <imre.deak@nokia.com>,
        Jamie Lokier <jamie@shareable.org>,
        Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [RFC PATCH 01/20] Create generic alignment API (v8)
Message-ID: <20100818020953.GA10401@Krystal>
References: <20100817231619.277457797@efficios.com> <20100817232150.251244768@efficios.com> <1282094726.3268.2197.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1282094726.3268.2197.camel@gandalf.stny.rr.com>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 21:39:10 up 207 days,  4:15,  4 users,  load average: 0.08, 0.04,
	0.01
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Steven Rostedt (rostedt@goodmis.org) wrote:
> On Tue, 2010-08-17 at 19:16 -0400, Mathieu Desnoyers wrote:
> 
> > +/*
> > + * Align pointer on natural object alignment. Object size must be power of two.
> > + */
> 
> Hmm, I wonder if we should add a compiler bug here too.
> 
> extern void __bug_obj_not_power_of_two(void);
> 
> ({
> 	if ((sizeof(*obj) - 1) & sizeof(*obj))
> 		__bug_obj_not_power_of_two();
> 	PTR_ALIGN((obj), __alignof__(*(obj)));
> })

[...]

Nevermind the "Object size must be power of two." part of the comment. That was
true when I first implemented the patch, where I used sizeof(), e.g.:

#define object_align(obj)       PTR_ALIGN(obj, sizeof(*(obj)))
#define object_align_floor(obj) PTR_ALIGN_FLOOR(obj, sizeof(*(obj)))

But given that we can expect structures and various objects to be passed as
parameters, __alignof__ is more appropriate. This is what this patch now
implements:

#define object_align(obj)       PTR_ALIGN(obj, __alignof__(*(obj)))
#define object_align_floor(obj) PTR_ALIGN_FLOOR(obj, __alignof__(*(obj)))

so we let gcc determine the appropriate alignment. It will automatically be a
power of two. I'll just update the comment.

[...]

> I take it that theses functions can have variables passed to it for
> alignment, thus a check wont help. Although, we could add a test for the
> constant case.

That's right. I could add something like:

  MAYBE_BUILD_BUG_ON_NOT_POWER_OF_2(alignment);

which will add a dependency on kernel.h (for MAYBE_BUILD_BUG_ON) and log2.h (for
is_power_of_2). I'll move the #include <linux/align.h> further down in kernel.h,
keeping it outside of #ifdef __KERNEL__.

To make sure this build test works when a constant is passed to offset_align or
offset_align_floor, I'll have to turn them into macros instead of static
inlines.

The next round will have a patch that adds "MAYBE_BUILD_BUG_ON_NOT_POWER_OF_2"
to kernel.h.

Thanks,

Mathieu

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
