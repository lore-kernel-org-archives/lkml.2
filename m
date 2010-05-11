Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753318Ab0EKKdQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 06:33:16 -0400
Received: from mail-pz0-f204.google.com ([209.85.222.204]:56058 "EHLO
	mail-pz0-f204.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751102Ab0EKKdP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 06:33:15 -0400
MIME-Version: 1.0
Date: Tue, 11 May 2010 13:33:14 +0300
Message-ID: <AANLkTilVp0xvAJNns3TEe4SzEUpN8hMC9DdwmwW7i9yX@mail.gmail.com>
Subject: [PATCH v2] [RESEND] Handle instruction cache maintenance fault 
	properly
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Russell King <linux@arm.linux.org.uk>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
       Siarhei Siamashka <siarhei.siamashka@nokia.com>,
       linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
       Aaro Koskinen <aaro.koskinen@nokia.com>, Valdis.Kletnieks@vt.edu
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Between "clean D line..." and "invalidate I line" operations in
v7_coherent_user_range(), the memory page may get swapped out.
And the fault on "invalidate I line" could not be properly handled
causing the oops.

In ARMv6 "external abort on linefetch" replaced by "instruction cache
maintenance fault". Let's handle it as translation fault. It fixes the
issue.

I'm not sure if it's reasonable to check arch version in run-time.
Let's do it in compile time for now.

Signed-off-by: Siarhei Siamashka <siarhei.siamashka@nokia.com>
Signed-off-by: Kirill A. Shutemov <kirill@shutemov.name>
---

Sorry for resend. I've made mistake in maillist address.

---
 arch/arm/mm/fault.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mm/fault.c b/arch/arm/mm/fault.c
index 9d40c34..7f193ea 100644
--- a/arch/arm/mm/fault.c
+++ b/arch/arm/mm/fault.c
@@ -463,7 +463,12 @@ static struct fsr_info {
 	{ do_bad,		SIGILL,	 BUS_ADRALN,	"alignment exception"		   },
 	{ do_bad,		SIGKILL, 0,		"terminal exception"		   },
 	{ do_bad,		SIGILL,	 BUS_ADRALN,	"alignment exception"		   },
+/* Do we need runtime check ? */
+#if __LINUX_ARM_ARCH__ < 6
 	{ do_bad,		SIGBUS,	 0,		"external abort on linefetch"	   },
+#else
+	{ do_translation_fault,	SIGSEGV, SEGV_MAPPER,	"I-cache maintenance
fault"	   },
+#endif
 	{ do_translation_fault,	SIGSEGV, SEGV_MAPERR,	"section translation
fault"	   },
 	{ do_bad,		SIGBUS,	 0,		"external abort on linefetch"	   },
 	{ do_page_fault,	SIGSEGV, SEGV_MAPERR,	"page translation fault"	   },
-- 
1.7.0.4
