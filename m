Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755831Ab0FXPAi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jun 2010 11:00:38 -0400
Received: from cantor2.suse.de ([195.135.220.15]:57971 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754503Ab0FXPAh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jun 2010 11:00:37 -0400
Date: Fri, 25 Jun 2010 01:00:23 +1000
From: Nick Piggin <npiggin@suse.de>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       John Stultz <johnstul@us.ibm.com>, Frank Mayhar <fmayhar@google.com>
Subject: Re: [patch 06/52] fs: scale files_lock
Message-ID: <20100624150023.GD10441@laptop>
References: <20100624030212.676457061@suse.de>
 <20100624030726.584973456@suse.de>
 <1277365937.1875.883.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1277365937.1875.883.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 24, 2010 at 09:52:17AM +0200, Peter Zijlstra wrote:
> On Thu, 2010-06-24 at 13:02 +1000, npiggin@suse.de wrote:
> > 
> > One difficulty with this approach is that a file can be removed from the list
> > by another CPU. We must track which per-cpu list the file is on.  Scalability
> > could suffer if files are frequently removed from different cpu's list.
> 
> 
> Is this really a lot less complex than what I did with my fine-grained
> locked list?

http://www.mail-archive.com/linux-kernel@vger.kernel.org/msg115071.html

Honestly the filevec code seemed overkill to me, and yes it was a bit
complex. The only reason to consider it AFAIKS would be if the space
overhead of the per-cpu structures, or the slowpath cost of the brlock
was unbearable.

filevecs probably dont perform as well in the fastpath. My patch doesn't
add any atomics. The cost of adding or removing a file from its list are
one atomic for the spinlock.

The cost of adding a file with filevecs is a spinlock to put it on the
vec, a spinlock to take it off the vec, a spinlock to put it on the
lock-list. 3 atomics. A heap more icache and branches.

Removing a file with filevecs is a spinlock to check the vec, and 1 or 2
spinlocks to take it off the list (common case).

Scalability will be improved, but it will hit the global list still
1/15th times (and there is even no lock batching on the list but I
assume that could be fixed). Compared with never for my patch (unless
there is a cross-CPU removal, in which case they both need to hit a
remote-CPU cacheline).

But before we even get to scalability, I think filevecs from complexity
and single threaded performance point already lose.

