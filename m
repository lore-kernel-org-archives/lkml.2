Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755712Ab1HaOmK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 10:42:10 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:58557 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755633Ab1HaOmI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 10:42:08 -0400
From: Seth Jennings <sjenning@linux.vnet.ibm.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, dan.magenheimer@oracle.com, ngupta@vflare.org,
        cascardo@holoscopio.com, rdunlap@xenotime.net,
        linux-kernel@vger.kernel.org,
        Seth Jennings <sjenning@linux.vnet.ibm.com>
Subject: [PATCH 0/3] staging: zcache: xcfmalloc support
Date: Wed, 31 Aug 2011 09:40:38 -0500
Message-Id: <1314801641-15059-1-git-send-email-sjenning@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset introduces a new memory allocator for persistent
pages for zcache.  The current allocator is xvmalloc.  xvmalloc
has two notable limitations:
* High (up to 50%) external fragmentation on allocation sets > PAGE_SIZE/2
* No compaction support which reduces page reclaimation

xcfmalloc seeks to fix these issues by using scatter-gather model that
allows for cross-page allocations and relocatable data blocks.

In tests, with pages that only compress to 75% of their original
size, xvmalloc had an effective compression (pages stored / pages used by the
compressed memory pool) of ~95% (~20% lost to fragmentation). Almost nothing
was gained by the compression in this case. xcfmalloc had an effective
compression of ~77% (about ~2% lost to fragmentation and metadata overhead).

xcfmalloc uses the same locking scheme as xvmalloc; a single pool-level
spinlock.  This can lead to some contention.  However, in my tests on a 4
way SMP system, the contention was minimal (200 contentions out of 600k
aquisitions).  The locking scheme may be able to be improved in the future.
In tests, xcfmalloc and xvmalloc had identical throughputs.

While the xcfmalloc design lends itself to compaction, this is not yet
implemented.  Support will be added in a follow-on patch.

Based on 3.1-rc4.

Seth Jennings (3):
  staging: zcache: xcfmalloc memory allocator for zcache
  staging: zcache: replace xvmalloc with xcfmalloc
  staging: zcache: add zv_page_count and zv_desc_count

 drivers/staging/zcache/Makefile      |    2 +-
 drivers/staging/zcache/xcfmalloc.c   |  653 ++++++++++++++++++++++++++++++++++
 drivers/staging/zcache/xcfmalloc.h   |   29 ++
 drivers/staging/zcache/zcache-main.c |  154 ++++++---
 4 files changed, 791 insertions(+), 47 deletions(-)
 create mode 100644 drivers/staging/zcache/xcfmalloc.c
 create mode 100644 drivers/staging/zcache/xcfmalloc.h

-- 
1.7.4.1

