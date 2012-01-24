Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754855Ab2AXA2x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 19:28:53 -0500
Received: from andromeda.dapyr.net ([206.212.254.10]:36871 "EHLO
	andromeda.dapyr.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751558Ab2AXA2w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 19:28:52 -0500
Date: Mon, 23 Jan 2012 20:28:28 -0400
From: Konrad Rzeszutek Wilk <konrad@darnok.org>
To: David Vrabel <dvrabel@cantab.net>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>, xen-devel@lists.xensource.com,
        David Vrabel <david.vrabel@citrix.com>, linux-kernel@vger.kernel.org
Subject: Re: [Xen-devel] [PATCH] x86: xen: size struct xen_spinlock to always fit in arch_spinlock_t
Message-ID: <20120124002828.GA18635@andromeda.dapyr.net>
References: <1327347145-16439-1-git-send-email-david.vrabel@citrix.com> <20120123195047.GA11002@phenom.dumpdata.com> <4F1DD4C1.2070704@cantab.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F1DD4C1.2070704@cantab.net>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 23, 2012 at 09:44:33PM +0000, David Vrabel wrote:
> On 23/01/2012 19:50, Konrad Rzeszutek Wilk wrote:
> >On Mon, Jan 23, 2012 at 07:32:25PM +0000, David Vrabel wrote:
> >>From: David Vrabel<david.vrabel@citrix.com>
> >>
> >>If NR_CPUS<  256 then arch_spinlock_t is only 16 bits wide but struct
> >>xen_spinlock is 32 bits.  When a spin lock is contended and
> >>xl->spinners is modified the two bytes immediately after the spin lock
> >>would be corrupted.
> >>
> >>This is a regression caused by 84eb950db13ca40a0572ce9957e14723500943d6
> >>(x86, ticketlock: Clean up types and accessors) which reduced the size
> >>of arch_spinlock_t.
> >>
> >>Fix this by making xl->spinners a u8 if NR_CPUS<  256.  A
> >>BUILD_BUG_ON() is also added to check the sizes of the two structures
> >>are compatible.
> >>
> >>In many cases this was not noticable as there would often be padding
> >>bytes after the lock (e.g., if any of CONFIG_GENERIC_LOCKBREAK,
> >>CONFIG_DEBUG_SPINLOCK, or CONFIG_DEBUG_LOCK_ALLOC were enabled).
> >>
> >>The bnx2 driver is affected. In struct bnx2, phy_lock and
> >>indirect_lock may have no padding after them.  Contention on phy_lock
> >>would corrupt indirect_lock making it appear locked and the driver
> >>would deadlock.
> >
> >Nice find. I think it also affected the ahci driver, and some of the USB
> >ones - at least those I saw starting to hang with:
> 
> It's possible but keep in mind that this isn't a recent regression.  I 
> think it's been around since 3.0 and maybe even earlier.

konrad@phenom:~/work/linux.mm$ git tag --contains 84eb950db13ca40a0572ce9957e14723500943d6 | grep -v rc
v3.2

So since v3.2, hmm, I should double-check those serial logs
to see if the problems I had were in 3.2 as well.
