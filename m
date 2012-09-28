Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757141Ab2I1Ihq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 04:37:46 -0400
Received: from casper.infradead.org ([85.118.1.10]:56457 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757041Ab2I1Ihk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 04:37:40 -0400
Message-ID: <1348821438.3292.48.camel@twins>
Subject: Re: 20% performance drop on PostgreSQL 9.2 from kernel 3.5.3 to
 3.6-rc5 on AMD chipsets - bisected
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@kernel.org>,
        Mike Galbraith <efault@gmx.de>, Mel Gorman <mgorman@suse.de>,
        Nikolay Ulyanitsky <lystor@gmail.com>, linux-kernel@vger.kernel.org,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Paul Turner <pjt@google.com>
Date: Fri, 28 Sep 2012 10:37:18 +0200
In-Reply-To: <CA+55aFwnos6qFMi6R9uGxY2QtkUVm3hEc_Lgx1R0+AZt5V=SRA@mail.gmail.com>
References: <20120926163233.GA5339@x1.osrc.amd.com>
	 <CA+55aFzC1GZG8+Gv9KmAcV=RGU+hw39hwC9AjfYVqiJ84qAYkw@mail.gmail.com>
	 <20120926213723.GA27692@liondog.tnic>
	 <1348722568.7059.115.camel@marge.simpson.net>
	 <20120927054742.GA4370@gmail.com>
	 <1348727665.7059.160.camel@marge.simpson.net>
	 <20120927064142.GB5996@gmail.com>
	 <1348728852.7059.171.camel@marge.simpson.net>
	 <20120927071011.GA8980@gmail.com>
	 <CA+55aFyxjdir-LZneBTk1JQV0cVSRFzEK9Jpxje2SJqA6aP3Yg@mail.gmail.com>
	 <20120927180507.GD8527@x1.osrc.amd.com>
	 <CA+55aFyTrcmx3Uf7UGU=-K=BwTym8aN15fTo==cV2bCK6so0Fg@mail.gmail.com>
	 <1348770584.3292.44.camel@twins>
	 <CA+55aFwnos6qFMi6R9uGxY2QtkUVm3hEc_Lgx1R0+AZt5V=SRA@mail.gmail.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-09-27 at 12:40 -0700, Linus Torvalds wrote:
> I wonder about this comment, for example:
> 
>          * By using 'se' instead of 'curr' we penalize light tasks, so
>          * they get preempted easier. That is, if 'se' < 'curr' then
>          * the resulting gran will be larger, therefore penalizing the
>          * lighter, if otoh 'se' > 'curr' then the resulting gran will
>          * be smaller, again penalizing the lighter task.
> 
> why would we want to preempt light tasks easier? It sounds backwards
> to me. If they are light, we have *less* reason to preempt them, since
> they are more likely to just go to sleep on their own, no?

No, weight is nice, you nicing a task doesn't make it want to run less.
So preempting them sooner means they disturb the heavier less, which is
I think what you want with nice.

> Another question is whether the fact that this same load interacts
> with select_idle_sibling() is perhaps a sign that maybe the preemption
> logic is all fine, but it interacts badly with the "pick new cpu"
> code. In particular, after having changed rq's, is the vruntime really
> comparable? IOW, maybe this is an interaction between "place_entity()"
> and then the immediately following (?) call to check wakeup
> preemption? 

No, the vruntime comparison between cpus is dubious, its not complete
nonsense but its not 'correct' either. PJT has patches to improve that
based on his per-entity tracking stuff.
