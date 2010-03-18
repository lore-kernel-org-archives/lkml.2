Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752164Ab0CRTZW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 15:25:22 -0400
Received: from smtp-out.google.com ([74.125.121.35]:23127 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751181Ab0CRTZS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 15:25:18 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=oRMVNQHqcEy/b4veUnm3BwiwpksepN4NJM4+KZtKHaldkAFQVWZl+jXYDGMkTSFli
	6RFlWDPYbugI5rFvUpgGw==
MIME-Version: 1.0
In-Reply-To: <20100318175935.15143.96345.stgit@bob.kio>
References: <20100318175852.15143.2124.stgit@bob.kio>
	 <20100318175935.15143.96345.stgit@bob.kio>
Date: Thu, 18 Mar 2010 12:25:12 -0700
Message-ID: <3055132f1003181225g72009919he645c3cce9986c58@mail.gmail.com>
Subject: Re: [PATCH v2 2/4] hpet: pass physical address, not entire hpet_data, 
	to hpet_is_known()
From: Venkatesh Pallipadi <venki@google.com>
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Clemens Ladisch <clemens@ladisch.de>, Vojtech Pavlik <vojtech@suse.cz>,
       linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Venkatesh Pallipadi <venki@google.com>

On Thu, Mar 18, 2010 at 10:59 AM, Bjorn Helgaas <bjorn.helgaas@hp.com> wrote:
>
> No functional change; hpet_is_known() only needs the physical address,
> so supplying that instead of the whole struct hpet_data makes the callers
> a little simpler.
>
> Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
> Acked-by: Clemens Ladisch <clemens@ladisch.de>
> ---
>
>  drivers/char/hpet.c |   14 +++++---------
>  1 files changed, 5 insertions(+), 9 deletions(-)
>
>
> diff --git a/drivers/char/hpet.c b/drivers/char/hpet.c
> index 5cb05ed..d132fef 100644
> --- a/drivers/char/hpet.c
> +++ b/drivers/char/hpet.c
> @@ -662,12 +662,12 @@ static const struct file_operations hpet_fops = {
>        .mmap = hpet_mmap,
>  };
>
> -static int hpet_is_known(struct hpet_data *hdp)
> +static int hpet_is_known(unsigned long phys_address)
>  {
>        struct hpets *hpetp;
>
>        for (hpetp = hpets; hpetp; hpetp = hpetp->hp_next)
> -               if (hpetp->hp_hpet_phys == hdp->hd_phys_address)
> +               if (hpetp->hp_hpet_phys == phys_address)
>                        return 1;
>
>        return 0;
> @@ -788,7 +788,7 @@ int hpet_alloc(struct hpet_data *hdp)
>         * If platform dependent code has allocated the hpet that
>         * ACPI has also reported, then we catch it here.
>         */
> -       if (hpet_is_known(hdp)) {
> +       if (hpet_is_known(hdp->hd_phys_address)) {
>                printk(KERN_DEBUG "%s: duplicate HPET ignored\n",
>                        __func__);
>                return 0;
> @@ -909,12 +909,7 @@ static int hpet_pnp_add(struct pnp_dev *dev, const struct pnp_device_id *dev_id)
>        memset(&data, 0, sizeof(data));
>
>        mem = pnp_get_resource(dev, IORESOURCE_MEM, 0);
> -       if (!mem)
> -               return -ENODEV;
> -
> -       data.hd_phys_address = mem->start;
> -
> -       if (hpet_is_known(&data))
> +       if (!mem || hpet_is_known(mem->start))
>                return -ENODEV;
>
>        i = 0;
> @@ -926,6 +921,7 @@ static int hpet_pnp_add(struct pnp_dev *dev, const struct pnp_device_id *dev_id)
>        if (!data.hd_nirqs)
>                return -ENODEV;
>
> +       data.hd_phys_address = mem->start;
>        data.hd_address = ioremap(mem->start, resource_size(mem));
>
>        return hpet_alloc(&data);
>
>
