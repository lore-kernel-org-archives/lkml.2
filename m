Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752892Ab1HATYU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 15:24:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8973 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752605Ab1HATYP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 15:24:15 -0400
Date: Mon, 1 Aug 2011 15:24:07 -0400
From: Don Zickus <dzickus@redhat.com>
To: ZAK Magnus <zakmagnus@google.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Mandeep Singh Baines <msb@chromium.org>
Subject: Re: [PATCH v3 2/2] Make hard lockup detection use timestamps
Message-ID: <20110801192407.GE2581@redhat.com>
References: <1311271873-10879-1-git-send-email-zakmagnus@google.com>
 <20110722195340.GF3765@redhat.com>
 <CAAuSN93tiSehpNXxjOgrq7oV-U+1ZPi2eqr+2dNSBG0yu0jxmA@mail.gmail.com>
 <20110725124451.GA2866@redhat.com>
 <CAAuSN93Qjk4eEAvm_Xn=O-0t+qhAyKmxy6HyPuyzJ35tX2u_CQ@mail.gmail.com>
 <20110729205538.GD14343@redhat.com>
 <CAAuSN93ouWrPn9xWb9Zd3E2Dp0hQxC4JmFH1utbyy1_aMnfkLA@mail.gmail.com>
 <20110801125234.GE14343@redhat.com>
 <CAAuSN92UAjuJXprBAj9z0sekk=iBWGe3PP88z8NmrZ5fExOyjg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAuSN92UAjuJXprBAj9z0sekk=iBWGe3PP88z8NmrZ5fExOyjg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 01, 2011 at 11:33:24AM -0700, ZAK Magnus wrote:
> Okay... So this is a problem we need to solve. Does there exist a good
> way to output a stack trace to, say, a file in /proc? I think that
> would be an appealing solution, if doable.

One idea I thought of to workaround this is to save the timestamp and the
watchdog bool and restore after the stack dump.  It's a cheap hack and I
am not to sure about the locking as it might race with
touch_nmi_watchdog().  But it gives you an idea what I was thinking.

Being in the nmi context, no one can normally touch these variables,
except for another cpu using touch_nmi_watchdog() (or watchdog_enable()
but that should never race in these scenarios).

Cheers,
Don

compile tested only.


diff --git a/kernel/watchdog.c b/kernel/watchdog.c
index 17bcded..2dcedb3 100644
--- a/kernel/watchdog.c
+++ b/kernel/watchdog.c
@@ -214,6 +214,9 @@ void touch_softlockup_watchdog_sync(void)
 static void update_hardstall(unsigned long stall, int this_cpu)
 {
 	int update_stall = 0;
+	int ts;
+	bool touched;
+
 	if (stall > hardstall_thresh &&
 			stall > worst_hardstall + hardstall_diff_thresh) {
 		unsigned long flags;
@@ -225,10 +228,14 @@ static void update_hardstall(unsigned long stall, int this_cpu)
 	}
 
 	if (update_stall) {
+		ts = __this_cpu_read(watchdog_touch_ts);
+		touched = __this_cpu_read(watchdog_nmi_touch);
 		printk(KERN_WARNING "LOCKUP may be in progress!"
 			"Worst hard stall seen on CPU#%d: %lums\n",
 			this_cpu, stall);
 		dump_stack();
+		__this_cpu_write(watchdog_touch_ts, ts);
+		__this_cpu_write(watchdog_nmi_touch, touched);
 	}
 }
 
@@ -262,6 +269,9 @@ static int is_hardlockup(int this_cpu)
 static void update_softstall(unsigned long stall, int this_cpu)
 {
 	int update_stall = 0;
+	int ts;
+	bool touched;
+
 	if (stall > get_softstall_thresh() &&
 			stall > worst_softstall + softstall_diff_thresh) {
 		unsigned long flags;
@@ -273,10 +283,14 @@ static void update_softstall(unsigned long stall, int this_cpu)
 	}
 
 	if (update_stall) {
+		ts = __this_cpu_read(watchdog_touch_ts);
+		touched = __this_cpu_read(watchdog_nmi_touch);
 		printk(KERN_WARNING "LOCKUP may be in progress!"
 				"Worst soft stall seen on CPU#%d: %lums\n",
 				this_cpu, stall);
 		dump_stack();
+		__this_cpu_write(watchdog_touch_ts, ts);
+		__this_cpu_write(watchdog_nmi_touch, touched);
 	}
 }
 
