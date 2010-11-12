Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933083Ab0KLXRO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 18:17:14 -0500
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:35168 "EHLO
	ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933009Ab0KLXRL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 18:17:11 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAENZ3Ux5LcEI/2dsb2JhbACiUHK+c4VKBA
Date: Sat, 13 Nov 2010 10:17:05 +1100
From: Nick Piggin <npiggin@kernel.dk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Nick Piggin <npiggin@kernel.dk>, Nick Piggin <npiggin@gmail.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Dave Chinner <dchinner@redhat.com>
Subject: Re: [patch 1/6] fs: icache RCU free inodes
Message-ID: <20101112231705.GB3317@amd>
References: <20101109124610.GB11477@amd>
 <AANLkTi=b3dEmoTgrJ2xMTUzgM-mUQNNx6J9jeLq2=mtf@mail.gmail.com>
 <1289319698.2774.16.camel@edumazet-laptop>
 <AANLkTimJCgsPqB9ihbScr1RdZ+XGk2tq7LZNfh109Skv@mail.gmail.com>
 <20101109220506.GE3246@amd>
 <AANLkTi=H5ZZ3b5F=Z-PM6FX84FJNzdSh4_HbeeU666ts@mail.gmail.com>
 <AANLkTimn623-N1R_Bn4sF4U6OX55TQZ2w7jGOq+kB5Pz@mail.gmail.com>
 <20101112060202.GB3332@amd>
 <20101112064911.GA3775@amd>
 <AANLkTimJ8hgM8ASCq7tb+1kFiY_sCamm8Xmyodrm0h6w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTimJ8hgM8ASCq7tb+1kFiY_sCamm8Xmyodrm0h6w@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 12, 2010 at 09:33:11AM -0800, Linus Torvalds wrote:
> On Thu, Nov 11, 2010 at 10:49 PM, Nick Piggin <npiggin@kernel.dk> wrote:
> >
> > In reality, it's likely to be well under 0.1% in any real workload, even
> > an inode intensive one. So I much prefer to err on the side of less
> > complexity, to start with. There just isn't much risk of regression
> > AFAIKS, and much more risk of becoming unmaintainable too complex.
> 
> Well, I have to say that if we don't get this lockless path lookup
> thing merged in the next merge window (ir 38-rc1), I'm going to be
> personally very disappointed (*).

I'm trying to piece things together. I'll hopefully be able to post
patches again soon for review.


> So yes, the "initial complexity" argument is certainly acceptable to
> me. It does make me suspect something is wrong, though, because quite
> frankly, the actual accesses to the inode during the lockless walk
> should be very _very_ controlled anyway. And it's trivial to do a "is
> this inode still the same one I started with" with zero locking, by
> just checking that "dentry->d_inode" is the same after-the-fact and
> checking that the dentry is still hashed. The inode type had better
> _NOT_ change if the dentry pointer is still there.
> 
> So even if the type or i_ops changes, none of that should matter in
> the least. Nobody should _care_. We might get two wildly different
> results, but we have a trivial way to check whether the inode was
> stable after-the-fact, and just punt if it wasn't. So it really smells
> like if this is an issue, there's something wrong going on.

Yes you are very right about that, it is actually possible to use
seqlocks and re-checking things to verify it after the fact. And
this is why I'm optimisic that we can tackle any and all regressions
that come up.

An example of where it can get more complicated:

A filesystem has an ->op function which gets the sb from inode->i_sb,
and then does the container_of thing, to get the filesystem specific
superblock so it can check flags to determine something (eg. whether
it is case sensitive or not).

If the inode goes away and i_sb can change, this can oops. We basically
just need to further tighten rules and further audit everyone. I'm not
saying it can't be done, I'm just saying it's not _totally_ trivail like
the usual DESTROY_BY_RCU pattern, so let's just see what incremental
patches look like.

I'm glad you agree at this point (and if it does turn out to be much
simpler than I anticipate, then hey that's great, we can just move to
DESTROY_BY_RCU even quicker).

Thanks,
Nick
