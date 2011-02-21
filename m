Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752056Ab1BUUpy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Feb 2011 15:45:54 -0500
Received: from void.printf.net ([89.145.121.20]:38478 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750995Ab1BUUpw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Feb 2011 15:45:52 -0500
Date: Mon, 21 Feb 2011 20:45:23 +0000
From: Chris Ball <cjb@laptop.org>
To: Pierre Tardy <tardyp@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Pierre Tardy <pierre.tardy@intel.com>,
        linux-pm@lists.linux-foundation.org, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org, Yunpeng Gao <yunpeng.gao@intel.com>
Subject: Re: [PATCH v2 2/3] sdhci-pci : Enable runtime PM support
Message-ID: <20110221204523.GA28419@void.printf.net>
References: <cover.1297014479.git.pierre.tardy@intel.com> <6722fa7986194808f4d69a1e5ba6d3f163b77da9.1297014479.git.pierre.tardy@intel.com> <20110210043718.GA7585@void.printf.net> <AANLkTi=iZ3dzAoRuRdpvQ=uBp4u8O8LtMuu2XdSWeZwr@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTi=iZ3dzAoRuRdpvQ=uBp4u8O8LtMuu2XdSWeZwr@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pierre,

On Sun, Feb 13, 2011 at 11:42:01AM +0100, Pierre Tardy wrote:
> > [   10.892280] sdhci-pci 0000:17:00.0: Unbalanced pm_runtime_enable!
> 
> I never have seen this before. I'm not testing those patches on
> mmc-next, as our platform is not totally upstream yet, and do not boot
> on 2.6.37+ based kernel.
> However, we backported the pm_runtime patches from 2.6.37. Is there
> some differences in very latest patches on default enablement of
> runtime_pm?

It's getting enabled by drivers/pci/pci-driver.c:local_pci_probe(),
before the sdhci-pci probe function runs.  local_pci_probe() does:

        /* Unbound PCI devices are always set to disabled and suspended.
         * During probe, the device is set to enabled and active and the
         * usage count is incremented.  If the driver supports runtime PM,
         * it should call pm_runtime_put_noidle() in its probe routine and
         * pm_runtime_get_noresume() in its remove routine.
         */
        pm_runtime_get_noresume(dev);
        pm_runtime_set_active(dev);
        pm_runtime_enable(dev);

and then the "Unbalanced pm_runtime_enable!" message appears when
sdhci_pci_probe() calls pm_runtime_enable() for the second time. 

> > I then removed the card and reinserted it, but there's no dmesg output
> > related to the reinsert, only to the card removal:
> >
> > [   65.381047] mmc0: card d555 removed
> >
> > So, card insertion is broken.  I then did rmmod sdhci-pci && modprobe
> > sdhci-pci, and it picked up the card again.
> 
> So what you have here is non working card-detection when device is in PCI_D3.
> This sounds like a HW limitation in you platform.
> 
> D3 is originally meant for suspend to ram, so it sounds logic that
> some HW wont support wake on card detect.
> it sounds like we need a SDHCI_RUNTIME_PM_CAP, so that we can properly
> describe which HW can be safely put D3 at runtime.
> Also, maybe on some HW, D1 will support wake on card detect. I dont
> know how can the driver hint pci subsystem that it should go D1 rather
> than D3 in the runtime_pm flow.
> Maybe Rafael can advice on this.

The controller advertises the ability to generate PME wakeups from D3
in its PCI capabilities; perhaps we just aren't programming it properly.
I don't see anything in your patch that would set SDHCI wakeup bits or
unmask card insertion/removal IRQs -- maybe that could be it?

Thanks,

-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
One Laptop Per Child
