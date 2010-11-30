Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754765Ab0K3W2D (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 17:28:03 -0500
Received: from mx1.redhat.com ([209.132.183.28]:28587 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753999Ab0K3W2B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 17:28:01 -0500
From: Don Zickus <dzickus@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Robert Richter <robert.richter@amd.com>, ying.huang@intel.com,
        Andi Kleen <andi@firstfloor.org>, gorcunov@gmail.com,
        LKML <linux-kernel@vger.kernel.org>, Don Zickus <dzickus@redhat.com>
Subject: [PATCH 8/9] panic:  ratelimit panic messages
Date: Tue, 30 Nov 2010 17:27:29 -0500
Message-Id: <1291156050-4482-9-git-send-email-dzickus@redhat.com>
In-Reply-To: <1291156050-4482-1-git-send-email-dzickus@redhat.com>
References: <1291156050-4482-1-git-send-email-dzickus@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sometimes when things go bad, so much spew is coming on the console it is hard
to figure out what happened.  This patch allows you to ratelimit the panic
messages with the intent that the first panic message will provide the info
we need to figure out what happened.

Adds new kernel param 'panic_ratelimit=on/<integer in seconds>'

Signed-off-by: Don Zickus <dzickus@redhat.com>
---
 Documentation/kernel-parameters.txt |    6 ++++++
 kernel/panic.c                      |   30 ++++++++++++++++++++++++++++++
 2 files changed, 36 insertions(+), 0 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 5e55e46..79d1df8 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -1807,6 +1807,12 @@ and is between 256 and 4096 characters. It is defined in the file
 	panic=		[KNL] Kernel behaviour on panic
 			Format: <timeout>
 
+	panic_ratelimit=	[KNL] ratelimit the panic messages
+			Useful for slowing down multiple panics to capture
+			the first one before it scrolls off the screen
+			Format: "on" or some integer in seconds
+			"on" defaults to 10 minutes
+
 	parkbd.port=	[HW] Parallel port number the keyboard adapter is
 			connected to, default is 0.
 			Format: <parport#>
diff --git a/kernel/panic.c b/kernel/panic.c
index 4c13b1a..fe89e04 100644
--- a/kernel/panic.c
+++ b/kernel/panic.c
@@ -23,6 +23,7 @@
 #include <linux/init.h>
 #include <linux/nmi.h>
 #include <linux/dmi.h>
+#include <linux/ratelimit.h>
 
 #define PANIC_TIMER_STEP 100
 #define PANIC_BLINK_SPD 18
@@ -48,6 +49,31 @@ static long no_blink(int state)
 long (*panic_blink)(int state);
 EXPORT_SYMBOL(panic_blink);
 
+/* setting default to 0 effectively disables it */
+DEFINE_RATELIMIT_STATE(panic_ratelimit_state, 0, 1);
+
+static int __init panic_ratelimit_setup(char *str)
+{
+	int interval;
+
+	if (!strncmp(str, "on", 2))
+		/* default to 10 minutes */
+		interval = 600 * HZ;
+	else
+		interval = simple_strtoul(str, NULL, 0) * HZ;
+
+	panic_ratelimit_state.interval = interval;
+	return 1;
+}
+__setup("panic_ratelimit=", panic_ratelimit_setup);
+
+static int __panic_ratelimit(const char *func)
+{
+	return ___ratelimit(&panic_ratelimit_state, func);
+}
+
+#define panic_ratelimit() __panic_ratelimit(__func__)
+
 /**
  *	panic - halt the system
  *	@fmt: The text string to print
@@ -63,6 +89,10 @@ NORET_TYPE void panic(const char * fmt, ...)
 	long i, i_next = 0;
 	int state = 0;
 
+	if (!panic_ratelimit())
+		for(;;)
+			cpu_relax();
+
 	/*
 	 * It's possible to come here directly from a panic-assertion and
 	 * not have preempt disabled. Some functions called from here want
-- 
1.7.3.2

