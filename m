Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752238Ab0JVErD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 00:47:03 -0400
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:58056 "EHLO
	ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751800Ab0JVErC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 00:47:02 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAOazwEx5Ldx0/2dsb2JhbAChX3K+HYVKBA
Date: Fri, 22 Oct 2010 15:46:57 +1100
From: Nick Piggin <npiggin@kernel.dk>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Nick Piggin <npiggin@kernel.dk>, Dave Chinner <david@fromorbit.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Inode Lock Scalability V7 (was V6)
Message-ID: <20101022044657.GA6899@amd>
References: <1287622186-1935-1-git-send-email-david@fromorbit.com>
 <20101021050422.GP32255@dastard>
 <20101021132034.GB13620@amd>
 <20101021235227.GI12506@dastard>
 <20101022004540.GA5920@amd>
 <20101022022010.GG19804@ZenIV.linux.org.uk>
 <20101022023444.GA6573@amd>
 <20101022030728.GH19804@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101022030728.GH19804@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 22, 2010 at 04:07:28AM +0100, Al Viro wrote:
> On Fri, Oct 22, 2010 at 01:34:44PM +1100, Nick Piggin wrote:
> 
> > > 	* walkers of the sb, wb and hash lists can grab ->i_lock at will;
> > > it nests inside their locks.
> > 
> > What about if it is going on or off multiple data structures while
> > the inode is live, like inode_lock can protect today. Such as putting
> > it on the hash and sb list.
> 
> Look at the code.  You are overengineering it.  We do *not* need a framework
> for messing with these lists in arbitrary ways.  Where would we need to
> do that to an inode we don't hold a reference to or had placed I_FREEING

Look, my point is that I believe it is an easier step to get from
inode_lock to i_lock, and then from there we can go wild.

What is your criteria for a particular lock ordering being "natural"
versus not? In almost all cases we have

[stuff with data structure] -> [stuff with inode]
and
[stuff with inode] -> [stuff with data structure]

So neither is inherently more natural, I think. So it comes down to
how the code fits together and works.

The difficulty with inode_lock breaking is not the data structures.
We know how to lock and modify them. The hardest part is verifying
that a particular inode has no new, unhandled concurrency introduced
to it (eg. the particular concurrency you pointed out in Dave's patch
just now). Agree?

So in that case, I think it is much more natural to be able to take
an inode and with i_lock, cover it from all icache state concurrency.
I object to it being called over engineering -- it's actually just a
big hammer on the inode, compared with fiddling with more complex
rules.


> on and would need i_lock held by caller?  Even assuming that we need to
> keep [present in hash, present on sb list] in sync (which I seriously doubt),
> we can bloody well grab both locks before i_lock.

I'm not saying there is. Most of the problems would be between a
particular inode state versus its membership on one of the lists.
However, with my patches, I *don't care* if there is an issue there
or not. It simply doesn't matter because it has the same protection
as inode_lock at that point.

If you want to micro optimise it, change lock orders around, and
open more concurrency, that is easily possible to do after my patches
lift inode_lock. If you do all the changes *before* inode_lock removal,
then it's not bisectable at all.

