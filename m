Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751661Ab0HOUOz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Aug 2010 16:14:55 -0400
Received: from king.tilera.com ([72.1.168.226]:38578 "EHLO king.tilera.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751392Ab0HOUOy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Aug 2010 16:14:54 -0400
Message-Id: <201008152014.o7FKEqxV016485@farm-0002.internal.tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Sun, 15 Aug 2010 15:01:45 -0400
Subject: [PATCH] arch/tile: don't validate CROSS_COMPILE needlessly
To: linux-kernel@vger.kernel.org
Cc: Sam Ravnborg <sam@ravnborg.org>
X-OriginalArrivalTime: 15 Aug 2010 20:14:53.0074 (UTC) FILETIME=[8571E720:01CB3CB6]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With this change, the arch/tile Makefile will only check for a valid
combination of CROSS_COMPILE vs "uname -m" for a few common targets
that are typically the ones we get wrong (vmlinux, all, and modules).
The change handles the case of an empty "make" goal like "make all".

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
Reviewed-by: Sam Ravnborg <sam@ravnborg.org>
---
 arch/tile/Makefile |   20 +++++++++++---------
 1 files changed, 11 insertions(+), 9 deletions(-)

diff --git a/arch/tile/Makefile b/arch/tile/Makefile
index 07c4318..fd8f6bb 100644
--- a/arch/tile/Makefile
+++ b/arch/tile/Makefile
@@ -8,20 +8,22 @@
 # for "archclean" and "archdep" for cleaning up and making dependencies for
 # this architecture
 
-ifeq ($(CROSS_COMPILE),)
 # If building with TILERA_ROOT set (i.e. using the Tilera Multicore
 # Development Environment) we can set CROSS_COMPILE based on that.
-ifdef TILERA_ROOT
-CROSS_COMPILE	= $(TILERA_ROOT)/bin/tile-
-endif
-endif
-
 # If we're not cross-compiling, make sure we're on the right architecture.
+# Only bother to test for a few common targets, to avoid useless errors.
 ifeq ($(CROSS_COMPILE),)
-HOST_ARCH = $(shell uname -m)
-ifneq ($(HOST_ARCH),$(ARCH))
+  ifdef TILERA_ROOT
+    CROSS_COMPILE := $(TILERA_ROOT)/bin/tile-
+  else
+    goals := $(if $(MAKECMDGOALS), $(MAKECMDGOALS), all)
+    ifneq ($(strip $(filter vmlinux modules all,$(goals))),)
+      HOST_ARCH := $(shell uname -m)
+      ifneq ($(HOST_ARCH),$(ARCH))
 $(error Set TILERA_ROOT or CROSS_COMPILE when building $(ARCH) on $(HOST_ARCH))
-endif
+      endif
+    endif
+  endif
 endif
 
 
-- 
1.6.5.2

