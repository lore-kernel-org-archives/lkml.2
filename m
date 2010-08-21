Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752075Ab0HUNIE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Aug 2010 09:08:04 -0400
Received: from mga02.intel.com ([134.134.136.20]:18511 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751459Ab0HUNIC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Aug 2010 09:08:02 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.56,245,1280732400"; 
   d="scan'208";a="547414548"
Date: Sat, 21 Aug 2010 21:07:49 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Tiago Maluta <tiago.maluta@gmail.com>, Michal Marek <mmarek@suse.cz>,
        LKML <linux-kernel@vger.kernel.org>, Sam Ravnborg <sam@ravnborg.org>
Subject: [PATCH -mm V3] kbuild: fix reading CROSS_COMPILE from .config
Message-ID: <20100821130749.GA22280@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix compile error

        $ ARCH=x86_64 CROSS_COMPILE=x86_64-linux-gnu- make
        ...
        cc1: error: unrecognized command line option "-m64"
        cc1: error: unrecognized command line option "-mno-red-zone"
        cc1: error: unrecognized command line option "-mcmodel=kernel"
        cc1: error: unrecognized command line option "-maccumulate-outgoing-args"

The error was introduced by patch
kbuild-fix-config_cross_compile-issue-in-config.patch:

  -CROSS_COMPILE  ?= $(CONFIG_CROSS_COMPILE:"%"=%)
  +CROSS_COMPILE  := $(shell grep CONFIG_CROSS_COMPILE .config | cut -d'"' -f2)

That patch does two things:
1) It grep for CONFIG_CROSS_COMPILE because we may not have incldued .config
2) It no longer pick up CROSS_COMPILE from the environment.

Traditionally we have picked up ARCH and CROSS_COMPILE from the environment,
hence the use of "?=".
"?=" says - perform this assignment unless lhs is already defined.
And lhs may be already defined is we have the symbol defined in the
environment.

I think the original submitter changed from ?= to := without realizing this.
So the patch should be adjusted to use ?= again before it is applied.

Cc: Tiago Maluta <tiago.maluta@gmail.com>
Cc: Michal Marek <mmarek@suse.cz>
Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---

Andrew: it's an -mm tree only bug for now
Sam: I copied so many of your nice comments to the changelog, so that I added
your Signed-off-by :)

diff --git a/Makefile b/Makefile
index d646d69..af8864e 100644
--- a/Makefile
+++ b/Makefile
@@ -190,7 +190,7 @@ SUBARCH := $(shell uname -m | sed -e s/i.86/i386/ -e s/sun4u/sparc64/ \
 export KBUILD_BUILDHOST := $(SUBARCH)
 ARCH		?= $(SUBARCH)
 CROSS_COMPILE	?=
-CROSS_COMPILE	:= $(shell grep CONFIG_CROSS_COMPILE .config | cut -d'"' -f2)
+CROSS_COMPILE	?= $(shell grep CONFIG_CROSS_COMPILE .config | cut -d'"' -f2)
 
 # Architecture as present in compile.h
 UTS_MACHINE 	:= $(ARCH)
