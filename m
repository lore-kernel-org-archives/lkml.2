Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753955Ab2GSJh4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2012 05:37:56 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:33430 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753723Ab2GSJhw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2012 05:37:52 -0400
Date: Thu, 19 Jul 2012 10:37:38 +0100
From: Will Deacon <will.deacon@arm.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Arnd Bergmann <arnd@arndb.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Avi Kivity <avi@redhat.com>
Subject: Re: [PATCH] Revert "KVM: Export asm-generic/kvm_para.h"
Message-ID: <20120719093738.GA29153@mudshark.cambridge.arm.com>
References: <1342607393-32254-1-git-send-email-will.deacon@arm.com>
 <201207181158.07236.arnd@arndb.de>
 <CAMuHMdXiWdtrH74BBkw402W=M5jjeu+uQAkHUitWJD06f1tZdQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMuHMdXiWdtrH74BBkw402W=M5jjeu+uQAkHUitWJD06f1tZdQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Geert,

On Wed, Jul 18, 2012 at 01:33:01PM +0100, Geert Uytterhoeven wrote:
> > On Wednesday 18 July 2012, Will Deacon wrote:
> >
> >> I'm not sure what specific problem the original commit was fixing, so we
> >> may need to solve this another way if there's something I've missed.
> 
> See below.

[...]

> make[4]: *** No rule to make target
> `/scratch/kisskb/build/linux-next_m68k-allmodconfig_m68k/usr/include/linux/kvm_para.h',
> needed by `/scratch/kisskb/build/linux-next_m68k-allmodconfig_m68k/usr/include/linux/.check'.
> make[3]: *** [linux] Error 2
> make[2]: *** [headers_check] Error 2

[...]

> So far the former case is limited to sh (mainline) and m68k (next), but I expect
> more architectures to start using the "generic-y += ..." idiom.
> 
> The latter is limited to cris and m32r.
> 
> Hence just reverting 56457f38f212344fb38b250cfa7e7311c065022f is not the
> right fix, as it will cause more breakage.

Thanks for the explanation. Given that we have the asm-generic version of
kvm_para.h, I don't see why we can't just export linux/kvm_para.h
unconditionally and fix the few remaining architectures by adding generic-y
lines to their Kbuild files.

Something like below (I also removed what look like dead references to
asm-$(SRCARCH) in the srctree)...

Will

---8<---

diff --git a/arch/cris/include/asm/Kbuild b/arch/cris/include/asm/Kbuild
index 04d02a5..2fde49c 100644
--- a/arch/cris/include/asm/Kbuild
+++ b/arch/cris/include/asm/Kbuild
@@ -7,3 +7,5 @@ header-y += ethernet.h
 header-y += etraxgpio.h
 header-y += rs485.h
 header-y += sync_serial.h
+
+generic-y += kvm_para.h
diff --git a/arch/m32r/include/asm/Kbuild b/arch/m32r/include/asm/Kbuild
index c68e168..78c505e 100644
--- a/arch/m32r/include/asm/Kbuild
+++ b/arch/m32r/include/asm/Kbuild
@@ -1 +1,3 @@
 include include/asm-generic/Kbuild.asm
+
+generic-y += kvm_para.h
diff --git a/include/asm-generic/Kbuild.asm b/include/asm-generic/Kbuild.asm
index c5d2e5d..f180c99 100644
--- a/include/asm-generic/Kbuild.asm
+++ b/include/asm-generic/Kbuild.asm
@@ -1,15 +1,8 @@
-ifneq ($(wildcard $(srctree)/arch/$(SRCARCH)/include/asm/kvm.h \
-		  $(srctree)/include/asm-$(SRCARCH)/kvm.h),)
+ifneq ($(wildcard $(srctree)/arch/$(SRCARCH)/include/asm/kvm.h),)
 header-y  += kvm.h
 endif
 
-ifneq ($(wildcard $(srctree)/arch/$(SRCARCH)/include/asm/kvm_para.h \
-		  $(srctree)/include/asm-$(SRCARCH)/kvm_para.h),)
-header-y  += kvm_para.h
-endif
-
-ifneq ($(wildcard $(srctree)/arch/$(SRCARCH)/include/asm/a.out.h \
-		  $(srctree)/include/asm-$(SRCARCH)/a.out.h),)
+ifneq ($(wildcard $(srctree)/arch/$(SRCARCH)/include/asm/a.out.h),)
 header-y += a.out.h
 endif
 
@@ -21,6 +14,7 @@ header-y += fcntl.h
 header-y += ioctl.h
 header-y += ioctls.h
 header-y += ipcbuf.h
+header-y += kvm_para.h
 header-y += mman.h
 header-y += msgbuf.h
 header-y += param.h
diff --git a/include/linux/Kbuild b/include/linux/Kbuild
index 8760be3..048abc6 100644
--- a/include/linux/Kbuild
+++ b/include/linux/Kbuild
@@ -23,20 +23,13 @@ header-y += wimax/
 objhdr-y += version.h
 
 ifneq ($(wildcard $(srctree)/arch/$(SRCARCH)/include/asm/a.out.h \
-		  $(srctree)/include/asm-$(SRCARCH)/a.out.h \
 		  $(INSTALL_HDR_PATH)/include/asm-*/a.out.h),)
 header-y += a.out.h
 endif
 ifneq ($(wildcard $(srctree)/arch/$(SRCARCH)/include/asm/kvm.h \
-		  $(srctree)/include/asm-$(SRCARCH)/kvm.h \
 		  $(INSTALL_HDR_PATH)/include/asm-*/kvm.h),)
 header-y += kvm.h
 endif
-ifneq ($(wildcard $(srctree)/arch/$(SRCARCH)/include/asm/kvm_para.h \
-		  $(srctree)/include/asm-$(SRCARCH)/kvm_para.h \
-		  $(INSTALL_HDR_PATH)/include/asm-*/kvm_para.h),)
-header-y += kvm_para.h
-endif
 
 header-y += acct.h
 header-y += adb.h
@@ -229,6 +222,7 @@ header-y += kernel-page-flags.h
 header-y += kexec.h
 header-y += keyboard.h
 header-y += keyctl.h
+header-y += kvm_para.h
 header-y += l2tp.h
 header-y += limits.h
 header-y += llc.h
