Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756760Ab0C3XRe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 19:17:34 -0400
Received: from kroah.org ([198.145.64.141]:51733 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756522Ab0C3XR2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 19:17:28 -0400
X-Mailbox-Line: From linux@linux.site Tue Mar 30 15:56:03 2010
Message-Id: <20100330225602.552820899@linux.site>
User-Agent: quilt/0.47-14.9
Date: Tue, 30 Mar 2010 15:54:48 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       John Stultz <johnstul@us.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [010/116] timekeeping: Prevent oops when GENERIC_TIME=n
In-Reply-To: <20100330230600.GA28802@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: john stultz <johnstul@us.ibm.com>

commit ad6759fbf35d104dbf573cd6f4c6784ad6823f7e upstream.

Aaro Koskinen reported an issue in kernel.org bugzilla #15366, where
on non-GENERIC_TIME systems, accessing
/sys/devices/system/clocksource/clocksource0/current_clocksource
results in an oops.

It seems the timekeeper/clocksource rework missed initializing the
curr_clocksource value in the !GENERIC_TIME case.

Thanks to Aaro for reporting and diagnosing the issue as well as
testing the fix!

Reported-by: Aaro Koskinen <aaro.koskinen@iki.fi>
Signed-off-by: John Stultz <johnstul@us.ibm.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
LKML-Reference: <1267475683.4216.61.camel@localhost.localdomain>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/time/clocksource.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/kernel/time/clocksource.c
+++ b/kernel/time/clocksource.c
@@ -515,6 +515,10 @@ static inline void clocksource_select(vo
  */
 static int __init clocksource_done_booting(void)
 {
+	mutex_lock(&clocksource_mutex);
+	curr_clocksource = clocksource_default_clock();
+	mutex_unlock(&clocksource_mutex);
+
 	finished_booting = 1;
 
 	/*


