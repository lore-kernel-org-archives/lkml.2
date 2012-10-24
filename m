Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755982Ab2JXXUr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 19:20:47 -0400
Received: from smtp.outflux.net ([198.145.64.163]:40129 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751333Ab2JXXUp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 19:20:45 -0400
Date: Wed, 24 Oct 2012 16:20:32 -0700
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>,
        Josh Triplett <josh@joshtriplett.org>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        linux-fsdevel@vger.kernel.org, halfdog <me@halfdog.net>
Subject: [PATCH] exec: do not leave bprm->interp on stack
Message-ID: <20121024232032.GA31129@www.outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If a series of scripts are executed, each triggering module loading via
unprintable bytes in the script header, kernel stack contents can leak
into the command line.

Normally execution of binfmt_script and binfmt_misc happens
recursively. However, when modules are enabled, and unprintable bytes
exist in the bprm->buf, execution will restart after attempting to load
matching binfmt modules. Unfortunately, the logic in binfmt_script and
binfmt_misc does not expect to get restarted. They leave bprm->interp
pointing to their local stack. This means on restart bprm->interp is
left pointing into unused stack memory which can then be copied into
the userspace argv areas.

This changes the logic to require allocation for any changes to the
bprm->interp. To avoid adding a new kmalloc to every exec, the default
value is left as-is. Only when passing through binfmt_script or
binfmt_misc does an allocation take place.

For a proof of concept, see DoTest.sh from:
http://www.halfdog.net/Security/2012/LinuxKernelBinfmtScriptStackDataDisclosure/

Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: halfdog <me@halfdog.net>
Cc: stable@vger.kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 fs/binfmt_misc.c        |    5 ++++-
 fs/binfmt_script.c      |    4 +++-
 fs/exec.c               |   14 ++++++++++++++
 include/linux/binfmts.h |    1 +
 4 files changed, 22 insertions(+), 2 deletions(-)

diff --git a/fs/binfmt_misc.c b/fs/binfmt_misc.c
index 790b3cd..772428d 100644
--- a/fs/binfmt_misc.c
+++ b/fs/binfmt_misc.c
@@ -176,7 +176,10 @@ static int load_misc_binary(struct linux_binprm *bprm, struct pt_regs *regs)
 		goto _error;
 	bprm->argc ++;
 
-	bprm->interp = iname;	/* for binfmt_script */
+	/* Update interp in case binfmt_script needs it. */
+	retval = bprm_change_interp(iname, bprm);
+	if (retval < 0)
+		goto _error;
 
 	interp_file = open_exec (iname);
 	retval = PTR_ERR (interp_file);
diff --git a/fs/binfmt_script.c b/fs/binfmt_script.c
index d3b8c1f..df49d48 100644
--- a/fs/binfmt_script.c
+++ b/fs/binfmt_script.c
@@ -82,7 +82,9 @@ static int load_script(struct linux_binprm *bprm,struct pt_regs *regs)
 	retval = copy_strings_kernel(1, &i_name, bprm);
 	if (retval) return retval; 
 	bprm->argc++;
-	bprm->interp = interp;
+	retval = bprm_change_interp(interp, bprm);
+	if (retval < 0)
+		return retval;
 
 	/*
 	 * OK, now restart the process with the interpreter's dentry.
diff --git a/fs/exec.c b/fs/exec.c
index 8b9011b..91099be 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1174,9 +1174,23 @@ void free_bprm(struct linux_binprm *bprm)
 		mutex_unlock(&current->signal->cred_guard_mutex);
 		abort_creds(bprm->cred);
 	}
+	/* If a binfmt changed the interp, free it. */
+	if (bprm->interp != bprm->filename)
+		kfree(bprm->interp);
 	kfree(bprm);
 }
 
+int bprm_change_interp(char *interp, struct linux_binprm *bprm)
+{
+	/* If a binfmt changed the interp, free it first. */
+	if (bprm->interp != bprm->filename)
+		kfree(bprm->interp);
+	bprm->interp = kstrdup(interp, GFP_KERNEL);
+	if (!bprm->interp)
+		return -ENOMEM;
+	return 0;
+}
+
 /*
  * install the new credentials for this executable
  */
diff --git a/include/linux/binfmts.h b/include/linux/binfmts.h
index cfcc6bf..de0628e 100644
--- a/include/linux/binfmts.h
+++ b/include/linux/binfmts.h
@@ -114,6 +114,7 @@ extern int setup_arg_pages(struct linux_binprm * bprm,
 			   unsigned long stack_top,
 			   int executable_stack);
 extern int bprm_mm_init(struct linux_binprm *bprm);
+extern int bprm_change_interp(char *interp, struct linux_binprm *bprm);
 extern int copy_strings_kernel(int argc, const char *const *argv,
 			       struct linux_binprm *bprm);
 extern int prepare_bprm_creds(struct linux_binprm *bprm);
-- 
1.7.9.5


-- 
Kees Cook
Chrome OS Security
