Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753328Ab2H1TOh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2012 15:14:37 -0400
Received: from cantor2.suse.de ([195.135.220.15]:39352 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752602Ab2H1TOg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2012 15:14:36 -0400
Date: Tue, 28 Aug 2012 12:14:26 -0700 (PDT)
From: Jiri Kosina <jkosina@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Chris Metcalf <cmetcalf@tilera.com>, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH] tile: Fix personality bits handling upon exec()
Message-ID: <alpine.LNX.2.00.1208281210590.22447@pobox.suse.cz>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Historically, the top three bytes of personality have been used for things 
such as ADDR_NO_RANDOMIZE, which made sense only for specific 
architectures.

We now however have a flag there that is general no matter the
architecture (UNAME26); generally we have to be careful to preserve the
personality flags across exec().

This patch fixes tile architecture not to forcefully overwrite
personality flags during exec().

In addition to that, we fix two other things along the way:

- exec_domain switching is fixed -- set_personality() should always
  be used instead of directly assigning to current->personality.
- as pointed out by Arnd Bergmann, PER_LINUX_32BIT is not used anywhere
  by tile, so let's just drop that in favor of PER_LINUX

Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Acked-by: Chris Metcalf <cmetcalf@tilera.com>
---

Andrew,

this is kind of followup to 
cross-arch-dont-corrupt-personality-flags-upon-exec.patch but it fixes 
a little bit more for tile compared to what we did for other 
architectures, so I think it makes sense to take it as a separate patch 
and not fold it into.

Thanks.

 arch/tile/include/asm/elf.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/tile/include/asm/elf.h b/arch/tile/include/asm/elf.h
index d16d006..f8ccf08 100644
--- a/arch/tile/include/asm/elf.h
+++ b/arch/tile/include/asm/elf.h
@@ -156,12 +156,12 @@ extern int arch_setup_additional_pages(struct linux_binprm *bprm,
 #undef SET_PERSONALITY
 #define SET_PERSONALITY(ex) \
 do { \
-	current->personality = PER_LINUX; \
+	set_personality(PER_LINUX | (current->personality & (~PER_MASK))); \
 	current_thread_info()->status &= ~TS_COMPAT; \
 } while (0)
 #define COMPAT_SET_PERSONALITY(ex) \
 do { \
-	current->personality = PER_LINUX_32BIT; \
+	set_personality(PER_LINUX | (current->personality & (~PER_MASK))); \
 	current_thread_info()->status |= TS_COMPAT; \
 } while (0)
 
-- 
Jiri Kosina
SUSE Labs
