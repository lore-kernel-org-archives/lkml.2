Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753890Ab2KQA0r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 19:26:47 -0500
Received: from terminus.zytor.com ([198.137.202.10]:37673 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753832Ab2KQA0p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 19:26:45 -0500
Date: Fri, 16 Nov 2012 16:25:52 -0800
From: tip-bot for Alexander Duyck <alexander.h.duyck@intel.com>
Message-ID: <tip-409fa8dcd2c8b1ec1e705ad99b152bce665af025@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        alexander.h.duyck@intel.com, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        alexander.h.duyck@intel.com, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <20121116215552.8521.68085.stgit@ahduyck-cp1.jf.intel.com>
References: <20121116215552.8521.68085.stgit@ahduyck-cp1.jf.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mm] x86: Drop 4 unnecessary calls to __pa_symbol
Git-Commit-ID: 409fa8dcd2c8b1ec1e705ad99b152bce665af025
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 16 Nov 2012 16:26:39 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  409fa8dcd2c8b1ec1e705ad99b152bce665af025
Gitweb:     http://git.kernel.org/tip/409fa8dcd2c8b1ec1e705ad99b152bce665af025
Author:     Alexander Duyck <alexander.h.duyck@intel.com>
AuthorDate: Fri, 16 Nov 2012 13:56:35 -0800
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Fri, 16 Nov 2012 15:20:28 -0800

x86: Drop 4 unnecessary calls to __pa_symbol

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
Link: http://lkml.kernel.org/r/20121116215552.8521.68085.stgit@ahduyck-cp1.jf.intel.com
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/kernel/head32.c | 4 ++--
 arch/x86/kernel/head64.c | 4 ++--
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
