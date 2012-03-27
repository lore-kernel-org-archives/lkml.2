Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755887Ab2C0UxS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 16:53:18 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:58871 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755249Ab2C0Uwv convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 16:52:51 -0400
MIME-Version: 1.0
In-Reply-To: <4F68E308.6090808@gmx.net>
References: <4F68D14B.60409@gmx.net> <4F68E308.6090808@gmx.net>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Tue, 27 Mar 2012 14:52:28 -0600
Message-ID: <CAErSpo4Vq44Kjvh+DLNJCXhfr=_xO9uVRjEW0GXvTYNrpmummg@mail.gmail.com>
Subject: Re: [PATCH 3/3] PNP: Allow resource flags to be set explicitly
To: Witold Szczeponik <Witold.Szczeponik@gmx.net>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 20, 2012 at 2:05 PM, Witold Szczeponik
<Witold.Szczeponik@gmx.net> wrote:
> The patch introduces a new means to display and to read a PNP resource's
> flags.
>
> In the current implementation, this is done by explicitly checking for a flag
> and then displaying the corresponding value.  At the same time, there is no
> support to read these flags when setting PNP resources using the
> "/sys/bus/pnp/*/*/resources" interfaces.
>
> In order to uniformly display and read the flags, a table of all flags and the
> corresponding clear text is introduced.  This table contains all the
> information that is needed to display and to set the flags.
>
> If a resource contains flags that are not handled by this table, they are
> displayed explicitly and also can be read explicitly (c.f. example below).
>
> To better understand the implications of this patch, the following output from
> a devices resource table illustrates the patch.  If a device contains the
> resources,
>
>        io disabled
>        io 0xd00-0xffff window
>
> then the patch ensures that all values are displayed and read uniformly.  If
> new flags need to be interpreted, then only extending the flag table is
> required.  However, even without such extensions, the routines would work
> properly, because then the "missing" flags would be displayed explicitly, e.g.,
>
>        io disabled
>        io 0xd00-0xffff flags 0x05001

I don't quite understand the illustration.  Maybe it would help if you
showed before & after output.

> The patch is applied against Linux 3.3.x.
>
>
> Signed-off-by: Witold Szczeponik <Witold.Szczeponik@gmx.net>
>
>
> Index: linux/drivers/pnp/interface.c
> ===================================================================
> --- linux.orig/drivers/pnp/interface.c
> +++ linux/drivers/pnp/interface.c
> @@ -242,6 +242,29 @@ static ssize_t pnp_show_options(struct d
>        return ret;
>  }
>
> +#define PNP_RES_VAL(typ, flg, val)     \
> +       { \
> +               .type = (typ), \
> +               .mask = IORESOURCE_ ## flg, \
> +               .flags = IORESOURCE_ ## flg, \
> +               .value = (val) \
> +       }
> +static struct pnp_resource_value {
> +       unsigned long type;
> +       unsigned long mask;
> +       unsigned long flags;
> +       const char *value;
> +} pnp_resource_values[] = {
> +       PNP_RES_VAL(IORESOURCE_MEM, PREFETCH, "pref"),
> +       PNP_RES_VAL(IORESOURCE_IO | IORESOURCE_MEM, MEM_64, "64bit"),
> +       PNP_RES_VAL(IORESOURCE_IO | IORESOURCE_MEM, WINDOW, "window"),
> +       PNP_RES_VAL(IORESOURCE_TYPE_BITS, DISABLED, "disabled"),
> +       PNP_RES_VAL(IORESOURCE_TYPE_BITS, DISABLED, "<none>"),

I'm not clear on the usefulness of having both "disabled" and "<none>"
here (same question as on patch [1/3]).  From reading the code, it
looks like we would always print them together, e.g., "disabled
<none>"?

> +       PNP_RES_VAL(IORESOURCE_TYPE_BITS, AUTO, "auto"),
> +       { .type = 0 }
> +};
> +#undef PNP_RES_VAL
> +
>  static ssize_t pnp_show_current_resources(struct device *dmdev,
>                                          struct device_attribute *attr,
>                                          char *buf)
> @@ -249,7 +272,6 @@ static ssize_t pnp_show_current_resource
>        struct pnp_dev *dev = to_pnp_dev(dmdev);
>        pnp_info_buffer_t *buffer;
>        struct pnp_resource *pnp_res;
> -       struct resource *res;
>        int ret;
>
>        if (!dev)
> @@ -266,31 +288,53 @@ static ssize_t pnp_show_current_resource
>        pnp_printf(buffer, "state = %s\n", dev->active ? "active" : "disabled");
>
>        list_for_each_entry(pnp_res, &dev->resources, list) {
> -               res = &pnp_res->res;
> +               struct resource *res = &pnp_res->res;
> +               unsigned long mask = res->flags;
> +               struct pnp_resource_value *val;
>
>                pnp_printf(buffer, pnp_resource_type_name(res));
>
> -               if (res->flags & IORESOURCE_DISABLED) {
> -                       pnp_printf(buffer, " disabled\n");
> -                       continue;
> +               if (mask & IORESOURCE_DISABLED) {
> +                       pnp_printf(buffer, " disabled");
> +                       mask &= ~IORESOURCE_DISABLED;
> +               } else {
> +                       switch (pnp_resource_type(res)) {
> +                       case IORESOURCE_IO:
> +                       case IORESOURCE_MEM:
> +                       case IORESOURCE_BUS:
> +                               pnp_printf(buffer, " %#llx-%#llx",
> +                                          (unsigned long long) res->start,
> +                                          (unsigned long long) res->end);
> +                               break;
> +                       case IORESOURCE_IRQ:
> +                       case IORESOURCE_DMA:
> +                               pnp_printf(buffer, " %lld",
> +                                          (unsigned long long) res->start);
> +                               break;
> +                       }
>                }
>
> -               switch (pnp_resource_type(res)) {
> -               case IORESOURCE_IO:
> -               case IORESOURCE_MEM:
> -               case IORESOURCE_BUS:
> -                       pnp_printf(buffer, " %#llx-%#llx%s\n",
> -                                  (unsigned long long) res->start,
> -                                  (unsigned long long) res->end,
> -                                  res->flags & IORESOURCE_WINDOW ?
> -                                       " window" : "");
> -                       break;
> -               case IORESOURCE_IRQ:
> -               case IORESOURCE_DMA:
> -                       pnp_printf(buffer, " %lld\n",
> -                                  (unsigned long long) res->start);
> -                       break;
> +               /* ignore the "automatically assigned" flag */
> +               mask &= ~IORESOURCE_AUTO;
> +               /* ignore all bus-specific flags */
> +               mask &= ~IORESOURCE_BITS;
> +
> +               for (val = pnp_resource_values; val->type; val++) {
> +                       if ((pnp_resource_type(res) & val->type)
> +                           && (mask & val->mask)
> +                           && (mask & val->mask == val->flags)) {
> +                               if (val->value && val->value[0])
> +                                       pnp_printf(buffer, " %s", val->value);
> +                               mask &= ~val->mask;
> +                       }
>                }
> +
> +               /* fallback when there are still some unhandled flags */
> +               if (mask)
> +                       pnp_printf(buffer, " flags %#llx",
> +                                  (unsigned long long) res->flags);
> +
> +               pnp_printf(buffer, "\n");
>        }
>
>        ret = (buffer->curr - buf);
> @@ -330,7 +374,32 @@ static char *pnp_get_resource_value(char
>                }
>        }
>
> -       /* TBD: allow for additional flags, e.g., IORESOURCE_WINDOW */
> +       /* allow for additional flags, e.g., "window" (IORESOURCE_WINDOW) */
> +       buf = skip_spaces(buf);

You could just do this here and unindent the rest of the function:

        if (!flags)
                return buf;

> +       if (flags) {
> +               struct pnp_resource_value *val = pnp_resource_values;
> +
> +               while (val->type) {
> +                       size_t len = 0;
> +
> +                       if ((val->type & type) && val->value)
> +                               len = strlen(val->value);
> +
> +                       if (len && !strnicmp(buf, val->value, len)) {
> +                               *flags = (*flags & ~val->mask) | val->flags;
> +
> +                               buf = skip_spaces(buf + len);
> +                               val = pnp_resource_values; /* restart loop */
> +                       } else
> +                               val += 1; /* check next value */
> +               }
> +       }
> +
> +       /* fallback: allow for direct flag setting */
> +       if (flags && !strnicmp(buf, "flags", 5)) {
> +               buf += 5;
> +               *flags = simple_strtoul(buf, &buf, 0);

Is there a minor asymmetry here?  When printing, I think you could
print "pref flags 0x..." (so you have both decoded bits and undecoded
bits), but if you pasted that same "pref flags 0x..." text into a
"set," you would lose the PREFETCH bit because you overwrite *flags
instead of ORing in the extra bits.

> +       }
>
>        return buf;
>  }
