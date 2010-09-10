Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756799Ab0IJFbZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 01:31:25 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:58948 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756503Ab0IJFbY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 01:31:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=xSwG0/s3aZta8AbCIYRoZa3e+8SMWntnybfL57uYQ+4nXYpxl7GjSlWIgRCOeoKMHE
         V+bBDv74BKSprGpedsdisEG/B+RNRflPV8BBhvv/aBoIoj/7o+EXxGcRIdCKE6VH3MHR
         nFnCiO4u3KYAbBowON+WZeZTh3AgrRIp6mAJM=
From: Brian Gerst <brgerst@gmail.com>
To: tj@kernel.org
Cc: linux-kernel@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>
Subject: [PATCH] x86, percpu: Fix __this_cpu_ptr with const pointers
Date: Fri, 10 Sep 2010 01:31:04 -0400
Message-Id: <1284096664-4539-1-git-send-email-brgerst@gmail.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <20100910124543.3e8604fd.sfr@canb.auug.org.au>
References: <20100910124543.3e8604fd.sfr@canb.auug.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix this error when the pointer is marked const:
error: read-only variable 'tcp_ptr__' used as 'asm' output

Signed-off-by: Brian Gerst <brgerst@gmail.com>
CC: Stephen Rothwell <sfr@canb.auug.org.au>
---
 arch/x86/include/asm/percpu.h |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/percpu.h b/arch/x86/include/asm/percpu.h
index fe418dd..f62b52c 100644
--- a/arch/x86/include/asm/percpu.h
+++ b/arch/x86/include/asm/percpu.h
@@ -54,12 +54,12 @@
  */
 #define __this_cpu_ptr(ptr)				\
 ({							\
-	typeof(ptr) tcp_ptr__ = (ptr);			\
+	unsigned long tcp_ptr__;			\
 	__verify_pcpu_ptr(ptr);				\
 	asm volatile("add " __percpu_arg(1) ", %0"	\
-		     : "+r" (tcp_ptr__)			\
-		     : "m" (this_cpu_off));		\
-	tcp_ptr__;					\
+		     : "=r" (tcp_ptr__)			\
+		     : "m" (this_cpu_off), "0" (ptr));	\
+	(typeof(ptr) __kernel __force) tcp_ptr__;	\
 })
 #else
 #define __percpu_arg(x)		"%P" #x
-- 
1.7.2.2

