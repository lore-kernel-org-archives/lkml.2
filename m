Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757933Ab1EMIF2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 04:05:28 -0400
Received: from smtprelay04.ispgateway.de ([80.67.31.38]:48618 "EHLO
	smtprelay04.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757804Ab1EMIFY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 04:05:24 -0400
Message-ID: <4DCCE6BF.8030109@ladisch.de>
Date: Fri, 13 May 2011 10:07:27 +0200
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Simon Richter <Simon.Richter@hogyros.de>
CC: Nick Cheng <nick.cheng@areca.com.tw>, linux-kernel@vger.kernel.org
Subject: Re: PCI devices sharing IRQs
References: <20110512081756.GB2206@salmiakki.hogyros.de>
In-Reply-To: <20110512081756.GB2206@salmiakki.hogyros.de>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Df-Sender: linux-kernel@cl.domainfactory-kunde.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Simon Richter wrote:
> most of the PCI slots appear to map to the same IRQ, and I'm wondering
> if anything can be done about this.

The routing of PCI interrupts cannot be changed on any modern system.

PCI-Express devices are required to support message-signaled interrupts
(MSIs), which do not require separate hardware interrupt lines and are
never shared.  So throw away those cheap Intel chips and use the good
Realtek one instead.  ;-)

As for the RAID card, the arcmsr driver does not enable MSI.
I don't know if this an oversight in the driver or a hardware bug.
Please try the patch below.

(Nick, it looks as if there is an error path that doesn't free the
requested interrupt.)

> If there is anything I could try to change in order to give each card
> its own IRQ (especially pulling the RAID card and the Ethernet
> controller apart could possibly be worth something,

If these devices are on cards, you could try changing slots.

> as would handling IRQs on more than one core)

My AMD CPU automatically routes interrupts to an idle core ...


Regards,
Clemens

--8<---------------------------------------------------------------->8--
[SCSI] arcmsr: add MSI support

Try to enable MSI for Areca host adapters.  It might actually work.

Signed-off-by: Clemens Ladisch <clemens@ladisch.de>

--- a/drivers/scsi/arcmsr/arcmsr_hba.c
+++ b/drivers/scsi/arcmsr/arcmsr_hba.c
@@ -692,7 +692,10 @@ static int arcmsr_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	if(error){
 		goto RAID_controller_stop;
 	}
+	pci_enable_msi(pdev);
-	error = request_irq(pdev->irq, arcmsr_do_interrupt, IRQF_SHARED, "arcmsr", acb);
+	error = request_irq(pdev->irq, arcmsr_do_interrupt,
+			    pci_dev_msi_enabled(pdev) ? 0 : IRQF_SHARED,
+			    "arcmsr", acb);
 	if(error){
 		goto scsi_host_remove;
 	}
@@ -711,7 +714,9 @@ static int arcmsr_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		goto out_free_sysfs;
 	return 0;
 out_free_sysfs:
+	/* FIXME: free_irq */
 scsi_host_remove:
+	pci_disable_msi(pdev);
 	scsi_remove_host(host);
 RAID_controller_stop:
 	arcmsr_stop_adapter_bgrb(acb);
@@ -1050,6 +1055,7 @@ static void arcmsr_remove(struct pci_dev *pdev)
 		}
 	}
 	free_irq(pdev->irq, acb);
+	pci_disable_msi(pdev);
 	arcmsr_free_ccb_pool(acb);
 	arcmsr_free_hbb_mu(acb);
 	arcmsr_unmap_pciregion(acb);
