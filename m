Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753374Ab1IXDV4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Sep 2011 23:21:56 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:63418 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753329Ab1IXDVy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Sep 2011 23:21:54 -0400
Date: Sat, 24 Sep 2011 12:21:47 +0900
From: Tejun Heo <htejun@gmail.com>
To: David Rientjes <rientjes@google.com>
Cc: Mike Galbraith <efault@gmx.de>, Li Zefan <lizf@cn.fujitsu.com>,
        LKML <linux-kernel@vger.kernel.org>, Paul Menage <paul@paulmenage.org>
Subject: Re: [patch] cpusets: allow PF_THREAD_BOUND kworkers to escape from a
 cpuset
Message-ID: <20110924032147.GB29319@htj.dyndns.org>
References: <1316758874.7393.2.camel@marge.simson.net>
 <4E7C2E7F.40307@cn.fujitsu.com>
 <1316762345.8168.4.camel@marge.simson.net>
 <alpine.DEB.2.00.1109230204270.29350@chino.kir.corp.google.com>
 <1316770936.6641.11.camel@marge.simson.net>
 <1316775204.7562.9.camel@marge.simson.net>
 <alpine.DEB.2.00.1109230619410.666@chino.kir.corp.google.com>
 <1316788392.6544.33.camel@marge.simson.net>
 <alpine.DEB.2.00.1109231304310.11347@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1109231304310.11347@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Sorry about the delay.  I'm mostly offline until the end of this
month.

On Fri, Sep 23, 2011 at 01:20:51PM -0700, David Rientjes wrote:
> > @@ -1382,9 +1383,10 @@ static int cpuset_can_attach(struct cgroup_subsys *ss, struct cgroup *cont,
> >  	 * set of allowed nodes is unnecessary.  Thus, cpusets are not
> >  	 * applicable for such threads.  This prevents checking for success of
> >  	 * set_cpus_allowed_ptr() on all attached tasks before cpus_allowed may
> > -	 * be changed.
> > +	 * be changed.  We also disallow attaching kthreadd, to prevent it's
> > +	 * child from becoming trapped should it then acquire PF_THREAD_BOUND.
> >  	 */
> > -	if (tsk->flags & PF_THREAD_BOUND)
> > +	if (tsk->flags & PF_THREAD_BOUND || tsk == kthreadd_task)
> >  		return -EINVAL;
> >  
> >  	return 0;
> 
> I like this much better, let's wait to hear from Tejun because he may 
> shead some light on whether PF_THREAD_BOUND is really necessary for 
> kworkers at all times.

Yes, PF_THREAD_BOUND is necessary.  The whole thing depends heavily on
per-cpu behavior.  In addition, I don't think it makes much sense to
put kworkers into a cpuset (or any other resource container) which
isn't global to the system.  If certain CPU intensive tasks require
scheduler based resource limitation, the RTTD would be creating a
dedicated worker thread for it and put restrictions on that specific
kthread.

Putting kthreadd into a sub cpuset and thus putting restrictions on
random kthreads seems like asking for trouble.  So, I agree with the
suggested approach.

Thank you.

-- 
tejun
