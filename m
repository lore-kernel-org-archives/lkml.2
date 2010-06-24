Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755866Ab0FXPDt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jun 2010 11:03:49 -0400
Received: from cantor2.suse.de ([195.135.220.15]:58061 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755836Ab0FXPDr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jun 2010 11:03:47 -0400
Date: Fri, 25 Jun 2010 01:03:34 +1000
From: Nick Piggin <npiggin@suse.de>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       John Stultz <johnstul@us.ibm.com>, Frank Mayhar <fmayhar@google.com>
Subject: Re: [patch 16/52] fs: dcache RCU for multi-step operaitons
Message-ID: <20100624150334.GE10441@laptop>
References: <20100624030212.676457061@suse.de>
 <20100624030728.129875799@suse.de>
 <1277366290.1875.891.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1277366290.1875.891.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 24, 2010 at 09:58:10AM +0200, Peter Zijlstra wrote:
> On Thu, 2010-06-24 at 13:02 +1000, npiggin@suse.de wrote:
> > plain text document attachment (fs-dcache_lock-multi-step.patch)
> > The remaining usages for dcache_lock is to allow atomic, multi-step read-side
> > operations over the directory tree by excluding modifications to the tree.
> > Also, to walk in the leaf->root direction in the tree where we don't have
> > a natural d_lock ordering.
> > 
> > This could be accomplished by taking every d_lock, but this would mean a
> > huge number of locks and actually gets very tricky.
> > 
> > Solve this instead by using the rename seqlock for multi-step read-side
> > operations. Insert operations are not serialised. Delete operations are
> > tricky when walking up the directory our parent might have been deleted
> > when dropping locks so also need to check and retry for that.
> > 
> > XXX: hmm, we could of course just take the rename lock if there is any worry
> > about livelock. Most of these are slow paths.
> 
> 
> Ah, does this address John's issue? 

This is where John's issue is introduced. I actually again couldn't
see the problem (thought I saw a problem, then lost it!).

Got to think about it and test more... I couldn't reproduce the problem
mind you, but I was testing mainline wheras bug was seen on -rt.
