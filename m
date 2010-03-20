Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751849Ab0CTN4Y (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Mar 2010 09:56:24 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:54301 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751378Ab0CTN4W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Mar 2010 09:56:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=N3QWquJBNwzDS7kzNTR35rIgFFCjaGwSlZn8j/oMxPtEG93ERHDs5JcZP8D1pTSCho
         wDsENayZUH7rP+ptRU2vsEa4+t73b3zBd13BfTpoFJJonZDDA/VosHH/wpCyZ6AAUOfl
         hk8pOY+YKGr7YpGAwv4gy1GI/7cJehUM/aMrw=
Date: Sat, 20 Mar 2010 16:56:04 +0300
From: Dan Carpenter <error27@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@redhat.com>, Frederic Weisbecker <fweisbec@gmail.com>,
       Li Zefan <lizf@cn.fujitsu.com>, Tom Zanussi <tzanussi@gmail.com>,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [patch] trace: find the correct ftrace event
Message-ID: <20100320135604.GA28881@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ingo Molnar <mingo@redhat.com>,
	Frederic Weisbecker <fweisbec@gmail.com>,
	Li Zefan <lizf@cn.fujitsu.com>, Tom Zanussi <tzanussi@gmail.com>,
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
References: <20100320131923.GA20922@bicker> <1269092233.28658.9.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1269092233.28658.9.camel@localhost>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 20, 2010 at 09:37:13AM -0400, Steven Rostedt wrote:
> On Sat, 2010-03-20 at 16:19 +0300, Dan Carpenter wrote:
> > The original code doesn't work because "call" is never NULL there.
> 
> A one line change would have done the same ;-)
> 
> > Signed-off-by: Dan Carpenter <error27@gmail.com>
> > ---
> > My code should work, but it seems like there should but it seems like
> > there should be a more elegant way to do this?
> > 
> > diff --git a/kernel/trace/trace_events_filter.c b/kernel/trace/trace_events_filter.c
> > index 4615f62..6070c70 100644
> > --- a/kernel/trace/trace_events_filter.c
> > +++ b/kernel/trace/trace_events_filter.c
> > @@ -1388,16 +1388,19 @@ int ftrace_profile_set_filter(struct perf_event *event, int event_id,
> >  	struct event_filter *filter;
> >  	struct filter_parse_state *ps;
> >  	struct ftrace_event_call *call = NULL;
> > +	int found = 0;
> >  
> >  	mutex_lock(&event_mutex);
> >  
> >  	list_for_each_entry(call, &ftrace_events, list) {
> > -		if (call->id == event_id)
> > +		if (call->id == event_id) {
> > +			found = 1;
> >  			break;
> > +		}
> >  	}
> >  
> >  	err = -EINVAL;
> > -	if (!call)
> 
> 	if (call == &ftrace_events)
> 

Man...  That makes my head hurt.  It only works because ->list is the 
first element in the struct.

We'd need a cast.

Is that really cleaner?

regards,
dan carpenter

> -- Steve
> 
> > +	if (!found)
> >  		goto out_unlock;
> >  
> >  	err = -EEXIST;
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
