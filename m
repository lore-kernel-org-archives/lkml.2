Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759568Ab1LOVSw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 16:18:52 -0500
Received: from mga03.intel.com ([143.182.124.21]:65366 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759523Ab1LOVSK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 16:18:10 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="86206938"
Message-Id: <5d6588ab3dadabd8334cffee06b3e87abe3b81b7.1323979146.git.tony.luck@intel.com>
In-Reply-To: <cover.1323979146.git.tony.luck@intel.com>
References: <cover.1323979146.git.tony.luck@intel.com>
From: Tony Luck <tony.luck@intel.com>
Date: Wed, 14 Dec 2011 15:55:20 -0800
Subject: [PATCH 4/6] x86, mce: Add mechanism to safely save information in MCE handler
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Borislav Petkov <bp@amd64.org>,
        Chen Gong <gong.chen@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Machine checks on Intel cpus interrupt execution on all cpus, regardless
of interrupt masking.  We have a need to save some data about the cause
of the machine check (physical address) in the machine check handler that
can be retrieved later to attempt recovery in a more flexible execution
state.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 arch/x86/kernel/cpu/mcheck/mce.c |   43 ++++++++++++++++++++++++++++++++++++++
 1 files changed, 43 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index 645070f..7d7303a 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -887,6 +887,49 @@ static void mce_clear_state(unsigned long *toclear)
 }
 
 /*
+ * Need to save faulting physical address associated with a process
+ * in the machine check handler some place where we can grab it back
+ * later in mce_notify_process()
+ */
+#define	MAX_MCE_INFO	16
+
+struct mce_info {
+	atomic_t		inuse;
+	struct task_struct	*t;
+	__u64			paddr;
+} mce_info[MAX_MCE_INFO];
+
+static void mce_save_info(__u64 addr)
+{
+	struct mce_info *mi;
+
+	for (mi = mce_info; mi < &mce_info[MAX_MCE_INFO]; mi++) {
+		if (atomic_cmpxchg(&mi->inuse, 0, 1) == 0) {
+			mi->t = current;
+			mi->paddr = addr;
+			return;
+		}
+	}
+
+	mce_panic("Too many concurrent recoverable errors", NULL, NULL);
+}
+
+static struct mce_info *mce_find_info(void)
+{
+	struct mce_info *mi;
+
+	for (mi = mce_info; mi < &mce_info[MAX_MCE_INFO]; mi++)
+		if (atomic_read(&mi->inuse) && mi->t == current)
+			return mi;
+	return NULL;
+}
+
+static void mce_clear_info(struct mce_info *mi)
+{
+	atomic_set(&mi->inuse, 0);
+}
+
+/*
  * The actual machine check handler. This only handles real
  * exceptions when something got corrupted coming in through int 18.
  *
-- 
1.7.3.1

