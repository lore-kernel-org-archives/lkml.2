Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752948Ab2GSF7I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2012 01:59:08 -0400
Received: from mga02.intel.com ([134.134.136.20]:40789 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751152Ab2GSF7F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2012 01:59:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="168319257"
From: Chen Gong <gong.chen@linux.intel.com>
To: tglx@linutronix.de
Cc: tony.luck@intel.com, bp@amd64.org, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/5] x86: mce: Serialize mce injection
Date: Thu, 19 Jul 2012 13:59:38 -0400
Message-Id: <1342720781-4729-3-git-send-email-gong.chen@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1342720781-4729-1-git-send-email-gong.chen@linux.intel.com>
References: <1342720781-4729-1-git-send-email-gong.chen@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

raise_mce() fiddles with global state, but lacks any kind of
serialization.

Add a mutex around the raise_mce() call, so concurrent writers do not
stomp on each other toes.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/kernel/cpu/mcheck/mce-inject.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/x86/kernel/cpu/mcheck/mce-inject.c b/arch/x86/kernel/cpu/mcheck/mce-inject.c
index 753746f..ddc72f8 100644
--- a/arch/x86/kernel/cpu/mcheck/mce-inject.c
+++ b/arch/x86/kernel/cpu/mcheck/mce-inject.c
@@ -78,6 +78,7 @@ static void raise_exception(struct mce *m, struct pt_regs *pregs)
 }
 
 static cpumask_var_t mce_inject_cpumask;
+static DEFINE_MUTEX(mce_inject_mutex);
 
 static int mce_raise_notify(unsigned int cmd, struct pt_regs *regs)
 {
@@ -229,7 +230,10 @@ static ssize_t mce_write(struct file *filp, const char __user *ubuf,
 	 * so do it a jiffie or two later everywhere.
 	 */
 	schedule_timeout(2);
+
+	mutex_lock(&mce_inject_mutex);
 	raise_mce(&m);
+	mutex_unlock(&mce_inject_mutex);
 	return usize;
 }
 
-- 
1.7.10.4

