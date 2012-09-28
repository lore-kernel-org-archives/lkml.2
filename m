Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757282Ab2I1IsG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 04:48:06 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:42949 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754595Ab2I1IsB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 04:48:01 -0400
Date: Fri, 28 Sep 2012 09:46:52 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Ming Lei <ming.lei@canonical.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] driver core: fix possible missing of device probe
Message-ID: <20120928084652.GC7916@n2100.arm.linux.org.uk>
References: <1348793563-19186-1-git-send-email-ming.lei@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1348793563-19186-1-git-send-email-ming.lei@canonical.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 28, 2012 at 08:52:43AM +0800, Ming Lei wrote:
> Inside bus_add_driver(), one device might be added into
> the bus or probed which is triggered by deferred probe
> just after completing of driver_attach() and before
> 'klist_add_tail(&priv->knode_bus, &bus->p->klist_drivers)',
> so the device won't be probed by this driver.
> 
> This patch moves the below line
> 
> 	'klist_add_tail(&priv->knode_bus, &bus->p->klist_drivers)'
> 
> before driver_attach() inside bus_add_driver().
> 
> So fixes the problem since the below way can guarantee that
> no probe(dev) may be lost.
> 
> CPU0                            	CPU1
> driver_register
> 	...
> 	write(bus->driver_list)
> 	smp_mb()
> 	read(bus->device_list)
> 	...
> 					device_add
> 						/* bus_add_device */
> 						write(bus->device_list)
> 						smp_mb()
> 						/* bus_probe_device*/
> 						read(bus->driver_list)
> 
> And the smp_mb() has been implicit by UNLOCK+LOCK
> of 'klist' according to 'VARIETIES OF MEMORY BARRIER' part
> of Documentation/memory-barriers.txt.
> 
> Reported-and-Tested-by: Russell King <linux@arm.linux.org.uk>

Please use rmk+kernel@arm.linux.org.uk here, thanks.
