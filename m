Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757435Ab1CYCXW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 22:23:22 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:38096 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754610Ab1CYCXV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 22:23:21 -0400
X-Authority-Analysis: v=1.1 cv=pN6kzQkhXdmdOr6Akjoh3kGBD/S3UyPMKQp53EJY+ro= c=1 sm=0 a=UaVp1nUTDLkA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=EQ2y0qqVXTN24CGcXWwA:9 a=MOkRG8d7FNaKymhmsAAA:7 a=PtG8o-gHuOcN5nZ3UwP8AjpCsnQA:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCHv2] tracing - avoid soft lockup in trace_pipe
From: Steven Rostedt <rostedt@goodmis.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Oleg Nesterov <oleg@redhat.com>, fweisbec@gmail.com, mingo@redhat.com,
        linux-kernel@vger.kernel.org
In-Reply-To: <20110321121008.GA1979@jolsa.brq.redhat.com>
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
Content-Type: text/plain; charset="ISO-8859-15"
Date: Thu, 24 Mar 2011 22:23:18 -0400
Message-ID: <1301019798.14261.159.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-03-21 at 13:10 +0100, Jiri Olsa wrote:
> On Mon, Mar 14, 2011 at 07:06:21PM +0100, Jiri Olsa wrote:
> > On Mon, Mar 14, 2011 at 11:20:57AM -0400, Steven Rostedt wrote:
> > > On Mon, 2011-03-14 at 16:07 +0100, Jiri Olsa wrote:
> > > > So we get back the the while loop with no data added and with
> > > > TRACE_TYPE_HANDLED return code, which will keep us in the loop.
> > > > 
> > > > Not sure this is bug or feature :)
> > > > 
> > > > 
> > > Most bugs are features ;)
> > > 
> > > honestly, I'd love to rip out all the "bin", "hex" etc formats as they
> > > are pretty much deprecated.
> > > 
> > > But as you pointed out that this can keep us in the inner loop, we need
> > > to fix that. I prefer to fix it within the nop print function. Perhaps
> > > we need to fill in something. "type: %d", iter->ent->type ?
> > 
> > sounds ok :) attaching v2 patch
> hi, any feedback?

Ah, sorry, as this was a reply to the original thread, it didn't pop up
immediately.

> > 
> > 
> > ---
> > running following commands:
> > 
> >   # enable the binary option
> >   echo 1 > ./options/bin
> >   # disable context info option
> >   echo 0 > ./options/context-info 
> >   # tracing only events
> >   echo 1 > ./events/enable
> >   cat trace_pipe
> > 
> > is causing lockup (in NON preemptive kernels) inside
> > tracing_read_pipe function.
> > 
> > The reason are:
> >  - bin/hex/raw output functions for events are set to
> >    trace_nop_print function, which prints nothing and
> >    returns TRACE_TYPE_HANDLED value
> >  - LOST EVENT trace do not handle trace_seq overflow
> > 
> > These reasons force the while loop in tracing_read_pipe
> > function never to break.
> > 
> > The attached patch fixies handling of lost event trace, and
> > changes trace_nop_print to print minimal info, which is needed
> > for the correct tracing_read_pipe processing.
> > 
> > v2 changes:
> >  - omit the cond_resched changes by trace_nop_print changes
> >  - WARN changed to WARN_ONCE and added info to be able
> >    to find out the culprit

So this replaces both patches, correct?

Thanks,

-- Steve



