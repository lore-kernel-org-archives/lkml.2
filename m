Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753223Ab1HJWGV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 18:06:21 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:56010 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751616Ab1HJWGU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 18:06:20 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Thu, 11 Aug 2011 00:06:04 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: linux1394-devel@lists.sourceforge.net
Cc: Clemens Ladisch <clemens@ladisch.de>,
        Carl Karsten <carl@personnelware.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] firewire: cdev: fix 32 bit userland on 64 bit kernel compat
 corner cases
Message-ID: <20110811000604.4a5ec5b7@stein>
In-Reply-To: <20110810234635.11ea2ea1@stein>
References: <CADmzSSh_gRKxjGNk7c938mhZQhe3N-18KJrqq4UpG8L6FcCQDQ@mail.gmail.com>
	<4E415305.3040404@ladisch.de>
	<4E4159D1.9020208@ladisch.de>
	<20110809221719.74e29be5@stein>
	<4E4231DF.2060303@ladisch.de>
	<20110810163444.768d583d@stein>
	<4E42BA4D.7080203@ladisch.de>
	<20110810234635.11ea2ea1@stein>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.4; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Clemens points out that we need to use compat_ptr() in order to safely
cast from u64 to addresses of a 32-bit usermode client.

Before, our conversion went wrong
  - in practice if the client cast from pointer to integer such that
    sign-extension happened, (libraw1394 and libdc1394 at least were not
    doing that, IOW were not affected)
or
  - in theory on s390 (which doesn't have FireWire though) and on the
    tile architecture, regardless of what the client does.
The bug would usually be observed as the initial get_info ioctl failing
with "Bad address" (EFAULT).

Reported-by: Carl Karsten <carl@personnelware.com>
Reported-by: Clemens Ladisch <clemens@ladisch.de>
Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: stable@kernel.org
---
 drivers/firewire/core-cdev.c |   24 +++++++++++++++++++++---
 1 file changed, 21 insertions(+), 3 deletions(-)

Index: b/drivers/firewire/core-cdev.c
===================================================================
--- a/drivers/firewire/core-cdev.c
+++ b/drivers/firewire/core-cdev.c
@@ -216,15 +216,33 @@ struct inbound_phy_packet_event {
 	struct fw_cdev_event_phy_packet phy_packet;
 };
 
-static inline void __user *u64_to_uptr(__u64 value)
+#ifdef CONFIG_COMPAT
+static void __user *u64_to_uptr(u64 value)
+{
+	if (is_compat_task())
+		return compat_ptr(value);
+	else
+		return (void __user *)(unsigned long)value;
+}
+
+static u64 uptr_to_u64(void __user *ptr)
+{
+	if (is_compat_task())
+		return ptr_to_compat(ptr);
+	else
+		return (u64)(unsigned long)ptr;
+}
+#else
+static inline void __user *u64_to_uptr(u64 value)
 {
 	return (void __user *)(unsigned long)value;
 }
 
-static inline __u64 uptr_to_u64(void __user *ptr)
+static inline u64 uptr_to_u64(void __user *ptr)
 {
-	return (__u64)(unsigned long)ptr;
+	return (u64)(unsigned long)ptr;
 }
+#endif /* CONFIG_COMPAT */
 
 static int fw_device_op_open(struct inode *inode, struct file *file)
 {


-- 
Stefan Richter
-=====-==-== =--- -=-=-
http://arcgraph.de/sr/
