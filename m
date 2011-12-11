Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752121Ab1LKSN3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Dec 2011 13:13:29 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:60233 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751986Ab1LKSN1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Dec 2011 13:13:27 -0500
Date: Sun, 11 Dec 2011 21:13:19 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
Cc: x86@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] i386: less assembly in strlen()
Message-ID: <20111211181319.GA17097@p183.telecom.by>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Current i386 strlen() hardcodes NOT/DEC sequence. DEC is mentioned
to be suboptimal on Core2. So, put only REPNE SCASB sequence in assembly,
compiler can do the rest.

The difference in generated code is like below (MCORE2=y):

	<strlen>:
		push   %edi
		mov    $0xffffffff,%ecx
		mov    %eax,%edi
		xor    %eax,%eax
		repnz scas %es:(%edi),%al
		not    %ecx

	-	dec    %ecx
	-	mov    %ecx,%eax
	+	lea    -0x1(%ecx),%eax

		pop    %edi
		ret

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 arch/x86/lib/string_32.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

--- a/arch/x86/lib/string_32.c
+++ b/arch/x86/lib/string_32.c
@@ -164,15 +164,13 @@ EXPORT_SYMBOL(strchr);
 size_t strlen(const char *s)
 {
 	int d0;
-	int res;
+	size_t res;
 	asm volatile("repne\n\t"
-		"scasb\n\t"
-		"notl %0\n\t"
-		"decl %0"
+		"scasb"
 		: "=c" (res), "=&D" (d0)
 		: "1" (s), "a" (0), "0" (0xffffffffu)
 		: "memory");
-	return res;
+	return ~res - 1;
 }
 EXPORT_SYMBOL(strlen);
 #endif
