Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756443Ab0G1Vv6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 17:51:58 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:40575 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753493Ab0G1Vvz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 17:51:55 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Tejun Heo <tj@kernel.org>
Subject: [PATCH] SATA / AHCI: Do not play with the link PM during suspend to RAM (was: Re: HDD not suspending properly / dead on resume)
Date: Wed, 28 Jul 2010 23:50:09 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.35-rc6-rjw+; KDE/4.4.4; x86_64; ; )
Cc: Stephan Diestelhorst <stephan.diestelhorst@gmail.com>,
        linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-pm@lists.osdl.org, stephan.diestelhorst@amd.com
References: <201007091750.05020.stephan.diestelhorst@amd.com> <201007100850.36889.stephan.diestelhorst@gmail.com> <4C384580.2080507@kernel.org>
In-Reply-To: <4C384580.2080507@kernel.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201007282350.09676.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, July 10, 2010, Tejun Heo wrote:
> On 07/10/2010 08:50 AM, Stephan Diestelhorst wrote:
> >> I have a box where this problem is kind of reproducible, but it happens _very_
> >> rarely.  Also I can't reproduce it on demand running suspend-resume in a tight
> >> loop.  Are you able to reproduce it more regurarly?
> > 
> > For me it is much more reproducible. If I run multiple direct writing
> > dd-s to the disk in question I trigger it rather reliably (~75% or
> > higher). See the attached script from an earlier email.
> > Maybe that helps triggering your case more reliabl, too?
> 
> Can you please try the following git tree?
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git libata-irq-expect

That didn't help, but the appended patch fixes the problem for me.

Thanks,
Rafael

---
From: Rafael J. Wysocki <rjw@sisk.pl>
Subject: SATA / AHCI: Do not play with the link PM during suspend to RAM

My Acer Ferrari One occasionally loses communication with the disk
(which in fact is an Intel SSD) during suspend to RAM.  The symptom
is that the IDENTIFY command times out during suspend and the device
is dropped by the kernel, so it is not available during resume and
the system is unuseable as a result.  The failure is not readily
reproducible, although it happens once every several suspends and
it always happens after the disk has been shut down by the SCSI
layer's suspend routine.

I was able to track this issue down to the link PM manipulations
carried out by ata_host_suspend(), which probably means that the
SSD's firmware is not implemented correctly.  However, the AHCI
driver, which is used on the affected box, doesn't really need to do
anything with the link PM during suspend to RAM, because the whole
controller is going to be put into D3 by ata_pci_device_do_suspend()
immediately and it will undergo full reset during the subsequent
resume anyway.  For this reason, make the AHCI driver avoid calling
ata_host_suspend() during suspend to RAM which fixes the problem and
makes sense as a general optimization.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/ata/ahci.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

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
+		pdev->dev.power.power_state = mesg;
+	else
+		rc = ata_host_suspend(host, mesg);
+
+	if (!rc)
+		ata_pci_device_do_suspend(pdev, mesg);
+
+	return rc;
 }
 
 static int ahci_pci_device_resume(struct pci_dev *pdev)
