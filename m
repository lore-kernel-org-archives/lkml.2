Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932207Ab1GVU7h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jul 2011 16:59:37 -0400
Received: from mga09.intel.com ([134.134.136.24]:30244 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755124Ab1GVU7e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jul 2011 16:59:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,249,1309762800"; 
   d="scan'208";a="30927873"
Subject: [RFC PATCH 0/2] block: rq_affinity performance fixes
To: jaxboe@fusionio.com
From: Dan Williams <dan.j.williams@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Date: Fri, 22 Jul 2011 13:59:33 -0700
Message-ID: <20110722205736.17420.41366.stgit@localhost6.localdomain6>
User-Agent: StGit/0.15-7-g9bfb-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens,

Per the "rq_affinity doesn't seem to work?" thread [1].  We found that the
default cpu steering that rq_affinity performs is insufficient to keep up with
some completion loads.

Dave collected the following relative iops measures:
pre-patches  rq_affinity=0: 1x
pre-patches  rq_affinity=1: 1x
post-patches rq_affinity=1: 1.08x
post-patches rq_affinity=2: 1.35x

The "adaptive rq_affinity" patch is more of a discussion point than a
real fix.  However, it shows that even something straightforward and
seemingly aggressive does not really come close to the performance of
just turning cpu grouping off altogether.  The "strict rq_affinity"
patch follows the "nomerges" interface precedent of setting 2 to
indicate "I really mean it".

So, at a minimum consider taking patch 1, and we can leave the search
for a better adaptive algorithm as future work.

[1]: http://marc.info/?l=linux-kernel&m=131049742925413&w=4

---

Dan Williams (2):
      block: strict rq_affinity
      block: adaptive rq_affinity

 Documentation/block/queue-sysfs.txt |   10 +++++++---
 block/blk-core.c                    |    6 ++----
 block/blk-softirq.c                 |   23 ++++++++++++++++++-----
 block/blk-sysfs.c                   |   13 +++++++++----
 include/linux/blkdev.h              |    3 ++-
 5 files changed, 38 insertions(+), 17 deletions(-)
