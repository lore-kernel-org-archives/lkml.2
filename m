Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752770Ab2GVWPQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2012 18:15:16 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:33542 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752692Ab2GVWPM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2012 18:15:12 -0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: mtk.manpages@gmail.com
Cc: linux-man@vger.kernel.org, linux-kernel@vger.kernel.org,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Pavel Emelyanov <xemul@parallels.com>
Subject: [PATCH 2/2] prctl.2: Add PR_SET_MM option description
Date: Mon, 23 Jul 2012 02:15:07 +0400
Message-Id: <1342995307-884-3-git-send-email-gorcunov@openvz.org>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1342995307-884-1-git-send-email-gorcunov@openvz.org>
References: <1342995307-884-1-git-send-email-gorcunov@openvz.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CC: Pavel Emelyanov <xemul@parallels.com>
Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
---
 man2/prctl.2 |  161 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 160 insertions(+), 1 deletions(-)

diff --git a/man2/prctl.2 b/man2/prctl.2
index effad2a..2e1b27c 100644
--- a/man2/prctl.2
+++ b/man2/prctl.2
@@ -378,6 +378,121 @@ Return the current per-process machine check kill policy.
 All unused
 .BR prctl ()
 arguments must be zero.
+.TP
+.BR PR_SET_MM " (since Linux 3.3)"
+Allows a user to modify certain kernel memory map descriptor fields
+of the calling process.
+Usually these fields are set by the kernel and dynamic loader (see
+.BR ld.so (8)
+for more information) and a regular application should not use this feature.
+Still there are cases such as self-modifying programs, where a program might
+find it useful to change its own memory map.
+The kernel must be built with
+.BR CONFIG_CHECKPOINT_RESTORE
+option turned on, otherwise this feature will not be accessible
+from a user space level.
+The calling process must have
+.BR CAP_SYS_RESOURCE
+(see
+.BR capabilities (7)
+for details) capability granted.
+The value in
+.I arg2
+is one of the options below, while
+.I arg3
+provides a new value for this option.
+
+.BR PR_SET_MM_START_CODE
+to set the address above which program text can run.
+
+.BR PR_SET_MM_END_CODE
+to set the address below which program text can run.
+
+.BR PR_SET_MM_START_DATA
+to set the address above which program data+bss is placed.
+
+.B PR_SET_MM_END_DATA
+to set the address below which program data+bss is placed.
+
+.BR PR_SET_MM_START_STACK
+to set the start address of the stack.
+
+.BR PR_SET_MM_START_BRK
+to set the address above which program heap can be expanded with
+.BR brk (2)
+call.
+The address must not be greater than ending address of
+the current program data segment, neither it may exceed
+resource limit for data (see
+.BR setrlimit (2)
+for more information).
+
+.BR PR_SET_MM_BRK
+to set the current
+.BR brk (2)
+value.
+The requirements for address are the same as for
+.BR PR_SET_MM_START_BRK
+option.
+
+.BR PR_SET_MM_ARG_START
+to set the address above which program command line is placed.
+
+.BR PR_SET_MM_ARG_END
+to set the address below which program command line is placed.
+
+.BR PR_SET_MM_ENV_START
+to set the address above which program environment is placed.
+
+.BR PR_SET_MM_ENV_END
+to set the address below which program environment is placed.
+
+The address passed with
+.BR PR_SET_MM_ARG_START ,
+.BR PR_SET_MM_ARG_END ,
+.BR PR_SET_MM_ENV_START ,
+.BR PR_SET_MM_ENV_END ,
+should belong to a process stack area, thus corresponding memory area
+must be readable, writable and (depending on the kernel
+configuration) has
+.BR MAP_GROWSDOWN
+attribute set (see
+.BR mmap (2)
+for details).
+
+.BR PR_SET_MM_AUXV
+to set a new auxiliary vector.
+The
+.I arg3
+argument should provide the address of the vector.
+The
+.I arg4
+is the size of the vector.
+
+.BR PR_SET_MM_EXE_FILE
+to supersede
+.IR /proc/pid/exe
+symbolic link with a new one pointing to a new executable file
+which descriptor is provided provided in the
+.I arg3
+argument.
+The file descriptor should be obtaned with a regular
+.BR open (2)
+call.
+
+To change the symlink, one needs to unmap all existing
+executable memory areas being created by the kernel itself
+(for example the kernel usually creates at least one executable
+memory area for Elf file
+.IR \.text
+section).
+
+The second limitation is that such transition can be done once
+in a process life time.
+Any furter attempts will be rejected.
+This should help system administrators to monitor the unusual
+symlinks transitions over all process running in a system.
+.\"
 .SH "RETURN VALUE"
 On success,
 .BR PR_GET_DUMPABLE ,
@@ -411,7 +526,9 @@ is not recognized.
 is
 .BR PR_MCE_KILL
 or
-.BR PR_MCE_KILL_GET ,
+.BR PR_MCE_KILL_GET
+or
+.BR PR_SET_MM ,
 and unused
 .BR prctl ()
 arguments were not specified as zero.
@@ -459,6 +576,48 @@ is
 and the caller does not have the
 .B CAP_SETPCAP
 capability.
+.TP
+.B EPERM
+.I option
+is
+.BR PR_SET_MM ,
+and the caller does not have the
+.B CAP_SYS_RESOURCE
+capability.
+.TP
+.B EACCES
+.I option
+is
+.BR PR_SET_MM ,
+and the
+.I arg3
+is
+.BR PR_SET_MM_EXE_FILE ,
+the file is not executable one.
+.TP
+.B EBUSY
+.I option
+is
+.BR PR_SET_MM ,
+and the
+.I arg3
+is
+.BR PR_SET_MM_EXE_FILE ,
+the second attempt to change
+.I /proc/pid/exe
+symlink is prohibited.
+.TP
+.B EBADF
+.I option
+is
+.BR PR_SET_MM ,
+and the
+.I arg3
+is
+.BR PR_SET_MM_EXE_FILE ,
+the file descriptor passed in
+.I arg4
+is not found.
 .\" The following can't actually happen, because prctl() in
 .\" seccomp mode will cause SIGKILL.
 .\" .TP
-- 
1.7.7.6

