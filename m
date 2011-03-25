Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934477Ab1CYDOy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 23:14:54 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:52541 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934463Ab1CYDOv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 23:14:51 -0400
X-Authority-Analysis: v=1.1 cv=ZtuXOl23UuD1yoJUTgnZ6i6Z5VPlPhPMWCeUNtN8OGA= c=1 sm=0 a=UaVp1nUTDLkA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=mQ1VDtjEBASVLmdvppQA:9 a=rXqLPU_xy_tS9Ko_RTgA:7 a=NkIRJHuOLYbhi6berMcfx-ZriRAA:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCHv2] tracing - avoid soft lockup in trace_pipe
From: Steven Rostedt <rostedt@goodmis.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Oleg Nesterov <oleg@redhat.com>, fweisbec@gmail.com, mingo@redhat.com,
        linux-kernel@vger.kernel.org
In-Reply-To: <1301019798.14261.159.camel@gandalf.stny.rr.com>
References: <1299970786-8075-1-git-send-email-jolsa@redhat.com>
	 <1299970786-8075-3-git-send-email-jolsa@redhat.com>
	 <20110313145811.GA30558@redhat.com>
	 <1300111651.9910.87.camel@gandalf.stny.rr.com>
	 <20110314141853.GB1936@jolsa.brq.redhat.com>
	 <1300112926.9910.100.camel@gandalf.stny.rr.com>
	 <20110314150746.GA4453@jolsa.brq.redhat.com>
	 <1300116057.9910.106.camel@gandalf.stny.rr.com>
	 <20110314180621.GA5987@jolsa.brq.redhat.com>
	 <20110321121008.GA1979@jolsa.brq.redhat.com>
	 <1301019798.14261.159.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Thu, 24 Mar 2011 23:14:49 -0400
Message-ID: <1301022889.14261.167.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-03-24 at 22:23 -0400, Steven Rostedt wrote:

> > > 
> > > 
> > > ---
> > > running following commands:
> > > 
> > >   # enable the binary option
> > >   echo 1 > ./options/bin
> > >   # disable context info option
> > >   echo 0 > ./options/context-info 
> > >   # tracing only events
> > >   echo 1 > ./events/enable
> > >   cat trace_pipe

OK, I'm trying to reproduce this, but I'm not able to.

I disabled preemption, recompiled and rebooted, and I did the above and
all I get is the numbers printing. But I can exit out with a simple ^C.

No soft lockups or anything.


I'm not saying that your patch is useless, it does seem to clean things
up. But I'm not seeing any lockups here.

The while loop will always exit when the ring buffer is empty.

You mean if the events are filling quicker than the loop then we have
this issue. Perhaps I'm not triggering enough events?

-- Steve

> > > 
> > > is causing lockup (in NON preemptive kernels) inside
> > > tracing_read_pipe function.
> > > 
> > > The reason are:
> > >  - bin/hex/raw output functions for events are set to
> > >    trace_nop_print function, which prints nothing and
> > >    returns TRACE_TYPE_HANDLED value
> > >  - LOST EVENT trace do not handle trace_seq overflow
> > > 
> > > These reasons force the while loop in tracing_read_pipe
> > > function never to break.
> > > 
> > > The attached patch fixies handling of lost event trace, and
> > > changes trace_nop_print to print minimal info, which is needed
> > > for the correct tracing_read_pipe processing.
> > > 
> > > v2 changes:
> > >  - omit the cond_resched changes by trace_nop_print changes
> > >  - WARN changed to WARN_ONCE and added info to be able
> > >    to find out the culprit
> 


