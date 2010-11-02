Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755551Ab0KBDqo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 23:46:44 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:42882 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755324Ab0KBDqm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 23:46:42 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Daniel J Blueman <daniel.blueman@gmail.com>
Subject: Re: [2.6.37-rc1, patch v2] r8169: fix sleeping while holding spinlock...
Date: Tue, 2 Nov 2010 04:45:23 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.36-rjw+; KDE/4.4.4; x86_64; ; )
Cc: Francois Romieu <romieu@fr.zoreil.com>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Kernel <linux-kernel@vger.kernel.org>
References: <AANLkTimZvwdY8Q+=iGMC2MhPt_Vow38a0SE9g4ij-cRe@mail.gmail.com> <20101101234630.GA12106@electric-eye.fr.zoreil.com> <AANLkTinzQGzsUGgzrhFo8eS1_OcnkVDOXRuc1C=0nMx=@mail.gmail.com>
In-Reply-To: <AANLkTinzQGzsUGgzrhFo8eS1_OcnkVDOXRuc1C=0nMx=@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201011020445.23367.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, November 02, 2010, Daniel J Blueman wrote:
> Hi Francois,
> 
> On 1 November 2010 23:46, Francois Romieu <romieu@fr.zoreil.com> wrote:
> > Daniel J Blueman <daniel.blueman@gmail.com> :
> >> Recent changes to the r8169 driver cause it to call
> >> device_set_wakeup_enable under spinlock, which may sleep.
> >
> > The change is fine but the description is misleading : the r8169
> > driver has been issuing device_set_wakeup_enable under spinlock since
> > october 2008. device_set_wakeup_enable did not sleep until recently
> > (see f2dc0d1809ab7e0147c7e4ac837be1682f706538 for instance).

Yes, sorry about that.  I overlooked the fact that these drivers called
device_set_wakeup_enable() under spinlocks.

> Good catch; I also find that only the gainfar is the other driver
> needing fixing; I'll follow up with this.

Thanks a lot for taking care of this!

> Patch with updated description for David:
> 
> As device_set_wakeup_enable can now sleep, move the call to outside
> the critical section.
> 
> Signed-off-by: Daniel J Blueman <daniel.blueman@gmail.com>

Acked-by: Rafael J. Wysocki <rjw@sisk.pl>

> diff --git a/drivers/net/r8169.c b/drivers/net/r8169.c
> index d88ce9f..894e7c7 100644
> --- a/drivers/net/r8169.c
> +++ b/drivers/net/r8169.c
> @@ -846,10 +846,10 @@ static int rtl8169_set_wol(struct net_device
> *dev, struct ethtool_wolinfo *wol)
>  	else
>  		tp->features &= ~RTL_FEATURE_WOL;
>  	__rtl8169_set_wol(tp, wol->wolopts);
> -	device_set_wakeup_enable(&tp->pci_dev->dev, wol->wolopts);
> -
>  	spin_unlock_irq(&tp->lock);
> 
> +	device_set_wakeup_enable(&tp->pci_dev->dev, wol->wolopts);
> +
>  	return 0;
>  }
> 
> 

