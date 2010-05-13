Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758845Ab0EMMPO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 08:15:14 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:46169 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758796Ab0EMMPM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 08:15:12 -0400
X-Authority-Analysis: v=1.1 cv=RZg5C6NCKrCZril9sGGnsuGk01/OiP2z3O3lo0hXATg= c=1 sm=0 a=EYIAjt0hOJkA:10 a=hO-oPbc3tlwA:10 a=7U3hwN5JcxgA:10 a=Q9fys5e9bTEA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=meVymXHHAAAA:8 a=20KFwNOVAAAA:8 a=yQdBAQUQAAAA:8 a=ot2zeifykWNVRvTMB34A:9 a=hCWoDmUnmVBiXDH87IkwVAIbv5IA:4 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=jEp0ucaQiEUA:10 a=IcxpeKGZWnEA:10 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [PATCH 3/4] tracing: Allow mmio tracer to display
 trace_printk() and other events
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Pekka Paalanen <pq@iki.fi>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Larry Finger <Larry.Finger@lwfinger.net>
In-Reply-To: <20100513115414.7688b51d@daedalus.pq.iki.fi>
References: <20100513012110.558313399@goodmis.org>
	 <20100513012302.352845720@goodmis.org>
	 <20100513115414.7688b51d@daedalus.pq.iki.fi>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Thu, 13 May 2010 08:15:09 -0400
Message-ID: <1273752909.27703.809.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-05-13 at 11:54 +0300, Pekka Paalanen wrote:
> On Wed, 12 May 2010 21:21:13 -0400
> Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > From: Steven Rostedt <srostedt@redhat.com>
> > 
> > The mmio tracer has its own function to handle reading of events.
> > But if it encounters an event that it does not understand it
> > ignores it instead of telling the calling function that it is not
> > processing it.
> > 
> > If someone adds trace_printk() or enables events along with the
> > mmio tracer, then these events will not be displayed in the trace
> > output.
> > 
> > Simple solution is to just have the mmio print return UNHANDLED to
> > let the caller know that it did not processes the event and the
> > caller can process the event further.
> 
> Does this not mean that the mmiotrace output may contain
> foreign lines? If it does, it will break the user space.
> The dump format is specified in
> Documentation/trace/mmiotrace.txt.
> 
> If you want to handle arbitrary messages, format them as
> MARK events, please.
> 
> If I understood correctly, then NAK for this patch. Otherwise,
> could you explain how this does not break the mmiotrace dump
> format?
> 
> Is the tracing infrastructure now supporting several
> active tracers at the same time? If yes, and if mmiotrace
> should be able to co-operate, we need a new revision of the
> dump format, or a tool that extracts the mmiotrace
> events in the current format.
> 

It only displays other events if the user enabled those events.

But that said, I don't want to break existing userspace tools. I can add
a mmiotrace option "mmiotrace_all_events", if the user wants to see all
events within the mmiotracer then they can just enable that option,
otherwise, the mmiotracer will act like it currently does.

How does that sound?

-- Steve

> Thanks.
> 
> > Reported-by: Larry Finger <Larry.Finger@lwfinger.net>
> > Cc: Pekka Paalanen <pq@iki.fi>
> > Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> > ---
> >  kernel/trace/trace_mmiotrace.c |    3 ++-
> >  1 files changed, 2 insertions(+), 1 deletions(-)
> > 
> > diff --git a/kernel/trace/trace_mmiotrace.c
> > b/kernel/trace/trace_mmiotrace.c index 017fa37..592c00f 100644
> > --- a/kernel/trace/trace_mmiotrace.c
> > +++ b/kernel/trace/trace_mmiotrace.c
> > @@ -282,7 +282,8 @@ static enum print_line_t
> > mmio_print_line(struct trace_iterator *iter) case TRACE_PRINT:
> >  		return mmio_print_mark(iter);
> >  	default:
> > -		return TRACE_TYPE_HANDLED; /* ignore unknown
> > entries */
> > +		/* Not our event */
> > +		return TRACE_TYPE_UNHANDLED;
> >  	}
> >  }
> >  
> > -- 
> > 1.7.0
> 


