Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752195Ab0FHA2l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jun 2010 20:28:41 -0400
Received: from smtp110.sbc.mail.gq1.yahoo.com ([67.195.14.95]:30195 "HELO
	smtp110.sbc.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751400Ab0FHA2k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jun 2010 20:28:40 -0400
X-Yahoo-SMTP: fzDSGlOswBCWnIOrNw7KwwK1j9PqyNbe5PtLKiS4dDU.UNl_t6bdEZu9tTLW
X-YMail-OSG: f.if4wIVM1msaje604uX2YYMWfnGHITJcVcjUbohFLWct9Ffr3lyZBgPzW0CKPXDDarHp8_0eK8ehVyT2ClQx8c6OXeRdWs_dart7AR893he46F0lHKsvm_CuET_hNWZ.D1aaZy8uZyOt3xL9sCFzTDk3kWIXD7SqQec0NIHffiukJhmBhsvIvld8KkIjiyZV0sdcdihZ7sN8.cHh.iLJZIDm5ZAQrp.RXzRYkDboM6I0g9sjHLZyn1pPeMExcHAb388DlA22jUrVC.IlT85FUP3G0roUcALrwkhagxqDOamyVHor8JFpkyrWdh1xzGJpBqleIv8Y5YOM349NHPcCt7I
X-Yahoo-Newman-Property: ymail-3
Subject: RE: [PATCH] megaraid_sas: enable message-signaled interrupts
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: "Yang, Bo" <Bo.Yang@lsi.com>
Cc: Clemens Ladisch <clemens@ladisch.de>,
       DL-MegaRAID Linux <megaraidlinux@lsi.com>,
       "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Hannes Reinecke <hare@suse.de>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <4B6A08C587958942AA3002690DD4F8C3D0803AAB@cosmail02.lsi.com>
References: <4C0CA170.70003@ladisch.de>
	 <4B6A08C587958942AA3002690DD4F8C3D0803AAB@cosmail02.lsi.com>
Content-Type: text/plain
Date: Mon, 07 Jun 2010 17:28:34 -0700
Message-Id: <1275956914.6498.11.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-06-07 at 15:37 -0600, Yang, Bo wrote:
> NACK.  The MSI will be turn on until driver fully support it.
> 
> 

Hi Bo,

Do you have an idea of when this will be supported in the upstream
megaraid_sas driver..?  I am asking because I would like to eventually
add MSI support into the QEMU-KVM Megaraid 8708EM2 HBA emulation that
Hannes has been working on.

Best,

--nab

> -----Original Message-----
> From: Clemens Ladisch [mailto:clemens@ladisch.de] 
> Sent: Monday, June 07, 2010 3:36 AM
> To: DL-MegaRAID Linux
> Cc: linux-scsi@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: [PATCH] megaraid_sas: enable message-signaled interrupts
> 
> To avoid sharing interrupts, enable message-signaled interrupts, if
> possible.
> 
> Tested with LSI 9260-8i/8e, where sharing the interrupt with the nvidia
> driver would reduce the RAID performance.
> 
> Signed-off-by: Clemens Ladisch <clemens@ladisch.de>
> Tested-by: Bert dd <bert.ddecker@gmail.com>
> ---
>  drivers/scsi/megaraid/megaraid_sas.c |   17 +++++++++++++++--
>  1 file changed, 15 insertions(+), 2 deletions(-)
> 
> --- a/drivers/scsi/megaraid/megaraid_sas.c
> +++ b/drivers/scsi/megaraid/megaraid_sas.c
> @@ -3169,10 +3169,14 @@ megasas_probe_one(struct pci_dev *pdev,
>  	if (megasas_init_mfi(instance))
>  		goto fail_init_mfi;
>  
> +	pci_enable_msi(pdev);
> +
>  	/*
>  	 * Register IRQ
>  	 */
> -	if (request_irq(pdev->irq, megasas_isr, IRQF_SHARED, "megasas", instance)) {
> +	if (request_irq(pdev->irq, megasas_isr,
> +		pci_dev_msi_enabled(pdev) ? 0 : IRQF_SHARED,
> +		"megasas", instance)) {
>  		printk(KERN_DEBUG "megasas: Failed to register IRQ\n");
>  		goto fail_irq;
>  	}
> @@ -3222,6 +3226,8 @@ megasas_probe_one(struct pci_dev *pdev,
>  	megasas_release_mfi(instance);
>  
>        fail_irq:
> +	pci_disable_msi(pdev);
> +
>        fail_init_mfi:
>        fail_alloc_dma_buf:
>  	if (instance->evt_detail)
> @@ -3354,6 +3360,7 @@ megasas_suspend(struct pci_dev *pdev, pm
>  	pci_set_drvdata(instance->pdev, instance);
>  	instance->instancet->disable_intr(instance->reg_set);
>  	free_irq(instance->pdev->irq, instance);
> +	pci_disable_msi(pdev);
>  
>  	pci_save_state(pdev);
>  	pci_disable_device(pdev);
> @@ -3416,10 +3423,13 @@ megasas_resume(struct pci_dev *pdev)
>  	tasklet_init(&instance->isr_tasklet, megasas_complete_cmd_dpc,
>  			(unsigned long)instance);
>  
> +	pci_enable_msi(pdev);
> +
>  	/*
>  	 * Register IRQ
>  	 */
> -	if (request_irq(pdev->irq, megasas_isr, IRQF_SHARED,
> +	if (request_irq(pdev->irq, megasas_isr,
> +		pci_dev_msi_enabled(pdev) ? 0 : IRQF_SHARED,
>  		"megasas", instance)) {
>  		printk(KERN_ERR "megasas: Failed to register IRQ\n");
>  		goto fail_irq;
> @@ -3443,6 +3453,8 @@ megasas_resume(struct pci_dev *pdev)
>  	return 0;
>  
>  fail_irq:
> +	pci_disable_msi(pdev);
> +
>  fail_init_mfi:
>  	if (instance->evt_detail)
>  		pci_free_consistent(pdev, sizeof(struct megasas_evt_detail),
> @@ -3519,6 +3531,7 @@ static void __devexit megasas_detach_one
>  	instance->instancet->disable_intr(instance->reg_set);
>  
>  	free_irq(instance->pdev->irq, instance);
> +	pci_disable_msi(pdev);
>  
>  	megasas_release_mfi(instance);
>  
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

