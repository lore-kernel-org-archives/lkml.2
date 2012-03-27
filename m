Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754374Ab2C0Nvk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 09:51:40 -0400
Received: from smtp.citrix.com ([66.165.176.89]:13453 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753505Ab2C0Nvh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 09:51:37 -0400
X-IronPort-AV: E=Sophos;i="4.75,326,1330923600"; 
   d="scan'208";a="23540287"
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
To: konrad.wilk@oracle.com
CC: Stefano.Stabellini@eu.citrix.com, linux-kernel@vger.kernel.org,
        xen-devel@lists.xensource.com,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: [PATCH 2/2] m2p_find_override: use list_for_each_entry_safe
Date: Tue, 27 Mar 2012 14:52:44 +0100
Message-ID: <1332856364-29995-2-git-send-email-stefano.stabellini@eu.citrix.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1332856364-29995-1-git-send-email-stefano.stabellini@eu.citrix.com>
References: <1332856364-29995-1-git-send-email-stefano.stabellini@eu.citrix.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use list_for_each_entry_safe and remove the spin_lock acquisition in
m2p_find_override.

Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
---
 arch/x86/xen/p2m.c |    8 ++------
 1 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/arch/x86/xen/p2m.c b/arch/x86/xen/p2m.c
index 1b267e7..7ed8cc3 100644
--- a/arch/x86/xen/p2m.c
+++ b/arch/x86/xen/p2m.c
@@ -809,21 +809,17 @@ struct page *m2p_find_override(unsigned long mfn)
 {
 	unsigned long flags;
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

