Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755427Ab2LCQYm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 11:24:42 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:44862 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754933Ab2LCQYj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 11:24:39 -0500
From: Joonsoo Kim <js1304@gmail.com>
To: Michal Marek <mmarek@suse.cz>
Cc: linux-kernel@vger.kernel.org, Joonsoo Kim <js1304@gmail.com>
Subject: [PATCH 2/2] scripts/tags.sh: Support compiled source
Date: Tue,  4 Dec 2012 01:22:04 +0900
Message-Id: <1354551724-15089-2-git-send-email-js1304@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1354551724-15089-1-git-send-email-js1304@gmail.com>
References: <1354551724-15089-1-git-send-email-js1304@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We usually have interst in compiled files only,
because they are strongly related to individual's work.
Current tags.sh can't select compiled files, so support it.

We can use this functionality like below.
"make cscope O=. SRCARCH=xxxx SUBARCH=compiled"

It must be executed after building the kernel.

Signed-off-by: Joonsoo Kim <js1304@gmail.com>

diff --git a/scripts/tags.sh b/scripts/tags.sh
index a400c88..ef9668c 100755
--- a/scripts/tags.sh
+++ b/scripts/tags.sh
@@ -96,6 +96,29 @@ all_sources()
 	find_other_sources '*.[chS]'
 }
 
+all_compiled_sources()
+{
+	for i in $(all_sources); do
+		if [[ $i =~ .*c$ || $i =~ .*S$ ]]; then
+			j=${i/\.[cS]/\.o}
+			if [ -e $j ]; then
+				echo $i
+			fi
+		else
+			echo $i
+		fi
+	done
+}
+
+all_target_sources()
+{
+	if [ "$compiled_target" = "true" ]; then
+		all_compiled_sources
+	else
+		all_sources
+	fi
+}
+
 all_kconfigs()
 {
 	for arch in $ALLSOURCE_ARCHS; do
@@ -111,18 +134,18 @@ all_defconfigs()
 
 docscope()
 {
-	(echo \-k; echo \-q; all_sources) > cscope.files
+	(echo \-k; echo \-q; all_target_sources) > cscope.files
 	cscope -b -f cscope.out
 }
 
 dogtags()
 {
-	all_sources | gtags -i -f -
+	all_target_sources | gtags -i -f -
 }
 
 exuberant()
 {
-	all_sources | xargs $1 -a                               \
+	all_target_sources | xargs $1 -a                        \
 	-I __initdata,__exitdata,__acquires,__releases          \
 	-I __read_mostly,____cacheline_aligned                  \
 	-I ____cacheline_aligned_in_smp                         \
@@ -174,7 +197,7 @@ exuberant()
 
 emacs()
 {
-	all_sources | xargs $1 -a                               \
+	all_target_sources | xargs $1 -a                        \
 	--regex='/^(ENTRY|_GLOBAL)(\([^)]*\)).*/\2/'            \
 	--regex='/^SYSCALL_DEFINE[0-9]?(\([^,)]*\).*/sys_\1/'   \
 	--regex='/^TRACE_EVENT(\([^,)]*\).*/trace_\1/'		\
@@ -221,10 +244,13 @@ xtags()
 	elif $1 --version 2>&1 | grep -iq emacs; then
 		emacs $1
 	else
-		all_sources | xargs $1 -a
+		all_target_sources | xargs $1 -a
         fi
 }
 
+if [ "${SUBARCH}" = "compiled" ]; then
+	compiled_target=true
+fi
 
 # Support um (which uses SUBARCH)
 if [ "${ARCH}" = "um" ]; then
-- 
1.7.9.5

