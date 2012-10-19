Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932976Ab2JSUj3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 16:39:29 -0400
Received: from usmamail.tilera.com ([12.216.194.151]:56106 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932822Ab2JSUj2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 16:39:28 -0400
Message-ID: <201210192039.q9JKdRJe003951@farm-0010.internal.tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Fri, 19 Oct 2012 11:43:11 -0400
Subject: [PATCH] arch/tile: avoid generating .eh_frame information in modules
To: <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The tile tool chain uses the .eh_frame information for backtracing.
The vmlinux build drops any .eh_frame sections at link time, but when
present in kernel modules, it causes a module load failure due to the
presence of unsupported pc-relative relocations.  When compiling to
use compiler feedback support, the compiler by default omits .eh_frame
information, so we don't see this problem.  But when not using feedback,
we need to explicitly suppress the .eh_frame.

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 arch/tile/Makefile |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/tile/Makefile b/arch/tile/Makefile
index 55640cf..3d15364 100644
--- a/arch/tile/Makefile
+++ b/arch/tile/Makefile
@@ -26,6 +26,10 @@ $(error Set TILERA_ROOT or CROSS_COMPILE when building $(ARCH) on $(HOST_ARCH))
   endif
 endif
 
+# The tile compiler may emit .eh_frame information for backtracing.
+# In kernel modules, this causes load failures due to unsupported relocations.
+KBUILD_CFLAGS   += -fno-asynchronous-unwind-tables
+
 ifneq ($(CONFIG_DEBUG_EXTRA_FLAGS),"")
 KBUILD_CFLAGS   += $(CONFIG_DEBUG_EXTRA_FLAGS)
 endif
-- 
1.7.10.3

