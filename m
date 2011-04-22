Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754930Ab1DVKU4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Apr 2011 06:20:56 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:60098 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754891Ab1DVKUu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Apr 2011 06:20:50 -0400
From: Richard Weinberger <richard@nod.at>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, user-mode-linux-devel@lists.sourceforge.net,
        kirill@shutemov.name, Richard Weinberger <richard@nod.at>
Subject: [PATCH] um: Adjust current_thread_info() for newer gcc versions
Date: Fri, 22 Apr 2011 12:20:14 +0200
Message-Id: <1303467614-7585-1-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.7.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In some cases gcc >= 4.5.2 will optimize away current_thread_info().
To prevent gcc from doing so the stack address has to be obtained
via inline asm.

LKML-Reference: http://marc.info/?i=201104132150.05623.richard@nod.at

Acked-by: Kirill A. Shutemov <kirill@shutemov.name>
Signed-off-by: Richard Weinberger <richard@nod.at>
---
 arch/um/include/asm/thread_info.h |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/arch/um/include/asm/thread_info.h b/arch/um/include/asm/thread_info.h
index e2cf786..5bd1bad 100644
--- a/arch/um/include/asm/thread_info.h
+++ b/arch/um/include/asm/thread_info.h
@@ -49,7 +49,10 @@ static inline struct thread_info *current_thread_info(void)
 {
 	struct thread_info *ti;
 	unsigned long mask = THREAD_SIZE - 1;
-	ti = (struct thread_info *) (((unsigned long) &ti) & ~mask);
+	void *p;
+
+	asm volatile ("" : "=r" (p) : "0" (&ti));
+	ti = (struct thread_info *) (((unsigned long)p) & ~mask);
 	return ti;
 }
 
-- 
1.7.4.2

