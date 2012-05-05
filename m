Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752687Ab2EEGqT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2012 02:46:19 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:59392 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752143Ab2EEGqR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2012 02:46:17 -0400
MIME-Version: 1.0
In-Reply-To: <201205042143.54364.rjw@sisk.pl>
References: <1336119221-21146-1-git-send-email-ying.huang@intel.com>
	<1336119221-21146-4-git-send-email-ying.huang@intel.com>
	<201205042143.54364.rjw@sisk.pl>
Date: Sat, 5 May 2012 14:46:16 +0800
Message-ID: <CAC=cRTMoSCoWYvVqhBb5_SD=+bJuQ86-eifDqZxtGYRW_Ok9eg@mail.gmail.com>
Subject: Re: [RFC v2 3/5] PCIe, Add runtime PM support to PCIe port
From: huang ying <huang.ying.caritas@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Huang Ying <ying.huang@intel.com>, Bjorn Helgaas <bhelgaas@google.com>,
        ming.m.lin@intel.com, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, Zheng Yan <zheng.z.yan@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 5, 2012 at 3:43 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Friday, May 04, 2012, Huang Ying wrote:
>> From: Zheng Yan <zheng.z.yan@intel.com>
>>
>> This patch adds runtime PM support to PCIe port.  This is needed by
>> PCIe D3cold support, where PCIe device in slot may be powered on/off
>> by PCIe port.
>>
>> Because runtime suspend is broken for some chipset, a white list is
>> used to enable runtime PM support for only chipset known to work.
>>
>> Signed-off-by: Zheng Yan <zheng.z.yan@intel.com>
>> Signed-off-by: Huang Ying <ying.huang@intel.com>
>> ---
>>  drivers/pci/pci.c              |    9 +++++++++
>>  drivers/pci/pcie/portdrv_pci.c |   40 ++++++++++++++++++++++++++++++++++++++++
>>  2 files changed, 49 insertions(+)
>>
>> --- a/drivers/pci/pci.c
>> +++ b/drivers/pci/pci.c
>> @@ -1476,6 +1476,15 @@ bool pci_check_pme_status(struct pci_dev
>>   */
>>  static int pci_pme_wakeup(struct pci_dev *dev, void *pme_poll_reset)
>>  {
>> +     struct pci_dev *bridge = dev->bus->self;
>> +
>> +     /*
>> +      * If bridge is in low power state, the configuration space of
>> +      * subordinate devices may be not accessible
>
> Please also say in the comment _when_ this is possible.  That's far from
> obvious, because the runtime PM framework generally ensures that parents are
> resumed before the children, so the comment should describe the particular
> scenario leading to this situation.

OK.  I will add something like below into comments.

This is possible when doing PME poll.

>> +      */
>> +     if (bridge && bridge->current_state != PCI_D0)
>> +             return 0;
>> +
>>       if (pme_poll_reset && dev->pme_poll)
>>               dev->pme_poll = false;
>>
>> --- a/drivers/pci/pcie/portdrv_pci.c
>> +++ b/drivers/pci/pcie/portdrv_pci.c
>> @@ -11,6 +11,7 @@
>>  #include <linux/kernel.h>
>>  #include <linux/errno.h>
>>  #include <linux/pm.h>
>> +#include <linux/pm_runtime.h>
>>  #include <linux/init.h>
>>  #include <linux/pcieport_if.h>
>>  #include <linux/aer.h>
>> @@ -99,6 +100,27 @@ static int pcie_port_resume_noirq(struct
>>       return 0;
>>  }
>>
>> +#ifdef CONFIG_PM_RUNTIME
>> +static int pcie_port_runtime_suspend(struct device *dev)
>> +{
>> +     struct pci_dev *pdev = to_pci_dev(dev);
>> +
>
> A comment explaining why this is needed here would be welcome.

Sorry, do not catch your idea exactly.  What is needed?  Why do we
need to add PCIe port runtime suspend support?

Best Regards,
Huang Ying
