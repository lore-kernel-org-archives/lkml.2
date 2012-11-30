Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755298Ab2K3BlS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 20:41:18 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:57718 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753467Ab2K3BlQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 20:41:16 -0500
Date: Thu, 29 Nov 2012 17:41:12 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com, Gavin Shan <shangw@linux.vnet.ibm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: Re: [PATCH 026/270] powerpc/eeh: Lock module while handling EEH event
Message-ID: <20121130014112.GC13478@kroah.com>
References: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
 <1353949160-26803-27-git-send-email-herton.krzesinski@canonical.com>
 <1353982714.4266.36.camel@deadeye.wl.decadent.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1353982714.4266.36.camel@deadeye.wl.decadent.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 27, 2012 at 02:18:34AM +0000, Ben Hutchings wrote:
> On Mon, 2012-11-26 at 14:55 -0200, Herton Ronaldo Krzesinski wrote:
> > 3.5.7u1 -stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Gavin Shan <shangw@linux.vnet.ibm.com>
> > 
> > commit feadf7c0a1a7c08c74bebb4a13b755f8c40e3bbc upstream.
> > 
> > The EEH core is talking with the PCI device driver to determine the
> > action (purely reset, or PCI device removal). During the period, the
> > driver might be unloaded and in turn causes kernel crash as follows:
> > 
> > EEH: Detected PCI bus error on PHB#4-PE#10000
> > EEH: This PCI device has failed 3 times in the last hour
> > lpfc 0004:01:00.0: 0:2710 PCI channel disable preparing for reset
> > Unable to handle kernel paging request for data at address 0x00000490
> > Faulting instruction address: 0xd00000000e682c90
> > cpu 0x1: Vector: 300 (Data Access) at [c000000fc75ffa20]
> >     pc: d00000000e682c90: .lpfc_io_error_detected+0x30/0x240 [lpfc]
> >     lr: d00000000e682c8c: .lpfc_io_error_detected+0x2c/0x240 [lpfc]
> >     sp: c000000fc75ffca0
> >    msr: 8000000000009032
> >    dar: 490
> >  dsisr: 40000000
> >   current = 0xc000000fc79b88b0
> >   paca    = 0xc00000000edb0380	 softe: 0	 irq_happened: 0x00
> >     pid   = 3386, comm = eehd
> > enter ? for help
> > [c000000fc75ffca0] c000000fc75ffd30 (unreliable)
> > [c000000fc75ffd30] c00000000004fd3c .eeh_report_error+0x7c/0xf0
> > [c000000fc75ffdc0] c00000000004ee00 .eeh_pe_dev_traverse+0xa0/0x180
> > [c000000fc75ffe70] c00000000004ffd8 .eeh_handle_event+0x68/0x300
> > [c000000fc75fff00] c0000000000503a0 .eeh_event_handler+0x130/0x1a0
> > [c000000fc75fff90] c000000000020138 .kernel_thread+0x54/0x70
> > 1:mon>
> > 
> > The patch increases the reference of the corresponding driver modules
> > while EEH core does the negotiation with PCI device driver so that the
> > corresponding driver modules can't be unloaded during the period and
> > we're safe to refer the callbacks.
> > 
> > Reported-by: Alexey Kardashevskiy <aik@ozlabs.ru>
> > Signed-off-by: Gavin Shan <shangw@linux.vnet.ibm.com>
> > Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> > [ herton: backported for 3.5, adjusted driver assignments, return 0
> >   instead of NULL, assume dev is not NULL ]
> > Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
> [...]
> 
> Greg, you probably want this in 3.4 and 3.6.

Many thanks.  Herton, any reason why you didn't forward on this
backported version of the patch?

greg k-h
