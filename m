Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030436Ab2CABSk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 20:18:40 -0500
Received: from mail-pz0-f52.google.com ([209.85.210.52]:44219 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030290Ab2CABSi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 20:18:38 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of hughd@google.com designates 10.68.195.99 as permitted sender) smtp.mail=hughd@google.com; dkim=pass header.i=hughd@google.com
Date: Wed, 29 Feb 2012 17:18:09 -0800 (PST)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Johannes Weiner <hannes@cmpxchg.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH next] memcg: fix deadlock by avoiding stat lock when
 anon
In-Reply-To: <20120229193517.GD1673@cmpxchg.org>
Message-ID: <alpine.LSU.2.00.1202291648340.11821@eggly.anvils>
References: <alpine.LSU.2.00.1202282121160.4875@eggly.anvils> <alpine.LSU.2.00.1202282125240.4875@eggly.anvils> <20120229193517.GD1673@cmpxchg.org>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 Feb 2012, Johannes Weiner wrote:
> 
> Saving the begin/end_update_page_stat() calls for the anon case where
> we know in advance we don't need them is one thing, but this also
> hides a dependencies that even eludes lockdep behind what looks like a
> minor optimization of the anon case.

Sounds like you'd appreciate a comment there: akpm has not put
this version in yet, so I'll send an updated version shortly.

> 
> Wouldn't this be more robust if we turned the ordering inside out in
> move_account instead?

I think we need more than the one user of this infrastructure before
that can be decided.

But I didn't actually consider that at all: perhaps prejudiced by the
way I had solved the race Konstantin pointed out in my patchset of 10
last week, by using the lruvec lock for move_lock_mem_cgroup too,
which fits with it being inside the page_cgroup lock.

Hmm, I notice move_lock_mem_cgroup is likewise spin_lock_irqsave:
if it needs to be (and I guess the idea is that it doesn't need to be
today, but for generality later on had better be), then it has to be
inside page_cgroup lock.

(If FILE_MAPPED were to be the only user of the infrastructure, I'd
actually prefer to remove the begin/end, and make move_account raise
the file page's mapcount temporarily, doing its own page_remove_rmap
after, to solve these races.  There's probably one or two VM_BUG_ONs
elsewhere that would need deleting to make that completely safe.
But I understand there may be more users to come - and mapcount
games might not fit your desire for robustness.)

Hugh
