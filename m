Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754233Ab0HYU6r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Aug 2010 16:58:47 -0400
Received: from smtp-out.google.com ([74.125.121.35]:49521 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754099Ab0HYU6o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Aug 2010 16:58:44 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=rGFOlzadVdFLjfRNw915P6TwujM04s2GfpjnidRKBs3brMvPpCJcZmTReIbp26z5B
	32c9FOpMa6gEO+toLtbeQ==
Date: Wed, 25 Aug 2010 13:58:37 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Peter Zijlstra <peterz@infradead.org>
cc: Dave Chinner <david@fromorbit.com>, "Ted Ts'o" <tytso@mit.edu>,
        Jens Axboe <jaxboe@fusionio.com>,
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
In-Reply-To: <1282743342.2605.3707.camel@laptop>
Message-ID: <alpine.DEB.2.00.1008251347550.16484@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.1008240340010.18908@chino.kir.corp.google.com> <1282656558.2605.2742.camel@laptop> <4C73CA24.3060707@fusionio.com> <alpine.DEB.2.00.1008241309170.21242@chino.kir.corp.google.com> <20100825112433.GB4453@thunk.org>
 <1282736132.2605.3563.camel@laptop> <20100825115709.GD4453@thunk.org> <1282740516.2605.3644.camel@laptop> <20100825132417.GQ31488@dastard> <1282743342.2605.3707.camel@laptop>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Aug 2010, Peter Zijlstra wrote:

> While I appreciate that it might be somewhat (a lot) harder for a
> filesystem to provide that guarantee, I'd be deeply worried about your
> claim that its impossible.
> 
> It would render a system without swap very prone to deadlocks. Even with
> the very tight dirty page accounting we currently have you can fill all
> your memory with anonymous pages, at which point there's nothing free
> and you require writeout of dirty pages to succeed.
> 

While I'd really love for callers to be able to gracefully handle getting 
a NULL back from the page allocator in all cases, it's not a prerequisite 
for this patchset.  This patchset actually does nothing interesting except 
removing the __GFP_NOFAIL bit from their gfp mask.  All of these 
allocations already loop looking for memory because they have orders that 
are less than PAGE_ALLOC_COSTLY_ORDER (which defaults to 3).  So the loops 
in kzalloc_nofail(), etc., never actually loop.

Demanding that the page allocator return order-3 memory in any context is 
a non-starter, so I'm not really interested in that.  I'm more concerned 
about proper error handling being implemented for these callers iff 
someone redefines PAGE_ALLOC_COSTLY_ORDER to something else, perhaps even 
0.

Callers can, when desperate for memory, use GFP_ATOMIC to use some memory 
reserves across zones, hopefully order-0 and not an egregious amount.  But 
the remainder of the burden really is back on the caller when this is 
depleted or it needs higher order allocs to be fixed in a way that doesn't 
rely on memory that doesn't exist.  That's an implementation choice by the 
caller and I agree that some failsafe behavior is the only way that we 
don't get really bad results like corrupted user data or filesystems.
