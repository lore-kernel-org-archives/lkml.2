Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755237Ab2KIRWS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 12:22:18 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:47189 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755117Ab2KIRWQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 12:22:16 -0500
Date: Fri, 9 Nov 2012 09:22:11 -0800
From: Tejun Heo <tj@kernel.org>
To: Daniel Wagner <wagi@monom.org>
Cc: lizefan@huawei.com, mhocko@suse.cz, rjw@sisk.pl,
        containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        fweisbec@gmail.com, Glauber Costa <glommer@parallels.com>
Subject: Re: [PATCH 1/9 v3] cgroup: add cgroup_subsys->post_create()
Message-ID: <20121109172211.GB2711@htj.dyndns.org>
References: <1351931915-1701-1-git-send-email-tj@kernel.org>
 <1351931915-1701-2-git-send-email-tj@kernel.org>
 <20121108190715.GD9672@htj.dyndns.org>
 <509CE472.9040504@monom.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <509CE472.9040504@monom.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey, Daniel.

On Fri, Nov 09, 2012 at 12:09:38PM +0100, Daniel Wagner wrote:
> On 08.11.2012 20:07, Tejun Heo wrote:> Subject: cgroup: add
> cgroup_subsys->post_create()
> >
> > Currently, there's no way for a controller to find out whether a new
> > cgroup finished all ->create() allocatinos successfully and is
> > considered "live" by cgroup.
> 
> I'd like add hierarchy support to net_prio and the first thing to
> do is to get rid of get_prioidx(). It looks like it would be nice to

Ooh, I'm already working on it.  I *think* I should be able to post
the patches later today or early next week.

> be able to use use_id and post_create() for this but as I read the
> code this might not work because the netdev might access resources
> allocated between create() and post_create(). So my question is
> would it make sense to move
> 
> cgroup_create():
> 
> 		if (ss->use_id) {
> 			err = alloc_css_id(ss, parent, cgrp);
> 			if (err)
> 				goto err_destroy;
> 		}
> 
> part before create() or add some protection between create() and
> post_create() callback in net_prio. I have a patch but I see
> I could drop it completely if post_create() is there.

Glauber had about similar question about css_id and I need to think
more about it but currently I think I want to phase out css IDs.  It's
an id of the wrong thing (CSSes don't need IDs, cgroups do) and
unnecessarily duplicates its own hierarchy when the hierarchy of
cgroups already exists.  Once memcontrol moves away from walking using
css_ids, I *think* I'll try to kill it.

I'll add cgroup ID (no hierarchy funnies, just a single ida allocated
number) so that it can be used for cgroup indexing.  Glauber, that
should solve your problem too, right?

Thanks.

-- 
tejun
