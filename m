Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932938Ab2GBVQI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 17:16:08 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:43398 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755780Ab2GBVQH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 17:16:07 -0400
From: Seth Jennings <sjenning@linux.vnet.ibm.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Nitin Gupta <ngupta@vflare.org>, Minchan Kim <minchan@kernel.org>,
        Robert Jennings <rcj@linux.vnet.ibm.com>, linux-mm@kvack.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/4] zsmalloc improvements
Date: Mon,  2 Jul 2012 16:15:48 -0500
Message-Id: <1341263752-10210-1-git-send-email-sjenning@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.9.5
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12070221-5518-0000-0000-000005B5F25A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset removes the current x86 dependency for zsmalloc
and introduces some performance improvements in the object
mapping paths.

It was meant to be a follow-on to my previous patchest

https://lkml.org/lkml/2012/6/26/540

However, this patchset differed so much in light of new performance
information that I mostly started over.

In the past, I attempted to compare different mapping methods
via the use of zcache and frontswap.  However, the nature of those
two features makes comparing mapping method efficiency difficult
since the mapping is a very small part of the overall code path.

In an effort to get more useful statistics on the mapping speed,
I wrote a microbenchmark module named zsmapbench, designed to
measure mapping speed by calling straight into the zsmalloc
paths.

https://github.com/spartacus06/zsmapbench

This exposed an interesting and unexpected result: in all
cases that I tried, copying the objects that span pages instead
of using the page table to map them, was _always_ faster.  I could
not find a case in which the page table mapping method was faster.

zsmapbench measures the copy-based mapping at ~560 cycles for a
map/unmap operation on spanned object for both KVM guest and bare-metal,
while the page table mapping was ~1500 cycles on a VM and ~760 cycles
bare-metal.  The cycles for the copy method will vary with
allocation size, however, it is still faster even for the largest
allocation that zsmalloc supports.

The result is convenient though, as mempcy is very portable :)

This patchset replaces the x86-only page table mapping code with
copy-based mapping code. It also makes changes to optimize this
new method further.

There are no changes in arch/x86 required.

Patchset is based on greg's staging-next.

Seth Jennings (4):
  zsmalloc: remove x86 dependency
  zsmalloc: add single-page object fastpath in unmap
  zsmalloc: add details to zs_map_object boiler plate
  zsmalloc: add mapping modes

 drivers/staging/zcache/zcache-main.c     |    6 +-
 drivers/staging/zram/zram_drv.c          |    7 +-
 drivers/staging/zsmalloc/Kconfig         |    4 -
 drivers/staging/zsmalloc/zsmalloc-main.c |  124 ++++++++++++++++++++++--------
 drivers/staging/zsmalloc/zsmalloc.h      |   14 +++-
 drivers/staging/zsmalloc/zsmalloc_int.h  |    6 +-
 6 files changed, 114 insertions(+), 47 deletions(-)

-- 
1.7.9.5

