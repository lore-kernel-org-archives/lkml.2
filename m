Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754794Ab2IQA5e (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2012 20:57:34 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33920 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754645Ab2IQAv0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2012 20:51:26 -0400
Message-Id: <20120917003631.514835802@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 17 Sep 2012 01:37:03 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Anton Blanchard <anton@samba.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [ 038/135] powerpc: Fix DSCR inheritance in copy_thread()
In-Reply-To: <20120917003625.784119135@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anton Blanchard <anton@samba.org>

commit 1021cb268b3025573c4811f1dee4a11260c4507b upstream.

If the default DSCR is non zero we set thread.dscr_inherit in
copy_thread() meaning the new thread and all its children will ignore
future updates to the default DSCR. This is not intended and is
a change in behaviour that a number of our users have hit.

We just need to inherit thread.dscr and thread.dscr_inherit from
the parent which ends up being much simpler.

This was found with the following test case:

http://ozlabs.org/~anton/junkcode/dscr_default_test.c

Signed-off-by: Anton Blanchard <anton@samba.org>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/powerpc/kernel/process.c |   12 ++----------
 1 file changed, 2 insertions(+), 10 deletions(-)

diff --git a/arch/powerpc/kernel/process.c b/arch/powerpc/kernel/process.c
index 710f400..1a1f2dd 100644
--- a/arch/powerpc/kernel/process.c
+++ b/arch/powerpc/kernel/process.c
@@ -802,16 +802,8 @@ int copy_thread(unsigned long clone_flags, unsigned long usp,
 #endif /* CONFIG_PPC_STD_MMU_64 */
 #ifdef CONFIG_PPC64 
 	if (cpu_has_feature(CPU_FTR_DSCR)) {
-		if (current->thread.dscr_inherit) {
-			p->thread.dscr_inherit = 1;
-			p->thread.dscr = current->thread.dscr;
-		} else if (0 != dscr_default) {
-			p->thread.dscr_inherit = 1;
-			p->thread.dscr = dscr_default;
-		} else {
-			p->thread.dscr_inherit = 0;
-			p->thread.dscr = 0;
-		}
+		p->thread.dscr_inherit = current->thread.dscr_inherit;
+		p->thread.dscr = current->thread.dscr;
 	}
 #endif
 


