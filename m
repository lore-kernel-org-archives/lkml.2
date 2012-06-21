Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758123Ab2FUH6g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 03:58:36 -0400
Received: from e06smtp14.uk.ibm.com ([195.75.94.110]:54930 "EHLO
	e06smtp14.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753285Ab2FUH6e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 03:58:34 -0400
Date: Thu, 21 Jun 2012 09:58:06 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>, Tony Luck <tony.luck@intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Venkatesh Pallipadi <venki@google.com>
Subject: Re: [PATCH 0/4] cputime: Virtual cputime accounting small cleanups
 and consolidation
Message-ID: <20120621095806.36df58f2@de.ibm.com>
In-Reply-To: <CAFTL4hz9UZr0Xfd4m3WTBma8vSvbm0Lg8o=oXsjFbpPfG9RxjQ@mail.gmail.com>
References: <1340113391-1896-1-git-send-email-fweisbec@gmail.com>
	<1340231192.21745.154.camel@twins>
	<CAFTL4hz9UZr0Xfd4m3WTBma8vSvbm0Lg8o=oXsjFbpPfG9RxjQ@mail.gmail.com>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
x-cbid: 12062107-1948-0000-0000-0000022909E4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 21 Jun 2012 02:46:29 +0200
Frederic Weisbecker <fweisbec@gmail.com> wrote:

> 2012/6/21 Peter Zijlstra <peterz@infradead.org>:
> > On Tue, 2012-06-19 at 15:43 +0200, Frederic Weisbecker wrote:
> >>
> >> I wish we could do more vtime cputime accounting consolidation
> >> but archs do the things pretty differently although I bet the
> >> behaviour could be more unified.
> >>
> > Yes.. so s390,ia64 use thread_info, ppc uses their paca (arch private
> > precursor to per-cpu data).

s390 uses the prefix page / lowcore to accumulate some accounting information.
Which basically is per-cpu data with the advantage that it is accessible with
at address 0-8191 for each cpu. The entry code does not have to load a pointer
to get to that page, I would prefer NOT to use per-cpu data here.

> > So I understand why s390,ia64 want the sched hook, but I don't see why
> > ppc would need it, their account_process_tick() can fold whatever they
> > need on the tick.
> 
> I think in any case you need to flush the time on a descheduling task otherwise
> its pending time will be accounted later to the next task when it
> receives an irq.
> 
> So I fear we still need that sched switch hook even with per cpu data. This
> may be a simple account_system_vtime() call.

Indeed, the scheduler hook is needed to add the accumulated values to the
correct task. 
 
> > So I think reworking s390,ia64 to use per-cpu storage should get rid of
> > this switch hook altogether.

If we get rid of the switch hook then the quality of the accounting numbers
will get significantly worse. Think of the scenario of a long running
background process and a task that repeatedly wakes up for a very short
time. Without the scheduler hook chances are good that the background task
is accounted all the accumulated user time.

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

