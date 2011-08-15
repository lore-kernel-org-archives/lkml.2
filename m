Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752064Ab1HOTkp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 15:40:45 -0400
Received: from mxout3.netvision.net.il ([194.90.6.2]:33590 "EHLO
	mxout3.netvision.net.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751302Ab1HOTko (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 15:40:44 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; CHARSET=US-ASCII; format=flowed
Message-id: <4E497708.4080108@billauer.co.il>
Date: Mon, 15 Aug 2011 22:44:08 +0300
From: Eli Billauer <eli@billauer.co.il>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
To: michal.simek@petalogix.com
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] microblaze: Removed U-Boot image creation from
 simpleImage rule
References: <4E3ABDB7.1000300@billauer.co.il> <4E490E14.3060902@petalogix.com>
In-reply-to: <4E490E14.3060902@petalogix.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry, I didn't notice that simpleImage.% was the only target to get 
uImage as well.


In this patch there is no simpleImage.%.ub rule, as I got messed up with 
wildcard issues, and I didn't see any point in working on resolving 
them. In practice, I suppose one wants either an U-Boot image or a 
simpleImage. In case both are wanted, it's as simple as mention both in 
the make target.


Patch follows (I made a few other changes as well).


  Eli


diff --git a/arch/microblaze/Makefile b/arch/microblaze/Makefile
index b23c40e..1dfaf22 100644
--- a/arch/microblaze/Makefile
+++ b/arch/microblaze/Makefile
@@ -70,7 +70,7 @@ export MMU DTB
 all: linux.bin
 
 # With make 3.82 we cannot mix normal and wildcard targets
-BOOT_TARGETS1 = linux.bin linux.bin.gz
+BOOT_TARGETS1 = linux.bin linux.bin.gz uImage
 BOOT_TARGETS2 = simpleImage.%
 
 archclean:
@@ -85,8 +85,8 @@ define archhelp
   echo '* linux.bin    - Create raw binary'
   echo '  linux.bin.gz - Create compressed raw binary'
   echo '  simpleImage.<dt> - ELF image with $(arch)/boot/dts/<dt>.dts 
linked in'
-  echo '                   - stripped elf with fdt blob'
-  echo '  simpleImage.<dt>.unstrip - full ELF image with fdt blob'
+  echo '                   - stripped elf with fdt blob, as well as 
unstripped'
+  echo '  uImage           - Image for U-Boot'
   echo '  *_defconfig      - Select default config from 
arch/microblaze/configs'
   echo ''
   echo '  Targets with <dt> embed a device tree blob inside the image'
@@ -96,4 +96,4 @@ define archhelp
   echo '  (minus the .dts extension).'
 endef
 
-MRPROPER_FILES += $(boot)/simpleImage.*
+MRPROPER_FILES += $(boot)/simpleImage.* $(boot)/uImage*
diff --git a/arch/microblaze/boot/Makefile b/arch/microblaze/boot/Makefile
index 4c4e58e..f7426eb 100644
--- a/arch/microblaze/boot/Makefile
+++ b/arch/microblaze/boot/Makefile
@@ -6,7 +6,7 @@ MKIMAGE := $(srctree)/scripts/mkuboot.sh
 
 obj-y += linked_dtb.o
 
-targets := linux.bin linux.bin.gz simpleImage.%
+targets := linux.bin linux.bin.gz simpleImage.% uImage
 
 OBJCOPYFLAGS := -O binary
 
@@ -21,7 +21,6 @@ endif
 
 $(obj)/linux.bin: vmlinux FORCE
     $(call if_changed,objcopy)
-    $(call if_changed,uimage)
     @echo 'Kernel: $@ is ready' ' (#'`cat .version`')'
 
 $(obj)/linux.bin.gz: $(obj)/linux.bin FORCE
@@ -43,11 +42,13 @@ quiet_cmd_uimage = UIMAGE  $@.ub
 
 $(obj)/simpleImage.%: vmlinux FORCE
     $(call if_changed,cp,.unstrip)
-    $(call if_changed,objcopy)
-    $(call if_changed,uimage)
     $(call if_changed,strip)
     @echo 'Kernel: $@ is ready' ' (#'`cat .version`')'
 
+$(obj)/uImage: vmlinux FORCE
+    $(call if_changed,objcopy)
+    $(call if_changed,uimage)
+    @echo 'Kernel: $@ is ready' ' (#'`cat .version`')'
 
 # Rule to build device tree blobs
 DTC_FLAGS := -p 1024



Michal Simek wrote:

> Eli Billauer wrote:
>> The simpleImage rule used to create a U-boot image as well, resulting in
>> a build error if the mkimage utility wasn't set up. A line in the 
>> Makefile
>> was removed, so "make simpleImage.(something)" now does what one 
>> should expect.
>
> Agree that we should remove it but that patch is incomplete.
> Please do these two more changes.
> 1. Remove uimage generation for linux.bin - the same reason as you 
> describe
> 2a. Add support for linux.bin.ub or uImage if you like
> 2b. Add support for simpleImage.%.ub
>
> I don't want to lose possibility to create u-boot formats.
>
> Thanks,
> Michal
>


-- 
Web: http://www.billauer.co.il

