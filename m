Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932178Ab1EQTft (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 15:35:49 -0400
Received: from smtp-out.google.com ([216.239.44.51]:54417 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932127Ab1EQTfr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 15:35:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=Y+zfRhCJeaKY7Kjjj8QrVXwTrLB8b3PNtvkNtnkgtyDkGRmTOHTuTg2ABoR2qhbFEM
         2poQ7aG2Lc4Nd+uUBUqg==
Date: Tue, 17 May 2011 12:35:32 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Christoph Lameter <cl@linux.com>
cc: Mel Gorman <mgorman@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        Colin King <colin.king@canonical.com>,
        Raghavendra D Prabhu <raghu.prabhu13@gmail.com>,
        Jan Kara <jack@suse.cz>, Chris Mason <chris.mason@oracle.com>,
        Pekka Enberg <penberg@kernel.org>, Rik van Riel <riel@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-ext4 <linux-ext4@vger.kernel.org>
Subject: Re: [PATCH 3/4] mm: slub: Do not take expensive steps for SLUBs
 speculative high-order allocations
In-Reply-To: <alpine.DEB.2.00.1105171251450.15604@router.home>
Message-ID: <alpine.DEB.2.00.1105171233150.5438@chino.kir.corp.google.com>
References: <1305295404-12129-1-git-send-email-mgorman@suse.de> <1305295404-12129-4-git-send-email-mgorman@suse.de> <alpine.DEB.2.00.1105161411440.4353@chino.kir.corp.google.com> <20110517084227.GI5279@suse.de> <alpine.DEB.2.00.1105170847550.11187@router.home>
 <20110517162256.GO5279@suse.de> <alpine.DEB.2.00.1105171251450.15604@router.home>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 May 2011, Christoph Lameter wrote:

> > In this particular patch, the success rate for high order allocations
> > would likely decrease in low memory conditions albeit the latency when
> > calling the page allocator will be lower and the disruption to the
> > system will be less (no copying or reclaim of pages). My expectation
> > would be that it's cheaper for SLUB to fall back than compact memory
> > or reclaim pages even if this means a slab page is smaller until more
> > memory is free. However, if the "goodness" criteria is high order
> > allocation success rate, the patch shouldn't be merged.
> 
> The criteria is certainly overall system performance and not a high order
> allocation rate.
> 

SLUB definitely depends on these higher order allocations being successful 
for performance, dropping back to the min order is a last resort as 
opposed to failing the kmalloc().  If it's the last resort, then it makes 
sense that we'd want to try both compaction and reclaim while we're 
already in the page allocator as we go down the slub slowpath.  Why not 
try just a little harder (compaction and/or reclaim) to alloc the cache's 
preferred order?
