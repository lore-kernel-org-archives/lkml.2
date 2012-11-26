Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933845Ab2KZRNK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 12:13:10 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:48027 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932206Ab2KZRNE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 12:13:04 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Chris Metcalf <cmetcalf@tilera.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 211/270] arch/tile: avoid generating .eh_frame information in modules
Date: Mon, 26 Nov 2012 14:58:21 -0200
Message-Id: <1353949160-26803-212-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
References: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7u1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chris Metcalf <cmetcalf@tilera.com>

commit 627072b06c362bbe7dc256f618aaa63351f0cfe6 upstream.

The tile tool chain uses the .eh_frame information for backtracing.
The vmlinux build drops any .eh_frame sections at link time, but when
present in kernel modules, it causes a module load failure due to the
presence of unsupported pc-relative relocations.  When compiling to
use compiler feedback support, the compiler by default omits .eh_frame
information, so we don't see this problem.  But when not using feedback,
we need to explicitly suppress the .eh_frame.

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 arch/tile/Makefile |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/tile/Makefile b/arch/tile/Makefile
index e20b0a0..7da1015 100644
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
1.7.9.5

