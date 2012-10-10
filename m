Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756460Ab2JJRxP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 13:53:15 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:20055 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750948Ab2JJRwp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 13:52:45 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, stable@vger.kernel.org,
        Olaf Hering <olaf@aepfle.de>
Subject: [PATCH 1/3] xen/pv-on-hvm kexec: add quirk for Xen 3.4 and shutdown watches.
Date: Wed, 10 Oct 2012 13:40:47 -0400
Message-Id: <1349890849-17471-2-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1349890849-17471-1-git-send-email-konrad.wilk@oracle.com>
References: <1349890849-17471-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The commit 254d1a3f02ebc10ccc6e4903394d8d3f484f715e, titled
"xen/pv-on-hvm kexec: shutdown watches from old kernel" assumes that the
XenBus backend can deal with reading of values from:
 "control/platform-feature-xs_reset_watches":

    ... a patch for xenstored is required so that it
    accepts the XS_RESET_WATCHES request from a client (see changeset
    23839:42a45baf037d in xen-unstable.hg). Without the patch for xenstored
    the registration of watches will fail and some features of a PVonHVM
    guest are not available. The guest is still able to boot, but repeated
    kexec boots will fail."

Sadly this is not true when using a Xen 3.4 hypervisor and booting a PVHVM
guest. We end up hanging at:

  err = xenbus_scanf(XBT_NIL, "control",
                        "platform-feature-xs_reset_watches", "%d", &supported);

This can easily be seen with guests hanging at xenbus_init:

NX (Execute Disable) protection: active
SMBIOS 2.4 present.
DMI: Xen HVM domU, BIOS 3.4.0 05/13/2011
Hypervisor detected: Xen HVM
Xen version 3.4.
Xen Platform PCI: I/O protocol version 1
... snip ..
calling  xenbus_init+0x0/0x27e @ 1

Reverting the commit or using the attached patch fixes the issue. This fix
checks whether the hypervisor is older than 4.0 and if so does not try to
perform the read.

Fixes-Oracle-Bug: 14708233
CC: stable@vger.kernel.org
CC: Olaf Hering <olaf@aepfle.de>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 drivers/xen/xenbus/xenbus_xs.c |   15 +++++++++++++++
 1 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/drivers/xen/xenbus/xenbus_xs.c b/drivers/xen/xenbus/xenbus_xs.c
index bce15cf..91f513b 100644
--- a/drivers/xen/xenbus/xenbus_xs.c
+++ b/drivers/xen/xenbus/xenbus_xs.c
@@ -47,6 +47,7 @@
 #include <xen/xenbus.h>
 #include <xen/xen.h>
 #include "xenbus_comms.h"
+#include <asm/xen/hypervisor.h>
 
 struct xs_stored_msg {
 	struct list_head list;
@@ -617,7 +618,18 @@ static struct xenbus_watch *find_watch(const char *token)
 
 	return NULL;
 }
+static bool xen_strict_xenbus_quirk()
+{
+	uint32_t eax, ebx, ecx, edx, base;
+
+	base = xen_cpuid_base();
+	cpuid(base + 1, &eax, &ebx, &ecx, &edx);
+
+	if ((eax >> 16) < 4)
+		return true;
+	return false;
 
+}
 static void xs_reset_watches(void)
 {
 	int err, supported = 0;
@@ -625,6 +637,9 @@ static void xs_reset_watches(void)
 	if (!xen_hvm_domain())
 		return;
 
+	if (xen_strict_xenbus_quirk())
+		return;
+
 	err = xenbus_scanf(XBT_NIL, "control",
 			"platform-feature-xs_reset_watches", "%d", &supported);
 	if (err != 1 || !supported)
-- 
1.7.7.6

