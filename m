Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751566Ab0HYFoX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Aug 2010 01:44:23 -0400
Received: from smtp-out.google.com ([74.125.121.35]:54353 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751306Ab0HYFoU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Aug 2010 01:44:20 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:message-id:user-agent:
	mime-version:content-type:x-system-of-record;
	b=K23Ehv4JiKU4ds6ZrQdSgUjYYL3+izeY3ZMHabXZDbY50bSPbODmOBSpGvvjsfkhb
	e9xxjDyf/TLR2V5+Xvjqw==
Date: Tue, 24 Aug 2010 22:44:12 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@sister.anvils
To: "H. Peter Anvin" <hpa@zytor.com>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Joerg Roedel <joerg.roedel@amd.com>,
        Borislav Petkov <borislav.petkov@amd.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] x86: fix CONFIG_VMSPLIT_1G and 2G_OPT trampoline
Message-ID: <alpine.LSU.2.00.1008242235120.2515@sister.anvils>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

rc2 kernel crashes when booting second cpu on this CONFIG_VMSPLIT_2G_OPT
laptop: whereas cloning from kernel to low mappings pgd range does need
to limit by both KERNEL_PGD_PTRS and KERNEL_PGD_BOUNDARY, cloning kernel
pgd range itself must not be limited by the smaller KERNEL_PGD_BOUNDARY.

Signed-off-by: Hugh Dickins <hughd@google.com>
---

 arch/x86/kernel/trampoline.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- 2.6.36-rc2/arch/x86/kernel/trampoline.c.0	2010-08-22 18:56:44.000000000 -0700
+++ linux/arch/x86/kernel/trampoline.c	2010-08-24 22:11:08.000000000 -0700
@@ -45,8 +45,7 @@ void __init setup_trampoline_page_table(
 	/* Copy kernel address range */
 	clone_pgd_range(trampoline_pg_dir + KERNEL_PGD_BOUNDARY,
 			swapper_pg_dir + KERNEL_PGD_BOUNDARY,
-			min_t(unsigned long, KERNEL_PGD_PTRS,
-			      KERNEL_PGD_BOUNDARY));
+			KERNEL_PGD_PTRS);
 
 	/* Initialize low mappings */
 	clone_pgd_range(trampoline_pg_dir,
