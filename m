Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753539Ab2HNVsE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 17:48:04 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:39043 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751044Ab2HNVsB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 17:48:01 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Huang Ying <ying.huang@intel.com>
Subject: Re: [BUGFIX -v3 3/4] PCI/PM: Fix config reg access for D3cold and bridge suspending
Date: Tue, 14 Aug 2012 23:53:58 +0200
User-Agent: KMail/1.13.6 (Linux/3.5.0+; KDE/4.6.0; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-pm@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
        Bjorn Helgaas <bhelgaas@google.com>
References: <1344388061-18981-1-git-send-email-ying.huang@intel.com> <1344388061-18981-4-git-send-email-ying.huang@intel.com> <1344566197.19962.95.camel@yhuang-dev>
In-Reply-To: <1344566197.19962.95.camel@yhuang-dev>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201208142353.59106.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry for the delay.

On Friday, August 10, 2012, Huang Ying wrote:
> On Wed, 2012-08-08 at 09:07 +0800, Huang Ying wrote:
> > This patch fixes the following bug:
> > 
> > http://marc.info/?l=linux-pci&m=134338059022620&w=2
> > 
> > Where lspci does not work properly if a device and the corresponding
> > parent bridge (such as PCIe port) is suspended.  This is because the
> > device configuration space registers will be not accessible if the
> > corresponding parent bridge is suspended or the device is put into
> > D3cold state.
> > 
> > To solve the issue, the bridge/PCIe port connected to the device is
> > put into active state before read/write configuration space registers.
> > If the device is in D3cold state, it will be put into active state
> > too.
> > 
> > To avoid resume/suspend PCIe port for each configuration register
> > read/write, a small delay is added before the PCIe port to go
> > suspended.
> > 
> > Reported-by: Bjorn Mork <bjorn@mork.no>
> > Signed-off-by: Huang Ying <ying.huang@intel.com>
> > ---
> >  drivers/pci/pci-sysfs.c        |   43 +++++++++++++++++++++++++++++++++++++++++
> >  drivers/pci/pcie/portdrv_pci.c |    9 ++++++++
> >  2 files changed, 52 insertions(+)
> > 
> > --- a/drivers/pci/pci-sysfs.c
> > +++ b/drivers/pci/pci-sysfs.c
> > @@ -458,6 +458,41 @@ boot_vga_show(struct device *dev, struct
> >  }
> >  struct device_attribute vga_attr = __ATTR_RO(boot_vga);
> >  
> > +static void
> > +pci_config_pm_runtime_get(struct pci_dev *pdev)
> > +{
> > +	struct device *dev = &pdev->dev;
> > +	struct device *parent = dev->parent;
> > +
> > +	if (parent)
> > +		pm_runtime_get_sync(parent);
> > +	pm_runtime_get_noresume(dev);
> > +	/*
> > +	 * pdev->current_state is set to PCI_D3cold during suspending,
> > +	 * so wait until suspending completes
> > +	 */
> > +	pm_runtime_barrier(dev);
> > +	if (pdev->current_state == PCI_D3cold) {
> > +		/*
> > +		 * Already called pm_runtime_get_noresume above, so
> > +		 * just calling pm_runtime_resume is sufficient, need
> > +		 * not to call pm_runtime_get_sync.
> > +		 */
> > +		pm_runtime_resume(dev);
> 
> Hi, Rafael,
> 
> Do you OK with this new version and the comments added above?

I meant something different.  Namely, it may not be entirely clear why
we make the effort to check if pdev->current_state is equal to PCI_D3cold
instead of just calling pm_runtime_get_sync() right after resuming the
parent.

My understanding is that we do it because in principle the device may
be suspended, but not in D3cold, and in that case we don't need to
resume it.  If that is the reason, it may be a good idea to document it
in a comment.

The comment explaining why the barrier is there is clearly useful, though.

Thanks,
Rafael
