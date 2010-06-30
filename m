Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756756Ab0F3QAh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 12:00:37 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:34873 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754561Ab0F3QAd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 12:00:33 -0400
X-Authority-Analysis: v=1.1 cv=aMplT6I4JJ0P4CS7sRSHqoj9En8aKfIxSsimYOJhsMQ= c=1 sm=0 a=BXBGmoTg8BIA:10 a=uEzv4HemXiYA:10 a=7U3hwN5JcxgA:10 a=Q9fys5e9bTEA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=D19gQVrFAAAA:8 a=meVymXHHAAAA:8 a=VnNF1IyMAAAA:8 a=7HDGqFX1_b5Lpb2Hd_gA:9 a=y_qu_t2zBb4dWjknZ1UVhhBx9BEA:4 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [Bugfix] unregister_trace_probe needs to be called under mutex
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Peter Zijlstra <peterz@infradead.org>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1277891066.1868.107.camel@laptop>
References: <20100630084548.GA10325@linux.vnet.ibm.com>
	 <1277891066.1868.107.camel@laptop>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Wed, 30 Jun 2010 12:00:29 -0400
Message-ID: <1277913629.24800.29.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-06-30 at 11:44 +0200, Peter Zijlstra wrote:
> On Wed, 2010-06-30 at 14:15 +0530, Srikar Dronamraju wrote:
> > Comment in unregister_trace_probe() says probe_lock will be held
> > when it gets called. However there is a case where it might called
> > without the probe_lock being held. Also since we are traversing the
> > probe_list and deleting an element from the probe_list, probe_lock
> > should be held.
> > 
> > This was first pointed in uprobes traceevent review by Frederic
> > Weisbecker here.  (http://lkml.org/lkml/2010/5/12/106)
> > 
> > This patch is needed for both 2.6.35-rc3 and 2.6.35-rc3-tip

Acked-by: Steven Rostedt <rostedt@goodmis.org>

> > 
> > Signed-off-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
> > ---
> > 
> > diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
> > index 4f11a56..67670cd 100644
> > --- a/kernel/trace/trace_kprobe.c
> > +++ b/kernel/trace/trace_kprobe.c
> > @@ -269,14 +269,17 @@ static int create_trace_probe(int argc, char **argv)
> >  			pr_info("Delete command needs an event name.\n");
> >  			return -EINVAL;
> >  		}
> > +		mutex_lock(&probe_lock);
> >  		tp = find_probe_event(event, group);
> >  		if (!tp) {
> > +			mutex_unlock(&probe_lock);
> >  			pr_info("Event %s/%s doesn't exist.\n", group, event);
> >  			return -ENOENT;
> >  		}
> >  		/* delete an event */
> >  		unregister_trace_probe(tp);
> >  		free_trace_probe(tp);
> > +		mutex_unlock(&probe_lock);
> >  		return 0;
> >  	}
> 
> Shouldn't all that go through steven's ->reg() interface?

Nah, this is specific to the kprobe code. Has really nothing to do with
the ->reg() interface.

-- Steve


