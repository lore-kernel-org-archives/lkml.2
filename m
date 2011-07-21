Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752831Ab1GUKJY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 06:09:24 -0400
Received: from hera.kernel.org ([140.211.167.34]:60127 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751564Ab1GUKJV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 06:09:21 -0400
Date: Thu, 21 Jul 2011 10:08:52 GMT
From: tip-bot for Jan Beulich <JBeulich@novell.com>
Message-ID: <tip-ef68c8f87ed13f65df867dddf36c0e185b27b942@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, mjg@redhat.com, hpa@zytor.com,
        mingo@redhat.com, mjg59@srcf.ucam.org, jbeulich@novell.com,
        JBeulich@novell.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, mjg@redhat.com,
        linux-kernel@vger.kernel.org, jbeulich@novell.com, JBeulich@novell.com,
        mjg59@srcf.ucam.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <4E257E33020000780004E319@nat28.tlf.novell.com>
References: <4E257E33020000780004E319@nat28.tlf.novell.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/rtc] x86: Serialize EFI time accesses on rtc_lock
Git-Commit-ID: ef68c8f87ed13f65df867dddf36c0e185b27b942
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 21 Jul 2011 10:08:56 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ef68c8f87ed13f65df867dddf36c0e185b27b942
Gitweb:     http://git.kernel.org/tip/ef68c8f87ed13f65df867dddf36c0e185b27b942
Author:     Jan Beulich <JBeulich@novell.com>
AuthorDate: Tue, 19 Jul 2011 11:53:07 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 21 Jul 2011 09:21:00 +0200

x86: Serialize EFI time accesses on rtc_lock

The EFI specification requires that callers of the time related
runtime functions serialize with other CMOS accesses in the
kernel, as the EFI time functions may choose to also use the
legacy CMOS RTC.

Besides fixing a latent bug, this is a prerequisite to safely
enable the rtc-efi driver for x86, which ought to be preferred
over rtc-cmos on all EFI platforms.

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Acked-by: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: <mjg@redhat.com>
Link: http://lkml.kernel.org/r/4E257E33020000780004E319@nat28.tlf.novell.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Cc: Matthew Garrett <mjg@redhat.com>
---
 arch/x86/platform/efi/efi.c |   39 +++++++++++++++++++++++++++++++++------
 1 files changed, 33 insertions(+), 6 deletions(-)

diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index 474356b..b8823d5 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -79,26 +79,50 @@ early_param("add_efi_memmap", setup_add_efi_memmap);
 
 static efi_status_t virt_efi_get_time(efi_time_t *tm, efi_time_cap_t *tc)
 {
-	return efi_call_virt2(get_time, tm, tc);
+	unsigned long flags;
+	efi_status_t status;
+
+	spin_lock_irqsave(&rtc_lock, flags);
+	status = efi_call_virt2(get_time, tm, tc);
+	spin_unlock_irqrestore(&rtc_lock, flags);
+	return status;
 }
 
 static efi_status_t virt_efi_set_time(efi_time_t *tm)
 {
-	return efi_call_virt1(set_time, tm);
+	unsigned long flags;
+	efi_status_t status;
+
+	spin_lock_irqsave(&rtc_lock, flags);
+	status = efi_call_virt1(set_time, tm);
+	spin_unlock_irqrestore(&rtc_lock, flags);
+	return status;
 }
 
 static efi_status_t virt_efi_get_wakeup_time(efi_bool_t *enabled,
 					     efi_bool_t *pending,
 					     efi_time_t *tm)
 {
-	return efi_call_virt3(get_wakeup_time,
-			      enabled, pending, tm);
+	unsigned long flags;
+	efi_status_t status;
+
+	spin_lock_irqsave(&rtc_lock, flags);
+	status = efi_call_virt3(get_wakeup_time,
+				enabled, pending, tm);
+	spin_unlock_irqrestore(&rtc_lock, flags);
+	return status;
 }
 
 static efi_status_t virt_efi_set_wakeup_time(efi_bool_t enabled, efi_time_t *tm)
 {
-	return efi_call_virt2(set_wakeup_time,
-			      enabled, tm);
+	unsigned long flags;
+	efi_status_t status;
+
+	spin_lock_irqsave(&rtc_lock, flags);
+	status = efi_call_virt2(set_wakeup_time,
+				enabled, tm);
+	spin_unlock_irqrestore(&rtc_lock, flags);
+	return status;
 }
 
 static efi_status_t virt_efi_get_variable(efi_char16_t *name,
@@ -164,11 +188,14 @@ static efi_status_t __init phys_efi_set_virtual_address_map(
 static efi_status_t __init phys_efi_get_time(efi_time_t *tm,
 					     efi_time_cap_t *tc)
 {
+	unsigned long flags;
 	efi_status_t status;
 
+	spin_lock_irqsave(&rtc_lock, flags);
 	efi_call_phys_prelog();
 	status = efi_call_phys2(efi_phys.get_time, tm, tc);
 	efi_call_phys_epilog();
+	spin_unlock_irqrestore(&rtc_lock, flags);
 	return status;
 }
 
