Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758711Ab0EGV4E (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 17:56:04 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:54282 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756539Ab0EGV4A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 17:56:00 -0400
Subject: Re: [tip:perf/core] perf: Add group scheduling transactional APIs
From: Peter Zijlstra <peterz@infradead.org>
To: mingo@redhat.com, hpa@zytor.com, eranian@google.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, davem@davemloft.net, fweisbec@gmail.com,
       ming.m.lin@intel.com, tglx@linutronix.de, mingo@elte.hu
Cc: linux-tip-commits@vger.kernel.org
In-Reply-To: <tip-6bde9b6ce0127e2a56228a2071536d422be31336@git.kernel.org>
References: <1272002160.5707.60.camel@minggr.sh.intel.com>
	 <tip-6bde9b6ce0127e2a56228a2071536d422be31336@git.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 07 May 2010 23:55:55 +0200
Message-ID: <1273269355.1642.383.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-05-07 at 18:44 +0000, tip-bot for Lin Ming wrote:
> Commit-ID:  6bde9b6ce0127e2a56228a2071536d422be31336
> Gitweb:     http://git.kernel.org/tip/6bde9b6ce0127e2a56228a2071536d422be31336
> Author:     Lin Ming <ming.m.lin@intel.com>
> AuthorDate: Fri, 23 Apr 2010 13:56:00 +0800
> Committer:  Ingo Molnar <mingo@elte.hu>
> CommitDate: Fri, 7 May 2010 11:31:02 +0200
> 
> perf: Add group scheduling transactional APIs
> 
> Add group scheduling transactional APIs to struct pmu.
> These APIs will be implemented in arch code, based on Peter's idea as
> below.
> 
> > the idea behind hw_perf_group_sched_in() is to not perform
> > schedulability tests on each event in the group, but to add the group
> > as a whole and then perform one test.
> >
> > Of course, when that test fails, you'll have to roll-back the whole
> > group again.
> >
> > So start_txn (or a better name) would simply toggle a flag in the pmu
> > implementation that will make pmu::enable() not perform the
> > schedulablilty test.
> >
> > Then commit_txn() will perform the schedulability test (so note the
> > method has to have a !void return value.
> >
> > This will allow us to use the regular
> > kernel/perf_event.c::group_sched_in() and all the rollback code.
> > Currently each hw_perf_group_sched_in() implementation duplicates all
> > the rolllback code (with various bugs).
> 
> ->start_txn:
> Start group events scheduling transaction, set a flag to make
> pmu::enable() not perform the schedulability test, it will be performed
> at commit time.
> 
> ->commit_txn:
> Commit group events scheduling transaction, perform the group
> schedulability as a whole
> 
> ->cancel_txn:
> Stop group events scheduling transaction, clear the flag so
> pmu::enable() will perform the schedulability test.
> 
> Reviewed-by: Stephane Eranian <eranian@google.com>
> Reviewed-by: Frederic Weisbecker <fweisbec@gmail.com>
> Signed-off-by: Lin Ming <ming.m.lin@intel.com>
> Cc: David Miller <davem@davemloft.net>
> Cc: Paul Mackerras <paulus@samba.org>
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> LKML-Reference: <1272002160.5707.60.camel@minggr.sh.intel.com>
> Signed-off-by: Ingo Molnar <mingo@elte.hu> 


Paul, are you ok with the powerpc patch that goes with this:
  https://patchwork.kernel.org/patch/94620/

(I've got a slightly modified version because I did rename things back
to txn)

Dave already said he was OK with the sparc bits.

If you don't object, I'll push both patches to Ingo.

