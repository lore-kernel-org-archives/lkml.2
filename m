Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755292Ab0DALYD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 07:24:03 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:44579 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755122Ab0DALXy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 07:23:54 -0400
Date: Thu, 1 Apr 2010 05:23:52 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Jamie Lokier <jamie@shareable.org>
Cc: David Howells <dhowells@redhat.com>, Russell King <rmk@arm.linux.org.uk>,
       Yinghai Lu <yinghai@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Rabin Vincent <rabin@rab.in>,
       lkml <linux-kernel@vger.kernel.org>, hpa@zytor.com,
       penberg@cs.helsinki.fi, cl@linux-foundation.org,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       linux-arch@vger.kernel.org
Subject: Re: start_kernel(): bug: interrupts were enabled early
Message-ID: <20100401112352.GB20577@parisc-linux.org>
References: <20100331210555.GA17715@flint.arm.linux.org.uk> <20100325194100.GA2364@debian> <20100331134048.da4e35a7.akpm@linux-foundation.org> <4BB3B4DB.7040904@kernel.org> <19680.1270076318@redhat.com> <20100401094111.GB29433@shareable.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100401094111.GB29433@shareable.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 01, 2010 at 10:41:11AM +0100, Jamie Lokier wrote:
> David Howells wrote:
> > Russell King <rmk@arm.linux.org.uk> wrote:
> > > We use the standard generic kernel implementation.  Is x86 different? ;)
> > 
> > The optimised fast paths used on x86 rwsems don't disable interrupts.
> 
> Any reason not to use the same technique for all the archs - plus the
> trick used in arch/armkernel/entry-armv.S:__kuser_cmpxchg for those
> archs which don't have atomic instructions or ll/sc?

Assuming you're talking about the __LINUX_ARM_ARCH__ < 6 + CONFIG_MMU
case, then this only works for uniprocessor machines.

> If the problem here is _only_ semaphores, and the above might make
> semaphores faster anyway, perhaps it's a solution.

You trade off a bit of overhead in the semaphore path for a bit of
overhead in the interrupt path.  We probably take more sempahores than
we do interrupts, so it's probably worthwhile.  Still, cmpxchg() needs
to be SMP-safe.

Realistically, this isn't something that can be done in generic code.
It has to be done in arch-specific code.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
