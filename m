Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756523Ab2K3IwM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 03:52:12 -0500
Received: from mga01.intel.com ([192.55.52.88]:40531 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755673Ab2K3It1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 03:49:27 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,191,1355126400"; 
   d="scan'208";a="255459062"
From: "Fenghua Yu" <fenghua.yu@intel.com>
To: "H Peter Anvin" <hpa@zytor.com>, "Ingo Molnar" <mingo@elte.hu>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        "Asit K Mallick" <asit.k.mallick@intel.com>,
        "Tigran Aivazian" <tigran@aivazian.fsnet.co.uk>,
        "Andreas Herrmann" <andreas.herrmann3@amd.com>,
        "Borislav Petkov" <borislav.petkov@amd.com>,
        "linux-kernel" <linux-kernel@vger.kernel.org>, "x86" <x86@kernel.org>
Cc: "Fenghua Yu" <fenghua.yu@intel.com>
Subject: [PATCH v2 01/10] Documentation/x86: Early load microcode
Date: Thu, 29 Nov 2012 17:47:39 -0800
Message-Id: <1354240068-9821-2-git-send-email-fenghua.yu@intel.com>
X-Mailer: git-send-email 1.7.2
In-Reply-To: <1354240068-9821-1-git-send-email-fenghua.yu@intel.com>
References: <1354240068-9821-1-git-send-email-fenghua.yu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fenghua Yu <fenghua.yu@intel.com>

Documenation for early loading microcode methodology.

Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
---
 Documentation/x86/early-microcode.txt |   43 +++++++++++++++++++++++++++++++++
 1 files changed, 43 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/x86/early-microcode.txt

diff --git a/Documentation/x86/early-microcode.txt b/Documentation/x86/early-microcode.txt
new file mode 100644
index 0000000..9b3a6ab
--- /dev/null
+++ b/Documentation/x86/early-microcode.txt
@@ -0,0 +1,43 @@
+Early load microcode
+====================
+By Fenghua Yu <fenghua.yu@intel.com>
+
+Kernel can update microcode in early phase of boot time. Loading microcode early
+can fix CPU issues before they are observed during kernel boot time.
+
+Microcode is stored in an initrd file. The microcode is read from the initrd
+file and loaded to CPUs during boot time.
+
+The format of the combined initrd image is microcode in cpio format followed by
+the initrd image (maybe compressed). Kernel parses the combined initrd image
+during boot time. The microcode file in cpio name space is:
+kernel/x86/microcode/GenuineIntel.bin
+
+During BSP boot (before SMP starts), if the kernel finds the microcode file in
+the initrd file, it parses the microcode and saves matching microcode in memory.
+If matching microcode is found, it will be uploaded in BSP and later on in all
+APs.
+
+The cached microcode patch is applied when CPUs resume from a sleep state.
+
+There are two legacy user space interfaces to load microcode, either through
+/dev/cpu/microcode or through /sys/devices/system/cpu/microcode/reload file
+in sysfs.
+
+In addition to these two legacy methods, the early loading method described
+here is the third method with which microcode can be uploaded to a system's
+CPUs.
+
+The following example script shows how to generate a new combined initrd file in
+/boot/initrd-3.5.0.ucode.img with original microcode microcode.hex and
+original initrd image /boot/initrd-3.5.0.img.
+
+mkdir initrd
+cd initrd
+cp ../microcode.hex kernel/x86/microcode/GenuineIntel/microcode.hex
+find .|cpio -oc >../ucode.cpio
+cd ..
+cat ucode.cpio /boot/initrd-3.5.0.img >/boot/initrd-3.5.0.ucode.img
+
+The generated /boot/initrd-3.5.0.ucode.img can be used as initrd file to load
+microcode during early boot time.
-- 
1.7.2

