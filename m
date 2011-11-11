Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752984Ab1KKKjO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Nov 2011 05:39:14 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:50425 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751083Ab1KKKjN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Nov 2011 05:39:13 -0500
Date: Fri, 11 Nov 2011 02:39:10 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Mel Gorman <mgorman@suse.de>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Minchan Kim <minchan.kim@gmail.com>, Jan Kara <jack@suse.cz>,
        Andy Isaacson <adi@hexapodia.org>,
        Johannes Weiner <jweiner@redhat.com>,
        Andrea Arcangeli <aarcange@redhat.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH] mm: Do not stall in synchronous compaction for THP
 allocations
In-Reply-To: <20111111101414.GJ3083@suse.de>
Message-ID: <alpine.DEB.2.00.1111110224500.7419@chino.kir.corp.google.com>
References: <20111110100616.GD3083@suse.de> <20111110142202.GE3083@suse.de> <CAEwNFnCRCxrru5rBk7FpypqeL8nD=SY5W3-TaA7Ap5o4CgDSbg@mail.gmail.com> <20111110161331.GG3083@suse.de> <20111110151211.523fa185.akpm@linux-foundation.org>
 <alpine.DEB.2.00.1111101536330.2194@chino.kir.corp.google.com> <20111111101414.GJ3083@suse.de>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Nov 2011, Mel Gorman wrote:

> > Indeed.  It seems like the behavior would better be controlled with 
> > /sys/kernel/mm/transparent_hugepage/defrag which is set aside specifically 
> > to control defragmentation for transparent hugepages and for that 
> > synchronous compaction should certainly apply.
> 
> With khugepaged in place, it's adding a tunable that is unnecessary and
> will not be used. Even if such a tuneable was created, the default
> behaviour should be "do not stall".
> 

Not sure what you mean, the tunable already exists and defaults to always 
if THP is turned on.  I've been able to effectively control the behavior 
of synchronous compaction with it in combination with extfrag_threshold, 
i.e. always compact even if the fragmentation index is very small, for 
workloads that really really really want hugepages at fault when such a 
latency is permissable and then disable khugepaged entirely in the 
background for cpu bound tasks.

The history of this boolean is somewhat disturbing: it's introduced in 
77f1fe6b back on January 13 to be true after the first attempt at 
compaction, then changed to be !(gfp_mask & __GFP_NO_KSWAPD) in 11bc82d6 
on March 22, then changed to be true again in c6a140bf on May 24, then 
proposed to be changed right back to !(gfp_mask & __GFP_NO_KSWAPD) in this 
patch again.  When are we going to understand that the admin needs to tell 
the kernel when we'd really like to try to allocate a transparent hugepage 
and when it's ok to fail?
