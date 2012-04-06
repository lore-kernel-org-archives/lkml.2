Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756765Ab2DFMGE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2012 08:06:04 -0400
Received: from mail1.windriver.com ([147.11.146.13]:60288 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753141Ab2DFMGD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2012 08:06:03 -0400
From: Mark Asselstine <mark.asselstine@windriver.com>
To: Steven Rostedt <rostedt@goodmis.org>
Reply-To: Mark Asselstine <mark.asselstine@windriver.com>
CC: <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] trace-cmd: setting plugin to 'nop' clears data before its recorded
Date: Fri, 6 Apr 2012 08:06:06 -0400
Message-ID: <9754868.ceVoCaPqDZ@super-penguin>
Organization: Wind River Systems Inc.
User-Agent: KMail/4.7.3 (Linux/3.0.0-17-generic; KDE/4.7.4; x86_64; ; )
In-Reply-To: <1333661866.4595.9.camel@acer.local.home>
References: <1333653586-3379-1-git-send-email-mark.asselstine@windriver.com> <1333653586-3379-4-git-send-email-mark.asselstine@windriver.com> <1333661866.4595.9.camel@acer.local.home>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 05 April 2012 17:37:46 Steven Rostedt wrote:
> On Thu, 2012-04-05 at 15:19 -0400, Mark Asselstine wrote:
> 
> Hi Mark,
> 
> Thanks for the updates.
> 
> > commit e09a5db1a929ab668c273b87c4f0a32b81e1c21a
> > [trace-cmd: Add trace-cmd record --date option]
> > 
> > moved the call to disable_all() in trace_record() from after
> > record_data() to before it. disable_all() sets 'nop' in
> > 'current_tracer' which has the side affect of clearing 'trace', thus
> > all the latency tracer reports are empty/useless. By moving
> > set_plugin() out of disable_all() and rather calling it after
> > record_data() we still achieve the desired goals of commit e09a5db1a9
> > while fixing latency tracing reports.
> > 
> > Signed-off-by: Mark Asselstine <mark.asselstine@windriver.com>
> > ---
> > 
> >  trace-record.c |   13 ++++++++++---
> >  1 files changed, 10 insertions(+), 3 deletions(-)
> > 
> > diff --git a/trace-record.c b/trace-record.c
> > index 1c56fa9..6887874 100644
> > --- a/trace-record.c
> > +++ b/trace-record.c
> > @@ -897,11 +897,10 @@ static void disable_tracing(void)
> > 
> >  	write_tracing_on(0);
> >  
> >  }
> > 
> > -static void disable_all(void)
> > +static void disable_all_but_plugin(void)
> 
> Hmm, I don't really care for this name. Maybe it would be better to have
> this take a parameter called "plugins", and if it is set, then you
> disable plugins, otherwise you don't. This keeps it a single function
> and not two different ones where one is slightly different than the
> other. That is usually only done when a function is used by lots of
> other areas and it is just simpler to make another function do something
> slightly different and have the original call it. But this isn't used
> much, so just changing the way it works, I think would be better.
> 

Works for me. I see you make use of gboolean elsewhere so I assume you prefer 
the use of this rather than using int?

> Also, and this has nothing to do with you or your patches, I simply hate
> the fact that I called these plugins. They should have been called
> "tracers" but I think I'm stuck with it. The term now is ambiguous as it
> means both a tracer (as it does here) and it means actual plugins that
> you can load into trace-cmd itself.
>

To stop the proliferation do you want me to name the bool 
'disable_current_tracer' rather than 'disable_plugin' or 'plugin'?

 
> >  {
> >  
> >  	disable_tracing();
> > 
> > -	set_plugin("nop");
> > 
> >  	reset_events();
> >  	
> >  	/* Force close and reset of ftrace pid file */
> > 
> > @@ -911,6 +910,12 @@ static void disable_all(void)
> > 
> >  	clear_trace();
> >  
> >  }
> > 
> > +static void disable_all(void)
> > +{
> > +	disable_all_but_plugin();
> > +	set_plugin("nop");
> > +}
> > +
> > 
> >  static void
> >  update_sched_event(struct event_list **event, const char *file,
> >  
> >  		   const char *pid_filter, const char *field_filter)
> > 
> > @@ -2227,7 +2232,7 @@ void trace_record (int argc, char **argv)
> > 
> >  	}
> >  	
> >  	if (!keep)
> > 
> > -		disable_all();
> > +		disable_all_but_plugin();
> > 
> >  	printf("Kernel buffer statistics:\n"
> >  	
> >  	       "  Note: \"entries\" are the entries left in the
> >  	       kernel ring buffer and are not\n"> 
> > @@ -2245,6 +2250,8 @@ void trace_record (int argc, char **argv)
> > 
> >  	record_data(date2ts);
> >  	delete_thread_data();
> > 
> > +	if (!keep)
> > +		set_plugin("nop");
> > 
> >  	if (keep)
> >  	
> >  		exit(0);
> 
> I think the above would have been better if you did:
> 
> 	if (keep)
> 		exit(0);
> 	else
> 		set_plugin(nop);
> 
> -- Steve

Wow, I wasn't being too bright there was I? Agreed and the 'else' isn't 
necessary either, so this is a good cleanup.

I will get this fixed up later today. Do you want a V2 of the full patch series 
or just an update of this one patch?

Regards,
Mark

