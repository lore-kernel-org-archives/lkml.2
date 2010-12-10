Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756462Ab0LJNkD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Dec 2010 08:40:03 -0500
Received: from e36.co.us.ibm.com ([32.97.110.154]:38206 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756435Ab0LJNkA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Dec 2010 08:40:00 -0500
Date: Fri, 10 Dec 2010 08:39:05 -0500
From: Josh Boyer <jwboyer@linux.vnet.ibm.com>
To: Rupjyoti Sarmah <rsarmah@amcc.com>
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org, rsarmah@apm.com
Subject: Re: [PATCH v5] ppc44x:PHY fixup for USB on canyonlands board
Message-ID: <20101210133905.GE1903@zod.rchland.ibm.com>
References: <201012090424.oB94O1DV006463@amcc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201012090424.oB94O1DV006463@amcc.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 09, 2010 at 09:54:01AM +0530, Rupjyoti Sarmah wrote:

A few error path issues, plus one leak in the good case.  I'll wait to
see if there are any more comments for a couple of days.

>+static int __init ppc460ex_canyonlands_fixup(void)
>+{
>+	u8 __iomem *bcsr ;
>+	void __iomem *vaddr;
>+	struct device_node *np;
>+	int ret = 0;
>+
>+	np = of_find_compatible_node(NULL, NULL, "amcc,ppc460ex-bcsr");
>+	if (!np) {
>+		printk(KERN_ERR "failed did not find amcc, ppc460ex bcsr node\n");
>+		return -ENODEV;
>+	}
>+
>+	bcsr = of_iomap(np, 0);
>+	of_node_put(np);
>+
>+	if (!bcsr) {
>+		printk(KERN_CRIT "Could not remap bcsr\n");
>+		ret = -ENODEV;
>+	}
>+
>+	np = of_find_compatible_node(NULL, NULL, "ibm,ppc4xx-gpio");

This can fail if you boot a new kernel on a board with an old FDT that
lacks the gpio node.  Calling of_iomap with a NULL np seems like it
would work without crashing anything, so maybe that's not a huge issue.

>+	vaddr = of_iomap(np, 0);
>+	if (!vaddr) {
>+		printk(KERN_CRIT "Could not get gpio node address\n");
>+		ret = -ENODEV;
>+		goto err_bcsr;
>+	}

A reference count is leaked for the node in this error case because
of_node_put isn't called for the gpio node.  Also, iounmap is never
called on vaddr.

>+	/* Disable USB, through the BCSR7 bits */
>+	setbits8(&bcsr[7], BCSR_USB_EN);
>+
>+	/* Wait for a while after reset */
>+	msleep(100);
>+
>+	/* Enable USB here */
>+	clrbits8(&bcsr[7], BCSR_USB_EN);
>+
>+	/*
>+	 * Configure multiplexed gpio16 and gpio19 as alternate1 output
>+	 * source after USB reset. In this configuration gpio16 will be
>+	 * USB2HStop and gpio19 will be USB2DStop. For more details refer to
>+	 * table 34-7 of PPC460EX user manual.
>+	 */
>+	setbits32((vaddr + GPIO0_OSRH), 0x42000000);
>+	setbits32((vaddr + GPIO0_TSRH), 0x42000000);
>+	of_node_put(np);
>+err_bcsr:
>+	iounmap(bcsr);
>+	return ret;
>+}
>+machine_device_initcall(canyonlands, ppc460ex_canyonlands_fixup);

josh
