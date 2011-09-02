Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933135Ab1IBCuY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 22:50:24 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:45322 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933071Ab1IBCuX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 22:50:23 -0400
Date: Fri, 2 Sep 2011 11:50:16 +0900
From: Tejun Heo <tj@kernel.org>
To: Matt Helsley <matthltc@us.ibm.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Oleg Nesterov <oleg@redhat.com>,
        Paul Menage <paul@paulmenage.org>,
        containers@lists.linux-foundation.org,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH pm-freezer 1/4] cgroup_freezer: fix freezer->state
 setting bug in freezer_change_state()
Message-ID: <20110902025016.GI2752@htj.dyndns.org>
References: <20110831102100.GA2828@mtj.dyndns.org>
 <20110902004231.GF1919@count0.beaverton.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110902004231.GF1919@count0.beaverton.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Matt.

On Thu, Sep 01, 2011 at 05:42:31PM -0700, Matt Helsley wrote:
> >  	case CGROUP_FROZEN:
> > -		atomic_inc(&system_freezing_cnt);
> > -		retval = try_to_freeze_cgroup(cgroup, freezer);
> > +		if (freezer->state == CGROUP_THAWED) {
> > +			freezer->state = CGROUP_FREEZING;
> > +			atomic_inc(&system_freezing_cnt);
> > +			retval = try_to_freeze_cgroup(cgroup, freezer);
> 
> This still doesn't look quite right. If the cgroup is FREEZING it should
> also call try_to_freeze_cgroup(). I think this is what's needed:
> 
> 		if (freezer->state == CGROUP_THAWED)
> 			atomic_inc(&system_freezing_cnt);
> 		freezer->state = CGROUP_FREEZING;
> 		retval = try_to_freeze_cgroup(cgroup, freezer);

Does this make any difference?  Tasks can't migrate if the cgroups are
freezing and freezing state is inherited through forks.  But yeah
doing that for both THAWED and FROZEN might still be a good idea for
safety.

Thanks.

-- 
tejun
