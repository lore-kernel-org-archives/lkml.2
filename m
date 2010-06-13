Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754309Ab0FMTeb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jun 2010 15:34:31 -0400
Received: from mx.ij.cx ([212.13.201.15]:61951 "EHLO wes.ijneb.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752341Ab0FMTe3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jun 2010 15:34:29 -0400
X-Greylist: delayed 1980 seconds by postgrey-1.27 at vger.kernel.org; Sun, 13 Jun 2010 15:34:29 EDT
Date: Sun, 13 Jun 2010 20:01:26 +0100 (BST)
From: Mark Hills <mark@pogo.org.uk>
To: linux-kernel@vger.kernel.org
cc: David Rientjes <rientjes@google.com>, Michal Marek <mmarek@suse.cz>
Subject: Appending '+' to version, since 2.6.35-rc2
Message-ID: <alpine.NEB.2.01.1006131729430.2991@jrf.vwaro.pbz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mark@pogo.org.uk
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 85a256d adds a new feature:

  [...] When CONFIG_LOCALVERSION_AUTO is not enabled, a `+' is appended
  to the kernel version to represent that the kernel has been revised
  since the last release unless "make LOCALVERSION=" was used to uniquely
  identify the build.

I'm finding this inconvenient for 'casual' kernel development.

For example, my usual workflow goes something like:

1) find something I suspect is a bug
2) upgrade to the latest stable or -rc kernel, to confirm
3) experiment with patch to fix it

Since 2.6.35-rc2, going from step 2 to 3 causes the version of the kernel 
to change: forcing time-consuming rebuilds, installing modules, and manual 
changes associated with a new version number; eg. updating the lilo/grub 
config, or the distribution's initrd.

Whilst I can understand the motivation for the '+' being mandatory, the 
added stages above unnecessarily raise the bar for casual developers, or 
other people who need to 'dip' into the kernel and test patches. These 
people are least likely to be aware of using LOCALVERSION to override it 
too.

May I suggest that this particular part of the commit be reverted (example 
below)? In favour of a user, if they wish, explicitly setting LOCALVERSION 
or using CONFIG_LOCALVERSION_AUTO.

-- 
Mark


From: Mark Hills <mark@pogo.org.uk>
Date: Sun, 13 Jun 2010 19:16:55 +0100
Subject: [PATCH] kbuild: Do not append mandatory '+' to kernel release


Signed-off-by: Mark Hills <mark@pogo.org.uk>
---
 Makefile |   14 --------------
 1 files changed, 0 insertions(+), 14 deletions(-)

diff --git a/Makefile b/Makefile
index d49d96c..6870f6f 100644
--- a/Makefile
+++ b/Makefile
@@ -909,14 +909,6 @@ $(vmlinux-dirs): prepare scripts
 #	    $(scm-identifier)		(unique SCM tag, if one exists)
 #	      ./scripts/setlocalversion	(only with CONFIG_LOCALVERSION_AUTO)
 #	      .scmversion		(only with CONFIG_LOCALVERSION_AUTO)
-#	    +				(only without CONFIG_LOCALVERSION_AUTO
-#					 and without LOCALVERSION= and
-#					 repository is at non-tagged commit)
-#
-# For kernels without CONFIG_LOCALVERSION_AUTO compiled from an SCM that has
-# been revised beyond a tagged commit, `+' is appended to the version string
-# when not overridden by using "make LOCALVERSION=".  This indicates that the
-# kernel is not a vanilla release version and has been modified.
 
 pattern = ".*/localversion[^~]*"
 string  = $(shell cat /dev/null \
@@ -942,12 +934,6 @@ endif
 
 ifdef CONFIG_LOCALVERSION_AUTO
 	localver-extra = $(scm-identifier)
-else
-	ifneq ($(scm-identifier),)
-		ifeq ($(LOCALVERSION),)
-			localver-extra = +
-		endif
-	endif
 endif
 
 localver-full = $(localver)$(LOCALVERSION)$(localver-extra)
-- 
1.7.1
