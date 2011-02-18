Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756042Ab1BRNQB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Feb 2011 08:16:01 -0500
Received: from cantor.suse.de ([195.135.220.2]:36448 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752292Ab1BRNP7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Feb 2011 08:15:59 -0500
From: Ludwig Nussel <ludwig.nussel@suse.de>
To: linux-kernel@vger.kernel.org
Cc: x86@kernel.org, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        security@kernel.org, Ludwig Nussel <ludwig.nussel@suse.de>
Subject: [PATCH] fix mmap random address range on x86
Date: Fri, 18 Feb 2011 14:15:57 +0100
Message-Id: <1298034957-17128-1-git-send-email-ludwig.nussel@suse.de>
X-Mailer: git-send-email 1.7.1
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
1.7.1

