Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757412Ab2AKQ0u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jan 2012 11:26:50 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:62264 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750970Ab2AKQ0s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jan 2012 11:26:48 -0500
Date: Wed, 11 Jan 2012 17:26:44 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: axboe@kernel.dk, mingo@redhat.com, rostedt@goodmis.org,
        teravest@google.com, slavapestov@google.com, ctalbott@google.com,
        dhsharp@google.com, linux-kernel@vger.kernel.org, winget@google.com,
        namhyung@gmail.com, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 8/9] stacktrace: implement save_stack_trace_quick()
Message-ID: <20120111162642.GC7991@somewhere.redhat.com>
References: <1326220106-5765-1-git-send-email-tj@kernel.org>
 <1326220106-5765-9-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1326220106-5765-9-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 10, 2012 at 10:28:25AM -0800, Tejun Heo wrote:
> Implement save_stack_trace_quick() which only considers the usual
> contexts (ie. thread and irq) and doesn't handle links between
> different contexts - if %current is in irq context, only backtrace in
> the irq stack is considered.

The thing I don't like is the duplication that involves not only on
stack unwinding but also on the safety checks.

What about making struct stacktrace_ops::stack() return a value
that either stops or continue the trace? In your case EOE/EOI would
be the triggering condition.

Filtering stack contexts might in fact be a desirable generic feature
overall.

At least in perf we could be interested in filtering kernel/user contexts.
And in your case in stopping after the first context. I also don't know if
we will be interested in filtering irq/exception/process stacks in the future
but I prefer to ensure we have a flexible enough interface to allow that.

So it may be a good idea to reuse the exisiting code for your needs like
a stack() return value as above. And if the post processing will be done
from userspace (which I really hope) then extend the ftrace/perf interface
to allow your quick filtering, something that can be later extended to
allow more finegrained stacktrace filtering.

> This is subset of dump_trace() done in much simpler way.  It's
> intended to be used in hot paths where the overhead of dump_trace()
> can be too heavy.

Is it? Have you found a measurable impact (outside the fact you record only
one stack).

Thanks.
