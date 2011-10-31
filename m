Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933123Ab1JaRL5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Oct 2011 13:11:57 -0400
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:35133 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932789Ab1JaRL4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Oct 2011 13:11:56 -0400
Subject: [RFC PATCH v3 07/10] fadump: Introduce cleanup routine to invalidate
	/proc/vmcore.
To: linuxppc-dev <linuxppc-dev@ozlabs.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
From: Mahesh J Salgaonkar <mahesh@linux.vnet.ibm.com>
Cc: Haren Myneni <hbabu@us.ibm.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Amerigo Wang <amwang@redhat.com>, Milton Miller <miltonm@bga.com>,
        Anton Blanchard <anton@samba.org>
Date: Mon, 31 Oct 2011 22:41:03 +0530
Message-ID: <20111031171103.12259.49019.stgit@mars.in.ibm.com>
In-Reply-To: <20111031170200.12259.27663.stgit@mars.in.ibm.com>
References: <20111031170200.12259.27663.stgit@mars.in.ibm.com>
User-Agent: StGit/0.15-1-ged5e-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mahesh Salgaonkar <mahesh@linux.vnet.ibm.com>

With the firmware-assisted dump support we don't require a reboot when we
are in second kernel after crash. The second kernel after crash is a normal
kernel boot and has knowledge about entire system RAM with the page tables
initialized for entire system RAM. Hence once the dump is saved to disk, we
can just release the reserved memory area for general use and continue
with second kernel as production kernel.

Hence when we release the reserved memory that contains dump data, the
'/proc/vmcore' will not be valid anymore. Hence this patch introduces
a cleanup routine that invalidates and removes the /proc/vmcore file. This
routine will be invoked before we release the reserved dump memory area.

Signed-off-by: Mahesh Salgaonkar <mahesh@linux.vnet.ibm.com>
---
 fs/proc/vmcore.c |   23 +++++++++++++++++++++++
 1 files changed, 23 insertions(+), 0 deletions(-)

diff --git a/fs/proc/vmcore.c b/fs/proc/vmcore.c
index cd99bf5..fae5526 100644
--- a/fs/proc/vmcore.c
+++ b/fs/proc/vmcore.c
@@ -699,3 +699,26 @@ static int __init vmcore_init(void)
 	return 0;
 }
 module_init(vmcore_init)
+
+/* Cleanup function for vmcore module. */
+void vmcore_cleanup(void)
+{
+	struct list_head *pos, *next;
+
+	if (proc_vmcore) {
+		remove_proc_entry(proc_vmcore->name, proc_vmcore->parent);
+		proc_vmcore = NULL;
+	}
+
+	/* clear the vmcore list. */
+	list_for_each_safe(pos, next, &vmcore_list) {
+		struct vmcore *m;
+
+		m = list_entry(pos, struct vmcore, list);
+		list_del(&m->list);
+		kfree(m);
+	}
+	kfree(elfcorebuf);
+	elfcorebuf = NULL;
+}
+EXPORT_SYMBOL_GPL(vmcore_cleanup);

