Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755272Ab1H3RHg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 13:07:36 -0400
Received: from mailb.microsoft.com ([131.107.115.215]:58120 "EHLO
	smtp.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753657Ab1H3RHf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 13:07:35 -0400
From: KY Srinivasan <kys@microsoft.com>
To: Greg KH <greg@kroah.com>
CC: "gregkh@suse.de" <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: RE: [PATCH 41/46] Staging: hv: vmbus: Fix a bug in error handling
 in vmbus_bus_init()
Thread-Topic: [PATCH 41/46] Staging: hv: vmbus: Fix a bug in error handling
 in vmbus_bus_init()
Thread-Index: AQHMZOS1xsL7F2lXdkukWoVslPXxw5U0mO0AgAELx1A=
Date: Tue, 30 Aug 2011 17:07:34 +0000
Message-ID: <6E21E5352C11B742B20C142EB499E048081B5307@TK5EX14MBXC126.redmond.corp.microsoft.com>
References: <1314469874-7017-1-git-send-email-kys@microsoft.com>
 <1314469905-7058-1-git-send-email-kys@microsoft.com>
 <1314469905-7058-41-git-send-email-kys@microsoft.com>
 <20110829180842.GA23618@kroah.com>
In-Reply-To: <20110829180842.GA23618@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.54.51.33]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Greg KH [mailto:greg@kroah.com]
> Sent: Monday, August 29, 2011 2:09 PM
> To: KY Srinivasan
> Cc: gregkh@suse.de; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org; virtualization@lists.osdl.org; Haiyang Zhang
> Subject: Re: [PATCH 41/46] Staging: hv: vmbus: Fix a bug in error handling in
> vmbus_bus_init()
> 
> On Sat, Aug 27, 2011 at 11:31:40AM -0700, K. Y. Srinivasan wrote:
> > Fix a bug in error handling in vmbus_bus_init().
> >
> > Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> > Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
> > ---
> >  drivers/staging/hv/vmbus_drv.c |   21 ++++++++++-----------
> >  1 files changed, 10 insertions(+), 11 deletions(-)
> >
> > diff --git a/drivers/staging/hv/vmbus_drv.c b/drivers/staging/hv/vmbus_drv.c
> > index 02edb11..4d1b123 100644
> > --- a/drivers/staging/hv/vmbus_drv.c
> > +++ b/drivers/staging/hv/vmbus_drv.c
> > @@ -492,7 +492,7 @@ static int vmbus_bus_init(int irq)
> >
> >  	ret = bus_register(&hv_bus);
> >  	if (ret)
> > -		return ret;
> > +		goto err1;
> >
> >  	ret = request_irq(irq, vmbus_isr, IRQF_SAMPLE_RANDOM,
> >  			driver_name, hv_acpi_dev);
> > @@ -500,10 +500,7 @@ static int vmbus_bus_init(int irq)
> >  	if (ret != 0) {
> >  		pr_err("Unable to request IRQ %d\n",
> >  			   irq);
> > -
> > -		bus_unregister(&hv_bus);
> > -
> > -		return ret;
> > +		goto err2;
> >  	}
> >
> >  	vector = IRQ0_VECTOR + irq;
> > @@ -514,16 +511,18 @@ static int vmbus_bus_init(int irq)
> >  	 */
> >  	on_each_cpu(hv_synic_init, (void *)&vector, 1);
> >  	ret = vmbus_connect();
> > -	if (ret) {
> > -		free_irq(irq, hv_acpi_dev);
> > -		bus_unregister(&hv_bus);
> > -		return ret;
> > -	}
> > -
> > +	if (ret)
> > +		goto err3;
> >
> >  	vmbus_request_offers();
> >
> >  	return 0;
> > +
> > +err3:	free_irq(irq, hv_acpi_dev);
> > +err2:	bus_unregister(&hv_bus);
> > +err1:	hv_cleanup();
> 
> The traditional way to write this is:
> 
> err3:
> 	free_irq(irq, hv_acpi_dev);
> err2:
> 	bus_unregister(&hv_bus);
> err1:
> 	hv_cleanup();
> 
> Care to fix this up and resend it?

Will do.

Regards,

K. Y

