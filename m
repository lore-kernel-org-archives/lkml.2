Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752711Ab0CTObt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Mar 2010 10:31:49 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:51228 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751702Ab0CTObr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Mar 2010 10:31:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=srPmEUJQPGyU50KIXFkuSe6tXKRtcdm/YoyQQZ/1ieJeHuCGpIooO00XcRtoIh2s6H
         6L0Eb25HhQNp7Vdg9aNwN4Qhub2DPHTmG/+aRpWZiDczfcORcAVjRcr18PcWGuT96Frx
         h6BnCT6rvMvatAQWl4epTGZVPvOSQVfAysfsQ=
Date: Sat, 20 Mar 2010 17:31:37 +0300
From: Dan Carpenter <error27@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@redhat.com>, Frederic Weisbecker <fweisbec@gmail.com>,
       Li Zefan <lizf@cn.fujitsu.com>, Tom Zanussi <tzanussi@gmail.com>,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [patch] trace: find the correct ftrace event
Message-ID: <20100320143136.GE5331@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ingo Molnar <mingo@redhat.com>,
	Frederic Weisbecker <fweisbec@gmail.com>,
	Li Zefan <lizf@cn.fujitsu.com>, Tom Zanussi <tzanussi@gmail.com>,
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
References: <20100320131923.GA20922@bicker> <1269092233.28658.9.camel@localhost> <20100320135604.GA28881@bicker> <1269094036.28658.12.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1269094036.28658.12.camel@localhost>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 20, 2010 at 10:07:16AM -0400, Steven Rostedt wrote:
> On Sat, 2010-03-20 at 16:56 +0300, Dan Carpenter wrote:
> 
> > > > diff --git a/kernel/trace/trace_events_filter.c b/kernel/trace/trace_events_filter.c
> > > > index 4615f62..6070c70 100644
> > > > --- a/kernel/trace/trace_events_filter.c
> > > > +++ b/kernel/trace/trace_events_filter.c
> > > > @@ -1388,16 +1388,19 @@ int ftrace_profile_set_filter(struct perf_event *event, int event_id,
> > > >  	struct event_filter *filter;
> > > >  	struct filter_parse_state *ps;
> > > >  	struct ftrace_event_call *call = NULL;
> > > > +	int found = 0;
> > > >  
> > > >  	mutex_lock(&event_mutex);
> > > >  
> > > >  	list_for_each_entry(call, &ftrace_events, list) {
> > > > -		if (call->id == event_id)
> > > > +		if (call->id == event_id) {
> > > > +			found = 1;
> > > >  			break;
> > > > +		}
> > > >  	}
> > > >  
> > > >  	err = -EINVAL;
> > > > -	if (!call)
> > > 
> > > 	if (call == &ftrace_events)
> > > 
> > 
> > Man...  That makes my head hurt.  It only works because ->list is the 
> > first element in the struct.
> > 
> > We'd need a cast.
> 
> Oops, I missed the fact that it was list_*_entry(). That should be:
> 
> 	if (call->list != &ftrace_events)
> 
> No cast needed.
> 

Hm...  "list" is a struct not a pointer to a struct.

So it would have to be:

        if (&call->list == &ftrace_events)
                goto out_unlock;

That's how the list_for_each_entry() determines the end of the list as
well.

I'll send a patch to do that.

regards,
dan carpenter

> > 
> > Is that really cleaner?
> 
> Perhaps not, but I think it is more elegant ;-)
> 
> -- Steve
