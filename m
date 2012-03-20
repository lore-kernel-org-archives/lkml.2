Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755520Ab2CTJd5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 05:33:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45777 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753443Ab2CTJdz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 05:33:55 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1332212514-22071-1-git-send-email-gxt@mprc.pku.edu.cn>
References: <1332212514-22071-1-git-send-email-gxt@mprc.pku.edu.cn> <7019.1332155925@redhat.com>
To: Guan Xuetao <gxt@mprc.pku.edu.cn>
Cc: dhowells@redhat.com, paul.gortmaker@windriver.com,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        arnd@arndb.de
Subject: Re: [PATCH] Disintegrate asm/system.h for Unicore32 [based on ver #3, changed by gxt]
Date: Tue, 20 Mar 2012 09:33:40 +0000
Message-ID: <14078.1332236020@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Guan Xuetao <gxt@mprc.pku.edu.cn> wrote:

> Disintegrate asm/system.h for Unicore32. (Compilation successful)
> The implementation details are not changed, but only splitted.
> BTW, some codestyles are adjusted.
> 
> Signed-off-by: David Howells <dhowells@redhat.com>
> Signed-off-by: Guan Xuetao <gxt@mprc.pku.edu.cn>

Aha!  Much better.  It mostly looks reasonable, apart from one thing.  See the
attached patch, which I'll roll in if you're happy with it.

David
---
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] Fix unicore xchg() to fail at build time with an unsupported pointer

Fix unicore xchg() to fail at build time with an unsupported pointer rather
then using panic().

Additionally, panic() should not be redeclared in this manner, but rather
should be brought in by #inclusion of <linux/kernel.h>.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 arch/unicore32/include/asm/cmpxchg.h |   10 +++++++---
 1 files changed, 7 insertions(+), 3 deletions(-)


diff --git a/arch/unicore32/include/asm/cmpxchg.h b/arch/unicore32/include/asm/cmpxchg.h
index 37c431d..f39a59d 100644
--- a/arch/unicore32/include/asm/cmpxchg.h
+++ b/arch/unicore32/include/asm/cmpxchg.h
@@ -10,7 +10,11 @@
 #ifndef __UNICORE_CMPXCHG_H__
 #define __UNICORE_CMPXCHG_H__
 
-extern void panic(const char *fmt, ...);
+/*
+ * Generate a link failure on undefined symbol if the pointer points to a value
+ * of unsupported size.
+ */
+extern void __xchg_bad_pointer(void)
 
 static inline unsigned long __xchg(unsigned long x, volatile void *ptr,
 		int size)
@@ -31,8 +35,8 @@ static inline unsigned long __xchg(unsigned long x, volatile void *ptr,
 			: "memory", "cc");
 		break;
 	default:
-		panic("xchg: bad data size: ptr 0x%p, size %d\n",
-			ptr, size);
+		__xchg_bad_pointer();
+		break;
 	}
 
 	return ret;

