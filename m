Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753475Ab1DOXD1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Apr 2011 19:03:27 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:58713 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753135Ab1DOXD0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Apr 2011 19:03:26 -0400
From: Richard Weinberger <richard@nod.at>
To: linux-kernel@vger.kernel.org
Cc: user-mode-linux-devel@lists.sourceforge.net,
        Richard Weinberger <richard@nod.at>
Subject: [PATCH] um: Adjust current_thread_info() for gcc-4.6
Date: Sat, 16 Apr 2011 01:03:13 +0200
Message-Id: <1302908593-4374-1-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.6.6.1
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
1.6.6.1

