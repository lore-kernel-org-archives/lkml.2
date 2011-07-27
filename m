Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755471Ab1G0Vs2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 17:48:28 -0400
Received: from mga09.intel.com ([134.134.136.24]:28839 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755454Ab1G0VsY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 17:48:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,279,1309762800"; 
   d="scan'208";a="32826295"
From: Andi Kleen <andi@firstfloor.org>
References: <20110727247.325703029@firstfloor.org>
In-Reply-To: <20110727247.325703029@firstfloor.org>
To: kronos.it@gmail.com, jrickman@myamigos.us, w5pny@arrl.net, dz@debian.org,
        khali@linux-fr.org, gregkh@suse.de, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [25/99] i8k: Avoid lahf in 64-bit code
Message-Id: <20110727214823.BF1732403FF@tassilo.jf.intel.com>
Date: Wed, 27 Jul 2011 14:48:23 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Luca Tettamanti <kronos.it@gmail.com>

commit bc1f419c76a2d6450413ce4349f4e4a07be011d5 upstream.

i8k uses lahf to read the flag register in 64-bit code; early x86-64
CPUs, however, lack this instruction and we get an invalid opcode
exception at runtime.
Use pushf to load the flag register into the stack instead.

Signed-off-by: Luca Tettamanti <kronos.it@gmail.com>
Reported-by: Jeff Rickman <jrickman@myamigos.us>
Tested-by: Jeff Rickman <jrickman@myamigos.us>
Tested-by: Harry G McGavran Jr <w5pny@arrl.net>
Cc: Massimo Dal Zotto <dz@debian.org>
Signed-off-by: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/char/i8k.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux-2.6.35.y/drivers/char/i8k.c
===================================================================
--- linux-2.6.35.y.orig/drivers/char/i8k.c
+++ linux-2.6.35.y/drivers/char/i8k.c
@@ -138,8 +138,8 @@ static int i8k_smm(struct smm_regs *regs
 		"movl %%edi,20(%%rax)\n\t"
 		"popq %%rdx\n\t"
 		"movl %%edx,0(%%rax)\n\t"
-		"lahf\n\t"
-		"shrl $8,%%eax\n\t"
+		"pushfq\n\t"
+		"popq %%rax\n\t"
 		"andl $1,%%eax\n"
 		:"=a"(rc)
 		:    "a"(regs)
