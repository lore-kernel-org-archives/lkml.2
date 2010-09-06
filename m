Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753184Ab0IFXgP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Sep 2010 19:36:15 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:60313 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752356Ab0IFXgK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Sep 2010 19:36:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=hQ7xX9Y/yo7lQhlhmtw/C3hrUeO/AWAVSbsNp/1vx3t8+5e6bxAApG1Kzt+sRNrWl4
         7G+EVaYsXPRxjmXdY/BbvH/WzqXffP/xTZEEMkZi76A6oUgBgkQhU9HnHi/wqvuMNr5F
         QpjHIKalHlhQoGUc4gTYflIwIXfAzXzlhxaaY=
Date: Mon, 6 Sep 2010 16:36:01 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Rafi Rubin <rafi@seas.upenn.edu>
Cc: Jiri Slaby <jirislaby@gmail.com>, jkosina@suse.cz,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        micki@n-trig.com, rydberg@euromail.se, chatty@enac.fr
Subject: Re: [PATCH] identify firmware version
Message-ID: <20100906233601.GA20528@core.coreip.homeip.net>
References: <4C7EB3A3.7050402@gmail.com>
 <1283791362-27780-1-git-send-email-rafi@seas.upenn.edu>
 <20100906194838.GB31384@core.coreip.homeip.net>
 <4C855BAA.4000900@gmail.com>
 <20100906233203.GA18048@seas.upenn.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100906233203.GA18048@seas.upenn.edu>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 06, 2010 at 07:32:03PM -0400, Rafi Rubin wrote:
> On Mon, Sep 06, 2010 at 11:22:50PM +0200, Jiri Slaby wrote:
> > On 09/06/2010 09:48 PM, Dmitry Torokhov wrote:
> > >> @@ -848,10 +871,43 @@ static int ntrig_probe(struct hid_device *hdev, const struct hid_device_id *id)
> > >>  	if (report)
> > >>  		usbhid_submit_report(hdev, report, USB_DIR_OUT);
> > >>  
> > >> +	data = kmalloc(8, GFP_KERNEL);
> > >> +	if (!data) {
> > >> +		ret = -ENOMEM;
> > >> +		goto err_free;
> > >> +	}
> > >> +
> > >> +	ret = usb_control_msg(usb_dev, usb_rcvctrlpipe(usb_dev, 0),
> > >> +			      USB_REQ_CLEAR_FEATURE,
> > >> +			      USB_TYPE_CLASS | USB_RECIP_INTERFACE |
> > >> +			      USB_DIR_IN,
> > >> +			      0x30c, 1, data, 8,
> > >> +			      USB_CTRL_SET_TIMEOUT);
> > >> +
> > >> +	if (ret == 8) {
> > >> +		buf = kmalloc(20, GFP_KERNEL);
> > >> +		if (!buf) {
> > >> +			ret = -ENOMEM;
> > >> +			goto err_free_data;
> > >> +		}
> > > 
> > > Why do you allocate this from heap? Surely we can spare 20 bytes on
> > > stack (you aren't doing DMA into it).
> > 
> > Hi, yeah, I think so too.
> 
> No arguments from me, that was just sloppy.
> 
> > > I'd also split all this code into ntrig_report_version() to simplifu
> > > error handling here.
> > > 
> > >> +
> > >> +		ret = ntrig_version_string(&data[2], buf);
> > >> +
> > >> +		dev_info(&hdev->dev,
> > >> +			 "Firmware version: %s (%02x%02x %02x%02x)\n",
> > >> +			 buf, data[2], data[3], data[4], data[5]);
> > >> +
> > >> +		kfree(buff);
> > 
> > In any case, this doesn't compile...
> > 
> > >> +	}
> 
> Jiri, I moved the code to a separate function as Dmitry suggested, and compiled a kernel from a clean tree using 
> gcc-3.4 (I think).
> 
> If this version fails for you, would you mind being a bit more verbose about the failure.
> 

Looks good to me, thanks for making changes Rafi.

-- 
Dmitry
