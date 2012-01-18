Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757569Ab2ARN7w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 08:59:52 -0500
Received: from mx1.redhat.com ([209.132.183.28]:13544 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757529Ab2ARN7v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 08:59:51 -0500
Date: Wed, 18 Jan 2012 14:59:39 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: rostedt@goodmis.org, mingo@redhat.com, paulus@samba.org,
        acme@ghostprotocols.net, a.p.zijlstra@chello.nl,
        linux-kernel@vger.kernel.org, aarapov@redhat.com
Subject: Re: [PATCH 2/7] ftrace: Add enable/disable ftrace_ops control
 interface
Message-ID: <20120118135939.GF19019@m.redhat.com>
References: <1324493791-5688-1-git-send-email-jolsa@redhat.com>
 <1325495060-6402-1-git-send-email-jolsa@redhat.com>
 <1325495060-6402-3-git-send-email-jolsa@redhat.com>
 <20120117014209.GB24200@somewhere.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120117014209.GB24200@somewhere.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 17, 2012 at 02:42:12AM +0100, Frederic Weisbecker wrote:
> On Mon, Jan 02, 2012 at 10:04:15AM +0100, Jiri Olsa wrote:
> > Adding a way to temporarily enable/disable ftrace_ops. The change
> > follows the same way as 'global' ftrace_ops are done.
> > 
> > Introducing 2 global ftrace_ops - control_ops and ftrace_control_list
> > which take over all ftrace_ops registered with FTRACE_OPS_FL_CONTROL
> > flag. In addition new per cpu flag called 'disabled' is also added to
> > ftrace_ops to provide the control information for each cpu.
> > 
> > When ftrace_ops with FTRACE_OPS_FL_CONTROL is registered, it is
> > set as disabled for all cpus.
> > 
> > The ftrace_control_list contains all the registered 'control' ftrace_ops.
> > The control_ops provides function which iterates ftrace_control_list
> > and does the check for 'disabled' flag on current cpu.
> > 
> > Adding 2 inline functions ftrace_function_enable/ftrace_function_disable,
> > which enable/disable the ftrace_ops for given cpu.
> > 
> > Signed-off-by: Jiri Olsa <jolsa@redhat.com>
> > ---
> 
> So this is used to implement pmu->add() / -> del(). But perf_tp_event_match()
> already takes care of that by checking PERF_HES_STOPPED.
> 
> Now what you are doing here is an interesting optimization as it doesn't even
> call on ftrace_ops that have called pmu->del().
> 
> I'm not against the idea but I want to ensure this is really your purpose
> and it would be nice to put some words about that in the changelog as
> well as in PATCH 4/7.

well, to say the truth I missed the PERF_HES_STOPPED possibility ;)
since I was up to disabling ftrace_ops completely when it's not used..

but as you said it's faster, so I'd stay with it..

I'll try to make some comment about that and repost the patch

> 
> >  include/linux/ftrace.h |   42 +++++++++++++++++
> >  kernel/trace/ftrace.c  |  119 +++++++++++++++++++++++++++++++++++++++++++++---
> >  kernel/trace/trace.h   |    2 +
> >  3 files changed, 156 insertions(+), 7 deletions(-)
> > 
> > diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
> > index 523640f..0d43a2b 100644
> > --- a/include/linux/ftrace.h
> > +++ b/include/linux/ftrace.h
> > @@ -35,12 +35,14 @@ enum {
> >  	FTRACE_OPS_FL_ENABLED		= 1 << 0,
> >  	FTRACE_OPS_FL_GLOBAL		= 1 << 1,
> >  	FTRACE_OPS_FL_DYNAMIC		= 1 << 2,
> > +	FTRACE_OPS_FL_CONTROL		= 1 << 3,
> 
> Please comment the role of this flag. In fact it would be nice to have
> a comment that explains all these. GLOBAL and DYNAMIC don't actually give
> much clues alone.

I'll comment those as well..

thanks,
jirka
