Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756152Ab0FONGq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 09:06:46 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:59732 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752865Ab0FONGp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 09:06:45 -0400
Date: Tue, 15 Jun 2010 09:06:22 -0400
From: Kyle McMartin <kyle@mcmartin.ca>
To: tytso@mit.edu, Andrew Morton <akpm@linux-foundation.org>,
       Salman <sqazi@google.com>, mingo@elte.hu, linux-kernel@vger.kernel.org,
       peterz@infradead.org, tytso@google.com, torvalds@linux-foundation.org,
       walken@google.com, Chen Liqin <liqin.chen@sunplusct.com>,
       Lennox Wu <lennox.wu@gmail.com>
Subject: Re: [PATCH] Fix a race in pid generation that causes pids to be
	reused immediately.
Message-ID: <20100615130622.GQ20317@bombadil.infradead.org>
References: <AANLkTinlnb-HsDia4X2qgRjkTL_Z5CfVKYHRFwREoyIn@mail.gmail.com> <20100611224902.5039.60134.stgit@bumblebee1.mtv.corp.google.com> <20100614165851.6bdfe485.akpm@linux-foundation.org> <20100615005619.GI6666@thunk.org> <20100614185556.afdc5304.akpm@linux-foundation.org> <20100615125650.GL6666@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100615125650.GL6666@thunk.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 15, 2010 at 08:56:50AM -0400, tytso@mit.edu wrote:
> > I think you're probably right, as long as one sticks with 4-byte
> > scalars.  The cmpxchg-is-now-generic change snuck in under the radar
> > (mine, at least).
> 
> Hmmm, what about unsigned longs?  (Which might be 8 bytes on some
> architectures....)
> 

Longs are fine, since Linux only supports LP64 (and would need major work
to support anything else.)

The problem documented above is that on 32-bit, a 64-bit read is
non-atomic, so even if you use a hashed spinlock to protect a u64
variable on 32-bit, reads will be non-atomic, and so must take the same
lock in order to be safe. Hence, you need accessor functions.

This is what the generic atomic code does, perhaps we could add a new
API that gives us hooks to do proper hashed spinlocks on crap
architectures but falls back to simple assignment and real cmpxchg on
real platforms.

--Kyle

