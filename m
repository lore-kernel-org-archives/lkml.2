Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753571Ab1G0AfG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 20:35:06 -0400
Received: from mga01.intel.com ([192.55.52.88]:6474 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753482Ab1G0Ae7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 20:34:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,272,1309762800"; 
   d="scan'208";a="32659161"
From: Andi Kleen <andi@firstfloor.org>
References: <20110726534.972201586@firstfloor.org>
In-Reply-To: <20110726534.972201586@firstfloor.org>
To: jim876@xs4all.nl, andi@firstfloor.org, schwab@linux-m68k.org,
        torvalds@linux-foundation.org, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org, tim.bird@am.sony.com,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH] [7/98] i8k: Tell gcc that *regs gets clobbered
Message-Id: <20110727003459.1BD952403FF@tassilo.jf.intel.com>
Date: Tue, 26 Jul 2011 17:34:59 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Jim Bos <jim876@xs4all.nl>

[ upstream commit 6b4e81db2552bad04100e7d5ddeed7e848f53b48 ]

More recent GCC caused the i8k driver to stop working, on Slackware
compiler was upgraded from gcc-4.4.4 to gcc-4.5.1 after which it didn't
work anymore, meaning the driver didn't load or gave total nonsensical
output.

As it turned out the asm(..) statement forgot to mention it modifies the
*regs variable.

Credits to Andi Kleen and Andreas Schwab for providing the fix.

Signed-off-by: Jim Bos <jim876@xs4all.nl>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Andreas Schwab <schwab@linux-m68k.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

Index: linux-2.6.35.y/drivers/char/i8k.c
===================================================================
--- linux-2.6.35.y.orig/drivers/char/i8k.c
+++ linux-2.6.35.y/drivers/char/i8k.c
@@ -141,7 +141,7 @@ static int i8k_smm(struct smm_regs *regs
 		"lahf\n\t"
 		"shrl $8,%%eax\n\t"
 		"andl $1,%%eax\n"
-		:"=a"(rc)
+		:"=a"(rc), "+m" (*regs)
 		:    "a"(regs)
 		:    "%ebx", "%ecx", "%edx", "%esi", "%edi", "memory");
 #else
@@ -166,7 +166,8 @@ static int i8k_smm(struct smm_regs *regs
 	    "movl %%edx,0(%%eax)\n\t"
 	    "lahf\n\t"
 	    "shrl $8,%%eax\n\t"
-	    "andl $1,%%eax\n":"=a"(rc)
+	    "andl $1,%%eax\n"
+	    :"=a"(rc), "+m" (*regs)
 	    :    "a"(regs)
 	    :    "%ebx", "%ecx", "%edx", "%esi", "%edi", "memory");
 #endif
