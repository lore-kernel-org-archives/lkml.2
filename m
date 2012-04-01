Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753096Ab2DAQGN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2012 12:06:13 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:48598 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753054Ab2DAQGJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2012 12:06:09 -0400
X-Authenticated: #787645
X-Provags-ID: V01U2FsdGVkX18tFlNuu8otUpliM04P9mZGaT8xi85s1/vwLAk0v7
	BFQbpTA0QEoKGR
Message-ID: <4F787CE0.2050406@gmx.net>
Date: Sun, 01 Apr 2012 18:05:52 +0200
From: Witold Szczeponik <Witold.Szczeponik@gmx.net>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:11.0) Gecko/20120310 Thunderbird/11.0
MIME-Version: 1.0
To: Bjorn Helgaas <bhelgaas@google.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] PNP: Simplify setting of resources
References: <4F68D14B.60409@gmx.net> <4F68E12C.8090807@gmx.net> <CAErSpo6VxdvpmSA_RbPLcqduwqXbJg_VCqSdW7_+_UGLeWWT+w@mail.gmail.com>
In-Reply-To: <CAErSpo6VxdvpmSA_RbPLcqduwqXbJg_VCqSdW7_+_UGLeWWT+w@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27/03/12 22:32, Bjorn Helgaas wrote:

[...]

>
> A few minor comments below, but I think this looks good.  In the past,
> I've sent PNP patches through linux-acpi and Len's ACPI tree.
>
> Reviewed-by: Bjorn Helgaas<bhelgaas@google.com>
>

I will send an updated version of the patch series also to Len and 
linux-acpi.  Thanks for pointing this out to me!

>> Signed-off-by: Witold Szczeponik<Witold.Szczeponik@gmx.net>
>>
>>
>> Index: linux/drivers/pnp/interface.c
>> ===================================================================
>> --- linux.orig/drivers/pnp/interface.c
>> +++ linux/drivers/pnp/interface.c
>> @@ -298,6 +298,39 @@ static ssize_t pnp_show_current_resource
>>         return ret;
>>   }
>>
>> +static char *pnp_get_resource_value(char *buf,
>> +                                   unsigned long type,
>> +                                   resource_size_t *start,
>> +                                   resource_size_t *end,
>> +                                   unsigned long *flags)
>> +{
>> +       if (start)
>> +               *start = 0;
>> +       if (end)
>> +               *end = 0;
>> +       if (flags)
>> +               *flags = 0;
>> +
>> +       /* TBD: allow for disabled resources */
>> +
>> +       buf = skip_spaces(buf);
>> +       if (start) {
>> +               *start = simple_strtoull(buf,&buf, 0);
>> +               if (end) {
>> +                       buf = skip_spaces(buf);
>> +                       if (*buf == '-') {
>> +                               buf = skip_spaces(buf + 1);
>> +                               *end = simple_strtoull(buf,&buf, 0);
>> +                       } else
>> +                               *end = *start;
>> +               }
>> +       }
>> +
>> +       /* TBD: allow for additional flags, e.g., IORESOURCE_WINDOW */
>> +
>> +       return buf;
>> +}
>> +
>>   static ssize_t pnp_set_current_resources(struct device *dmdev,
>>                                          struct device_attribute *attr,
>>                                          const char *ubuf, size_t count)
>> @@ -305,7 +338,6 @@ static ssize_t pnp_set_current_resources
>>         struct pnp_dev *dev = to_pnp_dev(dmdev);
>>         char *buf = (void *)ubuf;
>>         int retval = 0;
>> -       resource_size_t start, end;
>>
>>         if (dev->status&  PNP_ATTACHED) {
>>                 retval = -EBUSY;
>> @@ -349,6 +381,10 @@ static ssize_t pnp_set_current_resources
>>                 goto done;
>>         }
>>         if (!strnicmp(buf, "set", 3)) {
>> +               resource_size_t start;
>> +               resource_size_t end;
>> +               unsigned long flags;
>> +
>>                 if (dev->active)
>>                         goto done;
>>                 buf += 3;
>> @@ -357,42 +393,42 @@ static ssize_t pnp_set_current_resources
>>                 while (1) {
>>                         buf = skip_spaces(buf);
>>                         if (!strnicmp(buf, "io", 2)) {
>> -                               buf = skip_spaces(buf + 2);
>> -                               start = simple_strtoul(buf,&buf, 0);
>> -                               buf = skip_spaces(buf);
>> -                               if (*buf == '-') {
>> -                                       buf = skip_spaces(buf + 1);
>> -                                       end = simple_strtoul(buf,&buf, 0);
>> -                               } else
>> -                                       end = start;
>> -                               pnp_add_io_resource(dev, start, end, 0);
>> -                               continue;
>> -                       }
>> -                       if (!strnicmp(buf, "mem", 3)) {
>> -                               buf = skip_spaces(buf + 3);
>> -                               start = simple_strtoul(buf,&buf, 0);
>> -                               buf = skip_spaces(buf);
>> -                               if (*buf == '-') {
>> -                                       buf = skip_spaces(buf + 1);
>> -                                       end = simple_strtoul(buf,&buf, 0);
>> -                               } else
>> -                                       end = start;
>> -                               pnp_add_mem_resource(dev, start, end, 0);
>> -                               continue;
>> -                       }
>> -                       if (!strnicmp(buf, "irq", 3)) {
>> -                               buf = skip_spaces(buf + 3);
>> -                               start = simple_strtoul(buf,&buf, 0);
>> -                               pnp_add_irq_resource(dev, start, 0);
>> -                               continue;
>> -                       }
>> -                       if (!strnicmp(buf, "dma", 3)) {
>> -                               buf = skip_spaces(buf + 3);
>> -                               start = simple_strtoul(buf,&buf, 0);
>> -                               pnp_add_dma_resource(dev, start, 0);
>> -                               continue;
>> -                       }
>> -                       break;
>> +                               buf = pnp_get_resource_value(buf + 2,
>> +                                                            IORESOURCE_IO,
>> +&start,
>> +&end,
>> +&flags);
>
> Looks like at least "&end" will fit on the same line as "&start".

Indeed, they do: will change this.

>
>> +                               pnp_add_io_resource(dev, start, end, flags);
>> +                       } else if (!strnicmp(buf, "mem", 3)) {
>> +                               buf = pnp_get_resource_value(buf + 3,
>> +                                                            IORESOURCE_MEM,
>> +&start,
>> +&end,
>> +&flags);
>> +                               pnp_add_mem_resource(dev, start, end, flags);
>> +                       } else if (!strnicmp(buf, "irq", 3)) {
>> +                               buf = pnp_get_resource_value(buf + 3,
>> +                                                            IORESOURCE_IRQ,
>> +&start,
>> +                                                            NULL,
>> +&flags);
>> +                               pnp_add_irq_resource(dev, start, flags);
>> +                       } else if (!strnicmp(buf, "dma", 3)) {
>> +                               buf = pnp_get_resource_value(buf + 3,
>> +                                                            IORESOURCE_DMA,
>> +&start,
>> +                                                            NULL,
>> +&flags);
>> +                               pnp_add_dma_resource(dev, start, flags);
>> +                       } else if (!strnicmp(buf, "bus", 3)) {
>> +                               buf = pnp_get_resource_value(buf + 3,
>> +                                                            IORESOURCE_BUS,
>> +&start,
>> +&end,
>> +                                                            NULL);
>> +                               pnp_add_bus_resource(dev, start, end);
>
> It makes sense to allow a user to set bus number resources just like
> any other resources, but I don't think the rest of PNP supports this
> yet.  I think only PNPACPI supports bus number resources at all, so
> when you "activate" the device after setting its resources, we'll call
> pnpacpi_set_resources() and pnpacpi_encode_resources(), but
> pnpacpi_encode_resources() doesn't know how to encode the address16
> descriptor that will probably be used for bus numbers.
>
> I guess that's all right, though.  We already have the same situation
> for all the address space descriptors when used for IO or MEM.
>
>> +                       } else
>> +                               break;
>>                 }
>>                 mutex_unlock(&pnp_res_mutex);
>>                 goto done;
