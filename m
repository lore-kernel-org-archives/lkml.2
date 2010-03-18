Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752452Ab0CRQ4Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 12:56:16 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:43234 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751089Ab0CRQ4O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 12:56:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=xjI59TN19puWVH7hcMja+/d9uUSO65Erj6ERgabQanLynpF/s2pvnBLvTbvMMkQoLl
         9GjqFg8VBz70HZ/kmYPcJ+OnWBDWEhEPA1SrrT62/ilVwkZXpu2zdxVGWqN2NLlP7qYA
         YMfLcvyvze35U039ENcNZNf8upIl1Qr/r9XmA=
Date: Thu, 18 Mar 2010 17:56:16 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: David Miller <davem@davemloft.net>, sparclinux@vger.kernel.org,
       tj@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [BUG] percpu misaligned allocation
Message-ID: <20100318165613.GA5103@nowhere>
References: <20100318044930.GC5045@nowhere> <20100317.232648.59697287.davem@davemloft.net> <4BA1CA91.2060004@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BA1CA91.2060004@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 18, 2010 at 02:39:13PM +0800, Li Zefan wrote:
> David Miller wrote:
> > From: Frederic Weisbecker <fweisbec@gmail.com>
> > Date: Thu, 18 Mar 2010 05:49:33 +0100
> > 
> >> While using the lock events through perf in a sparc box, I can see
> >> the following message repeated many times:
> >>
> >> 	Kernel unaligned access at TPC[49357c] perf_trace_lock_acquire+0xb4/0x180
> >>
> >> It actually hangs the box as the messages are sent to a serial console.
> >>
> >> When used with perf, the trace events use a per cpu buffer allocated
> >> in kernel/trace/trace_event_perf.c, and the allocation appears to return
> >> a misaligned percpu pointer. It is aligned to 4 while it seems it
> >> requires to be aligned to 8.
> > 
> > Thanks I'll take a look at this.
> > 
> > RAW locks (both rwlocks and spinlocks) on sparc64 are 4-bytes
> > in size, maybe some piece of code is assuming that locks
> > are cpu word sized.
> > 
> > Where is perf_trace_lock_acquire() I can't find it in Linus's
> > tree?  Does it get created by some crazy macro expansion?
> > 
> 
> Yes, it's expanded by some crazy macro in include/trace/ftrace.h..
> 
> In linus' tree, it's called ftrace_profile_lock_acquire(), and it's
> renamed to perf_trace_lock_acquire() in -tip tree by commit
> 97d5a22005f38057b4bc0d95f81cd26510268794.
> 
> #undef DECLARE_EVENT_CLASS
> #define DECLARE_EVENT_CLASS(call, proto, args, tstruct, assign, print)  \
> static notrace void                                                     \
> ftrace_profile_templ_##call(struct ftrace_event_call *event_call,       \
>                             proto)                                      \
> {                                                                       \
>         struct ftrace_data_offsets_##call __maybe_unused __data_offsets;\
>         struct ftrace_raw_##call *entry;                                \
>         u64 __addr = 0, __count = 1;                                    \
>         unsigned long irq_flags;                                        \
>         int __entry_size;                                               \
>         int __data_size;                                                \
>         int rctx;                                                       \
>                                                                         \
> ...
> }


Yeah indeed. The problem happens in Linus's tree and -tip tree as well,
it's just that I debugged it in -tip and there has been a naming change
inside, I forgot about that. So in mainline the problem happens in
ftrace_profile_templ_lock_acquire (macro generated above).

Thanks.

