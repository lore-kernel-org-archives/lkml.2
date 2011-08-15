Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751992Ab1HOKrE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 06:47:04 -0400
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:64445 "EHLO
	ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751633Ab1HOKrC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 06:47:02 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AgIDALb3SE55LbABgWdsb2JhbABAqAMVAQEWJiWBQAEBBScTHCMQCAMOCi4UJQMhE7xLDoY5BJtOiEs
Date: Mon, 15 Aug 2011 20:46:56 +1000
From: Dave Chinner <david@fromorbit.com>
To: Pekka Enberg <penberg@kernel.org>
Cc: Glauber Costa <glommer@parallels.com>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, containers@lists.linux-foundation.org,
        Pavel Emelyanov <xemul@parallels.com>,
        Al Viro <viro@zeniv.linux.org.uk>, Hugh Dickins <hughd@google.com>,
        Nick Piggin <npiggin@kernel.dk>,
        Andrea Arcangeli <aarcange@redhat.com>, Rik van Riel <riel@redhat.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        James Bottomley <JBottomley@parallels.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Christoph Lameter <cl@linux.com>, David Rientjes <rientjes@google.com>
Subject: Re: [PATCH v3 3/4] limit nr_dentries per superblock
Message-ID: <20110815104656.GG26978@dastard>
References: <1313334832-1150-1-git-send-email-glommer@parallels.com>
 <1313334832-1150-4-git-send-email-glommer@parallels.com>
 <CAOJsxLFYD9DkEU5R+9fZr-uaznteP8-BUC_Ti+FnNFqtbOCHSw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOJsxLFYD9DkEU5R+9fZr-uaznteP8-BUC_Ti+FnNFqtbOCHSw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 15, 2011 at 10:12:06AM +0300, Pekka Enberg wrote:
> On Sun, Aug 14, 2011 at 6:13 PM, Glauber Costa <glommer@parallels.com> wrote:
> > This patch lays the foundation for us to limit the dcache size.
> > Each super block can have only a maximum amount of dentries under its
> > sub-tree. Allocation fails if we we're over limit and the cache
> > can't be pruned to free up space for the newcomers.
.....
> We track the total number of objects in mm/slub.c when
> CONFIG_SLUB_DEBUG is enabled (look for n->total_objects in the code).
> Have you considered extending that for this purpose?

That's usage for the entire slab, though, and we don't have a dentry
slab per superblock so I don't think that helps us. And with slab
merging, I think that even if we did have a slab per superblock,
they'd end up in the same slab context anyway, right?

Ideally what we need is a slab, LRU and shrinkers all rolled into a
single infrastructure handle so we can simply set them up per
object, per context etc and not have to re-invent the wheel for
every single slab cache/LRU/shrinker setup we have in the kernel.

I've got a rough node-aware generic LRU/shrinker infrastructure
prototype that is generic enough for most of the existing slab
caches with shrinkers, but I haven't looked at what is needed to
integrate it with the slab cache code. That's mainly because I don't
like the idea of having to implement the same thing 3 times in 3
different ways and debug them all before anyone would consider it
for inclusion in the kernel.

Once I've sorted out the select_parent() use-the-LRU-for-disposal
abuse and have a patch set that survives a 'rm -rf *' operation,
maybe we can then talk about what is needed to integrate stuff into
the slab caches....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
