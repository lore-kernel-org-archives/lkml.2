Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754428Ab1B1P0c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 10:26:32 -0500
Received: from hera.kernel.org ([140.211.167.34]:42448 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753634Ab1B1P0b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 10:26:31 -0500
Date: Mon, 28 Feb 2011 15:26:04 GMT
From: tip-bot for Don Zickus <dzickus@redhat.com>
Cc: linux-kernel@vger.kernel.org, mjg@redhat.com, hpa@zytor.com,
        mingo@redhat.com, stable@kernel.org, tglx@linutronix.de,
        dzickus@redhat.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, mjg@redhat.com,
        linux-kernel@vger.kernel.org, stable@kernel.org, tglx@linutronix.de,
        dzickus@redhat.com, mingo@elte.hu
In-Reply-To: <1297139100-424-1-git-send-email-dzickus@redhat.com>
References: <1297139100-424-1-git-send-email-dzickus@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86: Use u32 instead of long to set reset vector back to 0
Message-ID: <tip-299c56966a72b9109d47c71a6db52097098703dd@git.kernel.org>
Git-Commit-ID: 299c56966a72b9109d47c71a6db52097098703dd
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 28 Feb 2011 15:26:04 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  299c56966a72b9109d47c71a6db52097098703dd
Gitweb:     http://git.kernel.org/tip/299c56966a72b9109d47c71a6db52097098703dd
Author:     Don Zickus <dzickus@redhat.com>
AuthorDate: Mon, 7 Feb 2011 23:25:00 -0500
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 28 Feb 2011 16:22:18 +0100

x86: Use u32 instead of long to set reset vector back to 0

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
Cc: <stable@kernel.org>
LKML-Reference: <1297139100-424-1-git-send-email-dzickus@redhat.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/include/asm/smpboot_hooks.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/smpboot_hooks.h b/arch/x86/include/asm/smpboot_hooks.h
index 6c22bf3..725b778 100644
--- a/arch/x86/include/asm/smpboot_hooks.h
+++ b/arch/x86/include/asm/smpboot_hooks.h
@@ -34,7 +34,7 @@ static inline void smpboot_restore_warm_reset_vector(void)
 	 */
 	CMOS_WRITE(0, 0xf);
 
-	*((volatile long *)phys_to_virt(apic->trampoline_phys_low)) = 0;
+	*((volatile u32 *)phys_to_virt(apic->trampoline_phys_low)) = 0;
 }
 
 static inline void __init smpboot_setup_io_apic(void)
