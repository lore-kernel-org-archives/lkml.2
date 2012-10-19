Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030415Ab2JSDBe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 23:01:34 -0400
Received: from mail.kernel.org ([198.145.19.201]:52196 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964922Ab2JSCs5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 22:48:57 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Olaf Hering <olaf@aepfle.de>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [ 36/76] xen/pv-on-hvm kexec: add quirk for Xen 3.4 and shutdown watches.
Date: Thu, 18 Oct 2012 19:47:00 -0700
Message-Id: <20121019024355.933797236@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc0.18.gf84667d
In-Reply-To: <20121019024350.087156547@linuxfoundation.org>
References: <20121019024350.087156547@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

commit cb6b6df111e46b9d0f79eb971575fd50555f43f4 upstream.

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
Acked-by: Olaf Hering <olaf@aepfle.de>
[v2: Added a comment in the source code]
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/xen/xenbus/xenbus_xs.c |   21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

--- a/drivers/xen/xenbus/xenbus_xs.c
+++ b/drivers/xen/xenbus/xenbus_xs.c
@@ -47,6 +47,7 @@
 #include <xen/xenbus.h>
 #include <xen/xen.h>
 #include "xenbus_comms.h"
+#include <asm/xen/hypervisor.h>
 
 struct xs_stored_msg {
 	struct list_head list;
@@ -617,7 +618,24 @@ static struct xenbus_watch *find_watch(c
 
 	return NULL;
 }
+/*
+ * Certain older XenBus toolstack cannot handle reading values that are
+ * not populated. Some Xen 3.4 installation are incapable of doing this
+ * so if we are running on anything older than 4 do not attempt to read
+ * control/platform-feature-xs_reset_watches.
+ */
+static bool xen_strict_xenbus_quirk()
+{
+	uint32_t eax, ebx, ecx, edx, base;
+
+	base = xen_cpuid_base();
+	cpuid(base + 1, &eax, &ebx, &ecx, &edx);
 
+	if ((eax >> 16) < 4)
+		return true;
+	return false;
+
+}
 static void xs_reset_watches(void)
 {
 	int err, supported = 0;
@@ -625,6 +643,9 @@ static void xs_reset_watches(void)
 	if (!xen_hvm_domain())
 		return;
 
+	if (xen_strict_xenbus_quirk())
+		return;
+
 	err = xenbus_scanf(XBT_NIL, "control",
 			"platform-feature-xs_reset_watches", "%d", &supported);
 	if (err != 1 || !supported)


