Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753853Ab1EPVET (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 17:04:19 -0400
Received: from smtp-out.google.com ([74.125.121.67]:37308 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753840Ab1EPVDs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 17:03:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=nMHCAuM17VHACnntBw7bc+ASUj0V3wAeG6kvTYSVcggXgIQN+SYn+/StG06fVw4Yi1
         etybYt2oW6qmjOoyJ2dg==
Date: Mon, 16 May 2011 14:03:33 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrea Arcangeli <aarcange@redhat.com>
cc: Mel Gorman <mgorman@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        Colin King <colin.king@canonical.com>,
        Raghavendra D Prabhu <raghu.prabhu13@gmail.com>,
        Jan Kara <jack@suse.cz>, Chris Mason <chris.mason@oracle.com>,
        Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-ext4 <linux-ext4@vger.kernel.org>
Subject: Re: [PATCH 3/3] mm: slub: Default slub_max_order to 0
In-Reply-To: <20110512173628.GJ11579@random.random>
Message-ID: <alpine.DEB.2.00.1105161356140.4353@chino.kir.corp.google.com>
References: <1305127773-10570-1-git-send-email-mgorman@suse.de> <1305127773-10570-4-git-send-email-mgorman@suse.de> <alpine.DEB.2.00.1105111314310.9346@chino.kir.corp.google.com> <20110512173628.GJ11579@random.random>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 May 2011, Andrea Arcangeli wrote:

> On Wed, May 11, 2011 at 01:38:47PM -0700, David Rientjes wrote:
> > kswapd and doing compaction for the higher order allocs before falling 
> 
> Note that patch 2 disabled compaction by clearing __GFP_WAIT.
> 
> What you describe here would be patch 2 without the ~__GFP_WAIT
> addition (so keeping only ~GFP_NOFAIL).
> 

It's out of context, my sentence was:

"With the previous changes in this patchset, specifically avoiding waking 
kswapd and doing compaction for the higher order allocs before falling 
back to the min order..."

meaning this patchset avoids waking kswapd and avoids doing compaction.

> Not clearing __GFP_WAIT when compaction is enabled is possible and
> shouldn't result in bad behavior (if compaction is not enabled with
> current SLUB it's hard to imagine how it could perform decently if
> there's fragmentation). You should try to benchmark to see if it's
> worth it on the large NUMA systems with heavy network traffic (for
> normal systems I doubt compaction is worth it but I'm not against
> trying to keep it enabled just in case).
> 

The fragmentation isn't the only issue with the netperf TCP_RR benchmark, 
the problem is that the slub slowpath is being used >95% of the time on 
every allocation and free for the very large number of kmalloc-256 and 
kmalloc-2K caches.  Those caches are order 1 and 3, respectively, on my 
system by default, but the page allocator seldomly gets invoked for such a 
benchmark after the partial lists are populated: the overhead is from the 
per-node locking required in the slowpath to traverse the partial lists.  
See the data I presented two years ago: http://lkml.org/lkml/2009/3/30/15.
