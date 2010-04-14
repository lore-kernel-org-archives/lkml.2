Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755710Ab0DNOJH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 10:09:07 -0400
Received: from rcsinet12.oracle.com ([148.87.113.124]:24595 "EHLO
	rcsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755524Ab0DNOJE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 10:09:04 -0400
Date: Wed, 14 Apr 2010 10:07:19 -0400
From: Chris Mason <chris.mason@oracle.com>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Andi Kleen <andi@firstfloor.org>, Dave Chinner <david@fromorbit.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] mm: disallow direct reclaim page writeback
Message-ID: <20100414140719.GR13327@think>
Mail-Followup-To: Chris Mason <chris.mason@oracle.com>,
	Mel Gorman <mel@csn.ul.ie>, Andi Kleen <andi@firstfloor.org>,
	Dave Chinner <david@fromorbit.com>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, linux-fsdevel@vger.kernel.org
References: <1271117878-19274-1-git-send-email-david@fromorbit.com>
 <20100413095815.GU25756@csn.ul.ie>
 <20100413111902.GY2493@dastard>
 <20100413193428.GI25756@csn.ul.ie>
 <20100413202021.GZ13327@think>
 <877hoa9wlv.fsf@basil.nowhere.org>
 <20100414112015.GO13327@think>
 <20100414132349.GL25756@csn.ul.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100414132349.GL25756@csn.ul.ie>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090203.4BC5CC58.00D4:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 14, 2010 at 02:23:50PM +0100, Mel Gorman wrote:
> On Wed, Apr 14, 2010 at 07:20:15AM -0400, Chris Mason wrote:

[ nods ]

> 
> Bear in mind that the context of lumpy reclaim that the VM doesn't care
> about where the data is on the file or filesystem. It's only concerned
> about where the data is located in memory. There *may* be a correlation
> between location-of-data-in-file and location-of-data-in-memory but only
> if readahead was a factor and readahead happened to hit at a time the page
> allocator broke up a contiguous block of memory.
> 
> > I know Mel mentioned before he wasn't interested in waiting for helper
> > threads, but I don't see how we can work without it.
> > 
> 
> I'm not against the idea as such. It would have advantages in that the
> thread could reorder the IO for better seeks for example and lumpy
> reclaim is already potentially waiting a long time so another delay
> won't hurt. I would worry that it's just hiding the stack usage by
> moving it to another thread and that there would be communication cost
> between a direct reclaimer and this writeback thread. The main gain
> would be in hiding the "splicing" effect between subsystems that direct
> reclaim can have.

The big gain from the helper threads is that storage operates at a
roughly fixed iop rate.  This is true for ssd as well, it's just a much
higher rate.  So the threads can send down 4K ios and recover clean pages at
exactly the same rate it would sending down 64KB ios. 

I know that for lumpy purposes it might not be the best 64KB, but the
other side of it is that we have to write those pages eventually anyway.
We might as well write them when it is more or less free.

The per-bdi writeback threads are a pretty good base for changing the
ordering for writeback, it seems like a good place to integrate requests
from the VM about which files (and which offsets in those files) to
write back first.

-chris

