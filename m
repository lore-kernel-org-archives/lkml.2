Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755487Ab1HCVvT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 17:51:19 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:41689 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755287Ab1HCVvN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 17:51:13 -0400
Message-ID: <4E39C2CE.1000800@gmail.com>
Date: Wed, 03 Aug 2011 23:51:10 +0200
From: Maarten Lankhorst <m.b.lankhorst@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110707 Thunderbird/5.0
MIME-Version: 1.0
To: Matt Fleming <matt@console-pimps.org>
CC: linux-kernel@vger.kernel.org, syslinux@zytor.com
Subject: Re: efilinux release 0.8
References: <1311853470.21232.31.camel@mfleming-mobl1.ger.corp.intel.com>
In-Reply-To: <1311853470.21232.31.camel@mfleming-mobl1.ger.corp.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/28/2011 01:44 PM, Matt Fleming wrote:
> Hi,
>
> I'm pleased to announce release 0.8 of efilinux, a reference
> implementation of a minimal UEFI bootloader. This bootloader has no
> bells or whistles, it is simply a prototype with the minimum amount of
> smarts required to load a linux kernel (though loaders for other formats
> could be added).
>
> Currently it only supports booting x86-64 bzImages but i386 support is
> planned for release 0.9, with a 1.0 release coming after a thorough
> round of testing.
>
> If anyone has the time and inclination I'd really appreciate it if they
> could have a play with it on their machines and report any bugs. Testing
> has mainly been done under qemu up to this point so there are bound to
> be some lurking bugs that only show up on real hardware.
>
> As there is no configuration file parser all config is done via
> command-line arguments. To boot a kernel simply type,
>
> Shell> efilinux -l
> efilinux loader 0.8
> Devices:
>
> 	0. "Acpi(PNP0A03,0)/Pci(1|1)/Ata(Primary,Master)"
>
> Shell> efilinux -f Acpi(PNP0A03,0)/Pci(1|1)/Ata(Primary,Master):\bzimage
>
> efilinux understands the LILO-style initrd= kernel command-line
> argument, but the full device path to the initrd is required. A kernel
> command-line can be passed at the end of the command-line, e.g.
>
> Shell> efilinux -f bzimage console=ttyS0 root=/dev/sdb
>
> The latest release is available at,
>
> 	git://git.kernel.org/pub/scm/boot/efilinux/efilinux.git
>
> This project is a preview of the EFI stub patches that I hope to push
> into the kernel. The EFI stub will allow a bzImage to masquerade as an
> EFI application, such that the firmware will load the bzImage and jump
> to its entry point without requiring a bootloader at all.
>

Yuck, it's case sensitive and it requires you to type all that?
Here's a patch to accept 0:\vmlinuz initrd=0:\initrd.img and zap the sensitivity.

I alter name in file_open, but it seems nothing else requires it anyhow,
so I didn't see a need to copy or revert it.

For what it's worth, it didn't seem to boot on my asrock P67 pro3.

Signed-off-by: Maarten Lankhorst <m.b.lankhorst@gmail.com>

---
diff --git a/fs/fs.c b/fs/fs.c
index b799c00..555ced3 100644
--- a/fs/fs.c
+++ b/fs/fs.c
@@ -66,6 +66,21 @@ file_open(CHAR16 *name, struct file **file)
 	if (!f)
 		return EFI_OUT_OF_RESOURCES;
 
+	for (dev_len = 0; name[dev_len]; ++dev_len) {
+		if (name[dev_len] == ':') break;
+	}
+	if (!name[dev_len] || !dev_len)
+		goto notfound;
+	name[dev_len] = 0;
+
+	if (name[0] >= '0' && name[0] <= '9') {
+		i = Atoi(name);
+		if (i >= nr_fs_devices)
+			goto notfound;
+		f->handle = fs_devices[i].fh;
+		goto found;
+	}
+
 	for (i = 0; i < nr_fs_devices; i++) {
 		EFI_DEVICE_PATH *path;
 		CHAR16 *dev;
@@ -73,23 +88,20 @@ file_open(CHAR16 *name, struct file **file)
 		path = DevicePathFromHandle(fs_devices[i].handle);
 		dev = DevicePathToStr(path);
 
-		if (!StrnCmp(dev, name, StrLen(dev))) {
+		if (!StriCmp(dev, name)) {
 			f->handle = fs_devices[i].fh;
-			dev_len = StrLen(dev);
 			free_pool(dev);
 			break;
 		}
 
 		free_pool(dev);
 	}
+	if (i == nr_fs_devices)
+		goto notfound;
 
-	if (i == nr_fs_devices) {
-		err = EFI_NOT_FOUND;
-		goto fail;
-	}
-
+found:
 	/* Strip the device name */
-	filename = name + dev_len;
+	filename = name + dev_len + 1;
 
 	/* skip any path separators */
 	while (*filename == ':' || *filename == '\\')
@@ -104,6 +116,8 @@ file_open(CHAR16 *name, struct file **file)
 	*file = f;
 
 	return err;
+notfound:
+	err  = EFI_NOT_FOUND;
 fail:
 	Print(L"Unable to open file \"%s\"", name);
 	free(f);

