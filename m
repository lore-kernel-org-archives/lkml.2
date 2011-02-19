Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755413Ab1BSOex (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Feb 2011 09:34:53 -0500
Received: from mail3.microsoft.com ([131.107.115.214]:27712 "EHLO
	smtp.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754766Ab1BSOew convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Feb 2011 09:34:52 -0500
From: KY Srinivasan <kys@microsoft.com>
To: Thomas Gleixner <tglx@linutronix.de>
CC: "gregkh@suse.de" <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        "Hank Janssen" <hjanssen@microsoft.com>
Subject: RE: [PATCH]: Staging: hv: Allocate the vmbus irq dynamically
Thread-Topic: [PATCH]: Staging: hv: Allocate the vmbus irq dynamically
Thread-Index: AQHLzUkvKd3MYDWV20OaBRjCSuUWD5QJKYYA//++VEA=
Date: Sat, 19 Feb 2011 14:34:51 +0000
Message-ID: <6E21E5352C11B742B20C142EB499E048011738@TK5EX14MBXC124.redmond.corp.microsoft.com>
References: <1297799735-25917-1-git-send-email-kys@microsoft.com>
 <alpine.LFD.2.00.1102191046220.2701@localhost6.localdomain6>
In-Reply-To: <alpine.LFD.2.00.1102191046220.2701@localhost6.localdomain6>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.54.123.12]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Thomas Gleixner [mailto:tglx@linutronix.de]
> Sent: Saturday, February 19, 2011 5:23 AM
> To: KY Srinivasan
> Cc: gregkh@suse.de; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org; virtualization@lists.osdl.org; Haiyang Zhang; Hank
> Janssen
> Subject: Re: [PATCH]: Staging: hv: Allocate the vmbus irq dynamically
> 
> On Tue, 15 Feb 2011, K. Y. Srinivasan wrote:
> > -/* FIXME! We need to do this dynamically for PIC and APIC system */
> > -#define VMBUS_IRQ		0x5
> > -#define VMBUS_IRQ_VECTOR	IRQ5_VECTOR
> > +static int vmbus_irq;
> >
> >  /* Main vmbus driver data structure */
> >  struct vmbus_driver_context {
> > @@ -57,6 +55,27 @@ struct vmbus_driver_context {
> >  	struct vm_device device_ctx;
> >  };
> >
> > +/*
> > + * Find an un-used IRQ that the VMBUS can use. If none is available;
> > + * return -EBUSY.
> > + */
> > +static int vmbus_get_irq(void)
> > +{
> > +	unsigned int avail_irq_mask;
> > +	int irq = -EBUSY;
> > +
> > +	/*
> > +	 * Pick the first unused interrupt. HyperV can
> > +	 * interrupt us on any interrupt line we specify.
> > +	 */
> > +
> > +	avail_irq_mask = probe_irq_on();
> > +	if (avail_irq_mask != 0)
> > +		irq = ffs(avail_irq_mask);
> > +	probe_irq_off(avail_irq_mask);
> > +	return irq;
> 
> 
> Please do not use probe_irq_on for dynamic irq allocation. Highjacking
> the lower PIC irqs is really not a good idea. Depending on when this
> runs, you might grab an irq required by a driver which gets loaded
> later.
> 
> Could you please explain what you're trying to do here ?

The IRQ being allocated is for the VMBUS driver for Linux guests running on
a Windows virtualization platform (Hyper-V hypervisor).
The hypervisor is capable of notifying events on the VMBUS via
a guest specified interrupt line. Prior to this patch,
the code was statically selecting an interrupt line for
use by VMBUS. One of the long standing review comments
on  that code was to make this irq allocation dynamic and that
is what this patch does. For the Linux guest running as a VM
on Hyper-V, the concern you raise is not an issue.

Regards,

K. Y

