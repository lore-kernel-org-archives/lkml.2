Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755377Ab0KLReG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 12:34:06 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47829 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754877Ab0KLReF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 12:34:05 -0500
MIME-Version: 1.0
In-Reply-To: <20101112064911.GA3775@amd>
References: <20101109124610.GB11477@amd> <AANLkTi=b3dEmoTgrJ2xMTUzgM-mUQNNx6J9jeLq2=mtf@mail.gmail.com>
 <1289319698.2774.16.camel@edumazet-laptop> <AANLkTimJCgsPqB9ihbScr1RdZ+XGk2tq7LZNfh109Skv@mail.gmail.com>
 <20101109220506.GE3246@amd> <AANLkTi=H5ZZ3b5F=Z-PM6FX84FJNzdSh4_HbeeU666ts@mail.gmail.com>
 <AANLkTimn623-N1R_Bn4sF4U6OX55TQZ2w7jGOq+kB5Pz@mail.gmail.com>
 <20101112060202.GB3332@amd> <20101112064911.GA3775@amd>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 12 Nov 2010 09:33:11 -0800
Message-ID: <AANLkTimJ8hgM8ASCq7tb+1kFiY_sCamm8Xmyodrm0h6w@mail.gmail.com>
Subject: Re: [patch 1/6] fs: icache RCU free inodes
To: Nick Piggin <npiggin@kernel.dk>
Cc: Nick Piggin <npiggin@gmail.com>, Eric Dumazet <eric.dumazet@gmail.com>,
        Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Dave Chinner <dchinner@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 11, 2010 at 10:49 PM, Nick Piggin <npiggin@kernel.dk> wrote:
>
> In reality, it's likely to be well under 0.1% in any real workload, even
> an inode intensive one. So I much prefer to err on the side of less
> complexity, to start with. There just isn't much risk of regression
> AFAIKS, and much more risk of becoming unmaintainable too complex.

Well, I have to say that if we don't get this lockless path lookup
thing merged in the next merge window (ir 38-rc1), I'm going to be
personally very disappointed (*).

So yes, the "initial complexity" argument is certainly acceptable to
me. It does make me suspect something is wrong, though, because quite
frankly, the actual accesses to the inode during the lockless walk
should be very _very_ controlled anyway. And it's trivial to do a "is
this inode still the same one I started with" with zero locking, by
just checking that "dentry->d_inode" is the same after-the-fact and
checking that the dentry is still hashed. The inode type had better
_NOT_ change if the dentry pointer is still there.

So even if the type or i_ops changes, none of that should matter in
the least. Nobody should _care_. We might get two wildly different
results, but we have a trivial way to check whether the inode was
stable after-the-fact, and just punt if it wasn't. So it really smells
like if this is an issue, there's something wrong going on.

                       Linus

(*) To the point where if Al and Dave cannot end up agreeing on
something, I'll just instead end up making the executive decision to
screw the eternal nay-saying, and just merging your series. So just a
heads-up guys: healthy discussion is fine, but obstructionism will
_not_ work.
