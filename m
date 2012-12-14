Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756066Ab2LNLCh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 06:02:37 -0500
Received: from mail-lb0-f174.google.com ([209.85.217.174]:38531 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755793Ab2LNLCf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 06:02:35 -0500
Subject: [PATCH 01/12] tools/testing/modules: introduce test which
 loads/unloads random modules
To: linux-kernel@vger.kernel.org
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-modules@vger.kernel.org, Jon Masters <jcm@redhat.com>
Date: Fri, 14 Dec 2012 15:02:29 +0400
Message-ID: <20121214110229.11019.63713.stgit@zurg>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This test tries to expose bugs and races in modules' init/exit code blocks.

Loading and unloading random modules shouldn't lead to the kernel crash.
Kernel cannot load all modules at once due to limitations in per-cpu allocator.
By default this script runs 4 iterations of two-phased test: on first phase it
loads/unloads all modules one by one in random order. On the second phase it
loads modules until it got 10 fail in a row, after that it unloads all modules
and goes on. Script excludes from test all modules which are already loaded.

usage sample:

 make -C tools/testing/modules/ test_all test_normal test_staging

script modprobe-remove-test.sh takes configuration from the environment:

#  environment var      example         default
#
#  MODULES              "foo bar"       all, except loaded and excluded
#  INCLUDE_MODULES      "foo bar"       ""
#  EXCLUDE_MODULES      "foo bar"       ""
#  INCLUDE_DIRS         "net/ sound/"   ""
#  EXCLUDE_DIRS         "drivers/ foo/" ""
#  ITERATIONS           "0"             "4"
#  MAX_FAILS            "0"             "10"
#  MODULES_ROOT         "/foo"          ""
#  MODULES_DIR          "/foo/bar"      "$MODULES_ROOT/lib/modules/`uname -r`/kernel"
#  MODPROBE_ARGS        ""              "--verbose --ignore-remove --ignore-install"
#
#  overriding priority: MODULES > EXCLUDE_* = LOADED > INCLUDE_*

Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jon Masters <jcm@redhat.com>
Cc: linux-modules@vger.kernel.org
---
 tools/testing/modules/Makefile                |    8 +
 tools/testing/modules/modprobe-remove-test.sh |  167 +++++++++++++++++++++++++
 2 files changed, 175 insertions(+)
 create mode 100644 tools/testing/modules/Makefile
 create mode 100755 tools/testing/modules/modprobe-remove-test.sh

diff --git a/tools/testing/modules/Makefile b/tools/testing/modules/Makefile
new file mode 100644
index 0000000..7adc4b5
--- /dev/null
+++ b/tools/testing/modules/Makefile
@@ -0,0 +1,8 @@
+test_all:
+	./modprobe-remove-test.sh
+
+test_normal:
+	EXCLUDE_DIRS="drivers/staging/" ./modprobe-remove-test.sh
+
+test_staging:
+	INCLUDE_DIRS="drivers/staging/" ./modprobe-remove-test.sh
diff --git a/tools/testing/modules/modprobe-remove-test.sh b/tools/testing/modules/modprobe-remove-test.sh
new file mode 100755
index 0000000..1d30f64
--- /dev/null
+++ b/tools/testing/modules/modprobe-remove-test.sh
@@ -0,0 +1,167 @@
+#!/bin/bash
+#
+#  modprobe-remove-test.sh - load/unload modules in random order
+#
+#   - first phase  : load/unload all possible modules one by one
+#   - second phase : load multiple modules, remove all after $MAX_FAILS in a row
+#
+#  environment var	example		default
+#
+#  MODULES		"foo bar"	all, except loaded and excluded
+#  INCLUDE_MODULES	"foo bar"	""
+#  EXCLUDE_MODULES	"foo bar"	""
+#  INCLUDE_DIRS		"net/ sound/"	""
+#  EXCLUDE_DIRS		"drivers/ foo/"	""
+#  ITERATIONS		"0"		"4"
+#  MAX_FAILS		"100"		"10"
+#  MODULES_ROOT		"/foo"		""
+#  MODULES_DIR		"/foo/bar"	"$MODULES_ROOT/lib/modules/`uname -r`/kernel"
+#  MODPROBE_ARGS	""		"--verbose --ignore-remove --ignore-install"
+#
+#  overriding priority: MODULES > EXCLUDE_* = LOADED > INCLUDE_*
+#
+
+: ${MAX_FAILS=10}
+: ${ITERATIONS=4}
+
+: ${MODULES_ROOT=}
+: ${MODULES_DIR=$MODULES_ROOT/lib/modules/`uname -r`/kernel}
+
+: ${MODPROBE_ARGS=--verbose --ignore-remove --ignore-install}
+[ -n "$MODULES_ROOT" ] && MODULES_ARGS="--dirname=$MODULES_ROOT $MODULES_ARGS"
+
+set -o pipefail
+
+line_modules() {
+	for M in $@ ; do echo $M ; done
+}
+
+subtract_modules() {
+	comm -2 -3 <(echo "$1" | sort -u) <(echo "$2" | sort -u)
+}
+
+loaded_modules() {
+	lsmod | awk 'FNR != 1 { print $1 }' | sort -u
+}
+
+list_modules() {
+	(
+		cd "$MODULES_DIR" &&
+		find $@ -type f -name '*.ko' -printf '%f\n' |
+		sed 's/.ko$//;s/-/_/g'
+	)
+}
+
+load_module() {
+	modprobe ${MODPROBE_ARGS} "$1"
+}
+
+unload_module() {
+	modprobe ${MODPROBE_ARGS} --remove "$1"
+}
+
+topological_sort() {
+	local M
+	for M in $@ ; do
+		echo `modprobe ${MODPROBE_ARGS} --show-depends $M | wc -l` $M
+	done | sort -n -r | cut -d ' ' -f 2
+}
+
+unload_all_modules() {
+	local M
+
+	# try to unload in random order
+	LOADED_MODULES=`loaded_modules`
+	UNLOAD_MODULES=`subtract_modules "$LOADED_MODULES" "$EXCLUDE_MODULES"`
+	UNLOAD_MODULES=`echo "$UNLOAD_MODULES" | sort -R`
+	for M in $UNLOAD_MODULES ; do
+		unload_module $M
+	done
+
+	# unload the rest in topological order
+	LOADED_MODULES=`loaded_modules`
+	UNLOAD_MODULES=`subtract_modules "$LOADED_MODULES" "$EXCLUDE_MODULES"`
+	UNLOAD_MODULES=`topological_sort $UNLOAD_MODULES`
+	for M in $UNLOAD_MODULES ; do
+		unload_module $M
+	done
+}
+
+do_exit() {
+	unload_all_modules
+	echo "--- interrupted "
+	exit 2
+}
+
+trap do_exit INT TERM
+
+INITIAL_MODULES=`loaded_modules` || exit
+
+if [ -n "$EXCLUDE_DIRS" ] ; then
+	EXCLUDE_MODULES="$EXCLUDE_MODULES `list_modules $EXCLUDE_DIRS`" || exit
+fi
+
+EXCLUDE_MODULES=`line_modules $EXCLUDE_MODULES $INITIAL_MODULES`
+
+MODULES=`line_modules $MODULES`
+EXCLUDE_MODULES=`subtract_modules "$EXCLUDE_MODULES" "$MODULES"`
+
+if [ -n "$INCLUDE_DIRS" ] ; then
+	MODULES="$MODULES `list_modules $INCLUDE_DIRS`" || exit
+fi
+
+MODULES=`line_modules $MODULES $INCLUDE_MODULES`
+
+if [ -z "$MODULES" ] ; then
+	MODULES=`list_modules "."` || exit
+fi
+
+POSSIBLE_MODULES="$MODULES"
+
+MODULES=`subtract_modules "$MODULES" "$EXCLUDE_MODULES"`
+
+EXCLUDED_MODULES=`subtract_modules "$POSSIBLE_MODULES" "$MODULES"`
+
+echo "--- loaded modules:" $INITIAL_MODULES
+
+echo "--- modules under test:" $MODULES
+
+echo "--- excluded modules:" $EXCLUDED_MODULES
+
+for (( I=1 ; I <= $ITERATIONS ; I++ )) ; do
+	echo "--- iteration $I in $ITERATIONS"
+
+	echo "--- load/unload modules one by one"
+	for M in `echo "$MODULES" | sort -R` ; do
+		load_module "$M"
+		unload_module "$M"
+		unload_all_modules
+	done
+
+	echo "--- load multiple modules at once"
+	FAILS=0
+	for M in `echo "$MODULES" | sort -R` ; do
+		if load_module "$M" ; then
+			FAILS=0
+			continue
+		fi
+		if ((++FAILS >= MAX_FAILS)) ; then
+			echo "--- $FAILS fails in a row: unload all modules"
+			unload_all_modules
+			FAILS=0
+		fi
+	done
+	unload_all_modules
+	unload_all_modules
+done
+
+LOADED_MODULES=`loaded_modules`
+STUCK_MODULES=`subtract_modules "$LOADED_MODULES" "$INITIAL_MODULES"`
+MISSING_MODULES=`subtract_modules "$INITIAL_MODULES" "$LOADED_MODULES"`
+
+echo "--- stuck modules:" $STUCK_MODULES
+
+echo "--- missing modules:" $MISSING_MODULES
+
+echo "--- done"
+exit 0

