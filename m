Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752951Ab0JVCUO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 22:20:14 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:52756 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751752Ab0JVCUM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 22:20:12 -0400
Date: Fri, 22 Oct 2010 03:20:10 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Nick Piggin <npiggin@kernel.dk>
Cc: Dave Chinner <david@fromorbit.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: Inode Lock Scalability V7 (was V6)
Message-ID: <20101022022010.GG19804@ZenIV.linux.org.uk>
References: <1287622186-1935-1-git-send-email-david@fromorbit.com>
 <20101021050422.GP32255@dastard>
 <20101021132034.GB13620@amd>
 <20101021235227.GI12506@dastard>
 <20101022004540.GA5920@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101022004540.GA5920@amd>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 22, 2010 at 11:45:40AM +1100, Nick Piggin wrote:

> No you didn't make these points to me over the past couple of weeks.
> Specifically, do you agree or disagree about these points:
> - introducing new concurrency situations from not having a single lock
>   for an inode's icache state is a negative?

I disagree.

> And I have kept saying I would welcome your idea to reduce i_lock width
> in a small incremental patch. I still haven't figured out quite what
> is so important that can't be achieved in simpler ways (like rcu, or
> using a seperate inode lock).

No, it's not a small incremental.  It's your locking order being wrong;
the natural one is
	[hash, wb, sb] > ->i_lock > [lru]
and that's one hell of a difference compared to what you are doing.

Look:
	* iput_final() should happen under ->i_lock
	* if it leaves the inode alive, that's it; we can put it on LRU list
since lru lock nests inside ->i_lock
	* if it decides to kill the inode, it sets I_FREEING or I_WILL_FREE
before dropping ->i_lock.  Once that's done, the inode is ours and nobody
will pick it through the lists.  We can release ->i_lock and then do what's
needed.  Safely.
	* accesses of ->i_state are under ->i_lock, including the switchover
from I_WILL_FREE to I_FREEING
	* walkers of the sb, wb and hash lists can grab ->i_lock at will;
it nests inside their locks.
	* prune_icache() grabs lru lock, then trylocks ->i_lock on the
first element.  If trylock fails, we just give inode another spin through
the list by moving it to the tail; if it doesn't, we are holding ->i_lock
and can proceed safely.

What you seem to miss is that there are very few places accessing inode through
the lists (i.e. via pointers that do not contribute to refcount) and absolute
majority already checks for I_FREEING/I_WILL_FREE, refusing to pick such
inodes.  It's not an accidental subtle property of the code, it's bloody
fundamental.

As I've said, I've no religious problems with trylocks; we *do* need them for
prune_icache() to get a sane locking scheme.  But the way you put ->i_lock on
the top of hierarchy is simply wrong.
