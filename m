Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758616Ab1EZXis (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 19:38:48 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:52745 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757296Ab1EZXir (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 19:38:47 -0400
X-Authority-Analysis: v=1.1 cv=y6zMVzRGPZqd+EkIbWgKRW0ZY5+85Abqc3bXR1aXymM= c=1 sm=0 a=Yc1t9-nblxEA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=meVymXHHAAAA:8 a=4NPRrqaWZu2iEvSyIsIA:9 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH] trace: Set oom_score_adj to maximum for ring buffer
 allocating process
From: Steven Rostedt <rostedt@goodmis.org>
To: Vaibhav Nagarnaik <vnagarnaik@google.com>
Cc: David Rientjes <rientjes@google.com>, Ingo Molnar <mingo@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Michael Rubin <mrubin@google.com>, David Sharp <dhsharp@google.com>,
        linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Mel Gorman <mel@csn.ul.ie>, Rik Van Riel <riel@redhat.com>,
        David Rientjes <rientjes@google.com>,
        Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <BANLkTimK44fQeJJFkNzT6rBuuz=FDJ8K0w@mail.gmail.com>
References: <1306439537-23706-1-git-send-email-vnagarnaik@google.com>
	 <1306440288.3857.9.camel@gandalf.stny.rr.com>
	 <BANLkTi=dEHG4zEZ2xRF7VEDdM6fsd9Hr=g@mail.gmail.com>
	 <alpine.DEB.2.00.1105261328200.29812@chino.kir.corp.google.com>
	 <1306443612.3857.15.camel@gandalf.stny.rr.com>
	 <BANLkTimK44fQeJJFkNzT6rBuuz=FDJ8K0w@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Thu, 26 May 2011 19:38:38 -0400
Message-ID: <1306453118.3857.20.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ I added to the Cc people that understand MM more than I do ]

On Thu, 2011-05-26 at 15:28 -0700, Vaibhav Nagarnaik wrote:
> On Thu, May 26, 2011 at 2:00 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> > But the issue is, if the process increasing the size of the ring buffer
> > causes the oom, it will not handle the SIGKILL until after the ring
> > buffer has finished allocating. Now, if it failed to allocate, then we
> > are fine, but if it does not fail, but now we start killing processes,
> > then we may be in trouble.
> >
> 
> If I understand correctly, if a fatal signal is pending on a process
> while allocation is called, the allocation fails. Then we handle the
> freeing up memory correctly, though the echo gets killed once we return
> from the allocation process.
> 
> > I like the NORETRY better. But then, would this mean that if we have a
> > lot of cached filesystems, we wont be able to extend the ring buffer?
> 
> It doesn't seem so. I talked with the mm- team and I understand that
> even if NORETRY is set, cached pages will be flushed out and allocation
> will succeed. But it still does not address the situation when the ring
> buffer allocation is going on and another process invokes OOM. If the
> oom_score_adj is not set to maximum, then random processes will still be
> killed before ring buffer allocation fails.
> 
> >
> > I'm thinking the oom killer used here got lucky. As it killed this task,
> > we were still out of memory, and the ring buffer failed to get the
> > memory it needed and freed up everything that it previously allocated,
> > and returned. Then the process calling this function would be killed by
> > the OOM. Ideally, the process shouldn't be killed and the ring buffer
> > just returned -ENOMEM to the user.
> 
> What do you think of this?
> 
> test_set_oom_score_adj(MAXIMUM);
> allocate_ring_buffer(GFP_KERNEL | __GFP_NORETRY);
> test_set_oom_score_adj(original);
> 
> This makes sure that the allocation fails much sooner and more
> gracefully. If oom-killer is invoked in any circumstance, then the ring
> buffer allocation process gives up memory and is killed.

I don't know. But as I never seen this function before, I went and took
a look. This test_set_oom_score_adj() is new, and coincidentally written
by another google developer ;)

As there's not really a precedence to this, if those that I added to the
Cc, give their acks, I'm happy to apply this for the next merge window.

-- Steve
 

