Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754698Ab1LED3l (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Dec 2011 22:29:41 -0500
Received: from va3ehsobe002.messaging.microsoft.com ([216.32.180.12]:24072
	"EHLO VA3EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754050Ab1LED3j convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Dec 2011 22:29:39 -0500
X-SpamScore: -10
X-BigFish: VS-10(zz1432N4015Lzz1202hzzz2dh2a8h668h839h8e2h8e3h944h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
From: Chen Peter-B29397 <B29397@freescale.com>
To: NeilBrown <neilb@suse.de>, "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Greg KH <greg@kroah.com>, "gregkh@suse.de" <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "stern@rowland.harvard.edu" <stern@rowland.harvard.edu>,
        "hzpeterchen@gmail.com" <hzpeterchen@gmail.com>,
        Igor Grinberg <grinberg@compulab.co.il>
Subject: RE: [PATCH 1/1] driver core: disable device's runtime pm during
 shutdown
Thread-Topic: [PATCH 1/1] driver core: disable device's runtime pm during
 shutdown
Thread-Index: AQHMoxycXXQ805A53UK1qWqObZXQz5Wtgh2AgAF1WwCAHcYOAP//2roQ
Date: Mon, 5 Dec 2011 03:29:24 +0000
Message-ID: <35AB98346D25394A9354ED89C4D76587228E65@039-SN1MPN1-002.039d.mgd.msft.net>
References: <1321231380-11631-1-git-send-email-peter.chen@freescale.com>
	<201111142327.37524.rjw@sisk.pl>	<20111115005951.GB26360@kroah.com>
	<201111160016.09174.rjw@sisk.pl> <20111205085632.5976fe96@notabene.brown>
In-Reply-To: <20111205085632.5976fe96@notabene.brown>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.192.242.127]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 
> 
> Hi,
>  this patches causes a problem for me.
> 
> Specifically it makes it impossible to power-down a device which uses
> twl4030
> for power control on an omap3 processor.
> 
> To perform the shutdown we need to send a command over the i2c bus.
> The relevant bus is called omap_i2c.1 and this is normally in suspend
> mode.
> When a request is sent, omap_i2c_xfer uses pm_runtime_get_sync to wake it
> up,
> performs the transfer, then calls pm_runtime_put to let it go back to
> sleep.
> 
> So it is asleep when the new pm_runtime_disable() call is made, so it
> stays
> asleep, omap_i2c_xfer cannot wake it, the transfer doesn't happen and the
> system doesn't get powered off.
> 
> So here is a device that should *not* have pm disabled at shutdown.
> 
> So I feel this fix is a little too heavy-handed.
> I don't fully understand the problem scenario described above but it
> seems to
> me that if the auto-suspend timer can fire after the hardware has been
> shut
> down, then maybe the hardware-shutdown should be disabling that timer.
> Maybe?
> 
Oh, I am sorry to cause your problem. I think it may not be easy to handle this
kinds of problem well. 

In my opinion, it is better to handle shutdown/suspend SYNC at device drivers.
Since the pm core is hard to know driver's shutdown is finished, and vice versa.

1. Driver needs to has relationship between suspend/shutdown, like usb host,
hcd needs to know downstream port's suspend, and usb core needs to know hcd's shutdown. 

2. At driver's shutdown
static void xxx_driver_shutdown(struct platform_device *pdev)
{
	if (supports_autosuspend(&pdev->dev) {
		pm_runtime_cancel_pending(&pdev->dev);
		wait_xxx_driver_suspend(pdev); /* need to sync with driver's suspend */
	}
	real_shutdown();		
}

> Suggestions?
> 
> Thanks,
> NeilBrown

