Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759352Ab2HIABx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 20:01:53 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:55155 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752037Ab2HIABv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 20:01:51 -0400
MIME-Version: 1.0
In-Reply-To: <1344469333-8739-1-git-send-email-charlie.mear@hp.com>
References: <1344469333-8739-1-git-send-email-charlie.mear@hp.com>
Date: Wed, 8 Aug 2012 17:01:50 -0700
X-Google-Sender-Auth: OnjKDoCwjgO1bPrY2KvfZCKaeXo
Message-ID: <CAE9FiQW2aFMxO54aD_GFSegjsfwexA2E+azFr3bqkh9248z3Uw@mail.gmail.com>
Subject: Re: [PATCH] x86/pci: Allow x86 platforms to use translation offsets
From: Yinghai Lu <yinghai@kernel.org>
To: charlie.mear@hp.com
Cc: ">" <"tglx@linutronix.de, mingo@redhat.com, hpa"@zytor.com>,
        x86@kernel.org, bhelgaas@google.com, jbarnes@virtuousgeek.org,
        davej@redhat.com, liuj97@gmail.com, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 8, 2012 at 4:42 PM,  <charlie.mear@hp.com> wrote:
> From: Charlie Mear <charlie.mear@hp.com>
>
> The memory range descriptors in the _CRS control method contain an
> address translation offset for host bridges.  This value is used to
> translate addresses across the bridge.  The support to use _TRA values
> is present for other architectures but not for X86 platforms.
>
> For existing X86 platforms the _TRA value is zero.  Non zero _TRA values
> are expected on future X86 platforms and this change will register that
> value with the resource.
>
> Signed-off-by: Charlie Mear <charlie.mear@hp.com>
> ---
>  arch/x86/pci/acpi.c |   18 ++++++++++++++++--
>  1 files changed, 16 insertions(+), 2 deletions(-)
>
> diff --git a/arch/x86/pci/acpi.c b/arch/x86/pci/acpi.c
> index 505acdd..37acbae 100644
> --- a/arch/x86/pci/acpi.c
> +++ b/arch/x86/pci/acpi.c
> @@ -12,6 +12,7 @@ struct pci_root_info {
>         char name[16];
>         unsigned int res_num;
>         struct resource *res;
> +       u64 *res_offset;

resource_size_t * ?

>         struct pci_sysdata sd;
>  #ifdef CONFIG_PCI_MMCONFIG
>         bool mcfg_added;
> @@ -306,6 +307,7 @@ setup_resource(struct acpi_resource *acpi_res, void *data)
>         res->start = start;
>         res->end = end;
>         res->child = NULL;
> +       info->res_offset[info->res_num] = addr.translation_offset;
>
>         if (!pci_use_crs) {
>                 dev_printk(KERN_DEBUG, &info->bridge->dev,
> @@ -375,7 +377,8 @@ static void add_resources(struct pci_root_info *info,
>                                  "ignoring host bridge window %pR (conflicts with %s %pR)\n",
>                                  res, conflict->name, conflict);
>                 else
> -                       pci_add_resource(resources, res);
> +                       pci_add_resource_offset(resources, res,
> +                                       info->res_offset[i]);
>         }
>  }
>
> @@ -383,6 +386,8 @@ static void free_pci_root_info_res(struct pci_root_info *info)
>  {
>         kfree(info->res);
>         info->res = NULL;
> +       kfree(info->res_offset);
> +       info->res_offset = NULL;
>         info->res_num = 0;
>  }
>
> @@ -433,11 +438,20 @@ probe_pci_root_info(struct pci_root_info *info, struct acpi_device *device,
>                 return;
>
>         size = sizeof(*info->res) * info->res_num;
> -       info->res_num = 0;
>         info->res = kmalloc(size, GFP_KERNEL);
>         if (!info->res)
                   you need to info->res_num = 0 here
>                 return;
>
> +       size = sizeof(*info->res_offset) * info->res_num;
> +       info->res_offset = kmalloc(size, GFP_KERNEL);
> +       if (!info->res_offset) {
> +               kfree(info->res);
> +               info->res = NULL;
> +               return;
> +       }
> +       info->res_num = 0;

need to move it before: if (!info->res_offset) {

Thanks

Yinghai
