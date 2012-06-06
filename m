Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754141Ab2FFNuO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 09:50:14 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:51081 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753470Ab2FFNuN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 09:50:13 -0400
Date: Wed, 6 Jun 2012 14:50:09 +0100
From: Matthew Garrett <mjg@redhat.com>
To: Khalid Aziz <khalid.aziz@hp.com>
Cc: linux-kernel@vger.kernel.org, bhelgaas@google.com,
        linux-pci@vger.kernel.org
Subject: Re: [PATCH] Disable Bus Master on PCI device shutdown
Message-ID: <20120606135009.GB1517@srcf.ucam.org>
References: <20120427190033.GA17588@ldl.usa.hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120427190033.GA17588@ldl.usa.hp.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 27, 2012 at 01:00:33PM -0600, Khalid Aziz wrote:
> Disable Bus Master bit on the device in
> pci_device_shutdown() to ensure PCI devices do not continue
> to DMA data after shutdown. This can cause memory
> corruption in case of a kexec where the current kernel
> shuts down and transfers control to a new kernel while a
> PCI device continues to DMA to memory that does not belong
> to it any more in the new kernel.

This protects against the case where a piece of hardware is continuing 
to DMA even after the driver shutdown method has been called? I'm not 
convinced this is safe. Some Broadcom parts will crash if busmastering 
is disabled while they're still performing DMA, and they'll then hang 
the bus if reenabled. There's also the risk that the hardware will start 
DMAing again if it's reenabled after being shut down. It seems like 
you're covering over the case where the driver didn't correctly quiesce 
the hardware, but you risk triggering other bugs instead.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
