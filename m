Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755983Ab0EaOWG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 10:22:06 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:12271 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754912Ab0EaOWE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 10:22:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :x-enigmail-version:content-type:content-transfer-encoding;
        b=e0X4IAepTFSk2e1fvpBs/ZhTGM2qhAFIK5NN3tm4fXrWgY90CrtRZZoVyMwTW8FVzd
         inYmRI2FCjleJJGDdew6Zmo1Fl5kzESU3765dKdK2mFOlQC0r4wvk9IgMiuqFMfsI1ZZ
         DjCu3D0+3NJMuxtXMUeSyz7eOuA8o4H04q5wQ=
Message-ID: <4C03C608.1040600@gmail.com>
Date: Mon, 31 May 2010 16:22:00 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.4) Gecko/20100522 SUSE/3.1rc1-2.1 Thunderbird/3.1
MIME-Version: 1.0
To: dzickus@redhat.com
CC: Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       linux-ide@vger.kernel.org
Subject: hibernation hangs with ATA errors (lockup_detector bug)
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

with -next I get the following errors while trying to hibernate in
qemu-kvm after the image is stored on disk:
sd 0:0:0:0: [sda] Starting disk
sd 0:0:1:0: [sdb] Starting disk
e1000: eth0 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: RX
ata1.00: configured for MWDMA2
ata1.01: configured for MWDMA2
PM: thaw of devices complete after 168.017 msecs
ata2.01: qc timeout (cmd 0xec)
ata2.01: failed to IDENTIFY (I/O error, err_mask=0x4)
sd 0:0:1:0: [sdb] Stopping disk
sd 0:0:0:0: [sda] Stopping disk
uhci_hcd 0000:00:01.2: PCI INT D disabled
e1000 0000:00:03.0: PCI INT A disabled
ata2.01: qc timeout (cmd 0xec)
ata2.01: failed to IDENTIFY (I/O error, err_mask=0x4)
ata2.01: qc timeout (cmd 0xec)
ata2.01: failed to IDENTIFY (I/O error, err_mask=0x4)
...

I bisected it down to:
commit 58687acba59266735adb8ccd9b5b9aa2c7cd205b
Author: Don Zickus <dzickus@redhat.com>
Date:   Fri May 7 17:11:44 2010 -0400

    lockup_detector: Combine nmi_watchdog and softlockup detector

    The new nmi_watchdog (which uses the perf event subsystem) is very
    similar in structure to the softlockup detector.  Using Ingo's
    suggestion, I combined the two functionalities into one file:
    kernel/watchdog.c.
...



The config difference against 58687acb^:
--- .config.old     2010-05-31 16:01:51.727312636 +0200
+++ .config 2010-05-31 16:11:08.682136175 +0200
@@ -1,7 +1,7 @@
 #
 # Automatically generated make config: don't edit
 # Linux kernel version: 2.6.34-rc7
-# Mon May 31 16:01:51 2010
+# Mon May 31 16:11:08 2010
 #
 CONFIG_64BIT=y
 # CONFIG_X86_32 is not set
@@ -2133,7 +2133,7 @@
 CONFIG_DEBUG_KERNEL=y
 CONFIG_DEBUG_SHIRQ=y
 CONFIG_DETECT_SOFTLOCKUP=y
-CONFIG_NMI_WATCHDOG=y
+CONFIG_LOCKUP_DETECTOR=y
 # CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC is not set
 CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC_VALUE=0
 CONFIG_DETECT_HUNG_TASK=y




'nowatchdog' parameter helps.

$ grep PERF .config
CONFIG_HAVE_PERF_EVENTS=y
CONFIG_PERF_EVENTS=y
# CONFIG_PERF_COUNTERS is not set
# CONFIG_DEBUG_PERF_USE_VMALLOC is not set
CONFIG_HAVE_PERF_EVENTS_NMI=y

-- 
js
