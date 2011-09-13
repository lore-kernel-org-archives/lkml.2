Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755467Ab1IMQZp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Sep 2011 12:25:45 -0400
Received: from smtp-out.google.com ([216.239.44.51]:22847 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755384Ab1IMQZn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Sep 2011 12:25:43 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:from:date:
	message-id:subject:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=N5AXFyqGK1hrBUap/MO2bpgfOW6TKAcEtuTVdGVBONXwcIGJ0/Rh5LB73h4k4Ds7d
	gaTW+UilktJNSPUEXcL7A==
MIME-Version: 1.0
In-Reply-To: <4DF11908.2030509@gmx.net>
References: <20110822005902.GA30602@gallifrey> <4DF117B8.8080408@gmx.net> <4DF11908.2030509@gmx.net>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Tue, 13 Sep 2011 10:25:20 -0600
Message-ID: <CAErSpo55KB7Gwc26=zm0kJozsjQcdtG+PQFYFd4v1V8mT7gEoA@mail.gmail.com>
Subject: Re: [PATCH] PNPACPI: Simplify disabled resource registration
To: Witold Szczeponik <Witold.Szczeponik@gmx.net>
Cc: "Dr. David Alan Gilbert" <linux@treblig.org>, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 9, 2011 at 1:03 PM, Witold Szczeponik
<Witold.Szczeponik@gmx.net> wrote:
> The attached patch simplifies 29df8d8f8702f0f53c1375015f09f04bc8d023c1.  As
> the "pnp_xxx" structs are not designed to cope with IORESOURCE_DISABLED, and
> hence no code can test for this value, setting this value is actually a "no op"
> and can be skipped altogether.  It is sufficient to remove the checks for
> "empty" resources and continue processing.
>
>
> Signed-off-by: Witold Szczeponik <Witold.Szczeponik@gmx.net>

Acked-by: Bjorn Helgaas <bhelgaas@google.com>

I think keeping all the resources is the right thing because we need
them for _SRS templates, as you mentioned.

Len normally takes PNP patches through his ACPI tree.

>
>
> diff -u linux/drivers/pnp/pnpacpi/rsparser.c linux/drivers/pnp/pnpacpi/rsparser.c
> --- linux/drivers/pnp/pnpacpi/rsparser.c
> +++ linux/drivers/pnp/pnpacpi/rsparser.c
> @@ -509,15 +509,12 @@
>                                            struct acpi_resource_dma *p)
>  {
>        int i;
> -       unsigned char map = 0, flags = 0;
> -
> -       if (p->channel_count == 0)
> -               flags |= IORESOURCE_DISABLED;
> +       unsigned char map = 0, flags;
>
>        for (i = 0; i < p->channel_count; i++)
>                map |= 1 << p->channels[i];
>
> -       flags |= dma_flags(dev, p->type, p->bus_master, p->transfer);
> +       flags = dma_flags(dev, p->type, p->bus_master, p->transfer);
>        pnp_register_dma_resource(dev, option_flags, map, flags);
>  }
>
> @@ -527,17 +524,14 @@
>  {
>        int i;
>        pnp_irq_mask_t map;
> -       unsigned char flags = 0;
> -
> -       if (p->interrupt_count == 0)
> -               flags |= IORESOURCE_DISABLED;
> +       unsigned char flags;
>
>        bitmap_zero(map.bits, PNP_IRQ_NR);
>        for (i = 0; i < p->interrupt_count; i++)
>                if (p->interrupts[i])
>                        __set_bit(p->interrupts[i], map.bits);
>
> -       flags |= irq_flags(p->triggering, p->polarity, p->sharable);
> +       flags = irq_flags(p->triggering, p->polarity, p->sharable);
>        pnp_register_irq_resource(dev, option_flags, &map, flags);
>  }
>
> @@ -547,10 +541,7 @@
>  {
>        int i;
>        pnp_irq_mask_t map;
> -       unsigned char flags = 0;
> -
> -       if (p->interrupt_count == 0)
> -               flags |= IORESOURCE_DISABLED;
> +       unsigned char flags;
>
>        bitmap_zero(map.bits, PNP_IRQ_NR);
>        for (i = 0; i < p->interrupt_count; i++) {
> @@ -564,7 +555,7 @@
>                }
>        }
>
> -       flags |= irq_flags(p->triggering, p->polarity, p->sharable);
> +       flags = irq_flags(p->triggering, p->polarity, p->sharable);
>        pnp_register_irq_resource(dev, option_flags, &map, flags);
>  }
>
> @@ -574,11 +565,8 @@
>  {
>        unsigned char flags = 0;
>
> -       if (io->address_length == 0)
> -               flags |= IORESOURCE_DISABLED;
> -
>        if (io->io_decode == ACPI_DECODE_16)
> -               flags |= IORESOURCE_IO_16BIT_ADDR;
> +               flags = IORESOURCE_IO_16BIT_ADDR;
>        pnp_register_port_resource(dev, option_flags, io->minimum, io->maximum,
>                                   io->alignment, io->address_length, flags);
>  }
> @@ -587,13 +575,8 @@
>                                        unsigned int option_flags,
>                                        struct acpi_resource_fixed_io *io)
>  {
> -       unsigned char flags = 0;
> -
> -       if (io->address_length == 0)
> -               flags |= IORESOURCE_DISABLED;
> -
>        pnp_register_port_resource(dev, option_flags, io->address, io->address,
> -                                  0, io->address_length, flags | IORESOURCE_IO_FIXED);
> +                                  0, io->address_length, IORESOURCE_IO_FIXED);
>  }
>
>  static __init void pnpacpi_parse_mem24_option(struct pnp_dev *dev,
> @@ -602,11 +585,8 @@
>  {
>        unsigned char flags = 0;
>
> -       if (p->address_length == 0)
> -               flags |= IORESOURCE_DISABLED;
> -
>        if (p->write_protect == ACPI_READ_WRITE_MEMORY)
> -               flags |= IORESOURCE_MEM_WRITEABLE;
> +               flags = IORESOURCE_MEM_WRITEABLE;
>        pnp_register_mem_resource(dev, option_flags, p->minimum, p->maximum,
>                                  p->alignment, p->address_length, flags);
>  }
> @@ -617,11 +597,8 @@
>  {
>        unsigned char flags = 0;
>
> -       if (p->address_length == 0)
> -               flags |= IORESOURCE_DISABLED;
> -
>        if (p->write_protect == ACPI_READ_WRITE_MEMORY)
> -               flags |= IORESOURCE_MEM_WRITEABLE;
> +               flags = IORESOURCE_MEM_WRITEABLE;
>        pnp_register_mem_resource(dev, option_flags, p->minimum, p->maximum,
>                                  p->alignment, p->address_length, flags);
>  }
> @@ -632,11 +609,8 @@
>  {
>        unsigned char flags = 0;
>
> -       if (p->address_length == 0)
> -               flags |= IORESOURCE_DISABLED;
> -
>        if (p->write_protect == ACPI_READ_WRITE_MEMORY)
> -               flags |= IORESOURCE_MEM_WRITEABLE;
> +               flags = IORESOURCE_MEM_WRITEABLE;
>        pnp_register_mem_resource(dev, option_flags, p->address, p->address,
>                                  0, p->address_length, flags);
>  }
> @@ -656,19 +630,16 @@
>                return;
>        }
>
> -       if (p->address_length == 0)
> -               flags |= IORESOURCE_DISABLED;
> -
>        if (p->resource_type == ACPI_MEMORY_RANGE) {
>                if (p->info.mem.write_protect == ACPI_READ_WRITE_MEMORY)
> -                       flags |= IORESOURCE_MEM_WRITEABLE;
> +                       flags = IORESOURCE_MEM_WRITEABLE;
>                pnp_register_mem_resource(dev, option_flags, p->minimum,
>                                          p->minimum, 0, p->address_length,
>                                          flags);
>        } else if (p->resource_type == ACPI_IO_RANGE)
>                pnp_register_port_resource(dev, option_flags, p->minimum,
>                                           p->minimum, 0, p->address_length,
> -                                          flags | IORESOURCE_IO_FIXED);
> +                                          IORESOURCE_IO_FIXED);
>  }
>
>  static __init void pnpacpi_parse_ext_address_option(struct pnp_dev *dev,
> @@ -678,19 +649,16 @@
>        struct acpi_resource_extended_address64 *p = &r->data.ext_address64;
>        unsigned char flags = 0;
>
> -       if (p->address_length == 0)
> -               flags |= IORESOURCE_DISABLED;
> -
>        if (p->resource_type == ACPI_MEMORY_RANGE) {
>                if (p->info.mem.write_protect == ACPI_READ_WRITE_MEMORY)
> -                       flags |= IORESOURCE_MEM_WRITEABLE;
> +                       flags = IORESOURCE_MEM_WRITEABLE;
>                pnp_register_mem_resource(dev, option_flags, p->minimum,
>                                          p->minimum, 0, p->address_length,
>                                          flags);
>        } else if (p->resource_type == ACPI_IO_RANGE)
>                pnp_register_port_resource(dev, option_flags, p->minimum,
>                                           p->minimum, 0, p->address_length,
> -                                          flags | IORESOURCE_IO_FIXED);
> +                                          IORESOURCE_IO_FIXED);
>  }
>
>  struct acpipnp_parse_option_s {
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
