Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932657Ab2LMOIp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 09:08:45 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44584 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932629Ab2LMOIk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 09:08:40 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "H. Peter Anvin" <hpa@zytor.com>, Matt Fleming <matt.fleming@intel.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 127/241] x86, efi: Fix processor-specific memcpy() build error
Date: Thu, 13 Dec 2012 11:58:12 -0200
Message-Id: <1355407206-17100-128-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
References: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matt Fleming <matt.fleming@intel.com>

commit 0f905a43ce955b638139bd84486194770a6a2c08 upstream.

Building for Athlon/Duron/K7 results in the following build error,

arch/x86/boot/compressed/eboot.o: In function `__constant_memcpy3d':
eboot.c:(.text+0x385): undefined reference to `_mmx_memcpy'
arch/x86/boot/compressed/eboot.o: In function `efi_main':
eboot.c:(.text+0x1a22): undefined reference to `_mmx_memcpy'

because the boot stub code doesn't link with the kernel proper, and
therefore doesn't have access to the 3DNow version of memcpy. So,
follow the example of misc.c and #undef memcpy so that we use the
version provided by misc.c.

See https://bugzilla.kernel.org/show_bug.cgi?id=50391

Reported-by: Al Viro <viro@zeniv.linux.org.uk>
Reported-by: Ryan Underwood <nemesis@icequake.net>
Cc: H. Peter Anvin <hpa@zytor.com>
Signed-off-by: Matt Fleming <matt.fleming@intel.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 arch/x86/boot/compressed/eboot.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/boot/compressed/eboot.c b/arch/x86/boot/compressed/eboot.c
index 4e85f5f..f204178 100644
--- a/arch/x86/boot/compressed/eboot.c
+++ b/arch/x86/boot/compressed/eboot.c
@@ -12,6 +12,8 @@
 #include <asm/setup.h>
 #include <asm/desc.h>
 
+#undef memcpy			/* Use memcpy from misc.c */
+
 #include "eboot.h"
 
 static efi_system_table_t *sys_table;
-- 
1.7.9.5

