Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757395Ab0HaNdh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 09:33:37 -0400
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:34651 "EHLO
	TX2EHSOBE007.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753042Ab0HaNdf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 09:33:35 -0400
X-SpamScore: -2
X-BigFish: VPS-2(zzbb2cK146fK1432N98dN4015Lzz1202hzzz32i2a8h5bep5bfs43h61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0L80QOQ-01-B12-02
X-M-MSG: 
Date: Tue, 31 Aug 2010 15:26:51 +0200
From: Robert Richter <robert.richter@amd.com>
To: Matt Fleming <matt@console-pimps.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Will Deacon <will.deacon@arm.com>, Paul Mundt <lethal@linux-sh.org>,
        Russell King <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-sh@vger.kernel.org" <linux-sh@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>
Subject: Re: [PATCH V2 4/4] sh: Use the perf-events backend for oprofile
Message-ID: <20100831132651.GG22783@erda.amd.com>
References: <cover.1282848651.git.matt@console-pimps.org>
 <c741813aa911f0048cfab1a1a30534e8d7bb6765.1282848651.git.matt@console-pimps.org>
 <20100827145901.GO22783@erda.amd.com>
 <20100827201946.GB18829@console-pimps.org>
 <20100831112841.GF22783@erda.amd.com>
 <20100831122343.GB27532@console-pimps.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20100831122343.GB27532@console-pimps.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 31.08.10 08:23:43, Matt Fleming wrote:
> > > > > -static int op_sh_start(void)
> > > > > +static char *op_name_from_perf_name(const char *name)
> > > > >  {
> > > > > -	/* Enable performance monitoring for all counters.  */
> > > > > -	on_each_cpu(model->cpu_start, NULL, 1);
> > > > > +	if (!strcmp(name, "SH-4A"))
> > > > > +		return "sh/sh4a";
> > > > > +	if (!strcmp(name, "SH7750"))
> > > > > +		return "sh/sh7750";
> > > > 
> > > > With that implementation we always have to touch the code for new
> > > > cpus. Maybe we derive it from the perf name, e.g. making all lowercase
> > > > and removing dashes?
> > > 
> > > Is this code really that bad that we need to start playing string
> > > manipulation games?
> > 
> > No, but with that implementation we always have to update the cpu
> > string with each new cpu though nothing else changes. We may keep this
> > code. But, shouldn't we return a default string "sh/<name>" for all
> > other cases? We will then need to update only the oprofile userland
> > with new cpus.
> 
> These names are actually the names of types of performance counters,
> not a specific cpu. All SH-4 cpus that have performance counters have
> 7750-style performance counters and all SH-4A cpus have SH-4A-style
> counters.
> 
> It's unlikely we'd have to update this code in the near future. Paul,
> correct me if I'm wrong here.

Ok, this shouldn't block this patch series, we still can make a patch
if there is a use case.

> > > > > +	ops->setup		= oprofile_perf_setup;
> > > > > +	ops->create_files	= oprofile_perf_create_files;
> > > > > +	ops->start		= oprofile_perf_start;
> > > > > +	ops->stop		= oprofile_perf_stop;
> > > > > +	ops->cpu_type		= op_name_from_perf_name(sh_pmu_name());
> > > > >  
> > > > > -	model = lmodel;
> > > > > +	oprofile_perf_set_num_counters(sh_pmu_num_events());
> > > > >  
> > > > > -	ops->setup		= op_sh_setup;
> > > > > -	ops->create_files	= op_sh_create_files;
> > > > > -	ops->start		= op_sh_start;
> > > > > -	ops->stop		= op_sh_stop;
> > > > > -	ops->cpu_type		= lmodel->cpu_type;
> > > > > +	ret = oprofile_perf_init();
> > > > 
> > > > Instead of exporting all the functions above implement something like:
> > > > 
> > > > 	name = op_name_from_perf_name(sh_pmu_name());
> > > > 	num_events = sh_pmu_num_events();
> > > > 	ret = oprofile_perf_init(ops, name, num_events);
> > > > 
> > > > We will then have only oprofile_perf_init() and oprofile_perf_exit()
> > > > as interface which is much cleaner.
> > > 
> > > Well, the reason that I left it this way is so that architectures can
> > > choose to implement wrappers around the oprofile_perf_* functions. I
> > > don't think ARM or SH actually need wrappers (the only extra thing that
> > > ARM does is locking which SH should probably do too) but I assumed there
> > > was a reason that these functions pointers were exposed originally. I
> > > haven't look at what other architectures would do. I'll take a look at
> > > that.
> > 
> > I am not sure if we need such wrappers, and if so we could implement
> > it anyway, e.g.:
> > 
> >  oprofile_perf_init(perf_ops, name, num_events);
> > 
> >  op_sh_setup():
> > 
> > 	/* setup something */
> > 	...
> > 
> > 	perf_ops->setup();
> > 
> > 	/* setup more */
> > 	...
> > 
> > But I don't think we need this. And the above makes the interface much
> > cleaner.
> 
> OK, seeing as the two architectures that will use this initially don't
> require wrappers I've no problem doing it your way. It can always be
> extended later if necessary. And more importantly, with a proper
> usecase we'll be able to see exactly _how_ it needs to be extended.

Yes, right. So I am looking forward to your new version.

Thanks,

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

