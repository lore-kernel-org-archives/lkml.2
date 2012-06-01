Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965778Ab2FATNs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 15:13:48 -0400
Received: from terminus.zytor.com ([198.137.202.10]:43213 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933654Ab2FATNq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 15:13:46 -0400
Date: Fri, 1 Jun 2012 12:13:34 -0700
From: tip-bot for Matt Fleming <matt.fleming@intel.com>
Message-ID: <tip-0c7596621e313bfcfbacb288e768c7150f5de9e0@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, mjg@redhat.com, hpa@zytor.com,
        mingo@kernel.org, rdunlap@xenotime.net, tglx@linutronix.de,
        matt.fleming@intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, mjg@redhat.com,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, rdunlap@xenotime.net,
        matt.fleming@intel.com
In-Reply-To: <1331907517-3985-4-git-send-email-matt@console-pimps.org>
References: <1331907517-3985-4-git-send-email-matt@console-pimps.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/efi] x86, efi: Add EFI boot stub documentation
Git-Commit-ID: 0c7596621e313bfcfbacb288e768c7150f5de9e0
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 01 Jun 2012 12:13:40 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0c7596621e313bfcfbacb288e768c7150f5de9e0
Gitweb:     http://git.kernel.org/tip/0c7596621e313bfcfbacb288e768c7150f5de9e0
Author:     Matt Fleming <matt.fleming@intel.com>
AuthorDate: Fri, 16 Mar 2012 12:03:13 +0000
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Fri, 1 Jun 2012 09:11:41 -0700

x86, efi: Add EFI boot stub documentation

Since we can't expect every user to read the EFI boot stub code it
seems prudent to have a couple of paragraphs explaining what it is and
how it works.

The "initrd=" option in particular is tricky because it only
understands absolute EFI-style paths (backslashes as directory
separators), and until now this hasn't been documented anywhere. This
has tripped up a couple of users.

Cc: Matthew Garrett <mjg@redhat.com>
Cc: Randy Dunlap <rdunlap@xenotime.net>
Signed-off-by: Matt Fleming <matt.fleming@intel.com>
Link: http://lkml.kernel.org/r/1331907517-3985-4-git-send-email-matt@console-pimps.org
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 Documentation/x86/efi-stub.txt |   65 ++++++++++++++++++++++++++++++++++++++++
 arch/x86/Kconfig               |    2 +
 2 files changed, 67 insertions(+), 0 deletions(-)

diff --git a/Documentation/x86/efi-stub.txt b/Documentation/x86/efi-stub.txt
new file mode 100644
index 0000000..44e6bb6
--- /dev/null
+++ b/Documentation/x86/efi-stub.txt
@@ -0,0 +1,65 @@
+			  The EFI Boot Stub
+		     ---------------------------
+
+On the x86 platform, a bzImage can masquerade as a PE/COFF image,
+thereby convincing EFI firmware loaders to load it as an EFI
+executable. The code that modifies the bzImage header, along with the
+EFI-specific entry point that the firmware loader jumps to are
+collectively known as the "EFI boot stub", and live in
+arch/x86/boot/header.S and arch/x86/boot/compressed/eboot.c,
+respectively.
+
+By using the EFI boot stub it's possible to boot a Linux kernel
+without the use of a conventional EFI boot loader, such as grub or
+elilo. Since the EFI boot stub performs the jobs of a boot loader, in
+a certain sense it *IS* the boot loader.
+
+The EFI boot stub is enabled with the CONFIG_EFI_STUB kernel option.
+
+
+**** How to install bzImage.efi
+
+The bzImage located in arch/x86/boot/bzImage must be copied to the EFI
+System Partiion (ESP) and renamed with the extension ".efi". Without
+the extension the EFI firmware loader will refuse to execute it. It's
+not possible to execute bzImage.efi from the usual Linux file systems
+because EFI firmware doesn't have support for them.
+
+
+**** Passing kernel parameters from the EFI shell
+
+Arguments to the kernel can be passed after bzImage.efi, e.g.
+
+	fs0:> bzImage.efi console=ttyS0 root=/dev/sda4
+
+
+**** The "initrd=" option
+
+Like most boot loaders, the EFI stub allows the user to specify
+multiple initrd files using the "initrd=" option. This is the only EFI
+stub-specific command line parameter, everything else is passed to the
+kernel when it boots.
+
+The path to the initrd file must be an absolute path from the
+beginning of the ESP, relative path names do not work. Also, the path
+is an EFI-style path and directory elements must be separated with
+backslashes (\). For example, given the following directory layout,
+
+fs0:>
+	Kernels\
+			bzImage.efi
+			initrd-large.img
+
+	Ramdisks\
+			initrd-small.img
+			initrd-medium.img
+
+to boot with the initrd-large.img file if the current working
+directory is fs0:\Kernels, the following command must be used,
+
+	fs0:\Kernels> bzImage.efi initrd=\Kernels\initrd-large.img
+
+Notice how bzImage.efi can be specified with a relative path. That's
+because the image we're executing is interpreted by the EFI shell,
+which understands relative paths, whereas the rest of the command line
+is passed to bzImage.efi.
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index d700811..c70684f 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1506,6 +1506,8 @@ config EFI_STUB
           This kernel feature allows a bzImage to be loaded directly
 	  by EFI firmware without the use of a bootloader.
 
+	  See Documentation/x86/efi-stub.txt for more information.
+
 config SECCOMP
 	def_bool y
 	prompt "Enable seccomp to safely compute untrusted bytecode"
