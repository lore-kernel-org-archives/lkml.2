Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755618Ab2BVVzw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 16:55:52 -0500
Received: from hulk.biessmann.org ([62.75.166.25]:44082 "EHLO
	hulk.biessmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755387Ab2BVVzt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 16:55:49 -0500
From: =?UTF-8?q?Andreas=20Bie=C3=9Fmann?= <andreas@biessmann.de>
To: linux-kernel@vger.kernel.org
Cc: =?UTF-8?q?Andreas=20Bie=C3=9Fmann?= <andreas@biessmann.de>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Jochen Friedrich <jochen@scram.de>,
        Samuel Ortiz <sameo@linux.intel.com>,
        "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH] mod/file2alias: make modpost compile on darwin again
Date: Wed, 22 Feb 2012 22:55:35 +0100
Message-Id: <1329947735-4331-1-git-send-email-andreas@biessmann.de>
X-Mailer: git-send-email 1.7.9.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SPAM_bar: --
X-SPAM_score: -28
X-ChkData-Signature: c3154a1d4f2ce941f346c5073c38ac5a
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit e49ce14150c64b29a8dd211df785576fa19a9858 breaks cross compiling
the linux kernel on darwin hosts.
This fix introduce some minimal glue to adopt linker section handling
for darwin hosts.

Additionally this patch fixes minor chackpatch warnings introduced by
mentioned commit.

Signed-off-by: Andreas Bießmann <andreas@biessmann.de>
CC: Rusty Russell <rusty@rustcorp.com.au>
CC: Greg Kroah-Hartman <gregkh@suse.de>
CC: Jochen Friedrich <jochen@scram.de>
CC: Samuel Ortiz <sameo@linux.intel.com>
CC: "K. Y. Srinivasan" <kys@microsoft.com>
---
 scripts/mod/file2alias.c |   37 ++++++++++++++++++++++++++++++++-----
 1 files changed, 32 insertions(+), 5 deletions(-)

diff --git a/scripts/mod/file2alias.c b/scripts/mod/file2alias.c
index d0de2a2..d2f42eb 100644
--- a/scripts/mod/file2alias.c
+++ b/scripts/mod/file2alias.c
@@ -46,11 +46,37 @@ struct devtable {
 	void *function;
 };
 
+#define ___cat(a, b) a ## b
+#define __cat(a, b) ___cat(a, b)
+
+/* we need some special handling for this host tool running eventually on
+ * Darwin. The Mach-O section handling is a bit different than ELF section
+ * handling. The differnces in detail are:
+ *  a) we have segments which have sections
+ *  b) we need a API call to get the respective section symbols */
+#if defined(__MACH__)
+#include <mach-o/getsect.h>
+
+#define INIT_SECTION(name)  do {					\
+		unsigned long name ## _len;				\
+		char *__cat(pstart_, name) = getsectdata("__TEXT",	\
+			#name, &__cat(name, _len));			\
+		char *__cat(pstop_, name) = __cat(pstart_, name) +	\
+			__cat(name, _len);				\
+		__cat(__start_, name) = (void *)__cat(pstart_, name);	\
+		__cat(__stop_, name) = (void *)__cat(pstop_, name);	\
+	} while (0)
+#define SECTION(name)   __attribute__((section("__TEXT, " #name)))
+
+struct devtable **__start___devtable, **__stop___devtable;
+#else
+#define INIT_SECTION(name) /* no-op for ELF */
+#define SECTION(name)   __attribute__((section(#name)))
+
 /* We construct a table of pointers in an ELF section (pointers generally
  * go unpadded by gcc).  ld creates boundary syms for us. */
 extern struct devtable *__start___devtable[], *__stop___devtable[];
-#define ___cat(a,b) a ## b
-#define __cat(a,b) ___cat(a,b)
+#endif /* __MACH__ */
 
 #if __GNUC__ == 3 && __GNUC_MINOR__ < 3
 # define __used			__attribute__((__unused__))
@@ -60,13 +86,13 @@ extern struct devtable *__start___devtable[], *__stop___devtable[];
 
 /* Add a table entry.  We test function type matches while we're here. */
 #define ADD_TO_DEVTABLE(device_id, type, function) \
-	static struct devtable __cat(devtable,__LINE__) = {	\
+	static struct devtable __cat(devtable, __LINE__) = {	\
 		device_id + 0*sizeof((function)((const char *)NULL,	\
 						(type *)NULL,		\
 						(char *)NULL)),		\
 		sizeof(type), (function) };				\
-	static struct devtable *__attribute__((section("__devtable"))) \
-		__used __cat(devtable_ptr,__LINE__) = &__cat(devtable,__LINE__)
+	static struct devtable *SECTION(__devtable) __used \
+		__cat(devtable_ptr, __LINE__) = &__cat(devtable, __LINE__)
 
 #define ADD(str, sep, cond, field)                              \
 do {                                                            \
@@ -1080,6 +1106,7 @@ void handle_moddevtable(struct module *mod, struct elf_info *info,
 		do_pnp_card_entries(symval, sym->st_size, mod);
 	else {
 		struct devtable **p;
+		INIT_SECTION(__devtable);
 
 		for (p = __start___devtable; p < __stop___devtable; p++) {
 			if (sym_is(name, namelen, (*p)->device_id)) {
-- 
1.7.9.1

