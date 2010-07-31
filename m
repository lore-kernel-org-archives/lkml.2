Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754747Ab0GaC7z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 22:59:55 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:49519 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751940Ab0GaC7x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 22:59:53 -0400
Date: Sat, 31 Jul 2010 08:27:48 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Christoph Hellwig <hch@infradead.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Oleg Nesterov <oleg@redhat.com>, Mark Wielaard <mjw@redhat.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Naren A Devaiah <naren.devaiah@in.ibm.com>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCHv10 2.6.35-rc6-tip 11/14]  perf: perf interface for
 uprobes
Message-ID: <20100731025748.GA22812@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20100727110855.24690.26901.sendpatchset@localhost6.localdomain6>
 <20100727111105.24690.48335.sendpatchset@localhost6.localdomain6>
 <20100730191903.GD12166@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20100730191903.GD12166@ghostprotocols.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >  		 "Set how many probe points can be found for a probe."),
> > +	OPT_INTEGER('p', "pid", &params.upid,
> > +			"specify a pid for a uprobes based probe"),
> 
> "ubrobes based probe" could be made clear as:
> 
> "Specify pid of process where the probe will be added"

Okay . will do.

> 
> ?
> 
> The following three hunks could be moved to a separate patch that I'd
> apply on my perf/core branch, so to reduce this patchset size, like I
> did with the s/kprobe/probe/g one that is already there:
> 
> http://git.kernel.org/?p=linux/kernel/git/acme/linux-2.6.git;a=commitdiff;h=0e60836bbd392300198c5c2d918c18845428a1fe
> 
[snipped]

Okay, I can make a separate patch of those three hunks and send it out. 

> 
> >  			group = pev->group;
> > -		else
> > +		else if (!pev->upid)
> >  			group = PERFPROBE_GROUP;
> > +		else {
> > +			/*
> > +			 * For uprobes based probes create a group
> > +			 * probe_<pid>.
> > +			 */
> > +			snprintf(buf, 64, "%s_%d", PERFPROBE_GROUP, pev->upid);
> > +			group = buf;
> > +		}
> > +
> > +		tev->group = strdup(group);
> 
> Here you don't check as you do on the next strdups 

Actually tev->group gets checked where tev->event gets checked. 
However I had moved assigning tev->group to where group gets
assigned. This probably is causing the confusion. I will move the
assignment to where tev->event gets assigned.

> >  			break;
> >  		event = buf;
> > -
> >  		tev->event = strdup(event);
> > -		tev->group = strdup(group);
> > +
> 
> here

This strdup(group) was moved ahead by few lines. I can move it back
here it makes things more clear.

> 
> >  				       tev->point.symbol, NULL);
> > @@ -1598,15 +1812,19 @@ struct __event_package {
> >  int add_perf_probe_events(struct perf_probe_event *pevs, int npevs,
> >  			  bool force_add, int max_tevs)
> >  {
> > -	int i, j, ret;
> > +	int i, j, ret = 0;
> >  	struct __event_package *pkgs;
> >  
> >  	pkgs = zalloc(sizeof(struct __event_package) * npevs);
> >  	if (pkgs == NULL)
> >  		return -ENOMEM;
> >  
> > -	/* Init vmlinux path */
> > -	ret = init_vmlinux();
> > +	if (!pevs->upid)
> > +		/* Init vmlinux path */
> > +		ret = init_vmlinux();
> > +	else
> > +		ret = init_perf_uprobes();
> > +
> >  	if (ret < 0)
> 
> pkgs leaks here.

Right, but I dont think this leak was introduced by my patch(s). I
guess its better fixed by a different patch. 

> 

--
Thanks and Regards
Srikar
