Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751729Ab2GTIDe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2012 04:03:34 -0400
Received: from canardo.mork.no ([148.122.252.1]:42586 "EHLO canardo.mork.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751060Ab2GTID2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2012 04:03:28 -0400
From: =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>
To: KY Srinivasan <kys@microsoft.com>
Cc: Greg KH <gregkh@linuxfoundation.org>, Paolo Bonzini <pbonzini@redhat.com>,
        devel@linuxdriverproject.org, linux-kernel@vger.kernel.org,
        virtualization@lists.osdl.org,
        =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>
Subject: [PATCH] drivers: hv: use Linux version in guest ID
Date: Fri, 20 Jul 2012 10:03:08 +0200
Message-Id: <1342771388-24389-1-git-send-email-bjorn@mork.no>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <87fw8mlv7e.fsf@nemi.mork.no>
References: <87fw8mlv7e.fsf@nemi.mork.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use OS version number in the guest ID as recommended by Microsoft

Signed-off-by: Bjørn Mork <bjorn@mork.no>
---
So how about something like this?  Yes, I know including
linux/version.h often is unwanted, but the spec does
recommend using the actual OS version in the guest ID

Yes, this will be offensive again when Linux is at 
version 181.0, but we might have found a better solution by
then :-)


 drivers/hv/hyperv_vmbus.h |   20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

diff --git a/drivers/hv/hyperv_vmbus.h b/drivers/hv/hyperv_vmbus.h
index b9426a6..cc0c3f0 100644
--- a/drivers/hv/hyperv_vmbus.h
+++ b/drivers/hv/hyperv_vmbus.h
@@ -29,6 +29,7 @@
 #include <asm/sync_bitops.h>
 #include <linux/atomic.h>
 #include <linux/hyperv.h>
+#include <linux/version.h>
 
 /*
  * The below CPUID leaves are present if VersionAndFeatures.HypervisorPresent
@@ -410,10 +411,21 @@ enum {
 
 #define HV_PRESENT_BIT			0x80000000
 
-#define HV_LINUX_GUEST_ID_LO		0x00000000
-#define HV_LINUX_GUEST_ID_HI		0xB16B00B5
-#define HV_LINUX_GUEST_ID		(((u64)HV_LINUX_GUEST_ID_HI << 32) | \
-					   HV_LINUX_GUEST_ID_LO)
+/* Linux vendor ID allocated by Microsoft */
+#define HV_LINUX_GUEST_ID_VENDOR	0xB16B
+
+/* Creating a guest ID conforming to the encoding recommended by
+ * Microsoft, with variant and build fixed to 0
+ *
+ *   63:48 - Vendor ID
+ *   47:40 - OS Variant
+ *   39:32 - Major Version
+ *   31:24 - Minor Version
+ *   23:16 - Service Version
+ *   15:0  - Build Number
+ */
+#define HV_LINUX_GUEST_ID		((u64)HV_LINUX_GUEST_ID_VENDOR << 48 | \
+					 (u64)LINUX_VERSION_CODE << 16)
 
 #define HV_CPU_POWER_MANAGEMENT		(1 << 0)
 #define HV_RECOMMENDATIONS_MAX		4
-- 
1.7.10.4

