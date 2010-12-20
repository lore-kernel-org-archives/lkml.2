Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754689Ab0LTI6J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 03:58:09 -0500
Received: from daytona.panasas.com ([67.152.220.89]:58034 "EHLO
	daytona.panasas.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754177Ab0LTI6I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 03:58:08 -0500
Message-ID: <4D0F1A99.8000703@panasas.com>
Date: Mon, 20 Dec 2010 10:58:01 +0200
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Fedora/3.0.10-1.fc12 Thunderbird/3.0.10
MIME-Version: 1.0
To: linux-iscsi-target-dev@googlegroups.com
CC: "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        James Bottomley <James.Bottomley@suse.de>,
        Jeff Garzik <jeff@garzik.org>, Christoph Hellwig <hch@lst.de>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        Hannes Reinecke <hare@suse.de>, Mike Christie <michaelc@cs.wisc.edu>,
        Mike Anderson <andmike@linux.vnet.ibm.com>, Tejun Heo <tj@kernel.org>,
        Vasu Dev <vasu.dev@linux.intel.com>,
        Tim Chen <tim.c.chen@linux.intel.com>, Andi Kleen <ak@linux.intel.com>,
        Ravi Anand <ravi.anand@qlogic.com>,
        Andrew Vasquez <andrew.vasquez@qlogic.com>,
        Joe Eykholt <jeykholt@cisco.com>, James Smart <james.smart@emulex.com>,
        Douglas Gilbert <dgilbert@interlog.com>,
        adam radford <aradford@gmail.com>,
        Kashyap Desai <Kashyap.Desai@lsi.com>,
        MPTFusionLinux <DL-MPTFusionLinux@lsi.com>
Subject: Re: [PATCH 03/12] libsas: Convert to host_lock less w/ interrupts
 disabled externally
References: <1292793727-31957-1-git-send-email-nab@linux-iscsi.org> <1292793727-31957-4-git-send-email-nab@linux-iscsi.org>
In-Reply-To: <1292793727-31957-4-git-send-email-nab@linux-iscsi.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 20 Dec 2010 08:58:06.0737 (UTC) FILETIME=[04A4D810:01CBA024]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/19/2010 11:21 PM, Nicholas A. Bellinger wrote:
> From: Nicholas Bellinger <nab@linux-iscsi.org>
> 
> This patch converts the libsas queuecommand to run in host_lock less mode
> w/ the new IRQ_DISABLE_SCSI_QCMD() that disables interrupts while calling
> ->queuecommand() dispatch.
> 
> Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
> ---
>  drivers/scsi/libsas/sas_scsi_host.c |   12 ++----------
>  1 files changed, 2 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/scsi/libsas/sas_scsi_host.c b/drivers/scsi/libsas/sas_scsi_host.c
> index 29251fa..011580f 100644
> --- a/drivers/scsi/libsas/sas_scsi_host.c
> +++ b/drivers/scsi/libsas/sas_scsi_host.c
> @@ -185,24 +185,17 @@ int sas_queue_up(struct sas_task *task)
>  /**
>   * sas_queuecommand -- Enqueue a command for processing
>   * @parameters: See SCSI Core documentation
> - *
> - * Note: XXX: Remove the host unlock/lock pair when SCSI Core can
> - * call us without holding an IRQ spinlock...
>   */
> -static int sas_queuecommand_lck(struct scsi_cmnd *cmd,
> +static int sas_queuecommand_irq_disable(struct scsi_cmnd *cmd,
>  		     void (*scsi_done)(struct scsi_cmnd *))
> -	__releases(host->host_lock)
>  	__acquires(dev->sata_dev.ap->lock)
>  	__releases(dev->sata_dev.ap->lock)
> -	__acquires(host->host_lock)
>  {
>  	int res = 0;
>  	struct domain_device *dev = cmd_to_domain_dev(cmd);
>  	struct Scsi_Host *host = cmd->device->host;
>  	struct sas_internal *i = to_sas_internal(host->transportt);
>  
> -	spin_unlock_irq(host->host_lock);
> -
>  	{
>  		struct sas_ha_struct *sas_ha = dev->port->ha;
>  		struct sas_task *task;
> @@ -250,11 +243,10 @@ static int sas_queuecommand_lck(struct scsi_cmnd *cmd,
>  		}
>  	}
>  out:
> -	spin_lock_irq(host->host_lock);
>  	return res;
>  }
>  
> -DEF_SCSI_QCMD(sas_queuecommand)
> +IRQ_DISABLE_SCSI_QCMD(sas_queuecommand)
>  

I hate this new macro. It is so simple by now. And anyway you are
doing them one by one and auditing the code. Please completely drop
this macro and open code it. There is no "safety" argument to this
ugliness, any more.

(Completely drop the [PATCH 02/12] scsi: Add IRQ_DISABLE_SCSI_QCMD wrapper
 patch and redo the users)

Thanks
Boaz


>  static void sas_eh_finish_cmd(struct scsi_cmnd *cmd)
>  {

