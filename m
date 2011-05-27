Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758807Ab1E0Jnd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 05:43:33 -0400
Received: from smtp-out.google.com ([74.125.121.67]:3737 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752590Ab1E0Jnc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 05:43:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=NVsxHyRyP6ZnC4B/2Um1uz/X9fQkOj/qZh5pmWcJEvNn90y6w4vw5S0BNbDDlZryW3
         Mg2vMczVhhl3rSm2KP5Q==
Date: Fri, 27 May 2011 02:43:26 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Steven Rostedt <rostedt@goodmis.org>
cc: Vaibhav Nagarnaik <vnagarnaik@google.com>, Ingo Molnar <mingo@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Michael Rubin <mrubin@google.com>, David Sharp <dhsharp@google.com>,
        linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Mel Gorman <mel@csn.ul.ie>, Rik Van Riel <riel@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] trace: Set oom_score_adj to maximum for ring buffer
 allocating process
In-Reply-To: <1306453118.3857.20.camel@gandalf.stny.rr.com>
Message-ID: <alpine.DEB.2.00.1105270220580.22108@chino.kir.corp.google.com>
References: <1306439537-23706-1-git-send-email-vnagarnaik@google.com> <1306440288.3857.9.camel@gandalf.stny.rr.com> <BANLkTi=dEHG4zEZ2xRF7VEDdM6fsd9Hr=g@mail.gmail.com> <alpine.DEB.2.00.1105261328200.29812@chino.kir.corp.google.com> <1306443612.3857.15.camel@gandalf.stny.rr.com>
 <BANLkTimK44fQeJJFkNzT6rBuuz=FDJ8K0w@mail.gmail.com> <1306453118.3857.20.camel@gandalf.stny.rr.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 May 2011, Steven Rostedt wrote:

> > What do you think of this?
> > 
> > test_set_oom_score_adj(MAXIMUM);
> > allocate_ring_buffer(GFP_KERNEL | __GFP_NORETRY);
> > test_set_oom_score_adj(original);
> > 
> > This makes sure that the allocation fails much sooner and more
> > gracefully. If oom-killer is invoked in any circumstance, then the ring
> > buffer allocation process gives up memory and is killed.
> 
> I don't know. But as I never seen this function before, I went and took
> a look. This test_set_oom_score_adj() is new, and coincidentally written
> by another google developer ;)
> 

Ignore the history of function, it simply duplicates the old PF_OOM_ORIGIN 
flag that is now removed.

> As there's not really a precedence to this, if those that I added to the
> Cc, give their acks, I'm happy to apply this for the next merge window.
> 

This problem isn't new, it's always been possible that an allocation that 
is higher order, using GFP_ATOMIC or GFP_NOWAIT, or utilizing 
__GFP_NORETRY as I suggested here, would deplete memory at the same time 
that a GFP_FS allocation on another cpu would invoke the oom killer.

If that happens between the time when tracing_resize_ring_buffer() goes 
oom and its nicely written error handling starts freeing memory, then it's 
possible that another task will be unfairly oom killed.  Note that the 
suggested solution of test_set_oom_score_adj(OOM_SCORE_ADJ_MAX) doesn't 
prevent that in all cases: it's possible that another thread on the system 
also has an oom_score_adj of OOM_SCORE_ADJ_MAX and it would be killed in 
its place just because it appeared in the tasklist first (which is 
guaranteed if this is simply an echo command).

Relying on the oom killer to kill this task for parallel blockable 
allocations doesn't seem like the best solution for the sole reason that 
the program that wrote to buffer_size_kb may count on its return value.  
It may be able to handle an -ENOMEM return value and, perhaps, try to 
write a smaller value?

I think what this patch really wants to do is utilize __GFP_NORETRY as 
previously suggested and, if we're really concerned about parallel 
allocations in this instance even though the same situation exists all 
over the kernel, also create an oom notifier with register_oom_notifier() 
that may be called in oom conditions that would free memory when 
buffer->record_disabled is non-zero and prevent the oom.  That would 
increase the size of the ring buffer as large as possible up until oom 
even though it may not be to what the user requested.

Otherwise, you'll just want to use oom_killer_disable() to preven the oom 
killer altogether.
