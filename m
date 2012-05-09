Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760170Ab2EIWfY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 18:35:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35296 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756798Ab2EIWfW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 18:35:22 -0400
Date: Wed, 9 May 2012 18:35:14 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file.rdu.redhat.com
To: torvalds@linux-foundation.org
cc: linux-parisc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rolf Eike Beer <eike-kernel@sf-tec.de>,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        Helge Deller <deller@gmx.de>
Subject: [PATCH 5/5] PA-RISC: fix compile errors
In-Reply-To: <Pine.LNX.4.64.1205091818430.1272@file.rdu.redhat.com>
Message-ID: <Pine.LNX.4.64.1205091834240.1272@file.rdu.redhat.com>
References: <Pine.LNX.4.64.1205091758310.1272@file.rdu.redhat.com>
 <Pine.LNX.4.64.1205091816470.1272@file.rdu.redhat.com>
 <Pine.LNX.4.64.1205091817170.1272@file.rdu.redhat.com>
 <Pine.LNX.4.64.1205091818160.1272@file.rdu.redhat.com>
 <Pine.LNX.4.64.1205091818430.1272@file.rdu.redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rolf Eike Beer <eike-kernel@sf-tec.de>

This was defined in asm/pdc.h which needs to include asm/page.h for
__PAGE_OFFSET. This leads to an include loop so that page.h eventually will
include pdc.h again. While this is no problem because of header guards, it is
a problem because some symbols may be undefined. Such an error is this:

In file included from /home/buildbot/repos/linux/include/linux/bitops.h:35:0,
                 from /home/buildbot/repos/linux/include/asm-generic/getorder.h:7,
                 from /home/buildbot/repos/linux/arch/parisc/include/asm/page.h:162,
                 from /home/buildbot/repos/linux/arch/parisc/include/asm/pdc.h:346,
                 from /home/buildbot/repos/linux/arch/parisc/include/asm/processor.h:16,
                 from /home/buildbot/repos/linux/arch/parisc/include/asm/spinlock.h:6,
                 from /home/buildbot/repos/linux/arch/parisc/include/asm/atomic.h:20,
                 from /home/buildbot/repos/linux/include/linux/atomic.h:4,
                 from /home/buildbot/repos/linux/include/linux/sysfs.h:20,
                 from /home/buildbot/repos/linux/include/linux/kobject.h:21,
                 from /home/buildbot/repos/linux/include/linux/device.h:17,
                 from /home/buildbot/repos/linux/include/linux/eisa.h:5,
                 from /home/buildbot/repos/linux/arch/parisc/kernel/pci.c:11:
/home/buildbot/repos/linux/arch/parisc/include/asm/bitops.h: In function "set_bit":
/home/buildbot/repos/linux/arch/parisc/include/asm/bitops.h:82:2: error: implicit declaration of function "_atomic_spin_lock_irqsave" [-Werror=implicit-function-declaration]
/home/buildbot/repos/linux/arch/parisc/include/asm/bitops.h:84:2: error: implicit declaration of function "_atomic_spin_unlock_irqrestore" [-Werror=implicit-function-declaration]

Signed-off-by: Rolf Eike Beer <eike-kernel@sf-tec.de>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
---
 arch/parisc/include/asm/page.h  |    6 ++++++
 arch/parisc/include/asm/pdc.h   |    7 -------
 arch/parisc/kernel/pdc_cons.c   |    1 +
 arch/parisc/kernel/time.c       |    1 +
 drivers/parisc/sba_iommu.c      |    1 +
 drivers/video/console/sticore.c |    2 ++
 6 files changed, 11 insertions(+), 7 deletions(-)

diff --git a/arch/parisc/include/asm/page.h b/arch/parisc/include/asm/page.h
index a84cc1f..4e0e7db 100644
--- a/arch/parisc/include/asm/page.h
+++ b/arch/parisc/include/asm/page.h
@@ -160,5 +160,11 @@ extern int npmem_ranges;
 
 #include <asm-generic/memory_model.h>
 #include <asm-generic/getorder.h>
+#include <asm/pdc.h>
+
+#define PAGE0   ((struct zeropage *)__PAGE_OFFSET)
+
+/* DEFINITION OF THE ZERO-PAGE (PAG0) */
+/* based on work by Jason Eckhardt (jason@equator.com) */
 
 #endif /* _PARISC_PAGE_H */
diff --git a/arch/parisc/include/asm/pdc.h b/arch/parisc/include/asm/pdc.h
index 4ca510b..7f0f2d2 100644
--- a/arch/parisc/include/asm/pdc.h
+++ b/arch/parisc/include/asm/pdc.h
@@ -343,8 +343,6 @@
 
 #ifdef __KERNEL__
 
-#include <asm/page.h> /* for __PAGE_OFFSET */
-
 extern int pdc_type;
 
 /* Values for pdc_type */
@@ -677,11 +675,6 @@ static inline char * os_id_to_string(u16 os_id) {
 
 #endif /* __KERNEL__ */
 
-#define PAGE0   ((struct zeropage *)__PAGE_OFFSET)
-
-/* DEFINITION OF THE ZERO-PAGE (PAG0) */
-/* based on work by Jason Eckhardt (jason@equator.com) */
-
 /* flags of the device_path */
 #define	PF_AUTOBOOT	0x80
 #define	PF_AUTOSEARCH	0x40
diff --git a/arch/parisc/kernel/pdc_cons.c b/arch/parisc/kernel/pdc_cons.c
index 4f00459..9bbd2a5 100644
--- a/arch/parisc/kernel/pdc_cons.c
+++ b/arch/parisc/kernel/pdc_cons.c
@@ -50,6 +50,7 @@
 #include <linux/init.h>
 #include <linux/major.h>
 #include <linux/tty.h>
+#include <asm/page.h>		/* for PAGE0 */
 #include <asm/pdc.h>		/* for iodc_call() proto and friends */
 
 static DEFINE_SPINLOCK(pdc_console_lock);
diff --git a/arch/parisc/kernel/time.c b/arch/parisc/kernel/time.c
index 7c07743..70e105d 100644
--- a/arch/parisc/kernel/time.c
+++ b/arch/parisc/kernel/time.c
@@ -29,6 +29,7 @@
 #include <asm/uaccess.h>
 #include <asm/io.h>
 #include <asm/irq.h>
+#include <asm/page.h>
 #include <asm/param.h>
 #include <asm/pdc.h>
 #include <asm/led.h>
diff --git a/drivers/parisc/sba_iommu.c b/drivers/parisc/sba_iommu.c
index 8644d53..42cfcd9 100644
--- a/drivers/parisc/sba_iommu.c
+++ b/drivers/parisc/sba_iommu.c
@@ -44,6 +44,7 @@
 #include <asm/ropes.h>
 #include <asm/mckinley.h>	/* for proc_mckinley_root */
 #include <asm/runway.h>		/* for proc_runway_root */
+#include <asm/page.h>		/* for PAGE0 */
 #include <asm/pdc.h>		/* for PDC_MODEL_* */
 #include <asm/pdcpat.h>		/* for is_pdc_pat() */
 #include <asm/parisc-device.h>
diff --git a/drivers/video/console/sticore.c b/drivers/video/console/sticore.c
index 6468a29..39571f9 100644
--- a/drivers/video/console/sticore.c
+++ b/drivers/video/console/sticore.c
@@ -22,7 +22,9 @@
 #include <linux/font.h>
 
 #include <asm/hardware.h>
+#include <asm/page.h>
 #include <asm/parisc-device.h>
+#include <asm/pdc.h>
 #include <asm/cacheflush.h>
 #include <asm/grfioctl.h>
 

