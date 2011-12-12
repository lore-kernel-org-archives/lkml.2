Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755781Ab1LMTPO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 14:15:14 -0500
Received: from mga02.intel.com ([134.134.136.20]:42848 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755620Ab1LMTOW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 14:14:22 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="86860647"
Message-Id: <21784ca9d3f0a59c01c9d127a088077561616ba1.1323803130.git.tony.luck@intel.com>
In-Reply-To: <cover.1323803130.git.tony.luck@intel.com>
References: <cover.1323803130.git.tony.luck@intel.com>
From: Tony Luck <tony.luck@intel.com>
Date: Mon, 12 Dec 2011 13:06:02 -0800
Subject: [PATCH 4/6] x86, mce: Add mechanism to safely save information in MCE handler
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Borislav Petkov <bp@amd64.org>,
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
 arch/x86/kernel/cpu/mcheck/mce.c |   51 ++++++++++++++++++++++++++++++++++++++
 1 files changed, 51 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index 43f22c8..9b83b7d 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -887,6 +887,57 @@ static void mce_clear_state(unsigned long *toclear)
 }
 
 /*
+ * Need to save faulting physical address associated with a process
+ * in the machine check handler some place where we can grab it back
+ * later in mce_notify_process()
+ */
+#define	MAX_MCE_INFO	16
+struct mce_info {
+	atomic_t		inuse;
+	struct task_struct	*t;
+	__u64			paddr;
+} mce_info[MAX_MCE_INFO];
+
+static void mce_save_info(__u64 addr)
+{
+	int	i;
+
+	for (i = 0; i < MAX_MCE_INFO; i++)
+		if (atomic_cmpxchg(&mce_info[i].inuse, 0, 1) == 0) {
+			mce_info[i].t = current;
+			mce_info[i].paddr = addr;
+			return;
+		}
+
+	mce_panic("Too many concurrent recoverable errors", NULL, NULL);
+}
+
+static int mce_find_info(__u64 *paddr)
+{
+	int	i;
+
+	for (i = 0; i < MAX_MCE_INFO; i++)
+		if (atomic_read(&mce_info[i].inuse) &&
+		    mce_info[i].t == current) {
+			*paddr = mce_info[i].paddr;
+			return 1;
+		}
+	return 0;
+}
+
+static void mce_clear_info(void)
+{
+	int	i;
+
+	for (i = 0; i < MAX_MCE_INFO; i++)
+		if (atomic_read(&mce_info[i].inuse) &&
+		    mce_info[i].t == current) {
+			atomic_set(&mce_info[i].inuse, 0);
+			return;
+		}
+}
+
+/*
  * The actual machine check handler. This only handles real
  * exceptions when something got corrupted coming in through int 18.
  *
-- 
1.7.3.1

