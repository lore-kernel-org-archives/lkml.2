Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755435Ab1ECVlu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 17:41:50 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:38957 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755133Ab1ECVls (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 17:41:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=REiLuXIkny7JBJI3JW73eJDWPEKauCrx1WaWYr8LaJL4DlSsXsByK0lhHUJ3An7EKe
         P18/BeIyDINaKH4QIvin9wMTyIQDAl+9zaecWeaCtOGcwMHchVEwAgqMNaEarCsrNq/w
         VGzc+bVPEuLerm3mqXBGQMJJGDCkm0kEjf3Ls=
Date: Tue, 3 May 2011 23:41:45 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Vaibhav Nagarnaik <vnagarnaik@google.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>,
        Michael Rubin <mrubin@google.com>, David Sharp <dhsharp@google.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] tracing: Don't call wakeup() when committing the
 event
Message-ID: <20110503214142.GC2678@nowhere>
References: <1304456616-30281-1-git-send-email-vnagarnaik@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1304456616-30281-1-git-send-email-vnagarnaik@google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 03, 2011 at 02:03:36PM -0700, Vaibhav Nagarnaik wrote:
> In using syscall tracing by concurrent processes, the wakeup() that is
> called in the event commit function causes contention on the spin lock
> of the waitqueue. I enabled sys_enter_getuid and sys_exit_getuid
> tracepoints, and by running getuid_microbench from autotest in parallel
> I found that the contention causes exponential latency increase in the
> tracing path.
> 
> The autotest binary getuid_microbench calls getuid() in a tight loop for
> the given number of iterations and measures the average time required to
> complete a single invocation of syscall.
> 
> The patch here points to the problem and provides a naive solution to
> start the discussion. It is not intended to be a definitive solution.

Right, so another solution could be to have per cpu waitqueues for
the per_cpu trace_pipe/trace_pipe_raw files, and one big for the main
trace_pipe file.

That involves two wake_up() calls but then it scales and you keep
the awakening.
