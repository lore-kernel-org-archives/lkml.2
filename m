Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030274Ab2B1TZL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 14:25:11 -0500
Received: from terminus.zytor.com ([198.137.202.10]:54986 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966039Ab2B1TZI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 14:25:08 -0500
Date: Tue, 28 Feb 2012 11:24:38 -0800
From: tip-bot for Matt Fleming <matt.fleming@intel.com>
Message-ID: <tip-12871c568305a0b20f116315479a18cd46882e9b@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        tglx@linutronix.de, matt.fleming@intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, matt.fleming@intel.com
In-Reply-To: <1330436245-24875-4-git-send-email-matt@console-pimps.org>
References: <1330436245-24875-4-git-send-email-matt@console-pimps.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/build] x86, mkpiggy: Don't open code put_unaligned_le32()
Git-Commit-ID: 12871c568305a0b20f116315479a18cd46882e9b
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 28 Feb 2012 11:25:04 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  12871c568305a0b20f116315479a18cd46882e9b
Gitweb:     http://git.kernel.org/tip/12871c568305a0b20f116315479a18cd46882e9b
Author:     Matt Fleming <matt.fleming@intel.com>
AuthorDate: Tue, 28 Feb 2012 13:37:22 +0000
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Tue, 28 Feb 2012 10:22:57 -0800

x86, mkpiggy: Don't open code put_unaligned_le32()

Use the new headers in tools/include instead of rolling our own
put_unaligned_le32() implementation.

Cc: H. Peter Anvin <hpa@zytor.com>
Signed-off-by: Matt Fleming <matt.fleming@intel.com>
Link: http://lkml.kernel.org/r/1330436245-24875-4-git-send-email-matt@console-pimps.org
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/boot/compressed/Makefile  |    1 +
 arch/x86/boot/compressed/mkpiggy.c |   11 ++---------
 2 files changed, 3 insertions(+), 9 deletions(-)

diff --git a/arch/x86/boot/compressed/Makefile b/arch/x86/boot/compressed/Makefile
index b123b9a..fd55a2f 100644
--- a/arch/x86/boot/compressed/Makefile
+++ b/arch/x86/boot/compressed/Makefile
@@ -22,6 +22,7 @@ LDFLAGS := -m elf_$(UTS_MACHINE)
 LDFLAGS_vmlinux := -T
 
 hostprogs-y	:= mkpiggy
+HOST_EXTRACFLAGS += -I$(srctree)/tools/include
 
 VMLINUX_OBJS = $(obj)/vmlinux.lds $(obj)/head_$(BITS).o $(obj)/misc.o \
 	$(obj)/string.o $(obj)/cmdline.o $(obj)/early_serial_console.o \
diff --git a/arch/x86/boot/compressed/mkpiggy.c b/arch/x86/boot/compressed/mkpiggy.c
index 46a8238..958a641 100644
--- a/arch/x86/boot/compressed/mkpiggy.c
+++ b/arch/x86/boot/compressed/mkpiggy.c
@@ -29,14 +29,7 @@
 #include <stdio.h>
 #include <string.h>
 #include <inttypes.h>
-
-static uint32_t getle32(const void *p)
-{
-	const uint8_t *cp = p;
-
-	return (uint32_t)cp[0] + ((uint32_t)cp[1] << 8) +
-		((uint32_t)cp[2] << 16) + ((uint32_t)cp[3] << 24);
-}
+#include <tools/le_byteshift.h>
 
 int main(int argc, char *argv[])
 {
@@ -69,7 +62,7 @@ int main(int argc, char *argv[])
 	}
 
 	ilen = ftell(f);
-	olen = getle32(&olen);
+	olen = get_unaligned_le32(&olen);
 	fclose(f);
 
 	/*
