Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755677Ab0HYA2G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 20:28:06 -0400
Received: from ozlabs.org ([203.10.76.45]:38493 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755151Ab0HYA2C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 20:28:02 -0400
Date: Wed, 25 Aug 2010 10:22:58 +1000
From: Anton Blanchard <anton@samba.org>
To: benh@kernel.crashing.org, ebiederm@xmission.com, akpm@linux-foundation.org
Cc: kexec@lists.infradead.org, linuxppc-dev@ozlabs.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] kdump: Allow shrinking of kdump region to be overridden
Message-ID: <20100825002258.GD28360@kryten>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On ppc64 the crashkernel region almost always overlaps an area of firmware.
This works fine except when using the sysfs interface to reduce the kdump
region. If we free the firmware area we are guaranteed to crash.

Rename free_reserved_phys_range to crash_free_reserved_phys_range and make
it a weak function so we can override it.

Signed-off-by: Anton Blanchard <anton@samba.org>
---

Index: powerpc.git/kernel/kexec.c
===================================================================
--- powerpc.git.orig/kernel/kexec.c	2010-08-25 10:12:11.493863566 +1000
+++ powerpc.git/kernel/kexec.c	2010-08-25 10:12:35.907264327 +1000
@@ -1097,7 +1097,8 @@ size_t crash_get_memory_size(void)
 	return size;
 }
 
-static void free_reserved_phys_range(unsigned long begin, unsigned long end)
+void __weak crash_free_reserved_phys_range(unsigned long begin,
+					   unsigned long end)
 {
 	unsigned long addr;
 
@@ -1133,7 +1134,7 @@ int crash_shrink_memory(unsigned long ne
 	start = roundup(start, PAGE_SIZE);
 	end = roundup(start + new_size, PAGE_SIZE);
 
-	free_reserved_phys_range(end, crashk_res.end);
+	crash_free_reserved_phys_range(end, crashk_res.end);
 
 	if ((start == end) && (crashk_res.parent != NULL))
 		release_resource(&crashk_res);
Index: powerpc.git/include/linux/kexec.h
===================================================================
--- powerpc.git.orig/include/linux/kexec.h	2010-08-25 10:12:11.483862172 +1000
+++ powerpc.git/include/linux/kexec.h	2010-08-25 10:12:13.664166570 +1000
@@ -208,6 +208,7 @@ int __init parse_crashkernel(char *cmdli
 		unsigned long long *crash_size, unsigned long long *crash_base);
 int crash_shrink_memory(unsigned long new_size);
 size_t crash_get_memory_size(void);
+void crash_free_reserved_phys_range(unsigned long begin, unsigned long end);
 
 #else /* !CONFIG_KEXEC */
 struct pt_regs;
