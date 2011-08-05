Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756127Ab1HECYL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Aug 2011 22:24:11 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:41303 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755591Ab1HECYI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Aug 2011 22:24:08 -0400
MIME-Version: 1.0
In-Reply-To: <20110803223407.GA20646@redhat.com>
References: <20110803223407.GA20646@redhat.com>
Date: Thu, 4 Aug 2011 22:24:07 -0400
Message-ID: <CACqU3MXaHJ+AnUpkeBWg=aHp3iJBR=uXgr22pinAdu-wgeoCuQ@mail.gmail.com>
Subject: Re: [rfc] suppress excessive AER output
From: Arnaud Lacombe <lacombar@gmail.com>
To: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        tom.l.nguyen@intel.com, yanmin.zhang@intel.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, Aug 3, 2011 at 6:34 PM, Dave Jones <davej@redhat.com> wrote:
> I have a machine that has developed some kind of problem with
> its onboard ethernet.  It still boots, but spewed almost 1.5G of text
> (2381585 instances of the warning below) before we realised what
> was going on, and blacklisted the igb driver.
>
> Is it worth logging every single error when we're flooding like this ?
> It seems unlikely that we'll find useful information in amongst that much data
> that wasn't already in the first 100 instances.
>
> I picked 100 in the (untested) example patch below arbitarily, but the exact
> value could be smaller, or slightly bigger..
>
> could we do something like this maybe ?
>
Please do not reinvent the wheel and use printk_ratelimited().

Thanks,
 - Arnaud

>        Dave
>
> diff --git a/drivers/pci/pcie/aer/aerdrv_errprint.c b/drivers/pci/pcie/aer/aerdrv_errprint.c
> index 3ea5173..4ec88c6 100644
> --- a/drivers/pci/pcie/aer/aerdrv_errprint.c
> +++ b/drivers/pci/pcie/aer/aerdrv_errprint.c
> @@ -153,6 +153,17 @@ void aer_print_error(struct pci_dev *dev, struct aer_err_info *info)
>  {
>        int id = ((dev->bus->number << 8) | dev->devfn);
>        char prefix[44];
> +       static unsigned long aer_printk_limit = 0;
> +
> +       aer_printk_limit++;
> +
> +       if (aer_printk_limit > 100)
> +               return;
> +
> +       if (aer_printk_limit == 100) {
> +               printk(KERN_ERR "Reached limit of 100 AER errors. Further AER output suppressed.\n");
> +               return;
> +       }
>
>        snprintf(prefix, sizeof(prefix), "%s%s %s: ",
>                 (info->severity == AER_CORRECTABLE) ? KERN_WARNING : KERN_ERR,
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
