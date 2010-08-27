Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752752Ab0H0VF6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 17:05:58 -0400
Received: from mail.perches.com ([173.55.12.10]:1456 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751973Ab0H0VF5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 17:05:57 -0400
Subject: [rfc PATCH] vsprintf.c: use default pointer field size for
 "(null)" strings
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 27 Aug 2010 14:05:56 -0700
Message-ID: <1282943156.1946.30.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It might be nicer to align the output.

For instance, ACPI messages sometimes have "(null)" pointers.

$ dmesg | grep "(null)"  -A 1 -B 1
[    0.198733] ACPI: Dynamic OEM Table Load:
[    0.198745] ACPI: SSDT (null) 00239 (v02  PmRef  Cpu0Ist 00003000 INTL 20051117)
[    0.199294] ACPI: SSDT 7f596e10 001C7 (v02  PmRef  Cpu0Cst 00003001 INTL 20051117)
[    0.200708] ACPI: Dynamic OEM Table Load:
[    0.200721] ACPI: SSDT (null) 001C7 (v02  PmRef  Cpu0Cst 00003001 INTL 20051117)
[    0.201950] ACPI: SSDT 7f597f10 000D0 (v02  PmRef  Cpu1Ist 00003000 INTL 20051117)
[    0.203386] ACPI: Dynamic OEM Table Load:
[    0.203398] ACPI: SSDT (null) 000D0 (v02  PmRef  Cpu1Ist 00003000 INTL 20051117)
[    0.203871] ACPI: SSDT 7f595f10 00083 (v02  PmRef  Cpu1Cst 00003000 INTL 20051117)
[    0.205301] ACPI: Dynamic OEM Table Load:
[    0.205315] ACPI: SSDT (null) 00083 (v02  PmRef  Cpu1Cst 00003000 INTL 20051117)

Signed-off-by: Joe Perches <joe@perches.com>
---
 lib/vsprintf.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/lib/vsprintf.c b/lib/vsprintf.c
index 7af9d84..da1cc99 100644
--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -988,8 +988,11 @@ static noinline_for_stack
 char *pointer(const char *fmt, char *buf, char *end, void *ptr,
 	      struct printf_spec spec)
 {
-	if (!ptr)
+	if (!ptr) {
+		if (spec.field_width == -1)
+			spec.field_width = 2 * sizeof(void *);
 		return string(buf, end, "(null)", spec);
+	}
 
 	switch (*fmt) {
 	case 'F':
@@ -1031,7 +1034,7 @@ char *pointer(const char *fmt, char *buf, char *end, void *ptr,
 	}
 	spec.flags |= SMALL;
 	if (spec.field_width == -1) {
-		spec.field_width = 2*sizeof(void *);
+		spec.field_width = 2 * sizeof(void *);
 		spec.flags |= ZEROPAD;
 	}
 	spec.base = 16;


