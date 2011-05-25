Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756698Ab1EYUqh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 16:46:37 -0400
Received: from outappmail003.snc4.facebook.com ([66.220.144.157]:50436 "EHLO
	mx-out.facebook.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756646Ab1EYUqf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 16:46:35 -0400
Date: Wed, 25 May 2011 13:46:34 -0700
From: Arun Sharma <asharma@fb.com>
To: Michal Marek <mmarek@suse.cz>
Cc: Arun Sharma <asharma@fb.com>, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/6] kbuild: Append RPM release to $KERNELRELEASE
Message-ID: <20110525204634.GA31841@dev1756.snc6.facebook.com>
References: <1305653779-3445-1-git-send-email-asharma@fb.com>
 <1305653779-3445-5-git-send-email-asharma@fb.com>
 <4DD2D703.4030908@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DD2D703.4030908@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 17, 2011 at 10:13:55PM +0200, Michal Marek wrote:
> 
> Please stop decorating the kernel release string for the sake of make
> rpm, thanks. If you really want the kernel release string match rpm's
> %{version}-%{release}, how about this: Let the user set
> CONFIG_LOCALVERSION=-<number> and check in make rpm if $KERNELRELEASE
> ends with -<number>. If so, use <number> in the Release: field and the
> rest in Version:, otherwise use the same scheme as before. That way, you
> won't force a new kernel release numbering scheme on anyone.

This patch has been working better than the previous one for us and it
has a similar property that it is a nop for developers who don't use
rpm for packaging.

commit 29cbbfa5d840ac1ecd80a2045f05f6440d2c4c04
Author: Arun Sharma <asharma@fb.com>
Date:   Fri May 20 14:48:01 2011 -0700

    kbuild: Use KERNELRELEASE from packaging scripts
    
    This adds two changes to the kernel Makefile:
    
    * Honor KERNELRELEASE if it's already set
    * Allow external scripts to append $LOCAL_VERSION to
      $EXTRA_VERSION

diff --git a/Makefile b/Makefile
index 123d858..01c51e4 100644
--- a/Makefile
+++ b/Makefile
@@ -368,7 +368,11 @@ KBUILD_CFLAGS_MODULE  := -DMODULE
 KBUILD_LDFLAGS_MODULE := -T $(srctree)/scripts/module-common.lds
 
 # Read KERNELRELEASE from include/config/kernel.release (if it exists)
-KERNELRELEASE = $(shell cat include/config/kernel.release 2> /dev/null)
+# and if it's not already defined
+KERNELRELEASE ?= $(shell cat include/config/kernel.release 2> /dev/null)
+ifdef LOCAL_VERSION
+EXTRAVERSION := $(EXTRAVERSION)_$(LOCAL_VERSION)
+endif
 KERNELVERSION = $(VERSION).$(PATCHLEVEL).$(SUBLEVEL)$(EXTRAVERSION)
 
 export VERSION PATCHLEVEL SUBLEVEL KERNELRELEASE KERNELVERSION
diff --git a/scripts/package/mkspec b/scripts/package/mkspec
index 001814e..c496bd5 100755
--- a/scripts/package/mkspec
+++ b/scripts/package/mkspec
@@ -23,13 +23,16 @@ fi
 
 PROVIDES="$PROVIDES kernel-$KERNELRELEASE"
 __KERNELRELEASE=`echo $KERNELRELEASE | sed -e "s/-/_/g"`
+LOCAL_VERSION=`. $srctree/scripts/mkversion``$srctree/scripts/setlocalversion | sed 's/-/_/g'`
+KERNELRELEASE=${__KERNELRELEASE}-${LOCAL_VERSION}
+
 
 echo "Name: kernel"
 echo "Summary: The Linux Kernel"
 echo "Version: $__KERNELRELEASE"
 # we need to determine the NEXT version number so that uname and
 # rpm -q will agree
-echo "Release: `. $srctree/scripts/mkversion`"
+echo "Release: $LOCAL_VERSION"
 echo "License: GPL"
 echo "Group: System Environment/Kernel"
 echo "Vendor: The Linux Community"
@@ -84,6 +87,8 @@ fi
 
 echo "%build"
 echo 'rm -rf $RPM_BUILD_ROOT'
+echo "export KERNELRELEASE=%{version}-%{release}"
+echo "export LOCAL_VERSION=%{release}"
 
 if ! $PREBUILT; then
 echo "make clean && make %{?_smp_mflags}"
@@ -91,6 +96,8 @@ echo ""
 fi
 
 echo "%install"
+echo "export KERNELRELEASE=%{version}-%{release}"
+echo "export LOCAL_VERSION=%{release}"
 echo "%ifarch ia64"
 echo 'mkdir -p $RPM_BUILD_ROOT/boot/efi $RPM_BUILD_ROOT/lib/modules'
 echo 'mkdir -p $RPM_BUILD_ROOT/lib/firmware'
