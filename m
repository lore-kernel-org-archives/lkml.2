Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754812Ab1L2W4G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Dec 2011 17:56:06 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:32887 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754747Ab1L2W4D convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Dec 2011 17:56:03 -0500
MIME-Version: 1.0
In-Reply-To: <20111226213140.0308612f@fido5>
References: <20111226213140.0308612f@fido5>
Date: Thu, 29 Dec 2011 23:56:02 +0100
Message-ID: <CACPM=kX5xDOwb4Q9d33R0kpG1vED0mQgY+EBO93+-=gVSP0Wig@mail.gmail.com>
Subject: Re: Linux 3.1.5/6 regression: fails to resume from suspend (bisected)
From: Bjarke Istrup Pedersen <gurligebis@gmail.com>
To: Philip Langdale <philipl@overt.org>
Cc: linux-kernel@vger.kernel.org, gregkh@suse.de, tglx@linutronix.de
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/12/27 Philip Langdale <philipl@overt.org>:
> Hi,
>
> After upgrading to 3.1.5, and still in 3.1.6, I found myself unable to
> resume from suspend. I did a bisect and identified the following change
> as the cause:

Hey,

I can confirm this breaks things.
My router box (a Soekris net5011-70) is unable to boot with this patch
applied (it hangs when control is passed onto init, with the text
"INIT:").
Reverting this patch makes it boot fine.

/Bjarke

> commit aeed6baa702a285cf03b7dc4182ffc1a7f4e4ed6
> Author: Thomas Gleixner <tglx@linutronix.de>
> Date:   Fri Dec 2 16:02:45 2011 +0100
>
>    clockevents: Set noop handler in clockevents_exchange_device()
>
>    commit de28f25e8244c7353abed8de0c7792f5f883588c upstream.
>
>    If a device is shutdown, then there might be a pending interrupt,
>    which will be processed after we reenable interrupts, which causes
>    the original handler to be run. If the old handler is the
>    (broadcast) periodic handler the shutdown state might hang the
>    kernel completely.
>    Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
>    Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
>
> diff --git a/kernel/time/clockevents.c b/kernel/time/clockevents.c
> index e4c699d..13dfaab 100644
> --- a/kernel/time/clockevents.c
> +++ b/kernel/time/clockevents.c
> @@ -286,6 +286,7 @@ void clockevents_exchange_device(struct
> clock_event_device *old,
>         * released list and do a notify add later.
>         */
>        if (old) {
> +               old->event_handler = clockevents_handle_noop;
>                clockevents_set_mode(old, CLOCK_EVT_MODE_UNUSED);
>                list_del(&old->list);
>                list_add(&old->list, &clockevents_released);
>
> If I undo this change in my 3.1.6 tree, I am then able to resume as
> before.
>
> This was also reported upstream at fedora but was not fully
> diagnosed:
>
> https://bugzilla.redhat.com/show_bug.cgi?id=767248
>
> I wouldn't be surprised if it's related to the nvidia binary drivers
> in some way (I use them and so does the fedora bug reporter), but it's
> not practical to avoid them.
>
> --phil
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
