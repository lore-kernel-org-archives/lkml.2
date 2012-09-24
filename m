Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758025Ab2IXUtI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 16:49:08 -0400
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:60448 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757951Ab2IXUtG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 16:49:06 -0400
Message-ID: <5060C714.8030606@linux.vnet.ibm.com>
Date: Tue, 25 Sep 2012 02:18:20 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Borislav Petkov <bp@amd64.org>
CC: Conny Seidel <conny.seidel@amd.com>, Jan Kara <jack@suse.cz>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Fengguang Wu <fengguang.wu@intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <jweiner@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH] CPU hotplug, writeback: Don't call writeback_set_ratelimit()
 too often during hotplug
References: <20120924102324.GA22303@aftab.osrc.amd.com> <20120924142305.GD12264@quack.suse.cz> <20120924143609.GH22303@aftab.osrc.amd.com> <20120924201650.6574af64.conny.seidel@amd.com> <20120924181927.GA25762@aftab.osrc.amd.com> <5060AB0E.3070809@linux.vnet.ibm.com>
In-Reply-To: <5060AB0E.3070809@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12092420-3568-0000-0000-00000281C0B5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>

The CPU hotplug callback related to writeback calls writeback_set_ratelimit()
during every state change in the hotplug sequence. This is unnecessary
since num_online_cpus() changes only once during the entire hotplug operation.

So invoke the function only once per hotplug, thereby avoiding the
unnecessary repetition of those costly calculations.

Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
---

 mm/page-writeback.c |   14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index 5ad5ce2..830893b 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -1602,10 +1602,18 @@ void writeback_set_ratelimit(void)
 }
 
 static int __cpuinit
-ratelimit_handler(struct notifier_block *self, unsigned long u, void *v)
+ratelimit_handler(struct notifier_block *self, unsigned long action,
+		  void *hcpu)
 {
-	writeback_set_ratelimit();
-	return NOTIFY_DONE;
+
+	switch (action & ~CPU_TASKS_FROZEN) {
+	case CPU_ONLINE:
+	case CPU_DEAD:
+		writeback_set_ratelimit();
+		return NOTIFY_OK;
+	default:
+		return NOTIFY_DONE;
+	}
 }
 
 static struct notifier_block __cpuinitdata ratelimit_nb = {


