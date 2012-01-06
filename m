Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758781Ab2AFQTM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jan 2012 11:19:12 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:31389 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751022Ab2AFQTL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jan 2012 11:19:11 -0500
Date: Fri, 6 Jan 2012 11:17:26 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Ian Campbell <Ian.Campbell@citrix.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "jbarnes@virtuousgeek.org" <jbarnes@virtuousgeek.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>
Subject: Re: [Xen-devel] [PATCH 2/5] xen/pciback: Support pci_reset_function,
 aka FLR or D3 support.
Message-ID: <20120106161726.GA8657@phenom.dumpdata.com>
References: <1325724403-29642-1-git-send-email-konrad.wilk@oracle.com>
 <1325724403-29642-3-git-send-email-konrad.wilk@oracle.com>
 <1325759051.25206.361.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1325759051.25206.361.camel@zakaz.uk.xensource.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
X-CT-RefId: str=0001.0A090208.4F071EFC.000F,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 05, 2012 at 10:24:11AM +0000, Ian Campbell wrote:
> On Thu, 2012-01-05 at 00:46 +0000, Konrad Rzeszutek Wilk wrote:
> > We use the __pci_reset_function_locked to perform the action.
> > Also on attaching ("bind") and detaching ("unbind") we save and
> > restore the configuration states. When the device is disconnected
> > from a guest we use the "pci_reset_function" to also reset the
> > device before being passed to another guest.
> 
> Currently I thought the toolstack was supposed to do the reset (by
> writing to the reset node in sysfs) as it was (de)assigning devices
> to/from guests. That's not to say that there isn't an argument for
> preferring to do it kernels side but it would be interesting to make
> that argument explicitly.

I am kind of on the fence on this one. The one issue I found with
the toolstack is that it sometimes is run too late (now mind you -
I haven't actually found any bugs, so this might be all ballloony).

The xen-pciback can be used to inhibit drivers from grabbing the devices
during bootup. This can be done by 'xen-pciback.hide=(02:00.0)(02:00.1)(..)'

Pretty handy as you don't have to deal with:
 echo "0000:02:00.1" > /sys/bus/pci/devices/0000:02:00.1/drivers/unbind

and then later 'rmmod e1000e' to save some memory space.

The unfortunate side effect is that xen-pciback does this:

 pci_enable_device()
 pci_disable_device(dev)
 pci_write_config_word(dev, PCI_COMMAND, 0)

... and then when the guest finally uses the device it would (this is what
the toolstack does - I think?):

 echo "1" > /sys/bus/pci/devices/0000:02:00.1/reset

which calls
 pci_dev_reset() - do FLR or D3, or whatnot
 pci_save_state()

 pci_write_config_word(dev, PCI_COMMAND, PCI_COMMAND_INTX_DISABLE);

 pci_dev_reset(dev) [with a lock held so that "reset" on SysFS cannot be done]
 pci_restore_state()

which means that the PCI configuration state before the "pci_save_state"
is already influenced by what the xen-pciback had done during startup:
the pci_enable/pci_disable/pci_write_config_work(dev, PCI_COMMAND, 0).

When the 'pci_restore_state()' is called it would restore it to
what xen-pciback.hide=(xx) did. Not what the device state is before xen-pciback
gets its hand on it.

This is part of this patchset - were we make sure to save it before we do our deed.
(with those pci_save_config/pci_restore_config). 
And to be fair - I hadn't seen any issues with this, so it might not be
neccessary.

The other way of making this work is to remove the 
pci_write_config_work(dev, PCI_COMMAND, 0) but I hadn't seen any bugs with
that ..

> 
> I guess the toolstack doesn't currently save/restore the configuration
> state, could it though? I guess the state is all available in sysfs. On
> the other hand the kernel provides us with a very handy function which
> Just Does It...

Yeah, there is one more use case - 'xm'. The 'xm' does not do 'reset' on the 
SysFS so having it done in the kernel is kind of nice. But then 'xm' is on the
deprecated list so xen-unstable does not care about it. But I do since
Fedora Core 16 is using it ..

