Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754540Ab2ELPBy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 May 2012 11:01:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39842 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753512Ab2ELPBw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 May 2012 11:01:52 -0400
Date: Sat, 12 May 2012 17:01:47 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: fweisbec@gmail.com, mingo@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] ftrace: No return value for ftrace_process_locs
Message-ID: <20120512150146.GA5964@m.brq.redhat.com>
References: <1335342219-2782-1-git-send-email-jolsa@redhat.com>
 <1335342219-2782-4-git-send-email-jolsa@redhat.com>
 <1336486760.14207.176.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1336486760.14207.176.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 08, 2012 at 10:19:20AM -0400, Steven Rostedt wrote:
> On Wed, 2012-04-25 at 10:23 +0200, Jiri Olsa wrote:
> > The return value of ftrace_process_locs is never checked. The function
> > tries to update as many calls as possible and in case of error there's
> > either warning output or ftrace_bug call.
> > 
> > Signed-off-by: Jiri Olsa <jolsa@redhat.com>
> > ---
> >  kernel/trace/ftrace.c |   37 ++++++++++++++++---------------------
> >  1 files changed, 16 insertions(+), 21 deletions(-)
> > 
> > diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
> > index b3ceecd..e67f5b3 100644
> > --- a/kernel/trace/ftrace.c
> > +++ b/kernel/trace/ftrace.c
> > @@ -1930,7 +1930,7 @@ static int ops_traces_mod(struct ftrace_ops *ops)
> >  	return ftrace_hash_empty(hash);
> >  }
> >  
> > -static int ftrace_update_code(struct module *mod)
> > +static void ftrace_update_code(struct module *mod)
> >  {
> >  	struct ftrace_page *pg;
> >  	struct dyn_ftrace *p;
> > @@ -1959,7 +1959,7 @@ static int ftrace_update_code(struct module *mod)
> >  		for (i = 0; i < pg->index; i++) {
> >  			/* If something went wrong, bail without enabling anything */
> >  			if (unlikely(ftrace_disabled))
> > -				return -1;
> > +				return;
> >  
> >  			p = &pg->records[i];
> >  			p->flags = ref;
> > @@ -1968,8 +1968,8 @@ static int ftrace_update_code(struct module *mod)
> >  			 * Do the initial record conversion from mcount jump
> >  			 * to the NOP instructions.
> >  			 */
> > -			if (!ftrace_code_disable(mod, p))
> > -				break;
> > +			if (WARN_ON_ONCE(!ftrace_code_disable(mod, p)))
> > +				return;
> 
> Why the warning? If ftrace_disabled is set, something broke a long time
> ago, and the ftrace_bug gives its own warning.
> 
> I don't think this is needed.

right, I missed the ftrace_disabled case..

About the ftrace_update_code/ftrace_process_locs return values..
I still think the void is better, because we dont change the code
path in case it fails and all errors are already reported.

jirka
