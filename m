Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753423Ab1GZQCQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 12:02:16 -0400
Received: from casper.infradead.org ([85.118.1.10]:43640 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751160Ab1GZQCG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 12:02:06 -0400
Subject: Re: klogd dies, possible emit_log_char() vs do_syslog(..READ..)
 race.
From: Peter Zijlstra <peterz@infradead.org>
To: Peter Chubb <peter.chubb@nicta.com.au>
Cc: akpm@linux-foundation.org, torvalds@linux-foundation.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <w4ipqp26i1.wl%peter@chubb.wattle.id.au>
References: <w4ipqp26i1.wl%peter@chubb.wattle.id.au>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 26 Jul 2011 18:01:33 +0200
Message-ID: <1311696094.24752.98.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-07-26 at 11:08 +1000, Peter Chubb wrote:
> Hi,
> 
>    Since mid May, my klogd has been turning into a 100% CPU hog at
>    regular intervals.  Turns out that sometimes reads from /proc/kmsg
>    return with zero bytes read --- pointing to a race between
>    do_syslog(SYSLOG_ACTION_READ...) and emit_log_char().
>    (In Debian, klogd is invoked with a dd frontend, as
>       dd if=/proc/kmsg of=/var/run/klogd bs=1
>    where /var/run/klogd is a named pipe; this dd dies when it reads
>    zero bytes).

Well I suppose that's a bug anyway since if someone managed to have
multiple consumers of the data you'll get into that same situation,
therefore using dd might not be the sanest thing to do.

Suppose someone does cat /proc/kmsg > /dev/null, just for kicks ;-)

>    There's history in the  Debian bug tracker,
>    http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=308580 
> 
>    I tried an obvious and very ugly band-aid (appended) and the
>    problem went away. 
> 
>    It seems to me that log_buf_end must be wrapping and be a little
>    less than log_buf_start, then when emit_log_char() updates
>    log_buf_end it can become equal, causing do_syslog() to return zero
>    bytes read.  This'd have to happen between the
>    wait_event_interruptible() and the taking of logbuf_lock in
>    do_syslog().
> 
>    I can't see how this can happen though.  emit_log_char() should
>    reset log_start so it can not happen.

Well there is a distinct lack of serialization between the log_start,
log_end usage in wait_event_interruptible() and emit_log_char().

>From what I can see one has to hold the logbuf_lock to get a stable
reading, so if the code in SYSLOG_ACTION_READ requires this for proper
functioning its buggy.

That said, this is the very first time I ever looked at that code ;-)

Does something like the (completely untested) patch below also cure
things?

---
 kernel/printk.c |   16 +++++++++++++---
 1 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/kernel/printk.c b/kernel/printk.c
index 37dff34..25907df 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -327,6 +327,17 @@ static int check_syslog_permissions(int type, bool from_file)
 	return 0;
 }
 
+static unsigned int log_size(void)
+{
+	unsigned int size;
+
+	spin_lock_irq(&logbuf_lock);
+	size = log_end - log_start;
+	spin_unlock_irq(&logbuf_lock);
+
+	return size;
+}
+
 int do_syslog(int type, char __user *buf, int len, bool from_file)
 {
 	unsigned i, j, limit, count;
@@ -358,8 +369,7 @@ int do_syslog(int type, char __user *buf, int len, bool from_file)
 			error = -EFAULT;
 			goto out;
 		}
-		error = wait_event_interruptible(log_wait,
-							(log_start - log_end));
+		error = wait_event_interruptible(log_wait, log_size());
 		if (error)
 			goto out;
 		i = 0;
@@ -467,7 +477,7 @@ int do_syslog(int type, char __user *buf, int len, bool from_file)
 		break;
 	/* Number of chars in the log buffer */
 	case SYSLOG_ACTION_SIZE_UNREAD:
-		error = log_end - log_start;
+		error = log_size();
 		break;
 	/* Size of the log buffer */
 	case SYSLOG_ACTION_SIZE_BUFFER:

