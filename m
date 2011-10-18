Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754939Ab1JRGve (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 02:51:34 -0400
Received: from ozlabs.org ([203.10.76.45]:36769 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752360Ab1JRGvd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 02:51:33 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Michal Schmidt <mschmidt@redhat.com>
Cc: linux-kernel@vger.kernel.org, Randy Dunlap <rdunlap@xenotime.net>
Subject: Re: [PATCH] params: make dashes and underscores in parameter names truly equal
In-Reply-To: <4E96F887.5050103@redhat.com>
References: <1318197817-20964-1-git-send-email-mschmidt@redhat.com> <8739exg588.fsf@rustcorp.com.au> <4E96F887.5050103@redhat.com>
User-Agent: Notmuch/0.5 (http://notmuchmail.org) Emacs/23.2.1 (i686-pc-linux-gnu)
Date: Tue, 18 Oct 2011 14:28:46 +1030
Message-ID: <87obxfq7bd.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Oct 2011 16:41:11 +0200, Michal Schmidt <mschmidt@redhat.com> wrote:
> On 10/13/2011 01:28 AM, Rusty Russell wrote:
> >          Idea is solid, implementation has a few quirks.  As the name
> > obsolete_checksetup() implies, this was only supposed to be a crutch for
> > old __setup() calls.  Modern code should be using module_param() or
> > core_param().
> 
> ... instead of __setup()?

Yep.

> No objection to the change in do_early_param() ?

Well, for the moment I've applied that, with parameq and parameqn
reimplemented more cleanly.  See below.

> > Did you have a specific example?
> 
> The specific example I had in mind was the one from 
> Documentation/kernel-parameters.txt:
> 
>            log_buf_len=1M print-fatal-signals=1
>    can also be entered as
>            log-buf-len=1M print_fatal_signals=1

Oops.

> Let's see how many __setup() parameters there are:
> $ git grep -E '^__setup\("' |wc -l
> 457
> 
> Only the ones with a dash or underscore in the name:
> $ git grep -E '__setup\(".*[_-].*"' | wc -l
> 180
> 
> It will take some time.

The easy things have already been done ;)

Just do the non-arch ones, first, and see where that gets us.

Thanks!
Rusty.

From: Michal Schmidt <mschmidt@redhat.com>
Subject: params: make dashes and underscores in parameter names truly equal
Date: Mon, 10 Oct 2011 00:03:37 +0200

The user may use "foo-bar" for a kernel parameter defined as "foo_bar".
Make sure it works the other way around too.

Apply the equality of dashes and underscores on early_params and __setup
params as well.

The example given in Documentation/kernel-parameters.txt indicates that
this is the intended behaviour.

With the patch the kernel accepts "log-buf-len=1M" as expected.
https://bugzilla.redhat.com/show_bug.cgi?id=744545

Signed-off-by: Michal Schmidt <mschmidt@redhat.com>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au> (neatened implementations)
---
 include/linux/moduleparam.h |   20 ++++++++++++++++++++
 init/main.c                 |    4 ++--
 kernel/params.c             |   21 ++++++++++++++-------
 3 files changed, 36 insertions(+), 9 deletions(-)

diff --git a/include/linux/moduleparam.h b/include/linux/moduleparam.h
--- a/include/linux/moduleparam.h
+++ b/include/linux/moduleparam.h
@@ -262,6 +262,26 @@ static inline void __kernel_param_unlock
 			    .str = &__param_string_##name, 0, perm);	\
 	__MODULE_PARM_TYPE(name, "string")
 
+/**
+ * parameq - checks if two parameter names match
+ * @name1: parameter name 1
+ * @name2: parameter name 2
+ *
+ * Returns true if the two parameter names are equal.
+ * Dashes (-) are considered equal to underscores (_).
+ */
+extern bool parameq(const char *name1, const char *name2);
+
+/**
+ * parameqn - checks if two parameter names match
+ * @name1: parameter name 1
+ * @name2: parameter name 2
+ * @n: the length to compare
+ *
+ * Similar to parameq(), except it compares @n characters.
+ */
+extern bool parameqn(const char *name1, const char *name2, size_t n);
+
 /* Called on module insert or kernel boot */
 extern int parse_args(const char *name,
 		      char *args,
diff --git a/init/main.c b/init/main.c
--- a/init/main.c
+++ b/init/main.c
@@ -163,7 +163,7 @@ static int __init obsolete_checksetup(ch
 	p = __setup_start;
 	do {
 		int n = strlen(p->str);
-		if (!strncmp(line, p->str, n)) {
+		if (parameqn(line, p->str, n)) {
 			if (p->early) {
 				/* Already done in parse_early_param?
 				 * (Needs exact match on param part).
@@ -392,7 +392,7 @@ static int __init do_early_param(char *p
 	const struct obs_kernel_param *p;
 
 	for (p = __setup_start; p < __setup_end; p++) {
-		if ((p->early && strcmp(param, p->str) == 0) ||
+		if ((p->early && parameq(param, p->str)) ||
 		    (strcmp(param, "console") == 0 &&
 		     strcmp(p->str, "earlycon") == 0)
 		) {
diff --git a/kernel/params.c b/kernel/params.c
--- a/kernel/params.c
+++ b/kernel/params.c
@@ -67,20 +67,27 @@ static void maybe_kfree_parameter(void *
 	}
 }
 
-static inline char dash2underscore(char c)
+static char dash2underscore(char c)
 {
 	if (c == '-')
 		return '_';
 	return c;
 }
 
-static inline int parameq(const char *input, const char *paramname)
+bool parameqn(const char *a, const char *b, size_t n)
 {
-	unsigned int i;
-	for (i = 0; dash2underscore(input[i]) == paramname[i]; i++)
-		if (input[i] == '\0')
-			return 1;
-	return 0;
+	size_t i;
+
+	for (i = 0; i < n; i++) {
+		if (dash2underscore(a[i]) != dash2underscore(b[i]))
+			return false;
+	}
+	return true;
+}
+
+bool parameq(const char *a, const char *b)
+{
+	return parameqn(a, b, strlen(a)+1);
 }
 
 static int parse_one(char *param,
