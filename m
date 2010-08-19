Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752317Ab0HSXCH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Aug 2010 19:02:07 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:45824 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751283Ab0HSXCF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Aug 2010 19:02:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :content-type:content-transfer-encoding;
        b=OGZEqsNPajCvo7HoMa5PzabHfzkHAPGlTRn54ABvZPY2ScHJsP5E4A/NmvYdH4B106
         Kib5aHN72eFp1Kdchk4JFzeCQcWEV7JSg5hXFAHhODgT7FbZsKpHqHqyofUboWKifzrA
         kbJqKnyq6HXvEmD4QK2aelHdnUQgtSBOlU1PM=
MIME-Version: 1.0
In-Reply-To: <20100819144620.e078fbbe.akpm@linux-foundation.org>
References: <281434.37339.qm@web65616.mail.ac4.yahoo.com> <20100819144620.e078fbbe.akpm@linux-foundation.org>
From: Stephen Pape <srpape@gmail.com>
Date: Thu, 19 Aug 2010 19:01:44 -0400
Message-ID: <AANLkTi=qVaz68ozjV-BtFCZBi6JvfM-wmqugYzoVfh1e@mail.gmail.com>
Subject: Re: [PATCH 001/001] USB: ftdi_sio: fix endianess of max packet size
To: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I guess you're right about it not being used very often on big endian machines.

The original bug report is here: https://dev.openwrt.org/ticket/7365

>From the user's point of view, priv->max_packet_size would get set to
0x0020 instead of 0x0200, so a message would print saying "Setting
MaxPacketSize 2" when it should be 512. After that you couldn't get
any data from the serial port, because priv->max_packet_size is used
in other sections of the code.

-Stephen

On Thu, Aug 19, 2010 at 5:46 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
>
> On Wed, 18 Aug 2010 07:14:37 -0700 (PDT)
> Michael Wileczka <mikewileczka@yahoo.com> wrote:
>
> > From: Michael Wileczka <mikewileczka@yahoo.com>
> >
> > The USB max packet size (always little-endian) was not being byte swapped on big-endian systems.
> > Created with 2.6.32.16
> > Applicable since [USB: ftdi_sio: fix hi-speed device packet size calculation] approx 2.6.31
> >
> > Signed-off-by: Michael Wileczka <mikewileczka@yahoo.com>
> > ---
> > --- a/drivers/usb/serial/ftdi_sio.c
> > +++ b/drivers/usb/serial/ftdi_sio.c
> > @@ -1397,7 +1397,7 @@ static void ftdi_set_max_packet_size(str
> >       }
> >
> >       /* set max packet size based on descriptor */
> > -     priv->max_packet_size = ep_desc->wMaxPacketSize;
> > +     priv->max_packet_size = le16_to_cpu(ep_desc->wMaxPacketSize);
> >
> >       dev_info(&udev->dev, "Setting MaxPacketSize %d\n", priv->max_packet_size);
> >  }
>
> So I guess nobody noticed this because the driver deosn't get used on
> big-endian machines a lot?
>
> What are the user-visible effects of this bug?
> --
> To unsubscribe from this list: send the line "unsubscribe linux-usb" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
