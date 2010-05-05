Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758373Ab0EETSB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 15:18:01 -0400
Received: from legolas.restena.lu ([158.64.1.34]:40514 "EHLO
	legolas.restena.lu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758393Ab0EETR7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 15:17:59 -0400
Date: Wed, 5 May 2010 21:17:42 +0200
From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Oliver Neukum <oneukum@suse.de>, linux-pm@lists.linux-foundation.org,
       list <linux-usb@vger.kernel.org>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [linux-pm] s2ram slow (radeon) / failing (usb)
Message-ID: <20100505211742.1cb4e448@neptune.home>
In-Reply-To: <alpine.LNX.2.00.1005051457460.9849@pobox.suse.cz>
References: <20100503214642.67577f91@neptune.home>
	<20100503225735.6b5e2687@neptune.home>
	<20100503231154.486c27d6@neptune.home>
	<201005040842.35260.oneukum@suse.de>
	<alpine.LNX.2.00.1005041028300.9849@pobox.suse.cz>
	<20100504230415.6097a767@neptune.home>
	<alpine.LNX.2.00.1005051457460.9849@pobox.suse.cz>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 05 May 2010 Jiri Kosina <jkosina@suse.cz> wrote:

> On Tue, 4 May 2010, Bruno Prémont wrote:
> 
> > > Bruno, could you, for testing purposes, check, whether the patch below 
> > > changes the behavior you are seeing (and also check what the actual return 
> > > value from device_add() was, see the added printk()).
> > 
> > Well, it's said to return 0:
> > 
> > [  286.872739] generic-usb 0003:058F:9462.0003: input: USB HID v1.10 Keyboard [Multimedia USB Keyboard Multimedia USB Keyboard] on usb-0000:00:13.0-2.1/input0
> > [  286.890136] HID: device_add() returned 0
> > 
> > [  286.919698] generic-usb: probe of 0003:058F:9462.0004 failed with error -22
> > [  286.929363] HID: device_add() returned 0
> > 
> > or with debug=1 for HID:
> > [  559.982958] /usr/src/linux-2.6-git/drivers/hid/usbhid/hid-core.c: HID probe called for ifnum 1
> > [  560.011698] /usr/src/linux-2.6-git/drivers/hid/hid-core.c: usage index exceeded
> > [  560.011704] /usr/src/linux-2.6-git/drivers/hid/hid-core.c: hid_add_usage failed
> > [  560.011710] /usr/src/linux-2.6-git/drivers/hid/hid-core.c: item 0 2 2 2 parsing failed
> > [  560.011732] /usr/src/linux-2.6-git/drivers/hid/usbhid/hid-core.c: parsing report descriptor failed
> > [  560.011747] generic-usb: probe of 0003:058F:9462.0006 failed with error -22
> > [  560.021718] HID: device_add() returned 0
> 
> Could you please verify with this patch? Thanks.

No difference, the second interface remains registered with HID bus
and I don't spot any difference in kernel log.

Going to have a look at what probe exactly it's that returns -EINVAL
and then attempt to unroll it up to device_add() ...
Hopefully I will find the function that does not hand back the failure.

Thanks,
Bruno

>  drivers/hid/hid-core.c |    4 +++-
>  1 files changed, 3 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
> index 2e2aa75..8df19d3 100644
> --- a/drivers/hid/hid-core.c
> +++ b/drivers/hid/hid-core.c
> @@ -1486,8 +1486,10 @@ static int hid_device_probe(struct device *dev)
>  			if (!ret)
>  				ret = hid_hw_start(hdev, HID_CONNECT_DEFAULT);
>  		}
> -		if (ret)
> +		if (ret) {
>  			hdev->driver = NULL;
> +			ret = -ENODEV;
> +		}
>  	}
>  	return ret;
>  }
> 
