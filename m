Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754552Ab1B1Oxc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 09:53:32 -0500
Received: from cantor2.suse.de ([195.135.220.15]:57632 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754316Ab1B1Oxb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 09:53:31 -0500
From: Ludwig Nussel <ludwig.nussel@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Ludwig Nussel <ludwig.nussel@suse.de>,
        Thomas Gleixner <tglx@linutronix.de> (maintainer:X86
	ARCHITECTURE...),
        Ingo Molnar <mingo@redhat.com> (maintainer:X86 ARCHITECTURE...),
        "H. Peter Anvin" <hpa@zytor.com> (maintainer:X86 ARCHITECTURE...),
        x86@kernel.org (maintainer:X86 ARCHITECTURE...)
Subject: [PATCH] fix mmap random address range on x86 (try2)
Date: Mon, 28 Feb 2011 15:53:03 +0100
Message-Id: <1298904783-4291-1-git-send-email-ludwig.nussel@suse.de>
X-Mailer: git-send-email 1.7.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On x86 casting the unsigned int result of get_random_int() to long
may result in a negative value. On x86 the range of mmap_rnd()
therefore was -255 to 255. The 32bit mode on x86_64 used 0 to 255 as
intended.

The bug was introduced by commit 675a081 in January 2008.

Signed-off-by: Ludwig Nussel <ludwig.nussel@suse.de>
---
 arch/x86/mm/mmap.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/mm/mmap.c b/arch/x86/mm/mmap.c
index 1dab519..f927429 100644
--- a/arch/x86/mm/mmap.c
+++ b/arch/x86/mm/mmap.c
@@ -87,9 +87,9 @@ static unsigned long mmap_rnd(void)
 	*/
 	if (current->flags & PF_RANDOMIZE) {
 		if (mmap_is_ia32())
-			rnd = (long)get_random_int() % (1<<8);
+			rnd = get_random_int() % (1<<8);
 		else
-			rnd = (long)(get_random_int() % (1<<28));
+			rnd = get_random_int() % (1<<28);
 	}
 	return rnd << PAGE_SHIFT;
 }
-- 
1.7.3.4

