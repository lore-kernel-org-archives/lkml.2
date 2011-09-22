Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753134Ab1IVNyd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 09:54:33 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:47054 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752504Ab1IVNya (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 09:54:30 -0400
Date: Thu, 22 Sep 2011 07:54:28 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Neil Horman <nhorman@tuxdriver.com>
Cc: linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
        Jesse Barnes <jbarnes@virtuousgeek.org>, linux-pci@vger.kernel.org
Subject: Re: [PATCH] sysfs: add per pci device msi[x] irq listing (v3)
Message-ID: <20110922135428.GC16740@parisc-linux.org>
References: <1316025413-5855-1-git-send-email-nhorman@tuxdriver.com> <1316447235-31345-1-git-send-email-nhorman@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1316447235-31345-1-git-send-email-nhorman@tuxdriver.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 19, 2011 at 11:47:15AM -0400, Neil Horman wrote:
> So a while back, I wanted to provide a way for irqbalance (and other apps) to
> definitively map irqs to devices, which, for msi[x] irqs is currently not really
> possible in user space.  My first attempt wen't not so well:
> https://lkml.org/lkml/2011/4/21/308
> 
> It was plauged by the same issues that prior attempts were, namely that it
> violated the one-file-one-value sysfs rule.  I wandered off but have recently
> come back to this.  I've got a new implementation here that exports a new
> subdirectory for every pci device,  called msi_irqs.  This subdirectory contanis
> a variable number of numbered subdirectories, in which the number represents an
> msi irq.  Each numbered subdirectory contains attributes for that irq, which
> currently is only the mode it is operating in (msi vs. msix).  I think fits
> within the constraints sysfs requires, and will allow irqbalance to properly map
> msi irqs to devices without having to rely on rickety, best guess methods like
> interface name matching.

This approach feels like building bigger rockets instead of a space
elevator :-)

What we need is to allow device drivers to ask for per-CPU interrupts,
and implement them in terms of MSI-X.  I've made a couple of stabs at
implementing this, but haven't got anything working yet.  It would solve
a number of problems:

1. NUMA cacheline fetch.  At the moment, desc->istate gets modified by
handle_edge_irq.  handle_percpu_irq doesn't need to worry about any
of that stuff, so doesn't touch desc->istate.  I've heard this is a
significant problem for the high-speed networking people.

2. /proc/interrupts is unmanagable on large machines.  There are hundreds
of interrupts and dozens of CPUs.  This would go a long way to reducing
the number of rows in the table (doesn't do anything about the columns).

ie instead of this:

 79:          0          0          0          0          0          0          0          0   PCI-MSI-edge      eth1
 80:          0          0    9275611          0          0          0          0          0   PCI-MSI-edge      eth1-TxRx-0
 81:          0          0    9275611          0          0          0          0          0   PCI-MSI-edge      eth1-TxRx-1
 82:          0          0          0          0    9275611          0          0          0   PCI-MSI-edge      eth1-TxRx-2
 83:          0          0          0          0    9275611          0          0          0   PCI-MSI-edge      eth1-TxRx-3
 84:          0          0          0          0          0    9275611          0          0   PCI-MSI-edge      eth1-TxRx-4
 85:          0          0          0          0          0    9275611          0          0   PCI-MSI-edge      eth1-TxRx-5
 86:          0          0          0          0          0          0    9275611          0   PCI-MSI-edge      eth1-TxRx-6
 87:          0          0          0          0          0          0    9275611          0   PCI-MSI-edge      eth1-TxRx-7

We'd get this:

 79:          0          0          0          0          0          0          0          0   PCI-MSI-edge      eth1
 80:    9275611    9275611    9275611    9275611    9275611    9275611    9275611    9275611   PCI-MSI-edge      eth1-TxRx

3. /proc/irq/x/smp_affinity actually makes sense again.  It can be a
mask of which interrupts are active instead of being a degenerate case
in which only the lowest set bit is actually honoured.

4. Easier to manage for the device driver.  All it needs is to call
request_percpu_irq(...) instead of trying to figure out how many
threads/cores/numa nodes/... there are in the machine, and how many
other multi-interrupt devices there are; and thus how many interrupts
it should allocate.  That can be left to the interrupt core which at
least has a chance of getting it right.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
