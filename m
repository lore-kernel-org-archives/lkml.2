Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754789Ab2BVSd5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 13:33:57 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:51382 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751995Ab2BVSdz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 13:33:55 -0500
Date: Wed, 22 Feb 2012 10:33:51 -0800
From: Tejun Heo <tj@kernel.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Kay Sievers <kay.sievers@vrfy.org>,
        Lennart Poettering <lennart@poettering.net>,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
        Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFD] cgroup: about multiple hierarchies
Message-ID: <20120222183351.GD32694@google.com>
References: <20120221211938.GE12236@google.com>
 <20120222163858.GB4128@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120222163858.GB4128@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey, Vivek.

On Wed, Feb 22, 2012 at 11:38:58AM -0500, Vivek Goyal wrote:
> Apart from orthogonal categorizations, one advantage of of multiple 
> hierarchies is that you don't have to use a controller if you don't
> want to. (Just don't create cgroup in controller's respective hierarchy).
> 
> This is not ideal but practically it might he helpful. In the sense
> cgroups might not come cheap and different controllers might have different
> overheads associated with it. For example, in blkio controller we can end
> up idling a lot with increasing number of cgroups. In that case a better
> way might be that use blkio controller cgroups selectively and that is
> any workload which is destroying the performance of others, move it out
> in a separate blkio group.

It should of course be possible to apply selective grouping on
different cgroups.  It's like any other layers on top of pstree -
sessions, program groups or containers.  Just group subtrees as you
see fit for each subsystem (there gotta be some fancy CS word for this
thing).  As long as those grouped trees are from the same base tree,
we can represent it in a single tree, just like we can just annotate
sessions and program groups in pstree.

So, as long as you don't want something orthogonal from pstree, it
should be fine.

> So for blkio controller we can convert it into fully nested hierarchy
> at the expense of more complex code in CFQ. I think memory cgroup
> controller provides both flat and hierarchical mode. Keeping it fully
> hierarchical also increases the cost as we need to traverse lot more
> pointers for simple things like nested stats. On a system having
> both systemd and libvirt, every virtual machine is already 3-4 level
> deep in cgroup hierarchy.

I don't think every controller should implement full nesting and
sharing the same hierarchy doesn't require it.  ie. if a controller
only wants to support flat hierarchy, just allow a single subgroup to
be active on any path between root and leaf.  We can add a flag or
helpers to support such mode of operation and controllers themselves
can treat all cgroups equally.

Thanks.

-- 
tejun
