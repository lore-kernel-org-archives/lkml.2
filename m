Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755914Ab0DWFzU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 01:55:20 -0400
Received: from mga09.intel.com ([134.134.136.24]:49747 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755859Ab0DWFzT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 01:55:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.52,260,1270450800"; 
   d="scan'208";a="615802050"
Subject: [RFC][PATCH v2 0/4] perf: remove __weak function
 hw_perf_group_sched_in()
From: Lin Ming <ming.m.lin@intel.com>
To: Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       "eranian@gmail.com" <eranian@gmail.com>,
       "Gary.Mohr@Bull.com" <Gary.Mohr@bull.com>,
       Corey Ashford <cjashfor@linux.vnet.ibm.com>,
       "arjan@linux.intel.com" <arjan@linux.intel.com>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Paul Mackerras <paulus@samba.org>,
       "David S. Miller" <davem@davemloft.net>
Cc: lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 23 Apr 2010 13:55:42 +0800
Message-Id: <1272002142.5707.59.camel@minggr.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 (2.24.1-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, all

>From the discussion of thread "[RFC] perf_events: support for uncore
a.k.a. nest units", in order to support multiple hw pmu, Peter suggested
the first thing that needs to be done is get rid of all the __weak
functions (with exception of perf_callchain*, since that really is arch
specific), includes

hw_perf_group_sched_in
hw_perf_event_init
hw_perf_disable
hw_perf_enable

Peter Zijlstra <peterz@infradead.org> wrote:
> One thing not on that list, which should happen first I guess, is to
> remove hw_perf_group_sched_in(). The idea is to add some sort of
> transactional API to the struct pmu, so that we can delay the
> schedulability check until commit time (and roll back when it fails).
>
> Something as simple as:
>
>  struct pmu {
>    void start_txn(struct pmu *);
>    void commit_txn(struct pmu *);
>
>    ,,,
>  };
>
> and then change group_sched_in() to use this instead of
> hw_perf_group_sched_in(), whose implementations mostly replicate
> group_sched_in() in various buggy ways anyway.
>

This patch series is to remove hw_perf_group_sched_in() first.

patch 1: core, add group scheduling transactional APIs
patch 2: x86, implement group scheduling transactional APIs
patch 3: powerpc, implement group scheduling transactional APIs
patch 4: sparc, implement group scheduling transactional APIs

I have tested these patches on x86, but for powerpc and sparc it's only
cross build tested.
It's very appreciated if anybody has powerpc or sparc can help to test. 

Thanks for any comment.

Changes log:

v2.
Change transaction flag(cpu_hw_events->group_flag) from u8 to unsigned
int. RISC architecture deals better with word sized variable than u8.
(Peter Zijlstra)

Rename callback names, *_txn -> *_group_trans for better readability.
Add a few comments to describe the callbacks. (Frederic Weisbecker)

v1.
remove __weak function hw_perf_group_sched_in() based on Peter's idea.

Thanks,
Lin Ming

