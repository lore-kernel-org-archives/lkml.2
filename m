Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752434Ab1B1EDc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Feb 2011 23:03:32 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:34557 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752227Ab1B1EDa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Feb 2011 23:03:30 -0500
From: "TK, Pratheesh Gangadhar" <pratheesh@ti.com>
To: Thomas Gleixner <tglx@linutronix.de>
CC: "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
        "hjk@hansjkoch.de" <hjk@hansjkoch.de>,
        "gregkh@suse.de" <gregkh@suse.de>,
        "sshtylyov@mvista.com" <sshtylyov@mvista.com>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "Chatterjee, Amit" <amit.chatterjee@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Date: Mon, 28 Feb 2011 09:32:54 +0530
Subject: RE: [PATCH v5 1/2] PRUSS UIO driver support
Thread-Topic: [PATCH v5 1/2] PRUSS UIO driver support
Thread-Index: AcvU0glPCxBF0LAlQbGylpXtJlNFegCKZfaw
Message-ID: <B85A65D85D7EB246BE421B3FB0FBB593024BF358B3@dbde02.ent.ti.com>
References: <1298623530-10294-1-git-send-email-pratheesh@ti.com>
 <1298623530-10294-2-git-send-email-pratheesh@ti.com>
 <alpine.LFD.2.00.1102251049090.2701@localhost6.localdomain6>
In-Reply-To: <alpine.LFD.2.00.1102251049090.2701@localhost6.localdomain6>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> -----Original Message-----
> From: Thomas Gleixner [mailto:tglx@linutronix.de]
> Sent: Friday, February 25, 2011 3:24 PM
> To: TK, Pratheesh Gangadhar
> Cc: davinci-linux-open-source@linux.davincidsp.com; hjk@hansjkoch.de;
> gregkh@suse.de; sshtylyov@mvista.com; arnd@arndb.de; Chatterjee, Amit;
> linux-kernel@vger.kernel.org; linux-arm-kernel@lists.infradead.org
> Subject: Re: [PATCH v5 1/2] PRUSS UIO driver support
> 
> On Fri, 25 Feb 2011, Pratheesh Gangadhar wrote:
> > +static irqreturn_t pruss_handler(int irq, struct uio_info *dev_info)
> > +{
> > +	void __iomem *base = dev_info->mem[0].internal_addr;
> > +	void __iomem *intren_reg = base + PINTC_HIER;
> > +	void __iomem *intrstat_reg = base + PINTC_HIPIR + ((irq - 1) << 2);
> > +	int val = ioread32(intren_reg), intr_mask = (1 << (irq - 1));
> > +
> > +	/* Is interrupt enabled and active ? */
> > +	if (!(val & intr_mask) && (ioread32(intrstat_reg) & HIPIR_NOPEND))
> > +		return IRQ_NONE;
> > +
> > +	/* Disable interrupt */
> > +	iowrite32((val & ~intr_mask), intren_reg);
> > +	return IRQ_HANDLED;
> > +}
> 
> Hmm, just noticed, that you fiddle with the interrupt enable register
> here totally unprotected. So on a SMP system you might haandle two
> different interrupts at the same time. That wants locking.
> 
> And even on UP, you have a problem as you reenable that thing from
> user space which requires a read modify write. Racy as hell.
> 
> Please look at the other UIO drivers which have the same problem.
> Sorry for not noticing earlier!

Thanks for pointing this out. Yes - this is a problem especially since we have more than one interrupt for PRUSS which is enabled/disabled in this register. I will fix this and resubmit along with fixes addressing Sergei's comments on platform specific portion.

Thanks,
Pratheesh

