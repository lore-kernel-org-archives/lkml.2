Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755777Ab2LCRka (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 12:40:30 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:41085 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755677Ab2LCRk2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 12:40:28 -0500
MIME-Version: 1.0
In-Reply-To: <1354552622-687-1-git-send-email-betty.dall@hp.com>
References: <1354552622-687-1-git-send-email-betty.dall@hp.com>
Date: Mon, 3 Dec 2012 10:40:27 -0700
Message-ID: <CAKocOOOudEzMx0Zs9CB2zmtCkPHVkx1TCbWeK2+uoV5cb=eiGg@mail.gmail.com>
Subject: Re: [PATCH] PCI AER: pci_get_domain_bus_and_slot() call missing
 required pci_dev_put()
From: Shuah Khan <shuahkhan@gmail.com>
To: Betty Dall <betty.dall@hp.com>
Cc: bhelgaas@google.com, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, wangyijing@huawei.com, jiang.liu@huawei.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 3, 2012 at 9:37 AM, Betty Dall <betty.dall@hp.com> wrote:
> The function aer_recover_queue() makes a call to pci_get_domain_bus_and_slot().
> That function is documented to require that the caller decrement the
> reference count by calling pci_dev_put(). This patch adds the missing
> call to pci_dev_put().
>
> Signed-off-by: Betty Dall <betty.dall@hp.com>
> ---
>  drivers/pci/pcie/aer/aerdrv_core.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/pci/pcie/aer/aerdrv_core.c b/drivers/pci/pcie/aer/aerdrv_core.c
> index af4e31c..43caf53 100644
> --- a/drivers/pci/pcie/aer/aerdrv_core.c
> +++ b/drivers/pci/pcie/aer/aerdrv_core.c
> @@ -616,6 +616,7 @@ static void aer_recover_work_func(struct work_struct *work)
>                         continue;
>                 }
>                 do_recovery(pdev, entry.severity);
> +               pci_dev_put(pdev);

Are you sure pci_get_domain_bus_and_slot() does indeed increment the
reference count? I see that in the comments right above the
definition.

pci_dev_get() does that for sure. I see a call trace of

pci_dev_get() -> get_device() -> kobj_to_dev(kobject_get(&dev->kobj)  etc.

and kref_get() finally incrementing the

static inline void kref_get(struct kref *kref)
{
        WARN_ON(!atomic_read(&kref->refcount));
        atomic_inc(&kref->refcount);
}

However, I could not find any evidence that
pci_get_domain_bus_and_slot() does that. I see
pci_get_domain_bus_and_slot() calling pci_domain_nr() and there are
several architecture specific defines for pci_domain_nr(). It is not
clear to me where does refcount get incremented from
pci_get_domain_bus_and_slot() is called.

What am I missing?

Thanks,
-- Shuah
