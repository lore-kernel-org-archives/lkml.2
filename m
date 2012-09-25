Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754698Ab2IYTEs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 15:04:48 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:42618 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751593Ab2IYTEr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 15:04:47 -0400
MIME-Version: 1.0
In-Reply-To: <1348579544-1573-2-git-send-email-mjg@redhat.com>
References: <1348579544-1573-1-git-send-email-mjg@redhat.com> <1348579544-1573-2-git-send-email-mjg@redhat.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Tue, 25 Sep 2012 13:04:25 -0600
Message-ID: <CAErSpo7giiZEnXkRY+QnhAV_2EGwdnju7S1-futjnKBjr7sY-A@mail.gmail.com>
Subject: Re: [PATCH 2/2] PNP: Unbind drivers if the new driver matches _HID
 rather than _CID
To: Matthew Garrett <mjg@redhat.com>
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 25, 2012 at 7:25 AM, Matthew Garrett <mjg@redhat.com> wrote:
> ACPIPNP devices may have two levels of ID - the HID (a single string
> defining the hardware) and the CIDs (zero or more strings defining
> interfaces compatible with the hardware). If a driver matching a CID is
> bound first, it will be impossible to bind a driver that matches the HID
> despite it being more specific. This has been seen in the wild with
> platforms that define an IPMI device as:
>
>                 Device (NIPM)
>                 {
>                     Name (_HID, EisaId ("IPI0001"))
>                     Name (_CID, EisaId ("PNP0C01"))
>
> resulting in the device being claimed by the generic motherboard resource
> driver binding to the PNP0C01 CID. The IPMI driver attempts to bind later
> and fails, preventing the IPMI device from being made available to the ACPI
> layer.
>
> This can be avoided at driver probe time by detaching the existing driver
> if the new driver matches the device HID. Since each device can only have
> a single HID this will only permit more specific drivers to dislodge more
> generic drivers.
>
> Signed-off-by: Matthew Garrett <mjg@redhat.com>

Seems reasonable to me.  The HID/CID idea is not new to ACPI; both
isapnp and pnpbios seem to support it as well.

Do you know of any scenarios besides this IPMI one where there's the
possibility of two drivers matching the same device?  If so, does the
detach/attach process work reasonably?  My worry is that drivers don't
normally give up devices, so the detach path is not well exercised.
And I don't know what happens to any users of the device during the
switch.  For example, if something was using a TPM and we replaced the
driver, what does that look like to the user?

> ---
>  drivers/pnp/driver.c | 42 +++++++++++++++++++++++++++++++++++++++---
>  1 file changed, 39 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/pnp/driver.c b/drivers/pnp/driver.c
> index 00e9403..8d22836 100644
> --- a/drivers/pnp/driver.c
> +++ b/drivers/pnp/driver.c
> @@ -25,6 +25,14 @@ static int compare_func(const char *ida, const char *idb)
>         return 1;
>  }
>
> +static int compare_single_pnp_id(const char *ida, const char *idb)
> +{
> +       if (memcmp(ida, idb, 3) == 0)
> +               if (compare_func(ida, idb) == 1)
> +                       return 1;
> +       return 0;
> +}
> +
>  int compare_pnp_id(struct pnp_id *pos, const char *id)
>  {
>         if (!pos || !id || (strlen(id) != 7))
> @@ -32,9 +40,8 @@ int compare_pnp_id(struct pnp_id *pos, const char *id)
>         if (memcmp(id, "ANYDEVS", 7) == 0)
>                 return 1;
>         while (pos) {
> -               if (memcmp(pos->id, id, 3) == 0)
> -                       if (compare_func(pos->id, id) == 1)
> -                               return 1;
> +               if (compare_single_pnp_id(pos->id, id) == 1)
> +                       return 1;
>                 pos = pos->next;
>         }
>         return 0;
> @@ -56,6 +63,22 @@ static const struct pnp_device_id *match_device(struct pnp_driver *drv,
>         return NULL;
>  }
>
> +static int match_hid(struct pnp_driver *drv, struct pnp_dev *dev)
> +{
> +       const struct pnp_device_id *drv_id = drv->id_table;
> +
> +       if (!drv_id)
> +               return 0;
> +
> +       while (&drv_id->id) {
> +               /* The first ID is _HID */
> +               if (compare_single_pnp_id(dev->id->id, drv_id->id))
> +                       return 1;
> +               drv_id++;
> +       }
> +       return 0;
> +}
> +
>  int pnp_device_attach(struct pnp_dev *pnp_dev)
>  {
>         spin_lock(&pnp_lock);
> @@ -151,6 +174,19 @@ static int pnp_bus_match(struct device *dev, struct device_driver *drv)
>
>         if (match_device(pnp_drv, pnp_dev) == NULL)
>                 return 0;
> +
> +       /*
> +        * ACPIPNP offers two levels of device ID - HID and CID. HID defines
> +        * the specific device ID while CID represents the device
> +        * compatibility IDs. If a device is matched by a compatibility ID
> +        * first, it will be impossible for a hardware-specific driver to
> +        * bind since there will already be a driver. We can handle this case
> +        * by unbinding the original driver if the device has one bound and
> +        * if the new driver matches the HID rather than a compatibility ID.
> +        */
> +       if (dev->driver && match_hid(pnp_drv, pnp_dev))
> +               device_release_driver(dev);
> +
>         return 1;
>  }
>
> --
> 1.7.11.4
>
