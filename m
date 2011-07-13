Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965414Ab1GMSIJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jul 2011 14:08:09 -0400
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:60766 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964838Ab1GMSIF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jul 2011 14:08:05 -0400
Subject: [RFC PATCH 07/10] fadump: Introduce cleanup routine to invalidate
	/proc/vmcore.
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
From: Mahesh J Salgaonkar <mahesh@linux.vnet.ibm.com>
Cc: Michael Ellerman <michael@ellerman.id.au>, Haren Myneni <hbabu@us.ibm.com>,
        Anton Blanchard <anton@samba.org>, Milton Miller <miltonm@bga.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Date: Wed, 13 Jul 2011 23:38:00 +0530
Message-ID: <20110713180751.6210.64850.stgit@mars.in.ibm.com>
In-Reply-To: <20110713180252.6210.34810.stgit@mars.in.ibm.com>
References: <20110713180252.6210.34810.stgit@mars.in.ibm.com>
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
 fs/proc/vmcore.c |   20 ++++++++++++++++++++
 1 files changed, 20 insertions(+), 0 deletions(-)

diff --git a/fs/proc/vmcore.c b/fs/proc/vmcore.c
index cd99bf5..1aa3d7b 100644
--- a/fs/proc/vmcore.c
+++ b/fs/proc/vmcore.c
@@ -699,3 +699,23 @@ static int __init vmcore_init(void)
 	return 0;
 }
 module_init(vmcore_init)
+
+/* Cleanup function for vmcore module. */
+void vmcore_cleanup(void)
+{
+	struct list_head *pos, *next;
+
+	if (proc_vmcore)
+		remove_proc_entry(proc_vmcore->name, proc_vmcore->parent);
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
+}
+EXPORT_SYMBOL_GPL(vmcore_cleanup);

