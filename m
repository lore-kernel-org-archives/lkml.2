Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752566Ab0JVDHd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 23:07:33 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:34574 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750932Ab0JVDHb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 23:07:31 -0400
Date: Fri, 22 Oct 2010 04:07:28 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Nick Piggin <npiggin@kernel.dk>
Cc: Dave Chinner <david@fromorbit.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: Inode Lock Scalability V7 (was V6)
Message-ID: <20101022030728.GH19804@ZenIV.linux.org.uk>
References: <1287622186-1935-1-git-send-email-david@fromorbit.com>
 <20101021050422.GP32255@dastard>
 <20101021132034.GB13620@amd>
 <20101021235227.GI12506@dastard>
 <20101022004540.GA5920@amd>
 <20101022022010.GG19804@ZenIV.linux.org.uk>
 <20101022023444.GA6573@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101022023444.GA6573@amd>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 22, 2010 at 01:34:44PM +1100, Nick Piggin wrote:

> > 	* walkers of the sb, wb and hash lists can grab ->i_lock at will;
> > it nests inside their locks.
> 
> What about if it is going on or off multiple data structures while
> the inode is live, like inode_lock can protect today. Such as putting
> it on the hash and sb list.

Look at the code.  You are overengineering it.  We do *not* need a framework
for messing with these lists in arbitrary ways.  Where would we need to
do that to an inode we don't hold a reference to or had placed I_FREEING
on and would need i_lock held by caller?  Even assuming that we need to
keep [present in hash, present on sb list] in sync (which I seriously doubt),
we can bloody well grab both locks before i_lock.

> > inodes.  It's not an accidental subtle property of the code, it's bloody
> > fundamental.
> 
> I didn't miss that, and I agree that at the point of my initial lock
> break up, the locking is "wrong". Whether you correct it by changing
> the lock ordering or by using RCU to do lookups is something I want to
> debate further.
> 
> I think it is natural to be able to lock the inode and have it lock the
> icache state.

Code outside of fs/inode.c and fs/fs-writeback.c generally has no business
looking at the full icache state, period.
