Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755100Ab2I0GyT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 02:54:19 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:38510 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754773Ab2I0GyS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 02:54:18 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18eoxIPInQei4DzfK0CBaKEogD51NzDdA8Ne5lOGr
	RE7p519/ReC81R
Message-ID: <1348728852.7059.171.camel@marge.simpson.net>
Subject: Re: 20% performance drop on PostgreSQL 9.2 from kernel 3.5.3 to
 3.6-rc5 on AMD chipsets - bisected
From: Mike Galbraith <efault@gmx.de>
To: Ingo Molnar <mingo@kernel.org>
Cc: Borislav Petkov <bp@alien8.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Mel Gorman <mgorman@suse.de>,
        Nikolay Ulyanitsky <lystor@gmail.com>, linux-kernel@vger.kernel.org,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Suresh Siddha <suresh.b.siddha@intel.com>
Date: Thu, 27 Sep 2012 08:54:12 +0200
In-Reply-To: <20120927064142.GB5996@gmail.com>
References: <1348574286.3881.40.camel@twins>
	 <20120925131736.GA30652@x1.osrc.amd.com>
	 <20120925170058.GC30158@x1.osrc.amd.com>
	 <CA+55aFzf=CApkYn+m5omwg+9-9i=11vj=7OMxKrCKb0qc-oBgg@mail.gmail.com>
	 <20120926163233.GA5339@x1.osrc.amd.com>
	 <CA+55aFzC1GZG8+Gv9KmAcV=RGU+hw39hwC9AjfYVqiJ84qAYkw@mail.gmail.com>
	 <20120926213723.GA27692@liondog.tnic>
	 <1348722568.7059.115.camel@marge.simpson.net>
	 <20120927054742.GA4370@gmail.com>
	 <1348727665.7059.160.camel@marge.simpson.net>
	 <20120927064142.GB5996@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-09-27 at 08:41 +0200, Ingo Molnar wrote: 
> * Mike Galbraith <efault@gmx.de> wrote:
> 
> > > Just to confirm, if you turn off all preemption via a hack 
> > > (basically if you turn SCHED_OTHER into SCHED_BATCH), does 
> > > psql perform and scale much better, with the quality of 
> > > sibling selection and spreading of processes only being a 
> > > secondary effect?
> > 
> > That has always been the case here.  Preemption dominates.
> 
> Yes, so we get the best psql performance if we allow the central 
> proxy process to dominate a single CPU (IIRC it can easily go up 
> to 100% CPU utilization on that CPU - it is what determines max 
> psql throughput), and not let any worker run there much, right?

Running the thing RT didn't cut it iirc (will try that again).  For RT,
we won't look for an empty spot on wakeup, we'll just squash an ant.

> > Others should play with it too, and let their boxen speak.
> 
> Do you have an easy-to-apply hack patch by chance that has the 
> effect of turning off all such preemption, which people could 
> try?

They don't need any hacks, all they have to do is start postgreqsl
SCHED_BATCH, then run pgbench the same way.

I use schedctl, but in chrt speak, chrt -b 0 /etc/init.d/postgresql
start, and then the same for pgbench itself.

-Mike

