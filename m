Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753105Ab1GNBev (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jul 2011 21:34:51 -0400
Received: from mga02.intel.com ([134.134.136.20]:4301 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750850Ab1GNBeu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jul 2011 21:34:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,527,1304319600"; 
   d="scan'208";a="25622792"
From: Huang Ying <ying.huang@intel.com>
To: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Vivek Goyal <vgoyal@redhat.com>
Cc: linux-kernel@vger.kernel.org, Huang Ying <ying.huang@intel.com>
Subject: [BUGFIX] kexec, x86, Fix incorrect jump back address if not preserve context
Date: Thu, 14 Jul 2011 09:34:37 +0800
Message-Id: <1310607277-25029-1-git-send-email-ying.huang@intel.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In kexec jump support, jump back address passed to the kexeced kernel
via function calling ABI, that is, the function call return address is
the jump back entry.  And jump back entry == 0 should be used to
signal that jump back or preserve context is not enabled in original
kernel.  But in original implementation, the stack position used for
function call return address is not cleared if preserve context is
disabled.  The patch fixes this issue.

Signed-off-by: Huang Ying <ying.huang@intel.com>
Reported-and-tested-by: Yin Kangkai <kangkai.yin@intel.com>
---
 arch/x86/kernel/relocate_kernel_32.S |    2 ++
 arch/x86/kernel/relocate_kernel_64.S |    2 ++
 2 files changed, 4 insertions(+)

--- a/arch/x86/kernel/relocate_kernel_32.S
+++ b/arch/x86/kernel/relocate_kernel_32.S
@@ -97,6 +97,8 @@ relocate_kernel:
 	ret
 
 identity_mapped:
+	/* set return address as 0 if not preserve context */
+	pushl	$0
 	/* store the start address on the stack */
 	pushl   %edx
 
--- a/arch/x86/kernel/relocate_kernel_64.S
+++ b/arch/x86/kernel/relocate_kernel_64.S
@@ -100,6 +100,8 @@ relocate_kernel:
 	ret
 
 identity_mapped:
+	/* set return address as 0 if not preserve context */
+	pushq	$0
 	/* store the start address on the stack */
 	pushq   %rdx
 
