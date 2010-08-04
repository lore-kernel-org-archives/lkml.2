Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932570Ab0HDGtT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 02:49:19 -0400
Received: from bld-mail19.adl2.internode.on.net ([150.101.137.104]:58053 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756438Ab0HDGtS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 02:49:18 -0400
Date: Wed, 4 Aug 2010 16:46:36 +1000
From: Dave Chinner <david@fromorbit.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Steven Rostedt <rostedt@rostedt.homelinux.com>,
        Thomas Gleixner <tglx@linutronix.de>, Christoph Hellwig <hch@lst.de>,
        Li Zefan <lizf@cn.fujitsu.com>, Lai Jiangshan <laijs@cn.fujitsu.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Tom Zanussi <tzanussi@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andi Kleen <andi@firstfloor.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        "Frank Ch. Eigler" <fche@redhat.com>, Tejun Heo <htejun@gmail.com>
Subject: Re: [patch 1/2] x86_64 page fault NMI-safe
Message-ID: <20100804064636.GY7362@dastard>
References: <20100714193652.GA13630@nowhere>
 <AANLkTilD4aYej_36lOCEvMNCdYc4jBIupi5-77oD9vD2@mail.gmail.com>
 <20100714221418.GA14533@nowhere>
 <20100714223107.GA2350@Krystal>
 <20100714224853.GC14533@nowhere>
 <20100714231117.GA22341@Krystal>
 <20100714233843.GD14533@nowhere>
 <20100715162631.GB30989@Krystal>
 <1280855904.1923.675.camel@laptop>
 <AANLkTinydcsYG6wj06bj0++EfiWUMQnZk=QvLQp=S8YB@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTinydcsYG6wj06bj0++EfiWUMQnZk=QvLQp=S8YB@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 03, 2010 at 11:56:11AM -0700, Linus Torvalds wrote:
> On Tue, Aug 3, 2010 at 10:18 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> >
> > FWIW I really utterly detest the whole concept of sub-buffers.
> 
> I'm not quite sure why. Is it something fundamental, or just an
> implementation issue?
> 
> One thing that I think could easily make sense in a _lot_ of buffering
> areas is the notion of a "continuation" buffer. We know we have cases
> where we want to attach a lot of data to one particular event, but the
> buffering itself is inevitably always going to have some limits on
> atomicity etc. And quite often, the event that _generates_ the data is
> not necessarily going to have all that data in one contiguous region,
> and doing a scatter-gather memcpy to get it that way is not good
> either.
> 
> At the same time, I do _not_ believe that the kernel ring-buffer code
> should handle pointers to sub-buffers etc, or worry about iovec-like
> arrays of smaller ranges. So if _that_ is what you mean by "concept of
> sub-buffers", then I agree with you.
> 
> But what I do think might make a lot of sense is to allow buffer
> fragments, and just teach user space to do de-fragmentation. Where it
> would be important that the de-fragmentation really is all in user
> space, and not really ever visible to the ring-buffer implementation
> itself (and there would not, for example, be any guarantees that the
> fragments would be contiguous - there could be other events in the
> buffer in between fragments).  Maybe we could even say that fragments
> might be across different CPU ring-buffers, and user-space needs to
> sort it out if it wants to (where "sort it out" literally would mean
> having to sort and re-attach them in the right order, since there
> wouldn't be any ordering between them).
> 
> From a kernel perspective, the only thing you need for fragment
> handling would be to have a buffer entry that just says "I'm fragment
> number X of event ID Y". Nothing more. Everything else would be up to
> the parser in user space to work out.

Heh. For a moment there I thought you were describing the the way
XFS writes transactions into it's log. Replace "CPU ring-buffers"
with "in-core log buffers", "userspace parsing" with "log recovery"
and "event ID" with "transaction ID", and the concept you describe
is eerily similar. That includes the fact that transactions are not
contiguous in the log, can interleave fragments between concurrent
transaction commits and they can span multiple log buffers, too. It
works pretty well for scaling concurrent writers....

I'll get back in my box now ;)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
