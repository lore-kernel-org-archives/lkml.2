Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757213Ab2ILXsA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 19:48:00 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:58620 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757084Ab2ILXpE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 19:45:04 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, Anton Blanchard <anton@samba.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [ 33/46] powerpc: Fix DSCR inheritance in copy_thread()
Date: Wed, 12 Sep 2012 16:39:23 -0700
Message-Id: <20120912233821.138175191@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120912233817.662663809@linuxfoundation.org>
References: <20120912233817.662663809@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.0-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/kernel/process.c |   12 ++----------
 1 file changed, 2 insertions(+), 10 deletions(-)

--- a/arch/powerpc/kernel/process.c
+++ b/arch/powerpc/kernel/process.c
@@ -794,16 +794,8 @@ int copy_thread(unsigned long clone_flag
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
 


