Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755868Ab1AKVKd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 16:10:33 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:48464 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754289Ab1AKVKb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 16:10:31 -0500
Date: Tue, 11 Jan 2011 13:10:22 -0800
From: Ram Pai <linuxram@us.ibm.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Ram Pai <linuxram@us.ibm.com>, Bjorn Helgaas <bjorn.helgaas@hp.com>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        clemens@ladisch.de, Yinghai Lu <yinghai@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        peter.henriksson@gmail.com, ebiederm@aristanetworks.com
Subject: Re: [PATCH 1/1] PCI: ignore failure to preallocate minimal
 resources to hotplug bridges
Message-ID: <20110111211021.GA26352@ram-laptop>
Reply-To: Ram Pai <linuxram@us.ibm.com>
References: <20101006225834.GE2945@ram-laptop>
 <201010081416.57454.bjorn.helgaas@hp.com>
 <20101012070515.GA549@ram-laptop>
 <201010121301.54402.bjorn.helgaas@hp.com>
 <20101018131010.0e4771eb@jbarnes-desktop>
 <20101019171740.GC8437@ram-laptop>
 <20101019112439.53c4901e@jbarnes-desktop>
 <20101022171640.GE24820@ram-laptop>
 <20110107143208.036a3c01@jbarnes-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110107143208.036a3c01@jbarnes-desktop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 07, 2011 at 02:32:08PM -0800, Jesse Barnes wrote:
> On Fri, 22 Oct 2010 10:16:40 -0700
> Ram Pai <linuxram@us.ibm.com> wrote:
> 
> >         PCI: ignore failure to preallocate minimal resources to 
> > 		hotplug bridges
> > 
> > 	Linux tries to pre-allocate minimal resources to hotplug 
> > 	bridges.  This 	works 	fine as long as there are enough 
> > 	resources  to  satisfy   all   other   genuine  resource
> > 	requirements.  However  if  enough  resources   are  not 
> > 	available    to    satisfy    the    pre-allocation, the 
> > 	resource-allocator reports errors and returns failure.
> > 	
> > 	This patch distinguishes between must-need resources and
> > 	nice-to-have   resources.   Any   failure   to  allocate 
> > 	nice-to-have resources are ignored. 
> > 
> > 	This  behavior  can  be  particularly  useful to trigger 
> > 	automatic  reallocation, if  the  OS  discovers  genuine 
> > 	resource  allocation  conflicts  or  genuine unallocated 
> > 	BARs  caused  by not-so-smart allocation behavior of the 
> > 	native BIOS.
> > 
> > 	The motivation for this patch is due a issue reported in 
> > 	https://bugzilla.kernel.org/show_bug.cgi?id=15960
> > 
> > Signed-off-by: Ram Pai <linuxram@us.ibm.com>
> > 
> 
> Seems like we want a fix like this; did you see Bjorn's comments?
> Maybe we can adjust the order of allocation instead?
> 
> What issues do you still have outstanding wrt resource allocation?  Do
> you still think you need the big "reallocate everything" option?

Jesse,

 Yes I saw Bjorn's comment but then i got pulled into something else and
 made no progress. Just yesterday I started looking into this and co-incidently
 see your mail too.

 I am not sure how to order the allocation given the current organization
 of the code.
	
 The real problem  is that the kernel wants to pre-allocate some minimum
 memory and ioport to hotplug bridges. On a system with just enough resources to
 satisfy the currently installed devices, the current code organization makes it
 hard to organize the allocation order such that atleast the must-have requests
 are satisfied.
	
 An ideal solution should first satisfy the must-have requests and if
 any additional resources are still available then pre-allocate nice-to-have
 requests.

 I am thinking of structuring the code the following way.

 a) note down the must-have requirement as well as the nice-to-way requirement
	for each pci-resource.
 b) run through each resource and satisfy the must-have requirement. 
 c) if (b) succeeds, run through each resource and *try* to satisfy the
	nice-to-way requirement.

 The other solution is to simply ignore preallocation to hotplug bridges.

Please suggest,
RP
	

> 
> Thanks,
> -- 
> Jesse Barnes, Intel Open Source Technology Center

-- 
Ram Pai
System X Device-Driver Enablement Lead
Linux Technology Center
Beaverton OR-97006
503-5783752 t/l 7753752
linuxram@us.ibm.com
