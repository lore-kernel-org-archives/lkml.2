Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932104Ab2IRVlM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 17:41:12 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:60740 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755595Ab2IRVlI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 17:41:08 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Dave Airlie <airlied@gmail.com>
Subject: Re: runtime PM and special power switches
Date: Tue, 18 Sep 2012 23:47:33 +0200
User-Agent: KMail/1.13.6 (Linux/3.6.0-rc6+; KDE/4.6.0; x86_64; ; )
Cc: Alan Stern <stern@rowland.harvard.edu>,
        LKML <linux-kernel@vger.kernel.org>,
        "dri-devel" <dri-devel@lists.freedesktop.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-pci@vger.kernel.org
References: <201209112255.10486.rjw@sisk.pl> <CAPM=9twQJSCX64kYsAikteZoJOH9m8e6AWuj-e_Ouyk3HmyOuQ@mail.gmail.com> <CAPM=9tw8ydqLveJLAdDJ75gDW4UkUiXMSqHqvtYPwnn-wLmGhg@mail.gmail.com>
In-Reply-To: <CAPM=9tw8ydqLveJLAdDJ75gDW4UkUiXMSqHqvtYPwnn-wLmGhg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201209182347.34049.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry for the delayed response.

On Wednesday, September 12, 2012, Dave Airlie wrote:
> On Wed, Sep 12, 2012 at 3:13 PM, Dave Airlie <airlied@gmail.com> wrote:
> > On Wed, Sep 12, 2012 at 8:58 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> >> On Wednesday, September 12, 2012, Dave Airlie wrote:
> >>> On Wed, Sep 12, 2012 at 7:32 AM, Alan Stern <stern@rowland.harvard.edu> wrote:
> >>> > On Tue, 11 Sep 2012, Rafael J. Wysocki wrote:
> >>> >
> >>> >> Hi,
> >>> >>
> >>> >> On Tuesday, September 11, 2012, Dave Airlie wrote:
> >>> >> > Hi Rafael,
> >>> >> >
> >>> >> > I've been investigating runtime PM support for some use-cases on GPUs.
> >>> >> >
> >>> >> > In some laptops we have a secondary GPU (optimus) that can be powered
> >>> >> > up for certain 3D tasks and then turned off when finished with. Now I
> >>> >> > did an initial pass on supporting it without using the kernel runtime
> >>> >> > PM stuff, but Alan said I should take a look so here I am.
> >>> >>
> >>> >> Alan Stern or Alan Cox? :-)
> >>> >>
> >>> >> > While I've started to get a handle on things, we have a bit of an
> >>> >> > extra that I'm not sure we cater for.
> >>> >> >
> >>> >> > Currently we get called from the PCI layer which after we are finished
> >>> >> > with our runtime suspend callback, will go put the device into the
> >>> >> > correct state etc, however on these optimus/powerxpress laptops we
> >>> >> > have a separate ACPI or platform driver controlled power switch that
> >>> >> > we need to call once the PCI layer is finished the job. This switch
> >>> >> > effectively turns the power to the card completely off leaving it
> >>> >> > drawing no power.
> >>> >> >
> >>> >> > No we can't hit the switch from the driver callback as the PCI layer
> >>> >> > will get lost, so I'm wondering how you'd envisage we could plug this
> >>> >> > in.
> >>> >>
> >>> >> Hmm.  In principle we might modify pci_pm_runtime_suspend() so that it
> >>> >> doesn't call pci_finish_runtime_suspend() if pci_dev->state_saved is
> >>> >> set.  That would actually make it work in analogy with pci_pm_suspend_noirq(),
> >>> >> so perhaps it's not even too dangerous.
> >>> >
> >>> > This sounds more like a job for a power domain.  Unless the power
> >>> > switch is already in the device hierarchy as a parent to the PCI
> >>> > device.
> >>>
> >>> I'll have to investigate power domains then,
> >>>
> >>> The switch is hidden in many different places, one some laptops its in
> >>> a ACPI _DSM on one GPU, on others its in an ACPI _DSM on the other
> >>> one, in some its in a different ACPI _DSM, then we have it in the ACPI
> >>> ATPX method on others, and finally Apple have it in a piece of hw that
> >>> isn't just on the LPC bus or somewhere like that.
> >>>
> >>> Currently we just hide it all inside vga_switcheroo and I'd just need
> >>> an interface to call that once the layers have stopped poking
> >>> registers in PCI config space, if we could fix PCI runtime suspend so
> >>> the driver was the last to g 2et called then that would also not suck.
> >>
> >> Well, as I said, we may try to change the PCI layer so that it doesn't
> >> access the device any more in pci_pm_runtime_suspend() if it sees that
> >> pci_dev->state_saved has been set by the driver's callback.  Then,
> >> your drivers would only need to set pci_dev->state_saved in their
> >> .runtime_suspend() callbacks.
> >>
> >
> > Actually it appears I'll need this, I'd forgotten things are a bit
> > messier than I thought
> >
> > So there are two variants on the _DSM for nvidia dual-gpu machines,
> > the older pre-optimus _DSM requires
> > an explicit power off call post-D3, however for optimus _DSM the D3
> > transition will flick the power switch, however
> > the pci code then goes and seem to turn the device back to D0 for some
> > reason. So yes after save state,
> > I'd really appreciate if it the pci layer would stop poking my device.

OK, so the patch for that is appended.  It would be nice if you could see
if that's sufficient for your use cases.

> >> Alternatively, which may be less hackish but more work, you can set the
> >> pm_domain pointer in the device structure to a struct dev_pm_domain whose
> >> ops will just call the corresponding bus type's ops except for
> >> .runtime_suspend() that will execute the additional ACPI stuff after calling
> >> the bus type's method.
> >
> > I've mostly written this, and it seems to work, I've jsut set a
> > pm_domain in the vga switcheroo code that copies the dev->bus->pm
> > into a private structure. I'll need this for the old nvidia and radeon
> > poweroffs.
> >
> 
> 
> http://cgit.freedesktop.org/~airlied/linux/log/?h=drm-opt-pwr
> is my current WIP branch

It looks reasonable to me.

Thanks,
Rafael


---
 drivers/pci/pci-driver.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

Index: linux/drivers/pci/pci-driver.c
===================================================================
--- linux.orig/drivers/pci/pci-driver.c
+++ linux/drivers/pci/pci-driver.c
@@ -1063,10 +1063,10 @@ static int pci_pm_runtime_suspend(struct
 		return 0;
 	}
 
-	if (!pci_dev->state_saved)
+	if (!pci_dev->state_saved) {
 		pci_save_state(pci_dev);
-
-	pci_finish_runtime_suspend(pci_dev);
+		pci_finish_runtime_suspend(pci_dev);
+	}
 
 	return 0;
 }
