Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756251Ab2BWTlg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 14:41:36 -0500
Received: from mx1.redhat.com ([209.132.183.28]:59349 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752177Ab2BWTlf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 14:41:35 -0500
Date: Thu, 23 Feb 2012 14:41:10 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: Li Zefan <lizf@cn.fujitsu.com>, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Kay Sievers <kay.sievers@vrfy.org>,
        Lennart Poettering <lennart@poettering.net>,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
        Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFD] cgroup: about multiple hierarchies
Message-ID: <20120223194109.GI19691@redhat.com>
References: <20120221211938.GE12236@google.com>
 <20120222163858.GB4128@redhat.com>
 <20120222183351.GD32694@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120222183351.GD32694@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 22, 2012 at 10:33:51AM -0800, Tejun Heo wrote:

[..]
> 
> > So for blkio controller we can convert it into fully nested hierarchy
> > at the expense of more complex code in CFQ. I think memory cgroup
> > controller provides both flat and hierarchical mode. Keeping it fully
> > hierarchical also increases the cost as we need to traverse lot more
> > pointers for simple things like nested stats. On a system having
> > both systemd and libvirt, every virtual machine is already 3-4 level
> > deep in cgroup hierarchy.
> 
> I don't think every controller should implement full nesting and
> sharing the same hierarchy doesn't require it.  ie. if a controller
> only wants to support flat hierarchy, just allow a single subgroup to
> be active on any path between root and leaf.  We can add a flag or
> helpers to support such mode of operation and controllers themselves
> can treat all cgroups equally.

I am not sure I understand "allow a single subgroup to be active on any
path"

So if a hierarchy looks as follows.

				root
			        / | \
			      g1  g2 g3
			          |   |	
				  g4  g5

So you are saying that just either g2 or g4 to be active in path 2 and 
similiarly allow g3 or g5 to be active. IOW, if a task is in g5 and g3
is active group, and effectively task will be considered in g3? So in
above diagram if g1 and g4 and g3 are active groups, controller will
see them as.

				root
				/ | \
			       g1 g4 g3

Did I understand it right or you meant something else. But this is still
not flat and has 2 level of hierarchy. Tasks in root group and tasks in 
children group (g1, g2 and g3) are different levels hence controller needs
to implement hierarchy. For it to be truly flat, it needs to look like
this.
			     pivot_point
				/ | \  \
			       g1 g4 g3 root

Now the notion that only one group is active in each path from root to
leaf does not mean much.

Considering everything internally as flat, isn't it simpler. So cgroup 
tree still might look hierarchical but actually controller treats it
as.
				root
		              / / | \ \
			    g1 g2 g3 g4 g5

Well, above is not exactly flat as has 2 level of hierarchy. That's blkio
controller views cgroup hierarhcy as follows, currently.

				pivot_point
		              / / | \   \  \ 
			    g1 g2 g3 g4 g5 root

Thanks
Vivek
