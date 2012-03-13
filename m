Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758860Ab2CMAxA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 20:53:00 -0400
Received: from mail.windriver.com ([147.11.1.11]:47978 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758808Ab2CMAXA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 20:23:00 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        James Bottomley <James.Bottomley@suse.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 099/196] slub: fix panic with DISCONTIGMEM
Date: Mon, 12 Mar 2012 20:20:12 -0400
Message-Id: <1331598109-31424-54-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.3
In-Reply-To: <1331598109-31424-1-git-send-email-paul.gortmaker@windriver.com>
References: <1331597724-31358-1-git-send-email-paul.gortmaker@windriver.com>
 <1331598109-31424-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: James Bottomley <James.Bottomley@HansenPartnership.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 4a5fa3590f09999f6db41bc386bce40848fa9f63 upstream.

Slub makes assumptions about page_to_nid() which are violated by
DISCONTIGMEM and !NUMA.  This violation results in a panic because
page_to_nid() can be non-zero for pages in the discontiguous ranges and
this leads to a null return by get_node().  The assertion by the
maintainer is that DISCONTIGMEM should only be allowed when NUMA is also
defined.  However, at least six architectures: alpha, ia64, m32r, m68k,
mips, parisc violate this.  The panic is a regression against slab, so
just mark slub broken in the problem configuration to prevent users
reporting these panics.

Acked-by: David Rientjes <rientjes@google.com>
Acked-by: Pekka Enberg <penberg@kernel.org>
Signed-off-by: James Bottomley <James.Bottomley@suse.de>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 init/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff --git a/init/Kconfig b/init/Kconfig
index 5fe94b8..04e486cf 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -1052,6 +1052,7 @@ config SLAB
 	  per cpu and per node queues.
 
 config SLUB
+	depends on BROKEN || NUMA || !DISCONTIGMEM
 	bool "SLUB (Unqueued Allocator)"
 	help
 	   SLUB is a slab allocator that minimizes cache line usage
-- 
1.7.9.3

