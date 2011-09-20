Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753145Ab1ITCJj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Sep 2011 22:09:39 -0400
Received: from smtp-out.google.com ([216.239.44.51]:17802 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751046Ab1ITCJi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Sep 2011 22:09:38 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:from:date:
	message-id:subject:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=QUJY0mnPeI+zz054CBntOpgTa+R1uOcWfIeLG0+WzNtY7hFw3ToXQ0MEhGHe7goUW
	yqnFd1Pw9Nx8I2rfI0Wlg==
MIME-Version: 1.0
In-Reply-To: <1316482741-21799-5-git-send-email-ying.huang@intel.com>
References: <1316482741-21799-1-git-send-email-ying.huang@intel.com> <1316482741-21799-5-git-send-email-ying.huang@intel.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Mon, 19 Sep 2011 20:09:14 -0600
Message-ID: <CAErSpo4_syhxOi8jGo5oyrWBimsO7PdsXEky1vwPY_130OuPMA@mail.gmail.com>
Subject: Re: [PATCH 4/8] ACPI, APEI, Resolve false conflict between ACPI NVS
 and APEI
To: Huang Ying <ying.huang@intel.com>
Cc: Len Brown <lenb@kernel.org>, linux-kernel@vger.kernel.org,
        Tony Luck <tony.luck@intel.com>, linux-acpi@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 19, 2011 at 7:38 PM, Huang Ying <ying.huang@intel.com> wrote:
> Some firmware will access memory in ACPI NVS region via APEI.  That
> is, instructions in APEI ERST/EINJ table will read/write ACPI NVS
> region.  The original resource conflict checking in APEI code will
> check memory/ioport accessed by APEI via general resource management
> mech.  But ACPI NVS region is marked as busy already, so that the
> false resource conflict will prevent APEI ERST/EINJ to work.
>
> To fix this, this patch excludes ACPI NVS regions when APEI components
> request resources.  So that they will not conflict with ACPI NVS
> regions.

I think this is much, much too complicated.

Yinghai's three-line e820.c patch to leave ACPI NVS regions in the
iomem_resource tree, but as not busy, is far better.

Bjorn

> Reported-and-tested-by: Pavel Ivanov <paivanof@gmail.com>
> Signed-off-by: Huang Ying <ying.huang@intel.com>
> ---
>  drivers/acpi/apei/apei-base.c |   29 ++++++++++++++++++++++++++++-
>  1 file changed, 28 insertions(+), 1 deletion(-)
>
> --- a/drivers/acpi/apei/apei-base.c
> +++ b/drivers/acpi/apei/apei-base.c
> @@ -438,8 +438,19 @@ int apei_resources_sub(struct apei_resou
>  }
>  EXPORT_SYMBOL_GPL(apei_resources_sub);
>
> +static int apei_get_nvs_callback(__u64 start, __u64 size, void *data)
> +{
> +       struct apei_resources *resources = data;
> +       return apei_res_add(&resources->iomem, start, size);
> +}
> +
> +static int apei_get_nvs_resources(struct apei_resources *resources)
> +{
> +       return acpi_nvs_for_each_region(apei_get_nvs_callback, resources);
> +}
> +
>  /*
> - * IO memory/port rersource management mechanism is used to check
> + * IO memory/port resource management mechanism is used to check
>  * whether memory/port area used by GARs conflicts with normal memory
>  * or IO memory/port of devices.
>  */
> @@ -448,12 +459,26 @@ int apei_resources_request(struct apei_r
>  {
>        struct apei_res *res, *res_bak = NULL;
>        struct resource *r;
> +       struct apei_resources nvs_resources;
>        int rc;
>
>        rc = apei_resources_sub(resources, &apei_resources_all);
>        if (rc)
>                return rc;
>
> +       /*
> +        * Some firmware uses ACPI NVS region, that has been marked as
> +        * busy, so exclude it from APEI resources to avoid false
> +        * conflict.
> +        */
> +       apei_resources_init(&nvs_resources);
> +       rc = apei_get_nvs_resources(&nvs_resources);
> +       if (rc)
> +               goto res_fini;
> +       rc = apei_resources_sub(resources, &nvs_resources);
> +       if (rc)
> +               goto res_fini;
> +
>        rc = -EINVAL;
>        list_for_each_entry(res, &resources->iomem, list) {
>                r = request_mem_region(res->start, res->end - res->start,
> @@ -500,6 +525,8 @@ err_unmap_iomem:
>                        break;
>                release_mem_region(res->start, res->end - res->start);
>        }
> +res_fini:
> +       apei_resources_fini(&nvs_resources);
>        return rc;
>  }
>  EXPORT_SYMBOL_GPL(apei_resources_request);
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
