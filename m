Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752663Ab2AaF6Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 00:58:25 -0500
Received: from mga14.intel.com ([143.182.124.37]:37677 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751754Ab2AaF6Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 00:58:24 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="101405946"
Subject: Re: [PATCH] perf: fix broken perf inject -b
From: Yanmin Zhang <yanmin_zhang@linux.intel.com>
Reply-To: yanmin_zhang@linux.intel.com
To: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Stephane Eranian <eranian@google.com>, linux-kernel@vger.kernel.org,
        peterz@infradead.org, mingo@elte.hu, robert.richter@amd.com,
        Avi Kivity <avi@redhat.com>
In-Reply-To: <20120130203653.GD5797@infradead.org>
References: <20120113144731.GA5458@quad>
	 <20120113165315.GA24387@infradead.org>
	 <CABPqkBTe1uqiLm02fijYE2bwF=rWWu=V0mjZQbEzW0TUKa4-+Q@mail.gmail.com>
	 <CABPqkBS50jYOHepmAqOzGYY8m+4SCJQuhrMV2yLXRYfdFpE70g@mail.gmail.com>
	 <20120130190008.GA5797@infradead.org>
	 <CABPqkBSzgc7WSbuS4L1gtCf+3u_q3fx002byArsMjKSxd5zw-g@mail.gmail.com>
	 <20120130200432.GC5797@infradead.org>
	 <CABPqkBQu=82igQV2O_UmJsuDOHh8_VyRQCUGmrGqTBvnEdyN+Q@mail.gmail.com>
	 <20120130203653.GD5797@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Organization: UMG
Date: Tue, 31 Jan 2012 13:58:19 +0800
Message-ID: <1327989499.14415.230.camel@ymzhang>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-01-30 at 18:36 -0200, Arnaldo Carvalho de Melo wrote:
> Em Mon, Jan 30, 2012 at 09:09:17PM +0100, Stephane Eranian escreveu:
> > On Mon, Jan 30, 2012 at 9:04 PM, Arnaldo Carvalho de Melo
> > <acme@redhat.com> wrote:
> > > Em Mon, Jan 30, 2012 at 08:53:26PM +0100, Stephane Eranian escreveu:
> > >> On Mon, Jan 30, 2012 at 8:00 PM, Arnaldo Carvalho de Melo
> > >> <acme@redhat.com> wrote:
> > >> > > >>> @@ -173,6 +178,7 @@ static int perf_event__inject_buildid(struct perf_tool *tool,
> > >> > > >>>               goto repipe;
> > >> > > >>>       }
> > >> > > >>> +     machine->pid = event->ip.pid;
> > >> >
> > >> > > I noticed that this statement conflicts with perf buildid-list (which
> > >> > > I am also fixing for pipe mode).
> 
> > >> > > I don't quite understand why, though.
> 
> > >> > Have you reached any conclusion about this problem? I haven't looked at
> > >> > it in detail, could you please elaborate more?
> 
> > >> I ended up removing it. But I am not sure this is correct.
> > >> Is the pid used in any way when processing buildids?
> > >
> > > I can't think of any.
> > >
> > > The same DSO could conceivably be present in the virtual machine, the
> > > host, and in the workstation used for perf report.  We just use the
> > > build-id in the perf.data file to find the right symtab.
> 
> > Right, so I don't know why it's there...
> 
> This comes from a1645ce1:
> 
> commit a1645ce12adb6c9cc9e19d7695466204e3f017fe
> Author: Zhang, Yanmin <yanmin_zhang@linux.intel.com>
> Date:   Mon Apr 19 13:32:50 2010 +0800
> 
>     perf: 'perf kvm' tool for monitoring guest performance from host
>     
>     Here is the patch of userspace perf tool.
>     
>     Signed-off-by: Zhang Yanmin <yanmin_zhang@linux.intel.com>
>     Signed-off-by: Avi Kivity <avi@redhat.com>
> 
> 
> 
> Zhang, what was the thinking about that pid in the buildid event?
I didn't work on it for a long time because of some special reasons.
I check it quickly and below are some explanation.

machine->pid is to support KVM multiple guest os kernels.
1) The guest os kernels might be different version of kernels from host's;
2) The guest os might be Windows.

At host side, every guest os is a process of host although it's multi-threaded.
machine->pid is to save its pid. The pid of host itself is HOST_KERNEL_ID.

In guest os, there are many processes. host os doesn't know them. So currently or
when I enhanced perf to support KVM, perf filters out guest os user space
detailed event samples while still keeping guest os user space simple counters.

event->ip.pid is equal to machine->pid only when 
((event->header.misc & PERF_RECORD_MISC_CPUMODE_MASK) == PERF_RECORD_MISC_GUEST_KERNEL).

In function perf_event__inject_buildid, we shouldn't reset machine->pid to
event->ip.pid. They are equal to each other if it's a guest os event. Isn't it?
If the event is host event, event->ip.pid points to a real process at host
and it shouldn't be equal to machine->pid (HOST_KERNEL_ID).

Yanmin


