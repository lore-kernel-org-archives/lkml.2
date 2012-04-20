Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755320Ab2DTVtb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 17:49:31 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:45851 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754905Ab2DTVt3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 17:49:29 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-mm@kvack.org, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, ngupta@vflare.org,
        sjenning@linux.vnet.ibm.com, rcj@linux.vnet.ibm.com,
        aarcange@redhat.com, dhowells@redhat.com, riel@redhat.com,
        JBeulich@novell.com
Subject: [RFC PATCH] frontswap (v15). +--------+ |zsmalloc| +--------+ +---------+    +------------+          | | swap    +--->| frontswap  +          v +---------+    +------------|      +--------+  +----->| zcache | +--------+
Date: Fri, 20 Apr 2012 17:44:09 -0400
Message-Id: <1334958255-6612-1-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.7.5
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090203.4F91D9E0.002A,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Example usage, others are tmem, ramster, and RFC KVM]

Frontswap provides a "transcendent memory" interface for swap pages.
In some environments, dramatic performance savings may be obtained because
swapped pages are saved in RAM (or a RAM-like device) instead of a swap disk.
A nice overview of it is visible at: http://lwn.net/Articles/454795/

The backends, such as zcache provides compression of pages resulting
in speed up [https://lkml.org/lkml/2012/3/22/383]. If the backends
are not enabled and CONFIG_FRONTSWAP is compiled there is no adverse
performance hit (details further down).

Patches are also at:
git://git.kernel.org/pub/scm/linux/kernel/git/konrad/mm.git  stable/frontswap.v15.squashed

The last time these patches were posted [https://lkml.org/lkml/2011/10/27/206]
the discussion got very technical - and the feeling I got was that:
 - The API is too simple. The hard decisions (what to do when memory
   is low and the pages are mlocked, disk is faster than the CPU compression,
   need some way to shed pages when OOM conditions are close by, which pages
   to compress) are left to the backends. Adding VM pressure hooks could solve 
   some (if not all) of these issues? Dan is working on figuring this out for
   zcache.
 - the backends - like zcache - are tied in how this API is used. This means
   that to get zcache out of staging need to think of the frontswap and
   zcache (and also the other backends).

So to rehash, I think the core issues were with the backends [note, I 
ommitted some here - that is not b/c I choose to ignore them - it just that 
there were some many and I believe many of them got resolved in the discussion?]
 - IRQ latency of zcache. Code needs to be rewritten in zcache a bit.
 - VM pressure - need to be able to influence the backends (or the
   frontswap API as a whole)
 - backends need to handle batched requests.
 - backend needs to fix glaring atrocities (casting of 'struct page *' to
   'char *' and then back).

frontswap API:
 - perhaps make it a device driver and stack it (similar to loopback)? So
   frontswap_ioctl /dev/sda3 /dev/frontswap1 [bind it]
   swapon /dev/frontswap1

   The work required here means more invasive patches in the swap code and
   block code to deal with a dynamic sized disk.
 - only do it on recently activate pages [https://lkml.org/lkml/2012/1/26/520]


Compared to the last posting [https://lkml.org/lkml/2011/10/27/206]
 - a writethrough option. Meaning hat every swap page gets written
   to both frontswap AND to the swap disk. The backend can choose to tell frontswap
   to stop sending pages to it. This would allow the backend to react to memory pressure
   or to shut down if it is taking too much time compressing and pages end up in
   proper swap.
 - change the put/get to a different name: store/load
 - make the return values be bool instead of the int - it was getting confusing
 - seperate the CONFIG_DEBUGFS options out

Documentation/vm/frontswap.txt        |  278 +++++++++++++++++++++++++++++
 MAINTAINERS                           |    7 +
 drivers/staging/ramster/zcache-main.c |    8 +-
 drivers/staging/zcache/zcache-main.c  |   10 +-
 drivers/xen/tmem.c                    |    8 +-
 include/linux/frontswap.h             |  127 +++++++++++++
 include/linux/swap.h                  |    4 +
 include/linux/swapfile.h              |   13 ++
 mm/Kconfig                            |   17 ++
 mm/Makefile                           |    1 +
 mm/frontswap.c                        |  314 +++++++++++++++++++++++++++++++++
 mm/page_io.c                          |   12 ++
 mm/swapfile.c                         |   54 +++++--
 13 files changed, 827 insertions(+), 26 deletions(-)
Dan Magenheimer (4):
      mm: frontswap: add frontswap header file
      mm: frontswap: core swap subsystem hooks and headers
      mm: frontswap: core frontswap functionality
      mm: frontswap: config and doc files

Konrad Rzeszutek Wilk (2):
      MAINTAINER: Add myself for the frontswap API
      frontswap: s/put_page/store/g s/get_page/load

Benchmarks:

James asked about if compiled in but not used (so FRONTSWAP=y but no 'zcache' on
the Linux comnand line argument). Dan did some work in this and found that the
that CONFIG_FRONTSWAP=y is faster... or actually realistically just well within any
measureable noise. 
