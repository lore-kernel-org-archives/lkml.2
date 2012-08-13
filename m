Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754243Ab2HMUWs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 16:22:48 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:55329 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754160Ab2HMUWo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 16:22:44 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Paul Mundt <lethal@linux-sh.org>
Subject: [ 36/82] sh: Fix up recursive fault in oops with unset TTB.
Date: Mon, 13 Aug 2012 13:19:12 -0700
Message-Id: <20120813201749.592000233@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120813201746.448504360@linuxfoundation.org>
References: <20120813201746.448504360@linuxfoundation.org>
User-Agent: quilt/0.60-20.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paul Mundt <lethal@linux-sh.org>

commit 90eed7d87b748f9c0d11b9bad64a4c41e31b78c4 upstream.

Presently the oops code looks for the pgd either from the mm context or
the cached TTB value. There are presently cases where the TTB can be
unset or otherwise cleared by hardware, which we weren't handling,
resulting in recursive faults on the NULL pgd. In these cases we can
simply reload from swapper_pg_dir and continue on as normal.

Signed-off-by: Paul Mundt <lethal@linux-sh.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/sh/mm/fault.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/arch/sh/mm/fault.c
+++ b/arch/sh/mm/fault.c
@@ -58,11 +58,15 @@ static void show_pte(struct mm_struct *m
 {
 	pgd_t *pgd;
 
-	if (mm)
+	if (mm) {
 		pgd = mm->pgd;
-	else
+	} else {
 		pgd = get_TTB();
 
+		if (unlikely(!pgd))
+			pgd = swapper_pg_dir;
+	}
+
 	printk(KERN_ALERT "pgd = %p\n", pgd);
 	pgd += pgd_index(addr);
 	printk(KERN_ALERT "[%08lx] *pgd=%0*Lx", addr,


