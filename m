Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757358Ab2HNS6Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 14:58:25 -0400
Received: from mail-we0-f202.google.com ([74.125.82.202]:54199 "EHLO
	mail-we0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757066Ab2HNS6X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 14:58:23 -0400
From: Greg Thelen <gthelen@google.com>
To: Glauber Costa <glommer@parallels.com>
Cc: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
        <cgroups@vger.kernel.org>, <devel@openvz.org>,
        Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christoph Lameter <cl@linux.com>, David Rientjes <rientjes@google.com>,
        Pekka Enberg <penberg@kernel.org>,
        Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [PATCH v2 06/11] memcg: kmem controller infrastructure
References: <1344517279-30646-1-git-send-email-glommer@parallels.com>
	<1344517279-30646-7-git-send-email-glommer@parallels.com>
	<50254475.4000201@jp.fujitsu.com> <5028BA9E.7000302@parallels.com>
Date: Tue, 14 Aug 2012 11:58:10 -0700
In-Reply-To: <5028BA9E.7000302@parallels.com> (Glauber Costa's message of
	"Mon, 13 Aug 2012 12:28:14 +0400")
Message-ID: <xr93ipcl9u7x.fsf@gthelen.mtv.corp.google.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 13 2012, Glauber Costa wrote:

>>> > +	WARN_ON(mem_cgroup_is_root(memcg));
>>> > +	size = (1 << order) << PAGE_SHIFT;
>>> > +	memcg_uncharge_kmem(memcg, size);
>>> > +	mem_cgroup_put(memcg);
>> Why do we need ref-counting here ? kmem res_counter cannot work as
>> reference ?
> This is of course the pair of the mem_cgroup_get() you commented on
> earlier. If we need one, we need the other. If we don't need one, we
> don't need the other =)
>
> The guarantee we're trying to give here is that the memcg structure will
> stay around while there are dangling charges to kmem, that we decided
> not to move (remember: moving it for the stack is simple, for the slab
> is very complicated and ill-defined, and I believe it is better to treat
> all kmem equally here)

By keeping memcg structures hanging around until the last referring kmem
page is uncharged do such zombie memcg each consume a css_id and thus
put pressure on the 64k css_id space?  I imagine in pathological cases
this would prevent creation of new cgroups until these zombies are
dereferenced.

Is there any way to see how much kmem such zombie memcg are consuming?
I think we could find these with
for_each_mem_cgroup_tree(root_mem_cgroup).  Basically, I'm wanting to
know where kernel memory has been allocated.  For live memcg, an admin
can cat memory.kmem.usage_in_bytes.  But for zombie memcg, I'm not sure
how to get this info.  It looks like the root_mem_cgroup
memory.kmem.usage_in_bytes is not hierarchically charged.
