Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756242Ab1CRMqB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 08:46:01 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:34450 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754465Ab1CRMp4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 08:45:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:sender:date:x-google-sender-auth:message-id:subject
         :from:to:content-type;
        b=xiaaCJs8dG2MapELw2Rv0wR2sPa+G7zCKFofUm3/yM5UaSl2xSOYarCvl+AlDd9AK5
         CmyiPkxaybvm4W7fcbFH6wmaGA2vXgvSNkslGxTF29Nhx8kwJWswtpOiL+M7TraPgqSC
         sJ2qXILnnGQ0SNUMX0zRJzKWgknbG9Tkrr6e0=
MIME-Version: 1.0
Date: Fri, 18 Mar 2011 13:45:55 +0100
X-Google-Sender-Auth: lls3aFtuXFK59-9BFnkem7Z1Ajc
Message-ID: <AANLkTinjYOmOk0MLUDQB6pzGwrbC0m9OQt0oh9gH9L1C@mail.gmail.com>
Subject: [PATCH] arch/x86/boot: added support for early builtin command-line
From: Maximilian Schneider <not.m.schneider@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So far the builtin command-line was appended to the bootloader
supplied one in arch/x86/kernel/setup.c. Code executed before (e.g.
arch/x86/boot/*) would not access the builtin command-line and
therefore not react to parameters configuring the early setup (e.g.
earlyprintk).

---
 arch/x86/boot/boot.h |   30 ++++++++++++++++++++++++++++++
 arch/x86/boot/main.c |    1 +
 2 files changed, 31 insertions(+), 0 deletions(-)

diff --git a/arch/x86/boot/boot.h b/arch/x86/boot/boot.h
index c7093bd..f3c6f9e 100644
--- a/arch/x86/boot/boot.h
+++ b/arch/x86/boot/boot.h
@@ -37,6 +37,7 @@

 extern struct setup_header hdr;
 extern struct boot_params boot_params;
+extern char builtin_cmd_line[];

 #define cpu_relax()    asm volatile("rep; nop")

@@ -289,12 +290,41 @@ int __cmdline_find_option(u32 cmdline_ptr, const
char *option, char *buffer, int
 int __cmdline_find_option_bool(u32 cmdline_ptr, const char *option);
 static inline int cmdline_find_option(const char *option, char
*buffer, int bufsize)
 {
+#ifdef CONFIG_CMDLINE_BOOL
+       u32 builtin_cmdline_ptr = (ds() << 4) + (u16)builtin_cmd_line;
+#ifdef CONFIG_CMDLINE_OVERRIDE
+       return __cmdline_find_option(builtin_cmdline_ptr, option,
buffer, bufsize);
+#else // !CONFIG_CMDLINE_OVERRIDE && CONFIG_CMDLINE_BOOL
+       int length_cmdline = __cmdline_find_option(boot_params.hdr.cmd_line_ptr,
+                        option, buffer, bufsize);
+       if (length_cmdline == -1) {
+               return __cmdline_find_option(builtin_cmdline_ptr,
option, buffer, bufsize);
+       } else {
+               return length_cmdline;
+       }
+#endif // CONFIG_CMDLINE_OVERRIDE
+#else // !CONFIG_CMDLINE_BOOL
        return __cmdline_find_option(boot_params.hdr.cmd_line_ptr,
option, buffer, bufsize);
+#endif
 }

 static inline int cmdline_find_option_bool(const char *option)
 {
+#ifdef CONFIG_CMDLINE_BOOL
+       u32 builtin_cmdline_ptr = (ds() << 4) + (u16)builtin_cmd_line;
+#ifdef CONFIG_CMDLINE_OVERRIDE
+       return __cmdline_find_option_bool(builtin_cmdline_ptr, option);
+#else // !CONFIG_CMDLINE_OVERRIDE && CONFIG_CMDLINE_BOOL
+       int length_cmdline =
__cmdline_find_option_bool(boot_params.hdr.cmd_line_ptr, option);
+       if (length_cmdline == -1) {
+               return __cmdline_find_option_bool(builtin_cmdline_ptr, option);
+       } else {
+               return length_cmdline;
+       }
+#endif // CONFIG_CMDLINE_OVERRIDE
+#else // !CONFIG_CMDLINE_BOOL
        return __cmdline_find_option_bool(boot_params.hdr.cmd_line_ptr, option);
+#endif
 }


diff --git a/arch/x86/boot/main.c b/arch/x86/boot/main.c
index 40358c8..9b12007 100644
--- a/arch/x86/boot/main.c
+++ b/arch/x86/boot/main.c
@@ -16,6 +16,7 @@
 #include "boot.h"

 struct boot_params boot_params __attribute__((aligned(16)));
+char builtin_cmd_line[] __attribute__((aligned(16))) = CONFIG_CMDLINE;

 char *HEAP = _end;
 char *heap_end = _end;         /* Default end of heap = no heap */
-- 
1.7.0.4
