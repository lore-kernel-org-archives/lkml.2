Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753676Ab1ASJeh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 04:34:37 -0500
Received: from hera.kernel.org ([140.211.167.34]:36881 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753519Ab1ASJeg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 04:34:36 -0500
Date: Wed, 19 Jan 2011 09:33:59 GMT
From: tip-bot for Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        sam@ravnborg.org, hongjiu.lu@intel.com, shaohua.li@intel.com,
        markus@trippelsdorf.de, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        sam@ravnborg.org, hongjiu.lu@intel.com, shaohua.li@intel.com,
        markus@trippelsdorf.de, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <4D36A759.60704@intel.com>
References: <4D36A759.60704@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] Revert "x86: Make relocatable kernel work with new binutils"
Message-ID: <tip-6b35eb9ddcddde7b510726de03fae071178f1ec4@git.kernel.org>
Git-Commit-ID: 6b35eb9ddcddde7b510726de03fae071178f1ec4
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 19 Jan 2011 09:34:00 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6b35eb9ddcddde7b510726de03fae071178f1ec4
Gitweb:     http://git.kernel.org/tip/6b35eb9ddcddde7b510726de03fae071178f1ec4
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Wed, 19 Jan 2011 10:09:42 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 19 Jan 2011 10:09:42 +0100

Revert "x86: Make relocatable kernel work with new binutils"

This reverts commit 86b1e8dd83cb ("x86: Make relocatable kernel work with
new binutils").

Markus Trippelsdorf reported a boot failure caused by this patch.

The real solution to the original patch will likely involve an
arch-generic solution to define an overlaid jiffies_64 and jiffies
variables.

Until that's done and tested on all architectures revert this commit to
solve the regression.

Reported-and-bisected-by: Markus Trippelsdorf <markus@trippelsdorf.de>
Acked-by: "H. Peter Anvin" <hpa@zytor.com>
Cc: Shaohua Li <shaohua.li@intel.com>
Cc: "Lu, Hongjiu" <hongjiu.lu@intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
Cc: Sam Ravnborg <sam@ravnborg.org>
LKML-Reference: <4D36A759.60704@intel.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/vmlinux.lds.S |   11 ++---------
 1 files changed, 2 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kernel/vmlinux.lds.S b/arch/x86/kernel/vmlinux.lds.S
index b34ab80..bf47007 100644
--- a/arch/x86/kernel/vmlinux.lds.S
+++ b/arch/x86/kernel/vmlinux.lds.S
@@ -34,9 +34,11 @@ OUTPUT_FORMAT(CONFIG_OUTPUT_FORMAT, CONFIG_OUTPUT_FORMAT, CONFIG_OUTPUT_FORMAT)
 #ifdef CONFIG_X86_32
 OUTPUT_ARCH(i386)
 ENTRY(phys_startup_32)
+jiffies = jiffies_64;
 #else
 OUTPUT_ARCH(i386:x86-64)
 ENTRY(phys_startup_64)
+jiffies_64 = jiffies;
 #endif
 
 #if defined(CONFIG_X86_64) && defined(CONFIG_DEBUG_RODATA)
@@ -140,15 +142,6 @@ SECTIONS
 		CACHELINE_ALIGNED_DATA(L1_CACHE_BYTES)
 
 		DATA_DATA
-		/*
-		 * Workaround a binutils (2.20.51.0.12 to 2.21.51.0.3) bug.
-		 * This makes jiffies relocatable in such binutils
-		 */
-#ifdef CONFIG_X86_32
-		jiffies = jiffies_64;
-#else
-		jiffies_64 = jiffies;
-#endif
 		CONSTRUCTORS
 
 		/* rarely changed data like cpu maps */
