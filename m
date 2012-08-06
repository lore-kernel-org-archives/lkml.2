Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932113Ab2HFOgM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 10:36:12 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:12012 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756589Ab2HFOf1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 10:35:27 -0400
X-IronPort-AV: E=Sophos;i="4.77,720,1336363200"; 
   d="scan'208";a="204276921"
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
To: <linux-kernel@vger.kernel.org>
CC: <xen-devel@lists.xensource.com>, <Stefano.Stabellini@eu.citrix.com>,
        <konrad.wilk@oracle.com>, <Ian.Campbell@citrix.com>, <tim@xen.org>,
        <linux-arm-kernel@lists.infradead.org>, <linaro-dev@lists.linaro.org>,
        <catalin.marinas@arm.com>, <arnd@arndb.de>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: [PATCH v2 04/23] xen/arm: sync_bitops
Date: Mon, 6 Aug 2012 15:27:07 +0100
Message-ID: <1344263246-28036-4-git-send-email-stefano.stabellini@eu.citrix.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <alpine.DEB.2.02.1208061428060.4645@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1208061428060.4645@kaball.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sync_bitops functions are equivalent to the SMP implementation of the
original functions, independently from CONFIG_SMP being defined.

We need them because _set_bit etc are not SMP safe if !CONFIG_SMP. But
under Xen you might be communicating with a completely external entity
who might be on another CPU (e.g. two uniprocessor guests communicating
via event channels and grant tables). So we need a variant of the bit
ops which are SMP safe even on a UP kernel.

Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
---
 arch/arm/include/asm/sync_bitops.h |   27 +++++++++++++++++++++++++++
 1 files changed, 27 insertions(+), 0 deletions(-)
 create mode 100644 arch/arm/include/asm/sync_bitops.h

diff --git a/arch/arm/include/asm/sync_bitops.h b/arch/arm/include/asm/sync_bitops.h
new file mode 100644
index 0000000..63479ee
--- /dev/null
+++ b/arch/arm/include/asm/sync_bitops.h
@@ -0,0 +1,27 @@
+#ifndef __ASM_SYNC_BITOPS_H__
+#define __ASM_SYNC_BITOPS_H__
+
+#include <asm/bitops.h>
+#include <asm/system.h>
+
+/* sync_bitops functions are equivalent to the SMP implementation of the
+ * original functions, independently from CONFIG_SMP being defined.
+ *
+ * We need them because _set_bit etc are not SMP safe if !CONFIG_SMP. But
+ * under Xen you might be communicating with a completely external entity
+ * who might be on another CPU (e.g. two uniprocessor guests communicating
+ * via event channels and grant tables). So we need a variant of the bit
+ * ops which are SMP safe even on a UP kernel.
+ */
+
+#define sync_set_bit(nr, p)		_set_bit(nr, p)
+#define sync_clear_bit(nr, p)		_clear_bit(nr, p)
+#define sync_change_bit(nr, p)		_change_bit(nr, p)
+#define sync_test_and_set_bit(nr, p)	_test_and_set_bit(nr, p)
+#define sync_test_and_clear_bit(nr, p)	_test_and_clear_bit(nr, p)
+#define sync_test_and_change_bit(nr, p)	_test_and_change_bit(nr, p)
+#define sync_test_bit(nr, addr)		test_bit(nr, addr)
+#define sync_cmpxchg			cmpxchg
+
+
+#endif
-- 
1.7.2.5

