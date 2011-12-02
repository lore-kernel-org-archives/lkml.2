Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753092Ab1LBX4t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Dec 2011 18:56:49 -0500
Received: from mga11.intel.com ([192.55.52.93]:13409 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751774Ab1LBX4q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Dec 2011 18:56:46 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,286,1320652800"; 
   d="scan'208";a="98072447"
Subject: [PATCH 0/3] drain_workqueue vs scsi_flush_work
To: tj@kernel.org, JBottomley@parallels.com
From: Dan Williams <dan.j.williams@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Date: Fri, 02 Dec 2011 15:56:45 -0800
Message-ID: <20111202235319.24470.65483.stgit@localhost6.localdomain6>
User-Agent: StGit/0.15-7-g9bfb-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tejun, James,

While trying to use drain_workqueue() in libsas I hit the
WARN_ON_ONCE(!is_chained_work(wq)) in __queue_work().  However, as I
mention in patch-2 libsas expects that new unchained work can be
submitted during a drain.  So, patch-2 is a hack to accept new work when
drain_workqueue() is used publicly as a "stronger flush", while keeping
the same warn+drop behavior for internal usages of drain_workqueue() in
the destroy_workqueue() case.

Smoke tested on sas topoloogy of:
host-->ata
host-->expander-->ata
host-->expander-->expander-->ata

--
Dan


---

Dan Williams (3):
      workqueue: promote workqueue_lock to hard-irq safe
      workqueue: defer work to a draining queue
      scsi: use drain_workqueue

 drivers/scsi/hosts.c      |    8 ++-
 drivers/scsi/isci/host.c  |    3 -
 include/linux/workqueue.h |    3 +
 include/scsi/scsi_host.h  |    2 -
 kernel/workqueue.c        |  114 ++++++++++++++++++++++++++++++++-------------
 5 files changed, 89 insertions(+), 41 deletions(-)
