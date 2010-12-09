Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755283Ab0LIAug (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 19:50:36 -0500
Received: from bld-mail16.adl2.internode.on.net ([150.101.137.101]:44524 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750930Ab0LIAuf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 19:50:35 -0500
Date: Thu, 9 Dec 2010 11:50:29 +1100
From: Dave Chinner <david@fromorbit.com>
To: Nick Piggin <npiggin@kernel.dk>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 02/46] fs: d_validate fixes
Message-ID: <20101209005029.GC32766@dastard>
References: <cover.1290852958.git.npiggin@kernel.dk>
 <0fff695735c9b652a3f63b8480686c64811e89d0.1290852958.git.npiggin@kernel.dk>
 <20101208015344.GE29333@dastard>
 <20101208065955.GA14846@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20101208065955.GA14846@amd>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 08, 2010 at 05:59:55PM +1100, Nick Piggin wrote:
> On Wed, Dec 08, 2010 at 12:53:44PM +1100, Dave Chinner wrote:
> > On Sat, Nov 27, 2010 at 08:44:32PM +1100, Nick Piggin wrote:
> > > d_validate has been broken for a long time.
> > > 
> > > kmem_ptr_validate does not guarantee that a pointer can be dereferenced
> > > if it can go away at any time. Even rcu_read_lock doesn't help, because
> > > the pointer might be queued in RCU callbacks but not executed yet.
> > > 
> > > So the parent cannot be checked, nor the name hashed. The dentry pointer
> > > can not be touched until it can be verified under lock. Hashing simply
> > > cannot be used.
> > > 
> > > Instead, verify the parent/child relationship by traversing parent's
> > > d_child list. It's slow, but only ncpfs and the destaged smbfs care
> > > about it, at this point.
> > 
> > I'd drop the previous revert patch and just convert the RCU hash
> > traversal straight to the d_child traversal code you introduce here.
> > This is a much better explanation of why the d_validate mechanism
> > needs to be changed, and the revert is really an unnecessary extra
> > step...
> 
> Has to be backported, though.

Backported where? The d_validate() change only got included in .37-rc1.

> Patch that is to be reverted obviously
> adds more brokenness and is a good example that you cannot dget() under
> rcu read protection even if the rest of the surrounding function is
> bugfree. I wouldn't have thought it's a big deal.

Reverting something broken to something already broken just to fix
to the less broken version seems like an unnecessary step. Just
fix the brokenneѕs in a single patch - no need to indirect the real
fix through a revert. One less patch to worry about.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
