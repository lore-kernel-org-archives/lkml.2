Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752857Ab2DWQza (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 12:55:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30886 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752180Ab2DWQz3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 12:55:29 -0400
Date: Mon, 23 Apr 2012 12:55:26 -0400
From: David Teigland <teigland@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, swhiteho@redhat.com
Subject: [GIT PULL] dlm fixes for 3.4
Message-ID: <20120423165526.GA30820@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull dlm fixes from tag:

git://git.kernel.org/pub/scm/linux/kernel/git/teigland/linux-dlm.git dlm-fixes-3.4

This includes one short patch fixing the behavior of
the QUECVT flag, which the gfs2 folks are waiting on.

Thanks,
Dave

From: David Teigland <teigland@redhat.com>
Date: Wed, 4 Apr 2012 09:49:15 -0500
Subject: [PATCH] dlm: fix QUECVT when convert queue is empty

The QUECVT flag should not prevent conversions from
being granted immediately when the convert queue is
empty.

Signed-off-by: David Teigland <teigland@redhat.com>
---
 fs/dlm/lock.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/fs/dlm/lock.c b/fs/dlm/lock.c
index fa5c07d..4c58d4a 100644
--- a/fs/dlm/lock.c
+++ b/fs/dlm/lock.c
@@ -1737,6 +1737,18 @@ static int _can_be_granted(struct dlm_rsb *r, struct dlm_lkb *lkb, int now)
 		return 1;
 
 	/*
+	 * Even if the convert is compat with all granted locks,
+	 * QUECVT forces it behind other locks on the convert queue.
+	 */
+
+	if (now && conv && (lkb->lkb_exflags & DLM_LKF_QUECVT)) {
+		if (list_empty(&r->res_convertqueue))
+			return 1;
+		else
+			goto out;
+	}
+
+	/*
 	 * The NOORDER flag is set to avoid the standard vms rules on grant
 	 * order.
 	 */
-- 
1.7.10.rc3

