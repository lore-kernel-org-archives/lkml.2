Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755621Ab0IXM2u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 08:28:50 -0400
Received: from cantor.suse.de ([195.135.220.2]:41536 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752714Ab0IXM2e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 08:28:34 -0400
From: Thomas Renninger <trenn@suse.de>
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, bjorn.helgaas@hp.com, jbaron@redhat.com,
        Thomas Renninger <trenn@suse.de>
Subject: [PATCH 2/4] PNP: Compile all pnp built-in stuff in one module namespace
Date: Fri, 24 Sep 2010 14:28:29 +0200
Message-Id: <1285331311-21753-3-git-send-email-trenn@suse.de>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <20100920184441.GA2915@redhat.com>
References: <20100920184441.GA2915@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

before, dynamic debug info (/sys/kernel/debug/dynamic_debug/control) showed
the file name as module name of each dynamic debug message (in square brackets):
drivers/pnp/core.c:198 [core]pnp_add_device p "%s device, IDs%s (%s)\012"
drivers/pnp/resource.c:619 [resource]pnp_add_bus_resource p "  add %pr\012"
..
drivers/pnp/pnpacpi/core.c:89 [core]pnpacpi_set_resources p "set resources\012"
..

With this patch the module name will be pnp for all "drivers/pnp/* -r" code:
drivers/pnp/core.c:198 [pnp]pnp_add_device p "%s device, IDs%s (%s)\012"
drivers/pnp/resource.c:619 [pnp]pnp_add_bus_resource p "  add %pr\012"
..
drivers/pnp/pnpacpi/core.c:112 [pnp]pnpacpi_disable_resources p "disable resources\012"

This has advantages:
  - Any pnp code can make use of the moduleparam.h interface, the modules
    will show up as pnp.param.
  - Passing pnp.ddebug as kernel boot param will enable all pnp debug messages
    with my previous patch and CONFIG_DYNAMIC_DEBUG enabled.


Signed-off-by: Thomas Renninger <trenn@suse.de>
CC: Bjorn Helgaas <bjorn.helgaas@hp.com>
CC: Jason Baron <jbaron@redhat.com>
CC: Greg KH <gregkh@suse.de>
CC: lkml <linux-kernel@vger.kernel.org>
---
 drivers/pnp/Makefile         |    6 ++++--
 drivers/pnp/isapnp/Makefile  |    6 +++---
 drivers/pnp/pnpacpi/Makefile |    3 ++-
 drivers/pnp/pnpbios/Makefile |    5 +++--
 4 files changed, 12 insertions(+), 8 deletions(-)

diff --git a/drivers/pnp/Makefile b/drivers/pnp/Makefile
index 8de3775..bfba893 100644
--- a/drivers/pnp/Makefile
+++ b/drivers/pnp/Makefile
@@ -2,11 +2,13 @@
 # Makefile for the Linux Plug-and-Play Support.
 #
 
-obj-y		:= core.o card.o driver.o resource.o manager.o support.o interface.o quirks.o
+obj-y		:= pnp.o
+
+pnp-y		:= core.o card.o driver.o resource.o manager.o support.o interface.o quirks.o
 
 obj-$(CONFIG_PNPACPI)		+= pnpacpi/
 obj-$(CONFIG_PNPBIOS)		+= pnpbios/
 obj-$(CONFIG_ISAPNP)		+= isapnp/
 
 # pnp_system_init goes after pnpacpi/pnpbios init
-obj-y				+= system.o
+pnp-y				+= system.o
diff --git a/drivers/pnp/isapnp/Makefile b/drivers/pnp/isapnp/Makefile
index cac18bb..6e607aa 100644
--- a/drivers/pnp/isapnp/Makefile
+++ b/drivers/pnp/isapnp/Makefile
@@ -1,7 +1,7 @@
 #
 # Makefile for the kernel ISAPNP driver.
 #
+obj-y			+= pnp.o
+pnp-y			:= core.o compat.o
 
-isapnp-proc-$(CONFIG_PROC_FS) = proc.o
-
-obj-y := core.o compat.o $(isapnp-proc-y)
+pnp-$(CONFIG_PROC_FS)	+= proc.o
diff --git a/drivers/pnp/pnpacpi/Makefile b/drivers/pnp/pnpacpi/Makefile
index 905326f..40c93da 100644
--- a/drivers/pnp/pnpacpi/Makefile
+++ b/drivers/pnp/pnpacpi/Makefile
@@ -1,5 +1,6 @@
 #
 # Makefile for the kernel PNPACPI driver.
 #
+obj-y += pnp.o
 
-obj-y := core.o rsparser.o
+pnp-y := core.o rsparser.o
diff --git a/drivers/pnp/pnpbios/Makefile b/drivers/pnp/pnpbios/Makefile
index 3cd3ed7..240b0ff 100644
--- a/drivers/pnp/pnpbios/Makefile
+++ b/drivers/pnp/pnpbios/Makefile
@@ -1,7 +1,8 @@
 #
 # Makefile for the kernel PNPBIOS driver.
 #
+obj-y := pnp.o
 
-pnpbios-proc-$(CONFIG_PNPBIOS_PROC_FS) = proc.o
+pnp-y := core.o bioscalls.o rsparser.o
 
-obj-y := core.o bioscalls.o rsparser.o $(pnpbios-proc-y)
+pnp-$(CONFIG_PNPBIOS_PROC_FS) += proc.o
-- 
1.6.4.2

