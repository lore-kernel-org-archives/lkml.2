Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758667Ab1COVqq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 17:46:46 -0400
Received: from ist.d-labs.de ([213.239.218.44]:34030 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756163Ab1COVqo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 17:46:44 -0400
Date: Tue, 15 Mar 2011 22:46:41 +0100
From: Florian Mickler <florian@mickler.org>
To: Malcolm Priestley <tvboxspy@gmail.com>
Cc: mchehab@infradead.org, oliver@neukum.org, jwjstone@fastmail.fm,
        linux-kernel@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        linux-media@vger.kernel.org
Subject: Re: [PATCH 12/16] [media] lmedm04: get rid of on-stack dma buffers
Message-ID: <20110315224641.4e088082@schatten.dmk.lab>
In-Reply-To: <1300222483.1910.12.camel@localhost>
References: <20110315093632.5fc9fb77@schatten.dmk.lab>
	<1300178655-24832-1-git-send-email-florian@mickler.org>
	<1300178655-24832-12-git-send-email-florian@mickler.org>
	<1300222483.1910.12.camel@localhost>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Mar 2011 20:54:43 +0000
Malcolm Priestley <tvboxspy@gmail.com> wrote:

> The patch failed for the following reason.
> 
> On Tue, 2011-03-15 at 09:43 +0100, Florian Mickler wrote:
> > usb_control_msg initiates (and waits for completion of) a dma transfer using
> > the supplied buffer. That buffer thus has to be seperately allocated on
> > the heap.
> > 
> > In lib/dma_debug.c the function check_for_stack even warns about it:
> > 	WARNING: at lib/dma-debug.c:866 check_for_stack
> > 
> > Note: This change is tested to compile only, as I don't have the hardware.
> > 
> > Signed-off-by: Florian Mickler <florian@mickler.org>
> > ---
> >  drivers/media/dvb/dvb-usb/lmedm04.c |   16 +++++++++++++---
> >  1 files changed, 13 insertions(+), 3 deletions(-)
> > 
> > diff --git a/drivers/media/dvb/dvb-usb/lmedm04.c b/drivers/media/dvb/dvb-usb/lmedm04.c
> > index 0a3e88f..bec5439 100644
> > --- a/drivers/media/dvb/dvb-usb/lmedm04.c
> > +++ b/drivers/media/dvb/dvb-usb/lmedm04.c
> > @@ -314,12 +314,17 @@ static int lme2510_int_read(struct dvb_usb_adapter *adap)
> >  static int lme2510_return_status(struct usb_device *dev)
> >  {
> >  	int ret = 0;
> > -	u8 data[10] = {0};
> > +	u8 *data;
> > +
> > +	data = kzalloc(10, GFP_KERNEL);
> > +	if (!data)
> > +		return -ENOMEM;
> >  
> >  	ret |= usb_control_msg(dev, usb_rcvctrlpipe(dev, 0),
> >  			0x06, 0x80, 0x0302, 0x00, data, 0x0006, 200);
> >  	info("Firmware Status: %x (%x)", ret , data[2]);
> >  
> > +	kfree(data);
> >  	return (ret < 0) ? -ENODEV : data[2];
> 
> data has been killed off when we need the buffer contents.
> changing to the following fixed.
> 
> 	ret = (ret < 0) ? -ENODEV : data[2];
> 
> 	kfree(data);
> 
> 	return ret;

Yes. Thanks. I updated the patch locally. 

> 
> > @@ -603,7 +608,7 @@ static int lme2510_download_firmware(struct usb_device *dev,
> >  					const struct firmware *fw)
> >  {
> >  	int ret = 0;
> > -	u8 data[512] = {0};
> > +	u8 *data;
> >  	u16 j, wlen, len_in, start, end;
> >  	u8 packet_size, dlen, i;
> >  	u8 *fw_data;
> > @@ -611,6 +616,11 @@ static int lme2510_download_firmware(struct usb_device *dev,
> >  	packet_size = 0x31;
> >  	len_in = 1;
> >  
> > +	data = kzalloc(512, GFP_KERNEL);
> > +	if (!data) {
> > +		info("FRM Could not start Firmware Download (Buffer allocation failed)");
> 
> Longer than 80 characters, 

I choose to ignore this warning to keep the string on one line (for
grep and co).

> > +		return -ENOMEM;
> > +	}
> >  
> >  	info("FRM Starting Firmware Download");
> >  
> > @@ -654,7 +664,7 @@ static int lme2510_download_firmware(struct usb_device *dev,
> >  	else
> >  		info("FRM Firmware Download Completed - Resetting Device");
> >  
> > -
> > +	kfree(data);
> >  	return (ret < 0) ? -ENODEV : 0;
> >  }
> >  
> 
> Otherwise the patch as corrected has been put on test. No initial
> problems have been encountered.
> 
> Regards 
> 
> Malcolm
> 

Thanks. I added a 
Tested-by: Malcolm Priestley <tvboxspy@gmail.com>,
if that is ok?

Do you know how often/when is the .identify_state callback called during
normal operation? I.e. is this memory allocation/deallocation
in lme2510_return_status happening often and should use a preallocated
buffer?

Regards,
Flo
