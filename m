Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932129Ab1CGKph (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 05:45:37 -0500
Received: from trent.utfs.org ([194.246.123.103]:54841 "EHLO trent.utfs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755940Ab1CGKpd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 05:45:33 -0500
Date: Mon, 7 Mar 2011 02:45:27 -0800 (PST)
From: Christian Kujau <lists@nerdbynature.de>
To: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
cc: LKML <linux-kernel@vger.kernel.org>, nicolas.2p.debian@free.fr,
        mmarek@suse.cz, max@stro.at, linux-kbuild@vger.kernel.org
Subject: Re: cannot create include/linux/version.h.tmp: Read-only file
 system
In-Reply-To: <20110307070510.GA1166@cr0.redhat.com>
Message-ID: <alpine.DEB.2.01.1103070149390.23816@trent.utfs.org>
References: <alpine.DEB.2.01.1103061600260.23816@trent.utfs.org> <20110307070510.GA1166@cr0.redhat.com>
User-Agent: Alpine 2.01 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-AV-Checked: ClamAV using ClamSMTP (127.0.0.1)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 7 Mar 2011 at 15:05, Américo Wang wrote:
> The following patch should fix both of them. :)

Almost, for rpm-pkg:

------------------------------------
$ make V=1 O=/var/tmp/lnx rpm-pkg
[...]
set -e; cd ..; ln -sf /usr/local/src/linux-2.6-git 
/var/tmp/lnx/kernel-2.6.38rc7
/bin/bash /usr/local/src/linux-2.6-git/scripts/setlocalversion --save-scmversion
set -e; cd ..; tar -cz --exclude SCCS --exclude BitKeeper --exclude .svn --exclude CVS --exclude .pc --exclude .hg --exclude .git -f /var/tmp/lnx/kernel-2.6.38rc7.tar.gz /var/tmp/lnx/kernel-2.6.38rc7/.
tar: Removing leading `/' from member names
set -e; cd ..; rm /var/tmp/lnx/kernel-2.6.38rc7
rm -f /var/tmp/lnx/.scmversion
set -e; \
        /bin/bash /usr/local/src/linux-2.6-git/scripts/mkversion > 
/var/tmp/lnx/.tmp_version
set -e; \
        mv -f /var/tmp/lnx/.tmp_version /var/tmp/lnx/.version
rpmbuild  --target i386 -ta ..//var/tmp/lnx/kernel-2.6.38rc7.tar.gz
Building target platforms: i386
Building for target i386
error: File ..//var/tmp/lnx/kernel-2.6.38rc7.tar.gz: No such file or directory
/bin/cat: ..//var/tmp/lnx/kernel-2.6.38rc7.tar.gz: No such file or directory
error: File ..//var/tmp/lnx/kernel-2.6.38rc7.tar.gz: No such file or directory
/bin/cat: ..//var/tmp/lnx/kernel-2.6.38rc7.tar.gz: No such file or directory
error: Failed to read spec file from ..//var/tmp/lnx/kernel-2.6.38rc7.tar.gz
make[2]: *** [rpm-pkg] Error 1
make[1]: *** [rpm-pkg] Error 2
make: *** [sub-make] Error 2
------------------------------------

I tried to edit scripts/package/Makefile once more, but "make 
rpm-pkg" gets a few steps closer, but the resulting tar.gz is 
still wrong, gotta think this through tomorrow...

--- linux-2.6-git/scripts/package/Makefile.patched	2011-03-07 00:21:44.000000000 -0800
+++ linux-2.6-git/scripts/package/Makefile	2011-03-07 02:18:02.000000000 -0800
@@ -45,7 +45,8 @@ rpm-pkg rpm: $(objtree)/kernel.spec FORC
 	$(MAKE) clean
 	$(PREV) ln -sf $(srctree) $(KERNELPATH)
 	$(CONFIG_SHELL) $(srctree)/scripts/setlocalversion --save-scmversion
-	$(PREV) tar -cz $(RCS_TAR_IGNORE) -f $(KERNELPATH).tar.gz $(KERNELPATH)/.
+	$(PREV) tar -cz $(RCS_TAR_IGNORE) -f $(KERNELPATH).tar.gz \
+	$(KERNELPATH)/. $(objtree)/kernel.spec
 	$(PREV) rm $(KERNELPATH)
 	rm -f $(objtree)/.scmversion
 	set -e; \
@@ -53,8 +54,8 @@ rpm-pkg rpm: $(objtree)/kernel.spec FORC
 	set -e; \
 	mv -f $(objtree)/.tmp_version $(objtree)/.version
 
-	$(RPM) $(RPMOPTS) --target $(UTS_MACHINE) -ta ../$(KERNELPATH).tar.gz
-	rm ../$(KERNELPATH).tar.gz
+	$(RPM) $(RPMOPTS) --target $(UTS_MACHINE) -ta $(KERNELPATH).tar.gz
+	rm $(KERNELPATH).tar.gz
 
 clean-files := $(objtree)/kernel.spec
 
 


Unfortunately, even with your patch "make deb-pkg" still fails:

---------------------
$ make V=1 O=/var/tmp/lnx/ deb-pkg
[...]
Kernel: arch/x86/boot/bzImage is ready  (#2)
mkdir -p /var/tmp/lnx/arch/i386/boot
ln -fsn ../../x86/boot/bzImage /var/tmp/lnx/arch/i386/boot/bzImage
  set -e; test `id -u` = 0 || test -n "" || { which fakeroot >/dev/null 
2>&1 && KBUILD_PKG_ROOTCMD="fakeroot -u"; } || { echo; echo "builddeb must 
be run as root (or using fakeroot)."; echo "KBUILD_PKG_ROOTCMD is unset 
and fakeroot not found."; echo "Try setting KBUILD_PKG_ROOTCMD to a 
command to acquire"; echo "root privileges (e.g., 'fakeroot -u' or 
'sudo')."; false; } && $KBUILD_PKG_ROOTCMD /bin/bash 
/usr/local/src/linux-2.6-git/scripts/package/builddeb
make -C /usr/local/src/linux-2.6-git O=/var/tmp/lnx/. headers_check
set -e; : '  CHK     include/linux/version.h'; mkdir -p include/linux/;         
(echo \#define LINUX_VERSION_CODE 132646; echo '#define 
KERNEL_VERSION(a,b,c) (((a) << 16) + ((b) << 8) + (c))';) < 
/usr/local/src/linux-2.6-git/Makefile > include/linux/version.h.tmp; if [ 
-r include/linux/version.h ] && cmp -s include/linux/version.h 
include/linux/version.h.tmp; then rm -f include/linux/version.h.tmp; else 
: '  UPD     include/linux/version.h'; mv -f include/linux/version.h.tmp 
include/linux/version.h; fi
/bin/sh: cannot create include/linux/version.h.tmp: Read-only file system
make[4]: *** [include/linux/version.h] Error 2
make[3]: *** [all] Error 2
make[2]: *** [deb-pkg] Error 2
make[1]: *** [deb-pkg] Error 2
make: *** [sub-make] Error 2
---------------------

Christian.
-- 
BOFH excuse #284:

Electrons on a bender
