Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932183Ab1GELWY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 07:22:24 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:37233 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932165Ab1GELWX convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com:3:1>);
	Tue, 5 Jul 2011 07:22:23 -0400
Message-Id: <4E13100A020000780004C256@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Tue, 05 Jul 2011 12:22:18 +0100
From: "Jan Beulich" <JBeulich@novell.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH, resend] x86/EFI: properly pre-initialize table
	 pointers
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Consumers of the table pointers in struct efi check for
EFI_INVALID_TABLE_ADDR to determine validity, hence these pointers
should all be pre-initialized to this value (rather than zero).

Noticed by the discrepancy between efivars' systab sysfs entry showing
all tables (and their pointers) despite the code intending to only
display the valid ones. No other bad effects known, but having the
various table parsing routines bogusly access physical address zero is
certainly not very desirable (even though they're unlikely to find
anything useful there).

Signed-off-by: Jan Beulich <jbeulich@novell.com>

---
 arch/x86/platform/efi/efi.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

--- 3.0-rc6/arch/x86/platform/efi/efi.c
+++ 3.0-rc6-x86-EFI/arch/x86/platform/efi/efi.c
@@ -51,7 +51,17 @@
 int efi_enabled;
 EXPORT_SYMBOL(efi_enabled);
 
-struct efi efi;
+struct efi __read_mostly efi = {
+	.mps        = EFI_INVALID_TABLE_ADDR,
+	.acpi       = EFI_INVALID_TABLE_ADDR,
+	.acpi20     = EFI_INVALID_TABLE_ADDR,
+	.smbios     = EFI_INVALID_TABLE_ADDR,
+	.sal_systab = EFI_INVALID_TABLE_ADDR,
+	.boot_info  = EFI_INVALID_TABLE_ADDR,
+	.hcdp       = EFI_INVALID_TABLE_ADDR,
+	.uga        = EFI_INVALID_TABLE_ADDR,
+	.uv_systab  = EFI_INVALID_TABLE_ADDR,
+};
 EXPORT_SYMBOL(efi);
 
 struct efi_memory_map memmap;



