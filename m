Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754495Ab1ATAMM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 19:12:12 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48096 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753224Ab1ATAMK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 19:12:10 -0500
Date: Wed, 19 Jan 2011 16:11:35 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Feng Tang <feng.tang@intel.com>
Cc: linux-kernel@vger.kernel.org, gregkh@suse.de, alan@linux.intel.com
Subject: Re: [PATCH] console: prevent registered consoles from dumping old
 kernel message over again
Message-Id: <20110119161135.aee848bb.akpm@linux-foundation.org>
In-Reply-To: <1294814926-1460-1-git-send-email-feng.tang@intel.com>
References: <1294814926-1460-1-git-send-email-feng.tang@intel.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Jan 2011 14:48:46 +0800
Feng Tang <feng.tang@intel.com> wrote:

> For a platform with many consoles like:
>  "console=tty1 console=ttyMFD2 console=ttyS0 earlyprintk=mrst"
> 
> Each time when the non "selected_console" (tty1 and ttyMFD2 here) get
> registered, the existing kernel message will be printed out on registered
> consoles again, the "mrst" early console will get some same message for
> 3 times, and "tty1" will get some for twice.
> 
> So try to temporarily disable registered console's printing when dump the
> existing kernel messages to the new console.
> 
> Signed-off-by: Feng Tang <feng.tang@intel.com>
> ---
>  kernel/printk.c |   13 +++++++++++++
>  1 files changed, 13 insertions(+), 0 deletions(-)
> 
> diff --git a/kernel/printk.c b/kernel/printk.c
> index f64b899..ba7186b 100644
> --- a/kernel/printk.c
> +++ b/kernel/printk.c
> @@ -1245,6 +1245,7 @@ void register_console(struct console *newcon)
>  	int i;
>  	unsigned long flags;
>  	struct console *bcon = NULL;
> +	struct console *con;
>  
>  	/*
>  	 * before we register a new CON_BOOT console, make sure we don't
> @@ -1357,8 +1358,20 @@ void register_console(struct console *newcon)
>  		spin_lock_irqsave(&logbuf_lock, flags);
>  		con_start = log_start;
>  		spin_unlock_irqrestore(&logbuf_lock, flags);
> +
> +		/*
> +		 * Disable the existing consoles temporarily to prevent it from
> +		 * printing out kernel log again.
> +		 */
> +		for_each_console(con)
> +			if (con != newcon)
> +				con->flags &= ~CON_ENABLED;

Is it racy?  If some CPU does an unrelated printk in the middle of all
this, might that get lost?  Perhaps not, given the way we pass the
start/end indexes into log_buf[].

>  	}
>  	release_console_sem();
> +
> +	for_each_console(con)
> +		con->flags |= CON_ENABLED;

If a console previously had CON_ENABLED unset, this will bogusly set
it.  That will (at least) defeat the intent of a previous
console_stop().

How's about something like this?

--- a/kernel/printk.c~a
+++ a/kernel/printk.c
@@ -113,6 +113,11 @@ static unsigned con_start;	/* Index into
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
@@ -460,6 +465,8 @@ static void __call_console_drivers(unsig
 	struct console *con;
 
 	for_each_console(con) {
+		if (exclusive_console && con != exclusive_console)
+			continue;
 		if ((con->flags & CON_ENABLED) && con->write &&
 				(cpu_online(smp_processor_id()) ||
 				(con->flags & CON_ANYTIME)))
@@ -1358,8 +1365,15 @@ void register_console(struct console *ne
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
+	exclusive_console = NULL;
 	console_sysfs_notify();
 
 	/*
_

