Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756588Ab2KVTOY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 14:14:24 -0500
Received: from mga03.intel.com ([143.182.124.21]:16771 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756570Ab2KVTON (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 14:14:13 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.83,295,1352102400"; 
   d="scan'208";a="171179774"
From: "H. Peter Anvin" <hpa@linux.intel.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Gleb Natapov <gleb@redhat.com>
Cc: Linux KVM mailing list <kvm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: [PATCH] x86, kvm: Remove incorrect redundant assembly constraint
Date: Wed, 21 Nov 2012 14:41:21 -0800
Message-Id: <1353537681-18759-1-git-send-email-hpa@linux.intel.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <B3584E72CFEBED439A3ECA9BCE67A4EF1B17AF90@FMSMSX107.amr.corp.intel.com>
References: <B3584E72CFEBED439A3ECA9BCE67A4EF1B17AF90@FMSMSX107.amr.corp.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "H. Peter Anvin" <hpa@linux.intel.com>

In __emulate_1op_rax_rdx, we use "+a" and "+d" which are input/output
constraints, and *then* use "a" and "d" as input constraints.  This is
incorrect, but happens to work on some versions of gcc.

However, it breaks gcc with -O0 and icc, and may break on future
versions of gcc.

Reported-and-tested-by: Melanie Blower <melanie.blower@intel.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Link: http://lkml.kernel.org/r/B3584E72CFEBED439A3ECA9BCE67A4EF1B17AF90@FMSMSX107.amr.corp.intel.com
---
 arch/x86/kvm/emulate.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 39171cb..bba39bf 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -426,8 +426,7 @@ static void invalidate_registers(struct x86_emulate_ctxt *ctxt)
 			_ASM_EXTABLE(1b, 3b)				\
 			: "=m" ((ctxt)->eflags), "=&r" (_tmp),		\
 			  "+a" (*rax), "+d" (*rdx), "+qm"(_ex)		\
-			: "i" (EFLAGS_MASK), "m" ((ctxt)->src.val),	\
-			  "a" (*rax), "d" (*rdx));			\
+			: "i" (EFLAGS_MASK), "m" ((ctxt)->src.val));	\
 	} while (0)
 
 /* instruction has only one source operand, destination is implicit (e.g. mul, div, imul, idiv) */
-- 
1.7.11.7

