Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754302Ab2AWUyp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 15:54:45 -0500
Received: from mx1.redhat.com ([209.132.183.28]:20922 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754262Ab2AWUyn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 15:54:43 -0500
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
To: linux-kernel@vger.kernel.org
Cc: Andi Kleen <andi@firstfloor.org>, Huang Ying <ying.huang@intel.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Subject: [PATCH] MCE: fix return value of mce_chrdev_read() when erst is disabled
Date: Mon, 23 Jan 2012 15:54:52 -0500
Message-Id: <1327352092-18395-1-git-send-email-n-horiguchi@ah.jp.nec.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Current kernel MCE code reads ERST at the first reading of /dev/mcelog
(maybe in starting mcelogd,) even if the system does not support ERST,
which results in a fake "no such device" message (as described in [1].)
This problem is not critical, but can confuse system admins.
This patch fixes it by filtering the return value from lower (ACPI) layer.

 [1] http://thread.gmane.org/gmane.linux.kernel/1060250

Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Huang Ying <ying.huang@intel.com>
---
 arch/x86/kernel/cpu/mcheck/mce.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git 3.3-rc1.orig/arch/x86/kernel/cpu/mcheck/mce.c 3.3-rc1/arch/x86/kernel/cpu/mcheck/mce.c
index 5a11ae2..8ee5c4f 100644
--- 3.3-rc1.orig/arch/x86/kernel/cpu/mcheck/mce.c
+++ 3.3-rc1/arch/x86/kernel/cpu/mcheck/mce.c
@@ -1541,6 +1541,12 @@ static int __mce_read_apei(char __user **ubuf, size_t usize)
 	/* Error or no more MCE record */
 	if (rc <= 0) {
 		mce_apei_read_done = 1;
+		/*
+		 * When ERST is disabled, mce_chrdev_read() should return
+		 * "no record" instead of "no device."
+		 */
+		if (rc == -ENODEV)
+			return 0;
 		return rc;
 	}
 	rc = -EFAULT;
-- 
1.7.6.5

