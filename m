Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755392Ab2CTSch (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 14:32:37 -0400
Received: from mail1.windriver.com ([147.11.146.13]:44614 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754862Ab2CTScg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 14:32:36 -0400
Message-ID: <4F68CD32.3040202@windriver.com>
Date: Tue, 20 Mar 2012 13:32:18 -0500
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: Tim Bird <tim.bird@am.sony.com>
CC: "kgdb-bugreport@lists.sourceforge.net" 
	<kgdb-bugreport@lists.sourceforge.net>,
        linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kdb: Add message about CONFIG_DEBUG_RODATA on failure
 to install breakpoint
References: <4E7A4413.5000307@am.sony.com>
In-Reply-To: <4E7A4413.5000307@am.sony.com>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/21/2011 03:07 PM, Tim Bird wrote:
> On x86, if CONFIG_DEBUG_RODATA is set, one cannot set breakpoints
> via KDB.  Apparently this is a well-known problem, as at least one distribution
> now ships with both KDB enabled and CONFIG_DEBUG_RODATA=y for security reasons.
> 
> This patch just adds an extra printk message to the breakpoint failure case,
> in order to provide some useful diagnostics to the user.
> 

The patch is definitely the right idea.  I believe we should try and tell the whole story and only print the message for the type of breakpoint that fails.  It is absolutely the case that you can still use kdb/kdb without recompiling the kernel.

I propose a slightly different implementation below.


---

Subject: [PATCH] kdb: Add message about CONFIG_DEBUG_RODATA on failure to install breakpoint

When the kernel config option CONFIG_DEBUG_RODATA=y is set on x86
software breakpoints are not available to KDB.  The constraints to
debug kernel are often at odds with security protections for a kernel
and several OS distributions ship with both KDB enabled and
CONFIG_DEBUG_RODATA=y.

This patch adds an printk message to the breakpoint failure case,
in order to provide suggestions about how to use the debugger.

Reported-by: Tim Bird <tim.bird@am.sony.com>
Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
---
 kernel/debug/kdb/kdb_bp.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/kernel/debug/kdb/kdb_bp.c b/kernel/debug/kdb/kdb_bp.c
index 20059ef..8418c2f 100644
--- a/kernel/debug/kdb/kdb_bp.c
+++ b/kernel/debug/kdb/kdb_bp.c
@@ -153,7 +153,13 @@ static int _kdb_bp_install(struct pt_regs *regs, kdb_bp_t *bp)
 	} else {
 		kdb_printf("%s: failed to set breakpoint at 0x%lx\n",
 			   __func__, bp->bp_addr);
+#ifdef CONFIG_DEBUG_RODATA
+		if (!bp->bp_type) {
+			kdb_printf("Software breakpoints are unavailable.\n"
+				   "  Change the kernel CONFIG_DEBUG_RODATA=n\n"
+				   "  OR use hw breakpoints: help bph\n");
+		}
+#endif
 		return 1;
 	}
 	return 0;
