Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754564Ab2HSC6j (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2012 22:58:39 -0400
Received: from mga03.intel.com ([143.182.124.21]:17805 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753209Ab2HSC52 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2012 22:57:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.77,792,1336374000"; 
   d="scan'208";a="182675628"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: x86@kernel.org, mmarek@suse.cz, linux-kbuild@vger.kernel.org,
        JBeulich@suse.com, akpm@linux-foundation.org,
        Joe Mario <jmario@redhat.com>, rusty@rustcorp.com.au,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 59/74] lto: Handle LTO common symbols in module loader
Date: Sat, 18 Aug 2012 19:56:55 -0700
Message-Id: <1345345030-22211-60-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1345345030-22211-1-git-send-email-andi@firstfloor.org>
References: <1345345030-22211-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Mario <jmario@redhat.com>

Here is the workaround I made for having the kernel not reject modules
built with -flto.  The clean solution would be to get the compiler to not
emit the symbol.  Or if it has to emit the symbol, then emit it as
initialized data but put it into a comdat/linkonce section.

Minor tweaks by AK over Joe's patch.

Cc: rusty@rustcorp.com.au
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 kernel/module.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/kernel/module.c b/kernel/module.c
index c00565a..2cbbae3 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -1904,6 +1904,10 @@ static int simplify_symbols(struct module *mod, const struct load_info *info)
 
 		switch (sym[i].st_shndx) {
 		case SHN_COMMON:
+			/* Ignore common symbols */
+			if (!strncmp(name, "__gnu_lto", 9))
+				break;
+
 			/* We compiled with -fno-common.  These are not
 			   supposed to happen.  */
 			pr_debug("Common symbol: %s\n", name);
-- 
1.7.7.6

