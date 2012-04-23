Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754127Ab2DWHKg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 03:10:36 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:45494 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754002Ab2DWHKc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 03:10:32 -0400
Date: Mon, 23 Apr 2012 00:09:15 -0700
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>
Cc: Russell King <linux@arm.linux.org.uk>, Mike Frysinger <vapier@gentoo.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Richard Weinberger <richard@nod.at>, Paul Mundt <lethal@linux-sh.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        John Stultz <john.stultz@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        uclinux-dist-devel@blackfin.uclinux.org, linuxppc-dev@lists.ozlabs.org,
        linux-sh@vger.kernel.org, user-mode-linux-devel@lists.sourceforge.net,
        linaro-kernel@lists.linaro.org, patches@linaro.org, linux-mm@kvack.org
Subject: [PATCH 6/9] blackfin: Fix possible deadlock in decode_address()
Message-ID: <20120423070915.GF30752@lizard>
References: <20120423070641.GA27702@lizard>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20120423070641.GA27702@lizard>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov found an interesting deadlock possibility:

> sysrq_showregs_othercpus() does smp_call_function(showacpu)
> and showacpu() show_stack()->decode_address(). Now suppose that IPI
> interrupts the task holding read_lock(tasklist).

To fix this, blackfin should not grab the write_ variant of the
tasklist lock, read_ one is enough.

Suggested-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Anton Vorontsov <anton.vorontsov@linaro.org>
---
 arch/blackfin/kernel/trace.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/blackfin/kernel/trace.c b/arch/blackfin/kernel/trace.c
index d08f0e3..f7f7a18 100644
--- a/arch/blackfin/kernel/trace.c
+++ b/arch/blackfin/kernel/trace.c
@@ -29,7 +29,7 @@ void decode_address(char *buf, unsigned long address)
 {
 	struct task_struct *p;
 	struct mm_struct *mm;
-	unsigned long flags, offset;
+	unsigned long offset;
 	struct rb_node *n;
 
 #ifdef CONFIG_KALLSYMS
@@ -113,7 +113,7 @@ void decode_address(char *buf, unsigned long address)
 	 * mappings of all our processes and see if we can't be a whee
 	 * bit more specific
 	 */
-	write_lock_irqsave(&tasklist_lock, flags);
+	read_lock(&tasklist_lock);
 	for_each_process(p) {
 		struct task_struct *t;
 
@@ -186,7 +186,7 @@ __continue:
 	sprintf(buf, "/* kernel dynamic memory */");
 
 done:
-	write_unlock_irqrestore(&tasklist_lock, flags);
+	read_unlock(&tasklist_lock);
 }
 
 #define EXPAND_LEN ((1 << CONFIG_DEBUG_BFIN_HWTRACE_EXPAND_LEN) * 256 - 1)
-- 
1.7.9.2

