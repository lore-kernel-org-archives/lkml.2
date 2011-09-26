Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752550Ab1IZS3G (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Sep 2011 14:29:06 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33913 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751456Ab1IZS3D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Sep 2011 14:29:03 -0400
Date: Mon, 26 Sep 2011 20:28:59 +0200
From: Michal Hocko <mhocko@suse.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: David Rientjes <rientjes@google.com>, Oleg Nesterov <oleg@redhat.com>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Tejun Heo <tj@kernel.org>, Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH 1/2] oom: do not live lock on frozen tasks
Message-ID: <20110926182859.GA22434@tiehlicka.suse.cz>
References: <20110825151818.GA4003@redhat.com>
 <alpine.DEB.2.00.1109260154510.1389@chino.kir.corp.google.com>
 <20110926091440.GE10156@tiehlicka.suse.cz>
 <201109261751.40688.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201109261751.40688.rjw@sisk.pl>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 26-09-11 17:51:40, Rafael J. Wysocki wrote:
> On Monday, September 26, 2011, Michal Hocko wrote:
[...]
> > From f935ed4558c2fb033ef5c14e02b28e12a615f80e Mon Sep 17 00:00:00 2001
> > From: Michal Hocko <mhocko@suse.cz>
> > Date: Fri, 16 Sep 2011 11:23:15 +0200
> > Subject: [PATCH] oom: do not live lock on frozen tasks
> > 
> > Konstantin Khlebnikov has reported (https://lkml.org/lkml/2011/8/23/45)
> > that OOM can end up in a live lock if select_bad_process picks up a frozen
> > task.
> > Unfortunately we cannot mark such processes as unkillable to ignore them
> > because we could panic the system even though there is a chance that
> > somebody could thaw the process so we can make a forward process (e.g. a
> > process from another cpuset or with a different nodemask).
> > 
> > Let's thaw an OOM selected frozen process right after we've sent fatal
> > signal from oom_kill_task.
> > Thawing is safe if the frozen task doesn't access any suspended device
> > (e.g. by ioctl) on the way out to the userspace where we handle the
> > signal and die. Note, we are not interested in the kernel threads because
> > they are not oom killable.
> > 
> > Accessing suspended devices by a userspace processes shouldn't be an
> > issue because devices are suspended only after userspace is already
> > frozen and oom is disabled at that time.
> > 
> > run_guest (drivers/lguest/core.c) calls try_to_freeze with an user
> > context but it seems it is able to cope with signals because it
> > explicitly checks for pending signals so we should be safe.
> > 
> > Other than that userspace accesses the fridge only from the
> > signal handling routines so we are able to handle SIGKILL without any
> > negative side effects.
> > 
> > Signed-off-by: Michal Hocko <mhocko@suse.cz>
> > Reported-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
> 
> Acked-by: Rafael J. Wysocki <rjw@sisk.pl>

Thanks.

-- 
Michal Hocko
SUSE Labs
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
