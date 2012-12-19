Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751354Ab2LSFlh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 00:41:37 -0500
Received: from mga11.intel.com ([192.55.52.93]:50645 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750881Ab2LSFl1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 00:41:27 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,313,1355126400"; 
   d="scan'208";a="266787350"
From: Lv Zheng <lv.zheng@intel.com>
To: Len Brown <len.brown@intel.com>,
        Rafael J Wysocki <rafael.j.wysocki@intel.com>
Cc: <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org,
        Lv Zheng <lv.zheng@intel.com>
Subject: [RFC PATCH] Scripts: Add binary diff utility.
Date: Wed, 19 Dec 2012 13:41:19 +0800
Message-Id: <2d59b5e20811d4e70cda7f73ddf304b7bd83dc57.1355476687.git.lv.zheng@intel.com>
X-Mailer: git-send-email 1.7.10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This utility is used as part of Linux ACPICA release process. It may be a
good idea to add it to kernel scripts, since it may be generally usefull for
verifying small kernel changes, like coding style cleanups etc.

Signed-off-by: Lv Zheng <lv.zheng@intel.com>
---
 scripts/diffvmlinux.sh |  227 ++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 227 insertions(+)
 create mode 100755 scripts/diffvmlinux.sh

Index: linux-pm/scripts/diffvmlinux.sh
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-pm/scripts/diffvmlinux.sh	2012-12-19 13:40:21.000000000 +0800
@@ -0,0 +1,226 @@
+#!/bin/sh
+#
+# Copyright (c) 2012, Intel Corporation
+# Author: Lv Zheng <lv.zheng@intel.com>
+#
+# This program is free software; you can redistribute it and/or modify it
+# under the terms of the GNU General Public License as published by the
+# Free Software Foundation; version 2 of the License.
+#
+# NAME
+#   diffvmlinux.sh - Generating vmlinux assembly differences before/after
+#                    applying a quilt patch
+# SYNOPSIS
+#   diffvmlinux.sh [-f assembly-diff] [-p patch-file] [-o object-file]
+#                  <linux-dir>
+
+
+# FIXME: More Useless Sections
+#
+# Please add other sections that would appear as executable but should get
+# removed for the comparision.
+USELESS_SECTIONS=".notes"
+
+fulldir() {
+	lpath=$1
+	(
+		cd $lpath; pwd
+	)
+}
+
+getdir() {
+	lpath=`dirname $1`
+	fulldir $lpath
+}
+
+fatal() {
+	echo $1
+	exit -1
+}
+
+usage() {
+	echo "Usage: `basename $0` [-p patch] <linux>"
+	echo "Where:"
+	echo " linux: Specify the linux source tree."
+	echo " patch: Specify the patch file name."
+}
+
+fatal_usage() {
+	usage
+	exit -1
+}
+
+quilt_applied() {
+	c=$1
+	applied_patches=`quilt applied 2>/dev/null`
+
+	for a in $applied_patches; do
+		if [ "x$a" = "x$c" ]; then
+			return 0
+		fi
+	done
+	return -1
+}
+
+remove_sections() {
+	binary2=$1
+	binary3=$2
+
+	for section in $USELESS_SECTIONS; do
+		echo "Removing $section section..."
+		objcopy -R $section $binary2 $binary3
+		mv $binary3 $binary2
+	done
+}
+
+quilt_push() {
+	quilt push > /dev/null || fatal "failed to push quilt stack"
+}
+
+quilt_pop() {
+	quilt pop > /dev/null || fatal "failed to pop quilt stack"
+}
+
+detect_patch() {
+	quilt_push
+	detected_patches=`quilt applied 2>/dev/null`
+	quilt_pop
+	for d in $detected_patches; do
+		quilt_applied $d || echo $d
+	done
+}
+
+quilt_forward() {
+	l=$1
+	patches=`quilt unapplied 2>/dev/null`
+	for i in $patches; do
+		quilt_push
+		quilt_applied $l
+		if [ $? -eq 0 ]; then
+			quilt_pop
+			return 0;
+		fi
+	done
+	fatal "Cannot find $locate in the unapplied patches."
+}
+
+quilt_backward() {
+	l=$1
+	patches=`quilt applied 2>/dev/null`
+	for i in $patches; do
+		quilt_pop
+		quilt_applied $l || return 0
+	done
+	fatal "Cannot find $locate in the applied patches."
+}
+
+locate_patch() {
+	t=$1
+	quilt_applied $t
+	if [ $? -eq 0 ]; then
+		echo "Locating $t in the applied patches..."
+		quilt_backward $t
+	else
+		echo "Locating $t in the unapplied patches..."
+		quilt_forward $t
+	fi
+}
+
+while getopts "f:p:o:" opt
+do
+	case $opt in
+	f) ASMDIFF=$OPTARG;;
+	o) BINARY=$OPTARG;;
+	p) PATCH=$OPTARG;;
+	?) echo "Invalid argument $opt"
+	   fatal_usage;;
+	esac
+done
+shift $(($OPTIND - 1))
+
+if [ "x$1" = "x" ]; then
+	echo "Missing <linux> paraemter."
+	fatal_usage
+fi
+
+CURDIR=`pwd`
+LINUX=`getdir $1`
+LINUX_BASE=`basename $LINUX`/vmlinux
+AFTER=$CURDIR/after.dump
+BEFORE=$CURDIR/before.dump
+
+if [ "x$BINARY" = "x" ]; then
+	BINARY=vmlinux
+fi
+echo "Diffing $BINARY..."
+BINARY0=$LINUX/$BINARY
+BINARY1=$LINUX/diffvmlinux
+BINARY2=$LINUX/diffvmlinux-nosections
+BINARY3=$LINUX/diffvmlinux-nosection
+
+# Prepare quilt stack
+if [ "x$PATCH" != "x" ]; then
+	echo "Locating patch $PATCH..."
+	locate_patch $PATCH
+else
+	PATCH=`detect_patch`
+	echo "Detected patch $PATCH."
+fi
+if [ "x$PATCH" = "x" ]; then
+	echo "Missing patch file"
+	fatal_usage
+fi
+
+# Allow overloading of ASMDIFF
+if [ "x$ASMDIFF" = "x" ]; then
+	ASMDIFF=$CURDIR/bin.diff
+fi
+
+(
+	cd $LINUX
+
+	# Assertion in case the above locating/detecting failed.
+	quilt_applied $PATCH && fatal "patch $PATCH should not be applied"
+	quilt_push
+	quilt_applied $PATCH || fatal "patch $PATCH should be the next patch"
+	quilt_pop
+
+	echo "Building $BINARY before applying $PATCH..."
+	rm -f $BINARY
+	make > /dev/null || fatal "failed to build $LINUX"
+	echo "Disassembling $BINARY before applying $PATCH..."
+	cp -f $BINARY0 $BINARY1
+	cp -f $BINARY1 $BINARY2 && remove_sections $BINARY2 $BINARY3
+	objdump -d $BINARY2 > $BEFORE
+
+	echo "Pushing $PATCH to $LINUX_BASE..."
+	quilt_push
+
+	echo "Building $BINARY after applying $PATCH..."
+	rm -f $BINARY
+	make > /dev/null || fatal "failed to build $LINUX"
+	echo "Disassembling $BINARY after applying $PATCH..."
+	cp -f $BINARY0 $BINARY1
+	cp -f $BINARY1 $BINARY2 && remove_sections $BINARY2 $BINARY3
+	objdump -d $BINARY2 > $AFTER
+
+	echo "Popping $PATCH from $LINUX_BASE..."
+	quilt_pop
+)
+
+# XXX: Fatal Error for the Sub-shell
+#
+# We'll reach here even in the case of fatal due to the sub-shell.
+# Thus we do cleanup here and the relative path of ASMDIFF is correct.
+
+if [ -f $BEFORE ] && [ -f $AFTER ]; then
+	echo "Generating assembly differences..."
+	diff -u $BEFORE $AFTER > $ASMDIFF
+	echo "$ASMDIFF is ready."
+fi
+
+rm -f $BINARY1
+rm -f $BINARY2
+rm -f $BINARY3
+rm -f $BEFORE
+rm -f $AFTER
