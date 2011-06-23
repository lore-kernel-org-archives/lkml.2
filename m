Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933550Ab1FWSFz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 14:05:55 -0400
Received: from mail.windriver.com ([147.11.1.11]:34782 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933482Ab1FWRhF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 13:37:05 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Don Zickus <dzickus@redhat.com>,
        Ingo Molnar <mingo@elte.hu>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 139/247] x86: Use u32 instead of long to set reset vector back to 0
Date: Thu, 23 Jun 2011 13:33:27 -0400
Message-Id: <1308850515-15242-80-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1308850515-15242-1-git-send-email-paul.gortmaker@windriver.com>
References: <1308849690-14530-1-git-send-email-paul.gortmaker@windriver.com>
 <1308850515-15242-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Don Zickus <dzickus@redhat.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 299c56966a72b9109d47c71a6db52097098703dd upstream.

A customer of ours, complained that when setting the reset
vector back to 0, it trashed other data and hung their box.
They noticed when only 4 bytes were set to 0 instead of 8,
everything worked correctly.

Mathew pointed out:

 |
 | We're supposed to be resetting trampoline_phys_low and
 | trampoline_phys_high here, which are two 16-bit values.
 | Writing 64 bits is definitely going to overwrite space
 | that we're not supposed to be touching.
 |

So limit the area modified to u32.

Signed-off-by: Don Zickus <dzickus@redhat.com>
Acked-by: Matthew Garrett <mjg@redhat.com>
LKML-Reference: <1297139100-424-1-git-send-email-dzickus@redhat.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 arch/x86/include/asm/smpboot_hooks.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/smpboot_hooks.h b/arch/x86/include/asm/smpboot_hooks.h
index 1def601..cfdc6c8 100644
--- a/arch/x86/include/asm/smpboot_hooks.h
+++ b/arch/x86/include/asm/smpboot_hooks.h
@@ -34,7 +34,7 @@ static inline void smpboot_restore_warm_reset_vector(void)
 	 */
 	CMOS_WRITE(0, 0xf);
 
-	*((volatile long *)phys_to_virt(apic->trampoline_phys_low)) = 0;
+	*((volatile u32 *)phys_to_virt(apic->trampoline_phys_low)) = 0;
 }
 
 static inline void __init smpboot_setup_io_apic(void)
-- 
1.7.4.4

