Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754462Ab2GRWTt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 18:19:49 -0400
Received: from g6t0185.atlanta.hp.com ([15.193.32.62]:48208 "EHLO
	g6t0185.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751440Ab2GRWTr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 18:19:47 -0400
From: Greg Pearson <greg.pearson@hp.com>
To: khalid.aziz@hp.com
Cc: linux-kernel@vger.kernel.org, greg.pearson@hp.com
Subject: [PATCH] PCDP: use early_ioremap/early_iounmap to access pcdp table
Date: Wed, 18 Jul 2012 16:19:34 -0600
Message-Id: <1342649974-6860-1-git-send-email-greg.pearson@hp.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The efi_setup_pcdp_console routine is called during boot to
parse the HCDP/PCDP EFI system table and setup an early console
for printk output. The routine uses ioremap/iounmap to setup
access to the HCDP/PCDP table information. The call to ioremap
is happening early in the boot process which leads to a panic
on x86_64 systems:

    0xffffffff815ffbd4 panic+0x01ca
    0xffffffff810535ec do_exit+0x043c
    0xffffffff81603847 oops_end+0x00a7
    0xffffffff81042859 no_context+0x0119
    0xffffffff81042a68 __bad_area_nosemaphore+0x0138
    0xffffffff81042b5e bad_area_nosemaphore+0x000e
    0xffffffff81606411 do_page_fault+0x0321
    0xffffffff81602cb0 page_fault+0x0020
    0xffffffff81045fc1 reserve_memtype+0x02a1
    0xffffffff810430a3 __ioremap_caller+0x0123
    0xffffffff81043402 ioremap_nocache+0x0012
    0xffffffff81d53e70 efi_setup_pcdp_console+0x002b
    0xffffffff81d1fcc5 setup_arch+0x03a9
    0xffffffff81d19b44 start_kernel+0x00d4
    0xffffffff81d19341 x86_64_start_reservations+0x012c
    0xffffffff81d19449 x86_64_start_kernel+0x00fe

This patch replaces the calls to ioremap/iounmap in
efi_setup_pcdp_console with calls to early_ioremap/early_iounmap
which can be called during early boot.

This patch was tested on an x86_64 prototype system which uses
the HCDP/PCDP table for early console setup.

Signed-off-by: Greg Pearson <greg.pearson@hp.com>
---
 drivers/firmware/pcdp.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/firmware/pcdp.c b/drivers/firmware/pcdp.c
index 51e0e2d..a330492 100644
--- a/drivers/firmware/pcdp.c
+++ b/drivers/firmware/pcdp.c
@@ -95,7 +95,7 @@ efi_setup_pcdp_console(char *cmdline)
 	if (efi.hcdp == EFI_INVALID_TABLE_ADDR)
 		return -ENODEV;
 
-	pcdp = ioremap(efi.hcdp, 4096);
+	pcdp = early_ioremap(efi.hcdp, 4096);
 	printk(KERN_INFO "PCDP: v%d at 0x%lx\n", pcdp->rev, efi.hcdp);
 
 	if (strstr(cmdline, "console=hcdp")) {
@@ -131,6 +131,6 @@ efi_setup_pcdp_console(char *cmdline)
 	}
 
 out:
-	iounmap(pcdp);
+	early_iounmap(pcdp, 4096);
 	return rc;
 }
-- 
1.7.5.4

