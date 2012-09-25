Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754296Ab2IYSmv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 14:42:51 -0400
Received: from mail.skyhub.de ([78.46.96.112]:42820 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753097Ab2IYSmt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 14:42:49 -0400
Date: Tue, 25 Sep 2012 20:42:45 +0200
From: Borislav Petkov <bp@alien8.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Mike Galbraith <efault@gmx.de>,
        Mel Gorman <mgorman@suse.de>, Nikolay Ulyanitsky <lystor@gmail.com>,
        linux-kernel@vger.kernel.org,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        Suresh Siddha <suresh.b.siddha@intel.com>
Subject: Re: 20% performance drop on PostgreSQL 9.2 from kernel 3.5.3 to
 3.6-rc5 on AMD chipsets - bisected
Message-ID: <20120925184245.GA13694@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	Mike Galbraith <efault@gmx.de>, Mel Gorman <mgorman@suse.de>,
	Nikolay Ulyanitsky <lystor@gmail.com>, linux-kernel@vger.kernel.org,
	Andreas Herrmann <andreas.herrmann3@amd.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@kernel.org>,
	Suresh Siddha <suresh.b.siddha@intel.com>
References: <1348505683.11847.111.camel@twins>
 <1348511193.6951.44.camel@marge.simpson.net>
 <CA+55aFxY7EPCxXqx_eKtVSOmjGKytUiAb2U-o5+=9O8nA-rYsA@mail.gmail.com>
 <20120924192056.GB4082@liondog.tnic>
 <1348538258.7100.23.camel@marge.simpson.net>
 <CA+55aFxw5yab4f=+KwB59RjRNXEhQZ==QEvQeLhEczKCTQK9wg@mail.gmail.com>
 <1348574286.3881.40.camel@twins>
 <20120925131736.GA30652@x1.osrc.amd.com>
 <20120925170058.GC30158@x1.osrc.amd.com>
 <CA+55aFzf=CApkYn+m5omwg+9-9i=11vj=7OMxKrCKb0qc-oBgg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CA+55aFzf=CApkYn+m5omwg+9-9i=11vj=7OMxKrCKb0qc-oBgg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 25, 2012 at 10:21:28AM -0700, Linus Torvalds wrote:
> On Tue, Sep 25, 2012 at 10:00 AM, Borislav Petkov <bp@alien8.de> wrote:
> >
> > 3.6-rc6+tip/auto-latest-kill select_idle_sibling()
> 
> Is this literally just removing it entirely?

Basically yes:

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 6b800a14b990..016ba387c7f2 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -2640,6 +2640,8 @@ static int select_idle_sibling(struct task_struct *p, int target)
        struct sched_group *sg;
        int i;
 
+       goto done;
+
        /*
         * If the task is going to be woken-up on this cpu and if it is
         * already idle, then it is the right target.

> Because apart from the latency spike at 4 procs (and the latency
> numbers look very noisy, so that's probably just noise), it looks
> clearly superior to everything else. On that benchmark, at least.

Yep, I need more results for a more reliable say here.

> How does pgbench look? That's the one that apparently really wants to
> spread out, possibly due to user-level spinlocks. So I assume it will
> show the reverse pattern, with "kill select_idle_sibling" being the
> worst case.

Let me run pgbench tomorrow (I had run it only on an older family 0x10
single-node box) on Bulldozer to check that out. And we haven't started
the multi-node measurements at all.

> Sad, because it really would be lovely to just remove that thing ;)

Right, so why did we need it all, in the first place? There has to be
some reason for it.

Thanks.

-- 
Regards/Gruss,
    Boris.
