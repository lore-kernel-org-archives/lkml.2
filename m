Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753914Ab1GGBJo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 21:09:44 -0400
Received: from smtp.outflux.net ([198.145.64.163]:46496 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751857Ab1GGBJn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 21:09:43 -0400
Date: Wed, 6 Jul 2011 18:09:10 -0700
From: Kees Cook <kees.cook@canonical.com>
To: linux-kernel@vger.kernel.org
Cc: Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org
Subject: [PATCH v2] x86: give names to realmode wakeup flags
Message-ID: <20110707010910.GA7877@outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: Canonical
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of using literals, use a common set of names for the
user-controlled realmode wakeup flags.

Signed-off-by: Kees Cook <kees.cook@canonical.com>
---
v2: split from the MISC_ENABLE restoration patch

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
index 97a29e1..516c885 100644
--- a/arch/x86/kernel/acpi/realmode/wakeup.h
+++ b/arch/x86/kernel/acpi/realmode/wakeup.h
@@ -38,6 +38,10 @@ struct wakeup_header {
 extern struct wakeup_header wakeup_header;
 #endif
 
+#define WAKEUP_FLAG_BIOS        1
+#define WAKEUP_FLAG_MODE        2
+#define WAKEUP_FLAG_BEEP        4
+
 #define WAKEUP_HEADER_OFFSET	8
 #define WAKEUP_HEADER_SIGNATURE 0x51ee1111
 #define WAKEUP_END_SIGNATURE	0x65a22c82
diff --git a/arch/x86/kernel/acpi/sleep.c b/arch/x86/kernel/acpi/sleep.c
index 103b6ab..12115a9 100644
--- a/arch/x86/kernel/acpi/sleep.c
+++ b/arch/x86/kernel/acpi/sleep.c
@@ -110,11 +110,11 @@ static int __init acpi_sleep_setup(char *str)
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

-- 
Kees Cook
Ubuntu Security Team
