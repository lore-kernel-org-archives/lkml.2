Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754787Ab2CZBgj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2012 21:36:39 -0400
Received: from mga09.intel.com ([134.134.136.24]:14905 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754567Ab2CZBgi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2012 21:36:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="121557659"
Subject: [PATCH_V2 1/2] fix the bug that printk can't support
 printk(KERN_LEVEL)
From: "he, bo" <bo.he@intel.com>
To: Ingo Molnar <mingo@kernel.org>, akpm@linux-foudation.org, mingo@elte.hu,
        rusty@rustcorp.com.au, a.p.zijlstra@chello.nl,
        linux-kernel@vger.kernel.org, william.douglas@intel.com
Cc: yanmin_zhang@linux.intel.com
In-Reply-To: <20120323122208.GB13920@gmail.com>
References: <1332493027.2359.5.camel@hebo> <1332493269.2359.9.camel@hebo>
	 <20120323122208.GB13920@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 26 Mar 2012 09:36:27 +0800
Message-ID: <1332725787.2359.27.camel@hebo>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: he bo <bo.he@intel.com>

Usually, there is a special scenario that developer wants to
call printk to just set up a log level (might be transferred
here as a parameter from upper level), then, later calling
of printk prints out real string with the same log level
continuously.

Current function vprintk has an issue to support this capability.
When the whole string in one calling to printk is just a log level,
it ignores it.

Signed-off-by: he, bo <bo.he@intel.com>
Reviewed-by: Zhang, Yanmin <yanmin.zhang@intel.com>
---
 kernel/printk.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/kernel/printk.c b/kernel/printk.c
index b663c2c..473afdb 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -909,7 +909,7 @@ asmlinkage int vprintk(const char *fmt, va_list args)
 	 * Copy the output into log_buf. If the caller didn't provide
 	 * the appropriate log prefix, we insert them here
 	 */
-	for (; *p; p++) {
+	for (; plen || *p; p++) {
 		if (new_text_line) {
 			new_text_line = 0;
 
@@ -920,6 +920,7 @@ asmlinkage int vprintk(const char *fmt, va_list args)
 				for (i = 0; i < plen; i++)
 					emit_log_char(printk_buf[i]);
 				printed_len += plen;
+				plen = 0;
 			} else {
 				/* Add log prefix */
 				emit_log_char('<');
@@ -946,10 +947,10 @@ asmlinkage int vprintk(const char *fmt, va_list args)
 				printed_len += tlen;
 			}
 
-			if (!*p)
-				break;
 		}
 
+		if (!*p)
+			break;
 		emit_log_char(*p);
 		if (*p == '\n')
 			new_text_line = 1;
-- 
1.7.1



