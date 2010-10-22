Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751837Ab0JVCl7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 22:41:59 -0400
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:42163 "EHLO
	ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751149Ab0JVCl6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 22:41:58 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAEOUwEx5Ldx0/2dsb2JhbAChXnK+P4VKBA
Date: Fri, 22 Oct 2010 13:41:52 +1100
From: Nick Piggin <npiggin@kernel.dk>
To: Nick Piggin <npiggin@kernel.dk>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, Dave Chinner <david@fromorbit.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Inode Lock Scalability V7 (was V6)
Message-ID: <20101022024152.GA6618@amd>
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
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 22, 2010 at 01:34:44PM +1100, Nick Piggin wrote:
> On Fri, Oct 22, 2010 at 03:20:10AM +0100, Al Viro wrote:
> > On Fri, Oct 22, 2010 at 11:45:40AM +1100, Nick Piggin wrote:
> > majority already checks for I_FREEING/I_WILL_FREE, refusing to pick such
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

Importantly, to be able to manipulate the icache state in any number of
steps, under a consistent lock. Exactly like we have with inode_lock
today.

Stepping away from that, adding code to handle new concurrencies, before
inode_lock is able to be lifted is just wrong.

The locking in my lock break patch is ugly and wrong, yes. But it is
always an intermediate step. I want to argue that with RCU inode work
*anyway*, there is not much point to reducing the strength of the
i_lock property because locking can be cleaned up nicely and still
keep i_lock ~= inode_lock (for a single inode).
