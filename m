Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756772Ab2KBUVi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 16:21:38 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:52991 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750791Ab2KBUVg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 16:21:36 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Huang Ying <ying.huang@intel.com>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-pm@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [BUGFIX] PCI/PM: Fix proc config reg access for D3cold and bridge suspending
Date: Fri, 02 Nov 2012 21:25:42 +0100
Message-ID: <1888439.VY5iAKy5E9@vostro.rjw.lan>
User-Agent: KMail/4.8.5 (Linux/3.7.0-rc3; KDE/4.8.5; x86_64; ; )
In-Reply-To: <CAErSpo6Q9DGwBJNCY5g3gGVPMCngv6pfLXB6TfiFu3gyLiNp7Q@mail.gmail.com>
References: <1351128963-10347-1-git-send-email-ying.huang@intel.com> <CAErSpo6Q9DGwBJNCY5g3gGVPMCngv6pfLXB6TfiFu3gyLiNp7Q@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, November 02, 2012 10:38:43 AM Bjorn Helgaas wrote:
> On Wed, Oct 24, 2012 at 7:36 PM, Huang Ying <ying.huang@intel.com> wrote:
> > In
> >
> >   https://bugzilla.kernel.org/show_bug.cgi?id=48981
> >
> > Peter reported that /proc/bus/pci/??/??.? does not works for 3.6.
> > This is This is because the device configuration space registers will
> > be not accessible if the corresponding parent bridge is suspended or
> > the device is put into D3cold state.
> >
> > This is the same as /sys/bus/pci/devices/0000:??:??.?/config access
> > issue.  So the function used to solve sysfs issue is used to solve
> > this issue.
> >
> > Cc: stable@vger.kernel.org
> > Reported-by: Peter <lekensteyn@gmail.com>
> 
> Is this bug the same as the one originally reported by Forrest Loomis
> (original reporter of bug 48981)?  And
> https://bugzilla.kernel.org/show_bug.cgi?id=49031, reported by Micael
> Dias (Rafael marked 49031 as a duplicate of 48981)?
> 
> If so, I'll mention Forrest and Micael and bug 49031 here as well.

No, it's not.  That one turned out to be a duplicate of bko#48981.

Thanks,
Rafael


> > Signed-off-by: Huang Ying <ying.huang@intel.com>
> > ---
> >  drivers/pci/pci-sysfs.c |   34 ----------------------------------
> >  drivers/pci/pci.c       |   32 ++++++++++++++++++++++++++++++++
> >  drivers/pci/pci.h       |    2 ++
> >  drivers/pci/proc.c      |    8 ++++++++
> >  4 files changed, 42 insertions(+), 34 deletions(-)
> >
> > --- a/drivers/pci/pci-sysfs.c
> > +++ b/drivers/pci/pci-sysfs.c
> > @@ -458,40 +458,6 @@ boot_vga_show(struct device *dev, struct
> >  }
> >  struct device_attribute vga_attr = __ATTR_RO(boot_vga);
> >
> > -static void
> > -pci_config_pm_runtime_get(struct pci_dev *pdev)
> > -{
> > -       struct device *dev = &pdev->dev;
> > -       struct device *parent = dev->parent;
> > -
> > -       if (parent)
> > -               pm_runtime_get_sync(parent);
> > -       pm_runtime_get_noresume(dev);
> > -       /*
> > -        * pdev->current_state is set to PCI_D3cold during suspending,
> > -        * so wait until suspending completes
> > -        */
> > -       pm_runtime_barrier(dev);
> > -       /*
> > -        * Only need to resume devices in D3cold, because config
> > -        * registers are still accessible for devices suspended but
> > -        * not in D3cold.
> > -        */
> > -       if (pdev->current_state == PCI_D3cold)
> > -               pm_runtime_resume(dev);
> > -}
> > -
> > -static void
> > -pci_config_pm_runtime_put(struct pci_dev *pdev)
> > -{
> > -       struct device *dev = &pdev->dev;
> > -       struct device *parent = dev->parent;
> > -
> > -       pm_runtime_put(dev);
> > -       if (parent)
> > -               pm_runtime_put_sync(parent);
> > -}
> > -
> >  static ssize_t
> >  pci_read_config(struct file *filp, struct kobject *kobj,
> >                 struct bin_attribute *bin_attr,
> > --- a/drivers/pci/pci.c
> > +++ b/drivers/pci/pci.c
> > @@ -1858,6 +1858,38 @@ bool pci_dev_run_wake(struct pci_dev *de
> >  }
> >  EXPORT_SYMBOL_GPL(pci_dev_run_wake);
> >
> > +void pci_config_pm_runtime_get(struct pci_dev *pdev)
> > +{
> > +       struct device *dev = &pdev->dev;
> > +       struct device *parent = dev->parent;
> > +
> > +       if (parent)
> > +               pm_runtime_get_sync(parent);
> > +       pm_runtime_get_noresume(dev);
> > +       /*
> > +        * pdev->current_state is set to PCI_D3cold during suspending,
> > +        * so wait until suspending completes
> > +        */
> > +       pm_runtime_barrier(dev);
> > +       /*
> > +        * Only need to resume devices in D3cold, because config
> > +        * registers are still accessible for devices suspended but
> > +        * not in D3cold.
> > +        */
> > +       if (pdev->current_state == PCI_D3cold)
> > +               pm_runtime_resume(dev);
> > +}
> > +
> > +void pci_config_pm_runtime_put(struct pci_dev *pdev)
> > +{
> > +       struct device *dev = &pdev->dev;
> > +       struct device *parent = dev->parent;
> > +
> > +       pm_runtime_put(dev);
> > +       if (parent)
> > +               pm_runtime_put_sync(parent);
> > +}
> > +
> >  /**
> >   * pci_pm_init - Initialize PM functions of given PCI device
> >   * @dev: PCI device to handle.
> > --- a/drivers/pci/pci.h
> > +++ b/drivers/pci/pci.h
> > @@ -72,6 +72,8 @@ extern void pci_disable_enabled_device(s
> >  extern int pci_finish_runtime_suspend(struct pci_dev *dev);
> >  extern int __pci_pme_wakeup(struct pci_dev *dev, void *ign);
> >  extern void pci_wakeup_bus(struct pci_bus *bus);
> > +extern void pci_config_pm_runtime_get(struct pci_dev *dev);
> > +extern void pci_config_pm_runtime_put(struct pci_dev *dev);
> >  extern void pci_pm_init(struct pci_dev *dev);
> >  extern void platform_pci_wakeup_init(struct pci_dev *dev);
> >  extern void pci_allocate_cap_save_buffers(struct pci_dev *dev);
> > --- a/drivers/pci/proc.c
> > +++ b/drivers/pci/proc.c
> > @@ -76,6 +76,8 @@ proc_bus_pci_read(struct file *file, cha
> >         if (!access_ok(VERIFY_WRITE, buf, cnt))
> >                 return -EINVAL;
> >
> > +       pci_config_pm_runtime_get(dev);
> > +
> >         if ((pos & 1) && cnt) {
> >                 unsigned char val;
> >                 pci_user_read_config_byte(dev, pos, &val);
> > @@ -121,6 +123,8 @@ proc_bus_pci_read(struct file *file, cha
> >                 cnt--;
> >         }
> >
> > +       pci_config_pm_runtime_put(dev);
> > +
> >         *ppos = pos;
> >         return nbytes;
> >  }
> > @@ -146,6 +150,8 @@ proc_bus_pci_write(struct file *file, co
> >         if (!access_ok(VERIFY_READ, buf, cnt))
> >                 return -EINVAL;
> >
> > +       pci_config_pm_runtime_get(dev);
> > +
> >         if ((pos & 1) && cnt) {
> >                 unsigned char val;
> >                 __get_user(val, buf);
> > @@ -191,6 +197,8 @@ proc_bus_pci_write(struct file *file, co
> >                 cnt--;
> >         }
> >
> > +       pci_config_pm_runtime_put(dev);
> > +
> >         *ppos = pos;
> >         i_size_write(ino, dp->size);
> >         return nbytes;
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-pci" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
