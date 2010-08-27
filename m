Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752182Ab0H0Xht (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 19:37:49 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:52072 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751893Ab0H0Xhs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 19:37:48 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Stephan Diestelhorst <stephan.diestelhorst@amd.com>
Subject: Re: [PATCH] SATA / AHCI: Do not play with the link PM during suspend to RAM
Date: Sat, 28 Aug 2010 01:35:38 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.36-rc2-rjw+; KDE/4.4.4; x86_64; ; )
Cc: Tejun Heo <htejun@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        "linux-pm@lists.osdl.org" <linux-pm@lists.osdl.org>,
        Stephan Diestelhorst <stephan.diestelhorst@gmail.com>
References: <201007091750.05020.stephan.diestelhorst@amd.com> <201008261815.34574.stephan.diestelhorst@amd.com> <201008262024.35551.rjw@sisk.pl>
In-Reply-To: <201008262024.35551.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201008280135.39005.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, August 26, 2010, Rafael J. Wysocki wrote:
> On Thursday, August 26, 2010, Stephan Diestelhorst wrote:
> > On Tuesday 24 August 2010 18:11:22 Stephan Diestelhorst wrote:
> > > On Tuesday 24 August 2010 18:07:23 Stephan Diestelhorst wrote:
> > > > On Monday 23 August 2010 14:03:40 Tejun Heo wrote:
> > > > > On 08/19/2010 06:23 PM, Stephan Diestelhorst wrote:
> > > > > > It says "max_performance", I have not touched anyhting. So it has been
> > > > > > like that all the time. Would this explain why your patch did not show
> > > > > > the debug printout?
> > > > > 
> > > > > Hmm... okay.  Yeah, if you haven't been using IPM at all, there won't
> > > > > be any debug messages but at the same time the posted patch should
> > > > > have had the same effect as Rafael's patch as IPM path isn't traveled
> > > > > at all.  Can you please check the followings?
> > > > > 
> > [...]
> > > > > * Rafael's patch actually fixes the problem.  If you haven't been
> > > > >   using IPM at all, Rafael's patch and mine should behave exactly the
> > > > >   same (ie. no IPM operation at all during suspend/resume).  It could
> > > > >   be that you're seeing a different issue.
> > > > 
> > > > That next on my list...
> > 
> > Just did the following: Rebased Rafaels patch to 2.6.35 and tried it
> > again (with added prints to make sure I am running the right one) and
> > did >10 suspend to ram / resume cycles under I/O write load. All of
> > them worked fine (for comparison: your patch resulted in RO HDD at
> > first attempt).
> > 
> > (I had some extra prints around the suspend functions changed in
> >  Rafael's patch, tried with and without, no change--works flawlessly.)
> > 
> > What do you make of this?
> 
> I think my patch actually does more than the Tejun's one.  I need to have a
> deeper look at them both.
> 
> I'm still testing the Tejun's patch on my system where I was able to reproduce
> the problem, but so far it's been working.

I reproduced the problem with the Tejun's patch applied, so I'm now quite
sure the problem is related to the suspend of controller ports (which is done
by scheduling SCSI error handling on the controller).

Anyway, below is a new version of my patch that plays a bit nicer with
the resume code.  Can you please check if it still fixes the problem for you?

Thanks,
Rafael

---
From: Rafael J. Wysocki <rjw@sisk.pl>
Subject: SATA / AHCI: Do not play with the link PM during suspend to RAM (v2)

My Acer Ferrari One occasionally loses communication with the HDD
(which in fact is an Intel SSD) during suspend to RAM.  The symptom
is that the IDENTIFY command times out during suspend and the device
is dropped by the kernel, so it is not available during resume and
the system is unuseable as a result.  The failure is not readily
reproducible, although it happens once every several suspends and
it always happens after the disk has been shut down by the SCSI
layer's suspend routine.

I was able to trace this issue down to the scheduling of error
handling for all of the controller's ports carried out by
ata_host_suspend(), which indicates quirky hardware.  However, the
AHCI driver, which is used on the affected box, doesn't really need
to do anything with the controller's ports during suspend to RAM,
because the controller is going to be put into D3 immediately by
ata_pci_device_do_suspend() and it will undergo full reset during
the subsequent resume anyway.  For this reason, make the AHCI driver
avoid calling ata_host_suspend() during suspend to RAM which works
around the problem and makes sense as a general optimization.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/ata/ahci.c        |   11 ++++++++++-
 drivers/ata/libata-core.c |   20 ++++++++++++++++++++
 include/linux/libata.h    |    1 +
 3 files changed, 31 insertions(+), 1 deletion(-)

Index: linux-2.6/drivers/ata/ahci.c
===================================================================
--- linux-2.6.orig/drivers/ata/ahci.c
+++ linux-2.6/drivers/ata/ahci.c
@@ -595,6 +595,7 @@ static int ahci_pci_device_suspend(struc
 	struct ahci_host_priv *hpriv = host->private_data;
 	void __iomem *mmio = hpriv->mmio;
 	u32 ctl;
+	int rc = 0;
 
 	if (mesg.event & PM_EVENT_SUSPEND &&
 	    hpriv->flags & AHCI_HFLAG_NO_SUSPEND) {
@@ -614,7 +615,15 @@ static int ahci_pci_device_suspend(struc
 		readl(mmio + HOST_CTL); /* flush */
 	}
 
-	return ata_pci_device_suspend(pdev, mesg);
+	if (mesg.event == PM_EVENT_SUSPEND)
+		ata_fake_suspend(host);
+	else
+		rc = ata_host_suspend(host, mesg);
+
+	if (!rc)
+		ata_pci_device_do_suspend(pdev, mesg);
+
+	return rc;
 }
 
 static int ahci_pci_device_resume(struct pci_dev *pdev)
Index: linux-2.6/include/linux/libata.h
===================================================================
--- linux-2.6.orig/include/linux/libata.h
+++ linux-2.6/include/linux/libata.h
@@ -986,6 +986,7 @@ extern bool ata_link_online(struct ata_l
 extern bool ata_link_offline(struct ata_link *link);
 #ifdef CONFIG_PM
 extern int ata_host_suspend(struct ata_host *host, pm_message_t mesg);
+extern void ata_fake_suspend(struct ata_host *host);
 extern void ata_host_resume(struct ata_host *host);
 #endif
 extern int ata_ratelimit(void);
Index: linux-2.6/drivers/ata/libata-core.c
===================================================================
--- linux-2.6.orig/drivers/ata/libata-core.c
+++ linux-2.6/drivers/ata/libata-core.c
@@ -5429,6 +5429,25 @@ int ata_host_suspend(struct ata_host *ho
 	return rc;
 }
 
+void ata_fake_suspend(struct ata_host *host)
+{
+	unsigned long flags;
+	int i;
+
+	for (i = 0; i < host->n_ports; i++) {
+		struct ata_port *ap = host->ports[i];
+
+		spin_lock_irqsave(ap->lock, flags);
+
+		ap->pm_mesg = PMSG_SUSPEND;
+		ap->pflags |= ATA_PFLAG_SUSPENDED;
+
+		spin_unlock_irqrestore(ap->lock, flags);
+	}
+
+	host->dev->power.power_state = PMSG_SUSPEND;
+}
+
 /**
  *	ata_host_resume - resume host
  *	@host: host to resume
@@ -6691,6 +6710,7 @@ EXPORT_SYMBOL_GPL(ata_link_online);
 EXPORT_SYMBOL_GPL(ata_link_offline);
 #ifdef CONFIG_PM
 EXPORT_SYMBOL_GPL(ata_host_suspend);
+EXPORT_SYMBOL_GPL(ata_fake_suspend);
 EXPORT_SYMBOL_GPL(ata_host_resume);
 #endif /* CONFIG_PM */
 EXPORT_SYMBOL_GPL(ata_id_string);
