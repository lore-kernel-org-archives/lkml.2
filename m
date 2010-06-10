Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758959Ab0FJLON (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 07:14:13 -0400
Received: from one.firstfloor.org ([213.235.205.2]:39169 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758830Ab0FJLKq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 07:10:46 -0400
From: Andi Kleen <andi@firstfloor.org>
References: <20100610110.764742110@firstfloor.org>
In-Reply-To: <20100610110.764742110@firstfloor.org>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [9/23] PRINTK: Use stable variable to dump kmsg buffer
Message-Id: <20100610111045.13CE3B1A2B@basil.firstfloor.org>
Date: Thu, 10 Jun 2010 13:10:45 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


kmsg_dump takes care to sample the global variables
inside a spinlock, but then goes on to use the same
variables outside the spinlock region too.

Use the correct variable. This will make the race
window smaller.

Found by gcc 4.6's new warnings.

Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 kernel/printk.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

Index: linux-2.6.35-rc2-gcc/kernel/printk.c
===================================================================
--- linux-2.6.35-rc2-gcc.orig/kernel/printk.c
+++ linux-2.6.35-rc2-gcc/kernel/printk.c
@@ -1520,9 +1520,9 @@ void kmsg_dump(enum kmsg_dump_reason rea
 	chars = logged_chars;
 	spin_unlock_irqrestore(&logbuf_lock, flags);
 
-	if (logged_chars > end) {
-		s1 = log_buf + log_buf_len - logged_chars + end;
-		l1 = logged_chars - end;
+	if (chars > end) {
+		s1 = log_buf + log_buf_len - chars + end;
+		l1 = chars - end;
 
 		s2 = log_buf;
 		l2 = end;
@@ -1530,8 +1530,8 @@ void kmsg_dump(enum kmsg_dump_reason rea
 		s1 = "";
 		l1 = 0;
 
-		s2 = log_buf + end - logged_chars;
-		l2 = logged_chars;
+		s2 = log_buf + end - chars;
+		l2 = chars;
 	}
 
 	if (!spin_trylock_irqsave(&dump_list_lock, flags)) {
