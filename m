Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753769Ab0IAMP0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Sep 2010 08:15:26 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:35768 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752626Ab0IAMPV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Sep 2010 08:15:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=JjZmxCTFD/kHB5d7sPCydqGawPyEi5YrD9nisPkT6YIzqa48C5KzX8wzOjMr7Yfiy9
         c0Itq5QhCnMAg/oEnDT/kZjewdiSTYkeN+AEY3H/NLWFNptnYRspAHVgfQFLri5hv7gU
         gmsE0HZBAPD5I+SsuhFuMztWVy9Q9y6X3r+Jg=
Date: Wed, 1 Sep 2010 14:15:20 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Avi Kivity <avi@redhat.com>, Li Zefan <lizf@cn.fujitsu.com>,
        Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
        kvm-devel <kvm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: ftrace/perf_event leak
Message-ID: <20100901121518.GA5378@nowhere>
References: <4C7E11E5.1040402@redhat.com> <1283331868.2059.808.camel@laptop> <4C7E1C36.6070400@redhat.com> <4C7E1F12.8030304@cn.fujitsu.com> <4C7E2D1D.3080603@redhat.com> <1283338977.2059.938.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1283338977.2059.938.camel@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 01, 2010 at 01:02:57PM +0200, Peter Zijlstra wrote:
> On Wed, 2010-09-01 at 13:38 +0300, Avi Kivity wrote:
> > On 09/01/2010 12:38 PM, Li Zefan wrote:
> > >
> > > Then try this:
> > 
> > Tested-by: Avi Kivity <avi@redhat.com>
> > 
> 
> Thanks, queued as:
> 
> ---
> Subject: perf, trace: Fix module leak
> From: Li Zefan <lizf@cn.fujitsu.com>
> Date: Wed Sep 01 12:58:43 CEST 2010
> 
> Commit 1c024eca (perf, trace: Optimize tracepoints by using
> per-tracepoint-per-cpu hlist to track events) caused a module refcount
> leak.
> 
> Tested-by: Avi Kivity <avi@redhat.com>
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> LKML-Reference: <4C7E1F12.8030304@cn.fujitsu.com>
> ---
>  kernel/trace/trace_event_perf.c |    3 +++
>  1 file changed, 3 insertions(+)
> 
> Index: linux-2.6/kernel/trace/trace_event_perf.c
> ===================================================================
> --- linux-2.6.orig/kernel/trace/trace_event_perf.c
> +++ linux-2.6/kernel/trace/trace_event_perf.c
> @@ -91,6 +91,8 @@ int perf_trace_init(struct perf_event *p
>  		    tp_event->class && tp_event->class->reg &&
>  		    try_module_get(tp_event->mod)) {
>  			ret = perf_trace_event_init(tp_event, p_event);
> +			if (ret)
> +				module_put(tp_event->mod);
>  			break;
>  		}
>  	}
> @@ -147,6 +149,7 @@ void perf_trace_destroy(struct perf_even
>  		}
>  	}
>  out:
> +	module_put(tp_event->mod);
>  	mutex_unlock(&event_mutex);
>  }
>  
> 



Thanks for fixing this.

However, can we split this in two patches to ease the backport?

The lack of a module_put() after perf_trace_init() failure is there for a while
(the backport needs to start in 2.6.32).

But the lack of a module_put in the destroy path needs a .35 backport only.

