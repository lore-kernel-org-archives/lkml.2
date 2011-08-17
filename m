Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753576Ab1HQTKr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Aug 2011 15:10:47 -0400
Received: from smtp.microsoft.com ([131.107.115.215]:41940 "EHLO
	smtp.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752793Ab1HQTKp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Aug 2011 15:10:45 -0400
From: KY Srinivasan <kys@microsoft.com>
To: Sasha Levin <levinsasha928@gmail.com>
CC: "gregkh@suse.de" <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: RE: [PATCH 7/8] Staging: hv: vmbus: Fix a bug in error handling in
 vmbus_bus_init()
Thread-Topic: [PATCH 7/8] Staging: hv: vmbus: Fix a bug in error handling in
 vmbus_bus_init()
Thread-Index: AQHMW5WZHDtwLLWhSUCA3QitSyA0fJUhgKEA///nFUA=
Date: Wed, 17 Aug 2011 19:10:44 +0000
Message-ID: <6E21E5352C11B742B20C142EB499E04808194C98@TK5EX14MBXC126.redmond.corp.microsoft.com>
References: <1313446210-10611-1-git-send-email-kys@microsoft.com>
	 <1313446327-10650-1-git-send-email-kys@microsoft.com>
	 <1313446327-10650-7-git-send-email-kys@microsoft.com>
 <1313587570.18295.2.camel@lappy>
In-Reply-To: <1313587570.18295.2.camel@lappy>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.54.51.36]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Sasha Levin [mailto:levinsasha928@gmail.com]
> Sent: Wednesday, August 17, 2011 9:26 AM
> To: KY Srinivasan
> Cc: gregkh@suse.de; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org; virtualization@lists.osdl.org; Haiyang Zhang
> Subject: Re: [PATCH 7/8] Staging: hv: vmbus: Fix a bug in error handling in
> vmbus_bus_init()
> 
> On Mon, 2011-08-15 at 15:12 -0700, K. Y. Srinivasan wrote:
> > Fix a bug in error handling in vmbus_bus_init().
> >
> > Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> > Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
> > ---
> 
> vmbus_bus_init() has a 'cleanup' label which is used just for returning,
> while the cleanup logic is replicated all over the code.
> 
> Can't we just move all of it to the cleanup label?

These are in  two different functions - vmbus_bus_init(),  hv_acpi_init().
 hv_cleanup() rolls back state established in hv_init(). I could look at 
cleaning up the error handling code.

Regards,

K. Y


> 
> >  drivers/staging/hv/vmbus_drv.c |    6 +++++-
> >  1 files changed, 5 insertions(+), 1 deletions(-)
> >
> > diff --git a/drivers/staging/hv/vmbus_drv.c b/drivers/staging/hv/vmbus_drv.c
> > index f20ab9a..0b0bff3 100644
> > --- a/drivers/staging/hv/vmbus_drv.c
> > +++ b/drivers/staging/hv/vmbus_drv.c
> > @@ -463,8 +463,10 @@ static int vmbus_bus_init(int irq)
> >  	tasklet_init(&event_dpc, vmbus_on_event, 0);
> >
> >  	ret = bus_register(&hv_bus);
> > -	if (ret)
> > +	if (ret) {
> > +		hv_cleanup();
> >  		return ret;
> > +	}
> >
> >  	ret = request_irq(irq, vmbus_isr, IRQF_SAMPLE_RANDOM,
> >  			driver_name, hv_acpi_dev);
> > @@ -473,6 +475,7 @@ static int vmbus_bus_init(int irq)
> >  		pr_err("Unable to request IRQ %d\n",
> >  			   irq);
> >
> > +		hv_cleanup();
> >  		bus_unregister(&hv_bus);
> >
> >  		return ret;
> > @@ -487,6 +490,7 @@ static int vmbus_bus_init(int irq)
> >  	on_each_cpu(hv_synic_init, (void *)&vector, 1);
> >  	ret = vmbus_connect();
> >  	if (ret) {
> > +		hv_cleanup();
> >  		free_irq(irq, hv_acpi_dev);
> >  		bus_unregister(&hv_bus);
> >  		return ret;
> 
> --
> 
> Sasha.
> 

