Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755102Ab1HWSdt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 14:33:49 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:45024 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750923Ab1HWSdo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 14:33:44 -0400
Message-ID: <4E53F282.10908@suse.cz>
Date: Tue, 23 Aug 2011 20:33:38 +0200
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0) Gecko/20110812 Thunderbird/6.0
MIME-Version: 1.0
To: gregkh@suse.de
CC: alan@linux.intel.com, arnd@arndb.de,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: patch "TTY: remove tty_locked" added to tty tree
References: <13141210141189@kroah.org>
In-Reply-To: <13141210141189@kroah.org>
X-Enigmail-Version: 1.3
Content-Type: multipart/mixed;
 boundary="------------040006090207050306080407"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------040006090207050306080407
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit

On 08/23/2011 07:36 PM, gregkh@suse.de wrote:
> diff --git a/include/linux/tty.h b/include/linux/tty.h
> index 44bc0c5..6d5eceb 100644
> --- a/include/linux/tty.h
> +++ b/include/linux/tty.h
> @@ -600,8 +600,6 @@ extern long vt_compat_ioctl(struct tty_struct *tty,
>  /* functions for preparation of BKL removal */
>  extern void __lockfunc tty_lock(void) __acquires(tty_lock);
>  extern void __lockfunc tty_unlock(void) __releases(tty_lock);
> -extern struct task_struct *__big_tty_mutex_owner;
> -#define tty_locked()		(current == __big_tty_mutex_owner)

It looks like I need tty_locked to fix system stalls in
tty_wait_until_sent in the end. Like with the patch attached. But if
someone finds another way to fix this in short-term, it would be great.

thanks,
-- 
js
suse labs

--------------040006090207050306080407
Content-Type: text/x-patch;
 name="0001-TTY-fix-stalls-on-BTM-when-waiting-until-sent.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0001-TTY-fix-stalls-on-BTM-when-waiting-until-sent.patch"

>From a7c35daffe26129072aceb5d285924017820b56d Mon Sep 17 00:00:00 2001
From: Jiri Slaby <jslaby@suse.cz>
Date: Fri, 19 Aug 2011 22:16:51 +0200
Subject: [PATCH] TTY: fix stalls on BTM when waiting until sent

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Andreas Bombe <aeb@debian.org>
---
 drivers/tty/tty_ioctl.c |   11 +++++++++--
 1 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/tty/tty_ioctl.c b/drivers/tty/tty_ioctl.c
index 53f2442..3837175 100644
--- a/drivers/tty/tty_ioctl.c
+++ b/drivers/tty/tty_ioctl.c
@@ -146,6 +146,7 @@ EXPORT_SYMBOL(tty_unthrottle);
 
 void tty_wait_until_sent(struct tty_struct *tty, long timeout)
 {
+	int retval;
 #ifdef TTY_DEBUG_WAIT_UNTIL_SENT
 	char buf[64];
 
@@ -153,8 +154,14 @@ void tty_wait_until_sent(struct tty_struct *tty, long timeout)
 #endif
 	if (!timeout)
 		timeout = MAX_SCHEDULE_TIMEOUT;
-	if (wait_event_interruptible_timeout(tty->write_wait,
-			!tty_chars_in_buffer(tty), timeout) >= 0) {
+
+	if (tty_locked()) /* e.g. uart (holds) vs. tty_ioctl (does not) */
+		retval = wait_event_interruptible_timeout_tty(tty->write_wait,
+			!tty_chars_in_buffer(tty), timeout);
+	else
+		retval = wait_event_interruptible_timeout(tty->write_wait,
+			!tty_chars_in_buffer(tty), timeout);
+	if (retval >= 0) {
 		if (tty->ops->wait_until_sent)
 			tty->ops->wait_until_sent(tty, timeout);
 	}
-- 
1.7.6


--------------040006090207050306080407--
