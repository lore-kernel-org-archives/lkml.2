Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753074Ab2FJWPg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2012 18:15:36 -0400
Received: from zene.cmpxchg.org ([85.214.230.12]:43933 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752494Ab2FJWPf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2012 18:15:35 -0400
Date: Mon, 11 Jun 2012 00:15:16 +0200
From: Johannes Weiner <hannes@cmpxchg.org>
To: Hugh Dickins <hughd@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Michal Hocko <mhocko@suse.cz>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH] memcg: fix use_hierarchy css_is_ancestor oops regression
Message-ID: <20120610221516.GJ1761@cmpxchg.org>
References: <alpine.LSU.2.00.1206101150230.4239@eggly.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.00.1206101150230.4239@eggly.anvils>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 10, 2012 at 11:54:47AM -0700, Hugh Dickins wrote:
> If use_hierarchy is set, reclaim testing soon oopses in css_is_ancestor()
> called from __mem_cgroup_same_or_subtree() called from page_referenced():
> when processes are exiting, it's easy for mm_match_cgroup() to pass along
> a NULL memcg coming from a NULL mm->owner.
> 
> Check for that in __mem_cgroup_same_or_subtree().  Return true or false?
> False because we cannot know if it was in the hierarchy, but also false
> because it's better not to count a reference from an exiting process.
> 
> Signed-off-by: Hugh Dickins <hughd@google.com>

Looks like an older version of the patch that introduced it slipped
into the tree, Konstantin noted this problem during review.  The final
version did

	match = memcg && __mem_cgroup_same_or_subtree(root, memcg);

in the caller because of it.

Do you think it would be cleaner this way, since this is also the
place where that memcg is looked up, and so the "can return NULL"
handling after mem_cgroup_from_task() would be in the same place?

But either way,

Acked-by: Johannes Weiner <hannes@cmpxchg.org>

Thanks, Hugh!
