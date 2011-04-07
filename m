Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932339Ab1DGCHS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 22:07:18 -0400
Received: from hera.kernel.org ([140.211.167.34]:50965 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932205Ab1DGCHC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 22:07:02 -0400
Date: Thu, 7 Apr 2011 02:06:51 GMT
From: tip-bot for Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        yinghai@kernel.org, tj@kernel.org, tglx@linutronix.de,
        rientjes@google.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        yinghai@kernel.org, tj@kernel.org, tglx@linutronix.de,
        rientjes@google.com
In-Reply-To: <1301955840-7246-9-git-send-email-tj@kernel.org>
References: <1301955840-7246-9-git-send-email-tj@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/numa] x86-32, numa: Make init_alloc_remap() less panicky
Message-ID: <tip-82044c328d6f6b22882c2a936e487e6d2240817a@git.kernel.org>
Git-Commit-ID: 82044c328d6f6b22882c2a936e487e6d2240817a
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 07 Apr 2011 02:06:52 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  82044c328d6f6b22882c2a936e487e6d2240817a
Gitweb:     http://git.kernel.org/tip/82044c328d6f6b22882c2a936e487e6d2240817a
Author:     Tejun Heo <tj@kernel.org>
AuthorDate: Tue, 5 Apr 2011 00:23:54 +0200
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Wed, 6 Apr 2011 17:57:21 -0700

x86-32, numa: Make init_alloc_remap() less panicky

Remap allocator failure isn't fatal.  The callers are required to fall
back to regular early memory allocation mechanisms on failure anyway,
so there's no reason to panic on remap init failure.  Whining and
returning are enough.

Signed-off-by: Tejun Heo <tj@kernel.org>
Link: http://lkml.kernel.org/r/1301955840-7246-9-git-send-email-tj@kernel.org
Acked-by: Yinghai Lu <yinghai@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
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
