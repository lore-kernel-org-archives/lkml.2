Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933458Ab0KOSYI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 13:24:08 -0500
Received: from mx1.redhat.com ([209.132.183.28]:1031 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933429Ab0KOSYG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 13:24:06 -0500
Date: Mon, 15 Nov 2010 13:23:14 -0500
From: Don Zickus <dzickus@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: fweisbec@gmail.com, Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>, akpm@linux-foundation.org,
        sergey.senozhatsky@gmail.com
Subject: Re: [PATCH v3] watchdog:  touch_nmi_watchdog should only touch local
 cpu not every one
Message-ID: <20101115182314.GW4823@redhat.com>
References: <1289240913-16677-1-git-send-email-dzickus@redhat.com>
 <20101110074941.GD29493@elte.hu>
 <20101110160516.GZ4823@redhat.com>
 <20101110180711.GB22410@elte.hu>
 <20101110190352.GA31794@redhat.com>
 <20101110191432.GB30227@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101110191432.GB30227@elte.hu>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 10, 2010 at 08:14:32PM +0100, Ingo Molnar wrote:
> > > Dunno. Maybe we should do your change - but also have an option to 'shut up' the 
> > > kernel after the first hard oops [not warning]. That would silence the secondary NMI 
> > > watchdog messages as well.
> > 
> > You mean inside the panic() routine? like a ratelimit?
> 
> A ratelimit, but some really serious one - like only one crash displayed per 10 
> minutes, or so - to give the user time to make a picture of the first crash, if it's 
> still visible on the screen or so.

Well I hacked up something.  It seems to work, but I am not sure I put the
check in the right spot.

Comments welcome.

-----------8<---cut---8<-----

From: Don Zickus <dzickus@redhat.com>
Date: Mon, 15 Nov 2010 13:09:31 -0500
Subject: [PATCH] panic:  ratelimit panic messages

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
index ed45e98..5d69064 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -1815,6 +1815,12 @@ and is between 256 and 4096 characters. It is defined in the file
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
1.7.2.3

