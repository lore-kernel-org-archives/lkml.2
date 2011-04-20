Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754442Ab1DTLfE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 07:35:04 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:60960 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752849Ab1DTLfD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 07:35:03 -0400
From: Richard Weinberger <richard@nod.at>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, user-mode-linux-devel@lists.sourceforge.net,
        Richard Weinberger <richard@nod.at>
Subject: [PATCH 1/3] um: Adjust current_thread_info() for gcc-4.6
Date: Wed, 20 Apr 2011 13:34:24 +0200
Message-Id: <1303299266-10219-1-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.7.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In some cases gcc-4.6 will optimize away current_thread_info().
To prevent gcc from doing so the stack address has to be obtained
via inline asm.

LKML-Reference: http://marc.info/?i=201104132150.05623.richard@nod.at

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

