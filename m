Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752706Ab1DSW67 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 18:58:59 -0400
Received: from mga11.intel.com ([192.55.52.93]:31202 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751693Ab1DSW6O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 18:58:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,241,1301900400"; 
   d="scan'208";a="911895397"
From: james_p_freyensee@linux.intel.com
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, suhail.ahmed@intel.com,
        james_p_freyensee@linux.intel.com, christophe.guerard@intel.com
Subject: [PATCH 2/4] Kernel documentation for the PTI feature.
Date: Tue, 19 Apr 2011 15:58:07 -0700
Message-Id: <1303253889-10074-3-git-send-email-james_p_freyensee@linux.intel.com>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <james_p_freyensee@linux.intel.com>
References: <james_p_freyensee@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: J Freyensee <james_p_freyensee@linux.intel.com>

This provides Kernel documentation for the PTI
feature and setting line discipline drivers
on top of tty's for Linux mobile solutions.

Signed-off-by: J Freyensee <james_p_freyensee@linux.intel.com>
---
 Documentation/pti/pti_intel_mid.txt |   99 +++++++++++++++++++++++++++++++++++
 1 files changed, 99 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/pti/pti_intel_mid.txt

diff --git a/Documentation/pti/pti_intel_mid.txt b/Documentation/pti/pti_intel_mid.txt
new file mode 100644
index 0000000..900f6db
--- /dev/null
+++ b/Documentation/pti/pti_intel_mid.txt
@@ -0,0 +1,99 @@
+The Intel MID PTI project is HW implemented in Intel Atom
+system-on-a-chip designs based on the Parallel Trace
+Interface for MIPI P1149.7 cJTAG standard.  The kernel solution
+for this platform involves the following files:
+
+./include/linux/pti.h
+./drivers/.../n_tracesink.h
+./drivers/.../n_tracerouter.c
+./drivers/.../n_tracesink.c
+./drivers/.../pti.c
+
+pti.c is the driver that enables various debugging features
+popular on certain mobile manufacturers.  n_tracerouter.c
+and n_tracesink.c allow extra system information to be
+collected and routed to the pti driver, such as trace
+debugging data from a modem.  Although n_tracerouter
+and n_tracesink are a part of the complete PTI solution,
+these two line disciplines can work separately from
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
+Below is example pseudo-code on how a 'privileged' application
+can hook up n_tracerouter and n_tracesink to any tty on
+a system.  'Privileged' means the application has enough
+privileges to successfully manipulate the ldisc drivers
+but is not just blindly executing as 'root'. Keep in mind
+the use of ioctl(,TIOCSETD,) is not specific to the n_tracerouter
+and n_tracesink line discpline drivers but is a generic
+operation for a program to use a line discpline driver
+on a tty port other than the default n_tty.
+
+/////////// To hook up n_tracerouter and n_tracesink /////////
+
+// Note that n_tracerouter depends on n_tracesink.
+#include <errno.h>
+#define ONE_TTY "/dev/ttyOne"
+#define TWO_TTY "/dev/ttyTwo"
+
+// needed global to hand onto ldisc connection
+static int g_fd_source = -1;
+static int g_fd_sink  = -1;
+
+// these two vars used to grab LDISC values from loaded ldisc drivers
+// in OS.  Look at /proc/tty/ldiscs to get the right numbers from
+// the ldiscs loaded in the system.
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
+// Three, program closes connection, and cleanup:
+close(g_fd_uart);
+close(g_fd_gadget);
+g_fd_uart = g_fd_gadget = NULL;
-- 
1.7.2.3

