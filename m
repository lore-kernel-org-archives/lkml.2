Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965108Ab2EOCRT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 22:17:19 -0400
Received: from mail1.windriver.com ([147.11.146.13]:52844 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964872Ab2EOCQL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 22:16:11 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [34-longterm 015/179] x86, amd: Use _safe() msr access for GartTlbWlk disable code
Date: Mon, 14 May 2012 22:11:51 -0400
Message-ID: <1337048075-6132-16-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.6
In-Reply-To: <1337048075-6132-1-git-send-email-paul.gortmaker@windriver.com>
References: <1337048075-6132-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Roedel, Joerg" <Joerg.Roedel@amd.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit d47cc0db8fd6011de2248df505fc34990b7451bf upstream.

The workaround for Bugzilla:

	https://bugzilla.kernel.org/show_bug.cgi?id=33012

introduced a read and a write to the MC4 mask msr.

Unfortunatly this MSR is not emulated by the KVM hypervisor
so that the kernel will get a #GP and crashes when applying
this workaround when running inside KVM.

This issue was reported as:

	https://bugzilla.kernel.org/show_bug.cgi?id=35132

and is fixed with this patch. The change just let the kernel
ignore any #GP it gets while accessing this MSR by using the
_safe msr access methods.

Reported-by: Török Edwin <edwintorok@gmail.com>
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Cc: Rafael J. Wysocki <rjw@sisk.pl>
Cc: Maciej Rutecki <maciej.rutecki@gmail.com>
Cc: Avi Kivity <avi@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 arch/x86/kernel/cpu/amd.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index 770346d..02a5a5f 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -586,10 +586,13 @@ static void __cpuinit init_amd(struct cpuinfo_x86 *c)
 		 * Fixes: https://bugzilla.kernel.org/show_bug.cgi?id=33012
 		 */
 		u64 mask;
+		int err;
 
-		rdmsrl(MSR_AMD64_MCx_MASK(4), mask);
-		mask |= (1 << 10);
-		wrmsrl(MSR_AMD64_MCx_MASK(4), mask);
+		err = rdmsrl_safe(MSR_AMD64_MCx_MASK(4), &mask);
+		if (err == 0) {
+			mask |= (1 << 10);
+			checking_wrmsrl(MSR_AMD64_MCx_MASK(4), mask);
+		}
 	}
 }
 
-- 
1.7.9.6

