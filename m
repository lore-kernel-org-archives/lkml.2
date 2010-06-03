Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756296Ab0FCVBT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 17:01:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23379 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754181Ab0FCVBS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 17:01:18 -0400
Date: Thu, 3 Jun 2010 22:59:48 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Arjan van de Ven <arjan@linux.intel.com>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Roland McGrath <roland@redhat.com>,
       Vegard Nossum <vegard.nossum@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] x86: make save_stack_address()
	!CONFIG_FRAME_POINTER friendly
Message-ID: <20100603205948.GA3080@redhat.com>
References: <20100603193239.GA31530@redhat.com> <4C080850.1090907@linux.intel.com> <20100603200655.GE5234@nowhere> <20100603203155.GA1163@redhat.com> <20100603205018.GF5234@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100603205018.GF5234@nowhere>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/03, Frederic Weisbecker wrote:
>
> On Thu, Jun 03, 2010 at 10:31:55PM +0200, Oleg Nesterov wrote:
> >
> > Do you mean it makes sense to add the helper which depends on
> > FRAME_POINTER ?
>
> Having in asm/stacktrace.h:
>
> #ifdef CONFIG_FRAME_POINTER
> static inline int reliable_frame_pointer(int reliable)
> {
> 	return reliable;
> }
> #else
> static inline int reliable_frame_pointer(int reliable)
> {
> 	return 1;
> }
> #endif
>
> But if we have only one user I'm not sure it's worth it.

Me too ;) let's ignore this.

> > Frederic, Arjan. Honestly, I have no opinion if this change makes
> > things better or worse for, say, lockdep.
> >
> > But note that this only affects the !CONFIG_FRAME_POINTER case.
> > Looking into Kconfig's I don't even understand how the bug reporters
> > managed to set CONFIG_STACKTRACE without !CONFIG_FRAME_POINTER.
> >
> > So, should I redo this patch to fix /proc/pid/stack ? Say, we
> > can change the meaning of stack_trace-<skip, if it is < 0, then
> > save_stack_address() ignores reliable. Yes, this is hack.
>
>
> No, people may want to ignore reliable and also to skip
> entries.

Yes, but currently stack_trace->skip is always >= 0. So I think
this should work

	skip  > 0 	- skip that much entries, consider reliable
	skip == 0	- don't skip, consider reliable
	skip  < 0	- skip nothing

But yes, I do not like this idea too much. I was going to use this
hack if this patch is nacked.

> I think your patches as is are the right way to go: by default provide
> as much information as we can.
>
> And those who care about reliability can use their own stack ops, which
> is what perf does for example. If needed we can still add a new
> save_stack_trace_reliable() in the future.

Great. Thanks!

Oleg.

