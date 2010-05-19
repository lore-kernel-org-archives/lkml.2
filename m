Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756512Ab0ESCBq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 22:01:46 -0400
Received: from mga11.intel.com ([192.55.52.93]:16798 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754193Ab0ESCBp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 22:01:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,258,1272870000"; 
   d="scan'208";a="799726848"
Subject: Re: [RFC][PATCH v2 02/11] perf: core, add pmu register and lookup
 functions
From: Lin Ming <ming.m.lin@intel.com>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Corey Ashford <cjashfor@linux.vnet.ibm.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Paul Mundt <lethal@linux-sh.org>,
       "eranian@gmail.com" <eranian@gmail.com>,
       "Gary.Mohr@Bull.com" <Gary.Mohr@bull.com>,
       "arjan@linux.intel.com" <arjan@linux.intel.com>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Paul Mackerras <paulus@samba.org>,
       "David S. Miller" <davem@davemloft.net>,
       Russell King <rmk+kernel@arm.linux.org.uk>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Will Deacon <will.deacon@arm.com>, Maynard Johnson <mpjohn@us.ibm.com>,
       Carl Love <carll@us.ibm.com>, "greg@kroah.com" <greg@kroah.com>,
       Kay Sievers <kay.sievers@vrfy.org>, lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <20100518183858.GE5081@lenovo>
References: <1274233502.3036.80.camel@localhost>
	 <20100518183858.GE5081@lenovo>
Content-Type: text/plain
Date: Wed, 19 May 2010 10:00:55 +0800
Message-Id: <1274234455.3603.0.camel@minggr.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 (2.24.1-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-05-19 at 02:38 +0800, Cyrill Gorcunov wrote:
> On Wed, May 19, 2010 at 01:45:02AM +0000, Lin Ming wrote:
> ...
> > +int perf_event_register_pmu(struct pmu *pmu)
> > +{
> > +	struct pmu *tmp;
> > +	int ret = 1;
> > +
> > +	rcu_read_lock();
> > +	list_for_each_entry_rcu(tmp, &pmus, entry) {
> > +		if (tmp->id == pmu->id) {
> > +			ret = 0;
> > +			goto err;
> 
> Hi Ming, is it supposed to get out in locked state?
> I mean imbalanced rcu_read_lock somehow suspicicous ;)

Ah, yes, that's real bug.
I'll fix it.

Thanks for review.

> 
> > +		}
> > +	}
> > +	rcu_read_unlock();
> > +
> > +	spin_lock(&pmus_lock);
> > +	list_add_tail_rcu(&pmu->entry, &pmus);
> > +	spin_unlock(&pmus_lock);
> > +
> > +err:
> > +	return ret;
> > +}
> > +
> ...
> 
> 	-- Cyrill

