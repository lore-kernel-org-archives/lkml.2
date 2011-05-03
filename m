Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752328Ab1ECV4q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 17:56:46 -0400
Received: from smtp-out.google.com ([74.125.121.67]:45417 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751322Ab1ECV4p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 17:56:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=lQF2HjMUGCCWPcc9Q5WwwYtdt+C1zYwbZH2qWhoHaWUqznC88r10RKNEH50TnDpYpx
         4U6DIMB9Jsz9sHzOvATQ==
MIME-Version: 1.0
In-Reply-To: <20110503214142.GC2678@nowhere>
References: <1304456616-30281-1-git-send-email-vnagarnaik@google.com> <20110503214142.GC2678@nowhere>
From: Vaibhav Nagarnaik <vnagarnaik@google.com>
Date: Tue, 3 May 2011 14:56:11 -0700
Message-ID: <BANLkTinA8M8Ok2jghtCoeBiTfw6n3NSziA@mail.gmail.com>
Subject: Re: [RFC PATCH] tracing: Don't call wakeup() when committing the event
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>,
        Michael Rubin <mrubin@google.com>, David Sharp <dhsharp@google.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 3, 2011 at 2:41 PM, Frederic Weisbecker <fweisbec@gmail.com> wrote:
> On Tue, May 03, 2011 at 02:03:36PM -0700, Vaibhav Nagarnaik wrote:
>> In using syscall tracing by concurrent processes, the wakeup() that is
>> called in the event commit function causes contention on the spin lock
>> of the waitqueue. I enabled sys_enter_getuid and sys_exit_getuid
>> tracepoints, and by running getuid_microbench from autotest in parallel
>> I found that the contention causes exponential latency increase in the
>> tracing path.
>>
>> The autotest binary getuid_microbench calls getuid() in a tight loop for
>> the given number of iterations and measures the average time required to
>> complete a single invocation of syscall.
>>
>> The patch here points to the problem and provides a naive solution to
>> start the discussion. It is not intended to be a definitive solution.
>
> Right, so another solution could be to have per cpu waitqueues for
> the per_cpu trace_pipe/trace_pipe_raw files, and one big for the main
> trace_pipe file.

That could be another way. But if there is still *one* common waitqueue for
the main trace file, we are still going to get contention on waking up that
common waitqueue.

Unless I am missing something, can you explain why there won't be contention
in your suggested solution?

>
> That involves two wake_up() calls but then it scales and you keep
> the awakening.
>

Vaibhav Nagarnaik
