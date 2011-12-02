Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752533Ab1LBIVU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Dec 2011 03:21:20 -0500
Received: from mail-ww0-f42.google.com ([74.125.82.42]:45268 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751598Ab1LBIVT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Dec 2011 03:21:19 -0500
Message-ID: <4ED88A78.8010706@suse.cz>
Date: Fri, 02 Dec 2011 09:21:12 +0100
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111123 Thunderbird/9.0
MIME-Version: 1.0
To: Tony Luck <tony.luck@intel.com>
CC: gregkh@suse.de, linux-kernel@vger.kernel.org, jirislaby@gmail.com,
        Dave Young <hidave.darkstar@gmail.com>, Dave Jones <davej@redhat.com>,
        Ben Hutchings <ben@decadent.org.uk>,
        Dmitriy Matrosov <sgf.dma@gmail.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, stable <stable@kernel.org>
Subject: Re: [PATCH 2/5] TTY: ldisc, move wait idle to caller
References: <1321457231-9154-1-git-send-email-jslaby@suse.cz> <1321457231-9154-2-git-send-email-jslaby@suse.cz> <CA+8MBbJ4Tu86jSbaBRjDKfowwVE12jY3efK7QMm74e7i8aq4Hg@mail.gmail.com>
In-Reply-To: <CA+8MBbJ4Tu86jSbaBRjDKfowwVE12jY3efK7QMm74e7i8aq4Hg@mail.gmail.com>
X-Enigmail-Version: 1.3.4
Content-Type: multipart/mixed;
 boundary="------------090501000704070200020300"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------090501000704070200020300
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

On 12/02/2011 12:01 AM, Tony Luck wrote:
> One of my systems (HP rx2620 - ia64) has started hanging during shutdown.
> Last messages on the serial console are:
> 
> Shutting down service (localfs) network  .  .  .  .  .  .  .  .  .   done
> Shutting down D-Bus daemon                                           done
> Running /etc/ini
> 
> and there it hangs forever in mid word (totally repeatable stops at "ini" every
> time).
> 
> git bisect blames:
> 
> commit 300420722e0734a4254f3b634e0f82664495d210
> Author: Jiri Slaby <jslaby@suse.cz>
> Date:   Wed Nov 16 16:27:08 2011 +0100
> 
>     TTY: ldisc, move wait idle to caller
> 
> [Though the following commit "TTY: ldisc, wait for ldisc infinitely in hangup"
>  sounds like it fits the symptoms]
> 
> Ideas?

Thanks. What distro and init do you use? Does the attached patch help?

-- 
js
suse labs

--------------090501000704070200020300
Content-Type: text/x-patch;
 name="0001-TTY-ldisc-don-t-wait-with-ldisc_mutex.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="0001-TTY-ldisc-don-t-wait-with-ldisc_mutex.patch"

>From 6f778e80388f8b1ad65f0c8bfbc874704d77b3eb Mon Sep 17 00:00:00 2001
From: Jiri Slaby <jslaby@suse.cz>
Date: Fri, 2 Dec 2011 09:19:05 +0100
Subject: [PATCH 1/1] TTY: ldisc, don't wait with ldisc_mutex

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/tty/tty_ldisc.c |   16 +++++++++++++---
 1 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/drivers/tty/tty_ldisc.c b/drivers/tty/tty_ldisc.c
index 24b95db..c93e113 100644
--- a/drivers/tty/tty_ldisc.c
+++ b/drivers/tty/tty_ldisc.c
@@ -527,6 +527,14 @@ static void tty_ldisc_flush_works(struct tty_struct *tty)
 	flush_work_sync(&tty->buf.work);
 }
 
+static bool tty_ldisc_is_idle(struct tty_struct *tty)
+{
+	bool idle;
+	mutex_lock(&tty->ldisc_mutex);
+	idle = !tty->ldisc || atomic_read(&tty->ldisc->users) == 1;
+	mutex_unlock(&tty->ldisc_mutex);
+	return idle;
+}
 /**
  *	tty_ldisc_wait_idle	-	wait for the ldisc to become idle
  *	@tty: tty to wait for
@@ -534,12 +542,14 @@ static void tty_ldisc_flush_works(struct tty_struct *tty)
  *
  *	Wait for the line discipline to become idle. The discipline must
  *	have been halted for this to guarantee it remains idle.
+ *
+ *	Locking: neither BTM, nor tty->ldisc_mutex must be held
  */
 static int tty_ldisc_wait_idle(struct tty_struct *tty, long timeout)
 {
 	long ret;
-	ret = wait_event_timeout(tty_ldisc_idle,
-			atomic_read(&tty->ldisc->users) == 1, timeout);
+	ret = wait_event_timeout(tty_ldisc_idle, tty_ldisc_is_idle(tty),
+			timeout);
 	return ret > 0 ? 0 : -EBUSY;
 }
 
@@ -830,6 +840,7 @@ retry:
 		if (atomic_read(&tty->ldisc->users) != 1) {
 			char cur_n[TASK_COMM_LEN], tty_n[64];
 			long timeout = 3 * HZ;
+			mutex_unlock(&tty->ldisc_mutex);
 			tty_unlock();
 
 			while (tty_ldisc_wait_idle(tty, timeout) == -EBUSY) {
@@ -839,7 +850,6 @@ retry:
 					__func__, get_task_comm(cur_n, current),
 					tty_name(tty, tty_n));
 			}
-			mutex_unlock(&tty->ldisc_mutex);
 			goto retry;
 		}
 
-- 
1.7.7.3


--------------090501000704070200020300--
