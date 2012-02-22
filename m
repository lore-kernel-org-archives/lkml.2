Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753823Ab2BVQjR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 11:39:17 -0500
Received: from mx1.redhat.com ([209.132.183.28]:38611 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751882Ab2BVQjO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 11:39:14 -0500
Date: Wed, 22 Feb 2012 11:38:58 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: Li Zefan <lizf@cn.fujitsu.com>, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Kay Sievers <kay.sievers@vrfy.org>,
        Lennart Poettering <lennart@poettering.net>,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
        Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFD] cgroup: about multiple hierarchies
Message-ID: <20120222163858.GB4128@redhat.com>
References: <20120221211938.GE12236@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120221211938.GE12236@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 21, 2012 at 01:19:38PM -0800, Tejun Heo wrote:

[..]
> 3. Head towards single hierarchy with the pie-in-the-sky goal of
>    merging things into process hierarchy in some distant future.
> 
>    The first step would be herding people to use a unified hierarchy
>    (ie. all subsystems mounted on a single cgroup tree) which is
>    controlled by single entity in userland (be it systemd or cgroupd,
>    cgroup-kit or whatever); however, even if we exclude supporting
>    orthogonal categorizations, there are good number of non-trivial
>    hurdles to clear before this can be realized.

Apart from orthogonal categorizations, one advantage of of multiple 
hierarchies is that you don't have to use a controller if you don't
want to. (Just don't create cgroup in controller's respective hierarchy).

This is not ideal but practically it might he helpful. In the sense
cgroups might not come cheap and different controllers might have different
overheads associated with it. For example, in blkio controller we can end
up idling a lot with increasing number of cgroups. In that case a better
way might be that use blkio controller cgroups selectively and that is
any workload which is destroying the performance of others, move it out
in a separate blkio group.

This is not ideal situation but that's how things currently are.

systemd by default creates in cgroups only cpu hierarchy (apart from named
systemd hiearchy to keep track of groups/processes). By default it does
not make use of other controllers and put any restrictions on
processes/services apart from cpu. Having a separate hiearchy for every
controller atleast easily allows that.

> 
>    Most importantly, we would need to clean up how nesting is handled
>    across different subsystems.  Handling internal and leaf nodes as
>    equals simply can't work.  Membership should be recursive, and for
>    subsystems which can't support proper nesting, the right thing to
>    do would be somehow ensuring that only single node in the path from
>    root to leaf is active for the controller.  We may even have to
>    introduce an alternative of operation to support this (yuck).
> 
>    This path would require the most amount of work and we would be
>    excluding a feature - support for multiple orthogonal
>    categorizations - which has been available till now, probably
>    through deprecation process spanning years; however, this at least
>    gives us hope that we may reach sanity in the end, how distant that
>    end may be.  Oh, hope. :)

Yes this is something needs to be cleaned up. Everybody seems to have
dealt with hiearchy in its own way.

For blkio controller, initially we provided fully nested hiearchies like
cpu controller but then implementation became too complex (CFQ is already
complicated and implementing fully nested hiearchies made it much more
complicated without any significant gain). So, I converted it into
flat model where internally we treat the whole hierarchy flat. (It
might have been a bad decision though).

So for blkio controller we can convert it into fully nested hierarchy
at the expense of more complex code in CFQ. I think memory cgroup
controller provides both flat and hierarchical mode. Keeping it fully
hierarchical also increases the cost as we need to traverse lot more
pointers for simple things like nested stats. On a system having
both systemd and libvirt, every virtual machine is already 3-4 level
deep in cgroup hierarchy.

Trying to make all the controllers uniform in terms of their treatment
of cgroup hiearchy sounds like a good thing to do. Once that is done,
one can probably see if it is worth to put all the controllers in a
single hierarchy.

Thanks
Vivek
