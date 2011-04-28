Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933445Ab1D1UEE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 16:04:04 -0400
Received: from na3sys009aog111.obsmtp.com ([74.125.149.205]:50082 "EHLO
	na3sys009aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757013Ab1D1UEC convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 16:04:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=nanometrics.ca; s=google;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=XyoHPxtt1GwiWHCoyJS3bz22BRTPICQelzMhSZximesz/xzdQ6omTOxyLXW+Pfm9gA
         Fl0FOXv5BHaVuK5D/SDAo+AnperRNt992t1LkweE6QXTbushpcs+8J0egRJiGKx4UqYa
         4PlpcA/QFv6CCZ6kaGCZq094BY4W/v/34cTZ0=
MIME-Version: 1.0
In-Reply-To: <20110428152222.0271163f@apollo.gnet>
References: <1303928054-14662-3-git-send-email-jamesnuss@nanometrics.ca>
	<20110428152222.0271163f@apollo.gnet>
Date: Thu, 28 Apr 2011 16:03:59 -0400
Message-ID: <BANLkTimG0vL3Ky=ARa+7XyW4PSFdg064YQ@mail.gmail.com>
Subject: Re: [LinuxPPS] [PATCH 2/2] pps: new client driver using IRQs
From: James Nuss <jamesnuss@nanometrics.ca>
To: Alexander Gordeev <lasaine@lvk.cs.msu.su>
Cc: Rodolfo Giometti <rodolfo.giometti@enneenne.com>,
        Ricardo Martins <rasm@fe.up.pt>, linuxpps@ml.enneenne.com,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alexander,

Thanks for reviewing the code.

On Thu, Apr 28, 2011 at 7:22 AM, Alexander Gordeev
<lasaine@lvk.cs.msu.su> wrote:
> Hi James,
>
> В Wed, 27 Apr 2011 14:14:14 -0400
> James Nuss <jamesnuss@nanometrics.ca> пишет:
>
>> This client driver allows you to use raw IRQs as a source for PPS
>> signals.
>>
>> This driver is based on the work by Ricardo Martins <rasm@fe.up.pt> who
>> submitted an initial implementation [1] of a PPS IRQ client driver to
>> the linuxpps mailing-list on Dec 3 2010.
>>
>> [1] http://ml.enneenne.com/pipermail/linuxpps/2010-December/004155.html
>>
>> Signed-off-by: James Nuss <jamesnuss@nanometrics.ca>
>> Reviewed-by: Ben Gardiner <bengardiner@nanometrics.ca>
>> CC: Ricardo Martins <rasm@fe.up.pt>
>> ---
>> NOTE: drivers/pps/clients/Kconfig does not have the obligatory statements
>> regarding building the drivers as modules, even though they are all tristates.
>> This was purposefully omitted from the new config item for consistency.
>> This could be addressed in a separate patch.
>>
>>  drivers/pps/clients/Kconfig   |    8 ++
>>  drivers/pps/clients/Makefile  |    1 +
>>  drivers/pps/clients/pps-irq.c |  169 +++++++++++++++++++++++++++++++++++++++++
>>  3 files changed, 178 insertions(+), 0 deletions(-)
>>  create mode 100644 drivers/pps/clients/pps-irq.c
>>
>> diff --git a/drivers/pps/clients/Kconfig b/drivers/pps/clients/Kconfig
>> index 8520a7f..94b2cc6 100644
>> --- a/drivers/pps/clients/Kconfig
>> +++ b/drivers/pps/clients/Kconfig
>> @@ -29,4 +29,12 @@ config PPS_CLIENT_PARPORT
>>         If you say yes here you get support for a PPS source connected
>>         with the interrupt pin of your parallel port.
>>
>> +config PPS_CLIENT_IRQ
>> +     tristate "PPS client based on raw IRQs"
>> +     depends on PPS
>> +     help
>> +       If you say yes here you get support for a PPS source based
>> +       on raw IRQs. To be useful, you must also register a platform
>> +       device with an IRQ resource, usually in your board setup.
>> +
>>  endif
>> diff --git a/drivers/pps/clients/Makefile b/drivers/pps/clients/Makefile
>> index 42517da..609a332 100644
>> --- a/drivers/pps/clients/Makefile
>> +++ b/drivers/pps/clients/Makefile
>> @@ -5,6 +5,7 @@
>>  obj-$(CONFIG_PPS_CLIENT_KTIMER)      += pps-ktimer.o
>>  obj-$(CONFIG_PPS_CLIENT_LDISC)       += pps-ldisc.o
>>  obj-$(CONFIG_PPS_CLIENT_PARPORT) += pps_parport.o
>> +obj-$(CONFIG_PPS_CLIENT_IRQ) += pps-irq.o
>>
>>  ifeq ($(CONFIG_PPS_DEBUG),y)
>>  EXTRA_CFLAGS += -DDEBUG
>> diff --git a/drivers/pps/clients/pps-irq.c b/drivers/pps/clients/pps-irq.c
>> new file mode 100644
>> index 0000000..33c1bf4
>> --- /dev/null
>> +++ b/drivers/pps/clients/pps-irq.c
>> @@ -0,0 +1,169 @@
>> +/*
>> + * pps-irq.c -- PPS IRQ client
>> + *
>> + *
>> + * Copyright (C) 2010 Ricardo Martins <rasm@fe.up.pt>
>> + * Copyright (C) 2011 James Nuss <jamesnuss@nanometrics.ca>
>> + *
>> + *   This program is free software; you can redistribute it and/or modify
>> + *   it under the terms of the GNU General Public License as published by
>> + *   the Free Software Foundation; either version 2 of the License, or
>> + *   (at your option) any later version.
>> + *
>> + *   This program is distributed in the hope that it will be useful,
>> + *   but WITHOUT ANY WARRANTY; without even the implied warranty of
>> + *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>> + *   GNU General Public License for more details.
>> + *
>> + *   You should have received a copy of the GNU General Public License
>> + *   along with this program; if not, write to the Free Software
>> + *   Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
>> + */
>> +
>> +#include <linux/init.h>
>> +#include <linux/kernel.h>
>> +#include <linux/interrupt.h>
>> +#include <linux/module.h>
>> +#include <linux/platform_device.h>
>> +#include <linux/slab.h>
>> +#include <linux/pps_kernel.h>
>> +#include <linux/gpio.h>
>> +#include <linux/list.h>
>> +
>> +#define PPS_IRQ_NAME            "pps-irq"
>> +#define PPS_IRQ_VERSION         "1.1.0"
>> +
>> +/* Info for each registered platform device */
>> +struct pps_irq_data {
>> +     int irq;                        /* IRQ used as PPS source */
>> +     struct pps_device *pps;         /* PPS source device */
>> +     struct pps_source_info info;    /* PPS source information */
>> +};
>> +
>> +/*
>> + * Report the PPS event
>> + */
>> +
>> +static irqreturn_t pps_irq_irq_handler(int irq, void *data)
>> +{
>> +     struct pps_irq_data *info;
>> +     struct pps_event_time ts;
>> +
>> +     /* Get the time stamp first */
>> +     pps_get_ts(&ts);
>> +
>> +     info = (struct pps_irq_data *)data;
>> +     pps_event(info->pps, &ts, PPS_CAPTUREASSERT, NULL);
>> +
>> +     return IRQ_HANDLED;
>> +}
>> +
>> +static int pps_irq_probe(struct platform_device *pdev)
>> +{
>> +     struct pps_irq_data *data;
>> +     struct resource *res;
>> +     int irq;
>> +     int ret;
>> +
>> +     /* Validate resource. */
>> +     if (pdev->num_resources != 1) {
>> +             pr_err(PPS_IRQ_NAME ": this driver handles only one IRQ resource");
>
> Shouldn't the format string in pr_*/dev_* call be ended with a '\n' or I
> missed something?
> Also I suggest you what I was once suggested: to define pr_fmt() macro
> with a module name as in drivers/pps/clients/pps_parport.c to omit
> it's use in every pr_* call. :)

You are right with the '\n'. My mistake.
Good suggestion on the pr_fmt() macro - that's much cleaner.

>
>> +             return -EINVAL;
>> +     }
>> +
>> +     res = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
>> +     if (res == NULL) {
>> +             pr_err(PPS_IRQ_NAME ": no IRQ resource was given");
>> +             return -EINVAL;
>> +     }
>> +
>> +     if (!(res->flags & (IRQF_TRIGGER_RISING | IRQF_TRIGGER_FALLING))) {
>> +             pr_err(PPS_IRQ_NAME ": given IRQ resource must be edge triggered");
>> +             return -EINVAL;
>> +     }
>
> I think it doesn't actually expect that both flags are set because it
> always treats it as assert in the irq handler. What does your signal
> look like?

The conditional logic is that one of either IRQF_TRIGGER_RISING or
IRQF_TRIGGER_FALLING must be set. It doesn't make much sense to have
neither set for PPS signals.
My intention is that the driver is generic enough so you can register
an IRQ resource with either IRQF_TRIGGER_RISING or
IRQF_TRIGGER_FALLING and you will get and assert event for that edge.
Clear events are not generated as you suggest but I believe this is
OK.
My signal is a simple low-to-high transition indicating the PPS. But I
believe you could register a device using this driver referencing the
other edge if required.

>
>> +     /* Allocate space for device info */
>> +     data = kzalloc(sizeof(struct pps_irq_data), GFP_KERNEL);
>> +     if (data == NULL)
>> +             return -ENOMEM;
>> +
>> +     /* Initialize PPS specific parts of the bookkeeping data structure. */
>> +     data->info.mode = PPS_CAPTUREASSERT | PPS_OFFSETASSERT |
>> +                     PPS_ECHOASSERT | PPS_CANWAIT | PPS_TSFMT_TSPEC;
>> +     data->info.owner = THIS_MODULE;
>> +     snprintf(data->info.name, PPS_MAX_NAME_LEN - 1, "%s.%d",
>> +              pdev->name, pdev->id);
>> +
>> +     /* Register PPS source. */
>> +     irq = platform_get_irq(pdev, 0);
>> +     pr_info(PPS_IRQ_NAME ": registering IRQ %d as PPS source", irq);
>> +     data->pps = pps_register_source(&data->info, PPS_CAPTUREASSERT
>> +                                     | PPS_OFFSETASSERT);
>> +     if (data->pps == NULL) {
>> +             kfree(data);
>> +             pr_err(PPS_IRQ_NAME ": failed to register IRQ %d as PPS source",
>> +                             irq);
>> +             return -1;
>> +     }
>> +
>> +     /* Request IRQ. */
>> +     pr_info(PPS_IRQ_NAME ": requesting IRQ %d", irq);
>> +     ret = request_irq(irq, pps_irq_irq_handler,
>> +                      res->flags & IRQF_TRIGGER_MASK,
>> +                      data->info.name, data);
>> +     if (ret) {
>> +             pps_unregister_source(data->pps);
>> +             kfree(data);
>> +             pr_err(PPS_IRQ_NAME ": failed to acquire IRQ %d\n", irq);
>> +             return ret;
>> +     }
>> +     data->irq = irq;
>> +
>> +     platform_set_drvdata(pdev, data);
>> +     dev_info(data->pps->dev, "Registered IRQ %d as PPS source", data->irq);
>> +
>> +     return 0;
>> +}
>> +
>> +static int pps_irq_remove(struct platform_device *pdev)
>> +{
>> +     struct pps_irq_data *data = platform_get_drvdata(pdev);
>> +     platform_set_drvdata(pdev, NULL);
>> +     free_irq(data->irq, data);
>> +     pps_unregister_source(data->pps);
>> +     pr_info(PPS_IRQ_NAME ": removed IRQ %d as PPS source", data->irq);
>> +     kfree(data);
>> +     return 0;
>> +}
>> +
>> +static struct platform_driver pps_irq_driver = {
>> +     .probe          = pps_irq_probe,
>> +     .remove         =  __devexit_p(pps_irq_remove),
>> +     .driver         = {
>> +             .name   = PPS_IRQ_NAME,
>> +             .owner  = THIS_MODULE
>> +     },
>> +};
>> +
>> +static int __init pps_irq_init(void)
>> +{
>> +     int ret = platform_driver_register(&pps_irq_driver);
>> +     if (ret < 0)
>> +             pr_err(PPS_IRQ_NAME ": failed to register platform driver");
>> +     return ret;
>> +}
>> +
>> +static void __exit pps_irq_exit(void)
>> +{
>> +     platform_driver_unregister(&pps_irq_driver);
>> +     pr_debug(PPS_IRQ_NAME ": unregistered platform driver");
>> +}
>> +
>> +module_init(pps_irq_init);
>> +module_exit(pps_irq_exit);
>> +
>> +MODULE_AUTHOR("Ricardo Martins <rasm@fe.up.pt>");
>> +MODULE_AUTHOR("James Nuss <jamesnuss@nanometrics.ca>");
>> +MODULE_DESCRIPTION("Use raw IRQs as PPS source");
>> +MODULE_LICENSE("GPL");
>> +MODULE_VERSION(PPS_IRQ_VERSION);
>
>
> --
>  Alexander
>
