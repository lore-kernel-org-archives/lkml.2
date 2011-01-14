Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753132Ab1ANJcw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 04:32:52 -0500
Received: from mx1.redhat.com ([209.132.183.28]:6446 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751152Ab1ANJcq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 04:32:46 -0500
Message-ID: <4D301A18.1050107@redhat.com>
Date: Fri, 14 Jan 2011 10:40:40 +0100
From: Hans de Goede <hdegoede@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101103 Fedora/1.0-0.33.b2pre.fc14 Lightning/1.0b2 Thunderbird/3.1.6
MIME-Version: 1.0
To: Jesper Juhl <jj@chaosbits.net>
CC: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jean-Francois Moine <moinejf@free.fr>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Lee Jones <lee.jones@canonical.com>
Subject: Re: [PATCH][rfc] media, video, stv06xx, pb0100: Don't potentially
 deref NULL in pb0100_start().
References: <alpine.LNX.2.00.1101132300490.11347@swampdragon.chaosbits.net>
In-Reply-To: <alpine.LNX.2.00.1101132300490.11347@swampdragon.chaosbits.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 01/13/2011 11:05 PM, Jesper Juhl wrote:
> usb_altnum_to_altsetting() may return NULL. If it does we'll dereference a
> NULL pointer in
> drivers/media/video/gspca/stv06xx/stv06xx_pb0100.c::pb0100_start().
> As far as I can tell there's not really anything more sensible than
> -ENODEV that we can return in that situation, but I'm not at all intimate
> with this code so I'd like a bit of review/comments on this before it's
> applied.
> Anyway, here's a proposed patch.
>

Hi,

On 01/13/2011 11:05 PM, Jesper Juhl wrote:
 > usb_altnum_to_altsetting() may return NULL. If it does we'll dereference a
 > NULL pointer in
 > drivers/media/video/gspca/stv06xx/stv06xx_pb0100.c::pb0100_start().
 > As far as I can tell there's not really anything more sensible than
 > -ENODEV that we can return in that situation, but I'm not at all intimate
 > with this code so I'd like a bit of review/comments on this before it's
 > applied.
 > Anyway, here's a proposed patch.
 >

pb0100_start gets called from stv06xx_start, which also does a
usb_altnum_to_altsetting(intf, sd->gspca_dev.alt); and does contain the
NULL check before calling pb0100_start. So I left out the check on purpose,
to keep the code compact in IMHO better readable.

Still I agree this is a bit tricky. So not NACK but not ACK either. What
do others think?

Regards,

Hans


> Signed-off-by: Jesper Juhl<jj@chaosbits.net>
> ---
>   stv06xx_pb0100.c |    2 ++
>   1 file changed, 2 insertions(+)
>
>    compile tested only.
>
> diff --git a/drivers/media/video/gspca/stv06xx/stv06xx_pb0100.c b/drivers/media/video/gspca/stv06xx/stv06xx_pb0100.c
> index ac47b4c..75a5b9c 100644
> --- a/drivers/media/video/gspca/stv06xx/stv06xx_pb0100.c
> +++ b/drivers/media/video/gspca/stv06xx/stv06xx_pb0100.c
> @@ -217,6 +217,8 @@ static int pb0100_start(struct sd *sd)
>
>   	intf = usb_ifnum_to_if(sd->gspca_dev.dev, sd->gspca_dev.iface);
>   	alt = usb_altnum_to_altsetting(intf, sd->gspca_dev.alt);
> +	if (!alt)
> +		return -ENODEV;
>   	packet_size = le16_to_cpu(alt->endpoint[0].desc.wMaxPacketSize);
>
>   	/* If we don't have enough bandwidth use a lower framerate */
>
>
>
