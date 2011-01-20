Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754852Ab1ATCaz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 21:30:55 -0500
Received: from mga11.intel.com ([192.55.52.93]:47130 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754772Ab1ATCav (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 21:30:51 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,347,1291622400"; 
   d="scan'208";a="649029672"
Date: Thu, 20 Jan 2011 10:31:14 +0800
From: Feng Tang <feng.tang@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "gregkh@suse.de" <gregkh@suse.de>,
        "alan@linux.intel.com" <alan@linux.intel.com>
Subject: Re: [PATCH] console: prevent registered consoles from dumping old
 kernel message over again
Message-ID: <20110120103114.2475c75f@feng-i7>
In-Reply-To: <20110119175134.5a2f283f.akpm@linux-foundation.org>
References: <1294814926-1460-1-git-send-email-feng.tang@intel.com>
	<20110119161135.aee848bb.akpm@linux-foundation.org>
	<20110120094458.144708e0@feng-i7>
	<20110119175134.5a2f283f.akpm@linux-foundation.org>
Organization: intel
X-Mailer: Claws Mail 3.7.4 (GTK+ 2.20.0; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Jan 2011 09:51:34 +0800
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Thu, 20 Jan 2011 09:44:58 +0800
> Feng Tang <feng.tang@intel.com> wrote:
> 
> > > How's about something like this?
> > 
> > Yes, it makes sense, I should add some check. And this new
> > "exclusive_console" should be better as its name shows what it is
> > for.
> 
> Is it racy, or does console_sem coverage save us?
> 
> Anyway.  If you think that the exclusive_console approach is suitable,
> please send a tested patch back at me sometime?
> 

Actually before my last email, I tested your patch which works fine which
I just forgot to mention :)

looks a little racy, so I move the "exclusive_console=NULL" to some place
protected by console_sem, and it works fine on my platform, pls review it

Thanks,
Feng


-----------------------------
rom cf1fcf9942f1ac067081572c8dc1e238674441fd Mon Sep 17 00:00:00 2001
From: Feng Tang <feng.tang@intel.com>
Date: Thu, 20 Jan 2011 10:26:21 +0800
Subject: [PATCH] console: prevent registered consoles from dumping old kernel message over again

For a platform with many consoles like:
 "console=tty1 console=ttyMFD2 console=ttyS0 earlyprintk=mrst"

Each time when the non "selected_console" (tty1 and ttyMFD2 here) get
registered, the existing kernel message will be printed out on registered
consoles again, the "mrst" early console will get some same message for
3 times, and "tty1" will get some for twice.

As suggested by Andrew Morton, everytime a new console is registered, it
will be set as the "exclusive" console which will dump the already existing
kernel message.

Signed-off-by: Feng Tang <feng.tang@intel.com>
---
 kernel/printk.c |   18 ++++++++++++++++++
 1 files changed, 18 insertions(+), 0 deletions(-)

diff --git a/kernel/printk.c b/kernel/printk.c
index 53d9a9e..ee71cc4 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -113,6 +113,11 @@ static unsigned con_start;	/* Index into log_buf: next char to be sent to consol
 static unsigned log_end;	/* Index into log_buf: most-recently-written-char + 1 */
 
 /*
+ * If exclusive_console is non-NULL then only this console is to be printed to.
+ */
+static struct console *exclusive_console;
+
+/*
  *	Array of consoles built from command line options (console=)
  */
 struct console_cmdline
@@ -460,6 +465,8 @@ static void __call_console_drivers(unsigned start, unsigned end)
 	struct console *con;
 
 	for_each_console(con) {
+		if (exclusive_console && con != exclusive_console)
+			continue;
 		if ((con->flags & CON_ENABLED) && con->write &&
 				(cpu_online(smp_processor_id()) ||
 				(con->flags & CON_ANYTIME)))
@@ -1136,6 +1143,11 @@ void release_console_sem(void)
 		local_irq_restore(flags);
 	}
 	console_locked = 0;
+
+	/* Release the exclusive_console once it is used */
+	if (unlikely(exclusive_console))
+		exclusive_console = NULL;
+
 	up(&console_sem);
 	spin_unlock_irqrestore(&logbuf_lock, flags);
 	if (wake_klogd)
@@ -1358,6 +1370,12 @@ void register_console(struct console *newcon)
 		spin_lock_irqsave(&logbuf_lock, flags);
 		con_start = log_start;
 		spin_unlock_irqrestore(&logbuf_lock, flags);
+		/*
+		 * We're about to replay the log buffer.  Only do this to the
+		 * just-registered console to avoid excessive message spam to
+		 * the already-registered consoles.
+		 */
+		exclusive_console = newcon;
 	}
 	release_console_sem();
 	console_sysfs_notify();
-- 
