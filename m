Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758194Ab2JaQiz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 12:38:55 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:59504 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758048Ab2JaQiw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 12:38:52 -0400
Date: Wed, 31 Oct 2012 09:38:48 -0700
From: Tejun Heo <tj@kernel.org>
To: Glauber Costa <glommer@parallels.com>
Cc: lizefan@huawei.com, hannes@cmpxchg.org, mhocko@suse.cz,
        bsingharora@gmail.com, kamezawa.hiroyu@jp.fujitsu.com,
        cgroups@vger.kernel.org, containers@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/8] cgroup: kill
 cgroup_subsys->__DEPRECATED_clear_css_refs
Message-ID: <20121031163848.GC2945@htj.dyndns.org>
References: <1351657365-25055-1-git-send-email-tj@kernel.org>
 <1351657365-25055-2-git-send-email-tj@kernel.org>
 <509125D9.8070100@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <509125D9.8070100@parallels.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Glauber.

On Wed, Oct 31, 2012 at 05:21:29PM +0400, Glauber Costa wrote:
> > +
> > +	local_irq_disable();
> > +
> > +	/* block new css_tryget() by deactivating refcnt */
> > +	for_each_subsys(cgrp->root, ss) {
> > +		struct cgroup_subsys_state *css = cgrp->subsys[ss->subsys_id];
> > +
> > +		WARN_ON(atomic_read(&css->refcnt) < 0);
> > +		atomic_add(CSS_DEACT_BIAS, &css->refcnt);
> >  	}
> > -	/* NO css_tryget() can success after here. */
> > +
> > +	/*
> > +	 * Set REMOVED.  All in-progress css_tryget() will be released.
> > +	 * Put all the base refs.  Each css holds an extra reference to the
> > +	 * cgroup's dentry and cgroup removal proceeds regardless of css
> > +	 * refs.  On the last put of each css, whenever that may be, the
> > +	 * extra dentry ref is put so that dentry destruction happens only
> > +	 * after all css's are released.
> > +	 */
> > +	for_each_subsys(cgrp->root, ss) {
> > +		struct cgroup_subsys_state *css = cgrp->subsys[ss->subsys_id];
> > +
> > +		set_bit(CSS_REMOVED, &css->flags);
> > +		css_put(css);
> > +	}
> > +
> > +	local_irq_enable();
> > +
> >  	finish_wait(&cgroup_rmdir_waitq, &wait);
> 
> It seems to me that the main reason for doing this in two passes was to
> derive a global "failed" state on the first pass. Now that we can't
> fail, why can't you just loop through the subsystems just once ?

Later in the series, pre_destroy() happens inbetween.  The first loop
marks the CSSes and cgrp dead, ->pre_destroy()s are called, and the
later loop will put the final ref.  I'll mention it in the commit
message.

Thanks.

-- 
tejun
