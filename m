Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751898Ab0JVCsj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 22:48:39 -0400
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:31935 "EHLO
	ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751149Ab0JVCsi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 22:48:38 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAMaXwEx5Ldx0/2dsb2JhbAChXnK+KoVKBA
Date: Fri, 22 Oct 2010 13:48:34 +1100
From: Nick Piggin <npiggin@kernel.dk>
To: Nick Piggin <npiggin@kernel.dk>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, Dave Chinner <david@fromorbit.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Inode Lock Scalability V7 (was V6)
Message-ID: <20101022024834.GA6708@amd>
References: <1287622186-1935-1-git-send-email-david@fromorbit.com>
 <20101021050422.GP32255@dastard>
 <20101021132034.GB13620@amd>
 <20101021235227.GI12506@dastard>
 <20101022004540.GA5920@amd>
 <20101022022010.GG19804@ZenIV.linux.org.uk>
 <20101022023444.GA6573@amd>
 <20101022024152.GA6618@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101022024152.GA6618@amd>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 22, 2010 at 01:41:52PM +1100, Nick Piggin wrote:
> The locking in my lock break patch is ugly and wrong, yes. But it is
> always an intermediate step. I want to argue that with RCU inode work
> *anyway*, there is not much point to reducing the strength of the
> i_lock property because locking can be cleaned up nicely and still
> keep i_lock ~= inode_lock (for a single inode).

The other thing is that with RCU, the idea of locking an object in
the data structure with a per object lock actually *is* much more
natural. It's hard to do it properly with just a big data structure
lock.

If I want to take a reference to an inode from a data structre, how
to do it with RCU?

rcu_read_lock()
list_for_each(inode) {
  spin_lock(&big_lock); /* oops, might as well not even use RCU then */
  if (!unhashed) {
    iget();
  }
}


