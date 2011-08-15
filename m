Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753822Ab1HOOCh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 10:02:37 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:53798 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753659Ab1HOOCf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 10:02:35 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Mon, 15 Aug 2011 16:01:31 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux1394-devel@lists.sourceforge.net
Subject: [git pull] FireWire fixes
Message-ID: <20110815160131.063f453d@stein>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.4; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from the fixes branch at

    git://git.kernel.org/pub/scm/linux/kernel/git/ieee1394/linux1394-2.6.git fixes

to receive a small update of the IEEE 1394 (FireWire) subsystem.  This addresses
old but only recently reported bugs.  Thanks.

Stefan Richter (2):
      firewire: cdev: fix 32 bit userland on 64 bit kernel compat corner cases
      firewire: ohci: fix DMA unmapping in an error path

 drivers/firewire/core-cdev.c |   24 +++++++++++++++++++++---
 drivers/firewire/ohci.c      |    9 +++++++--
 2 files changed, 28 insertions(+), 5 deletions(-)


Full log and diff:

commit a01e836087881dd9d824417190994c9b2b0f1dbb
Author: Stefan Richter <stefanr@s5r6.in-berlin.de>
Date:   Thu Aug 11 20:40:42 2011 +0200

    firewire: ohci: fix DMA unmapping in an error path
    
    If request_irq failed, we would pass wrong arguments to
    dma_free_coherent.  https://bugzilla.redhat.com/show_bug.cgi?id=728185
    
    Reported-by: Mads Kiilerich
    Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>

diff --git a/drivers/firewire/ohci.c b/drivers/firewire/ohci.c
index 4f6d72f..ded0c9b 100644
--- a/drivers/firewire/ohci.c
+++ b/drivers/firewire/ohci.c
@@ -2178,8 +2178,13 @@ static int ohci_enable(struct fw_card *card,
 			ohci_driver_name, ohci)) {
 		fw_error("Failed to allocate interrupt %d.\n", dev->irq);
 		pci_disable_msi(dev);
-		dma_free_coherent(ohci->card.device, CONFIG_ROM_SIZE,
-				  ohci->config_rom, ohci->config_rom_bus);
+
+		if (config_rom) {
+			dma_free_coherent(ohci->card.device, CONFIG_ROM_SIZE,
+					  ohci->next_config_rom,
+					  ohci->next_config_rom_bus);
+			ohci->next_config_rom = NULL;
+		}
 		return -EIO;
 	}
 

commit 9c1176b6a28850703ea6e3a0f0c703f6d6c61cd3
Author: Stefan Richter <stefanr@s5r6.in-berlin.de>
Date:   Thu Aug 11 00:06:04 2011 +0200

    firewire: cdev: fix 32 bit userland on 64 bit kernel compat corner cases
    
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

diff --git a/drivers/firewire/core-cdev.c b/drivers/firewire/core-cdev.c
index e6ad3bb..4799393 100644
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
-=====-==-== =--- -====
http://arcgraph.de/sr/
