Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932879Ab1EZW3f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 18:29:35 -0400
Received: from smtp-out.google.com ([74.125.121.67]:17883 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758450Ab1EZW3e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 18:29:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=UouOjC3l5MavRgp39R1PfBjZZSGIwDYHWb/e4Y2d2S3GQ1Jpeqh651YaCXC16uER5e
         62ps15kv40wWsuswZ4WA==
MIME-Version: 1.0
In-Reply-To: <1306443612.3857.15.camel@gandalf.stny.rr.com>
References: <1306439537-23706-1-git-send-email-vnagarnaik@google.com>
 <1306440288.3857.9.camel@gandalf.stny.rr.com> <BANLkTi=dEHG4zEZ2xRF7VEDdM6fsd9Hr=g@mail.gmail.com>
 <alpine.DEB.2.00.1105261328200.29812@chino.kir.corp.google.com> <1306443612.3857.15.camel@gandalf.stny.rr.com>
From: Vaibhav Nagarnaik <vnagarnaik@google.com>
Date: Thu, 26 May 2011 15:28:58 -0700
Message-ID: <BANLkTimK44fQeJJFkNzT6rBuuz=FDJ8K0w@mail.gmail.com>
Subject: Re: [PATCH] trace: Set oom_score_adj to maximum for ring buffer
 allocating process
To: Steven Rostedt <rostedt@goodmis.org>
Cc: David Rientjes <rientjes@google.com>, Ingo Molnar <mingo@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Michael Rubin <mrubin@google.com>, David Sharp <dhsharp@google.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 26, 2011 at 2:00 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> But the issue is, if the process increasing the size of the ring buffer
> causes the oom, it will not handle the SIGKILL until after the ring
> buffer has finished allocating. Now, if it failed to allocate, then we
> are fine, but if it does not fail, but now we start killing processes,
> then we may be in trouble.
>

If I understand correctly, if a fatal signal is pending on a process
while allocation is called, the allocation fails. Then we handle the
freeing up memory correctly, though the echo gets killed once we return
from the allocation process.

> I like the NORETRY better. But then, would this mean that if we have a
> lot of cached filesystems, we wont be able to extend the ring buffer?

It doesn't seem so. I talked with the mm- team and I understand that
even if NORETRY is set, cached pages will be flushed out and allocation
will succeed. But it still does not address the situation when the ring
buffer allocation is going on and another process invokes OOM. If the
oom_score_adj is not set to maximum, then random processes will still be
killed before ring buffer allocation fails.

>
> I'm thinking the oom killer used here got lucky. As it killed this task,
> we were still out of memory, and the ring buffer failed to get the
> memory it needed and freed up everything that it previously allocated,
> and returned. Then the process calling this function would be killed by
> the OOM. Ideally, the process shouldn't be killed and the ring buffer
> just returned -ENOMEM to the user.

What do you think of this?

test_set_oom_score_adj(MAXIMUM);
allocate_ring_buffer(GFP_KERNEL | __GFP_NORETRY);
test_set_oom_score_adj(original);

This makes sure that the allocation fails much sooner and more
gracefully. If oom-killer is invoked in any circumstance, then the ring
buffer allocation process gives up memory and is killed.


Vaibhav Nagarnaik
