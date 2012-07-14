Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757252Ab2GNAOE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2012 20:14:04 -0400
Received: from mail.vyatta.com ([76.74.103.46]:41090 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752502Ab2GNAOB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2012 20:14:01 -0400
Date: Fri, 13 Jul 2012 17:13:44 -0700
From: Stephen Hemminger <shemminger@vyatta.com>
To: Jon Mason <jon.mason@intel.com>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-pci@vger.kernel.org, Dave Jiang <dave.jiang@intel.com>
Subject: Re: [RFC 1/2] PCI-Express Non-Transparent Bridge Support
Message-ID: <20120713171344.1066d3b1@nehalam.linuxnetplumber.net>
In-Reply-To: <1342215900-3358-1-git-send-email-jon.mason@intel.com>
References: <1342215900-3358-1-git-send-email-jon.mason@intel.com>
Organization: Vyatta
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 Jul 2012 14:44:59 -0700
Jon Mason <jon.mason@intel.com> wrote:

> A PCI-Express non-transparent bridge (NTB) is a point-to-point PCIe bus
> connecting 2 systems, providing electrical isolation between the two subsystems.
> A non-transparent bridge is functionally similar to a transparent bridge except
> that both sides of the bridge have their own independent address domains.  The
> host on one side of the bridge will not have the visibility of the complete
> memory or I/O space on the other side of the bridge.  To communicate across the
> non-transparent bridge, each NTB endpoint has one (or more) apertures exposed to
> the local system.  Writes to these apertures are mirrored to memory on the
> remote system.  Communications can also occur through the use of doorbell
> registers that initiate interrupts to the alternate domain, and scratch-pad
> registers accessible from both sides.
> 
> The NTB device driver is needed to configure these memory windows, doorbell, and
> scratch-pad registers as well as use them in such a way as they can be turned
> into a viable communication channel to the remote system.  ntb_hw.[ch]
> determines the usage model (NTB to NTB or NTB to Root Port) and abstracts away
> the underlying hardware to provide access and a common interface to the doorbell
> registers, scratch pads, and memory windows.  These hardware interfaces are
> exported so that other, non-mainlined kernel drivers can access these.
> ntb_transport.[ch] also uses the exported interfaces in ntb_hw.[ch] to setup a
> communication channel(s) and provide a reliable way of transferring data from
> one side to the other, which it then exports so that "client" drivers can access
> them.  These client drivers are used to provide a standard kernel interface
> (i.e., Ethernet device) to NTB, such that Linux can transfer data from one
> system to the other in a standard way.
> 
> Signed-off-by: Jon Mason <jon.mason@intel.com>

This driver does some reimplementing of standard type operations is this
because you are trying to use the same code on multiple platforms?

Example:
+
+static void ntb_list_add_head(spinlock_t *lock, struct list_head *entry,
+			      struct list_head *list)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(lock, flags);
+	list_add(entry, list);
+	spin_unlock_irqrestore(lock, flags);
+}
+
+static void ntb_list_add_tail(spinlock_t *lock, struct list_head *entry,
+			      struct list_head *list)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(lock, flags);
+	list_add_tail(entry, list);
+	spin_unlock_irqrestore(lock, flags);
+}

Which are used on skb's and yet we already have sk_buff_head with locking?

I know you probably are committed to this API, but is there some way to
reuse existing shared memory used by virtio-net between two ports?


