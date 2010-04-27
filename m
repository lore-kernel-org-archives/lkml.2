Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752941Ab0D0HEe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 03:04:34 -0400
Received: from mga02.intel.com ([134.134.136.20]:9174 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751092Ab0D0HEd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 03:04:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.52,278,1270450800"; 
   d="scan'208";a="512783231"
Subject: [PATCH 1/2] mm, Make __get_user_pages return -EHWPOISON for
 HWPOISON page
From: Huang Ying <ying.huang@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Andi Kleen <andi@firstfloor.org>, Avi Kivity <avi@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 27 Apr 2010 15:04:18 +0800
Message-ID: <1272351858.24125.14.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With this patch, the caller of __get_user_pages can distinguish
HWPOISON page from general FAULT page. This is needed by KVM, where
UCR MCE should be relayed to guest for HWPOISON page, while
instruction emulation and MMIO will be tried for general FAULT page.

Signed-off-by: Huang Ying <ying.huang@intel.com>
---
 include/asm-generic/errno.h |    2 ++
 mm/memory.c                 |    5 +++--
 2 files changed, 5 insertions(+), 2 deletions(-)

--- a/include/asm-generic/errno.h
+++ b/include/asm-generic/errno.h
@@ -108,4 +108,6 @@
 
 #define ERFKILL		132	/* Operation not possible due to RF-kill */
 
+#define EHWPOISON	133	/* Memory page has hardware error */
+
 #endif
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -1432,9 +1432,10 @@ int __get_user_pages(struct task_struct
 				if (ret & VM_FAULT_ERROR) {
 					if (ret & VM_FAULT_OOM)
 						return i ? i : -ENOMEM;
-					if (ret &
-					    (VM_FAULT_HWPOISON|VM_FAULT_SIGBUS))
+					if (ret & VM_FAULT_SIGBUS)
 						return i ? i : -EFAULT;
+					if (ret & VM_FAULT_HWPOISON)
+						return i ? i : -EHWPOISON;
 					BUG();
 				}
 				if (ret & VM_FAULT_MAJOR)


