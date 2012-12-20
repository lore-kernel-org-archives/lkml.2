Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751609Ab2LTVpH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 16:45:07 -0500
Received: from mail-vc0-f180.google.com ([209.85.220.180]:47073 "EHLO
	mail-vc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750869Ab2LTVpD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 16:45:03 -0500
MIME-Version: 1.0
In-Reply-To: <50cdc89b.2788440a.0cfe.ffff8fb7SMTPIN_ADDED_BROKEN@mx.google.com>
References: <1355453531-23348-1-git-send-email-ying.huang@intel.com>
 <20121214051131.GA31440@richard.> <3929168.xsIhODq3Fi@vostro.rjw.lan> <50cdc89b.2788440a.0cfe.ffff8fb7SMTPIN_ADDED_BROKEN@mx.google.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Thu, 20 Dec 2012 14:44:42 -0700
Message-ID: <CAErSpo6xUDEdbtoOvReb+QX4PZ2_wGzUw4t=sJXCUTX-guUjRQ@mail.gmail.com>
Subject: Re: [PATCH] PCIe/PM: Do not suspend port if any subordinate device
 need PME polling
To: Richard Yang <weiyang@linux.vnet.ibm.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Huang Ying <ying.huang@intel.com>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-pm@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 16, 2012 at 6:11 AM, Richard Yang
<weiyang@linux.vnet.ibm.com> wrote:
> On Sat, Dec 15, 2012 at 12:03:33AM +0100, Rafael J. Wysocki wrote:
>>On Friday, December 14, 2012 01:11:31 PM Richard Yang wrote:
>>> On Fri, Dec 14, 2012 at 10:52:11AM +0800, Huang Ying wrote:
>>> >In
>>> >
>>> >  http://www.mail-archive.com/linux-usb@vger.kernel.org/msg07976.html
>>> >
>>> >Ulrich reported that his USB3 cardreader does not work reliably when
>>> >connected to the USB3 port.  It turns out that USB3 controller failed
>>> >to be waken up when plugging in the USB3 cardreader.  Further
>>> >experiment found that the USB3 host controller can only be waken up
>>> >via polling, while not via PME interrupt.  But if the PCIe port that
>>> >the USB3 host controller is connected is suspended, we can not poll
>>> >the USB3 host controller because its config space is not accessible if
>>> >the PCIe port is put into low power state.
>>> >
>>> >To solve the issue, the PCIe port will not be suspended if any
>>> >subordinate device need PME polling.
>>> >
>>> >Reported-by: Ulrich Eckhardt <usb@uli-eckhardt.de>
>>> >Signed-off-by: Huang Ying <ying.huang@intel.com>
>>> >Tested-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>
>>> >Cc: stable@vger.kernel.org  # 3.6+
>>> >---
>>> > drivers/pci/pcie/portdrv_pci.c |   18 +++++++++++++++++-
>>> > 1 file changed, 17 insertions(+), 1 deletion(-)
>>> >
>>> >--- a/drivers/pci/pcie/portdrv_pci.c
>>> >+++ b/drivers/pci/pcie/portdrv_pci.c
>>> >@@ -134,10 +134,26 @@ static int pcie_port_runtime_resume(stru
>>> >    return 0;
>>> > }
>>> >
>>> >+static int pci_dev_pme_poll(struct pci_dev *pdev, void *data)
>>> >+{
>>> >+   int *pme_poll = data;
>>> >+   *pme_poll = *pme_poll || pdev->pme_poll;
>>> >+   return 0;
>>> >+}
>>> >+
>>> > static int pcie_port_runtime_idle(struct device *dev)
>>> > {
>>> >+   struct pci_dev *pdev = to_pci_dev(dev);
>>> >+   int pme_poll = false;
>>>
>>> You want to use int or bool?
>>>
>>> I think bool is better?
>>
>>Well, bool would be nicer, but it's not a big deal.
>>
>
> Yep, not a big deal.

I fixed up the int/bool confusion and added this to my pci/for-3.8
branch.  I'll push it soon after v3.8-rc1.  Thanks!

Bjorn
