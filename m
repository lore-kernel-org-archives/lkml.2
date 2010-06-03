Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757454Ab0FCHoS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 03:44:18 -0400
Received: from smtprelay01.ispgateway.de ([80.67.31.24]:43581 "EHLO
	smtprelay01.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752148Ab0FCHoR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 03:44:17 -0400
Message-ID: <4C075D18.8010108@ladisch.de>
Date: Thu, 03 Jun 2010 09:43:20 +0200
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Robert Hancock <hancockrwd@gmail.com>
CC: Bert dd <bert.ddecker@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: Is there a way to change irq numbers of pcie cards ?
References: <AANLkTinfWMJ94pPxjRAx-vgvcqSwE9Hw3kHqEDLazhZ2@mail.gmail.com> <4C06E59E.40508@gmail.com>
In-Reply-To: <4C06E59E.40508@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Df-Sender: linux-kernel@cl.domainfactory-kunde.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Robert Hancock wrote:
> On 06/02/2010 06:08 AM, Bert dd wrote:
> > I have a supermicro machine with 2 raid cards (lsi 9260-8i and lsi 9260-8e) and
> > one nvidia GTX480 graphics card.
> > The problem is that all these pcie cards are assigned the same irq number,
> 
> If you can get MSI enabled for some of those cards, though, that should
> prevent them from sharing interrupts.

The PCIe spec says that all PCIe devices must support MSI interrupts.
(Whether they do in practice is another question ...)

Regardless of the graphics card, enabling MSI for the RAID cards will
prevent their interrupts from interfering with each other.
Bert, you might want to try this completely untested patch:


--- a/drivers/scsi/megaraid/megaraid_sas.c
+++ b/drivers/scsi/megaraid/megaraid_sas.c
@@ -3169,6 +3169,8 @@ megasas_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	if (megasas_init_mfi(instance))
 		goto fail_init_mfi;
 
+	pci_enable_msi(pdev);
+
 	/*
 	 * Register IRQ
 	 */
@@ -3218,6 +3220,7 @@ megasas_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	pci_set_drvdata(pdev, NULL);
 	instance->instancet->disable_intr(instance->reg_set);
 	free_irq(instance->pdev->irq, instance);
+	pci_disable_msi(pdev);
 
 	megasas_release_mfi(instance);
 
@@ -3354,6 +3357,7 @@ megasas_suspend(struct pci_dev *pdev, pm_message_t state)
 	pci_set_drvdata(instance->pdev, instance);
 	instance->instancet->disable_intr(instance->reg_set);
 	free_irq(instance->pdev->irq, instance);
+	pci_disable_msi(pdev);
 
 	pci_save_state(pdev);
 	pci_disable_device(pdev);
@@ -3416,6 +3420,8 @@ megasas_resume(struct pci_dev *pdev)
 	tasklet_init(&instance->isr_tasklet, megasas_complete_cmd_dpc,
 			(unsigned long)instance);
 
+	pci_enable_msi(pdev);
+
 	/*
 	 * Register IRQ
 	 */
@@ -3519,6 +3525,7 @@ static void __devexit megasas_detach_one(struct pci_dev *pdev)
 	instance->instancet->disable_intr(instance->reg_set);
 
 	free_irq(instance->pdev->irq, instance);
+	pci_disable_msi(pdev);
 
 	megasas_release_mfi(instance);
 
