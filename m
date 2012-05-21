Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757242Ab2EUCtk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2012 22:49:40 -0400
Received: from oproxy6-pub.bluehost.com ([67.222.54.6]:44721 "HELO
	oproxy6-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757131Ab2EUCta (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2012 22:49:30 -0400
Message-ID: <4FB9AD3F.8030904@xenotime.net>
Date: Sun, 20 May 2012 19:49:35 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
CC: linux-kbuild@vger.kernel.org, Michal Marek <mmarek@suse.cz>
Subject: [PATCH 2/3] scripts/patch-kernel: drop -ac support
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <rdunlap@xenotime.net>

Drop -ac option since -ac patches don't exist for 3.x.

Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
---
 scripts/patch-kernel |   60 ++---------------------------------------
 1 file changed, 3 insertions(+), 57 deletions(-)

--- lnx-34-rc7-pk.orig/scripts/patch-kernel
+++ lnx-34-rc7-pk/scripts/patch-kernel
@@ -1,22 +1,14 @@
 #! /bin/sh
 # Script to apply kernel patches.
-#   usage: patch-kernel [ sourcedir [ patchdir [ stopversion ] [ -acxx ] ] ]
+#   usage: patch-kernel [ sourcedir [ patchdir [ stopversion ] ] ]
 #     The source directory defaults to /usr/src/linux, and the patch
 #     directory defaults to the current directory.
 # e.g.
 #   scripts/patch-kernel . ..
 #      Update the kernel tree in the current directory using patches in the
 #      directory above to the latest Linus kernel
-#   scripts/patch-kernel . .. -ac
-#      Get the latest Linux kernel and patch it with the latest ac patch
 #   scripts/patch-kernel . .. 2.4.9
 #      Gets standard kernel 2.4.9
-#   scripts/patch-kernel . .. 2.4.9 -ac
-#      Gets 2.4.9 with latest ac patches
-#   scripts/patch-kernel . .. 2.4.9 -ac11
-#      Gets 2.4.9 with ac patch ac11
-#   Note: It uses the patches relative to the Linus kernels, not the
-#   ac to ac relative patches
 #
 # It determines the current kernel version from the top-level Makefile.
 # It then looks for patches for the next sublevel in the patch directory.
@@ -38,9 +30,6 @@
 # Fixed previous patch so that if we are already at the correct version
 # not to patch up.
 #
-# Added -ac option, use -ac or -ac9 (say) to stop at a particular version
-#       Dave Gilbert <linux@treblig.org>, 29th September 2001.
-#
 # Add support for (use of) EXTRAVERSION (to support 2.6.8.x, e.g.);
 # update usage message;
 # fix some whitespace damage;
@@ -67,7 +56,7 @@ stopvers=${3-default}
 
 if [ "$1" = -h -o "$1" = --help -o ! -r "$sourcedir/Makefile" ]; then
 cat << USAGE
-usage: $PNAME [-h] [ sourcedir [ patchdir [ stopversion ] [ -acxx ] ] ]
+usage: $PNAME [-h] [ sourcedir [ patchdir [ stopversion ] ] ]
   source directory defaults to /usr/src/linux,
   patch directory defaults to the current directory,
   stopversion defaults to <all in patchdir>.
@@ -75,16 +64,6 @@ USAGE
 exit 1
 fi
 
-# See if we have any -ac options
-for PARM in $*
-do
-  case $PARM in
-	  -ac*)
-		  gotac=$PARM;
-
-	esac;
-done
-
 # ---------------------------------------------------------------------------
 # arg1 is filename
 noFile () {
@@ -141,7 +120,7 @@ findFile () {
 
 # ---------------------------------------------------------------------------
 # Apply a patch and check it goes in cleanly
-# First param is patch name (e.g. patch-2.4.9-ac5) - without path or extension
+# First param is patch name (e.g. patch-3.1-rc1) - without path or extension
 
 applyPatch () {
   echo -n "Applying $1 (${name})... "
@@ -296,36 +275,3 @@ do
 	break
 done
 fi
-
-if [ x$gotac != x ]; then
-  # Out great user wants the -ac patches
-	# They could have done -ac (get latest) or -acxx where xx=version they want
-	if [ $gotac = "-ac" ]; then
-	  # They want the latest version
-		HIGHESTPATCH=0
-		for PATCHNAMES in $patchdir/patch-${CURRENTFULLVERSION}-ac*\.*
-		do
-			ACVALUE=`echo $PATCHNAMES | sed -e 's/^.*patch-[0-9.]*-ac\([0-9]*\).*/\1/'`
-			# Check it is actually a recognised patch type
-			findFile $patchdir/patch-${CURRENTFULLVERSION}-ac${ACVALUE} || break
-
-		  if [ $ACVALUE -gt $HIGHESTPATCH ]; then
-			  HIGHESTPATCH=$ACVALUE
-		  fi
-		done
-
-		if [ $HIGHESTPATCH -ne 0 ]; then
-			findFile $patchdir/patch-${CURRENTFULLVERSION}-ac${HIGHESTPATCH} || break
-			applyPatch patch-${CURRENTFULLVERSION}-ac${HIGHESTPATCH}
-		else
-		  echo "No -ac patches found"
-		fi
-	else
-	  # They want an exact version
-		findFile $patchdir/patch-${CURRENTFULLVERSION}${gotac} || {
-		  echo "Sorry, I couldn't find the $gotac patch for $CURRENTFULLVERSION.  Hohum."
-			exit 1
-		}
-		applyPatch patch-${CURRENTFULLVERSION}${gotac}
-	fi
-fi
