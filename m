Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752342Ab0LJGTJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Dec 2010 01:19:09 -0500
Received: from mail-fx0-f43.google.com ([209.85.161.43]:38254 "EHLO
	mail-fx0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750895Ab0LJGTI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Dec 2010 01:19:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=FwzXSRpONzbpUzWNn2Unv6DRe8xi5bX7k1debXE3FwYL0q3TMCS/tX4rFYKTrqpBVs
         QSsBpBlJD5aeiuyaBaL9edtci9J720TaQMmhNj2OgEUeNQ73i4Vdeavh5E/RB4/AheAF
         qOcGp9OEnSC4hwv9L8tK9+KeAPLz/gXYtmG50=
MIME-Version: 1.0
In-Reply-To: <201011180919.23001.hverkuil@xs4all.nl>
References: <1289913494-21590-1-git-send-email-manjunatha_halli@ti.com>
 <1289913494-21590-3-git-send-email-manjunatha_halli@ti.com>
 <1289913494-21590-4-git-send-email-manjunatha_halli@ti.com> <201011180919.23001.hverkuil@xs4all.nl>
From: halli manjunatha <manjunatha_halli@ti.com>
Date: Fri, 10 Dec 2010 11:48:45 +0530
X-Google-Sender-Auth: YkG_0RH0rNHCJ8cQrKzQAAxWUBg
Message-ID: <AANLkTik08q3Fz4m8jZRR4+wEihyYXr+6uQecZ36EV-AD@mail.gmail.com>
Subject: Re: [PATCH v4 3/6] drivers:staging: ti-st: fmdrv_common sources
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: mchehab@infradead.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hans,

On Thu, Nov 18, 2010 at 1:49 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
>
> >
> > These are the sources for the common interfaces required by the FM
> > V4L2 driver for TI WL127x and WL128x chips.
> >
<snip...>
>
> OK, I think the way interrupts are handled should be revamped. It is way too
> complex IMHO. All these action/response handlers have a similar structure,
> particularly for the response handlers as this part of the code is the same
> for all as far as I can tell:
>
>        del_timer(&fmdev->irq_info.int_timeout_timer);
>
>        ret = __check_cmdresp_status(fmdev, &skb);
>        if (ret < 0) {
>                pr_err("(fmdrv): Initiating irq recovery process\n");
>                mod_timer(&fmdev->irq_info.int_timeout_timer, jiffies +
>                          FM_DRV_TX_TIMEOUT);
>                return;
>        }
>
> What I think should happen is that rather than having each handler chain the
> other there is one core handler that is taking care of that. So the boilerplate
> code is in that core handler and it is calling the other handlers. So e.g. the
> hw_malfunction handler below could become something like this:
>
> static int fm_irq_handle_hw_malfunction(struct fmdrv_ops *fmdev, unsigned events)
> {
>        if (!(events & FM_MAL_EVENT))
>                pr_err("(fmdrv): irq: HW MAL int received - do nothing\n");
>        return FM_RDS_START_INDEX;
> }
>
> And unsigned events is set to fmdev->irq_info.flag & fmdev->irq_info.mask.
>
> This would refactor out a lot of code.

I tried out similar ways of handling interrupts and also tried out
having a single unified
interrupt handler/core handler and branching out onto various handlers
based on the
events received.
However, the way chip tends to send interrupts is slightly more complex here.

We have cases where 2 or more events are combined together which would
cause the FM interrupt, So when I do a FLAG_GET to request the cause
of interrupt, I will have to always check for each of the individual
bits (13 bits...)
More over when a bit is set say, RDS, and I am in the middle of doing
a GET_RDS, I have more interrupts coming in, which requires me to do a
FLAG_GET (generally a lot of low rssi, stereo/mono events..)

So at the moment all we can do is push the following into a function
and thereby reduce a bit of code size - But not complexity.

>        del_timer(&fmdev->irq_info.int_timeout_timer);
>
>        ret = __check_cmdresp_status(fmdev, &skb);
>        if (ret < 0) {
>                pr_err("(fmdrv): Initiating irq recovery process\n");
>                mod_timer(&fmdev->irq_info.int_timeout_timer, jiffies +
>                          FM_DRV_TX_TIMEOUT);
>                return;
>        }

So, Please suggest on how best such situation where multiple events
have caused 1 interrupt
can be handled ?

example:
After checking HW_MAL function, I begin to check for RDS - this is
where the handler branches out,

check hw malfunction
    |
check rds-----------------
    |                          |
  <true>               <false>--- check for tune_op_ended ---- check
for Tx power enabled
    |
send rds get command
    |
rds data response
    |
rds finish ------------ check for tune_op_ended.------- check for Tx
power enabled...

regards,
Manjunatha,

> > +static void fm_irq_handle_hw_malfunction(void *arg)
> > +{
> > +     struct fmdrv_ops *fmdev;
> > +
> > +     fmdev = arg;
> > +     if (fmdev->irq_info.flag & FM_MAL_EVENT & fmdev->irq_info.mask)
> > +             pr_err("(fmdrv): irq: HW MAL int received - do nothing\n");
> > +
> > +     /* Continue next function in interrupt handler table */
> > +     fmdev->irq_info.stage_index = FM_RDS_START_INDEX;
> > +     fmdev->irq_info.fm_int_handlers[fmdev->irq_info.stage_index](fmdev);
> > +}
>
> Regards,
>
>        Hans
>
> --
> Hans Verkuil - video4linux developer - sponsored by Cisco
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
