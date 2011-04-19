Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753979Ab1DSBjS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 21:39:18 -0400
Received: from ozlabs.org ([203.10.76.45]:39156 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753636Ab1DSBjH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 21:39:07 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Alessio Igor Bogani <abogani@kernel.org>, Tim Abbott <tabbott@ksplice.com>,
        Anders Kaseorg <andersk@ksplice.com>,
        Jason Wessel <jason.wessel@windriver.com>,
        Tim Bird <tim.bird@am.sony.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linux Embedded <linux-embedded@vger.kernel.org>,
        Alessio Igor Bogani <abogani@kernel.org>
Subject: Re: [PATCH 1/4] module: Restructure each_symbol() code
In-Reply-To: <1302960373-5309-2-git-send-email-abogani@kernel.org>
References: <1302960373-5309-1-git-send-email-abogani@kernel.org> <1302960373-5309-2-git-send-email-abogani@kernel.org>
User-Agent: Notmuch/0.3.1 (http://notmuchmail.org) Emacs/23.1.1 (i686-pc-linux-gnu)
Date: Tue, 19 Apr 2011 11:01:51 +0930
Message-ID: <87r58z3u2g.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 16 Apr 2011 15:26:10 +0200, Alessio Igor Bogani <abogani@kernel.org> wrote:
> Restructure code to better integrate future improvements.

I like all the rest, but I find the function names here a bit confusing.

How about using this (untested!) patch instead?

Thanks!
Rusty.
---
Subject: module: each_symbol_section instead of each_symbol

Instead of having a callback function for each symbol in the kernel,
have a callback for each array of symbols.

This eases the logic when we move to sorted symbols and binary search.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

diff --git a/include/linux/module.h b/include/linux/module.h
--- a/include/linux/module.h
+++ b/include/linux/module.h
@@ -477,8 +477,9 @@ const struct kernel_symbol *find_symbol(
 					bool warn);
 
 /* Walk the exported symbol table */
-bool each_symbol(bool (*fn)(const struct symsearch *arr, struct module *owner,
-			    unsigned int symnum, void *data), void *data);
+bool each_symbol_section(bool (*fn)(const struct symsearch *arr,
+				    struct module *owner,
+				    void *data), void *data);
 
 /* Returns 0 and fills in value, defined and namebuf, or -ERANGE if
    symnum out of range. */
diff --git a/kernel/module.c b/kernel/module.c
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -240,23 +240,24 @@ static bool each_symbol_in_section(const
 				   struct module *owner,
 				   bool (*fn)(const struct symsearch *syms,
 					      struct module *owner,
-					      unsigned int symnum, void *data),
+					      void *data),
 				   void *data)
 {
-	unsigned int i, j;
+	unsigned int j;
 
 	for (j = 0; j < arrsize; j++) {
-		for (i = 0; i < arr[j].stop - arr[j].start; i++)
-			if (fn(&arr[j], owner, i, data))
-				return true;
+		if (fn(&arr[j], owner, data))
+			return true;
 	}
 
 	return false;
 }
 
 /* Returns true as soon as fn returns true, otherwise false. */
-bool each_symbol(bool (*fn)(const struct symsearch *arr, struct module *owner,
-			    unsigned int symnum, void *data), void *data)
+bool each_symbol_section(bool (*fn)(const struct symsearch *arr,
+				    struct module *owner,
+				    void *data),
+			 void *data)
 {
 	struct module *mod;
 	static const struct symsearch arr[] = {
@@ -309,7 +310,7 @@ bool each_symbol(bool (*fn)(const struct
 	}
 	return false;
 }
-EXPORT_SYMBOL_GPL(each_symbol);
+EXPORT_SYMBOL_GPL(each_symbol_section);
 
 struct find_symbol_arg {
 	/* Input */
@@ -323,9 +324,9 @@ struct find_symbol_arg {
 	const struct kernel_symbol *sym;
 };
 
-static bool find_symbol_in_section(const struct symsearch *syms,
-				   struct module *owner,
-				   unsigned int symnum, void *data)
+static bool test_symbol_for_find(const struct symsearch *syms,
+				 struct module *owner,
+				 unsigned int symnum, void *data)
 {
 	struct find_symbol_arg *fsa = data;
 
@@ -365,6 +366,19 @@ static bool find_symbol_in_section(const
 	return true;
 }
 
+static bool find_symbol_in_section(const struct symsearch *syms,
+				   struct module *owner,
+				   void *data)
+{
+	unsigned int i;
+
+	for (i = 0; i < syms->stop - syms->start; i++) {
+		if (test_symbol_for_find(syms, owner, i, data))
+			return true;
+	}
+	return false;
+}
+
 /* Find a symbol and return it, along with, (optional) crc and
  * (optional) module which owns it.  Needs preempt disabled or module_mutex. */
 const struct kernel_symbol *find_symbol(const char *name,
@@ -379,7 +393,7 @@ const struct kernel_symbol *find_symbol(
 	fsa.gplok = gplok;
 	fsa.warn = warn;
 
-	if (each_symbol(find_symbol_in_section, &fsa)) {
+	if (each_symbol_section(find_symbol_in_section, &fsa)) {
 		if (owner)
 			*owner = fsa.owner;
 		if (crc)
