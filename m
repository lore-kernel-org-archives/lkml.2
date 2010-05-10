Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754557Ab0EJNIA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 09:08:00 -0400
Received: from mail-pz0-f204.google.com ([209.85.222.204]:47075 "EHLO
	mail-pz0-f204.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754322Ab0EJNH7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 09:07:59 -0400
MIME-Version: 1.0
Date: Mon, 10 May 2010 16:07:57 +0300
Message-ID: <AANLkTikIbI6hKoYSZlo6QDlyi2Qjxg287i-ilHpz1FF9@mail.gmail.com>
Subject: [PATCH] Handle instruction cache maintenance fault properly
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Russell King <linux@arm.linux.org.uk>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
       Siarhei Siamashka <siarhei.siamashka@nokia.com>,
       linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
       Aaro Koskinen <aaro.koskinen@nokia.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Between "clean D line..." and "invalidate I line" operations in
v7_coherent_user_range(), the memory page may get swapped out.
And the fault on "invalidate I line" could not be properly handled
causing the oops.

The patch adds the missing handling for "instruction cache
maintenance fault". Let's handle it as translation fault.

Signed-off-by: Siarhei Siamashka <siarhei.siamashka@nokia.com>
Signed-off-by: Kirill A. Shutemov <kirill@shutemov.name>
---
 arch/arm/mm/fault.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mm/fault.c b/arch/arm/mm/fault.c
index 9d40c34..8924617 100644
--- a/arch/arm/mm/fault.c
+++ b/arch/arm/mm/fault.c
@@ -463,7 +463,7 @@ static struct fsr_info {
 	{ do_bad,		SIGILL,	 BUS_ADRALN,	"alignment exception"		   },
 	{ do_bad,		SIGKILL, 0,		"terminal exception"		   },
 	{ do_bad,		SIGILL,	 BUS_ADRALN,	"alignment exception"		   },
-	{ do_bad,		SIGBUS,	 0,		"external abort on linefetch"	   },
+	{ do_translation_fault,	SIGSEGV, SEGV_MAPPER,	"I-cache maintenance
fault"	   },
 	{ do_translation_fault,	SIGSEGV, SEGV_MAPERR,	"section translation
fault"	   },
 	{ do_bad,		SIGBUS,	 0,		"external abort on linefetch"	   },
 	{ do_page_fault,	SIGSEGV, SEGV_MAPERR,	"page translation fault"	   },
-- 
1.7.0.4
