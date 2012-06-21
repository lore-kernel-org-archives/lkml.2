Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759844Ab2FUQhx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 12:37:53 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:46396 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759819Ab2FUQhw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 12:37:52 -0400
Date: Thu, 21 Jun 2012 18:37:42 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>, Tony Luck <tony.luck@intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Venkatesh Pallipadi <venki@google.com>
Subject: Re: [PATCH 0/4] cputime: Virtual cputime accounting small cleanups
 and consolidation
Message-ID: <20120621163738.GA8652@somewhere>
References: <1340113391-1896-1-git-send-email-fweisbec@gmail.com>
 <1340231192.21745.154.camel@twins>
 <CAFTL4hz9UZr0Xfd4m3WTBma8vSvbm0Lg8o=oXsjFbpPfG9RxjQ@mail.gmail.com>
 <20120621095806.36df58f2@de.ibm.com>
 <1340280264.18025.4.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1340280264.18025.4.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 21, 2012 at 02:04:24PM +0200, Peter Zijlstra wrote:
> On Thu, 2012-06-21 at 09:58 +0200, Martin Schwidefsky wrote:
> > On Thu, 21 Jun 2012 02:46:29 +0200
> > Frederic Weisbecker <fweisbec@gmail.com> wrote:
> > 
> > > 2012/6/21 Peter Zijlstra <peterz@infradead.org>:
> > > > On Tue, 2012-06-19 at 15:43 +0200, Frederic Weisbecker wrote:
> > > >>
> > > >> I wish we could do more vtime cputime accounting consolidation
> > > >> but archs do the things pretty differently although I bet the
> > > >> behaviour could be more unified.
> > > >>
> > > > Yes.. so s390,ia64 use thread_info, ppc uses their paca (arch private
> > > > precursor to per-cpu data).
> > 
> > s390 uses the prefix page / lowcore to accumulate some accounting information.
> > Which basically is per-cpu data with the advantage that it is accessible with
> > at address 0-8191 for each cpu. The entry code does not have to load a pointer
> > to get to that page, I would prefer NOT to use per-cpu data here.
> 
> Yeah, same for ppc and their paca, I just meant to put the data in
> per-cpu (your lowcore and ppc's paca qualify) storage instead of
> per-task.
> 
> But seeing as I completely overlooked the per-task accounting this
> doesn't matter anyway.
> 
> There being the per-task accounting also completely wrecks the proposal
> I outlined. That only works if its only per-cpu accounting.
> 
> The alternative is going full 64bit ns and having the tick fallback do
> TICK_NSEC increments. 32bit args that don't do VIRT_TIME or IRQ_TIME
> won't like that though :/
> 
> So yeah, I did miss something obvious.. no cookies for me.

Yeah but the idea of a dynamic switching between tick based accounting
and virtual based one (account_system_vtime()) is still valuable to me.

That of course only makes sense if the arch uses some kind of "on-demand"
virtual accounting. Like using TIF flags for syscall slow path and jump
labels for exception hooks. Although in the longer term we should rather
hook on the syscall fastpath, but you get the idea.

How does that sound?

Another way would be to make the adaptive tickless thing depend on
the traditional CONFIG_VIRT_CPU_TIME. So it's simply enabled all the
time and we don't care. But we need syscalls/exceptions hooks for RCU
anyway, which is why I think an on-demand thing could make sense because
both RCU and vtime could use these on-demand hooks.
