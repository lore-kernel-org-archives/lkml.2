Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751832Ab2AZNJw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 08:09:52 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:47691 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751258Ab2AZNJv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 08:09:51 -0500
Date: Thu, 26 Jan 2012 14:09:19 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        David Daney <david.daney@cavium.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Jan Beulich <jbeulich@suse.com>, Joerg Roedel <joerg.roedel@amd.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung.kim@lge.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Stephane Eranian <eranian@google.com>
Subject: Re: Fixing perf top --user shortcoming was: Re: [GIT PULL 0/9]
 perf/core improvements and fixes
Message-ID: <20120126130919.GA20115@elte.hu>
References: <1327446481-5505-1-git-send-email-acme@infradead.org>
 <20120126111648.GH3853@elte.hu>
 <20120126122200.GA9128@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120126122200.GA9128@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Arnaldo Carvalho de Melo <acme@infradead.org> wrote:

> > So what does --uid do which perf record --pid 1234 wouldnt 
> > already do? By all means --uid ought to be a fancy way of 
> > doing a whole bunch of perf record --pid 1234 profiling 
> > sessions, at once.
> 
> I stopped at the kernel, i.e. used what can be done with what 
> is available from the kernel right now, the diagnosis was sent 
> in private, but boils down to:
> 
> +++ b/kernel/events/core.c
> @@ -2636,7 +2636,8 @@ find_lively_task_by_vpid(pid_t vpid)
>  
>  	/* Reuse ptrace permission checks for now. */
>  	err = -EACCES;
> -	if (!ptrace_may_access(task, PTRACE_MODE_READ))
> +	if (perf_paranoid_tracepoint_raw() &&
> +	    !ptrace_may_access(task, PTRACE_MODE_READ))
>  		goto errout;
>  
>  	return task;
> 
> ptrace_may_access(task, PTRACE_MODE_READ) fails for some tasks 
> owned by the user because, IIRC, in __ptrace_may_access:

Which tasks are these, are they privileged in any sense?

If yes and if most of the 'real' tasks a user have can be 
profiled just fine then i think we should just skip the 
privileged tasks and not abort the profiling session?

Thanks,

	Ingo
