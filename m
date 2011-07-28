Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756077Ab1G1XoL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 19:44:11 -0400
Received: from mga02.intel.com ([134.134.136.20]:30203 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755457Ab1G1XoI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 19:44:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,285,1309762800"; 
   d="scan'208";a="33351662"
From: Andi Kleen <andi@firstfloor.org>
References: <20110728444.299940435@firstfloor.org>
In-Reply-To: <20110728444.299940435@firstfloor.org>
To: drosenberg@vsecurity.com, chris@zankel.net, oleg@redhat.com,
        akpm@linux-foundation.org, torvalds@linux-foundation.org,
        ak@linux.intel.com, linux-kernel@vger.kernel.org, stable@kernel.org,
        tim.bird@am.sony.com
Subject: [PATCH] [4/50] xtensa: prevent arbitrary read in ptrace
Message-Id: <20110728234408.5F8C22403FF@tassilo.jf.intel.com>
Date: Thu, 28 Jul 2011 16:44:08 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Dan Rosenberg <drosenberg@vsecurity.com>

[ upstream commit 0d0138ebe24b94065580bd2601f8bb7eb6152f56 ]

Prevent an arbitrary kernel read.  Check the user pointer with access_ok()
before copying data in.

[akpm@linux-foundation.org: s/EIO/EFAULT/]
Signed-off-by: Dan Rosenberg <drosenberg@vsecurity.com>
Cc: Christian Zankel <chris@zankel.net>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

Index: linux-2.6.35.y/arch/xtensa/kernel/ptrace.c
===================================================================
--- linux-2.6.35.y.orig/arch/xtensa/kernel/ptrace.c
+++ linux-2.6.35.y/arch/xtensa/kernel/ptrace.c
@@ -147,6 +147,9 @@ int ptrace_setxregs(struct task_struct *
 	elf_xtregs_t *xtregs = uregs;
 	int ret = 0;
 
+	if (!access_ok(VERIFY_READ, uregs, sizeof(elf_xtregs_t)))
+		return -EFAULT;
+
 #if XTENSA_HAVE_COPROCESSORS
 	/* Flush all coprocessors before we overwrite them. */
 	coprocessor_flush_all(ti);
