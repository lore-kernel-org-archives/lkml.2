Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756873Ab2LNW62 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 17:58:28 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:34165 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756766Ab2LNW60 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 17:58:26 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Richard Yang <weiyang@linux.vnet.ibm.com>
Cc: Huang Ying <ying.huang@intel.com>, Bjorn Helgaas <bhelgaas@google.com>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-pm@vger.kernel.org
Subject: Re: [PATCH] PCIe/PM: Do not suspend port if any subordinate device need PME polling
Date: Sat, 15 Dec 2012 00:03:33 +0100
Message-ID: <3929168.xsIhODq3Fi@vostro.rjw.lan>
User-Agent: KMail/4.9.3 (Linux/3.7.0; KDE/4.9.3; x86_64; ; )
In-Reply-To: <20121214051131.GA31440@richard.>
References: <1355453531-23348-1-git-send-email-ying.huang@intel.com> <20121214051131.GA31440@richard.>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, December 14, 2012 01:11:31 PM Richard Yang wrote:
> On Fri, Dec 14, 2012 at 10:52:11AM +0800, Huang Ying wrote:
> >In
> >
> >  http://www.mail-archive.com/linux-usb@vger.kernel.org/msg07976.html
> >
> >Ulrich reported that his USB3 cardreader does not work reliably when
> >connected to the USB3 port.  It turns out that USB3 controller failed
> >to be waken up when plugging in the USB3 cardreader.  Further
> >experiment found that the USB3 host controller can only be waken up
> >via polling, while not via PME interrupt.  But if the PCIe port that
> >the USB3 host controller is connected is suspended, we can not poll
> >the USB3 host controller because its config space is not accessible if
> >the PCIe port is put into low power state.
> >
> >To solve the issue, the PCIe port will not be suspended if any
> >subordinate device need PME polling.
> >
> >Reported-by: Ulrich Eckhardt <usb@uli-eckhardt.de>
> >Signed-off-by: Huang Ying <ying.huang@intel.com>
> >Tested-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>
> >Cc: stable@vger.kernel.org	# 3.6+
> >---
> > drivers/pci/pcie/portdrv_pci.c |   18 +++++++++++++++++-
> > 1 file changed, 17 insertions(+), 1 deletion(-)
> >
> >--- a/drivers/pci/pcie/portdrv_pci.c
> >+++ b/drivers/pci/pcie/portdrv_pci.c
> >@@ -134,10 +134,26 @@ static int pcie_port_runtime_resume(stru
> > 	return 0;
> > }
> >
> >+static int pci_dev_pme_poll(struct pci_dev *pdev, void *data)
> >+{
> >+	int *pme_poll = data;
> >+	*pme_poll = *pme_poll || pdev->pme_poll;
> >+	return 0;
> >+}
> >+
> > static int pcie_port_runtime_idle(struct device *dev)
> > {
> >+	struct pci_dev *pdev = to_pci_dev(dev);
> >+	int pme_poll = false;
> 
> You want to use int or bool? 
> 
> I think bool is better?

Well, bool would be nicer, but it's not a big deal.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
