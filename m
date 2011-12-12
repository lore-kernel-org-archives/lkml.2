Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753843Ab1LLShn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 13:37:43 -0500
Received: from terminus.zytor.com ([198.137.202.10]:40928 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753286Ab1LLShl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 13:37:41 -0500
Date: Mon, 12 Dec 2011 10:37:23 -0800
From: tip-bot for Alexey Dobriyan <adobriyan@gmail.com>
Message-ID: <tip-890890cb8e415e1e7a61bfe3c8e246f710196824@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        torvalds@linux-foundation.org, JBeulich@suse.com, tglx@linutronix.de,
        adobriyan@gmail.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, JBeulich@suse.com, tglx@linutronix.de,
        adobriyan@gmail.com, mingo@elte.hu
In-Reply-To: <20111211181319.GA17097@p183.telecom.by>
References: <20111211181319.GA17097@p183.telecom.by>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/asm] x86/i386: Use less assembly in strlen(), speed things up a bit
Git-Commit-ID: 890890cb8e415e1e7a61bfe3c8e246f710196824
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 12 Dec 2011 10:37:29 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  890890cb8e415e1e7a61bfe3c8e246f710196824
Gitweb:     http://git.kernel.org/tip/890890cb8e415e1e7a61bfe3c8e246f710196824
Author:     Alexey Dobriyan <adobriyan@gmail.com>
AuthorDate: Sun, 11 Dec 2011 21:13:19 +0300
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 12 Dec 2011 18:33:42 +0100

x86/i386: Use less assembly in strlen(), speed things up a bit

Current i386 strlen() hardcodes NOT/DEC sequence. DEC is
mentioned to be suboptimal on Core2. So, put only REPNE SCASB
sequence in assembly, compiler can do the rest.

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
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jan Beulich <JBeulich@suse.com>
Link: http://lkml.kernel.org/r/20111211181319.GA17097@p183.telecom.by
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/lib/string_32.c |    8 +++-----
 1 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/arch/x86/lib/string_32.c b/arch/x86/lib/string_32.c
index 82004d2..bd59090 100644
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
