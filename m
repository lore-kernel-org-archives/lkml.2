Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032834Ab2CPOSw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 10:18:52 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:33364 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1032793Ab2CPOSs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 10:18:48 -0400
From: Matt Fleming <matt@console-pimps.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Matthew Garret <mjg@redhat.com>, Matt Fleming <matt.fleming@intel.com>,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        Randy Dunlap <rdunlap@xenotime.net>
Subject: [PATCH 3/3] x86, efi: Add EFI boot stub documentation
Date: Fri, 16 Mar 2012 14:18:37 +0000
Message-Id: <1331907517-3985-4-git-send-email-matt@console-pimps.org>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1331907517-3985-1-git-send-email-matt@console-pimps.org>
References: <1331907517-3985-1-git-send-email-matt@console-pimps.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matt Fleming <matt.fleming@intel.com>

Since we can't expect every user to read the EFI boot stub code it
seems prudent to have a couple of paragraphs explaining what it is and
how it works.

The "initrd=" option in particular is tricky because it only
understands absolute EFI-style paths (backslashes as directory
separators), and until now this hasn't been documented anywhere. This
has tripped up a couple of users.

Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Matthew Garrett <mjg@redhat.com>
Cc: Randy Dunlap <rdunlap@xenotime.net>
Signed-off-by: Matt Fleming <matt.fleming@intel.com>
---
 Documentation/x86/efi-stub.txt |   65 ++++++++++++++++++++++++++++++++++++++++
 arch/x86/Kconfig               |    2 +
 2 files changed, 67 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/x86/efi-stub.txt

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
index 5bed94e..591c1a5 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1521,6 +1521,8 @@ config EFI_STUB
           This kernel feature allows a bzImage to be loaded directly
 	  by EFI firmware without the use of a bootloader.
 
+	  See Documentation/x86/efi-stub.txt for more information.
+
 config SECCOMP
 	def_bool y
 	prompt "Enable seccomp to safely compute untrusted bytecode"
-- 
1.7.4.4

