Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752506Ab0EGMyh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 08:54:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64800 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752098Ab0EGMyf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 08:54:35 -0400
Message-ID: <4BE40D6B.5020501@redhat.com>
Date: Fri, 07 May 2010 14:54:03 +0200
From: Tomas Henzl <thenzl@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: "Yang, Bo" <Bo.Yang@lsi.com>
CC: "'James.Bottomley@HansenPartnership.com'" 
	<James.Bottomley@HansenPartnership.com>,
       "'James.Bottomley@suse.de'" <James.Bottomley@suse.de>,
       "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>,
       "'akpm@osdl.org'" <akpm@osdl.org>,
       "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
       "Daftardar, Jayant" <Jayant.Daftardar@lsi.com>
Subject: Re: [PATCH 3/7] scsi: megaraid_sas - Online COntroller Reset (OCR)
 PART-III
References: <4B6A08C587958942AA3002690DD4F8C35C5123FA@cosmail02.lsi.com> <4B6A08C587958942AA3002690DD4F8C35C6861A5@cosmail02.lsi.com> <3A916D859199814BBB666188F96EB165013979165E@cosmail02.lsi.com> <4B6A08C587958942AA3002690DD4F8C3CDB80B82@cosmail02.lsi.com> <4B6A08C587958942AA3002690DD4F8C3CDB80BE9@cosmail02.lsi.com>
In-Reply-To: <4B6A08C587958942AA3002690DD4F8C3CDB80BE9@cosmail02.lsi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/06/2010 05:52 PM, Yang, Bo wrote:
> This is third part of the Online Controller Reset. In ISR routine, if driver receive the FW state change interrupt
> And the online controller reset support enabled in FW, driver will read the controller register.  Driver will issue
> Controller reset if the FW register state failure.  Also driver will back up the pending cmds for the re-fire after
> the reset finished.
>
> Also Driver added the CTIO support to this patch.
>
> Signed-off-by Bo Yang<bo.yang@lsi.com>
>
> +static void
> +process_fw_state_change_wq(struct work_struct *work)
> +{
> +       struct megasas_instance *instance =
> +               container_of(work, struct megasas_instance, work_init);
> +       u32 wait;
> +       unsigned long flags;
> +
> +       if (instance->adprecovery != MEGASAS_ADPRESET_SM_INFAULT) {
> +               printk(KERN_NOTICE "megaraid_sas: error, recovery st %x \n",
> +                               instance->adprecovery);
> +               return ;
> +       }
> +
> +       if (instance->adprecovery == MEGASAS_ADPRESET_SM_INFAULT) {
> +               printk(KERN_NOTICE "megaraid_sas: FW detected to be in fault"
> +                                       "state, restarting it...\n");
> +
> +               instance->instancet->disable_intr(instance->reg_set);
> +               atomic_set(&instance->fw_outstanding, 0);
> +
> +               atomic_set(&instance->fw_reset_no_pci_access, 1);
> +               instance->instancet->adp_reset(instance, instance->reg_set);
> +               atomic_set(&instance->fw_reset_no_pci_access, 0 );
> +
> +               printk(KERN_NOTICE "megaraid_sas: FW restarted successfully,"
> +                                       "initiating next stage...\n");
> +
> +               printk(KERN_NOTICE "megaraid_sas: HBA recovery state machine,"
> +                                       "state 2 starting...\n");
> +
> +               /*waitting for about 20 second before start the second init*/
> +               for (wait = 0; wait < 30; wait++) {
> +                       msleep(1000);
> +               }
>   
Hi Bo,
I'm only curios - couldn't be the above loop replaced by ssleep(30); 
and have the u32 wait; removed?
+		ssleep(30); /* wait for about 30 second before second init */

I guess you wanted to have a space after the comma in the printk, if yes I think
you should do this -> printk(KERN_NOTICE "megaraid_sas: HBA recovery state machine, "

It might be a problem with my mail reader, but it seems to me that you are using 
spaces instead of tabs almost everywhere.

Tomas


