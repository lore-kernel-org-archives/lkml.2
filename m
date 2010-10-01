Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756688Ab0JANa2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Oct 2010 09:30:28 -0400
Received: from cantor2.suse.de ([195.135.220.15]:47340 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756274Ab0JANa0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Oct 2010 09:30:26 -0400
Date: Fri, 1 Oct 2010 15:30:21 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Antonio Ospite <ospite@studenti.unina.it>
Cc: Alan Ott <alan@signal11.us>,
        Stefan Achatz <erazor_de@users.sourceforge.net>,
        Alexey Dobriyan <adobriyan@gmail.com>, Tejun Heo <tj@kernel.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Marcel Holtmann <marcel@holtmann.org>,
        Stephane Chatty <chatty@enac.fr>, Michael Poole <mdpoole@troilus.org>,
        "David S. Miller" <davem@davemloft.net>,
        Bastien Nocera <hadess@hadess.net>,
        Eric Dumazet <eric.dumazet@gmail.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v4 1/2] HID: Add Support for Setting and Getting Feature
 Reports from hidraw
In-Reply-To: <20100928153011.32750e5d.ospite@studenti.unina.it>
Message-ID: <alpine.LNX.2.00.1010011529460.29535@pobox.suse.cz>
References: <1281442367.12579.206.camel@localhost.localdomain> <1281990059-3562-2-git-send-email-alan@signal11.us> <20100928153011.32750e5d.ospite@studenti.unina.it>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 28 Sep 2010, Antonio Ospite wrote:

> Hi Alan, I am doing some stress testing on hidraw, if I have a loop with
> HIDIOCGFEATURE on a given report and I disconnect the device while the
> loop is running I get this:
> 
> BUG: unable to handle kernel NULL pointer dereference at 0000000000000028
> IP: [<ffffffffa02c66b4>] hidraw_ioctl+0xfc/0x32c [hid]
> 
> Full log attached along with the test program, the device is a Sony PS3
> Controller (sixaxis).
> 
> If my objdump analysis is right, hidraw_ioctl+0xfc should be around line
> 361 in hidraw.c (with your patch applied):
> 
> struct hid_device *hid = dev->hid;
> 
> It looks like 'dev' (which is hidraw_table[minor]) can be NULL
> sometimes, can't it?
> This is not introduced by your changes tho.
> 
> Just as a side note, the bug does not show up if the userspace program
> handles return values properly and exits as soon as it gets an error
> from the HID layer, see the XXX comment in test_hidraw_feature.c.
> 
> This fixes it, if it looks ok I will resend the patch rebased on
> mainline code:
> 
> diff --git a/drivers/hid/hidraw.c b/drivers/hid/hidraw.c
> index 7df1310..3c040c6 100644
> --- a/drivers/hid/hidraw.c
> +++ b/drivers/hid/hidraw.c
> @@ -322,6 +322,10 @@ static long hidraw_ioctl(struct file *file, unsigned int cmd,
> 
>         mutex_lock(&minors_lock);
>         dev = hidraw_table[minor];
> +       if (!dev) {
> +               ret = -ENODEV;
> +               goto out;
> +       }
> 
>         switch (cmd) {
>                 case HIDIOCGRDESCSIZE:
> @@ -412,6 +416,7 @@ static long hidraw_ioctl(struct file *file, unsigned int cmd,
> 
>                 ret = -ENOTTY;
>         }
> +out:
>         mutex_unlock(&minors_lock);
>         return ret;
>  }

Yes, this patch makes sense even for current mainline code. Could you 
please resend it to me with Signed-off-by: and changelog text, so that I 
could apply it?

Thanks!

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
