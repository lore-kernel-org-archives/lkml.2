Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753510Ab2FZUPS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 16:15:18 -0400
Received: from gir.skynet.ie ([193.1.99.77]:36594 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751960Ab2FZUPQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 16:15:16 -0400
Date: Tue, 26 Jun 2012 21:15:13 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: Andi Kleen <andi@firstfloor.org>
Cc: Rafael Aquini <aquini@redhat.com>, linux-mm@kvack.org,
        Rik van Riel <riel@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH 1/4] mm: introduce compaction and migration for virtio
 ballooned pages
Message-ID: <20120626201513.GJ8103@csn.ul.ie>
References: <cover.1340665087.git.aquini@redhat.com>
 <7f83427b3894af7969c67acc0f27ab5aa68b4279.1340665087.git.aquini@redhat.com>
 <20120626101729.GF8103@csn.ul.ie>
 <20120626165258.GY11413@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20120626165258.GY11413@one.firstfloor.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 26, 2012 at 06:52:58PM +0200, Andi Kleen wrote:
> > 
> > What shocked me actually is that VM_BUG_ON code is executed on
> > !CONFIG_DEBUG_VM builds and has been since 2.6.36 due to commit [4e60c86bd:
> > gcc-4.6: mm: fix unused but set warnings]. I thought the whole point of
> > VM_BUG_ON was to avoid expensive and usually unnecessary checks. Andi,
> > was this deliberate?
> 
> The idea was that the compiler optimizes it away anyways.
> 
> I'm not fully sure what putback_balloon_page does, but if it just tests
> a bit (without non variable test_bit) it should be ok.
> 

This was the definition before

#ifdef CONFIG_DEBUG_VM
#define VM_BUG_ON(cond) BUG_ON(cond)
#else
#define VM_BUG_ON(cond) do { } while (0)
#endif

and now it's

#ifdef CONFIG_DEBUG_VM
#define VM_BUG_ON(cond) BUG_ON(cond)
#else
#define VM_BUG_ON(cond) do { (void)(cond); } while (0)
#endif

How is the compiler meant to optimise away "cond" if it's a function
call?

In the old definition VM_BUG_ON did nothing and the intention was that the
"cond" should never had any side-effects. It was to be used for potentially
expensive tests to catch additional issues in DEBUG_VM kernels. My concern
is that after commit 4e60c86bd that the VM doing these additional checks
unnecesarily with a performance hit. In most cases the checks are small
but in others such as free_pages we are calling virt_addr_valid() which
is heavier.

What did I miss? If nothing, then I will revert this particular change
and Rafael will need to be sure his patch is not using VM_BUG_ON to call
a function with side-effects.

-- 
Mel Gorman
SUSE Labs
