Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751645Ab2JBDiw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 23:38:52 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:33455 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751274Ab2JBDiu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 23:38:50 -0400
Date: Mon, 1 Oct 2012 20:38:47 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Ingo Molnar <mingo@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        tglx@linutronix.de
cc: linux-tip-commits@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>, Len Brown <lenb@kernel.org>,
        Eric Piel <eric.piel@tremplin-utc.net>,
        Thomas Renninger <trenn@suse.de>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Robert Moore <robert.moore@intel.com>
Subject: [patch x86/acpi] ACPI: Fix build when disabled
In-Reply-To: <tip-53aac44c904abbad9f474f652f099de13b5c3563@git.kernel.org>
Message-ID: <alpine.DEB.2.00.1210012032470.31644@chino.kir.corp.google.com>
References: <1349043837-22659-4-git-send-email-trenn@suse.de> <tip-53aac44c904abbad9f474f652f099de13b5c3563@git.kernel.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

Signed-off-by: David Rientjes <rientjes@google.com>
---
 arch/x86/kernel/setup.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -941,7 +941,9 @@ void __init setup_arch(char **cmdline_p)
 
 	reserve_initrd();
 
+#if defined(CONFIG_ACPI) && defined(CONFIG_BLK_DEV_INITRD)
 	acpi_initrd_override((void *)initrd_start, initrd_end - initrd_start);
+#endif
 
 	reserve_crashkernel();
 
