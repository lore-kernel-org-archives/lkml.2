Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752955Ab2E1C4u (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2012 22:56:50 -0400
Received: from mga11.intel.com ([192.55.52.93]:52852 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751067Ab2E1C4t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2012 22:56:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="157793944"
Message-ID: <4FC2E8CF.2040109@intel.com>
Date: Mon, 28 May 2012 10:54:07 +0800
From: ShuoX Liu <shuox.liu@intel.com>
Reply-To: shuox.liu@intel.com
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Yanmin Zhang <yanmin_zhang@linux.intel.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Borislav Petkov <bp@alien8.de>,
        "andi@firstfloor.org" <andi@firstfloor.org>,
        Ingo Molnar <mingo@elte.hu>
Subject: [PATCH v3 1/2] printk: add interface for disabling recursion check
References: <4FBC444A.6060500@intel.com>  <20120523100138.GA13506@x1.osrc.amd.com> <4FBDCE4A.7050900@intel.com>  <20120524061145.GA18284@liondog.tnic>  <20120524155611.b7aeff4d.akpm@linux-foundation.org>  <1337905811.14538.206.camel@ymzhang.sh.intel.com>  <4FBF3295.7090608@intel.com>  <3908561D78D1C84285E8C5FCA982C28F192F4D39@ORSMSX104.amr.corp.intel.com> <1338165058.14538.209.camel@ymzhang.sh.intel.com>
In-Reply-To: <1338165058.14538.209.camel@ymzhang.sh.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: ShuoX Liu <shuox.liu@intel.com>

With some special scenario, such as Machine Check Exception happened
in printk, we want to bypass printk recursion check to printk some
important information. So we add these interfaces of printk.

1) printk_recursion_check_disable() for disabling recursion check
2) printk_recursion_check_enable() for enabling recursion check

Signed-off-by: Yanmin Zhang <yanmin_zhang@linux.intel.com>
Signed-off-by: ShuoX Liu <shuox.liu@intel.com>
---
 include/linux/printk.h |    3 +++
 kernel/printk.c        |   17 ++++++++++++++++-
 2 files changed, 19 insertions(+), 1 deletions(-)

diff --git a/include/linux/printk.h b/include/linux/printk.h
index 1bec2f7..da48ec7 100644
--- a/include/linux/printk.h
+++ b/include/linux/printk.h
@@ -42,6 +42,9 @@ static inline void console_verbose(void)
 		console_loglevel = 15;
 }
 
+void printk_recursion_check_disable(void);
+void printk_recursion_check_enable(void);
+
 struct va_format {
 	const char *fmt;
 	va_list *va;
diff --git a/kernel/printk.c b/kernel/printk.c
index 32462d2..0580f67 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -78,6 +78,19 @@ int console_printk[4] = {
 int oops_in_progress;
 EXPORT_SYMBOL(oops_in_progress);
 
+static atomic_t recursion_check_disabled = ATOMIC_INIT(0);
+
+void printk_recursion_check_disable(void)
+{
+	atomic_inc(&recursion_check_disabled);
+}
+
+void printk_recursion_check_enable(void)
+{
+	WARN_ON(atomic_read(&recursion_check_disabled) < 1);
+	atomic_dec(&recursion_check_disabled);
+}
+
 /*
  * console_sem protects the console_drivers list, and also
  * provides serialisation for access to the entire console
@@ -1295,7 +1308,9 @@ asmlinkage int vprintk_emit(int facility, int level,
 		 * recursion and return - but flag the recursion so that
 		 * it can be printed at the next appropriate moment:
 		 */
-		if (!oops_in_progress && !lockdep_recursing(current)) {
+		if (!atomic_read(&recursion_check_disabled)
+			&& !oops_in_progress
+			&& !lockdep_recursing(current)) {
 			recursion_bug = 1;
 			goto out_restore_irqs;
 		}
-- 
1.7.1

