Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752603Ab1GDWnF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jul 2011 18:43:05 -0400
Received: from smtp.outflux.net ([198.145.64.163]:38223 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752435Ab1GDWnD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jul 2011 18:43:03 -0400
From: Kees Cook <kees.cook@canonical.com>
To: x86@kernel.org, linux-kernel@vger.kernel.org
Cc: Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH 1/2] x86: give names to realmode wakeup flags
Date: Mon,  4 Jul 2011 15:35:52 -0700
Message-Id: <1309818953-769-2-git-send-email-kees.cook@canonical.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1309818953-769-1-git-send-email-kees.cook@canonical.com>
References: <1309818953-769-1-git-send-email-kees.cook@canonical.com>
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of using literals, use a common set of names for the
user-controlled realmode wakeup flags.

Signed-off-by: Kees Cook <kees.cook@canonical.com>
---
 arch/x86/kernel/acpi/realmode/wakemain.c |    6 +++---
 arch/x86/kernel/acpi/realmode/wakeup.h   |    4 ++++
 arch/x86/kernel/acpi/sleep.c             |    6 +++---
 3 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/acpi/realmode/wakemain.c b/arch/x86/kernel/acpi/realmode/wakemain.c
index 883962d..1749cde 100644
--- a/arch/x86/kernel/acpi/realmode/wakemain.c
+++ b/arch/x86/kernel/acpi/realmode/wakemain.c
@@ -67,13 +67,13 @@ void main(void)
 	if (wakeup_header.real_magic != 0x12345678)
 		while (1);
 
-	if (wakeup_header.realmode_flags & 4)
+	if (wakeup_header.realmode_flags & WAKE_FLAG_BEEP)
 		send_morse("...-");
 
-	if (wakeup_header.realmode_flags & 1)
+	if (wakeup_header.realmode_flags & WAKE_FLAG_BIOS)
 		asm volatile("lcallw   $0xc000,$3");
 
-	if (wakeup_header.realmode_flags & 2) {
+	if (wakeup_header.realmode_flags & WAKE_FLAG_MODE) {
 		/* Need to call BIOS */
 		probe_cards(0);
 		set_mode(wakeup_header.video_mode);
diff --git a/arch/x86/kernel/acpi/realmode/wakeup.h b/arch/x86/kernel/acpi/realmode/wakeup.h
index e1828c0..88f0e6c 100644
--- a/arch/x86/kernel/acpi/realmode/wakeup.h
+++ b/arch/x86/kernel/acpi/realmode/wakeup.h
@@ -39,4 +39,8 @@ extern struct wakeup_header wakeup_header;
 #define WAKEUP_HEADER_SIGNATURE 0x51ee1111
 #define WAKEUP_END_SIGNATURE	0x65a22c82
 
+#define WAKEUP_FLAG_BIOS        1
+#define WAKEUP_FLAG_MODE        2
+#define WAKEUP_FLAG_BEEP        4
+
 #endif /* ARCH_X86_KERNEL_ACPI_RM_WAKEUP_H */
diff --git a/arch/x86/kernel/acpi/sleep.c b/arch/x86/kernel/acpi/sleep.c
index 18a857b..cb968e5 100644
--- a/arch/x86/kernel/acpi/sleep.c
+++ b/arch/x86/kernel/acpi/sleep.c
@@ -104,11 +104,11 @@ static int __init acpi_sleep_setup(char *str)
 {
 	while ((str != NULL) && (*str != '\0')) {
 		if (strncmp(str, "s3_bios", 7) == 0)
-			acpi_realmode_flags |= 1;
+			acpi_realmode_flags |= WAKEUP_FLAG_BIOS;
 		if (strncmp(str, "s3_mode", 7) == 0)
-			acpi_realmode_flags |= 2;
+			acpi_realmode_flags |= WAKEUP_FLAG_MODE;
 		if (strncmp(str, "s3_beep", 7) == 0)
-			acpi_realmode_flags |= 4;
+			acpi_realmode_flags |= WAKEUP_FLAG_BEEP;
 #ifdef CONFIG_HIBERNATION
 		if (strncmp(str, "s4_nohwsig", 10) == 0)
 			acpi_no_s4_hw_signature();
-- 
1.7.4.1

