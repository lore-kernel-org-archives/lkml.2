Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753396Ab0LHHAG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 02:00:06 -0500
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:50002 "EHLO
	ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750746Ab0LHHAE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 02:00:04 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAM+6/kx5Lclt/2dsb2JhbACjSnLAbIVJBJAL
Date: Wed, 8 Dec 2010 17:59:55 +1100
From: Nick Piggin <npiggin@kernel.dk>
To: Dave Chinner <david@fromorbit.com>
Cc: Nick Piggin <npiggin@kernel.dk>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 02/46] fs: d_validate fixes
Message-ID: <20101208065955.GA14846@amd>
References: <cover.1290852958.git.npiggin@kernel.dk>
 <0fff695735c9b652a3f63b8480686c64811e89d0.1290852958.git.npiggin@kernel.dk>
 <20101208015344.GE29333@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101208015344.GE29333@dastard>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 08, 2010 at 12:53:44PM +1100, Dave Chinner wrote:
> On Sat, Nov 27, 2010 at 08:44:32PM +1100, Nick Piggin wrote:
> > d_validate has been broken for a long time.
> > 
> > kmem_ptr_validate does not guarantee that a pointer can be dereferenced
> > if it can go away at any time. Even rcu_read_lock doesn't help, because
> > the pointer might be queued in RCU callbacks but not executed yet.
> > 
> > So the parent cannot be checked, nor the name hashed. The dentry pointer
> > can not be touched until it can be verified under lock. Hashing simply
> > cannot be used.
> > 
> > Instead, verify the parent/child relationship by traversing parent's
> > d_child list. It's slow, but only ncpfs and the destaged smbfs care
> > about it, at this point.
> 
> I'd drop the previous revert patch and just convert the RCU hash
> traversal straight to the d_child traversal code you introduce here.
> This is a much better explanation of why the d_validate mechanism
> needs to be changed, and the revert is really an unnecessary extra
> step...

Has to be backported, though. Patch that is to be reverted obviously
adds more brokenness and is a good example that you cannot dget() under
rcu read protection even if the rest of the surrounding function is
bugfree. I wouldn't have thought it's a big deal.



