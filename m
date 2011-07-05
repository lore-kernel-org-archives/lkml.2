Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752419Ab1GEN7J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 09:59:09 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:55242 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752259Ab1GEN7I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 09:59:08 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 6/8] drivers: add Contiguous Memory Allocator
Date: Tue, 5 Jul 2011 15:58:39 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: "Russell King - ARM Linux" <linux@arm.linux.org.uk>,
        Daniel Walker <dwalker@codeaurora.org>,
        Jonathan Corbet <corbet@lwn.net>, Mel Gorman <mel@csn.ul.ie>,
        Chunsang Jeong <chunsang.jeong@linaro.org>,
        Jesse Barker <jesse.barker@linaro.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org, Michal Nazarewicz <mina86@mina86.com>,
        linaro-mm-sig@lists.linaro.org, linux-mm@kvack.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Ankita Garg <ankita@in.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        linux-media@vger.kernel.org
References: <1309851710-3828-1-git-send-email-m.szyprowski@samsung.com> <201107051427.44899.arnd@arndb.de> <20110705123035.GD8286@n2100.arm.linux.org.uk>
In-Reply-To: <20110705123035.GD8286@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201107051558.39344.arnd@arndb.de>
X-Provags-ID: V02:K0:7NvOMbovKgX/b8M6c1E7pNExqAmg3R0HjzlbJDi0kqk
 COMp6B6Fbn2YrpbIkbC/ojdONGwXm+u1arN48pMiTu9mlLBDVr
 HRPvyxV1/0wxKTgvII0pqnskHxslaDdWW2/8b5q3jlnof1QBiC
 xRsa8x5+93bji0LqaUKRfnIe3bNoOhCKu9myAAwjn1zelBza9k
 On2Ky5faLvomL6YHy4tyg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 05 July 2011, Russell King - ARM Linux wrote:
> On Tue, Jul 05, 2011 at 02:27:44PM +0200, Arnd Bergmann wrote:
> > It's also a preexisting problem as far as I can tell, and it needs
> > to be solved in __dma_alloc for both cases, dma_alloc_from_contiguous
> > and __alloc_system_pages as introduced in patch 7.
> 
> Which is now resolved in linux-next, and has been through this cycle
> as previously discussed.
> 
> It's taken some time because the guy who tested the patch for me said
> he'd review other platforms but never did, so I've just about given up
> waiting and stuffed it in ready for the 3.1 merge window irrespective
> of anything else.

Ah, sorry I missed that patch on the mailing list, found it now in
your for-next branch.

If I'm reading your "ARM: DMA: steal memory for DMA coherent mappings"
correctly, the idea is to have a per-platform compile-time amount
of memory that is reserved purely for coherent allocations and
taking out of the buddy allocator, right?

As you say, this solves the problem for the non-CMA case, and does
not apply to CMA because the entire point of CMA is not to remove
the pages from the buddy allocator in order to preserve memory.

So with your patch getting merged, patch 7/8 obviously has both a
conflict and introduces a regression against the fix you did.
Consequently that patch needs to be redone in a way that fits on
top of your patch and avoids the double-mapping problem.

What about the rest? As I mentioned in private, adding invasive features
to core code is obviously not nice if it can be avoided, but my feeling
is that we can no longer claim that there is no need for this with so
much hardware relying on large contiguous memory ranges for DMA.
The patches have come a long way since the first version, especially
regarding the device driver interface and I think they are about as
good as it gets in that regard.

I do understand that without patch 7, there isn't a single architecture
using the feature, which is somewhat silly, but I'm also convinced
that other architectures will start using it, and that a solution for the
double mapping in the ways I mentioned in my previous mail is going
to happen. Probably not in 3.1 then, but we could put the patches into
-mm anyway until we get there.

	Arnd
