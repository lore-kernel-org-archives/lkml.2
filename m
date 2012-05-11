Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030299Ab2EKSj0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 14:39:26 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:39262 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030255Ab2EKSjY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 14:39:24 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Huang Ying <ying.huang@intel.com>
Subject: Re: [RFC v2 3/5] PCIe, Add runtime PM support to PCIe port
Date: Fri, 11 May 2012 20:44:15 +0200
User-Agent: KMail/1.13.6 (Linux/3.4.0-rc6+; KDE/4.6.0; x86_64; ; )
Cc: huang ying <huang.ying.caritas@gmail.com>,
        Bjorn Helgaas <bhelgaas@google.com>, ming.m.lin@intel.com,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        Zheng Yan <zheng.z.yan@intel.com>
References: <1336119221-21146-1-git-send-email-ying.huang@intel.com> <201205072300.46939.rjw@sisk.pl> <1336723068.6487.8.camel@yhuang-dev>
In-Reply-To: <1336723068.6487.8.camel@yhuang-dev>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201205112044.15415.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, May 11, 2012, Huang Ying wrote:
> On Mon, 2012-05-07 at 23:00 +0200, Rafael J. Wysocki wrote:
> > On Saturday, May 05, 2012, huang ying wrote:
> > > On Sat, May 5, 2012 at 3:43 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > > > On Friday, May 04, 2012, Huang Ying wrote:
> > > >> From: Zheng Yan <zheng.z.yan@intel.com>
> > > >>
> > > >> This patch adds runtime PM support to PCIe port.  This is needed by
> > > >> PCIe D3cold support, where PCIe device in slot may be powered on/off
> > > >> by PCIe port.
> > > >>
> > > >> Because runtime suspend is broken for some chipset, a white list is
> > > >> used to enable runtime PM support for only chipset known to work.
> > > >>
> > > >> Signed-off-by: Zheng Yan <zheng.z.yan@intel.com>
> > > >> Signed-off-by: Huang Ying <ying.huang@intel.com>
> > > >> ---
> > > >>  drivers/pci/pci.c              |    9 +++++++++
> > > >>  drivers/pci/pcie/portdrv_pci.c |   40 ++++++++++++++++++++++++++++++++++++++++
> > > >>  2 files changed, 49 insertions(+)
> > > >>
> > > >> --- a/drivers/pci/pci.c
> > > >> +++ b/drivers/pci/pci.c
> > > >> @@ -1476,6 +1476,15 @@ bool pci_check_pme_status(struct pci_dev
> > > >>   */
> > > >>  static int pci_pme_wakeup(struct pci_dev *dev, void *pme_poll_reset)
> > > >>  {
> > > >> +     struct pci_dev *bridge = dev->bus->self;
> > > >> +
> > > >> +     /*
> > > >> +      * If bridge is in low power state, the configuration space of
> > > >> +      * subordinate devices may be not accessible
> > > >
> > > > Please also say in the comment _when_ this is possible.  That's far from
> > > > obvious, because the runtime PM framework generally ensures that parents are
> > > > resumed before the children, so the comment should describe the particular
> > > > scenario leading to this situation.
> > > 
> > > OK.  I will add something like below into comments.
> > > 
> > > This is possible when doing PME poll.
> > 
> > Well, that doesn't really explain much. :-)
> > 
> > I _think_ the situation is when a device causes WAKE# to be generated and
> > the platform receives a GPE as a result and we get an ACPI_NOTIFY_DEVICE_WAKE
> > notification for the device, which may be under a bridge (PCIe port really)
> > in D3_cold.  Is that the case?
> 
> That is not the case now.  Because we do not use pci_pme_wakeup_bus() in
> ACPI handler now.
> 
> But for PME poll, if some subordinate devices under a bridge is put in
> low power state, we still need to access configuration space of
> subordinate devices to poll PME status even when bridge is in low power
> state.  That may not work.

OK, I see.  You mean that pci_pme_list_scan() should avoid checking the
PME status for devices whose parents (bridges) are in low-power states, right?

I think that that check should be made by pci_pme_list_scan() itself, then.

Thanks,
Rafael
