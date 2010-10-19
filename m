Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757992Ab0JSA7P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 20:59:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42801 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755957Ab0JSA7O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 20:59:14 -0400
Subject: Re: ima: use of radix tree cache indexing == massive waste of
 memory?
From: Eric Paris <eparis@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Kyle McMartin <kyle@mcmartin.ca>, James Morris <jmorris@namei.org>,
        Christoph Hellwig <hch@infradead.org>, kernel@lists.fedoraproject.org,
        Mimi Zohar <zohar@us.ibm.com>, warthog9@kernel.org,
        Dave Chinner <david@fromorbit.com>, linux-kernel@vger.kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, Serge Hallyn <serue@us.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20101018181916.GB12372@elte.hu>
References: <20101016192027.GA6883@infradead.org>
	 <ebc4973c-6c11-4397-b8b0-c212a27abce4@email.android.com>
	 <20101017004945.GE1614@infradead.org> <20101017054008.GA16383@elte.hu>
	 <20101017184652.GB28060@infradead.org>
	 <alpine.LRH.2.00.1010181127480.9476@tundra.namei.org>
	 <20101018062530.GD8332@bombadil.infradead.org>
	 <1287420534.2530.67.camel@localhost.localdomain>
	 <AANLkTi=h6-qMtk9Kf0TRUfqjuBau+_FhKAMZOd_MZHrn@mail.gmail.com>
	 <1287425596.2530.70.camel@localhost.localdomain>
	 <20101018181916.GB12372@elte.hu>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 18 Oct 2010 20:58:10 -0400
Message-ID: <1287449890.2530.97.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-10-18 at 20:19 +0200, Ingo Molnar wrote:

> I think it would be fair to argue that #2 is the thing that should be fixed first 
> and foremost - before touching any data structure details.
> 
> Because if you fix #2 then all the other items will become no-op to 99.9% of the 
> people who are affected by this bug today.

Where I stand at the end of the day:

Executive summary for the TLDNR crowd:  Before upcoming patch series IMA
wasted 4,720k of memory on my test box when not configured to do
anything.  After patches IMA wastes 120k when not configured to do
anything.

------------------------

I'm considering a system with 5000 inodes in core and 1500 inodes which
IMA thinks should be measured (if it's on).  (which just so happens to
be close to the system I've been testing on shortly after reboot)

I'm going to consider 6 cases of memory usage and will post the patches
shortly after this mail.  My cases are going to be:

Linus - IMA Enabled
Linus - IMA Disabled
Allocate iint only when needed - IMA Enabled
Allocate iint only when needed - IMA Disabled
Allocate iint + RBTREE - IMA Enabled
allocate iint + RBTREE - IMA Disabled

In each case I consider 'disabled' to be 'compiled in but you didn't
tell it to do anything.'

So for Linus:
sizeof(iint) = 312
sizeof(radix) = 632
sizeof(inode delta) = 0  (how much I grew struct inode)

Given my scenario of a stock F14ish machine where 5000 inodes in core
and 1500 are IMA relevant when enabled we end up with:

Linus - Enabled			Linus - Disabled
------------------		----------------
iint_cache = 1,560k		iint_cache = 1,560k
radix = 3,160k			radix = 3,160k
inode d = 0			inode d = 0

total = 4,720k			total = 4,720k


For Allocate iint only when needed:
sizeof(iint) = 288
sizeof(radix) = 632
sizeof(inode delta) = 24 (24 bytes from iint move to struct inode)

Allocate iint - Enabled		Alloce iint - Disabled
-----------------------		----------------------
iint_cache = 342k		iint_cache = 0
radix = 948k			radix = 0
inode d = 120k			inode d  = 120k

total = 1,410k			total = 120k


For allocate iint only when needed and use rbtrees:
sizeof(iint) = 320
sizeof(radix) = 632 (but irrelevant)
sizeof(inode delta) = 24

Allocate + RBTREE - Enabled	Allocate iint + RBTREE - Disabled
---------------------------	---------------------------------
iint_cache = 480k		iint_cache = 0
radix = 0			radix = 0
inode d = 120k			inode d = 120k

total = 600k			total = 120k

Seems like about the best we can do.  This patch series attempts to
addresses all 3 of the problems I believe we identified (we still
serialize IMA relevant inodes but not the majority of them and none when
IMA is not enabled)

IMA will continue to waste 24 bytes per inode in core even when it isn't
doing anything useful just by compiling it in.  Future work to use a
freezer could get rid of this if the complexity is worth the tradeoff.
But I don't think it's worth it tonight.

-Eric

