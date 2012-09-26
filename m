Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756545Ab2IZI5z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 04:57:55 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:47515 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754320Ab2IZI5u convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:3:1>);
	Wed, 26 Sep 2012 04:57:50 -0400
Message-Id: <5062DFC4020000780009DEA5@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Wed, 26 Sep 2012 09:58:12 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: "Konrad Rzeszutek Wilk" <konrad.wilk@oracle.com>
Cc: "xen-devel" <xen-devel@lists.xen.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH 2/2] xen/pciback: When resetting the
 device don't disable twice.
References: <1348608440-4018-1-git-send-email-konrad.wilk@oracle.com>
 <1348608440-4018-3-git-send-email-konrad.wilk@oracle.com>
In-Reply-To: <1348608440-4018-3-git-send-email-konrad.wilk@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 25.09.12 at 23:27, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> wrote:
> We call 'pci_disable_device' which sets the bus_master to zero
> and it also disables the PCI_COMMAND. There is no need to
> do it outside the PCI library.

Not really - pci_disable_device() only does anything if enable_cnt
drops to zero, and only clears the bus master flag in the command
word.

The code you delete fully zeros the command word unconditionally.
(I also noticed that the old [forward ported] code here forced
enable_cnt to zero.)

Hence the question is whether this really isn't a functional
change rather than mere cleanup.

Jan

> --- a/drivers/xen/xen-pciback/pciback_ops.c
> +++ b/drivers/xen/xen-pciback/pciback_ops.c
> @@ -114,10 +114,6 @@ void xen_pcibk_reset_device(struct pci_dev *dev)
>  			pci_disable_msi(dev);
>  #endif
>  		pci_disable_device(dev);
> -
> -		pci_write_config_word(dev, PCI_COMMAND, 0);
> -
> -		dev->is_busmaster = 0;
>  	} else {
>  		pci_read_config_word(dev, PCI_COMMAND, &cmd);
>  		if (cmd & (PCI_COMMAND_INVALIDATE)) {


