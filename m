Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754515Ab1JKKwR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 06:52:17 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:57310 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752266Ab1JKKwP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 06:52:15 -0400
From: Matt Fleming <matt@console-pimps.org>
To: linux-kernel@vger.kernel.org
Cc: Matthew Garrett <mjg@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org, Zhang Rui <rui.zhang@intel.com>
Subject: [PATCH] x86, efi: Convert efi_phys_get_time() args to physical addresses
Date: Tue, 11 Oct 2011 11:52:13 +0100
Message-Id: <1318330333-4617-1-git-send-email-matt@console-pimps.org>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Maurice Ma <maurice.ma@intel.com>

Because callers of efi_phys_get_time() pass virtual stack addresses as
arguments, we need to find their corresponding physical addresses and
when calling GetTime() in physical mode.

Without this patch the following line is printed on boot,

	"Oops: efitime: can't read time!"

Cc: Matthew Garrett <mjg@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: x86@kernel.org
Cc: Zhang Rui <rui.zhang@intel.com>
Signed-off-by: Maurice Ma <maurice.ma@intel.com>
Signed-off-by: Matt Fleming <matt.fleming@intel.com>
---
 arch/x86/platform/efi/efi.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index 3ae4128..d182bba 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -237,7 +237,8 @@ static efi_status_t __init phys_efi_get_time(efi_time_t *tm,
 
 	spin_lock_irqsave(&rtc_lock, flags);
 	efi_call_phys_prelog();
-	status = efi_call_phys2(efi_phys.get_time, tm, tc);
+	status = efi_call_phys2(efi_phys.get_time, virt_to_phys(tm),
+				virt_to_phys(tc));
 	efi_call_phys_epilog();
 	spin_unlock_irqrestore(&rtc_lock, flags);
 	return status;
-- 
1.7.4.4

