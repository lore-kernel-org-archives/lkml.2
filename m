Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751968Ab2JBDuM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 23:50:12 -0400
Received: from terminus.zytor.com ([198.137.202.10]:53862 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751192Ab2JBDuK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 23:50:10 -0400
Date: Mon, 1 Oct 2012 20:49:53 -0700
From: tip-bot for David Rientjes <rientjes@google.com>
Message-ID: <tip-3dfd8235002727dbd759bb0f80f8ac862f392071@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        lenb@kernel.org, trenn@suse.de, tglx@linutronix.de,
        hpa@linux.intel.com, rientjes@google.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        lenb@kernel.org, trenn@suse.de, tglx@linutronix.de,
        hpa@linux.intel.com, rientjes@google.com
In-Reply-To: <alpine.DEB.2.00.1210012032470.31644@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.1210012032470.31644@chino.kir.corp.google.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/acpi] ACPI: Fix build when disabled
Git-Commit-ID: 3dfd8235002727dbd759bb0f80f8ac862f392071
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 01 Oct 2012 20:49:58 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3dfd8235002727dbd759bb0f80f8ac862f392071
Gitweb:     http://git.kernel.org/tip/3dfd8235002727dbd759bb0f80f8ac862f392071
Author:     David Rientjes <rientjes@google.com>
AuthorDate: Mon, 1 Oct 2012 20:38:47 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Mon, 1 Oct 2012 20:41:43 -0700

ACPI: Fix build when disabled

"ACPI: Store valid ACPI tables passed via early initrd in reserved
memblock areas" breaks the build if either CONFIG_ACPI or
CONFIG_BLK_DEV_INITRD is disabled:

arch/x86/kernel/setup.c: In function 'setup_arch':
arch/x86/kernel/setup.c:944: error: implicit declaration of function 'acpi_initrd_override'

or

arch/x86/built-in.o: In function `setup_arch':
(.init.text+0x1397): undefined reference to `initrd_start'
arch/x86/built-in.o: In function `setup_arch':
(.init.text+0x139e): undefined reference to `initrd_end'

The dummy acpi_initrd_override() function in acpi.h isn't defined without
CONFIG_ACPI and initrd_{start,end} are declared but not defined without
CONFIG_BLK_DEV_INITRD.

[ hpa: applying this as a fix, but this really should be done cleaner ]

Signed-off-by: David Rientjes <rientjes@google.com>
Link: http://lkml.kernel.org/r/alpine.DEB.2.00.1210012032470.31644@chino.kir.corp.google.com
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Cc: Thomas Renninger <trenn@suse.de>
Cc: Len Brown <lenb@kernel.org>
---
 arch/x86/kernel/setup.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 764e543..bf82c1e 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -941,7 +941,9 @@ void __init setup_arch(char **cmdline_p)
 
 	reserve_initrd();
 
+#if defined(CONFIG_ACPI) && defined(CONFIG_BLK_DEV_INITRD)
 	acpi_initrd_override((void *)initrd_start, initrd_end - initrd_start);
+#endif
 
 	reserve_crashkernel();
 
