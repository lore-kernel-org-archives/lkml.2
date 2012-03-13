Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759406Ab2CMClR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 22:41:17 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:41355 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759369Ab2CMClP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 22:41:15 -0400
MIME-Version: 1.0
In-Reply-To: <1331362837-10740-3-git-send-email-yinghai@kernel.org>
References: <1331362837-10740-1-git-send-email-yinghai@kernel.org> <1331362837-10740-3-git-send-email-yinghai@kernel.org>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Mon, 12 Mar 2012 20:40:53 -0600
Message-ID: <CAErSpo5jCx5MdMOWgNQ+KVbn-6XDJSVvoO35J2DnpSMJyU-a4Q@mail.gmail.com>
Subject: Re: [PATCH v2 02/37] PNPACPI: Fix device ref leaking in acpi_pnp_match
To: Yinghai Lu <yinghai@kernel.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, x86 <x86@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@kernel.org, Len Brown <lenb@kernel.org>,
        Adam Belay <abelay@mit.edu>, linux-acpi@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 10, 2012 at 12:00 AM, Yinghai Lu <yinghai@kernel.org> wrote:
> During testing pci root bus removal, found some root bus bridge is not freed.
>
> If booting with pnpacpi=off, those hostbridge could be freed without problem.
>
> It turns out that some devices reference are not released during acpi_pnp_match.
>
> That match should not hold one device ref during every calling.
>
> Add put_device calling before returning.

Changelog doesn't fit in 80 columns when using "git log".  I mentioned
this before; please try it yourself.

> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> Cc: stable@kernel.org
> Cc: Len Brown <lenb@kernel.org>
> Cc: Adam Belay <abelay@mit.edu>
> Cc: Bjorn Helgaas <bhelgaas@google.com>
> Cc: linux-acpi@vger.kernel.org
> ---
>  drivers/pnp/pnpacpi/core.c |    7 ++++++-
>  1 files changed, 6 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/pnp/pnpacpi/core.c b/drivers/pnp/pnpacpi/core.c
> index b00c176..d21e8f5 100644
> --- a/drivers/pnp/pnpacpi/core.c
> +++ b/drivers/pnp/pnpacpi/core.c
> @@ -321,9 +321,14 @@ static int __init acpi_pnp_match(struct device *dev, void *_pnp)
>  {
>        struct acpi_device *acpi = to_acpi_device(dev);
>        struct pnp_dev *pnp = _pnp;
> +       struct device *physical_device;
> +
> +       physical_device = acpi_get_physical_device(acpi->handle);
> +       if (physical_device)
> +               put_device(physical_device);
>
>        /* true means it matched */
> -       return !acpi_get_physical_device(acpi->handle)
> +       return !physical_device
>            && compare_pnp_id(pnp->id, acpi_device_hid(acpi));
>  }
>
> --
> 1.7.7
>
