Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933121Ab0FRTvi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jun 2010 15:51:38 -0400
Received: from cpoproxy1-pub.bluehost.com ([69.89.21.11]:45976 "HELO
	cpoproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S933135Ab0FRTvd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jun 2010 15:51:33 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=fFWjXTV/0nvB3wsEsl8xY5QScCrl588yLIbFJRYEIHDxBcqdeN+Li+aLe62s18PPnIbc0USJR7PabDtPDkgYi+T0dudfeZ2Cwp2k27xxpJcrhECrvBZmspNq3Jy3+JNK;
Date: Fri, 18 Jun 2010 12:49:56 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: "Justin P. Mattock" <justinmattock@gmail.com>,
       linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
       linux-pci@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH 4/5]pci:setup_bus.c Fix warning: variable 'retval' set
 but not used
Message-ID: <20100618124956.40c869a0@virtuousgeek.org>
In-Reply-To: <4C1BBF7D.8090904@kernel.org>
References: <1276666434-11227-1-git-send-email-justinmattock@gmail.com>
	<1276666434-11227-5-git-send-email-justinmattock@gmail.com>
	<20100618102330.29eccb5b@virtuousgeek.org>
	<4C1BBF7D.8090904@kernel.org>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.110.194.140 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Jun 2010 11:48:29 -0700
Yinghai Lu <yinghai@kernel.org> wrote:

> On 06/18/2010 10:23 AM, Jesse Barnes wrote:
> > On Tue, 15 Jun 2010 22:33:53 -0700
> > "Justin P. Mattock" <justinmattock@gmail.com> wrote:
> > 
> >> The below patch fixes a warning message when using gcc 4.6.0
> >>   CC      drivers/pci/setup-bus.o
> >> drivers/pci/setup-bus.c: In function 'pci_assign_unassigned_bridge_resources':
> >> drivers/pci/setup-bus.c:868:6: warning: variable 'retval' set but not used
> >>  
> >>  Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>
> >>
> >> ---
> >>  drivers/pci/setup-bus.c |    2 --
> >>  1 files changed, 0 insertions(+), 2 deletions(-)
> >>
> >> diff --git a/drivers/pci/setup-bus.c b/drivers/pci/setup-bus.c
> >> index 19b1113..215590b 100644
> >> --- a/drivers/pci/setup-bus.c
> >> +++ b/drivers/pci/setup-bus.c
> >> @@ -865,7 +865,6 @@ void pci_assign_unassigned_bridge_resources(struct pci_dev *bridge)
> >>  	struct pci_bus *parent = bridge->subordinate;
> >>  	int tried_times = 0;
> >>  	struct resource_list_x head, *list;
> >> -	int retval;
> >>  	unsigned long type_mask = IORESOURCE_IO | IORESOURCE_MEM |
> >>  				  IORESOURCE_PREFETCH;
> >>  
> >> @@ -874,7 +873,6 @@ void pci_assign_unassigned_bridge_resources(struct pci_dev *bridge)
> >>  again:
> >>  	pci_bus_size_bridges(parent);
> >>  	__pci_bridge_assign_resources(bridge, &head);
> >> -	retval = pci_reenable_device(bridge);
> >>  	pci_set_master(bridge);
> >>  	pci_enable_bridges(parent);
> >>  
> 
> I sent following patch several weeks ago, can you put that in pci-next?
> 
> Subject: [PATCH] pciehp: Enable bridges at last for multiple try assigning
> 
> Found one PCIe Module with several bridges "cold" hotadd doesn't work.
> 
> the root cause:
> 1. BIOS assign small range the parent bridges.
> 2. First try for hotadd only can make some bridges get resource assigned.
> 3. Second will update parent bridge res, get right sizes for all child bridges
>     and devices, but resource for child bridges are not set to HW register.
>     Because first try already enable those bridges, so __pci_bridge_assign_resource
>     skip the setting step.
> 
> So try to move enabling of child bridges to last and only do that one time
> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>

Yeah I had a hard time following the changelog, but just looked it
over.  Looks safe, but Justin will still need to check the return value
on pci_reenable_device.

Justin, we don't want a message on every reenable, just on ones that
fail.  So can you protect your printk with if (retval) instead?  You'll
need to refresh it based on my linux-next branch in a few minutes, as
I'm pushing Yinghai's patch now.

-- 
Jesse Barnes, Intel Open Source Technology Center
