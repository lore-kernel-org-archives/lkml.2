Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754849Ab2K2Oav (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 09:30:51 -0500
Received: from service87.mimecast.com ([91.220.42.44]:58075 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754588Ab2K2Oas (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 09:30:48 -0500
Date: Thu, 29 Nov 2012 14:30:41 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Stephen Warren <swarren@wwwdotorg.org>
CC: Michal Marek <mmarek@suse.cz>, Grant Likely <grant.likely@secretlab.ca>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        Sam Ravnborg <sam@ravnborg.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        Stephen Warren <swarren@nvidia.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH V7 3/7] arm64: use new common dtc rule
Message-ID: <20121129143041.GC30437@arm.com>
References: <1354058956-7199-1-git-send-email-swarren@wwwdotorg.org>
 <1354058956-7199-3-git-send-email-swarren@wwwdotorg.org>
MIME-Version: 1.0
In-Reply-To: <1354058956-7199-3-git-send-email-swarren@wwwdotorg.org>
Thread-Topic: [PATCH V7 3/7] arm64: use new common dtc rule
Accept-Language: en-GB, en-US
Content-Language: en-US
User-Agent: Mutt/1.5.20 (2009-06-14)
X-MC-Unique: 112112914304601901
Content-Type: multipart/mixed; boundary="wRRV7LY7NUeQGEoC"
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--wRRV7LY7NUeQGEoC
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Tue, Nov 27, 2012 at 11:29:12PM +0000, Stephen Warren wrote:
> From: Stephen Warren <swarren@nvidia.com>
>=20
> The current rules have the .dtb files build in a different directory
> from the .dts files. This patch changes arm64 to use the generic dtb
> rule which builds .dtb files in the same directory as the source .dts.
>=20
> This requires moving parts of arch/arm64/boot/Makefile into newly created
> arch/arm64/boot/dts/Makefile, and updating arch/arm64/Makefile to call th=
e
> new Makefile.
>=20
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: linux-arm-kernel@lists.infradead.org
> Signed-off-by: Stephen Warren <swarren@nvidia.com>

I had a bit more clean-up in a local patch (see attached). Depending on
the timing, you can just fold it into your patch (basically removing the
MACHINE argument, adding KBUILD_DTBS and dtbs target help). It's been
derived from your arch/arm patch anyway ;).

--=20
Catalin
--wRRV7LY7NUeQGEoC
Content-Type: text/x-diff; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="0001-arm64-Add-dtbs-target-for-building-all-the-enabled-d.patch"

>From 906ea5523f1a5c2fadea72b54d5d6a8e5fecdfe5 Mon Sep 17 00:00:00 2001
From: Catalin Marinas <catalin.marinas@arm.com>
Date: Wed, 21 Nov 2012 11:44:59 +0000
Subject: [PATCH] arm64: Add dtbs target for building all the enabled dtb
 files

Based on Rob Herring's patches for arch/arm, this patch adds a dtbs
target to arch/arm64/boot/Makefile.

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
---
 arch/arm64/Makefile        | 17 +++++++++++------
 arch/arm64/boot/.gitignore |  1 +
 arch/arm64/boot/Makefile   |  6 ++++++
 3 files changed, 18 insertions(+), 6 deletions(-)
 create mode 100644 arch/arm64/boot/dts/Makefile

diff --git a/arch/arm64/Makefile b/arch/arm64/Makefile
index 93e871e..ddadd27 100644
--- a/arch/arm64/Makefile
+++ b/arch/arm64/Makefile
@@ -42,20 +42,24 @@ libs-y=09=09:=3D arch/arm64/lib/ $(libs-y)
 libs-y=09=09+=3D $(LIBGCC)
=20
 # Default target when executing plain make
-KBUILD_IMAGE :=3D Image.gz
+KBUILD_IMAGE=09:=3D Image.gz
+KBUILD_DTBS=09:=3D dtbs
=20
-all:=09$(KBUILD_IMAGE)
+all:=09$(KBUILD_IMAGE) $(KBUILD_DTBS)
=20
 boot :=3D arch/arm64/boot
=20
 Image Image.gz: vmlinux
-=09$(Q)$(MAKE) $(build)=3D$(boot) MACHINE=3D$(MACHINE) $(boot)/$@
+=09$(Q)$(MAKE) $(build)=3D$(boot) $(boot)/$@
=20
 zinstall install: vmlinux
-=09$(Q)$(MAKE) $(build)=3D$(boot) MACHINE=3D$(MACHINE) $@
+=09$(Q)$(MAKE) $(build)=3D$(boot) $@
=20
-%.dtb:
-=09$(Q)$(MAKE) $(build)=3D$(boot) MACHINE=3D$(MACHINE) $(boot)/$@
+%.dtb: scripts
+=09$(Q)$(MAKE) $(build)=3D$(boot) $(boot)/$@
+
+dtbs: scripts
+=09$(Q)$(MAKE) $(build)=3D$(boot) $(boot)/$@
=20
 # We use MRPROPER_FILES and CLEAN_FILES now
 archclean:
@@ -64,6 +68,7 @@ archclean:
 define archhelp
   echo  '* Image.gz      - Compressed kernel image (arch/$(ARCH)/boot/Imag=
e.gz)'
   echo  '  Image         - Uncompressed kernel image (arch/$(ARCH)/boot/Im=
age)'
+  echo  '* dtbs          - Build device tree blobs for enabled boards'
   echo  '  install       - Install uncompressed kernel'
   echo  '  zinstall      - Install compressed kernel'
   echo  '                  Install using (your) ~/bin/installkernel or'
diff --git a/arch/arm64/boot/.gitignore b/arch/arm64/boot/.gitignore
index 8dab0bb..98af90a 100644
--- a/arch/arm64/boot/.gitignore
+++ b/arch/arm64/boot/.gitignore
@@ -1,2 +1,3 @@
 Image
 Image.gz
+*.dtb
diff --git a/arch/arm64/boot/Makefile b/arch/arm64/boot/Makefile
index 20048be..ce8642e 100644
--- a/arch/arm64/boot/Makefile
+++ b/arch/arm64/boot/Makefile
@@ -14,6 +14,8 @@
 # Based on the ia64 boot/Makefile.
 #
=20
+include $(srctree)/arch/arm64/boot/dts/Makefile
+
 targets :=3D Image Image.gz
=20
 $(obj)/Image: vmlinux FORCE
@@ -22,6 +24,10 @@ $(obj)/Image: vmlinux FORCE
 $(obj)/Image.gz: $(obj)/Image FORCE
 =09$(call if_changed,gzip)
=20
+targets +=3D $(dtb-y)
+
+$(obj)/dtbs: $(addprefix $(obj)/, $(dtb-y))
+
 install: $(obj)/Image
 =09$(CONFIG_SHELL) $(srctree)/$(src)/install.sh $(KERNELRELEASE) \
 =09$(obj)/Image System.map "$(INSTALL_PATH)"
diff --git a/arch/arm64/boot/dts/Makefile b/arch/arm64/boot/dts/Makefile
new file mode 100644
index 0000000..e69de29
--wRRV7LY7NUeQGEoC--

