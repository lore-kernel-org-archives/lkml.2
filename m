Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932463Ab0EKK3Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 06:29:25 -0400
Received: from mga09.intel.com ([134.134.136.24]:56785 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932108Ab0EKK3Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 06:29:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,206,1272870000"; 
   d="scan'208";a="620667836"
Subject: Re: [RFC][PATCH 3/9] perf: export registerred pmus via sysfs
From: Lin Ming <ming.m.lin@intel.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Corey Ashford <cjashfor@linux.vnet.ibm.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       "eranian@gmail.com" <eranian@gmail.com>,
       "Gary.Mohr@Bull.com" <Gary.Mohr@bull.com>,
       "arjan@linux.intel.com" <arjan@linux.intel.com>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Paul Mackerras <paulus@samba.org>,
       "David S. Miller" <davem@davemloft.net>,
       Russell King <rmk+kernel@arm.linux.org.uk>,
       Paul Mundt <lethal@linux-sh.org>, lkml <linux-kernel@vger.kernel.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Will Deacon <will.deacon@arm.com>, Maynard Johnson <mpjohn@us.ibm.com>,
       Carl Love <carll@us.ibm.com>
In-Reply-To: <20100511093151.GA24284@elte.hu>
References: <20100510115344.GA11238@elte.hu>
	 <4BE8931C.9070106@linux.vnet.ibm.com> <1273560419.5605.3426.camel@twins>
	 <20100511072127.GB10421@elte.hu>
	 <1273566031.30322.31.camel@minggr.sh.intel.com>
	 <1273567815.5605.3491.camel@twins>
	 <1273568620.30322.42.camel@minggr.sh.intel.com>
	 <1273569154.5605.3499.camel@twins> <20100511091833.GB18869@elte.hu>
	 <1273569877.5605.3509.camel@twins>  <20100511093151.GA24284@elte.hu>
Content-Type: text/plain
Date: Tue, 11 May 2010 18:28:42 +0800
Message-Id: <1273573722.30322.73.camel@minggr.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 (2.24.1-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-05-11 at 17:31 +0800, Ingo Molnar wrote:
> * Peter Zijlstra <peterz@infradead.org> wrote:
> 
> > On Tue, 2010-05-11 at 11:18 +0200, Ingo Molnar wrote:
> > > * Peter Zijlstra <peterz@infradead.org> wrote:
> > > 
> > > > The new PMUs will use a dynamic range that starts at PERF_TYPE_MAX.
> > > 
> > > I dont think we should use a dynamic range of event sources - it's a 
> > > completely useless indirection that has no meaning to humans.
> > > 
> > > As far as machine interfaces go a much cleaner approach would be to allow an 
> > > open fd to a sysfs file to be passed to sys_perf_event_open() - this would 
> > > identify the event source. This needs a small extension of the ABI but we 
> > > could thus get rid of the 'type' enumeration altogether and express _all_ 
> > > event sources via fds to sysfs files.
> > 
> > Whatever, that's almost identical. [...]
> 
> It's not identical: as we dont expose our mapping structure externally and 
> dont have to have some dynamic type ID allocation layer/mechanism. Also, using 
> fds is an elegant, Linuxish way of expressing some object's identity and 
> passing it along.

Don't understand this well enough.

Does it need to attach pmu info to the sys file?

For example, 

Does "perf top -e cycles" work as below?

1. get the pmu file of cycles events,
ie, /sys/devices/system/cpu/cpu_hw_events/event_source_id

2. fd = open("/sys/devices/system/cpu/cpu_hw_events/event_source_id")

3. perf_event_attr::type = fd | (1<<31)

4. In kernel, perf_event_lookup_pmu() finds pmu by fd -> sys file -> pmu


> 
> ( It also removes the possibility to intentionally or accidentally have type 
>   IDs that are not reachable via the sysfs and vica verse. )
> 
> > [...] What we can do is reserve perf_event_attr::type with bit 31 set for 
> > fd's and use the fd->file lookup instead of the type->pmu lookup.
> 
> Yeah, that sounds good.
> 
> 	Ingo

