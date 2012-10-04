Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754171Ab2JDSjK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 14:39:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56592 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752285Ab2JDSjI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 14:39:08 -0400
Date: Thu, 4 Oct 2012 20:38:19 +0200
From: Andrea Arcangeli <aarcange@redhat.com>
To: Christoph Lameter <cl@linux.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <pzijlstr@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        Mel Gorman <mel@csn.ul.ie>, Hugh Dickins <hughd@google.com>,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Hillf Danton <dhillf@gmail.com>, Andrew Jones <drjones@redhat.com>,
        Dan Smith <danms@us.ibm.com>, Thomas Gleixner <tglx@linutronix.de>,
        Paul Turner <pjt@google.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Mike Galbraith <efault@gmx.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH 29/33] autonuma: page_autonuma
Message-ID: <20121004183819.GM25675@redhat.com>
References: <20121004165008.GF25675@redhat.com>
 <0000013a2cff3c3d-76e00716-2869-4dc8-8717-82f0136018d0-000000@email.amazonses.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0000013a2cff3c3d-76e00716-2869-4dc8-8717-82f0136018d0-000000@email.amazonses.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Christoph,

On Thu, Oct 04, 2012 at 06:17:37PM +0000, Christoph Lameter wrote:
> On Thu, 4 Oct 2012, Andrea Arcangeli wrote:
> 
> > So we could drop page_autonuma by creating a CONFIG_SLUB=y dependency
> > (AUTONUMA wouldn't be available in the kernel config if SLAB=y, and it
> > also wouldn't be available on 32bit archs but the latter isn't a
> > problem).
> 
> Nope it should depend on page struct alignment. Other kernel subsystems
> may be depeding on page struct alignment in the future (and some other
> arches may already have that requirement)

But currently only SLUB x86 64bit selects
CONFIG_HAVE_ALIGNED_STRUCT_PAGE:

arch/Kconfig:config HAVE_ALIGNED_STRUCT_PAGE
arch/x86/Kconfig:       select HAVE_ALIGNED_STRUCT_PAGE if SLUB && !M386
include/linux/mm_types.h:       defined(CONFIG_HAVE_ALIGNED_STRUCT_PAGE)
include/linux/mm_types.h:#ifdef CONFIG_HAVE_ALIGNED_STRUCT_PAGE
mm/slub.c:    defined(CONFIG_HAVE_ALIGNED_STRUCT_PAGE)
mm/slub.c:    defined(CONFIG_HAVE_ALIGNED_STRUCT_PAGE)
mm/slub.c:    defined(CONFIG_HAVE_ALIGNED_STRUCT_PAGE)

So in practice a dependency on CONFIG_HAVE_ALIGNED_STRUCT_PAGE would
still mean the same: only available when SLUB enables it, and only on
x86 64bit (ppc64?).

If you mean CONFIG_AUTONUMA=y should select (not depend) on
CONFIG_HAVE_ALIGNED_STRUCT_PAGE, that would allow to enable it in all
.configs but it would have a worse cons: losing 8bytes per page
unconditionally (even when booting on non-NUMA hardware).

The current page_autonuma solution is substantially memory-cheaper
than selecting CONFIG_HAVE_ALIGNED_STRUCT_PAGE: it allocates 2bytes
per page at boot time but only if booting on real NUMA hardware
(without altering the page structure). So to me it looks still quite a
decent tradeoff.

Thanks,
Andrea
