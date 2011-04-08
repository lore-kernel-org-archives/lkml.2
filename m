Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755495Ab1DHRBk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Apr 2011 13:01:40 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:37710 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752636Ab1DHRBj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Apr 2011 13:01:39 -0400
Subject: Re: [patch 02/15] sched: validate CFS quota hierarchies
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: bharata@linux.vnet.ibm.com
Cc: Paul Turner <pjt@google.com>, linux-kernel@vger.kernel.org,
        Dhaval Giani <dhaval.giani@gmail.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Pavel Emelyanov <xemul@openvz.org>
In-Reply-To: <20110324063126.GA2721@in.ibm.com>
References: <20110323030326.789836913@google.com>
	 <20110323030448.853861319@google.com>  <20110324063126.GA2721@in.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 08 Apr 2011 19:01:19 +0200
Message-ID: <1302282079.9086.158.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-03-24 at 12:01 +0530, Bharata B Rao wrote:
> On Tue, Mar 22, 2011 at 08:03:28PM -0700, Paul Turner wrote:
> > Add constraints validation for CFS bandwidth hierachies.
> > 
> > +static u64 normalize_cfs_quota(struct task_group *tg,
> > +		               struct cfs_schedulable_data *d)
> > +{
> > +	u64 quota, period;
> > +	struct load_weight lw;
> > +
> > +	if (tg == d->tg) {
> > +		period = d->period;
> > +		quota = d->quota;
> > +	} else {
> > +		period = tg_get_cfs_period(tg);
> > +		quota = tg_get_cfs_quota(tg);
> > +	}
> > +
> > +	if (quota == RUNTIME_INF)
> > +		return RUNTIME_INF;
> > +
> > +	lw.weight = period;
> > +	lw.inv_weight = 0;
> > +
> > +	return calc_delta_mine(quota, max_cfs_quota_period, &lw) - 1;
> 
> Time to rename calc_delta_mine to something more meaningful ?

Or not use it there at all:

 - I'm not sure why we have different periods per cgroup, given that we
don't have EDF like scheduling and there's a very limited set of useful
periods. Too small and overhead increases like mad, too large and we get
lots of priority inversion crap.

 - Its not a fast-path by any means, so a straight fwd division wouldn't
hurt anybody.


