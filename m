Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752385Ab0KXIdZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 03:33:25 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:52615 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751824Ab0KXIdY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 03:33:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=pe6hAiGIoajQLF4A2rd6LTglCqxd/shNC61L10QUhCaqi6MdIb5hSllL1vL9Wmex9B
         n4RdGt7ghJxygWa4pUy0zSHcbac4ZjBo3z2rI4RBNpIT7ch/389R5wNJdDX8iU7FrUbD
         ATMPgWts/hhtgaOcydOR3kgpry9nFQtnJdkW4=
MIME-Version: 1.0
In-Reply-To: <1281307532-3235-1-git-send-email-shawn.bohrer@gmail.com>
References: <1281307532-3235-1-git-send-email-shawn.bohrer@gmail.com>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Wed, 24 Nov 2010 03:33:02 -0500
Message-ID: <AANLkTinLCN3ojoRqcAwRsA=JJ=0=R6TWv2dmyUvbMMTC@mail.gmail.com>
Subject: Re: [PATCH] hrtimer: make epoll_wait() use the hrtimer range feature
To: Shawn Bohrer <shawn.bohrer@gmail.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id oAO8XtqC010848

On Sun, Aug 8, 2010 at 18:45, Shawn Bohrer wrote:
> @@ -1116,18 +1113,22 @@ static int ep_send_events(struct eventpoll *ep,
>  static int ep_poll(struct eventpoll *ep, struct epoll_event __user *events,
>                   int maxevents, long timeout)
>  {
> -       int res, eavail;
> +       int res, eavail, timed_out = 0;
>        unsigned long flags;
> -       long jtimeout;
> +       long slack;
>        wait_queue_t wait;
> -
> -       /*
> -        * Calculate the timeout by checking for the "infinite" value (-1)
> -        * and the overflow condition. The passed timeout is in milliseconds,
> -        * that why (t * HZ) / 1000.
> -        */
> -       jtimeout = (timeout < 0 || timeout >= EP_MAX_MSTIMEO) ?
> -               MAX_SCHEDULE_TIMEOUT : (timeout * HZ + 999) / 1000;
> +       struct timespec end_time;
> +       ktime_t expires, *to = NULL;
> +
> +       if (timeout > 0) {
> +               ktime_get_ts(&end_time);
> +               timespec_add_ns(&end_time, (u64)timeout * NSEC_PER_MSEC);
> +               slack = estimate_accuracy(&end_time);
> +               to = &expires;
> +               *to = timespec_to_ktime(end_time);
> +       } else if (timeout == 0) {
> +               timed_out = 1;
> +       }
>
>  retry:
>        spin_lock_irqsave(&ep->lock, flags);
> @@ -1149,7 +1150,7 @@ retry:
>                         * to TASK_INTERRUPTIBLE before doing the checks.
>                         */
>                        set_current_state(TASK_INTERRUPTIBLE);
> -                       if (!list_empty(&ep->rdllist) || !jtimeout)
> +                       if (!list_empty(&ep->rdllist) || timed_out)
>                                break;
>                        if (signal_pending(current)) {
>                                res = -EINTR;
> @@ -1157,7 +1158,9 @@ retry:
>                        }
>
>                        spin_unlock_irqrestore(&ep->lock, flags);
> -                       jtimeout = schedule_timeout(jtimeout);
> +                       if (!schedule_hrtimeout_range(to, slack, HRTIMER_MODE_ABS))
> +                               timed_out = 1;
> +
>                        spin_lock_irqsave(&ep->lock, flags);
>                }
>                __remove_wait_queue(&ep->wq, &wait);

this code introduces a warning:
fs/eventpoll.c: In function ‘ep_poll’:
fs/eventpoll.c:1119: warning: ‘slack’ may be used uninitialized in this function

looks to me like you arent properly handling negative timeouts.
certainly epoll_wait() passes the timeout value straight from
userspace to ep_poll() without any error checking, so if userspace
passes a negative timeout value, it looks like "slack" will be used
uninitialized.
-mike
���{.n�+�������+%�����ݶ��w��{.n�+����{��G�����{ay�ʇڙ�,j��f���h��������z_�(�階�ݢj"���m������G������?����&���~��iO��z��v�^�m����������?�I�
