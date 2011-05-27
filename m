Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755182Ab1E0Ms1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 08:48:27 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:45023 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754452Ab1E0MsZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 08:48:25 -0400
X-Authority-Analysis: v=1.1 cv=u/eXSd3k4P+OuNmbl5aZU3ellt6eTxbOnGssQLT4hSY= c=1 sm=0 a=Yc1t9-nblxEA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=L9TwHIVpId0pzvzusysA:9 a=2ojl_tJ_yQ-8fXdStXMA:7 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH] trace: Set oom_score_adj to maximum for ring buffer
 allocating process
From: Steven Rostedt <rostedt@goodmis.org>
To: David Rientjes <rientjes@google.com>
Cc: Vaibhav Nagarnaik <vnagarnaik@google.com>, Ingo Molnar <mingo@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Michael Rubin <mrubin@google.com>, David Sharp <dhsharp@google.com>,
        linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Mel Gorman <mel@csn.ul.ie>, Rik Van Riel <riel@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <alpine.DEB.2.00.1105270220580.22108@chino.kir.corp.google.com>
References: <1306439537-23706-1-git-send-email-vnagarnaik@google.com>
	 <1306440288.3857.9.camel@gandalf.stny.rr.com>
	 <BANLkTi=dEHG4zEZ2xRF7VEDdM6fsd9Hr=g@mail.gmail.com>
	 <alpine.DEB.2.00.1105261328200.29812@chino.kir.corp.google.com>
	 <1306443612.3857.15.camel@gandalf.stny.rr.com>
	 <BANLkTimK44fQeJJFkNzT6rBuuz=FDJ8K0w@mail.gmail.com>
	 <1306453118.3857.20.camel@gandalf.stny.rr.com>
	 <alpine.DEB.2.00.1105270220580.22108@chino.kir.corp.google.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Fri, 27 May 2011 08:48:22 -0400
Message-ID: <1306500502.3857.26.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-05-27 at 02:43 -0700, David Rientjes wrote:

> This problem isn't new, it's always been possible that an allocation that 
> is higher order, using GFP_ATOMIC or GFP_NOWAIT, or utilizing 
> __GFP_NORETRY as I suggested here, would deplete memory at the same time 
> that a GFP_FS allocation on another cpu would invoke the oom killer.
> 
> If that happens between the time when tracing_resize_ring_buffer() goes 
> oom and its nicely written error handling starts freeing memory, then it's 
> possible that another task will be unfairly oom killed.  Note that the 
> suggested solution of test_set_oom_score_adj(OOM_SCORE_ADJ_MAX) doesn't 
> prevent that in all cases: it's possible that another thread on the system 
> also has an oom_score_adj of OOM_SCORE_ADJ_MAX and it would be killed in 
> its place just because it appeared in the tasklist first (which is 
> guaranteed if this is simply an echo command).
> 
> Relying on the oom killer to kill this task for parallel blockable 
> allocations doesn't seem like the best solution for the sole reason that 
> the program that wrote to buffer_size_kb may count on its return value.  
> It may be able to handle an -ENOMEM return value and, perhaps, try to 
> write a smaller value?
> 
> I think what this patch really wants to do is utilize __GFP_NORETRY as 
> previously suggested and, if we're really concerned about parallel 
> allocations in this instance even though the same situation exists all 
> over the kernel, also create an oom notifier with register_oom_notifier() 
> that may be called in oom conditions that would free memory when 
> buffer->record_disabled is non-zero and prevent the oom.  That would 
> increase the size of the ring buffer as large as possible up until oom 
> even though it may not be to what the user requested.
> 
> Otherwise, you'll just want to use oom_killer_disable() to preven the oom 
> killer altogether.

Thanks for the detailed explanation. OK, I'm convinced. The proper
solution looks to be both the use of __GFP_NORETRY and the use of
test_set_oom_score_adj(). I don't think it is necessary to worry about
multiple users of this score adj, as when we are in an OOM situation,
things are just bad to begin with. But Google has to deal with bad
situations more than others, so if it becomes an issue for you, then we
can discuss those changes later.

Vaibhav, can you send an updated patch?

Thanks,

-- Steve


