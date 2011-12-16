Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759464Ab1LPNoH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 08:44:07 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:50281 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756441Ab1LPNoE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 08:44:04 -0500
MIME-Version: 1.0
In-Reply-To: <201112161419.32775.trenn@suse.de>
References: <1323972371-13189-1-git-send-email-seth.forshee@canonical.com>
	<201112160122.36100.trenn@suse.de>
	<20111216003333.GA18489@srcf.ucam.org>
	<201112161419.32775.trenn@suse.de>
Date: Fri, 16 Dec 2011 14:44:02 +0100
Message-ID: <CAHR064hY+UaOq8AjC3C1cHsBE1SinM1mfMfwbne_PhmvQ+G45Q@mail.gmail.com>
Subject: Re: [PATCH 1/4] ACPI: EC: Add ec_get_handle()
From: Corentin Chary <corentin.chary@gmail.com>
To: Thomas Renninger <trenn@suse.de>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>,
        Seth Forshee <seth.forshee@canonical.com>, Len Brown <lenb@kernel.org>,
        Azael Avalos <coproscefalo@gmail.com>,
        platform-driver-x86@vger.kernel.org, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 16, 2011 at 2:19 PM, Thomas Renninger <trenn@suse.de> wrote:
> On Friday, December 16, 2011 01:33:33 AM Matthew Garrett wrote:
>> On Fri, Dec 16, 2011 at 01:22:35AM +0100, Thomas Renninger wrote:
>>
>> > I think best is to move the thinkpad implementation of getting
>> > ACPI handles based on HIDs to osl.c and make it global.
>> > I'll send patches.
>> > Please review them carefully, they are only compile tested.
>>
>> The ec driver is already finding the hardware on the basis of the HID -
>> is there any reason to do this twice rather than just exporting the
>> information the ec driver already has?
>
> I don't object to export ec_handle, but thinkpad_acpi.c should get
> adjusted as well.
>
> I had a closer look and can come up with a replacement for acpi_get_devices
> using bus.c matching function bus_find_device() avoiding the namespace
> walk.
>
> What do you think about this one?
> I found these occurences of acpi_get_devices, which I would
> adjust in follow up patches if it's worth it:
> drivers/char/agp/hp-agp.c:      acpi_get_devices("HWP0003", zx1_gart_probe, "HWP0003", NULL);
> drivers/char/agp/hp-agp.c:      acpi_get_devices("HWP0007", zx1_gart_probe, "HWP0007", NULL);
> drivers/acpi/processor_core.c:  acpi_get_devices("ACPI0007", early_init_pdc, NULL, NULL);
> drivers/platform/x86/eeepc-wmi.c:       status = acpi_get_devices(EEEPC_ACPI_HID, eeepc_wmi_parse_device,

I like the idea, that would remove some code from eeepc-wmi (and others) :).

> drivers/platform/x86/thinkpad_acpi.c:   status = acpi_get_devices(hid, tpacpi_acpi_handle_locate_callback,
>
>
> Argh, these are called before ACPI objects are initialized
> (or parsed at all) and won't work:
> drivers/acpi/ec.c:      status = acpi_get_devices(ec_device_ids[0].id, ec_parse_device,
> arch/ia64/kernel/acpi.c:        acpi_get_devices(NULL, acpi_map_iosapic, NULL, NULL);
> drivers/pnp/pnpacpi/core.c:     acpi_get_devices(NULL, pnpacpi_add_device_handler, NULL, NULL);
> arch/x86/pci/mmconfig-shared.c: acpi_get_devices("PNP0C01", find_mboard_resource, &mcfg_res, NULL);
> arch/x86/pci/mmconfig-shared.c:         acpi_get_devices("PNP0C02", find_mboard_resource, &mcfg_res,
> arch/ia64/sn/kernel/io_acpi_init.c:     acpi_get_devices("SGIHUB", sn_acpi_hubdev_init, NULL, NULL);
> arch/ia64/sn/kernel/io_acpi_init.c:     acpi_get_devices("SGITIO", sn_acpi_hubdev_init, NULL, NULL);
>
> Looks like it's not worth it.
> I paste my patch anyway, if there is any use-case,
> it's already tested and works...:
>
> ---
> ACPI: Provide an acpi device search on acpi bus registered devices
>
> These should replace unnecessary acpi_get_devices invokations
> which ends in a namespace walk.
>
> Signed-off-by: Thomas Renninger <trenn@suse.de>
> CC: Matthew Garrett <mjg@redhat.com>
> CC: Len Brown <lenb@kernel.org>
> CC: linux-acpi@vger.kernel.org
> CC: seth.forshee@canonical.com
> CC: Azael Avalos <coproscefalo@gmail.com>
> CC: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
>
> ---
>  drivers/acpi/scan.c  |   66 ++++++++++++++++++++++++++++++++++++++++++++++++++
>  include/linux/acpi.h |    4 +++
>  2 files changed, 70 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/acpi/scan.c b/drivers/acpi/scan.c
> index 8ab80ba..efd97ea 100644
> --- a/drivers/acpi/scan.c
> +++ b/drivers/acpi/scan.c
> @@ -1606,3 +1606,69 @@ int __init acpi_scan_init(void)
>
>        return result;
>  }
> +
> +static int acpi_bus_find_cb(struct device *dev, void *data)
> +{
> +       struct acpi_device_id *ids = data;
> +
> +       if (acpi_match_device_ids(to_acpi_device(dev), ids) == 0)
> +               return 1;
> +       return 0;
> +}
> +
> +/**
> + * acpi_find_devices - find acpi devices of a given HID and execute callback
> + * @ids: The Hardware IDs for matching devices
> + * @match: A callback function which is executed for matching HIDs
> + *
> + * This is the counterpart of acpi_get_devices from ACPICA sources which
> + * should not get executed because it performs a namespace walk.
> + * This function instead iterates only over all ACPI devices found by initially
> + * parsing the ACPI namespace (and thus got added to the ACPI bus).
> + * One difference to acpi_get_devices is that it only finds active devices
> + * which were successfully added to the acpi bus and show up in
> + * /sys/devices/LNXSYSTM:00 and for which an ACPI driver's .add function would
> + * get called.
> + *
> + * ACPI devices with a matching HID or CID are recognized.
> + *
> + * If match returns zero, no further, possibly matching devices are processed.
> + */
> +int acpi_find_devices(struct acpi_device_id *ids, void *data,
> +                     int (*match) (struct acpi_device *dev, void *data))
> +{
> +       struct device *hit_dev = NULL;
> +
> +       while(1) {
> +               hit_dev = bus_find_device(&acpi_bus_type, hit_dev, ids,
> +                                         acpi_bus_find_cb);
> +               if (!hit_dev)
> +                       break;
> +               if (!match(to_acpi_device(hit_dev), data))
> +                       break;
> +       }
> +       return 0;
> +}
> +EXPORT_SYMBOL_GPL(acpi_find_devices);
> +
> +/**
> + * acpi_find_device - find an acpi device of a given HID
> + * @ids: The Hardware IDs for matching devices
> + *
> + * Same as acpi_find_devices, but the search will stop on the first found
> + * device and its structure is returned.
> + *
> + * Use this one if you are sure that only 1 ACPI device of a given HID can
> + * exist in ACPI namespace.
> + *
> + * Returns NULL if no device is found.
> + */
> +struct acpi_device *acpi_find_device(struct acpi_device_id *ids)
> +{
> +       struct device *dev = bus_find_device(&acpi_bus_type, NULL, ids,
> +                                            acpi_bus_find_cb);
> +       if (dev)
> +               return to_acpi_device(dev);
> +       return NULL;
> +}
> +EXPORT_SYMBOL_GPL(acpi_find_device);
> diff --git a/include/linux/acpi.h b/include/linux/acpi.h
> index 6001b4da..2f9e09e 100644
> --- a/include/linux/acpi.h
> +++ b/include/linux/acpi.h
> @@ -146,6 +146,10 @@ struct acpi_pci_driver {
>  int acpi_pci_register_driver(struct acpi_pci_driver *driver);
>  void acpi_pci_unregister_driver(struct acpi_pci_driver *driver);
>
> +extern int acpi_find_devices(struct acpi_device_id *ids, void *data,
> +                            int (*match) (struct acpi_device *dev, void *data));
> +extern struct acpi_device *acpi_find_device(struct acpi_device_id *ids);
> +
>  extern int ec_read(u8 addr, u8 *val);
>  extern int ec_write(u8 addr, u8 val);
>  extern int ec_transaction(u8 command,
> --
> To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Corentin Chary
http://xf.iksaif.net
