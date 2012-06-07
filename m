Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932595Ab2FGETA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 00:19:00 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:59627 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932560Ab2FGESy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 00:18:54 -0400
Message-Id: <20120607040342.314328886@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Thu, 07 Jun 2012 13:04:17 +0900
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, "H. Peter Anvin" <hpa@zytor.com>
Subject: [ 41/82] x86, x32, ptrace: Remove PTRACE_ARCH_PRCTL for x32
In-Reply-To: <20120607041406.GA13233@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "H.J. Lu" <hjl.tools@gmail.com>

commit bad1a753d4d4deb09d4bc0bac1dd4fc3298502e9 upstream.

When I added x32 ptrace to 3.4 kernel, I also include PTRACE_ARCH_PRCTL
support for x32 GDB  For ARCH_GET_FS/GS, it takes a pointer to int64.  But
at user level, ARCH_GET_FS/GS takes a pointer to int32.  So I have to add
x32 ptrace to glibc to handle it with a temporary int64 passed to kernel and
copy it back to GDB as int32.  Roland suggested that PTRACE_ARCH_PRCTL
is obsolete and x32 GDB should use fs_base and gs_base fields of
user_regs_struct instead.

Accordingly, remove PTRACE_ARCH_PRCTL completely from the x32 code to
avoid possible memory overrun when pointer to int32 is passed to
kernel.

Link: http://lkml.kernel.org/r/CAMe9rOpDzHfS7NH7m1vmD9QRw8SSj4Sc%2BaNOgcWm_WJME2eRsQ@mail.gmail.com
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kernel/ptrace.c |    6 ------
 1 file changed, 6 deletions(-)

--- a/arch/x86/kernel/ptrace.c
+++ b/arch/x86/kernel/ptrace.c
@@ -1211,12 +1211,6 @@ static long x32_arch_ptrace(struct task_
 					     0, sizeof(struct user_i387_struct),
 					     datap);
 
-		/* normal 64bit interface to access TLS data.
-		   Works just like arch_prctl, except that the arguments
-		   are reversed. */
-	case PTRACE_ARCH_PRCTL:
-		return do_arch_prctl(child, data, addr);
-
 	default:
 		return compat_ptrace_request(child, request, addr, data);
 	}


