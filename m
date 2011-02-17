Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756549Ab1BQOH7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 09:07:59 -0500
Received: from bender.cm4all.net ([87.106.27.49]:46127 "EHLO bender.cm4all.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756528Ab1BQOH5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 09:07:57 -0500
Date: Thu, 17 Feb 2011 15:09:25 +0100
From: Max Kellermann <mk@cm4all.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: menage@google.com, lizf@cn.fujitsu.com,
        containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] new cgroup controller "fork"
Message-ID: <20110217140925.GA4115@rabbit.intern.cm-ag>
References: <20110217133152.4043.94951.stgit@rabbit.intern.cm-ag>
 <20110217225010.7f79b412.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110217225010.7f79b412.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011/02/17 14:50, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> I wonder allowing to set the limit to Root cgroup may imply the system death.
> How about disabling to set value to Root cgroup ?

That is taken care of already:

> > +static int
> > +cgroup_fork_populate(struct cgroup_subsys *ss, struct cgroup *cgroup)
> > +{
> > +	if (cgroup->parent == NULL)
> > +		/* cannot limit the root cgroup */
> > +		return 0;

The attribute simply doesn't exist in the root cgroup.

Also watch the loop condition in cgroup_fork_pre_fork() closely, the
root cgroup isn't checked (even if you could find a way to configure
it):

> > +	t = cgroup_fork_current();
> > +	while (t->css.cgroup->parent != NULL && err == 0) {


> IIRC, fork()'s error code is EAGAIN or ENOMEM. The exisiting limit of
> rlimit() returns EAGAIN.
> 
> How about -EAGAIN here ? I think it's not good to add new error code for
> system calls.

EPERM seemed appropriate to me, because the administrator disallows
more than N forks.  If there are practical reasons for changing it to
EAGAIN or ENOMEM, I'm ok with that.  Thanks for the hint.

Max
