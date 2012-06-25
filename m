Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757330Ab2FYQs2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 12:48:28 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:57783 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757169Ab2FYQs1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 12:48:27 -0400
From: Seth Jennings <sjenning@linux.vnet.ibm.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Nitin Gupta <ngupta@vflare.org>, Minchan Kim <minchan@kernel.org>,
        Robert Jennings <rcj@linux.vnet.ibm.com>, linux-mm@kvack.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] zsmalloc: remove x86 dependency
Date: Mon, 25 Jun 2012 11:14:35 -0500
Message-Id: <1340640878-27536-1-git-send-email-sjenning@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.9.5
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12062516-5930-0000-0000-000009425CEA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset continues/adapts Minchan Kim's work
to remove the x86 dependency from zsmalloc.

However, instead of whitelisting archs with support for
local_tlb_flush_kernel_range() in the zsmalloc Kconfig,
this patchset allows zsmalloc to work with all archs
through the addition of a generic/portable page
mapping methods (i.e. memcpy) when the required tlb
flushing functionality is not supported by the arch.

The arch advertises support for local_tlb_flush_kernel_range()
by defining __HAVE_LOCAL_FLUSH_TLB_KERNEL_RANGE

The third patch in the set adds local_tlb_flush_kernel_range()
support to x86.  In my single-threaded tests using zcache,
using the pte/tlb mapping method was 40% faster than the generic
method. So while the third patch is optional, it is highly
recommended.

Alex Shi is working on a large x86 patchset that includes
functionality similar to the third patch, however, it seems
that this patchset is getting very little attention and
includes much more than is needed for zsmalloc's purposes.

https://lkml.org/lkml/2012/6/12/116

Future work:
 - Add __HAVE_LOCAL_FLUSH_TLB_KERNEL_RANGE definition to
   archs that already have local_tlb_flush_kernel_range()
 - Add mapping mode flags (RO, WO, RW) to zs_map_object()
   to avoid unnecessary copies in the generic case

Based on Greg's staging-next.

Seth Jennings (3):
  zram/zcache: swtich Kconfig dependency from X86 to ZSMALLOC
  zsmalloc: add generic path and remove x86 dependency
  x86: add local_tlb_flush_kernel_range()

 arch/x86/include/asm/tlbflush.h          |   21 +++++
 drivers/staging/zcache/Kconfig           |    5 +-
 drivers/staging/zram/Kconfig             |    5 +-
 drivers/staging/zsmalloc/Kconfig         |    4 -
 drivers/staging/zsmalloc/zsmalloc-main.c |  136 ++++++++++++++++++++++++------
 drivers/staging/zsmalloc/zsmalloc_int.h  |    5 +-
 6 files changed, 138 insertions(+), 38 deletions(-)

-- 
1.7.9.5

