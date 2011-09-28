Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751634Ab1I1Tm1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 15:42:27 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:34524 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751840Ab1I1TmY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 15:42:24 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Bjorn Helgaas <bhelgaas@google.com>
Subject: Re: [PATCH] PCI / PM: Remove unnecessary error variable from acpi_dev_run_wake()
Date: Wed, 28 Sep 2011 21:44:36 +0200
User-Agent: KMail/1.13.6 (Linux/3.1.0-rc8+; KDE/4.6.0; x86_64; ; )
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        ACPI Devel Mailing List <linux-acpi@vger.kernel.org>,
        linux-pci@vger.kernel.org
References: <201109280001.28857.rjw@sisk.pl> <CAErSpo4CpEWaKkh280Kb_nNSVWfYKGZ06HQOrpLar=T40TyDZQ@mail.gmail.com>
In-Reply-To: <CAErSpo4CpEWaKkh280Kb_nNSVWfYKGZ06HQOrpLar=T40TyDZQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201109282144.36766.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, September 28, 2011, Bjorn Helgaas wrote:
> On Tue, Sep 27, 2011 at 4:01 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > From: Rafael J. Wysocki <rjw@sisk.pl>
> >
> > The error variable in acpi_dev_run_wake() is not really used, so
> > remove it.
> >
> > Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> > ---
> >  drivers/pci/pci-acpi.c |    3 +--
> >  1 file changed, 1 insertion(+), 2 deletions(-)
> >
> > Index: linux/drivers/pci/pci-acpi.c
> > ===================================================================
> > --- linux.orig/drivers/pci/pci-acpi.c
> > +++ linux/drivers/pci/pci-acpi.c
> > @@ -282,7 +282,6 @@ static int acpi_dev_run_wake(struct devi
> >  {
> >        struct acpi_device *dev;
> >        acpi_handle handle;
> > -       int error = -ENODEV;
> >
> >        if (!device_run_wake(phys_dev))
> >                return -EINVAL;
> > @@ -302,7 +301,7 @@ static int acpi_dev_run_wake(struct devi
> >                acpi_disable_wakeup_device_power(dev);
> >        }
> >
> > -       return error;
> > +       return 0;
> >  }
> >
> >  static void acpi_pci_propagate_run_wake(struct pci_bus *bus, bool enable)
> 
> This looks like the right thing to do, but the current changelog
> suggests that we're just removing unused code.
> 
> But in fact, we'll now return 0 (success) when we used to return
> -ENODEV, so the behavior of the callers will change (probably fixing
> some bugs).  Do you want to mention that in the changelog as well?

Yes, good idea.

> I'm assuming this is for the 3.2 merge window, since it doesn't look
> like a regression fix.

Yes, it's 3.2 material.

Below is an updated patch.

Thanks,
Rafael

---
From: Rafael J. Wysocki <rjw@sisk.pl>
Subject: PCI / PM: Return correct result from acpi_dev_run_wake()

The result returned by acpi_dev_run_wake() is always either -EINVAL
or -ENODEV, while obviously it should return 0 on success.  The
problem is that the leftover error variable, that's not really used
in the function, is initialized with -ENODEV and then returned
without modification.

To fix this issue remove the error variable from acpi_dev_run_wake()
and make the function return 0 on success as appropriate.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/pci/pci-acpi.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

Index: linux/drivers/pci/pci-acpi.c
===================================================================
--- linux.orig/drivers/pci/pci-acpi.c
+++ linux/drivers/pci/pci-acpi.c
@@ -282,7 +282,6 @@ static int acpi_dev_run_wake(struct devi
 {
 	struct acpi_device *dev;
 	acpi_handle handle;
-	int error = -ENODEV;
 
 	if (!device_run_wake(phys_dev))
 		return -EINVAL;
@@ -302,7 +301,7 @@ static int acpi_dev_run_wake(struct devi
 		acpi_disable_wakeup_device_power(dev);
 	}
 
-	return error;
+	return 0;
 }
 
 static void acpi_pci_propagate_run_wake(struct pci_bus *bus, bool enable)
