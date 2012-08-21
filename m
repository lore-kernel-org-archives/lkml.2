Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756883Ab2HULFv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 07:05:51 -0400
Received: from na3sys009aog116.obsmtp.com ([74.125.149.240]:58154 "EHLO
	na3sys009aog116.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756838Ab2HULFs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 07:05:48 -0400
MIME-Version: 1.0
In-Reply-To: <20120821105702.GX10347@arwen.pp.htv.fi>
References: <1345540555-24359-1-git-send-email-balbi@ti.com>
 <1345540555-24359-11-git-send-email-balbi@ti.com> <CAMQu2gzm4z8DbCiz4hOS2nKa2HzNofmp=SPORYEu2Z_H3+JN9Q@mail.gmail.com>
 <20120821105702.GX10347@arwen.pp.htv.fi>
From: "Shilimkar, Santosh" <santosh.shilimkar@ti.com>
Date: Tue, 21 Aug 2012 16:35:26 +0530
Message-ID: <CAMQu2gzJ2YksrJKPLNZ9pBoBoSih2Up=isca=X9Wsd5MsnNrTQ@mail.gmail.com>
Subject: Re: [RFC/PATCH 10/13] serial: omap: stick to put_autosuspend
To: balbi@ti.com
Cc: alan@linux.intel.com, Tony Lindgren <tony@atomide.com>,
        Kevin Hilman <khilman@ti.com>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>,
        linux-serial@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Shubhrajyoti Datta <shubhrajyoti@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 21, 2012 at 4:27 PM, Felipe Balbi <balbi@ti.com> wrote:
> On Tue, Aug 21, 2012 at 04:12:11PM +0530, Shilimkar, Santosh wrote:
>> On Tue, Aug 21, 2012 at 2:45 PM, Felipe Balbi <balbi@ti.com> wrote:
>> > Everytime we're done using our TTY, we want
>> > the pm timer to be reinitilized. By sticking
>> > to pm_runtime_pm_autosuspend() we make sure
>> > that this will always be the case.
>> >
>> > Signed-off-by: Felipe Balbi <balbi@ti.com>
>> > ---
>> >  drivers/tty/serial/omap-serial.c | 33 ++++++++++++++++++++++-----------
>> >  1 file changed, 22 insertions(+), 11 deletions(-)
>> >
>> > diff --git a/drivers/tty/serial/omap-serial.c b/drivers/tty/serial/omap-serial.c
>> > index 6ea24c5..458d77c 100644
>> > --- a/drivers/tty/serial/omap-serial.c
>> > +++ b/drivers/tty/serial/omap-serial.c
>> > @@ -164,7 +164,8 @@ static void serial_omap_enable_ms(struct uart_port *port)
>> >         pm_runtime_get_sync(up->dev);
>> >         up->ier |= UART_IER_MSI;
>> >         serial_out(up, UART_IER, up->ier);
>> > -       pm_runtime_put(up->dev);
>> > +       pm_runtime_mark_last_busy(up->dev);
>> > +       pm_runtime_put_autosuspend(up->dev);
>> >  }
>> >
>> Can you please expand the change-log a bit ?
>> Didn't follow the time re-init part completely.
>
> It's really just a micro-optimization. The thing is:
>
> if I call pm_runtime_put(), I will not reinitialize the pm timer to
> whatever timeout value I used. This means that pm_runtime_put() could
> actually execute right away (if timer was about to expire when I called
> pm_runtime_put()). While this wouldn't cause any issues, it's better to
> reinitialize the timer and make sure if there's another
> read/write/set_termios/whatever coming right after this, UART is still
> powered up.
>
> I mean, it's really just trying to avoid context save & restore when
> UART is still under heavy usage.
>
> Does it make sense ?

It does. Would be good to add the above description in the change-log.
Thanks for clarification.

Regars
Santosh
