Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752818Ab0IMVkG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 17:40:06 -0400
Received: from mail.openrapids.net ([64.15.138.104]:53420 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751994Ab0IMVkE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 17:40:04 -0400
Date: Mon, 13 Sep 2010 17:40:02 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@elte.hu>, Tony Lindgren <tony@atomide.com>
Subject: Re: [PATCH] sched: fix string comparison in features
Message-ID: <20100913214002.GA16118@Krystal>
References: <20100911174400.GA13462@Krystal> <1284413672.5701.12.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1284413672.5701.12.camel@gandalf.stny.rr.com>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 17:39:38 up 234 days, 16 min,  3 users,  load average: 0.18,
	0.13, 0.05
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Steven Rostedt (rostedt@goodmis.org) wrote:
> On Sat, 2010-09-11 at 13:44 -0400, Mathieu Desnoyers wrote:
> > Incorrect handling of the following case:
> > 
> > INTERACTIVE
> > INTERACTIVE_SOMETHING_ELSE
> > 
> > The comparison only checks up to each element's length.
> 
> Replace all your changes with mine, and you have the same effect ;-)

Indeed, your approach looks much nicer. Will update.

Thanks,

Mathieu

> 
> -- Steve
> 
> > 
> > Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> > ---
> >  kernel/sched.c |   11 ++++++++++-
> >  1 file changed, 10 insertions(+), 1 deletion(-)
> > 
> > Index: linux-2.6-lttng.git/kernel/sched.c
> > ===================================================================
> > --- linux-2.6-lttng.git.orig/kernel/sched.c
> > +++ linux-2.6-lttng.git/kernel/sched.c
> > @@ -722,7 +722,7 @@ sched_feat_write(struct file *filp, cons
> >  {
> >  	char buf[64];
> >  	char *cmp = buf;
> 
> -	char *cmp = buf;
> +	char *cmp;
> 
> > -	int neg = 0;
> > +	int neg = 0, cmplen;
> >  	int i;
> >  
> >  	if (cnt > 63)
> > @@ -732,15 +732,24 @@ sched_feat_write(struct file *filp, cons
> >  		return -EFAULT;
> >  
> >  	buf[cnt] = 0;
> > +	for (i = 0; i < cnt; i++) {
> > +		if (buf[i] == '\n' || buf[i] == ' ') {
> > +			buf[i] = 0;
> > +			break;
> > +		}
> > +	}
> 
> +	cmp = strstrip(buf);
> 
> >  
> >  	if (strncmp(buf, "NO_", 3) == 0) {
> >  		neg = 1;
> >  		cmp += 3;
> >  	}
> >  
> > +	cmplen = strlen(cmp);
> >  	for (i = 0; sched_feat_names[i]; i++) {
> >  		int len = strlen(sched_feat_names[i]);
> 
> -		int len = strlen(sched_feat_names[i]);
> 
> >  
> > +		if (cmplen != len)
> > +			continue;
> >  		if (strncmp(cmp, sched_feat_names[i], len) == 0) {
> 
> -		if (strncmp(cmp, sched_feat_names[i], len) == 0) {
> +		if (strcmp(cmp, sched_feat_names[i]) == 0) {
> 
> >  			if (neg)
> >  				sysctl_sched_features &= ~(1UL << i);
> 
> 

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
