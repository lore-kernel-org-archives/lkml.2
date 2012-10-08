Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753515Ab2JHGpR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 02:45:17 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:40084 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753099Ab2JHGpL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2012 02:45:11 -0400
From: Irina Tirdea <irina.tirdea@gmail.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: LKML <linux-kernel@vger.kernel.org>, Paul Mackerras <paulus@samba.org>,
        David Ahern <dsahern@gmail.com>, Namhyung Kim <namhyung@kernel.org>,
        Pekka Enberg <penberg@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Irina Tirdea <irina.tirdea@intel.com>
Subject: [PATCH 3/8] Documentation: add documentation on compiling for Android
Date: Mon,  8 Oct 2012 09:43:28 +0300
Message-Id: <1349678613-7045-4-git-send-email-irina.tirdea@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1349678613-7045-1-git-send-email-irina.tirdea@gmail.com>
References: <1349678613-7045-1-git-send-email-irina.tirdea@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Irina Tirdea <irina.tirdea@intel.com>

Add documentation for cross-compiling on Android including:
() instructions on how to set the Android NDK environment
() how to cross-compile perf for Android
() how to install on an Android device/emulator, set the runtime
environment and run it

Signed-off-by: Irina Tirdea <irina.tirdea@intel.com>
---
 tools/perf/Documentation/android.txt |   75 ++++++++++++++++++++++++++++++++++
 1 file changed, 75 insertions(+)
 create mode 100644 tools/perf/Documentation/android.txt

diff --git a/tools/perf/Documentation/android.txt b/tools/perf/Documentation/android.txt
new file mode 100644
index 0000000..a39dbbb
--- /dev/null
+++ b/tools/perf/Documentation/android.txt
@@ -0,0 +1,75 @@
+How to compile perf for Android
+=========================================
+
+I. Set the Android NDK environment
+------------------------------------------------
+
+(a). Use the Android NDK
+------------------------------------------------
+1. You need to download and install the Android Native Development Kit (NDK).
+Set the NDK variable to point to the path where you installed the NDK:
+  export NDK=/path/to/android-ndk
+
+2. Set cross-compiling environment variables for NDK toolchain and sysroot.
+For arm:
+  export NDK_TOOLCHAIN=${NDK}/toolchains/arm-linux-androideabi-4.6/prebuilt/linux-x86/bin/arm-linux-androideabi-
+  export NDK_SYSROOT=${NDK}/platforms/android-9/arch-arm
+For x86:
+  export NDK_TOOLCHAIN=${NDK}/toolchains/x86-4.6/prebuilt/linux-x86/bin/i686-linux-android-
+  export NDK_SYSROOT=${NDK}/platforms/android-9/arch-x86
+
+This method is not working for Android NDK versions up to Revision 8b.
+perf uses some bionic enhancements that are not included in these NDK versions.
+You can use method (b) described below instead.
+
+(b). Use the Android source tree
+-----------------------------------------------
+1. Download the master branch of the Android source tree.
+Set the environment for the target you want using:
+  source build/envsetup.sh
+  lunch
+
+2. Build your own NDK sysroot to contain latest bionic changes and set the
+NDK sysroot environment variable.
+  cd ${ANDROID_BUILD_TOP}/ndk
+For arm:
+  ./build/tools/build-ndk-sysroot.sh --abi=arm
+  export NDK_SYSROOT=${ANDROID_BUILD_TOP}/ndk/build/platforms/android-3/arch-arm
+For x86:
+  ./build/tools/build-ndk-sysroot.sh --abi=x86
+  export NDK_SYSROOT=${ANDROID_BUILD_TOP}/ndk/build/platforms/android-3/arch-x86
+
+3. Set the NDK toolchain environment variable.
+For arm:
+  export NDK_TOOLCHAIN=${ANDROID_TOOLCHAIN}/arm-linux-androideabi-
+For x86:
+  export NDK_TOOLCHAIN=${ANDROID_TOOLCHAIN}/i686-linux-android-
+
+II. Compile perf for Android
+------------------------------------------------
+You need to run make with the NDK toolchain and sysroot defined above:
+  make CROSS_COMPILE=${NDK_TOOLCHAIN} CFLAGS="--sysroot=${NDK_SYSROOT}"
+
+III. Install perf
+-----------------------------------------------
+You need to connect to your Android device/emulator using adb.
+Install perf using:
+  adb push perf /data/perf
+
+If you also want to use perf-archive you need busybox tools for Android.
+For installing perf-archive, you first need to replace #!/bin/bash with #!/system/bin/sh:
+  sed 's/#!\/bin\/bash/#!\/system\/bin\/sh/g' perf-archive >> /tmp/perf-archive
+  chmod +x /tmp/perf-archive
+  adb push /tmp/perf-archive /data/perf-archive
+
+IV. Environment settings for running perf
+------------------------------------------------
+Some perf features need environment variables to run properly.
+You need to set these before running perf on the target:
+  adb shell
+  # PERF_PAGER=cat
+
+IV. Run perf
+------------------------------------------------
+Run perf on your device/emulator to which you previously connected using adb:
+  # ./data/perf
-- 
1.7.9.5

