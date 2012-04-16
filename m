Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754830Ab2DPPbO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 11:31:14 -0400
Received: from mail.windriver.com ([147.11.1.11]:64803 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754271Ab2DPPbN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 11:31:13 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: linux-kernel@vger.kernel.org
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] pagemap.h: fix warning about possibly used before init var
Date: Mon, 16 Apr 2012 11:31:01 -0400
Message-Id: <1334590261-20310-1-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit f56f821feb7b36223f309e0ec05986bb137ce418 (linux-next)

    "mm: extend prefault helpers to fault in more than PAGE_SIZE"

added in the new functions:

	fault_in_multipages_writeable
	fault_in_multipages_readable

However, we currently see:

  include/linux/pagemap.h:492: warning: 'ret' may be used uninitialized in this function
  include/linux/pagemap.h:492: note: 'ret' was declared here

Unlike a lot of gcc nags, this one appears somewhat legit.
i.e. passing in an invalid negative value of "size" does make
it look like all the conditionals in there would be bypassed and
the uninitialized value would be returned.

Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---

[should we be more proactive guarding against negative size values?]

diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index efa26b4..7cfad3b 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -460,11 +460,11 @@ static inline int fault_in_pages_readable(const char __user *uaddr, int size)
  */
 static inline int fault_in_multipages_writeable(char __user *uaddr, int size)
 {
-	int ret;
+	int ret = 0;
 	char __user *end = uaddr + size - 1;
 
 	if (unlikely(size == 0))
-		return 0;
+		return ret;
 
 	/*
 	 * Writing zeroes into userspace here is OK, because we know that if
@@ -489,11 +489,11 @@ static inline int fault_in_multipages_readable(const char __user *uaddr,
 					       int size)
 {
 	volatile char c;
-	int ret;
+	int ret = 0;
 	const char __user *end = uaddr + size - 1;
 
 	if (unlikely(size == 0))
-		return 0;
+		return ret;
 
 	while (uaddr <= end) {
 		ret = __get_user(c, uaddr);
-- 
1.7.9.1

