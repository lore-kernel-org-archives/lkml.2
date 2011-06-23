Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933210Ab1FWXMS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 19:12:18 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:43441 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933959Ab1FWXMP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 19:12:15 -0400
MIME-Version: 1.0
In-Reply-To: <20110623183821.GA19188@S2100-06.ap.freescale.net>
References: <1308410354-21387-1-git-send-email-shawn.guo@linaro.org>
 <1308410354-21387-2-git-send-email-shawn.guo@linaro.org> <20110618161934.GH8195@ponder.secretlab.ca>
 <20110619073000.GA23171@S2100-06.ap.freescale.net> <20110621135558.GB9228@S2101-09.ap.freescale.net>
 <BANLkTim4vunTm1176MRw3pqRZnunu4=9jg@mail.gmail.com> <20110623183821.GA19188@S2100-06.ap.freescale.net>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Thu, 23 Jun 2011 17:11:54 -0600
X-Google-Sender-Auth: 61AoyMfAbkBNXrr03Bw1majIaEM
Message-ID: <BANLkTi=8Mks6T85WnEyihmB21U1j7reHrQ@mail.gmail.com>
Subject: Re: [PATCH 1/3] serial/imx: add device tree support
To: Shawn Guo <shawn.guo@freescale.com>
Cc: patches@linaro.org, netdev@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, Jason Liu <jason.hui@linaro.org>,
        linux-kernel@vger.kernel.org, Jeremy Kerr <jeremy.kerr@canonical.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        linux-arm-kernel@lists.infradead.org,
        David Gibson <david@gibson.dropbear.id.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 23, 2011 at 12:38 PM, Shawn Guo <shawn.guo@freescale.com> wrote:
> On Tue, Jun 21, 2011 at 01:13:50PM -0600, Grant Likely wrote:
> [...]
>> >
>> >  /**
>> > + *     of_get_device_index - Get device index by looking up "aliases" node
>> > + *     @np:    Pointer to device node that asks for device index
>> > + *     @name:  The device alias without index number
>> > + *
>> > + *     Returns the device index if find it, else returns -ENODEV.
>> > + */
>> > +int of_get_device_index(struct device_node *np, const char *alias)
>> > +{
>> > +       struct device_node *aliases = of_find_node_by_name(NULL, "aliases");
>> > +       struct property *prop;
>> > +       char name[32];
>> > +       int index = 0;
>> > +
>> > +       if (!aliases)
>> > +               return -ENODEV;
>> > +
>> > +       while (1) {
>> > +               snprintf(name, sizeof(name), "%s%d", alias, index);
>> > +               prop = of_find_property(aliases, name, NULL);
>> > +               if (!prop)
>> > +                       return -ENODEV;
>> > +               if (np == of_find_node_by_path(prop->value))
>> > +                       break;
>> > +               index++;
>> > +       }
>>
>> Rather than parsing the alias strings everytime, it would probably be
>> better to preprocess all the properties in the aliases node and create
>> a lookup table of alias->node references that can be walked quickly
>> and trivially.
>>
>> Also, when obtaining an enumeration for a device, you'll need to be
>> careful about what number gets returned.  If the node doesn't match a
>> given alias, but aliases do exist for other devices of like type, then
>> you need to be careful not to assign a number already assigned to
>> another device via an alias (this of course assumes the driver
>> supports dynamics enumeration, which many drivers will).  It would be
>>
>
> Grant, please take a look at the second shot below.  Please let me
> know what you think.

Hey Shawn, good progress.  Comments below.

Also, once you've got this sorted out, you'll need to break the
drivers/of/ bits out into a separate patch so I can apply it
separately.

g.

>
> diff --git a/arch/arm/boot/dts/imx51-babbage.dts b/arch/arm/boot/dts/imx51-babbage.dts
> index 7976932..f4a5c3c 100644
> --- a/arch/arm/boot/dts/imx51-babbage.dts
> +++ b/arch/arm/boot/dts/imx51-babbage.dts
> @@ -18,6 +18,12 @@
>        compatible = "fsl,imx51-babbage", "fsl,imx51";
>        interrupt-parent = <&tzic>;
>
> +       aliases {
> +               serial0 = &uart0;
> +               serial1 = &uart1;
> +               serial2 = &uart2;
> +       };
> +
>        chosen {
>                bootargs = "console=ttymxc0,115200 root=/dev/mmcblk0p3 rootwait";
>        };
> @@ -47,29 +53,29 @@
>                        reg = <0x70000000 0x40000>;
>                        ranges;
>
> -                       uart@7000c000 {
> -                               compatible = "fsl,imx51-uart", "fsl,imx-uart";
> +                       uart2: uart@7000c000 {
> +                               compatible = "fsl,imx51-uart", "fsl,imx21-uart";
>                                reg = <0x7000c000 0x4000>;
>                                interrupts = <33>;
>                                id = <3>;
>                                fsl,has-rts-cts;
>                        };
>                };
>
> -               uart@73fbc000 {
> -                       compatible = "fsl,imx51-uart", "fsl,imx-uart";
> +               uart0: uart@73fbc000 {
> +                       compatible = "fsl,imx51-uart", "fsl,imx21-uart";
>                        reg = <0x73fbc000 0x4000>;
>                        interrupts = <31>;
>                        id = <1>;
>                        fsl,has-rts-cts;
>                };
>
> -               uart@73fc0000 {
> -                       compatible = "fsl,imx51-uart", "fsl,imx-uart";
> +               uart1: uart@73fc0000 {
> +                       compatible = "fsl,imx51-uart", "fsl,imx21-uart";
>                        reg = <0x73fc0000 0x4000>;
>                        interrupts = <32>;
>                        id = <2>;
>                        fsl,has-rts-cts;
>                };
>        };
>
> diff --git a/arch/arm/mach-mx5/imx51-dt.c b/arch/arm/mach-mx5/imx51-dt.c
> index 8bfdb91..e6c7298 100644
> --- a/arch/arm/mach-mx5/imx51-dt.c
> +++ b/arch/arm/mach-mx5/imx51-dt.c
> @@ -40,6 +40,8 @@ static const struct of_device_id tzic_of_match[] __initconst = {
>
>  static void __init imx51_dt_init(void)
>  {
> +       of_scan_aliases();
> +

Instead of calling this from board code.  You can add the call
directly to the bottom of unflatten_device_tree() in drivers/of/fdt.c

>        irq_domain_generate_simple(tzic_of_match, MX51_TZIC_BASE_ADDR, 0);
>
>        of_platform_populate(NULL, of_default_bus_match_table,
> diff --git a/drivers/of/base.c b/drivers/of/base.c
> index 632ebae..90349a2 100644
> --- a/drivers/of/base.c
> +++ b/drivers/of/base.c
> @@ -17,12 +17,27 @@
>  *      as published by the Free Software Foundation; either version
>  *      2 of the License, or (at your option) any later version.
>  */
> +#include <linux/ctype.h>
>  #include <linux/module.h>
>  #include <linux/of.h>
>  #include <linux/spinlock.h>
>  #include <linux/slab.h>
>  #include <linux/proc_fs.h>
>
> +struct alias_devname {
> +       char devname[32];
> +       struct list_head link;
> +       struct list_head head;
> +};
> +
> +struct alias_devid {
> +       int devid;
> +       struct device_node *node;
> +       struct list_head link;
> +};

Some LinuxDoc documentation on the meaning of these structures would
be helpful.  I'm not convinced that a two level lookup table is really
necessary.  A flat table containing alias, device_node pointer, and
possibly decoded devname and id is probably sufficient to get started.
 Also, I think it will still be useful to store a pointer to the
actual alias name in the alias_devid record.

> +
> +static LIST_HEAD(aliases_lookup);
> +
>  struct device_node *allnodes;
>  struct device_node *of_chosen;
>
> @@ -922,3 +937,170 @@ out_unlock:
>  }
>  #endif /* defined(CONFIG_OF_DYNAMIC) */
>
> +/*
> + * get_alias_dev_name_id - Get device name and id from alias name
> + *
> + * an: The alias name passed in
> + * dn: The pointer used to return device name

There is actually little point in decoding an alias to the device
name.  It is more useful to decode alias to the device_node pointer
which can be found with of_find_node_by_path().  I'd like to have a
lookup table generated which contains {const char *alias_name,
device_node *np} pairs.  It would also be useful for that table to
decode the 'id' from the end of the alias name when available.  Then,
given an alias stem and id (like imxuart and 2) the code could match
it to alias imxuart0 and look up the device_node associated with (I
could see this used by console setup code).  Alternately, driver probe
code could use its device_node pointer to lookup its alias, and if no
alias exists, then use the table to find an unused id (and possibly
even add an entry to the table when it allocates an id).

> + *
> + * Returns device id which should be the number at the end of alias
> + * name, otherwise returns -1.
> + */
> +static int get_alias_name_id(char *an, char *dn)

Even private static functions should have a prefix consistent with the
file.  In this case, all the functions should probably be something in
the form "of_alias_*()"

> +{
> +       int len = strlen(an);
> +       char *end = an + len;
> +
> +       while (isdigit(*--end))
> +               len--;

Clever!  :-)

> +
> +       end++;
> +       strncpy(dn, an, len);
> +       dn[len] = '\0';
> +
> +       return strlen(end) ? simple_strtol(end, NULL, 10) : -1;

Just to be pendantic: simple_strtoul()  :-)

> +}
> +
> +/*
> + * get_an_available_devid - Get an available devid for the given devname
> + *
> + * adn:        The pointer to the given alias_devname
> + *
> + * Returns the available devid
> + */
> +static int get_an_available_devid(struct alias_devname *adn)
> +{
> +       int devid = 0;
> +       struct alias_devid *adi;
> +
> +       while (1) {
> +               bool used = false;
> +               list_for_each_entry(adi, &adn->head, link) {
> +                       if (adi->devid == devid) {
> +                               used = true;
> +                               break;
> +                       }
> +               }
> +
> +               if (!used)
> +                       break;
> +
> +               devid++;
> +       }
> +
> +       return devid;
> +}
> +
> +/*
> + * of_scan_aliases - Scan all properties of aliases node and populate the
> + *                  global lookup table with the device name and id info
> + *
> + * Returns the number of aliases properties found, or error code in error case.
> + */

Use LinuxDoc format for documentation blocks.
Documentation/kernel-doc-nano-HOWTO.txt

> +int of_scan_aliases(void)
> +{
> +       struct device_node *aliases = of_find_node_by_name(NULL, "aliases");

Like the chosen node, it is useful to keep around a reference to the
aliases node.  There is other code that will use it that I hope to
merge soon.  You can add a global of_aliases pointer and initialized
it in unflatten_device_tree()

> +       struct property *pp;
> +       struct alias_devname *adn;
> +       struct alias_devid *adi;
> +       int ret = 0;
> +
> +       if (!aliases) {
> +               ret = -ENODEV;
> +               goto out;

The function hasn't done anything that needs unwinding yet. Just
return immediately.

> +       }
> +
> +       for (pp = aliases->properties; pp != NULL; pp = pp->next) {

A "for_each_property()" macro would be useful to have and use here.
Can you add one to include/linux/of.h?

> +               bool found = false;
> +               char devname[32];

Rather than a static sized string, I'd like this to be the actual size
of the string.  You can do this by making the name the last element of
the list and giving it a [0] length.  Then when memory is kzalloced
for it, the size of the devname can be added to the end:

struct alias_devname {
       struct list_head link;
       const char *alias;
       struct device_node *node;
       int alias_id;
       char alias_stem[0];
};

> +               int devid = get_alias_name_id(pp->name, devname);
> +
> +               /* We do not want to proceed this sentinel one */
> +               if (!strcmp(pp->name, "name") && !strcmp(pp->value, "aliases"))
> +                       break;

Skipping the 'name' property is good, but I don't think you need to
check the value.  You should also skip the "phandle" property.

> +
> +               /* See if the devname already exists */
> +               list_for_each_entry(adn, &aliases_lookup, link) {
> +                       if (!strcmp(adn->devname, devname)) {
> +                               found = true;
> +                               break;
> +                       }
> +               }
> +
> +               /*
> +                * Create the entry for this devname if not found,
> +                * and add it into aliases_lookup
> +                */
> +               if (!found) {
> +                       adn = kzalloc(sizeof(*adn), GFP_KERNEL);
> +                       if (!adn) {
> +                               ret = -ENOMEM;
> +                               goto out;
> +                       }
> +
> +                       strcpy(adn->devname, devname);
> +                       INIT_LIST_HEAD(&adn->head);
> +                       list_add_tail(&adn->link, &aliases_lookup);
> +               }
> +
> +               /*
> +                * Save the devid as one entry of the list for this
> +                * specified devname
> +                */
> +               adi = kzalloc(sizeof(*adi), GFP_KERNEL);
> +               if (!adi) {
> +                       ret = -ENOMEM;
> +                       goto out;
> +               }
> +
> +               adi->devid = (devid == -1) ? get_an_available_devid(adn) :
> +                                            devid;
> +               adi->node = of_find_node_by_path(pp->value);
> +
> +               list_add_tail(&adi->link, &adn->head);
> +               ret++;

Going to a single level lookup table will certainly simplify this function.

> +       }
> +
> +out:
> +       return ret;
> +}
> +
> +/**
> + *     of_get_device_id - Get device id by looking up "aliases" node
> + *     @np:    Pointer to device node that asks for device id
> + *     @name:  The device alias name
> + *
> + *     Returns the device id if find it, else returns -ENODEV.
> + */
> +int of_get_device_id(struct device_node *np, const char *name)
> +{
> +       struct alias_devname *adn;
> +       struct alias_devid *adi;
> +       bool found = false;
> +       int ret;
> +
> +       list_for_each_entry(adn, &aliases_lookup, link) {
> +               if (!strcmp(adn->devname, name)) {
> +                       found = true;
> +                       break;
> +               }
> +       }
> +
> +       if (!found) {
> +               ret = -ENODEV;
> +               goto out;
> +       }
> +
> +       found = false;
> +       list_for_each_entry(adi, &adn->head, link) {
> +               if (np == adi->node) {
> +                       found = true;
> +                       break;
> +               }
> +       }
> +
> +       ret = found ? adi->devid : -ENODEV;
> +out:
> +       return ret;
> +}
> +EXPORT_SYMBOL(of_get_device_id);
> diff --git a/drivers/tty/serial/imx.c b/drivers/tty/serial/imx.c
> index 2769353..062639e 100644
> --- a/drivers/tty/serial/imx.c
> +++ b/drivers/tty/serial/imx.c
> @@ -1225,43 +1265,33 @@ static int serial_imx_resume(struct platform_device *dev)
>        return 0;
>  }
>
>  static int serial_imx_probe_dt(struct imx_port *sport,
>                struct platform_device *pdev)
>  {
>        struct device_node *node = pdev->dev.of_node;
> -       const __be32 *line;
> +       int line;
>
>        if (!node)
>                return -ENODEV;
>
> -       line = of_get_property(node, "id", NULL);
> -       if (!line)
> +       line = of_get_device_id(node, "serial");
> +       if (IS_ERR_VALUE(line))

if (line < 0) is a sufficient test.  I don't much like the IS_ERR_VALUE() macro.

>                return -ENODEV;
>
> -       sport->port.line = be32_to_cpup(line) - 1;
> +       sport->port.line = line;
>
> diff --git a/include/linux/of.h b/include/linux/of.h
> index bfc0ed1..270c671 100644
> --- a/include/linux/of.h
> +++ b/include/linux/of.h
> @@ -213,6 +213,9 @@ extern int of_parse_phandles_with_args(struct device_node *np,
>        const char *list_name, const char *cells_name, int index,
>        struct device_node **out_node, const void **out_args);
>
> +extern int of_scan_aliases(void);
> +extern int of_get_device_id(struct device_node *np, const char *name);
> +
>  extern int of_machine_is_compatible(const char *compat);
>
>  extern int prom_add_property(struct device_node* np, struct property* prop);
>
> --
> Regards,
> Shawn
>
>



-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
