Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754042Ab0HYUns (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Aug 2010 16:43:48 -0400
Received: from smtp-out.google.com ([74.125.121.35]:42357 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753255Ab0HYUnl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Aug 2010 16:43:41 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=SYudKBrDFT9W+nvGMP8i1jVM9dVIIkkMNZYzcVQqKC5WjZDxmVsWvGuLo+lq7l35r
	y47eXIqseO3ouVPtJFmXg==
Date: Wed, 25 Aug 2010 13:43:34 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Peter Zijlstra <peterz@infradead.org>
cc: Theodore Tso <tytso@mit.edu>, Jens Axboe <jaxboe@fusionio.com>,
        Andrew Morton <akpm@linux-foundation.org>, Neil Brown <neilb@suse.de>,
        Alasdair G Kergon <agk@redhat.com>,
        Chris Mason <chris.mason@oracle.com>,
        Steven Whitehouse <swhiteho@redhat.com>, Jan Kara <jack@suse.cz>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        "cluster-devel@redhat.com" <cluster-devel@redhat.com>,
        "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
        "reiserfs-devel@vger.kernel.org" <reiserfs-devel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [patch 1/5] mm: add nofail variants of kmalloc kcalloc and
 kzalloc
In-Reply-To: <1282743090.2605.3696.camel@laptop>
Message-ID: <alpine.DEB.2.00.1008251340420.16484@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.1008240340010.18908@chino.kir.corp.google.com> <1282656558.2605.2742.camel@laptop> <4C73CA24.3060707@fusionio.com> <alpine.DEB.2.00.1008241309170.21242@chino.kir.corp.google.com> <20100825112433.GB4453@thunk.org>
 <1282736132.2605.3563.camel@laptop> <20100825115709.GD4453@thunk.org>  <1282740516.2605.3644.camel@laptop> <1282740778.2605.3652.camel@laptop> <E25A6DCB-3188-4CF9-9DC4-631192B2F0E2@mit.edu> <1282743090.2605.3696.camel@laptop>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Aug 2010, Peter Zijlstra wrote:

> I'm not sure, but I think the cgroup thing doesn't account kernel
> allocations, in which case the above problem doesn't exist.
> 

Right, the only cgroup that does is cpusets because it binds the memory 
allocations to a set of nodes.

> For the cpuset case we punch through the cpuset constraints for kernel
> allocations (unless __GFP_HARDWALL).
> 

__GFP_HARDWALL doesn't mean that the allocation won't be constrained, this 
is a common misconception.  __GFP_HARDWALL only prevents us from looking 
at our cpuset.mem_exclusive flag and checking our nearest common ancestor 
cpuset if we can block.

The cpusets case is actually the easiest to fix: use GFP_ATOMIC.  
GFP_ATOMIC allocations aren't bound by any cpuset and, in the general 
case, can allocate below the min watermark because of 
ALLOC_HARD | ALLOC_HARDER in the page allocator which creates the notion 
of "memory reserves" available to these tasks.  Then, success really 
depends on the setting of the watermarks instead.
