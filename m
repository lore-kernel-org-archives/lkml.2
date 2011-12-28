Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754143Ab1L1Qth (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Dec 2011 11:49:37 -0500
Received: from senator.holtmann.net ([87.106.208.187]:57119 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754019Ab1L1Qte (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Dec 2011 11:49:34 -0500
Message-ID: <1325090923.1965.282.camel@aeonflux>
Subject: Re: [bluetooth] linux-3.x regression (bisected)
From: Marcel Holtmann <marcel@holtmann.org>
To: Gustavo Padovan <padovan@profusion.mobi>
Cc: Rene Herman <rene.herman@gmail.com>,
        Andre Guedes <andre.guedes@openbossa.org>,
        linux-kernel@vger.kernel.org, linux-bluetooth@vger.kernel.org
Date: Wed, 28 Dec 2011 08:48:43 -0800
In-Reply-To: <20111228155225.GA23292@joana>
References: <4EF3BACA.1080405@gmail.com>
	 <CACJA=fVezGGcgAtbzG=+ouWq0PiHbgXN1YPwL+VDUphWS7wnrw@mail.gmail.com>
	 <4EFA1EB8.9090005@gmail.com> <20111227203008.GA13870@joana>
	 <4EFA447C.3030906@gmail.com> <20111228012248.GC13870@joana>
	 <20111228012850.GD13870@joana> <4EFA7696.6060506@gmail.com>
	 <20111228155225.GA23292@joana>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2 (3.2.2-1.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Gustavo,

> > >>For some reason your adapter is returning here the same value of
> > >>Read Local Features. I would say your device is broken.  The only
> > >>fix I have in mind now is throw away the device.
> > >
> > >Yes, I have one of these ISSC devices, it's completely broken
> > >device.
> > 
> > It worked well upto and including 2.6.29 though.
> 
> We never used Extended Features before 2.6.39
> 
> > 
> > This would seem to be the kind of thing other subsystems use quirk
> > handling for. The device identifies itself as "1131:1004":
> > 
> > Bus 002 Device 002: ID 1131:1004 Integrated System Solution Corp.
> > Bluetooth Device
> > 
> > Do you guys have infra-structure in place for adapter-specific
> > (quitk) handling?
> 
> I think this patch can do handling, let's see what others think.
> 
> 	Gustavo
> 
> 
> ---
> Author: Gustavo F. Padovan <padovan@profusion.mobi>
> Date:   Wed Dec 28 13:40:02 2011 -0200
> 
>     Bluetooth: Fix lmp_host_le_capable() check for broken devices
>     
>     Some dongles reports a wrong Local Extended Features leading the kernel
>     think that dongle support LE while it don't.
>     
>     The fix here is just rely on a bit in Local Features (LE Capable) to tell
>     us if the device really supports LE.
>     
>     LE Host Capable is the only bit used from Local Extended Features in our
>     kernel.
>     
>     Signed-off-by: Gustavo F. Padovan <padovan@profusion.mobi>
> 
> diff --git a/include/net/bluetooth/hci_core.h b/include/net/bluetooth/hci_core.h
> index 5e2e984..c693111 100644
> --- a/include/net/bluetooth/hci_core.h
> +++ b/include/net/bluetooth/hci_core.h
> @@ -676,7 +676,11 @@ void hci_conn_del_sysfs(struct hci_conn *conn);
>  #define lmp_le_capable(dev)        ((dev)->features[4] & LMP_LE)
>  
>  /* ----- Extended LMP capabilities ----- */
> -#define lmp_host_le_capable(dev)   ((dev)->extfeatures[0] & LMP_HOST_LE)
> +/* Some crap dongles does not report a proper Local Extended Features causing

the page 1 is called host features and not local extended features.

> + * the kernel to wrongly init it as a LE device. So first check if it is LE
> + * capable (controller) which is a info from the Local Features */
> +#define lmp_host_le_capable(dev)    ( lmp_le_capable(dev) && \
> +                                       (dev)->extfeatures[0] & LMP_HOST_LE)

< HCI Command: Read Local Extended Features (0x04|0x0004) plen 1
     page 1
> HCI Event: Command Complete (0x0e) plen 14
     Read Local Extended Features (0x04|0x0004) ncmd 1
     status 0x00 page 0 max 0
     Features: 0xff 0xfe 0xff 0x7e 0x98 0x19 0x00 0x80

And this is correct. Page 0 is the same as local features. Storing this
as page 1 is the issue here. We request page 1, but we are getting page
0 instead. So yes, the controller is broken, but not as broken as it
gets us false information. We are just getting different information
than we requested. And we are being stupid here.

Here is the original patch that introduced this behavior:

commit 971e3a4bbcbf7378315b85150853d86be59cffe0
Author: Andre Guedes <andre.guedes@openbossa.org>
Date:   Thu Jun 30 19:20:52 2011 -0300

    Bluetooth: Add extfeatures to struct hci_dev

And even here we should have called this hostfeatures since that is what
page 1 really is.

The correct patch would be something like this:

diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
index 919e3c0..b6eb9c5 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -711,7 +711,8 @@ static void hci_cc_read_local_ext_features(struct hci_dev *h
        if (rp->status)
                return;
 
-       memcpy(hdev->extfeatures, rp->features, 8);
+       if (rp->page == 1)
+               memcpy(hdev->extfeatures, rp->features, 8);
 
        hci_req_complete(hdev, HCI_OP_READ_LOCAL_EXT_FEATURES, rp->status);
 }

The current patch is actually fully broken anyway. So besides switching
LE on when requesting page 0, you will also switch it off when
requesting any other page and it accidentally returns 0x00 since we
unconditionally overwrite it.

Regards

Marcel


