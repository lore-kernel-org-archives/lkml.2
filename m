Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755404Ab3ADWNp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2013 17:13:45 -0500
Received: from mail-vc0-f179.google.com ([209.85.220.179]:42723 "EHLO
	mail-vc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755117Ab3ADWNo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2013 17:13:44 -0500
MIME-Version: 1.0
In-Reply-To: <20130103223415.10751.17744.stgit@grignak.americas.hpqcorp.net>
References: <20130103223401.10751.1838.stgit@grignak.americas.hpqcorp.net> <20130103223415.10751.17744.stgit@grignak.americas.hpqcorp.net>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Fri, 4 Jan 2013 15:07:30 -0700
Message-ID: <CAErSpo5LV5QApKqVVV7FdpjdFFZ9=+8JJfaDtDqJ2AzFpxM+HA@mail.gmail.com>
Subject: Re: [PATCH v9 3/3] aerdrv: Cleanup log output for AER
To: Lance Ortiz <lance.ortiz@hp.com>
Cc: lance_ortiz@hotmail.com, jiang.liu@huawei.com, tony.luck@intel.com,
        bp@alien8.de, rostedt@goodmis.org, mchehab@redhat.com,
        linux-acpi@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 3, 2013 at 3:34 PM, Lance Ortiz <lance.ortiz@hp.com> wrote:
> These changes make cper_print_aer more consistent with aer_print_error
> and clean things up by elimiating the use of the prefix variable and
> replacing it with dev_printk.
>
> v1-v2 fix some compile errors withinn the #ifdef
> v3-v4 remove agent id stuff and kept print the same to avoid
> compatibility issues
> v7-v8 Updated to use dev_printk instated of prefix. Changed
> log levels to KERN_ERR as per Mauro's suggestion.
> v8-v9 Changed dev_printk to dev_err since all log levels are KERN_ERR.
>
> Signed-off-by: Lance Ortiz <lance.ortiz@hp.com>
> Acked-by: Tony Luck <tony.luck@intel.com>

Acked-by: Bjorn Helgaas <bhelgaas@google.com>

Nits (no need to fix them unless you have other reasons to touch this patch):

s/elimiating/eliminating/ above.

I remove the "v1-v2" notes when I merge patches because I don't think
they're useful any more.  But if Tony applies these, he can use his
judgment.

And a couple more below.

> ---
>
>  drivers/pci/pcie/aer/aerdrv_errprint.c |   54 +++++++++++++++-----------------
>  1 files changed, 26 insertions(+), 28 deletions(-)
>
> diff --git a/drivers/pci/pcie/aer/aerdrv_errprint.c b/drivers/pci/pcie/aer/aerdrv_errprint.c
> index d3e5fc5..5ab1425 100644
> --- a/drivers/pci/pcie/aer/aerdrv_errprint.c
> +++ b/drivers/pci/pcie/aer/aerdrv_errprint.c
> @@ -124,12 +124,11 @@ static const char *aer_agent_string[] = {
>         "Transmitter ID"
>  };
>
> -static void __aer_print_error(const char *prefix,
> +static void __aer_print_error(struct pci_dev *dev,
>                               struct aer_err_info *info)

This looks like it would fit on one line.

>  {
>         int i, status;
>         const char *errmsg = NULL;
> -

Don't remove this blank line.

>         status = (info->status & ~info->mask);
>
>         for (i = 0; i < 32; i++) {
> @@ -144,26 +143,22 @@ static void __aer_print_error(const char *prefix,
>                                 aer_uncorrectable_error_string[i] : NULL;
>
>                 if (errmsg)
> -                       printk("%s""   [%2d] %-22s%s\n", prefix, i, errmsg,
> +                       dev_err(&dev->dev, "   [%2d] %-22s%s\n", i, errmsg,
>                                 info->first_error == i ? " (First)" : "");
>                 else
> -                       printk("%s""   [%2d] Unknown Error Bit%s\n", prefix, i,
> -                               info->first_error == i ? " (First)" : "");
> +                       dev_err(&dev->dev, "   [%2d] Unknown Error Bit%s\n",
> +                               i, info->first_error == i ? " (First)" : "");
>         }
>  }
>
>  void aer_print_error(struct pci_dev *dev, struct aer_err_info *info)
>  {
>         int id = ((dev->bus->number << 8) | dev->devfn);
> -       char prefix[44];
> -
> -       snprintf(prefix, sizeof(prefix), "%s%s %s: ",
> -                (info->severity == AER_CORRECTABLE) ? KERN_WARNING : KERN_ERR,
> -                dev_driver_string(&dev->dev), dev_name(&dev->dev));
>
>         if (info->status == 0) {
> -               printk("%s""PCIe Bus Error: severity=%s, type=Unaccessible, "
> -                       "id=%04x(Unregistered Agent ID)\n", prefix,
> +               dev_err(&dev->dev,
> +                       "PCIe Bus Error: severity=%s, type=Unaccessible, "
> +                       "id=%04x(Unregistered Agent ID)\n",
>                         aer_error_severity_string[info->severity], id);

This means these messages will all be KERN_ERR, when they used to be
KERN_WARNING or KERN_ERR depending on the severity.  That's OK with
me, but mentioning in the changelog would make clear that this is what
you intended.

>         } else {
>                 int layer, agent;
> @@ -171,22 +166,24 @@ void aer_print_error(struct pci_dev *dev, struct aer_err_info *info)
>                 layer = AER_GET_LAYER_ERROR(info->severity, info->status);
>                 agent = AER_GET_AGENT(info->severity, info->status);
>
> -               printk("%s""PCIe Bus Error: severity=%s, type=%s, id=%04x(%s)\n",
> -                       prefix, aer_error_severity_string[info->severity],
> +               dev_err(&dev->dev,
> +                       "PCIe Bus Error: severity=%s, type=%s, id=%04x(%s)\n",
> +                       aer_error_severity_string[info->severity],
>                         aer_error_layer[layer], id, aer_agent_string[agent]);
>
> -               printk("%s""  device [%04x:%04x] error status/mask=%08x/%08x\n",
> -                       prefix, dev->vendor, dev->device,
> +               dev_err(&dev->dev,
> +                       "  device [%04x:%04x] error status/mask=%08x/%08x\n",
> +                       dev->vendor, dev->device,
>                         info->status, info->mask);
>
> -               __aer_print_error(prefix, info);
> +               __aer_print_error(dev, info);
>
>                 if (info->tlp_header_valid) {
>                         unsigned char *tlp = (unsigned char *) &info->tlp;
> -                       printk("%s""  TLP Header:"
> +                       dev_err(&dev->dev, "  TLP Header:"
>                                 " %02x%02x%02x%02x %02x%02x%02x%02x"
>                                 " %02x%02x%02x%02x %02x%02x%02x%02x\n",
> -                               prefix, *(tlp + 3), *(tlp + 2), *(tlp + 1), *tlp,
> +                               *(tlp + 3), *(tlp + 2), *(tlp + 1), *tlp,
>                                 *(tlp + 7), *(tlp + 6), *(tlp + 5), *(tlp + 4),
>                                 *(tlp + 11), *(tlp + 10), *(tlp + 9),
>                                 *(tlp + 8), *(tlp + 15), *(tlp + 14),
> @@ -195,8 +192,9 @@ void aer_print_error(struct pci_dev *dev, struct aer_err_info *info)
>         }
>
>         if (info->id && info->error_dev_num > 1 && info->id == id)
> -               printk("%s""  Error of this Agent(%04x) is reported first\n",
> -                       prefix, id);
> +               dev_err(&dev->dev,
> +                          "  Error of this Agent(%04x) is reported first\n",
> +                       id);
>         trace_aer_event(dev_name(&dev->dev), (info->status & ~info->mask),
>                         info->severity);
>  }
> @@ -244,21 +242,21 @@ void cper_print_aer(const char *prefix, struct pci_dev *dev, int cper_severity,
>         }
>         layer = AER_GET_LAYER_ERROR(aer_severity, status);
>         agent = AER_GET_AGENT(aer_severity, status);
> -       printk("%s""aer_status: 0x%08x, aer_mask: 0x%08x\n",
> -              prefix, status, mask);
> +       dev_err(&dev->dev, "aer_status: 0x%08x, aer_mask: 0x%08x\n",
> +              status, mask);
>         cper_print_bits(prefix, status, status_strs, status_strs_size);
> -       printk("%s""aer_layer=%s, aer_agent=%s\n", prefix,
> +       dev_err(&dev->dev, "aer_layer=%s, aer_agent=%s\n",
>                aer_error_layer[layer], aer_agent_string[agent]);
>         if (aer_severity != AER_CORRECTABLE)
> -               printk("%s""aer_uncor_severity: 0x%08x\n",
> -                      prefix, aer->uncor_severity);
> +               dev_err(&dev->dev, "aer_uncor_severity: 0x%08x\n",
> +                      aer->uncor_severity);
>         if (tlp_header_valid) {
>                 const unsigned char *tlp;
>                 tlp = (const unsigned char *)&aer->header_log;
> -               printk("%s""aer_tlp_header:"
> +               dev_err(&dev->dev, "aer_tlp_header:"
>                         " %02x%02x%02x%02x %02x%02x%02x%02x"
>                         " %02x%02x%02x%02x %02x%02x%02x%02x\n",
> -                       prefix, *(tlp + 3), *(tlp + 2), *(tlp + 1), *tlp,
> +                       *(tlp + 3), *(tlp + 2), *(tlp + 1), *tlp,
>                         *(tlp + 7), *(tlp + 6), *(tlp + 5), *(tlp + 4),
>                         *(tlp + 11), *(tlp + 10), *(tlp + 9),
>                         *(tlp + 8), *(tlp + 15), *(tlp + 14),
>
