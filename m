Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755231Ab1LEEm3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Dec 2011 23:42:29 -0500
Received: from va3ehsobe010.messaging.microsoft.com ([216.32.180.30]:46166
	"EHLO VA3EHSOBE010.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754975Ab1LEEm2 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Dec 2011 23:42:28 -0500
X-SpamScore: -10
X-BigFish: VS-10(zz1432N4015Lzz1202hzzz2dh2a8h668h839h8e2h8e3h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-FB-SS: 0,
From: Chen Peter-B29397 <B29397@freescale.com>
To: Ming Lei <tom.leiming@gmail.com>, NeilBrown <neilb@suse.de>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>, Greg KH <greg@kroah.com>,
        "gregkh@suse.de" <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "stern@rowland.harvard.edu" <stern@rowland.harvard.edu>,
        "hzpeterchen@gmail.com" <hzpeterchen@gmail.com>,
        Igor Grinberg <grinberg@compulab.co.il>
Subject: RE: [PATCH 1/1] driver core: disable device's runtime pm during
 shutdown
Thread-Topic: [PATCH 1/1] driver core: disable device's runtime pm during
 shutdown
Thread-Index: AQHMoxycXXQ805A53UK1qWqObZXQz5Wtgh2AgAF1WwCAHcYOAIAAXD0A//+uF3A=
Date: Mon, 5 Dec 2011 04:42:26 +0000
Message-ID: <35AB98346D25394A9354ED89C4D76587228EA3@039-SN1MPN1-002.039d.mgd.msft.net>
References: <1321231380-11631-1-git-send-email-peter.chen@freescale.com>
	<201111142327.37524.rjw@sisk.pl>	<20111115005951.GB26360@kroah.com>
	<201111160016.09174.rjw@sisk.pl>	<20111205085632.5976fe96@notabene.brown>
 <CACVXFVNkapRDJ8QkgmJCh+n1c2+7cHBiLf1ef22Nfdd8YrPpGg@mail.gmail.com>
In-Reply-To: <CACVXFVNkapRDJ8QkgmJCh+n1c2+7cHBiLf1ef22Nfdd8YrPpGg@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.192.242.127]
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> >  this patches causes a problem for me.
> >
> > Specifically it makes it impossible to power-down a device which uses
> twl4030
> > for power control on an omap3 processor.
> >
> > To perform the shutdown we need to send a command over the i2c bus.
> > The relevant bus is called omap_i2c.1 and this is normally in suspend
> mode.
> > When a request is sent, omap_i2c_xfer uses pm_runtime_get_sync to wake
> it up,
> > performs the transfer, then calls pm_runtime_put to let it go back to
> sleep.
> >
> > So it is asleep when the new pm_runtime_disable() call is made, so it
> stays
> > asleep, omap_i2c_xfer cannot wake it, the transfer doesn't happen and
> the
> > system doesn't get powered off.
> >
> > So here is a device that should *not* have pm disabled at shutdown.
> >
> > So I feel this fix is a little too heavy-handed.
> 
> Maybe the device's runtime PM should not be disabled if
> there is no ->shutdown defined in its driver, how about the blew?
> 
> diff --git a/drivers/base/core.c b/drivers/base/core.c
> index d8b3d89..ca30659 100644
> --- a/drivers/base/core.c
> +++ b/drivers/base/core.c
> @@ -1743,14 +1743,16 @@ void device_shutdown(void)
>  		 */
>  		list_del_init(&dev->kobj.entry);
>  		spin_unlock(&devices_kset->list_lock);
> -		/* Disable all device's runtime power management */
> -		pm_runtime_disable(dev);
> 
> +		/* Disable the device's runtime power management if
> +		 * it is to be shutdown*/
>  		if (dev->bus && dev->bus->shutdown) {
>  			dev_dbg(dev, "shutdown\n");
> +			pm_runtime_disable(dev);
>  			dev->bus->shutdown(dev);
>  		} else if (dev->driver && dev->driver->shutdown) {
>  			dev_dbg(dev, "shutdown\n");
> +			pm_runtime_disable(dev);
>  			dev->driver->shutdown(dev);
>  		}
>  		put_device(dev);
> 
> 
Yes, it is the solution for Neil's case, but I am not sure for all.
Is it possible to resume driver's itself at driver's shutdown?

> > I don't fully understand the problem scenario described above but it
> seems to
> > me that if the auto-suspend timer can fire after the hardware has been
> shut
> > down, then maybe the hardware-shutdown should be disabling that
> timer.  Maybe?
> >
> > Suggestions?
> >
> > Thanks,
> > NeilBrown
> 
> 
> thanks,
> --
> Ming Lei


