Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760078Ab2EDVJr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 17:09:47 -0400
Received: from mail-pz0-f45.google.com ([209.85.210.45]:61380 "EHLO
	mail-pz0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932485Ab2EDUqi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 16:46:38 -0400
Message-Id: <20120504204228.816066888@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 04 May 2012 13:43:16 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Matt Fleming <matt.fleming@intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: [ 52/75] x86, boot: Correct CFLAGS for hostprogs
In-Reply-To: <20120504204258.GA12552@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "H. Peter Anvin" <hpa@zytor.com>

commit 446e1c86d51d0823e003a43a2b85c430efce2733 upstream.

This is a partial revert of commit:
    d40f833 "Restrict CFLAGS for hostprogs"

The endian-manipulation macros in tools/include need <linux/types.h>,
but the hostprogs in arch/x86/boot need several headers from the
kernel build tree, which means we have to add the kernel headers to
the include path.  This picks up <linux/types.h> from the kernel tree,
which gives a warning.

Since this use of <linux/types.h> is intentional, add
-D__EXPORTED_HEADERS__ to the command line to silence the warning.

A better way to fix this would be to always install the exported
kernel headers into $(objtree)/usr/include as a standard part of the
kernel build, but that is a lot more involved.

Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
Acked-by: Matt Fleming <matt.fleming@intel.com>
Link: http://lkml.kernel.org/r/1330436245-24875-5-git-send-email-matt@console-pimps.org
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/boot/Makefile |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/arch/x86/boot/Makefile
+++ b/arch/x86/boot/Makefile
@@ -37,9 +37,9 @@ setup-y		+= video-bios.o
 targets		+= $(setup-y)
 hostprogs-y	:= mkcpustr tools/build
 
-HOSTCFLAGS_mkcpustr.o := -I$(srctree)/arch/$(SRCARCH)/include
-HOST_EXTRACFLAGS += -I$(objtree)/include -I$(srctree)/tools/include \
-                   -include $(srctree)/include/linux/kconfig.h
+HOST_EXTRACFLAGS += -I$(srctree)/tools/include $(LINUXINCLUDE) \
+	            -D__EXPORTED_HEADERS__
+
 $(obj)/cpu.o: $(obj)/cpustr.h
 
 quiet_cmd_cpustr = CPUSTR  $@


