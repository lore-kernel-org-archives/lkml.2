Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932558Ab2ITX1n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 19:27:43 -0400
Received: from smtp.outflux.net ([198.145.64.163]:54423 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932468Ab2ITX1l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 19:27:41 -0400
Date: Thu, 20 Sep 2012 16:27:38 -0700
From: Kees Cook <keescook@chromium.org>
To: Michael Kerrisk <mtk.manpages@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org
Subject: [PATCH] init_module: update to modern interfaces
Message-ID: <20120920232737.GA2953@www.outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This updates init_module(2) to reflect the reality of 2.6+ module
loading interfaces. It additionally drops references to the extra
deprecated module functions create_module(2) and query_module(2).

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 man2/delete_module.2 |    7 ++--
 man2/init_module.2   |   90 +++++++++++++++++--------------------------------
 2 files changed, 34 insertions(+), 63 deletions(-)

diff --git a/man2/delete_module.2 b/man2/delete_module.2
index 90c9d7e..55b0d7e 100644
--- a/man2/delete_module.2
+++ b/man2/delete_module.2
@@ -4,8 +4,9 @@
 .\"
 .\" 2006-02-09, some reformatting by Luc Van Oostenryck; some
 .\" reformatting and rewordings by mtk
+.\" 2012-09-20, drop references to deprecated syscalls, by Kees Cook.
 .\"
-.TH DELETE_MODULE 2 2006-02-09 "Linux" "Linux Programmer's Manual"
+.TH DELETE_MODULE 2 2012-09-20 "Linux" "Linux Programmer's Manual"
 .SH NAME
 delete_module \- delete a loadable module entry
 .SH SYNOPSIS
@@ -52,6 +53,4 @@ capability).
 .BR delete_module ()
 is Linux-specific.
 .SH "SEE ALSO"
-.BR create_module (2),
-.BR init_module (2),
-.BR query_module (2)
+.BR init_module (2)
diff --git a/man2/init_module.2 b/man2/init_module.2
index d324b51..bf37bdc 100644
--- a/man2/init_module.2
+++ b/man2/init_module.2
@@ -1,64 +1,40 @@
 .\" Copyright (C) 1996 Free Software Foundation, Inc.
 .\" This file is distributed according to the GNU General Public License.
 .\" See the file COPYING in the top level source directory for details.
+.\" and Copyright (C) 2012 Kees Cook <keescook@chromium.org>
 .\"
 .\" 2006-02-09, some reformatting by Luc Van Oostenryck; some
 .\" reformatting and rewordings by mtk
+.\" 2012-09-20, updated for current interface realities by Kees Cook.
 .\"
-.TH INIT_MODULE 2 2006-02-09 "Linux" "Linux Programmer's Manual"
+.TH INIT_MODULE 2 2012-09-20 "Linux" "Linux Programmer's Manual"
 .SH NAME
 init_module \- initialize a loadable module entry
 .SH SYNOPSIS
 .nf
 .B #include <linux/module.h>
 .sp
-.BI "int init_module(const char *" name ", struct module *" image );
+.BI "int init_module(const void *" module ", unsigned long " length ","
+.BI "                const char *" args );
 .fi
 .SH DESCRIPTION
 .BR init_module ()
-loads the relocated module image into kernel space and runs the
-module's
+loads an ELF image of
+.I length
+bytes from
+.I module
+into kernel space, performs relocations and runs the module's
 .I init
-function.
+function, passing the user option string
+.I args
+for parsing by the newly running kernel module.
 .PP
-The module image begins with a module structure and is followed by
-code and data as appropriate.
-The module structure is defined as follows:
+The module image should be a valid ELF image, built for the running kernel.
 .PP
-.in +4n
-.nf
-struct module {
-    unsigned long         size_of_struct;
-    struct module        *next;
-    const char           *name;
-    unsigned long         size;
-    long                  usecount;
-    unsigned long         flags;
-    unsigned int          nsyms;
-    unsigned int          ndeps;
-    struct module_symbol *syms;
-    struct module_ref    *deps;
-    struct module_ref    *refs;
-    int                 (*init)(void);
-    void                (*cleanup)(void);
-    const struct exception_table_entry *ex_table_start;
-    const struct exception_table_entry *ex_table_end;
-#ifdef __alpha__
-    unsigned long gp;
-#endif
-};
-.fi
-.in
-.PP
-All of the pointer fields, with the exception of
-.I next
-and
-.IR refs ,
-are expected to point within the module body and be
-initialized as appropriate for kernel space, that is, relocated with
-the rest of the module.
-.PP
-This system call requires privilege.
+This system call requires privilege, and for module loading to be enabled
+on the system. This is controlled by the
+.I /proc/sys/kernel/modules_disabed
+sysctl file.
 .SH "RETURN VALUE"
 On success, zero is returned.
 On error, \-1 is returned and
@@ -66,37 +42,33 @@ On error, \-1 is returned and
 is set appropriately.
 .SH ERRORS
 .TP
+.B EEXISTS
+The module with the same name is already loaded in the kernel.
+.TP
 .B EBUSY
 The module's initialization routine failed.
 .TP
 .B EFAULT
-.I name
-or
-.I image
+.I module
 is outside the program's accessible address space.
 .TP
 .B EINVAL
-Some
-.I image
-slot is filled in incorrectly,
-.I image\->name
-does not correspond to the original module name, some
-.I image\->deps
-entry does not correspond to a loaded module,
-or some other similar inconsistency.
+Some part of the ELF image in
+.I module
+contains inconsistencies.
 .TP
-.B ENOENT
-No module by that name exists.
+.B ENOEXEC
+The ELF image in
+.I module
+is too small or has corrupted segments.
 .TP
 .B EPERM
 The caller was not privileged
 (did not have the
 .B CAP_SYS_MODULE
-capability).
+capability), or module loading was disabled.
 .SH "CONFORMING TO"
 .BR init_module ()
 is Linux-specific.
 .SH "SEE ALSO"
-.BR create_module (2),
-.BR delete_module (2),
-.BR query_module (2)
+.BR delete_module (2)
-- 
1.7.0.4

-- 
Kees Cook
Chrome OS Security
