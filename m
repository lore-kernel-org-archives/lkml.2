Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933879Ab1ESSXl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 14:23:41 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:60336 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933854Ab1ESSHz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 14:07:55 -0400
X-Sasl-enc: lbscudGxEB4Yh/1pUoGsnVr47Za4+WS4g8Bk+1clCpDq 1305828474
X-Mailbox-Line: From gregkh@clark.kroah.org Thu May 19 11:05:55 2011
Message-Id: <20110519180555.352937123@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 19 May 2011 11:04:39 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Frederic Weisbecker <fweisbec@gmail.com>,
        LPPC <linuxppc-dev@lists.ozlabs.org>,
        Prasad <prasad@linux.vnet.ibm.com>, Ingo Molnar <mingo@elte.hu>
Subject: [11/71] hw_breakpoints, powerpc: Fix CONFIG_HAVE_HW_BREAKPOINT off-case in ptrace_set_debugreg()
In-Reply-To: <20110519180626.GA16555@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Frederic Weisbecker <fweisbec@gmail.com>

commit 925f83c085e1bb08435556c5b4844a60de002e31 upstream.

We make use of ptrace_get_breakpoints() / ptrace_put_breakpoints() to
protect ptrace_set_debugreg() even if CONFIG_HAVE_HW_BREAKPOINT if off.
However in this case, these APIs are not implemented.

To fix this, push the protection down inside the relevant ifdef.
Best would be to export the code inside
CONFIG_HAVE_HW_BREAKPOINT into a standalone function to cleanup
the ifdefury there and call the breakpoint ref API inside. But
as it is more invasive, this should be rather made in an -rc1.

Fixes this build error:

  arch/powerpc/kernel/ptrace.c:1594: error: implicit declaration of function 'ptrace_get_breakpoints' make[2]: ***

Reported-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LPPC <linuxppc-dev@lists.ozlabs.org>
Cc: Prasad <prasad@linux.vnet.ibm.com>
Link: http://lkml.kernel.org/r/1304639598-4707-1-git-send-email-fweisbec@gmail.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/powerpc/kernel/ptrace.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

--- a/arch/powerpc/kernel/ptrace.c
+++ b/arch/powerpc/kernel/ptrace.c
@@ -924,12 +924,16 @@ int ptrace_set_debugreg(struct task_stru
 	if (data && !(data & DABR_TRANSLATION))
 		return -EIO;
 #ifdef CONFIG_HAVE_HW_BREAKPOINT
+	if (ptrace_get_breakpoints(task) < 0)
+		return -ESRCH;
+
 	bp = thread->ptrace_bps[0];
 	if ((!data) || !(data & (DABR_DATA_WRITE | DABR_DATA_READ))) {
 		if (bp) {
 			unregister_hw_breakpoint(bp);
 			thread->ptrace_bps[0] = NULL;
 		}
+		ptrace_put_breakpoints(task);
 		return 0;
 	}
 	if (bp) {
@@ -939,9 +943,12 @@ int ptrace_set_debugreg(struct task_stru
 					(DABR_DATA_WRITE | DABR_DATA_READ),
 							&attr.bp_type);
 		ret =  modify_user_hw_breakpoint(bp, &attr);
-		if (ret)
+		if (ret) {
+			ptrace_put_breakpoints(task);
 			return ret;
+		}
 		thread->ptrace_bps[0] = bp;
+		ptrace_put_breakpoints(task);
 		thread->dabr = data;
 		return 0;
 	}
@@ -956,9 +963,12 @@ int ptrace_set_debugreg(struct task_stru
 							ptrace_triggered, task);
 	if (IS_ERR(bp)) {
 		thread->ptrace_bps[0] = NULL;
+		ptrace_put_breakpoints(task);
 		return PTR_ERR(bp);
 	}
 
+	ptrace_put_breakpoints(task);
+
 #endif /* CONFIG_HAVE_HW_BREAKPOINT */
 
 	/* Move contents to the DABR register */


