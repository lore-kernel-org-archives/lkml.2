Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757380Ab2BHQt1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 11:49:27 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:52462 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754680Ab2BHQtZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 11:49:25 -0500
Date: Wed, 8 Feb 2012 08:49:20 -0800
From: Tejun Heo <tj@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Shaohua Li <shaohua.li@intel.com>, Jens Axboe <axboe@kernel.dk>,
        Vivek Goyal <vgoyal@redhat.com>, lkml <linux-kernel@vger.kernel.org>,
        Knut Petersen <Knut_Petersen@t-online.de>, mroos@linux.ee
Subject: Re: [PATCH] block: strip out locking optimization in
 put_io_context()
Message-ID: <20120208164920.GB19392@google.com>
References: <20120206215451.GD21292@google.com>
 <4F30C96F.1000905@kernel.dk>
 <20120207162253.GG21292@google.com>
 <4F315113.5010804@kernel.dk>
 <CA+55aFxcjE4FsUVoarc+8OTi4OkqtgBmHq500=qaCeTqqWnqoA@mail.gmail.com>
 <20120207164735.GH21292@google.com>
 <CANejiEXUZpPzyrTmD-P-MWD-XDmvDoB9UAjDbnrzTEiAw6nsgQ@mail.gmail.com>
 <CANejiEXqLxJ=mhDYA04g4ZHo3CiXctCUVnHu1--yp0GYgPxOKQ@mail.gmail.com>
 <20120208162925.GA19392@google.com>
 <CA+55aFy8ym1KSFv753wGrYn8qG5eK6YOy_nOCpYiqPjoLJwysg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+55aFy8ym1KSFv753wGrYn8qG5eK6YOy_nOCpYiqPjoLJwysg@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Linus.

On Wed, Feb 08, 2012 at 08:34:53AM -0800, Linus Torvalds wrote:
> On Wed, Feb 8, 2012 at 8:29 AM, Tejun Heo <tj@kernel.org> wrote:
> >
> > Can you please try the following one?  Thanks a lot!
> 
> If you can use it as a rwlock, why can't you do it with RCU?

The original locking scheme was using RCU which was very fragile and
broken on corner cases.  The locking restructuring was aimed to make
things simpler.  While the double locking isn't trivial, it's much
easier to grasp and get right than RCU.  We might have to revive RCU
if the regression can't be tackled otherwise and it probably is
possible to do it simpler.  Let's see.

> Usually rwlocks are a bad idea. They tend to be more expensive than
> spinlocks, and the extra parallelism is almost never noticeable
> (except as "more cacheline bounces") for something that is appropriate
> for a non-sleeping lock.
>
> There's a *very* few situations where rwlock is the right thing, but
> it really almost always is a horribly bad idea.

I'm still a bit lost on where the regression is coming from and
*suspecting* that queue_lock contention is making the reverse locking
behave much worse than expected, so I mostly wanted to take that out
and see what happens.  rwlock might increase locking overhead per try
but it avoids unlock/lock dancing.  I'll try to reproduce the
regression in a few days and do better analysis.

Thanks.

-- 
tejun
