Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756558Ab1EQTZx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 15:25:53 -0400
Received: from smtp-out.google.com ([74.125.121.67]:35813 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756445Ab1EQTZv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 15:25:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=jCa4eRnKmfzGQaC6RsukOo9Di230MNaSRAllqBIZETBAIKjFcqMFIjbv1W7u5zaUgc
         H6SmV+nBnRijuUGlY9Jg==
Date: Tue, 17 May 2011 12:25:39 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Mel Gorman <mgorman@suse.de>
cc: Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
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
In-Reply-To: <20110517094845.GK5279@suse.de>
Message-ID: <alpine.DEB.2.00.1105171220400.5438@chino.kir.corp.google.com>
References: <1305127773-10570-1-git-send-email-mgorman@suse.de> <1305127773-10570-4-git-send-email-mgorman@suse.de> <alpine.DEB.2.00.1105111314310.9346@chino.kir.corp.google.com> <20110512173628.GJ11579@random.random> <alpine.DEB.2.00.1105161356140.4353@chino.kir.corp.google.com>
 <20110517094845.GK5279@suse.de>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 May 2011, Mel Gorman wrote:

> > The fragmentation isn't the only issue with the netperf TCP_RR benchmark, 
> > the problem is that the slub slowpath is being used >95% of the time on 
> > every allocation and free for the very large number of kmalloc-256 and 
> > kmalloc-2K caches. 
> 
> Ok, that makes sense as I'd full expect that benchmark to exhaust
> the per-cpu page (high order or otherwise) of slab objects routinely
> during default and I'd also expect the freeing on the other side to
> be releasing slabs frequently to the partial or empty lists.
> 

That's most of the problem, but it's compounded on this benchmark because 
the slab pulled from the partial list to replace the per-cpu page 
typically only has a very minimal number (2 or 3) of free objects, so it 
can only serve one allocation and then require the allocation slowpath to 
pull yet another slab from the partial list the next time around.  I had a 
patchset that addressed that, which I called "slab thrashing", by only 
pulling a slab from the partial list when it had a pre-defined proportion 
of available objects and otherwise skipping it, and that ended up helping 
the benchmark by 5-7%.  Smaller orders will make this worse, as well, 
since if there were only 2 or 3 free objects on an order-3 slab before, 
there's no chance that's going to be equivalent on an order-0 slab.
