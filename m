Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756641Ab2BPEz5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 23:55:57 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:48910 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754816Ab2BPEzz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 23:55:55 -0500
MIME-Version: 1.0
In-Reply-To: <201202152324.08073.rjw@sisk.pl>
References: <201202152318.04206.rjw@sisk.pl>
	<201202152324.08073.rjw@sisk.pl>
Date: Wed, 15 Feb 2012 20:55:54 -0800
Message-ID: <CAMP5Xgctu7ra6XbgNuTo5uP77otboXmSxAaLHj1uJwiH1+ce9g@mail.gmail.com>
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

2012/2/15 Rafael J. Wysocki <rjw@sisk.pl>:
...
> --- linux.orig/drivers/base/power/wakeup.c
> +++ linux/drivers/base/power/wakeup.c
> @@ -365,9 +365,15 @@ void __pm_stay_awake(struct wakeup_sourc
>                return;
>
>        spin_lock_irqsave(&ws->lock, flags);
> +
> +       del_timer(&ws->timer);
> +       ws->timer_expires = 0;

timer_expires gets overwritten in wakeup_source_activate, so
__pm_relax followed by __pm_stay_awake is still not safe.



...
> @@ -529,8 +535,12 @@ void __pm_wakeup_event(struct wakeup_sou
>        spin_lock_irqsave(&ws->lock, flags);
>
>        ws->event_count++;
> -       if (!ws->active)
> +       if (ws->active) {
> +               if (!ws->timer_expires)
> +                       goto unlock;
> +       } else {
>                wakeup_source_activate(ws);
> +       }
>
>        if (!msec) {
>                wakeup_source_deactivate(ws);
>

I suggest dropping this and adding:

-       if (time_after(expires, ws->timer_expires)) {
+       if (!ws->timer_expires || time_after(expires, ws->timer_expires)) {



-- 
Arve Hjønnevåg
