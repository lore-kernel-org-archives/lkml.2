Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756635Ab2FDLga (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 07:36:30 -0400
Received: from nm25.bullet.mail.sp2.yahoo.com ([98.139.91.95]:47337 "HELO
	nm25.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752806Ab2FDLg0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 07:36:26 -0400
X-Yahoo-Newman-Id: 166347.41092.bm@omp1023.access.mail.mud.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: YCoFDJoVM1m2IiYG_o24NVuXT5wLGk9WjmE7cMNphV9RFmf
 MWNI0HasKuSwFKh83gZ9LnKZ8Ibf20kwbpw7mbIAf89ypHyiECTPSEBktqQo
 d7_Pf8N5MakBbHzVBXgTP_vRgmGHa_vz6hQK20.2z4i3K.oYYxBsxkf57o3h
 CagM4nu1pa9TN7CrCrA_cvwdLAGXT.JlHYgoaW9dWERr1Dgz9DRwl.MesklZ
 ELxXMJgyaBG8NGG8TLRjtgb0fLSmyKmNo5xfRQfM3x7850J.vmZ7znHekjHw
 Vb7sFf3VG06mSeXcf8RwbPZpxntmERaIdUuZA7SM3vZMXwKmbKFE4044yHGO
 Whulltdw1.z.mXqKuP7hBTTY3wH1fZc4_KdbvaQsCV8fMWZQQiMUC.KY61wL
 UvTG02w--
X-Yahoo-SMTP: xXkkXk6swBBAi.5wfkIWFW3ugxbrqyhyk_b4Z25Sfu.XGQ--
Message-ID: <4FCC9D7F.7070404@att.net>
Date: Mon, 04 Jun 2012 06:35:27 -0500
From: Daniel Santos <danielfsantos@att.net>
Reply-To: daniel.santos@pobox.com
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.4) Gecko/20120502 Thunderbird/10.0.4
MIME-Version: 1.0
To: Paul Gortmaker <paul.gortmaker@windriver.com>,
        Jason Wessel <jason.wessel@windriver.com>
CC: linux-kernel@vger.kernel.org
Subject: [PATCH] linux/bug.h: make BUILD_BUG_ON generate compile-time error
X-Enigmail-Version: 1.3.5
Content-Type: multipart/mixed;
 boundary="------------070906080407090309060403"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------070906080407090309060403
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit

This is pretty straight-forward. __compiletime_error is defined in
compiler-gcc4.h with appropriate version checks, so shouldn't break on
older compilers. This makes the difference between getting an error at
link-time and getting one at compile time. Example:

/home/daniel/proj/kernel/grbtest/grbtest2.c:83:2: error: call to
‘__build_bug_on_failed’ declared with attribute error: BUILD_BUG_ON
failed: !__builtin_constant_p(count)

The above points me directly to where I called BUILD_BUG_ON. Note that
I'm moving __build_bug_on_failed out of the global scope, just so it can
be re-declared with different attributes each time.

Daniel

--------------070906080407090309060403
Content-Type: text/x-patch;
 name="0006-linux-bug.h-make-BUILD_BUG_ON-generate-compile-time-.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0006-linux-bug.h-make-BUILD_BUG_ON-generate-compile-time-.pa";
 filename*1="tch"

>From 3af9a38225e6d074ef6b22e6c99c2503bc581953 Mon Sep 17 00:00:00 2001
From: Daniel Santos <daniel.santos@pobox.com>
Date: Mon, 4 Jun 2012 06:13:41 -0500
Subject: linux/bug.h: make BUILD_BUG_ON generate compile-time error

---
 include/linux/bug.h |   11 ++++++-----
 1 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/include/linux/bug.h b/include/linux/bug.h
index 72961c3..d35d6e9 100644
--- a/include/linux/bug.h
+++ b/include/linux/bug.h
@@ -48,11 +48,12 @@ struct pt_regs;
 #ifndef __OPTIMIZE__
 #define BUILD_BUG_ON(condition) ((void)sizeof(char[1 - 2*!!(condition)]))
 #else
-extern int __build_bug_on_failed;
-#define BUILD_BUG_ON(condition)					\
-	do {							\
-		((void)sizeof(char[1 - 2*!!(condition)]));	\
-		if (condition) __build_bug_on_failed = 1;	\
+#define BUILD_BUG_ON(condition)						\
+	do {								\
+		extern void __build_bug_on_failed(void)			\
+		__compiletime_error("BUILD_BUG_ON failed: " #condition);\
+		((void)sizeof(char[1 - 2*!!(condition)]));		\
+		if (condition) __build_bug_on_failed();			\
 	} while(0)
 #endif
 
-- 
1.7.3.4


--------------070906080407090309060403--
