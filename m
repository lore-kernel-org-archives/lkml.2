Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759559Ab2JLCct (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 22:32:49 -0400
Received: from smtp.outflux.net ([198.145.64.163]:40467 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752159Ab2JLCcr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 22:32:47 -0400
Date: Thu, 11 Oct 2012 19:32:40 -0700
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>, halfdog <me@halfdog.net>,
        Randy Dunlap <rdunlap@xenotime.net>, linux-fsdevel@vger.kernel.org
Subject: [PATCH] binfmt_script: do not leave interp on stack
Message-ID: <20121012023240.GA24232@www.outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When binfmt_script's load_script ran, it would manipulate bprm->buf and
leave bprm->interp pointing to the local stack. If a series of scripts
are executed, the final one will have leaked kernel stack contents into
the cmdline. For a proof of concept, see DoTest.sh from:
http://www.halfdog.net/Security/2012/LinuxKernelBinfmtScriptStackDataDisclosure/

Largely based on a patch by halfdog. Cleaned up various style issues,
including those reported by Randy Dunlap and scripts/checkpatch.pl.

Cc: halfdog <me@halfdog.net>
Cc: stable@vger.kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
---
For more background, see the earlier thread:
https://lkml.org/lkml/2012/8/18/75
---
 fs/binfmt_script.c |  126 +++++++++++++++++++++++++++++++++++++++++-----------
 1 file changed, 101 insertions(+), 25 deletions(-)

diff --git a/fs/binfmt_script.c b/fs/binfmt_script.c
index d3b8c1f..15fe9e8 100644
--- a/fs/binfmt_script.c
+++ b/fs/binfmt_script.c
@@ -14,12 +14,22 @@
 #include <linux/err.h>
 #include <linux/fs.h>
 
+/*
+ * Check if this handler is suitable to load the interpreter identified
+ * by first BINPRM_BUF_SIZE bytes in bprm->buf following "#!".
+ *
+ * Returns:
+ *     0: success; the new executable is ready in bprm->mm.
+ *   -ve: interpreter not found, or other binfmts failed to find a
+ *        suitable binary.
+ */
 static int load_script(struct linux_binprm *bprm,struct pt_regs *regs)
 {
 	const char *i_arg, *i_name;
 	char *cp;
 	struct file *file;
-	char interp[BINPRM_BUF_SIZE];
+	char bprm_buf_copy[BINPRM_BUF_SIZE];
+	const char *bprm_old_interp_name;
 	int retval;
 
 	if ((bprm->buf[0] != '#') || (bprm->buf[1] != '!') ||
@@ -30,34 +40,57 @@ static int load_script(struct linux_binprm *bprm,struct pt_regs *regs)
 	 * Sorta complicated, but hopefully it will work.  -TYT
 	 */
 
-	bprm->recursion_depth++;
-	allow_write_access(bprm->file);
-	fput(bprm->file);
-	bprm->file = NULL;
+	/*
+	 * Keep bprm unchanged until we known that this is a script
+	 * to be handled by this loader. Copy bprm->buf for sure,
+	 * otherwise returning -ENOEXEC will make other handlers see
+	 * modified data.
+	 */
+	memcpy(bprm_buf_copy, bprm->buf, BINPRM_BUF_SIZE);
 
-	bprm->buf[BINPRM_BUF_SIZE - 1] = '\0';
-	if ((cp = strchr(bprm->buf, '\n')) == NULL)
-		cp = bprm->buf+BINPRM_BUF_SIZE-1;
+	/* Locate and truncate end of string. */
+	bprm_buf_copy[BINPRM_BUF_SIZE - 1] = '\0';
+	cp = strchr(bprm_buf_copy, '\n');
+	if (cp == NULL)
+		cp = bprm_buf_copy + BINPRM_BUF_SIZE - 1;
 	*cp = '\0';
-	while (cp > bprm->buf) {
+	/* Truncate trailing white-space. */
+	while (cp > bprm_buf_copy) {
 		cp--;
 		if ((*cp == ' ') || (*cp == '\t'))
 			*cp = '\0';
 		else
 			break;
 	}
-	for (cp = bprm->buf+2; (*cp == ' ') || (*cp == '\t'); cp++);
+	/* Skip leading white-space. */
+	for (cp = bprm_buf_copy + 2; (*cp == ' ') || (*cp == '\t'); cp++)
+		/* nothing */ ;
+
+	/*
+	 * No interpreter name found? No problem to let other handlers
+	 * retry, we did not change anything.
+	 */
 	if (*cp == '\0') 
-		return -ENOEXEC; /* No interpreter name found */
+		return -ENOEXEC;
+
 	i_name = cp;
 	i_arg = NULL;
+	/* Find start of first argument. */
 	for ( ; *cp && (*cp != ' ') && (*cp != '\t'); cp++)
 		/* nothing */ ;
+	/* Truncate and skip leading white-space. */
 	while ((*cp == ' ') || (*cp == '\t'))
 		*cp++ = '\0';
 	if (*cp)
 		i_arg = cp;
-	strcpy (interp, i_name);
+
+	/*
+	 * So this is our point-of-no-return: modification of bprm
+	 * will be irreversible, so if we fail to setup execution
+	 * using the new interpreter name (i_name), we have to make
+	 * sure that no other handler tries again.
+	 */
+
 	/*
 	 * OK, we've parsed out the interpreter name and
 	 * (optional) argument.
@@ -68,34 +101,77 @@ static int load_script(struct linux_binprm *bprm,struct pt_regs *regs)
 	 * This is done in reverse order, because of how the
 	 * user environment and arguments are stored.
 	 */
+
+	/*
+	 * Ugly: we store pointer to local stack frame in bprm,
+	 * so make sure to clean this up before returning.
+	 */
+	bprm_old_interp_name = bprm->interp;
+	bprm->interp = i_name;
+
 	retval = remove_arg_zero(bprm);
 	if (retval)
-		return retval;
-	retval = copy_strings_kernel(1, &bprm->interp, bprm);
-	if (retval < 0) return retval; 
+		goto out;
+
+	/*
+	 * copy_strings_kernel is ok here, even when racy: since no
+	 * user can be attached to new mm, there is nobody to race
+	 * with and call is safe for now. The return code of
+	 * copy_strings_kernel cannot be -ENOEXEC in any case,
+	 * so no special checks needed.
+	 */
+	retval = copy_strings_kernel(1, &bprm_old_interp_name, bprm);
+	if (retval < 0)
+		goto out;
 	bprm->argc++;
 	if (i_arg) {
 		retval = copy_strings_kernel(1, &i_arg, bprm);
-		if (retval < 0) return retval; 
+		if (retval < 0)
+			goto out;
 		bprm->argc++;
 	}
-	retval = copy_strings_kernel(1, &i_name, bprm);
-	if (retval) return retval; 
+	retval = copy_strings_kernel(1, &bprm->interp, bprm);
+	if (retval)
+		goto out;
 	bprm->argc++;
-	bprm->interp = interp;
 
 	/*
 	 * OK, now restart the process with the interpreter's dentry.
+	 * Release old file first.
 	 */
-	file = open_exec(interp);
-	if (IS_ERR(file))
-		return PTR_ERR(file);
-
+	allow_write_access(bprm->file);
+	fput(bprm->file);
+	bprm->file = NULL;
+	file = open_exec(bprm->interp);
+	if (IS_ERR(file)) {
+		retval = PTR_ERR(file);
+		goto out;
+	}
 	bprm->file = file;
+	/* Caveat: This also updates the credentials of the next exec. */
 	retval = prepare_binprm(bprm);
 	if (retval < 0)
-		return retval;
-	return search_binary_handler(bprm,regs);
+		goto out;
+	bprm->recursion_depth++;
+	retval = search_binary_handler(bprm, regs);
+
+out:
+	/*
+	 * Make sure we do not return local stack frame data. If
+	 * it would be needed after returning, we would have needed
+	 * to allocate memory or use a copy from new bprm->mm anyway.
+	 */
+	bprm->interp = bprm_old_interp_name;
+	/*
+	 * Since bprm is already modified, we cannot continue if the the
+	 * handlers for starting the new interpreter have failed.
+	 * Make sure that we do not return -ENOEXEC, as that would
+	 * allow searching for handlers to continue.
+	 */
+	if (retval == -ENOEXEC)
+		retval = -EINVAL;
+
+	return retval;
 }
 
 static struct linux_binfmt script_format = {
-- 
1.7.9.5


-- 
Kees Cook
Chrome OS Security
