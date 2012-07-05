Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754777Ab2GEVaR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 17:30:17 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:56898 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752495Ab2GEVaN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 17:30:13 -0400
MIME-Version: 1.0
In-Reply-To: <201206281201.02414.rjw@sisk.pl>
References: <201206281201.02414.rjw@sisk.pl>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Thu, 5 Jul 2012 15:29:51 -0600
Message-ID: <CAErSpo7yM3p7+pGuvhBMMsffGTVKF77=MCgfiN1OYr2sB259JA@mail.gmail.com>
Subject: Re: [PATCH] PCI / PM: Restore the original behavior of pci_set_power_state()
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
        Linux PM mailing list <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        linux-pci <linux-pci@vger.kernel.org>,
        Huang Ying <ying.huang@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 28, 2012 at 4:01 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> From: Rafael J. Wysocki <rjw@sisk.pl>
>
> Commit cc2893b6 (PCI: Ensure we re-enable devices on resume)
> addressed the problem with USB not being powered after resume on
> recent Lenovo machines, but it did that in a suboptimal way.
> Namely, it should have changed the relevant code paths only,
> which are pci_pm_resume_noirq() and pci_pm_restore_noirq() supposed
> to restore the device's power and standard configuration registers
> after system resume from suspend or hibernation.  Instead, however,
> it modified pci_set_power_state() which is executed in several
> other situations too.  That resulted in some undesirable effects,
> like attempting to change a device's power state in the same way
> multiple times in a row (up to as many as 4 times in a row in the
> snd_hda_intel driver).
>
> Fix the bug addressed by commit cc2893b6 in an alternative way,
> by forcibly powering up all devices in pci_pm_default_resume_early(),
> which is called by pci_pm_resume_noirq() and pci_pm_restore_noirq()
> to restore the device's power and standard configuration registers,
> and modifying pci_pm_runtime_resume() to avoid the forcible power-up
> if not necessary.  Then, revert the changes made by commit cc2893b6
> to make the confusion introduced by it go away.
>
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> ---
>  drivers/pci/pci-driver.c |   14 ++++++++------
>  drivers/pci/pci.c        |   19 ++++++++++++++++++-
>  drivers/pci/pci.h        |    1 +
>  3 files changed, 27 insertions(+), 7 deletions(-)
>
> Index: linux/drivers/pci/pci.c
> ===================================================================
> --- linux.orig/drivers/pci/pci.c
> +++ linux/drivers/pci/pci.c
> @@ -662,6 +662,19 @@ void pci_update_current_state(struct pci
>  }
>
>  /**
> + * pci_power_up - Put the given device into D0 forcibly
> + * @dev: PCI device to power up
> + */
> +void pci_power_up(struct pci_dev *dev)
> +{
> +       if (platform_pci_power_manageable(dev))
> +               platform_pci_set_power_state(dev, PCI_D0);
> +
> +       pci_raw_set_power_state(dev, PCI_D0);
> +       pci_update_current_state(dev, PCI_D0);
> +}
> +
> +/**
>   * pci_platform_power_transition - Use platform to change device power state
>   * @dev: PCI device to handle.
>   * @state: State to put the device into.
> @@ -707,7 +720,7 @@ static void __pci_start_power_transition
>   */
>  int __pci_complete_power_transition(struct pci_dev *dev, pci_power_t state)
>  {
> -       return state >= PCI_D0 ?
> +       return state > PCI_D0 ?
>                         pci_platform_power_transition(dev, state) : -EINVAL;

This hunk conflicted with Huang's D3_COLD patches.  I fixed it up; can
you check and make sure I did it correctly?

I pushed the resolution to here:
git://git.kernel.org/pub/scm/linux/kernel/git/helgaas/pci.git on the
pci/rafael-pci_set_power_state-rebase branch.

Bjorn

>  }
>  EXPORT_SYMBOL_GPL(__pci_complete_power_transition);
> @@ -744,6 +757,10 @@ int pci_set_power_state(struct pci_dev *
>                  */
>                 return 0;
>
> +       /* Check if we're already there */
> +       if (dev->current_state == state)
> +               return 0;
> +
>         __pci_start_power_transition(dev, state);
>
>         /* This device is quirked not to be put into D3, so
> Index: linux/drivers/pci/pci-driver.c
> ===================================================================
> --- linux.orig/drivers/pci/pci-driver.c
> +++ linux/drivers/pci/pci-driver.c
> @@ -459,16 +459,17 @@ static int pci_restore_standard_config(s
>         return 0;
>  }
>
> +#endif
> +
> +#ifdef CONFIG_PM_SLEEP
> +
>  static void pci_pm_default_resume_early(struct pci_dev *pci_dev)
>  {
> -       pci_restore_standard_config(pci_dev);
> +       pci_power_up(pci_dev);
> +       pci_restore_state(pci_dev);
>         pci_fixup_device(pci_fixup_resume_early, pci_dev);
>  }
>
> -#endif
> -
> -#ifdef CONFIG_PM_SLEEP
> -
>  /*
>   * Default "suspend" method for devices that have no driver provided suspend,
>   * or not even a driver at all (second part).
> @@ -1050,7 +1051,8 @@ static int pci_pm_runtime_resume(struct
>         if (!pm || !pm->runtime_resume)
>                 return -ENOSYS;
>
> -       pci_pm_default_resume_early(pci_dev);
> +       pci_restore_standard_config(pci_dev);
> +       pci_fixup_device(pci_fixup_resume_early, pci_dev);
>         __pci_enable_wake(pci_dev, PCI_D0, true, false);
>         pci_fixup_device(pci_fixup_resume, pci_dev);
>
> Index: linux/drivers/pci/pci.h
> ===================================================================
> --- linux.orig/drivers/pci/pci.h
> +++ linux/drivers/pci/pci.h
> @@ -67,6 +67,7 @@ struct pci_platform_pm_ops {
>
>  extern int pci_set_platform_pm(struct pci_platform_pm_ops *ops);
>  extern void pci_update_current_state(struct pci_dev *dev, pci_power_t state);
> +extern void pci_power_up(struct pci_dev *dev);
>  extern void pci_disable_enabled_device(struct pci_dev *dev);
>  extern int pci_finish_runtime_suspend(struct pci_dev *dev);
>  extern int __pci_pme_wakeup(struct pci_dev *dev, void *ign);
