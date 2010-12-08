Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757499Ab0LHBRF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 20:17:05 -0500
Received: from bld-mail20.adl6.internode.on.net ([150.101.137.105]:35685 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757474Ab0LHBRD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 20:17:03 -0500
Date: Wed, 8 Dec 2010 12:16:56 +1100
From: Dave Chinner <david@fromorbit.com>
To: Nick Piggin <npiggin@suse.de>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/46] Revert "fs: use RCU read side protection in
 d_validate"
Message-ID: <20101208011656.GD29333@dastard>
References: <cover.1290852958.git.npiggin@kernel.dk>
 <2d1d8ffc4acea8b6c4e5b58bb1653b3f0e7071e2.1290852958.git.npiggin@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2d1d8ffc4acea8b6c4e5b58bb1653b3f0e7071e2.1290852958.git.npiggin@kernel.dk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 27, 2010 at 08:56:03PM +1100, Nick Piggin wrote:
> This reverts commit 3825bdb7ed920845961f32f364454bee5f469abb.
> 
> Patch is broken, you can't dget() without holding any locks!

I believe you can - for the same reasons we can take a reference to
an inode without holding the inode_lock. That is, as long as the
caller already holds an active reference to the dentry,
dget() can be used to take another reference without needing the
dcache_lock.

Such usage appears to be described in the comment above dget() and
there's a BUG_ON() in dget() to catch callers that don't already
have an active reference. An example of a valid unlocked dget():
d_alloc() does an unlocked dget() to take a reference to the parent
dentry which we already are guaranteed to have a reference to.

As to d_validate() - it depends on the caller behaviour as to
whether the unlocked dget() is valid or not.  From a cursory check
of the NCP and SMB readdir caches, both appear to hold an active
reference to the dentry it is passing to d_validate(). If that is
the case then there is nothing wrong with the way d_validate uses
dget(). Can someone with more SMB/NCP expertise than me validate the
use of cached dentries?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
