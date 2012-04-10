Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754899Ab2DJQ0A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 12:26:00 -0400
Received: from smtp.citrix.com ([66.165.176.89]:37184 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751305Ab2DJQZ7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 12:25:59 -0400
X-IronPort-AV: E=Sophos;i="4.75,399,1330923600"; 
   d="scan'208";a="24030725"
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
To: konrad.wilk@oracle.com
CC: Stefano.Stabellini@eu.citrix.com, xen-devel@lists.xensource.com,
        linux-kernel@vger.kernel.org,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: [PATCH v3 2/2] m2p_find_override: use list_for_each_entry_safe
Date: Tue, 10 Apr 2012 17:29:35 +0100
Message-ID: <1334075375-25442-2-git-send-email-stefano.stabellini@eu.citrix.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1334075375-25442-1-git-send-email-stefano.stabellini@eu.citrix.com>
References: <1334075375-25442-1-git-send-email-stefano.stabellini@eu.citrix.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use list_for_each_entry_safe and remove the spin_lock acquisition in
m2p_find_override: getting stale entries is OK because we should never
get an m2p_find_override call looking for an entry that we are about to
add or delete.

Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
---
 arch/x86/xen/p2m.c |    9 ++-------
 1 files changed, 2 insertions(+), 7 deletions(-)

diff --git a/arch/x86/xen/p2m.c b/arch/x86/xen/p2m.c
index 7ece122..9092278 100644
--- a/arch/x86/xen/p2m.c
+++ b/arch/x86/xen/p2m.c
@@ -808,23 +808,18 @@ EXPORT_SYMBOL_GPL(m2p_remove_override);
 
 struct page *m2p_find_override(unsigned long mfn)
 {
-	unsigned long flags;
 	struct list_head *bucket = &m2p_overrides[mfn_hash(mfn)];
-	struct page *p, *ret;
+	struct page *p, *t, *ret;
 
 	ret = NULL;
 
-	spin_lock_irqsave(&m2p_override_lock, flags);
-
-	list_for_each_entry(p, bucket, lru) {
+	list_for_each_entry_safe(p, t, bucket, lru) {
 		if (page_private(p) == mfn) {
 			ret = p;
 			break;
 		}
 	}
 
-	spin_unlock_irqrestore(&m2p_override_lock, flags);
-
 	return ret;
 }
 
-- 
1.7.2.5

