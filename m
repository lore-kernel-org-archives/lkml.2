Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965362Ab2EOCkF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 22:40:05 -0400
Received: from mail.windriver.com ([147.11.1.11]:49785 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964839Ab2EOCRq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 22:17:46 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [34-longterm 130/179] kexec, x86: Fix incorrect jump back address if not preserving context
Date: Mon, 14 May 2012 22:13:46 -0400
Message-ID: <1337048075-6132-131-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.6
In-Reply-To: <1337048075-6132-1-git-send-email-paul.gortmaker@windriver.com>
References: <1337048075-6132-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Huang Ying <ying.huang@intel.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 050438ed5a05b25cdf287f5691e56a58c2606997 upstream.

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
Link: http://lkml.kernel.org/r/1310607277-25029-1-git-send-email-ying.huang@intel.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 arch/x86/kernel/relocate_kernel_32.S |    2 ++
 arch/x86/kernel/relocate_kernel_64.S |    2 ++
 2 files changed, 4 insertions(+)

diff --git a/arch/x86/kernel/relocate_kernel_32.S b/arch/x86/kernel/relocate_kernel_32.S
index 4123553..36818f8 100644
--- a/arch/x86/kernel/relocate_kernel_32.S
+++ b/arch/x86/kernel/relocate_kernel_32.S
@@ -97,6 +97,8 @@ relocate_kernel:
 	ret
 
 identity_mapped:
+	/* set return address to 0 if not preserving context */
+	pushl	$0
 	/* store the start address on the stack */
 	pushl   %edx
 
diff --git a/arch/x86/kernel/relocate_kernel_64.S b/arch/x86/kernel/relocate_kernel_64.S
index 4de8f5b..7a6f3b3 100644
--- a/arch/x86/kernel/relocate_kernel_64.S
+++ b/arch/x86/kernel/relocate_kernel_64.S
@@ -100,6 +100,8 @@ relocate_kernel:
 	ret
 
 identity_mapped:
+	/* set return address to 0 if not preserving context */
+	pushq	$0
 	/* store the start address on the stack */
 	pushq   %rdx
 
-- 
1.7.9.6

