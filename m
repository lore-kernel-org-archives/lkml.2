Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754253Ab0GNNoB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 09:44:01 -0400
Received: from one.firstfloor.org ([213.235.205.2]:34182 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752957Ab0GNNn7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 09:43:59 -0400
Date: Wed, 14 Jul 2010 15:43:52 +0200
From: Andi Kleen <andi@firstfloor.org>
To: mmarek@suse.cz, linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        ak@linux.intel.com
Subject: [PATCH] Kbuild: Add option to set -femit-struct-debug-baseonly 
Message-ID: <20100714134352.GA10341@basil.fritz.box>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kbuild: Add option to set -femit-struct-debug-baseonly 

Newer gcc has a -femit-struct-debug-baseonly option that dramatically
reduces the size of object files with debug info. What it does
is to only emit type information for structures when the structures
are defined in the same file or in a header file.

This means the type information for most headers are not included.
This is not good when the type information is actually
needed (e.g. with kgdb or systemtap) 

But often kernel hackers only care about line numbers and don't
need all the type information anyways. In this case setting
the option can be a big win:

A build dir for a specific x86-64 configuration with gcc 4.5
shrunk from 2.3G to 1.2G. The compilation was also nearly a minute
faster.

Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 Makefile          |    4 ++++
 lib/Kconfig.debug |   12 ++++++++++++
 2 files changed, 16 insertions(+)

Index: linux-2.6.34-ak/Makefile
===================================================================
--- linux-2.6.34-ak.orig/Makefile
+++ linux-2.6.34-ak/Makefile
@@ -554,6 +554,10 @@ KBUILD_CFLAGS	+= -g
 KBUILD_AFLAGS	+= -gdwarf-2
 endif
 
+ifdef CONFIG_DEBUG_INFO_REDUCED
+KBUILD_CFLAGS 	+= $(call cc-option, -femit-struct-debug-baseonly)
+endif
+
 ifdef CONFIG_FUNCTION_TRACER
 KBUILD_CFLAGS	+= -pg
 endif
Index: linux-2.6.34-ak/lib/Kconfig.debug
===================================================================
--- linux-2.6.34-ak.orig/lib/Kconfig.debug
+++ linux-2.6.34-ak/lib/Kconfig.debug
@@ -616,6 +616,18 @@ config DEBUG_INFO
 
 	  If unsure, say N.
 
+config DEBUG_INFO_REDUCED
+	bool "Reduce debugging information"
+	depends on DEBUG_INFO
+	help
+	  If you say Y here gcc is instructed to generate less debugging information
+          for structure types. This means that tools that need full debugging information
+          (like kgdb or systemtap) won't be happy. But if you merely need debugging
+          information to resolve line numbers there is no loss.
+          Advantage is that build directory object sizes shrink dramatically over
+          a full DEBUG_INFO build and compile times are reduced too.
+          Only works with newer gcc versions.
+
 config DEBUG_VM
 	bool "Debug VM"
 	depends on DEBUG_KERNEL
