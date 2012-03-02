Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030633Ab2CBVZk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 16:25:40 -0500
Received: from casper.infradead.org ([85.118.1.10]:53755 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758147Ab2CBVZi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 16:25:38 -0500
Message-ID: <1330723529.11248.237.camel@twins>
Subject: Re: [PATCH] cpuset: mm: Remove memory barrier damage from the page
 allocator
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Mel Gorman <mgorman@suse.de>
Cc: Christoph Lameter <cl@linux.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Miao Xie <miaox@cn.fujitsu.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Date: Fri, 02 Mar 2012 22:25:29 +0100
In-Reply-To: <20120302174349.GB3481@suse.de>
References: <20120302112358.GA3481@suse.de>
	 <alpine.DEB.2.00.1203021018130.15125@router.home>
	 <20120302174349.GB3481@suse.de>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-03-02 at 17:43 +0000, Mel Gorman wrote:
> 
> I considered using a seqlock but it isn't cheap. The read side is heavy
> with the possibility that it starts spinning and incurs a read barrier
> (looking at read_seqbegin()) here. The retry block incurs another read
> barrier so basically it would not be no better than what is there currently
> (which at a 4% performance hit, sucks) 

Use seqcount.

Also, for the write side it doesn't really matter, changing mems_allowed
should be rare and is an 'expensive' operation anyway.

For the read side you can do:

again:
  seq = read_seqcount_begin(&current->mems_seq);

  page = do_your_allocator_muck();

  if (!page && read_seqcount_retry(&current->mems_seq, seq))
    goto again;

  oom();

That way, you only have one smp_rmb() in your fath path,
read_seqcount_begin() doesn't spin, and you only incur the second
smp_rmb() when you've completely failed to allocate anything.

smp_rmb() is basicaly free on x86, other archs will incur some overhead,
but you need a barrier as Christoph pointed out.
