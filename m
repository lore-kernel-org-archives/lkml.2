Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752726Ab0KXOxA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 09:53:00 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:59372 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750974Ab0KXOw7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 09:52:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=hzfnr/ISnJZhEAJW8d9uwFtTu/E56GtY5edNjeX9X58QAaQqwFk8D3ky5JTm41lE23
         2faU9K3/pJ7HTPBdWb0hc6Uw6P1Njhw0yI/FUDyG2uek574rcUMCp3xHrKwTRjA9lUjw
         tL/wSbjxGpR8/xqU7aBPrjnxwsbrpaDQVPFU4=
Date: Wed, 24 Nov 2010 08:52:47 -0600
From: Shawn Bohrer <shawn.bohrer@gmail.com>
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] hrtimer: make epoll_wait() use the hrtimer range feature
Message-ID: <20101124145247.GA2860@BohrerMBP.rgmadvisors.com>
References: <1281307532-3235-1-git-send-email-shawn.bohrer@gmail.com>
 <AANLkTinLCN3ojoRqcAwRsA=JJ=0=R6TWv2dmyUvbMMTC@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTinLCN3ojoRqcAwRsA=JJ=0=R6TWv2dmyUvbMMTC@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 24, 2010 at 03:33:02AM -0500, Mike Frysinger wrote:
> On Sun, Aug 8, 2010 at 18:45, Shawn Bohrer wrote:
> > @@ -1116,18 +1113,22 @@ static int ep_send_events(struct eventpoll *ep,
> >  static int ep_poll(struct eventpoll *ep, struct epoll_event __user *events,
> >                   int maxevents, long timeout)
> >  {
> > -       int res, eavail;
> > +       int res, eavail, timed_out = 0;
> >        unsigned long flags;
> > -       long jtimeout;
> > +       long slack;
> >        wait_queue_t wait;
> > -
> > -       /*
> > -        * Calculate the timeout by checking for the "infinite" value (-1)
> > -        * and the overflow condition. The passed timeout is in milliseconds,
> > -        * that why (t * HZ) / 1000.
> > -        */
> > -       jtimeout = (timeout < 0 || timeout >= EP_MAX_MSTIMEO) ?
> > -               MAX_SCHEDULE_TIMEOUT : (timeout * HZ + 999) / 1000;
> > +       struct timespec end_time;
> > +       ktime_t expires, *to = NULL;
> > +
> > +       if (timeout > 0) {
> > +               ktime_get_ts(&end_time);
> > +               timespec_add_ns(&end_time, (u64)timeout * NSEC_PER_MSEC);
> > +               slack = estimate_accuracy(&end_time);
> > +               to = &expires;
> > +               *to = timespec_to_ktime(end_time);
> > +       } else if (timeout == 0) {
> > +               timed_out = 1;
> > +       }
> >
> >  retry:
> >        spin_lock_irqsave(&ep->lock, flags);
> > @@ -1149,7 +1150,7 @@ retry:
> >                         * to TASK_INTERRUPTIBLE before doing the checks.
> >                         */
> >                        set_current_state(TASK_INTERRUPTIBLE);
> > -                       if (!list_empty(&ep->rdllist) || !jtimeout)
> > +                       if (!list_empty(&ep->rdllist) || timed_out)
> >                                break;
> >                        if (signal_pending(current)) {
> >                                res = -EINTR;
> > @@ -1157,7 +1158,9 @@ retry:
> >                        }
> >
> >                        spin_unlock_irqrestore(&ep->lock, flags);
> > -                       jtimeout = schedule_timeout(jtimeout);
> > +                       if (!schedule_hrtimeout_range(to, slack, HRTIMER_MODE_ABS))
> > +                               timed_out = 1;
> > +
> >                        spin_lock_irqsave(&ep->lock, flags);
> >                }
> >                __remove_wait_queue(&ep->wq, &wait);
> 
> this code introduces a warning:
> fs/eventpoll.c: In function ‘ep_poll’:
> fs/eventpoll.c:1119: warning: ‘slack’ may be used uninitialized in this function
> 
> looks to me like you arent properly handling negative timeouts.
> certainly epoll_wait() passes the timeout value straight from
> userspace to ep_poll() without any error checking, so if userspace
> passes a negative timeout value, it looks like "slack" will be used
> uninitialized.

If a negative timeout is passed in then 'to' remains NULL.  When 'to
is NULL schedule_hrtimeout_range() has an infinite timeout and the
'slack' parameter is never used.  So technically everything should be
fine here.

Of course it would be safest and best to simply initialize slack to 0.
I can send a patch this evening with the fix.

--
Shawn
