Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752875Ab0DAGuI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 02:50:08 -0400
Received: from gate.crashing.org ([63.228.1.57]:49824 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751862Ab0DAGuF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 02:50:05 -0400
Subject: Re: start_kernel(): bug: interrupts were enabled early
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Matthew Wilcox <matthew@wil.cx>, Yinghai Lu <yinghai@kernel.org>,
       Rabin Vincent <rabin@rab.in>, lkml <linux-kernel@vger.kernel.org>,
       penberg@cs.helsinki.fi, linux-arch@vger.kernel.org
In-Reply-To: <20100331233330.1a7357e4.akpm@linux-foundation.org>
References: <20100325194100.GA2364@debian>
	 <20100331134048.da4e35a7.akpm@linux-foundation.org>
	 <4BB3B4DB.7040904@kernel.org> <20100331210145.GB32165@parisc-linux.org>
	 <4BB3B8FC.1020608@zytor.com> <20100331211754.GC32165@parisc-linux.org>
	 <alpine.DEB.2.00.1003311640410.30456@router.home>
	 <20100331215411.GB17715@flint.arm.linux.org.uk>
	 <4BB3C540.9000405@zytor.com> <1270075071.7101.79.camel@pasglop>
	 <20100331154955.54176e5e.akpm@linux-foundation.org>
	 <1270084631.7101.81.camel@pasglop>
	 <20100331182654.d36c87ff.akpm@linux-foundation.org>
	 <4BB43CAC.3080102@zytor.com>
	 <20100331233330.1a7357e4.akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 01 Apr 2010 17:48:56 +1100
Message-ID: <1270104536.7101.114.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-03-31 at 23:33 -0400, Andrew Morton wrote:
> Just a few instructions, I guess.   But we can do it with zero.
> 
> And from a design POV, pretending that down_read()/down_write() can be
> called with interrupts disabled is daft - they cannot!  Why muck up
> the
> usual code paths with this startup-specific hack? 

Because we the problem of when interrupts are enabled for the first time
is a nasty one, and having entire layer of things not usable at the
right level of init because somewhere something might do an irq enable
due to calling generic code that down's a semaphore is a PITA.

Seriously, Andrew, I don't see a clean solution... Something -somewhere-
will have to be ugly.

Allocation is a pretty basic service that a lot of stuff expect
especially when booting.

We went through that discussion before when we moved the SLAB init
earlier during boot, because it makes no sense to have tons of code to
have to figure out what allocator to call depending on what phase of the
moon it's called from (especially when said code can also be called
later during boot, say for hotplug reasons).

So we moved sl*b init earlier, thus we ought to be able to also
kmem_cache_alloc() earlier. We -fixed- that problem already afaik.

Cheers,
Ben.


