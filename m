Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751823Ab2AZMW3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 07:22:29 -0500
Received: from casper.infradead.org ([85.118.1.10]:43139 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751460Ab2AZMW2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 07:22:28 -0500
Date: Thu, 26 Jan 2012 10:22:00 -0200
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
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
Subject: Fixing perf top --user shortcoming was: Re: [GIT PULL 0/9] perf/core
 improvements and fixes
Message-ID: <20120126122200.GA9128@infradead.org>
References: <1327446481-5505-1-git-send-email-acme@infradead.org>
 <20120126111648.GH3853@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120126111648.GH3853@elte.hu>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Jan 26, 2012 at 12:16:48PM +0100, Ingo Molnar escreveu:
> * Arnaldo Carvalho de Melo <acme@infradead.org> wrote:
> > 	The --uid feature works for root, we still need to 
> > sort out that paranoia with some threads owned by a user that 
> > prevents 'perf --uid non-root-user' to work for 
> > 'non-root-user'.

> Just wondering what detail causes that failure - the whole point 
> of --uid mingo would be to enable nonprivileged users to do 
> 'session wide' profiling, *especially* if paranoia is high.

> So what does --uid do which perf record --pid 1234 wouldnt 
> already do? By all means --uid ought to be a fancy way of doing 
> a whole bunch of perf record --pid 1234 profiling sessions, at 
> once.

I stopped at the kernel, i.e. used what can be done with what is
available from the kernel right now, the diagnosis was sent in private,
but boils down to:

+++ b/kernel/events/core.c
@@ -2636,7 +2636,8 @@ find_lively_task_by_vpid(pid_t vpid)
 
 	/* Reuse ptrace permission checks for now. */
 	err = -EACCES;
-	if (!ptrace_may_access(task, PTRACE_MODE_READ))
+	if (perf_paranoid_tracepoint_raw() &&
+	    !ptrace_may_access(task, PTRACE_MODE_READ))
 		goto errout;
 
 	return task;

ptrace_may_access(task, PTRACE_MODE_READ) fails for some tasks owned by
the user because, IIRC, in __ptrace_may_access:

        const struct cred *cred = current_cred(), *tcred;

        /* May we inspect the given task?
         * This check is used both for attaching with ptrace
         * and for allowing access to sensitive information in /proc.
         *
         * ptrace_attach denies several cases that /proc allows
         * because setting up the necessary parent/child relationship
         * or halting the specified task is impossible.
         */
        int dumpable = 0;
<SNIP>
        if (!dumpable && !task_ns_capable(task, CAP_SYS_PTRACE))
                return -EPERM;

fails.

The patch above is not any kind of solution, just a way to make it work
when paranoia is set to -1 (thus perf_paranoid_tracepoint_raw in the
POC) and show where the problem lies, ideas? Peter?

> [ Btw, we should probably alias --user to --uid as well, as that 
>   might be the intuitive thing people would typically use? ]

I'll do that
 
> Anyway, pulled, thanks a lot Arnaldo!
> 
> One detail: don't we want some of these fixes cherry-picked into 
> perf/urgent as well?

Yeah, I'll prepare a perf-urgent-for-ingo signed tag.
 
> Thanks,
> 
> 	Ingo
