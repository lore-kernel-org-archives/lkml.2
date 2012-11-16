Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753575Ab2KPV5q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 16:57:46 -0500
Received: from mga02.intel.com ([134.134.136.20]:22296 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753268Ab2KPV5p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 16:57:45 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.83,266,1352102400"; 
   d="scan'208";a="220838260"
Subject: [PATCH v4 4/8] x86: Drop 4 unnecessary calls to __pa_symbol
To: tglx@linutronix.de, mingo@redhat.com, andi@firstfloor.org, hpa@zytor.com
From: Alexander Duyck <alexander.h.duyck@intel.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org
Date: Fri, 16 Nov 2012 13:56:35 -0800
Message-ID: <20121116215552.8521.68085.stgit@ahduyck-cp1.jf.intel.com>
In-Reply-To: <20121116214644.8521.79072.stgit@ahduyck-cp1.jf.intel.com>
References: <20121116214644.8521.79072.stgit@ahduyck-cp1.jf.intel.com>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While debugging the __pa_symbol inline patch I found that there were a couple
spots where __pa_symbol was used as follows:
__pa_symbol(x) - __pa_symbol(y)

The compiler had reduced them to:
x - y

Since we also support a debug case where __pa_symbol is a function call it
would probably be useful to just change the two cases I found so that they are
always just treated as "x - y".  As such I am casting the values to
phys_addr_t and then doing simple subtraction so that the correct type and
value is returned.

Signed-off-by: Alexander Duyck <alexander.h.duyck@intel.com>
---
 arch/x86/kernel/head32.c |    4 ++--
 arch/x86/kernel/head64.c |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/head32.c b/arch/x86/kernel/head32.c
index c18f59d..f15db0c 100644
--- a/arch/x86/kernel/head32.c
+++ b/arch/x86/kernel/head32.c
@@ -30,8 +30,8 @@ static void __init i386_default_early_setup(void)
 
 void __init i386_start_kernel(void)
 {
-	memblock_reserve(__pa_symbol(&_text),
-			 __pa_symbol(&__bss_stop) - __pa_symbol(&_text));
+	memblock_reserve(__pa_symbol(_text),
+			 (phys_addr_t)__bss_stop - (phys_addr_t)_text);
 
 #ifdef CONFIG_BLK_DEV_INITRD
 	/* Reserve INITRD */
diff --git a/arch/x86/kernel/head64.c b/arch/x86/kernel/head64.c
index 037df57..42f5df1 100644
--- a/arch/x86/kernel/head64.c
+++ b/arch/x86/kernel/head64.c
@@ -97,8 +97,8 @@ void __init x86_64_start_reservations(char *real_mode_data)
 {
 	copy_bootdata(__va(real_mode_data));
 
-	memblock_reserve(__pa_symbol(&_text),
-			 __pa_symbol(&__bss_stop) - __pa_symbol(&_text));
+	memblock_reserve(__pa_symbol(_text),
+			 (phys_addr_t)__bss_stop - (phys_addr_t)_text);
 
 #ifdef CONFIG_BLK_DEV_INITRD
 	/* Reserve INITRD */

