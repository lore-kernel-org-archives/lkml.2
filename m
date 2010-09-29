Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755314Ab0I2TBT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 15:01:19 -0400
Received: from relay3.sgi.com ([192.48.152.1]:47091 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754339Ab0I2TBR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 15:01:17 -0400
Message-Id: <20100929190053.992911934@gulag1.americas.sgi.com>
User-Agent: quilt/0.47-1
Date: Wed, 29 Sep 2010 14:00:53 -0500
From: Robin Holt <holt@sgi.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Badari Pulavarty <pbadari@us.ibm.com>,
        Dave Hansen <haveblue@us.ibm.com>, Gary Hade <garyhade@us.ibm.com>,
        Ingo Molnar <mingo@elte.hu>,
        Matt Tolentino <matthew.e.tolentino@intel.com>,
        "Robert P. J. Day" <rpjday@crashcourse.ca>
Subject: [Patch 0/3] Speed up link_mem_sections during boot.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


During boot of a large system, we see a delay in the portion of boot which
is calling link_mem_sections().  On a 16TB x86_64 system, it is taking
1 hour 27 minutes.  With this patch set applied, it takes 46 seconds.

The speedup is accomplished by simply caching the results from the
previous find_memory_block and using that as a quick check to see if
the next block happens to be adjacent to the previous.  In our testing,
that was true 100% of the time.

---

 drivers/base/memory.c   |   28 ++++++++++++++++++----------
 drivers/base/node.c     |    8 +++++---
 include/linux/kobject.h |    2 ++
 include/linux/memory.h  |    2 ++
 lib/kobject.c           |   39 +++++++++++++++++++++++++++++++++++++++
 5 files changed, 66 insertions(+), 13 deletions(-)
