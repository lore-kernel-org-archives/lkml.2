Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754754Ab2CVKTI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 06:19:08 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:39176 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750920Ab2CVKTC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 06:19:02 -0400
From: Matt Fleming <matt@console-pimps.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, x86@kernel.org,
        linux-kernel@vger.kernel.org, Matt Fleming <matt.fleming@intel.com>
Subject: [PATCH] x86, efi: Fix processor-specific memcpy() build error
Date: Thu, 22 Mar 2012 10:18:54 +0000
Message-Id: <1332411534-10130-1-git-send-email-matt@console-pimps.org>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matt Fleming <matt.fleming@intel.com>

Building for Athlon/Duron/K7 results in the following build error,

arch/x86/boot/compressed/eboot.o: In function `__constant_memcpy3d':
eboot.c:(.text+0x385): undefined reference to `_mmx_memcpy'
arch/x86/boot/compressed/eboot.o: In function `efi_main':
eboot.c:(.text+0x1a22): undefined reference to `_mmx_memcpy'

because the boot stub code doesn't link with the kernel proper, and
therefore doesn't have access to the 3DNow version of memcpy. So,
follow the example of misc.c and #undef memcpy so that we use the
version provided by misc.c.

Reported-by: Al Viro <viro@zeniv.linux.org.uk>
Cc: H. Peter Anvin <hpa@zytor.com>
Signed-off-by: Matt Fleming <matt.fleming@intel.com>
---
 arch/x86/boot/compressed/eboot.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/x86/boot/compressed/eboot.c b/arch/x86/boot/compressed/eboot.c
index fec216f..3481574 100644
--- a/arch/x86/boot/compressed/eboot.c
+++ b/arch/x86/boot/compressed/eboot.c
@@ -14,6 +14,8 @@
 
 #include "eboot.h"
 
+#undef memcpy			/* Use memcpy from misc.c */
+
 static efi_system_table_t *sys_table;
 
 static efi_status_t __get_map(efi_memory_desc_t **map, unsigned long *map_size,
-- 
1.7.4.4

