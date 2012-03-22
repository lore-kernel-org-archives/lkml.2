Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760000Ab2CVV0h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 17:26:37 -0400
Received: from terminus.zytor.com ([198.137.202.10]:42074 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758358Ab2CVV0f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 17:26:35 -0400
Date: Thu, 22 Mar 2012 14:26:24 -0700
From: "tip-bot for H. Peter Anvin" <hpa@zytor.com>
Message-ID: <tip-446e1c86d51d0823e003a43a2b85c430efce2733@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, tglx@linutronix.de,
        matt.fleming@intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, tglx@linutronix.de,
        matt.fleming@intel.com
In-Reply-To: <1330436245-24875-5-git-send-email-matt@console-pimps.org>
References: <1330436245-24875-5-git-send-email-matt@console-pimps.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86, boot: Correct CFLAGS for hostprogs
Git-Commit-ID: 446e1c86d51d0823e003a43a2b85c430efce2733
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Thu, 22 Mar 2012 14:26:30 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  446e1c86d51d0823e003a43a2b85c430efce2733
Gitweb:     http://git.kernel.org/tip/446e1c86d51d0823e003a43a2b85c430efce2733
Author:     H. Peter Anvin <hpa@zytor.com>
AuthorDate: Thu, 22 Mar 2012 11:08:18 -0700
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Thu, 22 Mar 2012 12:42:51 -0700

x86, boot: Correct CFLAGS for hostprogs

This is a partial revert of commit:
    d40f833 "Restrict CFLAGS for hostprogs"

The endian-manipulation macros in tools/include need <linux/types.h>,
but the hostprogs in arch/x86/boot need several headers from the
kernel build tree, which means we have to add the kernel headers to
the include path.  This picks up <linux/types.h> from the kernel tree,
which gives a warning.

Since this use of <linux/types.h> is intentional, add
-D__EXPORTED_HEADERS__ to the command line to silence the warning.

A better way to fix this would be to always install the exported
kernel headers into $(objtree)/usr/include as a standard part of the
kernel build, but that is a lot more involved.

Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
Acked-by: Matt Fleming <matt.fleming@intel.com>
Link: http://lkml.kernel.org/r/1330436245-24875-5-git-send-email-matt@console-pimps.org
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/boot/Makefile |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/boot/Makefile b/arch/x86/boot/Makefile
index 3e02148..5a747dd 100644
--- a/arch/x86/boot/Makefile
+++ b/arch/x86/boot/Makefile
@@ -37,9 +37,9 @@ setup-y		+= video-bios.o
 targets		+= $(setup-y)
 hostprogs-y	:= mkcpustr tools/build
 
-HOSTCFLAGS_mkcpustr.o := -I$(srctree)/arch/$(SRCARCH)/include
-HOST_EXTRACFLAGS += -I$(objtree)/include -I$(srctree)/tools/include \
-                   -include $(srctree)/include/linux/kconfig.h
+HOST_EXTRACFLAGS += -I$(srctree)/tools/include $(LINUXINCLUDE) \
+	            -D__EXPORTED_HEADERS__
+
 $(obj)/cpu.o: $(obj)/cpustr.h
 
 quiet_cmd_cpustr = CPUSTR  $@
