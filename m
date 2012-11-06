Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933343Ab2KFAsS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 19:48:18 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:56457 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932295Ab2KFAsP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 19:48:15 -0500
Date: Mon, 5 Nov 2012 16:48:13 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Glauber Costa <glommer@parallels.com>
Cc: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        <kamezawa.hiroyu@jp.fujitsu.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Tejun Heo <tj@kernel.org>, Michal Hocko <mhocko@suse.cz>,
        Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Pekka Enberg <penberg@cs.helsinki.fi>,
        Suleiman Souhlal <suleiman@google.com>
Subject: Re: [PATCH v6 25/29] memcg/sl[au]b: shrink dead caches
Message-Id: <20121105164813.2eba5ecb.akpm@linux-foundation.org>
In-Reply-To: <1351771665-11076-26-git-send-email-glommer@parallels.com>
References: <1351771665-11076-1-git-send-email-glommer@parallels.com>
	<1351771665-11076-26-git-send-email-glommer@parallels.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu,  1 Nov 2012 16:07:41 +0400
Glauber Costa <glommer@parallels.com> wrote:

> This means that when we destroy a memcg cache that happened to be empty,
> those caches may take a lot of time to go away: removing the memcg
> reference won't destroy them - because there are pending references, and
> the empty pages will stay there, until a shrinker is called upon for any
> reason.
> 
> In this patch, we will call kmem_cache_shrink for all dead caches that
> cannot be destroyed because of remaining pages. After shrinking, it is
> possible that it could be freed. If this is not the case, we'll schedule
> a lazy worker to keep trying.

This patch is really quite nasty.  We poll the cache once per minute
trying to shrink then free it?  a) it gives rise to concerns that there
will be scenarios where the system could suffer unlimited memory windup
but mainly b) it's just lame.

The kernel doesn't do this sort of thing.  The kernel tries to be
precise: in a situation like this we keep track of the number of
outstanding objects and when that falls to zero, we free their
container synchronously.  If those objects are normally left floating
around in an allocated but reclaimable state then we can address that
by synchronously freeing them if their container has been destroyed.

Or something like that.  If it's something else then fine, but not this.

What do we need to do to fix this?

