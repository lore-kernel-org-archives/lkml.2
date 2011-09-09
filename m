Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932458Ab1IIBsS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Sep 2011 21:48:18 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:49012 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932067Ab1IIBsO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Sep 2011 21:48:14 -0400
Date: Fri, 9 Sep 2011 09:48:06 +0800
From: Yong Zhang <yong.zhang0@gmail.com>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu,
        Jesse Barnes <jbarnes@virtuousgeek.org>, linux-pci@vger.kernel.org,
        linux-doc@vger.kernel.org
Subject: [UPDATED] [PATCH 61/62] Documentation: irq: Change documents related
 to IRQF_DISABLED
Message-ID: <20110909014806.GD18249@zhy>
Reply-To: Yong Zhang <yong.zhang0@gmail.com>
References: <1315383059-3673-1-git-send-email-yong.zhang0@gmail.com>
 <1315383059-3673-62-git-send-email-yong.zhang0@gmail.com>
 <4E6935D9.1040104@xenotime.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4E6935D9.1040104@xenotime.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

IRQF_DISABLED is a NOOP now, place where suggest to use this
flag also doesn't make sense any more.

Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>
---
 Documentation/PCI/MSI-HOWTO.txt  |   21 ---------------------
 Documentation/scsi/ncr53c8xx.txt |    4 +++-
 Documentation/scsi/tmscsim.txt   |    4 ++--
 3 files changed, 5 insertions(+), 24 deletions(-)

diff --git a/Documentation/PCI/MSI-HOWTO.txt b/Documentation/PCI/MSI-HOWTO.txt
index 53e6fca..b3f514d 100644
--- a/Documentation/PCI/MSI-HOWTO.txt
+++ b/Documentation/PCI/MSI-HOWTO.txt
@@ -255,27 +255,6 @@ as many vectors for MSI as it could for MSI-X.  On some platforms, MSI
 interrupts must all be targeted at the same set of CPUs whereas MSI-X
 interrupts can all be targeted at different CPUs.
 
-4.5.2 Spinlocks
-
-Most device drivers have a per-device spinlock which is taken in the
-interrupt handler.  With pin-based interrupts or a single MSI, it is not
-necessary to disable interrupts (Linux guarantees the same interrupt will
-not be re-entered).  If a device uses multiple interrupts, the driver
-must disable interrupts while the lock is held.  If the device sends
-a different interrupt, the driver will deadlock trying to recursively
-acquire the spinlock.
-
-There are two solutions.  The first is to take the lock with
-spin_lock_irqsave() or spin_lock_irq() (see
-Documentation/DocBook/kernel-locking).  The second is to specify
-IRQF_DISABLED to request_irq() so that the kernel runs the entire
-interrupt routine with interrupts disabled.
-
-If your MSI interrupt routine does not hold the lock for the whole time
-it is running, the first solution may be best.  The second solution is
-normally preferred as it avoids making two transitions from interrupt
-disabled to enabled and back again.
-
 4.6 How to tell whether MSI/MSI-X is enabled on a device
 
 Using 'lspci -v' (as root) may show some devices with "MSI", "Message
diff --git a/Documentation/scsi/ncr53c8xx.txt b/Documentation/scsi/ncr53c8xx.txt
index cda5f8f..c5a9904 100644
--- a/Documentation/scsi/ncr53c8xx.txt
+++ b/Documentation/scsi/ncr53c8xx.txt
@@ -786,7 +786,9 @@ port address 0x1400.
         irqm:1     same as initial settings (assumed BIOS settings)
         irqm:2     always totem pole
         irqm:0x10  driver will not use IRQF_SHARED flag when requesting irq
-        irqm:0x20  driver will not use IRQF_DISABLED flag when requesting irq
+        irqm:0x20  driver will not use IRQF_DISABLED (does not make sense
+		   any more since genirq will keep irq disabled and the flag
+		   is dead from linux-2.6.35) flag when requesting irq
 
     (Bits 0x10 and 0x20 can be combined with hardware irq mode option)
 
diff --git a/Documentation/scsi/tmscsim.txt b/Documentation/scsi/tmscsim.txt
index 61c0531..1dee219 100644
--- a/Documentation/scsi/tmscsim.txt
+++ b/Documentation/scsi/tmscsim.txt
@@ -108,8 +108,8 @@ MHz PCI bus works for me, though, but I don't recommend using higher clocks
 than the 33.33 MHz being in the PCI spec.
 
 If you want to share the IRQ with another device and the driver refuses to
-do so, you might succeed with changing the DC390_IRQ type in tmscsim.c to 
-IRQF_SHARED | IRQF_DISABLED.
+do so, you should find out what's the mismatch between the shared IRQs,
+and CONFIG_DEBUG_SHIRQ may give you more help.
 
 
 3.Features
-- 
1.7.4.1

