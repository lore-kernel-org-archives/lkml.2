Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755898Ab1LMVI7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 16:08:59 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:43976 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755861Ab1LMVI4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 16:08:56 -0500
Date: Tue, 13 Dec 2011 21:08:38 +0000
From: Will Deacon <will.deacon@arm.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: "eranian@google.com" <eranian@google.com>, "mingo@elte.hu" <mingo@elte.hu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: perf NULL pointer dereference on -rc5
Message-ID: <20111213210838.GA6143@mudshark.cambridge.arm.com>
References: <20111213152651.GP20297@mudshark.cambridge.arm.com>
 <1323805735.9082.47.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1323805735.9082.47.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 13, 2011 at 07:48:55PM +0000, Peter Zijlstra wrote:
> On Tue, 2011-12-13 at 15:26 +0000, Will Deacon wrote:
> > 
> > Commit 10c6db11 ("perf: Fix loss of notification with multi-event") seems to
> > dereference a NULL event->rb in the wakeup handler during Vince Weaver's perf
> > tests (specifically corner_cases/overflow_requires_mmap).
> > 
> > This diff seems to fix the problem, but I'm not sure if it just hides something else:
> 
> No that is about right.. not so very good of us to have missed that.

Well, at least we caught it in the end.

> Can I add your SoB to this? 

Sure:

Signed-off-by: Will Deacon <will.deacon@arm.com>

Will

> ---
> Subject: perf: Fix ring_buffer_wakeup()
> From: Will Deacon <will.deacon@arm.com>
> Date: Tue Dec 13 20:40:45 CET 2011
> 
> Commit 10c6db11 ("perf: Fix loss of notification with multi-event")
> seems to unconditionally dereference event->rb in the wakeup handler,
> this is wrong, there might not be a buffer attached.
> 
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Link: http://lkml.kernel.org/r/20111213152651.GP20297@mudshark.cambridge.arm.com
> ---
>  kernel/events/core.c |    3 +++
>  1 file changed, 3 insertions(+)
> 
> --- a/kernel/events/core.c
> +++ b/kernel/events/core.c
> @@ -3360,9 +3360,12 @@ static void ring_buffer_wakeup(struct pe
>  
>  	rcu_read_lock();
>  	rb = rcu_dereference(event->rb);
> +	if (!rb)
> +		goto unlock;
>  	list_for_each_entry_rcu(event, &rb->event_list, rb_entry) {
>  		wake_up_all(&event->waitq);
>  	}
> +unlock:
>  	rcu_read_unlock();
>  }
>  
> 
> 
