Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757376Ab0JSUkI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 16:40:08 -0400
Received: from smtp-out.google.com ([216.239.44.51]:37557 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753662Ab0JSUkG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 16:40:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=KG9oG0kS+0xKE9CDNTQ3kEZ709D1GtedG5W4RUXM0fWQJY6YudV/Q0sLuP/Br7YQ35
         V0HGFFjCYqVU9UAEQweg==
Date: Tue, 19 Oct 2010 13:39:55 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Christoph Lameter <cl@linux.com>
cc: Pekka Enberg <penberg@cs.helsinki.fi>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [UnifiedV4 00/16] The Unified slab allocator (V4)
In-Reply-To: <20101005185725.088808842@linux.com>
Message-ID: <alpine.DEB.2.00.1010191337370.20631@chino.kir.corp.google.com>
References: <20101005185725.088808842@linux.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 5 Oct 2010, Christoph Lameter wrote:

> V3->V4:
> - Lots of debugging
> - Performance optimizations (more would be good)...
> - Drop per slab locking in favor of per node locking for
>   partial lists (queuing implies freeing large amounts of objects
>   to per node lists of slab).
> - Implement object expiration via reclaim VM logic.
> 

I applied this set on top of Pekka's for-next tree reverted back to 
5d1f57e4 since it doesn't apply later then that.

Overall, the results are _much_ better than the vanilla slub allocator 
that I frequently saw ~20% regressions with the TCP_RR netperf benchmark 
on a couple of my machines with larger cpu counts.  However, there still 
is a significant performance degradation compared to slab.

When running this patchset on two (client and server running 
netperf-2.4.5) four 2.2GHz quad-core AMD processors with 64GB of memory,
here're the results:

	threads		SLAB		SLUB		diff
	16		207038		184389		-10.9%
	32		266105		234386		-11.9%
	48		287989		252733		-12.2%
	64		307572		277221		- 9.9%		
	80		309802		284199		- 8.3%
	96		302959		291743		- 3.7%
	112		307381		297459		- 3.2%
	128		314582		299340		- 4.8%
	144		331945		299648		- 9.7%
	160		321882		314192		- 2.4%
