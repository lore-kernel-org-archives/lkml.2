Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755380Ab0K3KPJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 05:15:09 -0500
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:38400 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755059Ab0K3KPH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 05:15:07 -0500
Subject: [PATCH 0/3] Series short description
To: linux-mm@kvack.org, Christoph Lameter <cl@linux.com>
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        kvm <kvm@vger.kernel.org>
Date: Tue, 30 Nov 2010 15:44:57 +0530
Message-ID: <20101130101126.17475.18729.stgit@localhost6.localdomain6>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following series implements page cache control,
this is a split out version of patch 1 of version 3 of the
page cache optimization patches posted earlier at
http://www.mail-archive.com/kvm@vger.kernel.org/msg43654.html

Christoph Lamater recommended splitting out patch 1, which
is what this series does

Detailed Description
====================
This patch implements unmapped page cache control via preferred
page cache reclaim. The current patch hooks into kswapd and reclaims
page cache if the user has requested for unmapped page control.
This is useful in the following scenario

- In a virtualized environment with cache=writethrough, we see
  double caching - (one in the host and one in the guest). As
  we try to scale guests, cache usage across the system grows.
  The goal of this patch is to reclaim page cache when Linux is running
  as a guest and get the host to hold the page cache and manage it.
  There might be temporary duplication, but in the long run, memory
  in the guests would be used for mapped pages.
- The option is controlled via a boot option and the administrator
  can selectively turn it on, on a need to use basis.

A lot of the code is borrowed from zone_reclaim_mode logic for
__zone_reclaim(). One might argue that the with ballooning and
KSM this feature is not very useful, but even with ballooning,
we need extra logic to balloon multiple VM machines and it is hard
to figure out the correct amount of memory to balloon. With these
patches applied, each guest has a sufficient amount of free memory
available, that can be easily seen and reclaimed by the balloon driver.
The additional memory in the guest can be reused for additional
applications or used to start additional guests/balance memory in
the host.

KSM currently does not de-duplicate host and guest page cache. The goal
of this patch is to help automatically balance unmapped page cache when
instructed to do so.

There are some magic numbers in use in the code, UNMAPPED_PAGE_RATIO
and the number of pages to reclaim when unmapped_page_control argument
is supplied. These numbers were chosen to avoid aggressiveness in
reaping page cache ever so frequently, at the same time providing control.

The sysctl for min_unmapped_ratio provides further control from
within the guest on the amount of unmapped pages to reclaim.



For a single VM - running kernbench

Enabled

Optimal load -j 8 run number 1...
Optimal load -j 8 run number 2...
Optimal load -j 8 run number 3...
Optimal load -j 8 run number 4...
Optimal load -j 8 run number 5...
Average Optimal load -j 8 Run (std deviation):
Elapsed Time 273.726 (1.2683)
User Time 190.014 (0.589941)
System Time 298.758 (1.72574)
Percent CPU 178 (0)
Context Switches 119953 (865.74)
Sleeps 38758 (795.074)

Disabled

Optimal load -j 8 run number 1...
Optimal load -j 8 run number 2...
Optimal load -j 8 run number 3...
Optimal load -j 8 run number 4...
Optimal load -j 8 run number 5...
Average Optimal load -j 8 Run (std deviation):
Elapsed Time 272.672 (0.453178)
User Time 189.7 (0.718157)
System Time 296.77 (0.845606)
Percent CPU 178 (0)
Context Switches 118822 (277.434)
Sleeps 37542.8 (545.922)

More data on the test results with the earlier patch is
at http://www.mail-archive.com/kvm@vger.kernel.org/msg43655.html

---

Balbir Singh (3):
      Move zone_reclaim() outside of CONFIG_NUMA
      Refactor zone_reclaim, move reusable functionality outside
      Provide control over unmapped pages


 include/linux/mmzone.h |    4 +-
 include/linux/swap.h   |    5 +-
 mm/page_alloc.c        |    7 ++-
 mm/vmscan.c            |  109 +++++++++++++++++++++++++++++++++++++++++-------
 4 files changed, 104 insertions(+), 21 deletions(-)

-- 
Balbir
