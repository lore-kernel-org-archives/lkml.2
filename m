Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755587Ab1BHTfB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 14:35:01 -0500
Received: from mga11.intel.com ([192.55.52.93]:29661 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754441Ab1BHTfA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 14:35:00 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,443,1291622400"; 
   d="scan'208";a="885571358"
From: james_p_freyensee@linux.intel.com
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, suhail.ahmed@intel.com,
        james_p_freyensee@linux.intel.com
Subject: [PATCH 02/12] Kernel documentation for the PTI feature.
Date: Tue,  8 Feb 2011 11:34:47 -0800
Message-Id: <1297193697-5417-3-git-send-email-james_p_freyensee@linux.intel.com>
X-Mailer: git-send-email 1.6.6.1
In-Reply-To: <1297193697-5417-2-git-send-email-james_p_freyensee@linux.intel.com>
References: <james_p_freyensee@linux.intel.com>
 <1297193697-5417-1-git-send-email-james_p_freyensee@linux.intel.com>
 <1297193697-5417-2-git-send-email-james_p_freyensee@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: J Freyensee <james_p_freyensee@linux.intel.com>

This provides Kernel documentation for the PTI
feature for Linux mobile solutions.

Signed-off-by: J Freyensee <james_p_freyensee@linux.intel.com>
---
 Documentation/pti/pti_intel_mid.txt |   89 +++++++++++++++++++++++++++++++++++
 1 files changed, 89 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/pti/pti_intel_mid.txt

diff --git a/Documentation/pti/pti_intel_mid.txt b/Documentation/pti/pti_intel_mid.txt
new file mode 100644
index 0000000..b9c3f3a
--- /dev/null
+++ b/Documentation/pti/pti_intel_mid.txt
@@ -0,0 +1,89 @@
+The Intel MID PTI project is HW implemented in Intel Atom
+system-on-a-chip designs based on the Parallel Trace
+Interface for MIPI P1149.7 cJTAG standard.  The kernel solution
+for this platform involves the following files:
+
+./include/linux/pti.h
+./include/linux/n_tracesink.h
+./drivers/.../n_tracerouter.c
+./drivers/.../n_tracesink.c
+./drivers/.../pti.c
+
+pti.c is the driver that enables various debugging features
+popular on certain mobile manufacturers.  n_tracerouter.c
+and n_tracesink.c allow extra system information to be
+collected and routed to the pti driver, such as trace
+debugging data from a modem.  Altough n_tracerouter
+and n_tracesink are a part of the complete PTI solution,
+these two line disciplines can work separate from
+pti.c and route any data stream from one /dev/tty node
+to another /dev/tty node via kernel-space.  This provides
+a stable, reliable connection that will not break unless
+the user-space application shuts down (plus avoids
+kernel->user->kernel context switch overheads of routing
+data).
+
+An example debugging usage for this driver system:
+   *Hook /dev/ttyPTI0 to syslogd.  Opening this port will also start
+    a console device to further capture debugging messages to PTI.
+   *Hook /dev/ttyPTI1 to modem debugging data to write to PTI HW.
+    This is where n_tracerouter and n_tracesink are used.
+   *Hook /dev/pti to a user-level debugging application for writing
+    to PTI HW.
+   *Use mipi_* Kernel Driver API in other device drivers for
+    debugging to PTI by first requesting a PTI write address via
+    mipi_request_masterchannel(1).
+
+Example 'privileged' (normal user privileges are not enough)
+user-space code on how to setup the n_tracerouter and n_tracesink
+ldisc drivers (note: n_tracerouter depends on n_tracesink):
+
+/////////// To hook up n_tracerouter and n_tracesink /////////
+
+#include <errno.h>
+#define ONE_TTY "/dev/ttyOne"
+#define TWO_TTY "/dev/ttyTwo"
+
+// needed global to hand onto ldisc connection
+static int g_fd_source = -1;
+static int g_fd_sink  = -1;
+
+// grab LDISC values from loaded ldisc drivers from /proc/tty/ldiscs
+int source_ldisc_num, sink_ldisc_num = -1;
+int retval;
+
+g_fd_source = open(ONE_TTY, O_RDWR); // must be R/W
+g_fd_sink   = open(TWO_TTY, O_RDWR); // must be R/W
+
+if (g_fd_source <= 0) || (g_fd_sink <= 0) {
+   // doubt you'll want to use these exact error lines of code
+   printf("Error on open(). errno: %d\n",errno);
+   return errno;
+}
+
+retval = ioctl(g_fd_sink, TIOCSETD, &sink_ldisc_num);
+if (retval < 0) {
+   printf("Error on ioctl().  errno: %d\n", errno);
+   return errno;
+}
+
+retval = ioctl(g_fd_source, TIOCSETD, &source_ldisc_num);
+if (retval < 0) {
+   printf("Error on ioctl().  errno: %d\n", errno);
+   return errno;
+}
+
+/////////// To disconnect n_tracerouter and n_tracesink ////////
+
+// First make sure data through the ldiscs has stopped.
+
+// Second, disconnect ldiscs.  This provides a
+// little cleaner shutdown on tty stack.
+sink_ldisc_num = 0;
+source_ldisc_num = 0;
+ioctl(g_fd_uart, TIOCSETD, &sink_ldisc_num);
+ioctl(g_fd_gadget, TIOCSETD, &source_ldisc_num);
+
+// Three, program closes connection:
+close(g_fd_uart);
+close(g_fd_gadget);
-- 
1.6.6.1

