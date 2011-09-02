Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754622Ab1IBSbq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Sep 2011 14:31:46 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:54550 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754127Ab1IBSbn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Sep 2011 14:31:43 -0400
Date: Fri, 2 Sep 2011 11:31:38 -0700
From: Matt Helsley <matthltc@us.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Matt Helsley <matthltc@us.ibm.com>, Tejun Heo <tj@kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Paul Menage <paul@paulmenage.org>,
        containers@lists.linux-foundation.org,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH pm-freezer 1/4] cgroup_freezer: fix freezer->state
 setting bug in freezer_change_state()
Message-ID: <20110902183138.GA27179@count0.beaverton.ibm.com>
References: <20110831102100.GA2828@mtj.dyndns.org>
 <20110902004231.GF1919@count0.beaverton.ibm.com>
 <20110902165839.GA7478@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110902165839.GA7478@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 02, 2011 at 06:58:39PM +0200, Oleg Nesterov wrote:
> On 09/01, Matt Helsley wrote:
> >
> > On Wed, Aug 31, 2011 at 12:21:07PM +0200, Tejun Heo wrote:
> > >  	case CGROUP_FROZEN:
> > > -		atomic_inc(&system_freezing_cnt);
> > > -		retval = try_to_freeze_cgroup(cgroup, freezer);
> > > +		if (freezer->state == CGROUP_THAWED) {
> > > +			freezer->state = CGROUP_FREEZING;
> > > +			atomic_inc(&system_freezing_cnt);
> > > +			retval = try_to_freeze_cgroup(cgroup, freezer);
> >
> > This still doesn't look quite right. If the cgroup is FREEZING it should
> > also call try_to_freeze_cgroup(). I think this is what's needed:
> >
> > 		if (freezer->state == CGROUP_THAWED)
> > 			atomic_inc(&system_freezing_cnt);
> > 		freezer->state = CGROUP_FREEZING;
> > 		retval = try_to_freeze_cgroup(cgroup, freezer);
> 
> This is what I mentioned before, to me this looks like a win.
> 
> Why do we need try_to_freeze_cgroup() in this case? "for safety"
> could actually mean "hide the bug" ;)

Well, I need to check Tejun's latest freezer bits to see if this is
still the case but it was possible to get to the FREEZING state and
not enter FROZEN before returning to userspace. So you could come back
into the state change function in the FREEZING state with FROZEN as
the goal state. Note that for the cgroup freezer the FREEZING state is
optional -- so skipping it is fine so long was we guarantee that by the
time we exit to userspace with a FROZEN state all the tasks in the cgroup
are actually frozen (in the refrigerator loop) or frozen enough (about to
enter the refrigerator loop without causing more IO -- e.g. stopped).

Cheers,
	-Matt
