Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755414Ab0F3KzL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 06:55:11 -0400
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:46369 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753189Ab0F3KzJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 06:55:09 -0400
Date: Wed, 30 Jun 2010 16:19:34 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>,
       Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [Bugfix] unregister_trace_probe needs to be called under mutex
Message-ID: <20100630104934.GF23231@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20100630084548.GA10325@linux.vnet.ibm.com>
 <1277891066.1868.107.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1277891066.1868.107.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

Currently the ->reg() interface does a enable/disable of the
probe_events. Infact the reg callback gets set in
register_trace_probe() function which inturn gets called from the
create_trace_probe().

Do we have plans to move probe_events creation to ->reg()
interface?

--
Regards
Srikar

