Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755083Ab1FCNG7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 09:06:59 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:35029 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754860Ab1FCNG6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 09:06:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=wDFBSFoP6pet8fr8oqgqAIMuvJeAB2uSvSz1uC+Ebvn8GEUHl1oBzep7khENk8awRF
         Mcn56NajQB+xCZyitqBgic7GMORrGHf5rweBmTPb9sCu0nM028vreuKnLuuAje5bhUTn
         UfADhJcr5ExPYEr1JYlK4vCH4BL/ZXfyt6s/s=
Message-ID: <4DE8DC6B.4070905@gmail.com>
Date: Fri, 03 Jun 2011 15:06:51 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110531 Thunderbird/5.0b1
MIME-Version: 1.0
To: Jiri Slaby <jslaby@suse.cz>
CC: gregkh@suse.de, linux-kernel@vger.kernel.org,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, stable@kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 1/2] TTY: ldisc, do not close until there are readers
References: <1307106096-6461-1-git-send-email-jslaby@suse.cz>
In-Reply-To: <1307106096-6461-1-git-send-email-jslaby@suse.cz>
X-Enigmail-Version: 1.2a1pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/03/2011 03:01 PM, Jiri Slaby wrote:
> We restored tty_ldisc_wait_idle in 100eeae2c5c (TTY: restore
> tty_ldisc_wait_idle). We used it in the ldisc changing path to fix the
> case where there are tasks in n_tty_read waiting for data and somebody
> tries to change ldisc.
> 
> Similar to the case above, there may be also tasks waiting in
> n_tty_read. As 65b770468e98 (tty-ldisc: turn ldisc user count into a
> proper refcount) removed the wait-until-idle from all paths, hangup
> path won't wait for them to disappear either. So add it back even to
> the hangup path.
> 
> There is a difference, we need uninterruptible sleep as there is
> obviously HUP signal pending. So tty_ldisc_wait_idle now takes
> interruptible parameter to decide. I'm not sure whether it's worth the
> complexity. Instead uninterruptible waiting may fit even for the ldisc
> change code. It wouldn't be possible to interrupted the change, but
> there is 5s timeout anyway.

I've detypoed the text locally, but will wait if there are any comments
on the code before resending.

> Before 65b770468e98 tty_ldisc_release was called also from
> tty_ldisc_release. It is called from tty_release, so I don't think we
> need to restore that one.
> 
> This is nicely reproducible after constify the timing as follows:
> --- a/drivers/tty/n_tty.c
> +++ b/drivers/tty/n_tty.c
> @@ -1548,6 +1549,7 @@ static int n_tty_open(struct tty_struct *tty)
> 
>         /* These are ugly. Currently a malloc failure here can panic */
>         if (!tty->read_buf) {
> +               msleep(100);
>                 tty->read_buf = kzalloc(N_TTY_BUF_SIZE, GFP_KERNEL);
>                 if (!tty->read_buf)
>                         return -ENOMEM;
> @@ -1741,6 +1743,7 @@ do_it_again:
> 
>         add_wait_queue(&tty->read_wait, &wait);
>         while (nr) {
> +               WARN_ON(!tty->read_buf);
>                 /* First test for status change. */
>                 if (packet && tty->link->ctrl_status) {
>                         unsigned char cs;
> @@ -1785,6 +1788,7 @@ do_it_again:
>                                 break;
>                         }
>                         timeout = schedule_timeout(timeout);
> +                       msleep(20);
>                         continue;
>                 }
>                 __set_current_state(TASK_RUNNING);
> 
> ==================================
> 
> With a process:
>     while (1) {
>         int fd = open(argv[1], O_RDWR);
>         read(fd, buf, sizeof(buf));
>         close(fd);
>     }
> ===== and its child: =====
>         setsid();
>         while (1) {
>                 int fd = open(tty, O_RDWR|O_NOCTTY);
>                 ioctl(fd, TIOCSCTTY, 1);
>                 vhangup();
>                 close(fd);
>                 usleep(100 * (10 + random() % 1000));
>         }
> 
> References: https://bugzilla.novell.com/show_bug.cgi?id=693374
> References: https://bugzilla.novell.com/show_bug.cgi?id=694509
> Signed-off-by: Jiri Slaby <jslaby@suse.cz>
> Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
> Cc: stable@kernel.org [32, 33, 34, 39]
> Cc: Linus Torvalds <torvalds@linux-foundation.org>
> ---
>  drivers/tty/tty_ldisc.c |   34 +++++++++++++++++++++++++++-------
>  1 files changed, 27 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/tty/tty_ldisc.c b/drivers/tty/tty_ldisc.c
> index 5d01d32..3c01bf0 100644
> --- a/drivers/tty/tty_ldisc.c
> +++ b/drivers/tty/tty_ldisc.c
> @@ -552,14 +552,32 @@ static void tty_ldisc_flush_works(struct tty_struct *tty)
>   *	Wait for the line discipline to become idle. The discipline must
>   *	have been halted for this to guarantee it remains idle.
>   */
> -static int tty_ldisc_wait_idle(struct tty_struct *tty)
> +static int tty_ldisc_wait_idle(struct tty_struct *tty, bool interruptible)
>  {
> +	DEFINE_WAIT(wait);
> +	long timeout = 5 * HZ;
> +	int state = interruptible ? TASK_INTERRUPTIBLE : TASK_UNINTERRUPTIBLE;
>  	int ret;
> -	ret = wait_event_interruptible_timeout(tty_ldisc_idle,
> -			atomic_read(&tty->ldisc->users) == 1, 5 * HZ);
> -	if (ret < 0)
> -		return ret;
> -	return ret > 0 ? 0 : -EBUSY;
> +
> +	for (;;) {
> +		prepare_to_wait(&tty_ldisc_idle, &wait, state);
> +		if (atomic_read(&tty->ldisc->users) == 1) {
> +			ret = 0;
> +			break;
> +		}
> +		if (interruptible && signal_pending(current)) {
> +			ret = -ERESTARTSYS;
> +			break;
> +		}
> +
> +		timeout = schedule_timeout(timeout);
> +		if (!timeout) {
> +			ret = -EBUSY;
> +			break;
> +		}
> +	}
> +	finish_wait(&tty_ldisc_idle, &wait);
> +	return ret;
>  }
>  
>  /**
> @@ -666,7 +684,7 @@ int tty_set_ldisc(struct tty_struct *tty, int ldisc)
>  
>  	tty_ldisc_flush_works(tty);
>  
> -	retval = tty_ldisc_wait_idle(tty);
> +	retval = tty_ldisc_wait_idle(tty, 1);
>  
>  	tty_lock();
>  	mutex_lock(&tty->ldisc_mutex);
> @@ -763,6 +781,8 @@ static int tty_ldisc_reinit(struct tty_struct *tty, int ldisc)
>  	if (IS_ERR(ld))
>  		return -1;
>  
> +	WARN_ON_ONCE(tty_ldisc_wait_idle(tty, 0));
> +
>  	tty_ldisc_close(tty, tty->ldisc);
>  	tty_ldisc_put(tty->ldisc);
>  	tty->ldisc = NULL;


-- 
js
