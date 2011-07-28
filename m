Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756276Ab1G1XyN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 19:54:13 -0400
Received: from mga14.intel.com ([143.182.124.37]:10910 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756143Ab1G1XoV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 19:44:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,285,1309762800"; 
   d="scan'208";a="32808941"
From: Andi Kleen <andi@firstfloor.org>
References: <20110728444.299940435@firstfloor.org>
In-Reply-To: <20110728444.299940435@firstfloor.org>
To: ying.huang@intel.com, ebiederm@xmission.com, vgoyal@redhat.com,
        ak@linux.intel.com, mingo@elte.hu, linux-kernel@vger.kernel.org,
        stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [11/50] kexec, x86: Fix incorrect jump back address if not
Message-Id: <20110728234415.7E3392403FF@tassilo.jf.intel.com>
Date: Thu, 28 Jul 2011 16:44:15 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Huang Ying <ying.huang@intel.com>

[ upstream commit 050438ed5a05b25cdf287f5691e56a58c2606997 ]
 preserving context

In kexec jump support, jump back address passed to the kexeced
kernel via function calling ABI, that is, the function call
return address is the jump back entry.

Furthermore, jump back entry == 0 should be used to signal that
the jump back or preserve context is not enabled in the original
kernel.

But in the current implementation the stack position used for
function call return address is not cleared context
preservation is disabled. The patch fixes this bug.

Reported-and-tested-by: Yin Kangkai <kangkai.yin@intel.com>
Signed-off-by: Huang Ying <ying.huang@intel.com>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: <stable@kernel.org>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
Link: http://lkml.kernel.org/r/1310607277-25029-1-git-send-email-ying.huang@intel.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>

Index: linux-2.6.35.y/arch/x86/kernel/relocate_kernel_32.S
===================================================================
--- linux-2.6.35.y.orig/arch/x86/kernel/relocate_kernel_32.S
+++ linux-2.6.35.y/arch/x86/kernel/relocate_kernel_32.S
@@ -97,6 +97,8 @@ relocate_kernel:
 	ret
 
 identity_mapped:
+	/* set return address to 0 if not preserving context */
+	pushl	$0
 	/* store the start address on the stack */
 	pushl   %edx
 
Index: linux-2.6.35.y/arch/x86/kernel/relocate_kernel_64.S
===================================================================
--- linux-2.6.35.y.orig/arch/x86/kernel/relocate_kernel_64.S
+++ linux-2.6.35.y/arch/x86/kernel/relocate_kernel_64.S
@@ -100,6 +100,8 @@ relocate_kernel:
 	ret
 
 identity_mapped:
+	/* set return address to 0 if not preserving context */
+	pushq	$0
 	/* store the start address on the stack */
 	pushq   %rdx
 
