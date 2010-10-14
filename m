Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755493Ab0JNJlT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Oct 2010 05:41:19 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:50029 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754565Ab0JNJlS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Oct 2010 05:41:18 -0400
Date: Thu, 14 Oct 2010 15:10:14 +0530
From: Bharata B Rao <bharata@linux.vnet.ibm.com>
To: Paul Turner <pjt@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        Dhaval Giani <dhaval.giani@gmail.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Pavel Emelyanov <xemul@openvz.org>,
        Herbert Poetzl <herbert@13thfloor.at>, Avi Kivity <avi@redhat.com>,
        Chris Friesen <cfriesen@nortel.com>, Paul Menage <menage@google.com>,
        Mike Waychison <mikew@google.com>, Nikhil Rao <ncrao@google.com>
Subject: Re: [PATCH v3 2/7] sched: accumulate per-cfs_rq cpu usage
Message-ID: <20101014094014.GE3874@in.ibm.com>
Reply-To: bharata@linux.vnet.ibm.com
References: <20101012074910.GA9893@in.ibm.com> <20101012075109.GC9893@in.ibm.com> <1287047996.29097.173.camel@twins> <AANLkTinJ_YyzPKZXwALoFyWTzipwd0MAYhJ1c0CBjQcS@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTinJ_YyzPKZXwALoFyWTzipwd0MAYhJ1c0CBjQcS@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 14, 2010 at 02:27:02AM -0700, Paul Turner wrote:
> On Thu, Oct 14, 2010 at 2:19 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> > On Tue, 2010-10-12 at 13:21 +0530, Bharata B Rao wrote:
> >> +#ifdef CONFIG_CFS_BANDWIDTH
> >> +       {
> >> +               .procname       = "sched_cfs_bandwidth_slice_us",
> >> +               .data           = &sysctl_sched_cfs_bandwidth_slice,
> >> +               .maxlen         = sizeof(unsigned int),
> >> +               .mode           = 0644,
> >> +               .proc_handler   = proc_dointvec_minmax,
> >> +               .extra1         = &one,
> >> +       },
> >> +#endif
> >
> > So this is basically your scalability knob.. the larger this value less
> > less frequent we have to access global state, but the less parallelism
> > is possible due to fewer CPUs depleting the total quota, leaving nothing
> > for the others.
> >
> 
> Exactly
> 
> > I guess one could go try and play load-balancer games to try and
> > mitigate this by pulling this group's tasks to the CPU(s) that have move
> > bandwidth for that group, but balancing that against the regular
> > load-balancer goal of well balancing load, will undoubtedly be
> > 'interesting'...
> >
> 
> I considered this approach as an alternative previously, but I don't
> think it can be enacted effectively:
> 
> Since quota will likely expire in a staggered fashion you're going to
> get a funnel-herd effect as everything is crowded onto the cpus with
> remaining quota.
> 
> It's much more easily avoided by keeping the slice small enough
> (relative to the bandwidth period) that we're not potentially
> stranding a significant percentage of our quota.  The potential for
> abuse could be eliminated/reduced here by making the slice size a
> constant ratio relative to the period length.  This would also make
> possible parallelism more deterministic.

You can see from the numbers I posted in 0/7, how current default of
10ms slice can lead to a large amount of stranted quota and how that
can affect the runtime obtained by the tasks. So reducing the slice
size should help, but it will still be a problem in a large system with
huge number of CPUs where each CPU claims a slice and does not use it fully.

Regards,
Bharata.
