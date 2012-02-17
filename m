Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755376Ab2BQCHz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 21:07:55 -0500
Received: from mail-qw0-f53.google.com ([209.85.216.53]:38296 "EHLO
	mail-qw0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752723Ab2BQCHy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 21:07:54 -0500
MIME-Version: 1.0
In-Reply-To: <201202162320.44863.rjw@sisk.pl>
References: <201202152318.04206.rjw@sisk.pl>
	<201202152324.08073.rjw@sisk.pl>
	<CAMP5Xgctu7ra6XbgNuTo5uP77otboXmSxAaLHj1uJwiH1+ce9g@mail.gmail.com>
	<201202162320.44863.rjw@sisk.pl>
Date: Thu, 16 Feb 2012 18:07:53 -0800
Message-ID: <CAMP5Xgc5JtqH-PqS9+z1swg9CR5w6Az+_HNyuO9uG9WyGONRaw@mail.gmail.com>
Subject: Re: [PATCH 3/3] PM / Sleep: Make __pm_stay_awake() delete wakeup
 source timers
From: =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux PM list <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/2/16 Rafael J. Wysocki <rjw@sisk.pl>:
> On Thursday, February 16, 2012, Arve Hjønnevåg wrote:
>> 2012/2/15 Rafael J. Wysocki <rjw@sisk.pl>:
>> ...
>> > --- linux.orig/drivers/base/power/wakeup.c
>> > +++ linux/drivers/base/power/wakeup.c
>> > @@ -365,9 +365,15 @@ void __pm_stay_awake(struct wakeup_sourc
>> >                return;
>> >
>> >        spin_lock_irqsave(&ws->lock, flags);
>> > +
>> > +       del_timer(&ws->timer);
>> > +       ws->timer_expires = 0;
>>
>> timer_expires gets overwritten in wakeup_source_activate,
>
> I actually don't remember why it does that and with the $subject changes
> it's just pointless.
>
>> so __pm_relax followed by __pm_stay_awake is still not safe.
>
> Yes, I overlooked that timer_expires modification.  Updated patch follows.
>
>> ...
>> > @@ -529,8 +535,12 @@ void __pm_wakeup_event(struct wakeup_sou
>> >        spin_lock_irqsave(&ws->lock, flags);
>> >
>> >        ws->event_count++;
>> > -       if (!ws->active)
>> > +       if (ws->active) {
>> > +               if (!ws->timer_expires)
>> > +                       goto unlock;
>> > +       } else {
>> >                wakeup_source_activate(ws);
>> > +       }
>> >
>> >        if (!msec) {
>> >                wakeup_source_deactivate(ws);
>> >
>>
>> I suggest dropping this and adding:
>
> Well, what exactly would you like to drop?  The above proposed changes I guess?

Yes.

>
>> -       if (time_after(expires, ws->timer_expires)) {
>> +       if (!ws->timer_expires || time_after(expires, ws->timer_expires)) {
>
> I've tried to follow your suggestion, so that __pm_wakeup_event() always
> sets the timer, if msec is positive, or deactivates the wakeup source, if
> msec is 0.  Please let me know if that's what you wanted. :-)
>

Yes. I should be able to replace a wake_lock with a single wakeup_source now.

-- 
Arve Hjønnevåg
