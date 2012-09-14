Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759264Ab2INSNq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 14:13:46 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:63759 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752023Ab2INSNo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 14:13:44 -0400
MIME-Version: 1.0
In-Reply-To: <20120823213529.GH14962@google.com>
References: <20120823213529.GH14962@google.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Fri, 14 Sep 2012 12:13:21 -0600
Message-ID: <CAErSpo7p_fx9oCNFXdP7JVN_2ZPWN=t4Gsx9M7JLy8hpSn0dYQ@mail.gmail.com>
Subject: Re: [PATCH] pci: rewrite pci_call_probe() to use workqueue instead of work_on_cpu()
To: Tejun Heo <tj@kernel.org>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 23, 2012 at 3:35 PM, Tejun Heo <tj@kernel.org> wrote:
> pci_call_probe() uses work_on_cpu(), which creates and tears down a
> full kthread on each call, to invoke ->probe() on node local CPU for
> allocation affinity.
>
> The same goal can easily be achieved using a work item.  This patch
> rewrites pci_call_probe() so that it uses a work item instead of
> work_on_cpu().
>
> Note that the function is restructured for simplicity.  This adds
> get/put_online_cpus() pair for devices without node but the overhead
> of doing so isn't anything material at this level.
>
> Signed-off-by: Tejun Heo <tj@kernel.org>

I applied this to my "next" branch and pushed it.  Thanks!

> ---
> I tested both paths but had to simulate device on foreign node.
>
> Thanks.
>
>  drivers/pci/pci-driver.c |   48 +++++++++++++++++++++++++++--------------------
>  1 file changed, 28 insertions(+), 20 deletions(-)
>
> diff --git a/drivers/pci/pci-driver.c b/drivers/pci/pci-driver.c
> index 5270f1a..554c15a 100644
> --- a/drivers/pci/pci-driver.c
> +++ b/drivers/pci/pci-driver.c
> @@ -274,11 +274,14 @@ struct drv_dev_and_id {
>         struct pci_driver *drv;
>         struct pci_dev *dev;
>         const struct pci_device_id *id;
> +       struct work_struct work;
> +       int error;
>  };
>
> -static long local_pci_probe(void *_ddi)
> +static void pci_probe_fn(struct work_struct *work)
>  {
> -       struct drv_dev_and_id *ddi = _ddi;
> +       struct drv_dev_and_id *ddi = container_of(work, struct drv_dev_and_id,
> +                                                 work);
>         struct device *dev = &ddi->dev->dev;
>         int rc;
>
> @@ -298,33 +301,38 @@ static long local_pci_probe(void *_ddi)
>                 pm_runtime_set_suspended(dev);
>                 pm_runtime_put_noidle(dev);
>         }
> -       return rc;
> +
> +       ddi->error = rc;
>  }
>
>  static int pci_call_probe(struct pci_driver *drv, struct pci_dev *dev,
>                           const struct pci_device_id *id)
>  {
> -       int error, node;
> +       int node;
> +       int cpu = nr_cpu_ids;
>         struct drv_dev_and_id ddi = { drv, dev, id };
>
> -       /* Execute driver initialization on node where the device's
> -          bus is attached to.  This way the driver likely allocates
> -          its local memory on the right node without any need to
> -          change it. */
> -       node = dev_to_node(&dev->dev);
> -       if (node >= 0) {
> -               int cpu;
> +       /*
> +        * Execute driver initialization on node where the device's bus is
> +        * attached to.  This way the driver likely allocates its local
> +        * memory on the right node without any need to change it.
> +        */
> +       get_online_cpus();
>
> -               get_online_cpus();
> +       node = dev_to_node(&dev->dev);
> +       if (node >= 0)
>                 cpu = cpumask_any_and(cpumask_of_node(node), cpu_online_mask);
> -               if (cpu < nr_cpu_ids)
> -                       error = work_on_cpu(cpu, local_pci_probe, &ddi);
> -               else
> -                       error = local_pci_probe(&ddi);
> -               put_online_cpus();
> -       } else
> -               error = local_pci_probe(&ddi);
> -       return error;
> +
> +       if (cpu < nr_cpu_ids) {
> +               INIT_WORK_ONSTACK(&ddi.work, pci_probe_fn);
> +               schedule_work_on(cpu, &ddi.work);
> +               flush_work(&ddi.work);
> +       } else {
> +               pci_probe_fn(&ddi.work);
> +       }
> +
> +       put_online_cpus();
> +       return ddi.error;
>  }
>
>  /**
