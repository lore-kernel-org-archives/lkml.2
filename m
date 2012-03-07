Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759356Ab2CGDxy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 22:53:54 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:57203 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756930Ab2CGDxw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 22:53:52 -0500
MIME-Version: 1.0
In-Reply-To: <1331018040-30725-9-git-send-email-yinghai@kernel.org>
References: <1331018040-30725-1-git-send-email-yinghai@kernel.org>
	<1331018040-30725-9-git-send-email-yinghai@kernel.org>
Date: Tue, 6 Mar 2012 20:53:50 -0700
Message-ID: <CABhMZUXsZD7YgViGxtvFyu8Pi2+QXfJ4rJwqZq9ybQt8UGTM9w@mail.gmail.com>
Subject: Re: [PATCH 08/23] PNPACPI: Fix device ref leaking in acpi_pnp_match
From: Bjorn Helgaas <bjorn.helgaas@gmail.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, x86 <x86@kernel.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@kernel.org, Len Brown <lenb@kernel.org>,
        Adam Belay <abelay@mit.edu>, Bjorn Helgaas <bhelgaas@google.com>,
        linux-acpi@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 6, 2012 at 12:13 AM, Yinghai Lu <yinghai@kernel.org> wrote:
> During testing pci root bus removal, found some root bus bridge is not freed.
>
> If booting with pnpacpi=off, those hostbridge could be freed without problem.
>
> It turns out that some devices reference are not released during acpi_pnp_match.
>
> that match should not hold one device ref during every calling.
>
> Add put_device calling before returning.
>
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

I spent about an hour convincing myself that this patch does the right
thing.  I *think* it does, but it certainly is not obvious.  It's
always nicer if the get/put are in the same function or in functions
that obviously correspond to each other.  But you didn't create this
mess, so I don't hold you responsible for fixing it :)

Bjorn
