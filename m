Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751178Ab0IVEYD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 00:24:03 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:33353 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750736Ab0IVEYC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 00:24:02 -0400
Date: Wed, 22 Sep 2010 09:53:54 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: eranian@google.com, linux-kernel@vger.kernel.org, mingo@elte.hu,
        paulus@samba.org, davem@davemloft.net, fweisbec@gmail.com,
        perfmon2-devel@lists.sf.net, eranian@gmail.com, robert.richter@amd.com,
        acme@redhat.com, Paul Menage <menage@google.com>,
        Li Zefan <lizf@cn.fujitsu.com>
Subject: Re: [RFC PATCH 0/2] perf_events: add support for per-cpu per-cgroup
 monitoring (v3)
Message-ID: <20100922042354.GG6676@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <4c88dc9c.991ce30a.3d91.3e0e@mx.google.com>
 <1285061899.2275.824.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1285061899.2275.824.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra <peterz@infradead.org> [2010-09-21 11:38:19]:

> On Thu, 2010-09-09 at 15:05 +0200, Stephane Eranian wrote:
> > The cgroup to monitor is designated by passing a file descriptor opened
> > on a new per-cgroup file in the cgroup filesystem (perf_event.perf). The
> > option must be activated by setting perf_event_attr.cgroup=1 and passing
> > a valid file descriptor in perf_event_attr.cgroup_fd. Those are the only
> > two ABI extensions. 
> 
> > +++ b/include/linux/perf_event.h
> > @@ -215,8 +215,9 @@ struct perf_event_attr {
> >                                  */
> >                                 precise_ip     :  2, /* skid constraint       */
> >                                 mmap_data      :  1, /* non-exec mmap data    */
> > +                               cgroup         :  1, /* cgroup aggregation    */
> >  
> > -                               __reserved_1   : 46;
> > +                               __reserved_1   : 45;
> >  
> >         union {
> >                 __u32           wakeup_events;    /* wakeup every n events */
> > @@ -226,6 +227,8 @@ struct perf_event_attr {
> >         __u32                   bp_type;
> >         __u64                   bp_addr;
> >         __u64                   bp_len;
> > +
> > +       int                     cgroup_fd;
> >  };
> >  
> >  /*
> 
> I'm not sure I like this much.. so we attach to {pid,cpu}, for nodes we
> can use cpu_to_node(cpu), which would suggest to use
> cgroup_of_task(pid), except that a task can be part of multiple cgroups,
> so its not unique.

Yes, a task can belong to multiple subsystems, hence multiple cgroups.
Ideally we'd want to use pid + subsystem

> 
> One thing we could do is pass this cgroup identifier in the pid field
> and use PERF_FLAG_CGROUP or something. Currently the syscall signature
> uses pid_t, but I think we can safely change that to int.

Or union it and overload the field to contain either pid_t or fd of the cgroup

> 
> You create a special new file in the cgroup stuff, I'm not sure about
> that either, but its not something I feel too strongly about, why
> wouldn't a fd of any file or even directory of that cgroup work? Do the
> cgroup people have an opinion?

No strong opinions either way at my end.


-- 
	Three Cheers,
	Balbir
