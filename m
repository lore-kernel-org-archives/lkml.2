Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753966Ab2HMUVq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 16:21:46 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:51291 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753764Ab2HMUVn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 16:21:43 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Greg Pearson <greg.pearson@hp.com>, Khalid Aziz <khalid.aziz@hp.com>
Subject: [ 15/82] pcdp: use early_ioremap/early_iounmap to access pcdp table
Date: Mon, 13 Aug 2012 13:18:51 -0700
Message-Id: <20120813201747.767790420@linuxfoundation.org>
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

From: Greg Pearson <greg.pearson@hp.com>

commit 6c4088ac3a4d82779903433bcd5f048c58fb1aca upstream.

efi_setup_pcdp_console() is called during boot to parse the HCDP/PCDP
EFI system table and setup an early console for printk output.  The
routine uses ioremap/iounmap to setup access to the HCDP/PCDP table
information.

The call to ioremap is happening early in the boot process which leads
to a panic on x86_64 systems:

    panic+0x01ca
    do_exit+0x043c
    oops_end+0x00a7
    no_context+0x0119
    __bad_area_nosemaphore+0x0138
    bad_area_nosemaphore+0x000e
    do_page_fault+0x0321
    page_fault+0x0020
    reserve_memtype+0x02a1
    __ioremap_caller+0x0123
    ioremap_nocache+0x0012
    efi_setup_pcdp_console+0x002b
    setup_arch+0x03a9
    start_kernel+0x00d4
    x86_64_start_reservations+0x012c
    x86_64_start_kernel+0x00fe

This replaces the calls to ioremap/iounmap in efi_setup_pcdp_console()
with calls to early_ioremap/early_iounmap which can be called during
early boot.

This patch was tested on an x86_64 prototype system which uses the
HCDP/PCDP table for early console setup.

Signed-off-by: Greg Pearson <greg.pearson@hp.com>
Acked-by: Khalid Aziz <khalid.aziz@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/firmware/pcdp.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

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


