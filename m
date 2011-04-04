Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755938Ab1DDWZ4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Apr 2011 18:25:56 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:46324 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755853Ab1DDWYR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Apr 2011 18:24:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=goQxGTkoYJ2sj0G+vVk/q8yw/Bz9ZQhqDoT7Id+8Z5tMLqzuALTb06QgqiOm2XflZm
         inxIZihaR3l733PdHv93239K9G5WVaZA/ALbxaRDV/q/hw8TAeZEi/RV1+utuGywpEyW
         h7BfqmQN5z3iGLPPd0+KORWQhCOg2Kz7gTPX0=
From: Tejun Heo <tj@kernel.org>
To: mingo@redhat.com, hpa@zytor.com, tglx@linutronix.de, rientjes@google.com,
        yinghai@kernel.org, linux-kernel@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 08/14] x86-32, NUMA: Make init_alloc_remap() less panicky
Date: Tue,  5 Apr 2011 00:23:54 +0200
Message-Id: <1301955840-7246-9-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1301955840-7246-1-git-send-email-tj@kernel.org>
References: <1301955840-7246-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remap allocator failure isn't fatal.  The callers are required to fall
back to regular early memory allocation mechanisms on failure anyway,
so there's no reason to panic on remap init failure.  Whining and
returning are enough.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
---
 arch/x86/mm/numa_32.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/arch/x86/mm/numa_32.c b/arch/x86/mm/numa_32.c
index 9a73365..c127543 100644
--- a/arch/x86/mm/numa_32.c
+++ b/arch/x86/mm/numa_32.c
@@ -290,8 +290,11 @@ static __init unsigned long init_alloc_remap(int nid, unsigned long offset)
 	node_pa = memblock_find_in_range(node_start_pfn[nid] << PAGE_SHIFT,
 					 (u64)node_end_pfn[nid] << PAGE_SHIFT,
 					 size, LARGE_PAGE_BYTES);
-	if (node_pa == MEMBLOCK_ERROR)
-		panic("Can not get kva ram\n");
+	if (node_pa == MEMBLOCK_ERROR) {
+		pr_warning("remap_alloc: failed to allocate %lu bytes for node %d\n",
+			   size, nid);
+		return 0;
+	}
 
 	node_remap_size[nid] = size >> PAGE_SHIFT;
 	node_remap_offset[nid] = offset;
-- 
1.7.1

