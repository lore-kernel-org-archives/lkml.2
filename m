Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751033Ab2ISTZN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 15:25:13 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:35598 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750857Ab2ISTZG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 15:25:06 -0400
Message-ID: <505A1C0D.3050906@suse.cz>
Date: Wed, 19 Sep 2012 21:25:01 +0200
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20120904 Thunderbird/16.0
MIME-Version: 1.0
To: Shachar Shemesh <shachar@liveu.tv>
CC: Greg KH <greg@kroah.com>, LKML <linux-kernel@vger.kernel.org>,
        kzak@redhat.com, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] tty ldisc: Close/Reopen race prevention should check
 the proper flag
References: <4FEFF3DF.9000909@liveu.tv> <20120706212430.GA454@kroah.com> <4FF94BC6.3000704@liveu.tv> <20120709164402.GA14592@kroah.com> <4FFBB575.6050602@liveu.tv>
In-Reply-To: <4FFBB575.6050602@liveu.tv>
X-Enigmail-Version: 1.5a1pre
Content-Type: multipart/mixed;
 boundary="------------040306050204040008060706"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------040306050204040008060706
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

On 07/10/2012 06:54 AM, Shachar Shemesh wrote:
> From: Shachar Shemesh <shachar@liveu.tv>
> 
> Commit acfa747b introduced the TTY_HUPPING flag to distinguish
> closed TTY from currently closing ones. The test in tty_set_ldisc
> still remained pointing at the old flag. This causes pppd to
> sometimes lapse into uninterruptible sleep when killed and
> restarted.
> 
> Signed-off-by: Shachar Shemesh <shachar@liveu.tv>
> ---
> Tested with 3.2.20 kernel.
> 
> diff --git a/drivers/tty/tty_ldisc.c b/drivers/tty/tty_ldisc.c
> index 24b95db..a662a24 100644
> --- a/drivers/tty/tty_ldisc.c
> +++ b/drivers/tty/tty_ldisc.c
> @@ -658,7 +658,7 @@ int tty_set_ldisc(struct tty_struct *tty, int ldisc)
>  		goto enable;
>  	}
>  
> -	if (test_bit(TTY_HUPPED, &tty->flags)) {
> +	if (test_bit(TTY_HUPPING, &tty->flags)) {
>  		/* We were raced by the hangup method. It will have stomped
>  		   the ldisc data and closed the ldisc down */
>  		clear_bit(TTY_LDISC_CHANGING, &tty->flags);

Yes, that makes the issue go away, but does not seem to be right too.
There are two issues I see:
* TTY_HUPPED has no use now. That is incorrect. Here should be a test
for both flags, I think.
* The change forces the set_ldisc path to always re-open the ldisc even
if it the terminal is HUPPED.

The bug is not in the kernel. It was in login(1) (util-linux). And it
should be fixed by now. See:
http://git.kernel.org/?p=utils/util-linux/util-linux.git;a=commitdiff;h=2e7035646eb85851171cc2e989bfa858a4f00cd4


I'm for an in-fact revert of the patch. But temporarily I would still
return EIO. However let's do it even after the reopen is done, so that
we get rid of the user-visible regression. Like in the attached patch.
The regression was introduced by commit c65c9bc3e (tty: rewrite the
ldisc locking). That is !three! years ago. And that is suspicious in itself.


BTW Why pppd thinks it is a good idea to ignore EIO from TIOCSETD ioctl?

regards,
-- 
js
suse labs

--------------040306050204040008060706
Content-Type: text/x-patch;
 name="0001-TTY-forbid-setting-ldisc-on-HUPPED-tty-step-1.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0001-TTY-forbid-setting-ldisc-on-HUPPED-tty-step-1.patch"

>From b3e5a7f778be46b4b8dd38d5565010755ccafd67 Mon Sep 17 00:00:00 2001
From: Jiri Slaby <jslaby@suse.cz>
Date: Wed, 19 Sep 2012 20:23:59 +0200
Subject: [PATCH 1/1] TTY: forbid setting ldisc on HUPPED tty, step 1

Commit c65c9bc3e (tty: rewrite the ldisc locking) introduced a check
into tty_set_ldisc whether the terminal is already hung. In that case
it returns -EIO.

Later, commit aa3c8af86 (tty ldisc: Close/Reopen race prevention
should check the proper flag) effectively disabled the check by
replacing HUPPED by HUPPING flag. Those are two different flags and
the former check was actually correct. In principle we revert here to
the previous behavior plus we add a check if we are HUPPING. Because
it makes no sense to change ldisc when some other thread is making a
HUP but it had to unlock BTM temporarily.

The bug which commit aa3c8af86 above tried to avoid lays in fact in
login(1). It was fixed by util-linux commit 2e7035646 (login: close
tty before vhangup()) already. It was reproducible for example by the
following setup:
1) add a user ppp with shell set to /usr/bin/pppd
2) run agetty on ttyS0 to wait for a user
3) user connects via modem on ttyS0, types ppp to getty
4) 'login ppp' is executed
5) login performs hangup without properly closing ttyS0
6) login executes pppd
7) pppd does TIOCSETD attempt to N_PPP
8) kernel denies step 7) as ttyS0 is HUPPED
9) pppd calls some N_PPP ldisc's ioctls regardless -- uninterruptible
   sleep in tty_ioctl, trying to have a ref on tty->ldisc

Now to sum up the fixes:
* The fix in util-linux is that 5 is changed to properly close all
  ttyS0 instances.
* The workaround from commit aa3c8af86 was that 8) succeeds.
* This patch is the same as aa3c8af86 except we still return -EIO and
  warn the user this will not be supported in the future. This is
  because we do not want to have a user-visible regression here.

"Step 1" because step two would be to immediatelly return -EIO like in
the attached false branch in the patch.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Shachar Shemesh <shachar@liveu.tv>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
---
 drivers/tty/tty_ldisc.c | 37 ++++++++++++++++++++++++++++---------
 1 file changed, 28 insertions(+), 9 deletions(-)

diff --git a/drivers/tty/tty_ldisc.c b/drivers/tty/tty_ldisc.c
index f4e6754..7cca3fd 100644
--- a/drivers/tty/tty_ldisc.c
+++ b/drivers/tty/tty_ldisc.c
@@ -563,6 +563,7 @@ int tty_set_ldisc(struct tty_struct *tty, int ldisc)
 	struct tty_ldisc *o_ldisc, *new_ldisc;
 	int work, o_work = 0;
 	struct tty_struct *o_tty;
+	int retval_hupped = 0;
 
 	new_ldisc = tty_ldisc_get(ldisc);
 	if (IS_ERR(new_ldisc))
@@ -659,14 +660,32 @@ int tty_set_ldisc(struct tty_struct *tty, int ldisc)
 		goto enable;
 	}
 
-	if (test_bit(TTY_HUPPING, &tty->flags)) {
-		/* We were raced by the hangup method. It will have stomped
-		   the ldisc data and closed the ldisc down */
-		clear_bit(TTY_LDISC_CHANGING, &tty->flags);
-		mutex_unlock(&tty->ldisc_mutex);
-		tty_ldisc_put(new_ldisc);
-		tty_unlock(tty);
-		return -EIO;
+	if (test_bit(TTY_HUPPED, &tty->flags) ||
+			test_bit(TTY_HUPPING, &tty->flags)) {
+		/*
+		 * Until login(1) is fixed everywhere, let's fall through.
+		 * Change to goto with -EIO after 3.10.
+		 */
+		if (1) {
+			char ttyn[64], comm[TASK_COMM_LEN];
+			printk_ratelimited(KERN_WARNING "%s: %s calls TIOCSETD on a hung TTY (%s). This is deprecated and will stop working soon.\n",
+					__func__, get_task_comm(comm, current),
+					tty_name(tty, ttyn));
+			retval_hupped = -EIO;
+		} else {
+			/*
+			 * We were raced by the hangup method. It will have
+			 * stomped the ldisc data and closed the ldisc down
+			 */
+			tty_ldisc_put(new_ldisc);
+			retval = -EIO;
+			/*
+			 * We have to enable the original ldisc so that
+			 * processes see N_TTY and fail instead of waiting
+			 * infinitely.
+			 */
+			goto enable;
+		}
 	}
 
 	/* Shutdown the current discipline. */
@@ -709,7 +728,7 @@ enable:
 		schedule_work(&o_tty->port->buf.work);
 	mutex_unlock(&tty->ldisc_mutex);
 	tty_unlock(tty);
-	return retval;
+	return retval ? : retval_hupped;
 }
 
 /**
-- 
1.7.12


--------------040306050204040008060706--
