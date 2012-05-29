Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753384Ab2E2Nj3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 09:39:29 -0400
Received: from mga11.intel.com ([192.55.52.93]:55463 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753237Ab2E2NjZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 09:39:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="158216613"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, alan@linux.intel.com,
        devel@linuxdriverproject.org, Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 4/4] misc: mei: fix stalled read
Date: Tue, 29 May 2012 16:39:12 +0300
Message-Id: <1338298752-15445-5-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1338298752-15445-1-git-send-email-tomas.winkler@intel.com>
References: <1338298752-15445-1-git-send-email-tomas.winkler@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This bug caused severe connectivity issue in the LMS application
(LMS is described in  Documentation/misc-devices/mei/mei.txt)

The bug was introduced in patch:
commit 1ccb7b6249f9bc50678e2a383084ed0a34cc9239
staging/mei: propagate error codes up in the write flow

The patch has reverted the return value logic of some fo function but
the conditional in _mei_irq_thread_read function was not swapped
making read always entering the error path

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/interrupt.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/misc/mei/interrupt.c b/drivers/misc/mei/interrupt.c
index 93936f1..23f5463 100644
--- a/drivers/misc/mei/interrupt.c
+++ b/drivers/misc/mei/interrupt.c
@@ -835,7 +835,7 @@ static int _mei_irq_thread_read(struct mei_device *dev,	s32 *slots,
 			struct mei_cl *cl,
 			struct mei_io_list *cmpl_list)
 {
-	if ((*slots * sizeof(u32)) >= (sizeof(struct mei_msg_hdr) +
+	if ((*slots * sizeof(u32)) < (sizeof(struct mei_msg_hdr) +
 			sizeof(struct hbm_flow_control))) {
 		/* return the cancel routine */
 		list_del(&cb_pos->cb_list);
-- 
1.7.4.4

