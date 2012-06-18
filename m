Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756339Ab2FRJY2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 05:24:28 -0400
Received: from hogsmeade.lieberbiber.de ([217.28.97.4]:49420 "EHLO
	hogsmeade.leitwerk.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752053Ab2FRJY1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 05:24:27 -0400
X-Greylist: delayed 618 seconds by postgrey-1.27 at vger.kernel.org; Mon, 18 Jun 2012 05:24:26 EDT
Date: Mon, 18 Jun 2012 11:14:03 +0200
From: Simon Raffeiner <sturmflut@lieberbiber.de>
To: Hans de Goede <hdegoede@redhat.com>
Cc: Ben Hutchings <ben@decadent.org.uk>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [ 60/69] usb-storage: Add 090c:1000 to unusal-devs
Message-ID: <20120618111403.0da5fbe6@cloud>
In-Reply-To: <4FDEE95A.8050605@redhat.com>
References: <20120617175950.030711074@decadent.org.uk>
	<4FDEE95A.8050605@redhat.com>
Organization: Lieberbiber, Inc.
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I wrote the original bug report for the Feiya QDI U2 DISK (bug 43265)
and can confirm that the bug was introduced with kernel 3.4.

3.2 and 3.3 are unaffected.

regards,
Simon



On Mon, 18 Jun 2012 10:39:54 +0200
Hans de Goede <hdegoede@redhat.com> wrote:

> Hi,
> 
> I'm not sure if this is needed with 3.2, it is needed with 3.4 because
> recently the usb-storage driver was changed to report the supported
> scsi level as reported by the device, rather then always report a
> scsi level of 2. This change causes sd.c to try READ_CAPACITY(16)
> first, which foobars up not only this one device, but as it turns
> out a lot of others too, so we're working on another fix
> (and I believe that 3.2 is unaffected).
> 
> With that said, this patch certainly cannot hurt in any way...
> 
> Regards,
> 
> Hans
> 
> 
> On 06/17/2012 08:00 PM, Ben Hutchings wrote:
> > 3.2-stable review patch.  If anyone has any objections, please let
> > me know.
> >
> > ------------------
> >
> > From: Hans de Goede<hdegoede@redhat.com>
> >
> > commit afff07e61a5243e14ee3f0a272a0380cd744a8a3 upstream.
> >
> > This device gives a bogus answer to get_capacity(16):
> > [ 8628.278614] scsi 8:0:0:0: Direct-Access     USB 2.0  USB Flash
> > Drive  1100 PQ: 0 ANSI: 4 [ 8628.279452] sd 8:0:0:0: Attached scsi
> > generic sg4 type 0 [ 8628.280338] sd 8:0:0:0: [sdd]
> > 35747322042253313 512-byte logical blocks: (18.3 EB/15.8 EiB)
> >
> > So set the quirk flag to avoid using get_capacity(16) with it:
> > [11731.386014] usb-storage 2-1.6:1.0: Quirks match for vid 090c pid
> > 1000: 80000 [11731.386075] scsi9 : usb-storage 2-1.6:1.0
> > [11731.386172] usbcore: registered new interface driver usb-storage
> > [11731.386175] USB Mass Storage support registered.
> > [11732.387394] scsi 9:0:0:0: Direct-Access     USB 2.0  USB Flash
> > Drive  1100 PQ: 0 ANSI: 4 [11732.388462] sd 9:0:0:0: Attached scsi
> > generic sg3 type 0 [11732.389432] sd 9:0:0:0: [sdc] 7975296
> > 512-byte logical blocks: (4.08 GB/3.80 GiB)
> >
> > Which makes the capacity look a lot more sane :)
> >
> > Signed-off-by: Hans de Goede<hdegoede@redhat.com>
> > Tested-by: Simon Raffeiner<sturmflut@lieberbiber.de>
> > Signed-off-by: Greg Kroah-Hartman<gregkh@linuxfoundation.org>
> > Signed-off-by: Ben Hutchings<ben@decadent.org.uk>
> > ---
> >   drivers/usb/storage/unusual_devs.h |    7 +++++++
> >   1 file changed, 7 insertions(+)
> >
> > diff --git a/drivers/usb/storage/unusual_devs.h
> > b/drivers/usb/storage/unusual_devs.h index 1719886..caf22bf 100644
> > --- a/drivers/usb/storage/unusual_devs.h
> > +++ b/drivers/usb/storage/unusual_devs.h
> > @@ -1107,6 +1107,13 @@ UNUSUAL_DEV( 0x090a, 0x1200, 0x0000, 0x9999,
> >   		USB_SC_RBC, USB_PR_BULK, NULL,
> >   		0 ),
> >
> > +/* Feiya QDI U2 DISK, reported by Hans de
> > Goede<hdegoede@redhat.com>  */ +UNUSUAL_DEV( 0x090c, 0x1000,
> > 0x0000, 0xffff,
> > +		"Feiya",
> > +		"QDI U2 DISK",
> > +		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
> > +		US_FL_NO_READ_CAPACITY_16 ),
> > +
> >   /* aeb */
> >   UNUSUAL_DEV( 0x090c, 0x1132, 0x0000, 0xffff,
> >   		"Feiya",
> >
> >

