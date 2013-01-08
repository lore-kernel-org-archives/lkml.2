Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755019Ab3AHVI1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 16:08:27 -0500
Received: from mga09.intel.com ([134.134.136.24]:45970 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754952Ab3AHVIY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 16:08:24 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,433,1355126400"; 
   d="scan'208";a="243605159"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, alan@linux.intel.com, linux-kernel@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc-next 19/21] mei: reenable mei_hcsr_set abstraction
Date: Tue,  8 Jan 2013 23:07:30 +0200
Message-Id: <1357679252-12958-20-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1357679252-12958-1-git-send-email-tomas.winkler@intel.com>
References: <1357679252-12958-1-git-send-email-tomas.winkler@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now when mei_hcsr_set is local to hw-me.c
we can benefit form the fact that it wraps
H_IS removal from the host csr.

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/hw-me.c   |   38 +++++++++++++++-----------------------
 drivers/misc/mei/mei_dev.h |    1 -
 2 files changed, 15 insertions(+), 24 deletions(-)

diff --git a/drivers/misc/mei/hw-me.c b/drivers/misc/mei/hw-me.c
index 49b558d..3190027 100644
--- a/drivers/misc/mei/hw-me.c
+++ b/drivers/misc/mei/hw-me.c
@@ -90,13 +90,10 @@ u32 mei_hcsr_read(const struct mei_device *dev)
  *
  * @dev: the device structure
  */
-void mei_hcsr_set(struct mei_device *dev)
+static inline void mei_hcsr_set(struct mei_device *dev, u32 hcsr)
 {
-
-	if ((dev->host_hw_state & H_IS) == H_IS)
-		dev->host_hw_state &= ~H_IS;
-	mei_reg_write(dev, H_CSR, dev->host_hw_state);
-	dev->host_hw_state = mei_hcsr_read(dev);
+	hcsr &= ~H_IS;
+	mei_reg_write(dev, H_CSR, hcsr);
 }
 
 /**
@@ -120,8 +117,7 @@ void mei_enable_interrupts(struct mei_device *dev)
 {
 	u32 hcsr = mei_hcsr_read(dev);
 	hcsr |= H_IE;
-	hcsr &= ~H_IS;
-	mei_reg_write(dev, H_CSR, hcsr);
+	mei_hcsr_set(dev, hcsr);
 }
 
 /**
@@ -133,8 +129,7 @@ void mei_disable_interrupts(struct mei_device *dev)
 {
 	u32 hcsr = mei_hcsr_read(dev);
 	hcsr  &= ~H_IE;
-	hcsr &= ~H_IS;
-	mei_reg_write(dev, H_CSR, hcsr);
+	mei_hcsr_set(dev, hcsr);
 }
 
 /**
@@ -156,16 +151,12 @@ void mei_hw_reset(struct mei_device *dev, bool intr_enable)
 	else
 		hcsr &= ~H_IE;
 
-	hcsr &= ~H_IS;
-
-	mei_reg_write(dev, H_CSR, hcsr);
-	hcsr = mei_hcsr_read(dev);
+	mei_hcsr_set(dev, hcsr);
 
+	hcsr = mei_hcsr_read(dev) | H_IG;
 	hcsr &= ~H_RST;
-	hcsr |= H_IG;
-	hcsr &= ~H_IS;
 
-	mei_reg_write(dev, H_CSR, hcsr);
+	mei_hcsr_set(dev, hcsr);
 
 	hcsr = mei_hcsr_read(dev);
 
@@ -182,7 +173,7 @@ void mei_hw_reset(struct mei_device *dev, bool intr_enable)
 void mei_host_set_ready(struct mei_device *dev)
 {
 	dev->host_hw_state |= H_IE | H_IG | H_RDY;
-	mei_hcsr_set(dev);
+	mei_hcsr_set(dev, dev->host_hw_state);
 }
 /**
  * mei_host_is_ready - check whether the host has turned ready
@@ -295,6 +286,7 @@ int mei_write_message(struct mei_device *dev, struct mei_msg_hdr *header,
 	unsigned long rem, dw_cnt;
 	unsigned long length = header->length;
 	u32 *reg_buf = (u32 *)buf;
+	u32 hcsr;
 	int i;
 	int empty_slots;
 
@@ -319,9 +311,8 @@ int mei_write_message(struct mei_device *dev, struct mei_msg_hdr *header,
 		mei_reg_write(dev, H_CB_WW, reg);
 	}
 
-	dev->host_hw_state = mei_hcsr_read(dev);
-	dev->host_hw_state |= H_IG;
-	mei_hcsr_set(dev);
+	hcsr = mei_hcsr_read(dev) | H_IG;
+	mei_hcsr_set(dev, hcsr);
 	dev->me_hw_state = mei_mecsr_read(dev);
 	if (!mei_me_is_ready(dev))
 		return -EIO;
@@ -366,6 +357,7 @@ void mei_read_slots(struct mei_device *dev, unsigned char *buffer,
 		    unsigned long buffer_length)
 {
 	u32 *reg_buf = (u32 *)buffer;
+	u32 hcsr;
 
 	for (; buffer_length >= sizeof(u32); buffer_length -= sizeof(u32))
 		*reg_buf++ = mei_mecbrw_read(dev);
@@ -375,7 +367,7 @@ void mei_read_slots(struct mei_device *dev, unsigned char *buffer,
 		memcpy(reg_buf, &reg, buffer_length);
 	}
 
-	dev->host_hw_state |= H_IG;
-	mei_hcsr_set(dev);
+	hcsr = mei_hcsr_read(dev) | H_IG;
+	mei_hcsr_set(dev, hcsr);
 }
 
diff --git a/drivers/misc/mei/mei_dev.h b/drivers/misc/mei/mei_dev.h
index 7b43659..ae4c5ff 100644
--- a/drivers/misc/mei/mei_dev.h
+++ b/drivers/misc/mei/mei_dev.h
@@ -387,7 +387,6 @@ void mei_watchdog_unregister(struct mei_device *dev);
 
 void mei_hw_reset(struct mei_device *dev, bool intr_enable);
 u32 mei_hcsr_read(const struct mei_device *dev);
-void mei_hcsr_set(struct mei_device *dev);
 u32 mei_mecsr_read(const struct mei_device *dev);
 u32 mei_mecbrw_read(const struct mei_device *dev);
 
-- 
1.7.4.4

