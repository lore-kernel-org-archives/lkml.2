Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753268Ab0FXGcU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jun 2010 02:32:20 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:9029 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752338Ab0FXGcT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jun 2010 02:32:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=RZvtysw0KfrkoayTpTkCH/mbciwKB1vGLlRDeqkNPUZ92U2554eXPUYwHSbAuGwCHh
         VRKQSO04oW8aONiYBnGTyDOJV7B71crX2DrHj8T2nZzmsjAvX3tGPlUfuAC9XA2uvUA1
         ZmRQ8a1zeslGUN0g7jfZNYkPBTFrl88W2olmM=
Date: Thu, 24 Jun 2010 08:32:25 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Paul Mackerras <paulus@samba.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       "K.Prasad" <prasad@linux.vnet.ibm.com>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: Hitting WARN_ON in hw_breakpoint code
Message-ID: <20100624063223.GA5313@nowhere>
References: <20100623125740.GA3368@brick.ozlabs.ibm.com> <20100623174918.GH5242@nowhere> <20100623235309.GA17441@brick.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100623235309.GA17441@brick.ozlabs.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 24, 2010 at 09:53:09AM +1000, Paul Mackerras wrote:
> On Wed, Jun 23, 2010 at 07:49:20PM +0200, Frederic Weisbecker wrote:
> 
> > Indeed. I'm suprised I've never seen this problem before while the
> > bug is quite obvious.
> > 
> > Anyway I'm cooking a fix, thanks for this report!
> 
> If you haven't been seeing it on x86, I think I'll look a bit closer.
> I would have thought that the perf_event would have a reference to the
> context, so the context shouldn't have gone away while the perf_event
> still exists.


The context is still alive and available from event->ctx.
But it is detached from the task. ie: task->perf_event_ctxp = NULL



>  It may be something we're doing differently on ppc64.


Not really. I just tested and encountered the warning in x86. The problem
is that I use to test my kernels on a testbox through ssh, so I don't see
the warnings directly, I need to run dmesg for that and sometimes I
forget to do it.

I'm actually observing that the code that keeps track of the per task
breakpoints is utterly broken anyway.

When a child task exits: every events are removed from its context and the
ctx removed from the task. The ctx is still alive though, it's just it has
no more events attached and it's not attached to the task anymore. So
counting the number of events in this context after that is totally
buggy.

If we are unlucky, this can also happen to the parent if it exits before
the child.

I have a fix, will post it very soon.

Thanks.

