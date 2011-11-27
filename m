Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755389Ab1K0UIS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Nov 2011 15:08:18 -0500
Received: from static.121.164.40.188.clients.your-server.de ([188.40.164.121]:44729
	"EHLO smtp.eikelenboom.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752167Ab1K0UIR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Nov 2011 15:08:17 -0500
Date: Sun, 27 Nov 2011 21:08:13 +0100
From: Sander Eikelenboom <linux@eikelenboom.it>
Organization: Eikelenboom IT services
X-Priority: 3 (Normal)
Message-ID: <242709247.20111127210813@eikelenboom.it>
To: matthieu castet <castet.matthieu@free.fr>
CC: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: re : 3.2-rc2 regression due to commit "USB: EHCI: fix HUB TT scheduling issue with iso transfer" 811c926c
In-Reply-To: <20111126231304.0bf12f69@mat-laptop>
References: <20111126231304.0bf12f69@mat-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Matthieu,

I can confirm this patch fixes my problem, after testing haven't seen any problems yet.

Thx !

--
Sander



Saturday, November 26, 2011, 11:13:04 PM, you wrote:

> Hi,

> could you try the following patch ?

> It seems there is a flow in the error condition.


> Matthieu


> diff --git a/drivers/usb/host/ehci-sched.c b/drivers/usb/host/ehci-sched.c
> index 56a3203..464b451 100644
> --- a/drivers/usb/host/ehci-sched.c
> +++ b/drivers/usb/host/ehci-sched.c
> @@ -1475,6 +1475,7 @@ iso_stream_schedule (
>          * jump until after the queue is primed.
>          */
>         else {
> +               int done = 0;
>                 start = SCHEDULE_SLOP + (now & ~0x07);
>  
>                 /* NOTE:  assumes URB_ISO_ASAP, to limit complexity/bugs */
> @@ -1491,19 +1492,23 @@ iso_stream_schedule (
>                         /* check schedule: enough space? */
>                         if (stream->highspeed) {
>                                 if (itd_slot_ok(ehci, mod, start,
> -                                               stream->usecs, period))
> +                                               stream->usecs, period)) {
> +                                       done = 1;
>                                         break;
> +                               }
>                         } else {
>                                 if ((start % 8) >= 6)
>                                         continue;
>                                 if (sitd_slot_ok(ehci, mod, stream,
> -                                               start, sched, period))
> +                                               start, sched, period)) {
> +                                       done = 1;
>                                         break;
> +                               }
>                         }
>                 } while (start > next);
>  
>                 /* no room in the schedule */
> -               if (start == next) {
> +               if (!done) {
>                         ehci_dbg(ehci, "iso resched full %p (now %d max %d)\n",
>                                 urb, now, now + mod);
>                         status = -ENOSPC;



-- 
Best regards,
 Sander                            mailto:linux@eikelenboom.it

