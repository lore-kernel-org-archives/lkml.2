Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751516Ab1BGFQg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 00:16:36 -0500
Received: from terminus.zytor.com ([198.137.202.10]:42477 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750893Ab1BGFQf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 00:16:35 -0500
Message-ID: <4D4F8019.2090104@zytor.com>
Date: Sun, 06 Feb 2011 21:16:09 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: castet.matthieu@free.fr
CC: Ingo Molnar <mingo@elte.hu>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        linux-security-module@vger.kernel.org, Matthias Hopf <mhopf@suse.de>,
        rjw@sisk.pl, Andrew Morton <akpm@linux-foundation.org>,
        Suresh Siddha <suresh.b.siddha@intel.com>
Subject: Re: [PATCH] NX protection for kernel data : fix 32 bits S3 suspend
References: <4D473FD5.1090903@free.fr> <20110201080223.GB20372@elte.hu> <1296566732.4d4809cc1f963@imp.free.fr> <20110202062632.GA12256@elte.hu> <4D4CA3FD.6000901@zytor.com> <1296924395.4d4d7eeb6f1fe@imp.free.fr>
In-Reply-To: <1296924395.4d4d7eeb6f1fe@imp.free.fr>
Content-Type: multipart/mixed;
 boundary="------------080104010609080307090205"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------080104010609080307090205
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Here is my cleaned-up version of Matthieu's patch... please test so we
can commit it as soon as possible.

If this one doesn't work either it is time to totally revert.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.



--------------080104010609080307090205
Content-Type: text/x-patch;
 name="0001-x86-nx-Mark-the-ACPI-resume-trampoline-code-as-x.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0001-x86-nx-Mark-the-ACPI-resume-trampoline-code-as-x.patch"

>From 0b327f122ccfbbb28f2c22834916f12d03fc2a06 Mon Sep 17 00:00:00 2001
From: H. Peter Anvin <hpa@zytor.com>
Date: Sun, 6 Feb 2011 19:58:38 -0800
Subject: [PATCH] x86, nx: Mark the ACPI resume trampoline code as +x

We reserve lowmem for the things that need it, like the ACPI wakeup
code, way early to guarantee availability.  This happens before we set
up the proper pagetables, so set_memory_x() has no effect.

Until we have a better solution, use an initcall to mark the wakeup
code executable.

Originally-by: Matthieu Castet <castet.matthieu@free.fr>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
LKML-Reference: <1296924395.4d4d7eeb6f1fe@imp.free.fr>
---
 arch/x86/kernel/acpi/sleep.c |   13 ++++++++++---
 1 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/acpi/sleep.c b/arch/x86/kernel/acpi/sleep.c
index 4d9ebba..68d1537 100644
--- a/arch/x86/kernel/acpi/sleep.c
+++ b/arch/x86/kernel/acpi/sleep.c
@@ -12,10 +12,8 @@
 #include <linux/cpumask.h>
 #include <asm/segment.h>
 #include <asm/desc.h>
-
-#ifdef CONFIG_X86_32
 #include <asm/pgtable.h>
-#endif
+#include <asm/cacheflush.h>
 
 #include "realmode/wakeup.h"
 #include "sleep.h"
@@ -149,6 +147,15 @@ void __init acpi_reserve_wakeup_memory(void)
 	memblock_x86_reserve_range(mem, mem + WAKEUP_SIZE, "ACPI WAKEUP");
 }
 
+int __init acpi_configure_wakeup_memory(void)
+{
+	if (acpi_realmode)
+		set_memory_x(acpi_realmode, WAKEUP_SIZE >> PAGE_SHIFT);
+
+	return 0;
+}
+arch_initcall(acpi_configure_wakeup_memory);
+
 
 static int __init acpi_sleep_setup(char *str)
 {
-- 
1.7.4


--------------080104010609080307090205--
