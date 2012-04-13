Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756903Ab2DMVCx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 17:02:53 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:60530 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755925Ab2DMVCv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 17:02:51 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: [PATCH][RESEND] do not redefine userspace's NULL #define
Date: Fri, 13 Apr 2012 21:02:14 +0000
User-Agent: KMail/1.12.2 (Linux/3.3.0-rc1; KDE/4.3.2; x86_64; ; )
Cc: Lubos Lunak <l.lunak@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
References: <201204132124.21294.l.lunak@suse.cz> <CA+55aFxCrVtwCd9bjHLt82Uwisp8OtKP9c+raPYMqCTXqVfxGw@mail.gmail.com>
In-Reply-To: <CA+55aFxCrVtwCd9bjHLt82Uwisp8OtKP9c+raPYMqCTXqVfxGw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201204132102.14873.arnd@arndb.de>
X-Provags-ID: V02:K0:p5EO9cYDiD4KRLb5HadgE2dajW8uKyoy5hUJ4Ocms8D
 FYy46iF0MtqR3oBIULsQFJUl8AF5te/xI3EkhMcw+FRraZsH3q
 e/obhTbsEtSeWIErCensbOqaqFrrfgFhK1Z0pRSIZsvfFs5cyi
 x2I1CwJTpBO2gQlj90pa9bSqPS2CkRInc+88dj0/1HIe93rMJO
 lQI3PiwbGLN//zhXtZ1D+S2tpoYYLTA8boDzAjJ0lS3CC7TDSn
 fU1VQ3wnHbrU8FVz09amlQ5nb+OOWCABKNpAfhpxejtVf4sxeN
 9YhsfjbUZmd5J+F1oIzMlseflOe7lN0U3j2J0oX2Ix6JFYVTRa
 bIRrPYOspBXQ/FYfi8N0=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 13 April 2012, Linus Torvalds wrote:
> There's no way user should ever include the linux internal stddef.h.
> 
> And quite frankly, kernel-external definitions of NULL have
> traditionally been pure sh*t (ie plain "0" without the cast to a
> pointer), so I'm not entirely convinced about this patch.
> 
> So what is the actual thing this helps with?

I think it used to get included implictly though other exported
kernel headers, but I found only one instance where this is still
true, in the s390 version of asm/ptrace.h.

Martin, does this work for you?

8<-----
headers: do not export linux/stddef.h

There is no reason to export linux/stddef.h and users should never
include it because the header conflicts with the standard stddef.h.

The only other exported header file that actually includes linux/stddef.h
is the s390 asm/ptrace.h, but there is no reason for it to do so, so
we can remove both the export and the inclusion.
When the file is no longer exported, we can also remove the extra lines
that attempt to make it safe for inclusion

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/s390/include/asm/ptrace.h |    1 -
 include/linux/Kbuild           |    1 -
 include/linux/stddef.h         |    8 --------
 3 files changed, 0 insertions(+), 10 deletions(-)

diff --git a/arch/s390/include/asm/ptrace.h b/arch/s390/include/asm/ptrace.h
index aeb77f0..e2acdd5 100644
--- a/arch/s390/include/asm/ptrace.h
+++ b/arch/s390/include/asm/ptrace.h
@@ -183,7 +183,6 @@
 #define PTRACE_OLDSETOPTIONS         21
 
 #ifndef __ASSEMBLY__
-#include <linux/stddef.h>
 #include <linux/types.h>
 
 typedef union
diff --git a/include/linux/Kbuild b/include/linux/Kbuild
index 3c9b616..96391c7 100644
--- a/include/linux/Kbuild
+++ b/include/linux/Kbuild
@@ -351,7 +351,6 @@ header-y += sonypi.h
 header-y += sound.h
 header-y += soundcard.h
 header-y += stat.h
-header-y += stddef.h
 header-y += string.h
 header-y += suspend_ioctls.h
 header-y += swab.h
diff --git a/include/linux/stddef.h b/include/linux/stddef.h
index 6a40c76..daf42b8 100644
--- a/include/linux/stddef.h
+++ b/include/linux/stddef.h
@@ -3,14 +3,7 @@
 
 #include <linux/compiler.h>
 
-#undef NULL
-#if defined(__cplusplus)
-#define NULL 0
-#else
 #define NULL ((void *)0)
-#endif
-
-#ifdef __KERNEL__
 
 enum {
 	false	= 0,
@@ -23,6 +16,5 @@ enum {
 #else
 #define offsetof(TYPE, MEMBER) ((size_t) &((TYPE *)0)->MEMBER)
 #endif
-#endif /* __KERNEL__ */
 
 #endif
