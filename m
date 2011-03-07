Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755303Ab1CGHFx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 02:05:53 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:40549 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752291Ab1CGHFv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 02:05:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=XT2c5+P7WWiebf+2GdfZbRF8kHuwXghBHAtacAqwDCu+nq6bcctnQpIvmcZUik7NqW
         SHPWgErjxCEJuhLHqbqw4FfpesCg4buXG/8vYEBrL4TYC7dSWisItqJJLC8HAsPtRqHR
         oIQLa5ZgNwR6eviG5CgmceiD2fw7eV1FC7FTE=
Date: Mon, 7 Mar 2011 15:05:10 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: Christian Kujau <lists@nerdbynature.de>
Cc: LKML <linux-kernel@vger.kernel.org>, nicolas.2p.debian@free.fr,
        mmarek@suse.cz, max@stro.at, linux-kbuild@vger.kernel.org
Subject: Re: cannot create include/linux/version.h.tmp: Read-only file system
Message-ID: <20110307070510.GA1166@cr0.redhat.com>
References: <alpine.DEB.2.01.1103061600260.23816@trent.utfs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.01.1103061600260.23816@trent.utfs.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 06, 2011 at 04:22:21PM -0800, Christian Kujau wrote:
>Hi,
>
>I'm trying to build a kernel with O= with the kernel source residing 
>on a readonly NFS share. The main build finishes just fine, vmlinux & the 
>modules are all built, but "make deb-pkg" and "make rpm-pkg" fail to 
>build:
>
>--------------------------
>$ make V=1 O=/mnt/sdb/s0/ deb-pkg
>[...]
>set -e; : '  CHK     include/linux/version.h'; mkdir -p 
>include/linux/; 	
>(echo \#define LINUX_VERSION_CODE 132646; echo '#define 
>KERNEL_VERSION(a,b,c) (((a) << 16) + ((b) << 8) + (c))';) < 
>/usr/local/src/linux-2.6-git/Makefile > include/linux/version.h.tmp; if [ 
>-r include/linux/version.h ] && cmp -s include/linux/version.h 
>include/linux/version.h.tmp; then rm -f include/linux/version.h.tmp; else 
>: '  UPD     include/linux/version.h'; mv -f include/linux/version.h.tmp 
>include/linux/version.h; fi
>/bin/sh: cannot create include/linux/version.h.tmp: Read-only file system
>make[4]: *** [include/linux/version.h] Error 2
>
>--------------------------
>$ make V=1 O=/mnt/sdb/s0/ rpm-pkg
>[...]
>make -f /usr/local/src/linux-2.6-git/scripts/Makefile.clean 
>obj=arch/x86/boot/compressed
>  rm -rf .tmp_versions
>  rm -f vmlinux System.map .tmp_kallsyms* .tmp_version .tmp_vmlinux* 
>.tmp_System.map
>set -e; cd ..; ln -sf /usr/local/src/linux-2.6-git kernel-2.6.38rc7
>ln: creating symbolic link `kernel-2.6.38rc7': Permission denied
>make[2]: *** [rpm-pkg] Error 1
>--------------------------
>
>The full buidlogs are here: http://nerdbynature.de/bits/2.6.38-rc7/make/
>
>Note that e.g. "make binrpm-pkg" succeeds and puts the .rpm in $HOME, I 
>wonder if at least deb-pkg could be fixed..?
>

The following patch should fix both of them. :)

------------------>

Signed-off: WANG Cong <xiyou.wangcong@gmail.com>

---
diff --git a/Makefile b/Makefile
index 26d7d82..37163fa 100644
--- a/Makefile
+++ b/Makefile
@@ -979,7 +979,7 @@ define filechk_version.h
 	echo '#define KERNEL_VERSION(a,b,c) (((a) << 16) + ((b) << 8) + (c))';)
 endef
 
-include/linux/version.h: $(srctree)/Makefile FORCE
+include/linux/version.h: $(objtree)/Makefile FORCE
 	$(call filechk,version.h)
 
 include/generated/utsrelease.h: include/config/kernel.release FORCE
diff --git a/scripts/package/Makefile b/scripts/package/Makefile
index d0b931b..b5c3b67 100644
--- a/scripts/package/Makefile
+++ b/scripts/package/Makefile
@@ -26,7 +26,7 @@ RPM := $(shell if [ -x "/usr/bin/rpmbuild" ]; then echo rpmbuild; \
 	           else echo rpm; fi)
 
 # Remove hyphens since they have special meaning in RPM filenames
-KERNELPATH := kernel-$(subst -,,$(KERNELRELEASE))
+KERNELPATH := $(objtree)/kernel-$(subst -,,$(KERNELRELEASE))
 MKSPEC     := $(srctree)/scripts/package/mkspec
 PREV       := set -e; cd ..;
 
