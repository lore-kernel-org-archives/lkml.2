Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751789Ab1BAXoz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 18:44:55 -0500
Received: from sabe.cs.wisc.edu ([128.105.6.20]:48792 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751307Ab1BAXoy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 18:44:54 -0500
Message-ID: <4D489B09.9010906@cs.wisc.edu>
Date: Tue, 01 Feb 2011 17:45:13 -0600
From: Mike Christie <michaelc@cs.wisc.edu>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Fedora/3.0.10-1.fc12 Thunderbird/3.0.10
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: linux-kernel@vger.kernel.org,
        Jayamohan Kallickal <jayamohank@serverengines.com>,
        Andrew Vasquez <andrew.vasquez@qlogic.com>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH 16/32] scsi/be2iscsi,qla2xxx: convert to alloc_workqueue()
References: <1294062595-30097-1-git-send-email-tj@kernel.org> <1294062595-30097-17-git-send-email-tj@kernel.org>
In-Reply-To: <1294062595-30097-17-git-send-email-tj@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/03/2011 07:49 AM, Tejun Heo wrote:
> diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
> index 75a85aa..4339196 100644
> --- a/drivers/scsi/be2iscsi/be_main.c
> +++ b/drivers/scsi/be2iscsi/be_main.c
> @@ -4276,7 +4276,7 @@ static int __devinit beiscsi_dev_probe(struct pci_dev *pcidev,
>
>   	snprintf(phba->wq_name, sizeof(phba->wq_name), "beiscsi_q_irq%u",
>   		 phba->shost->host_no);
> -	phba->wq = create_workqueue(phba->wq_name);
> +	phba->wq = alloc_workqueue(phba->wq_name, WQ_MEM_RECLAIM, 1);
>   	if (!phba->wq) {
>   		shost_printk(KERN_ERR, phba->shost, "beiscsi_dev_probe-"
>   				"Failed to allocate work queue\n");
> diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
> index 2c0876c..2cd0a77 100644
> --- a/drivers/scsi/qla2xxx/qla_os.c
> +++ b/drivers/scsi/qla2xxx/qla_os.c
> @@ -356,7 +356,7 @@ static int qla25xx_setup_mode(struct scsi_qla_host *vha)
>   				"Can't create request queue\n");
>   			goto fail;
>   		}
> -		ha->wq = create_workqueue("qla2xxx_wq");
> +		ha->wq = alloc_workqueue("qla2xxx_wq", WQ_MEM_RECLAIM, 1);
>   		vha->req = ha->req_q_map[req];
>   		options |= BIT_1;
>   		for (ques = 1; ques<  ha->max_rsp_queues; ques++) {

I think these are used in the main IO path, so would you also want 
WQ_HIGHPRI | WQ_CPU_INTENSIVE to be set? I think qla2xxx was using this 
in a path they expected to have high throughput/low latency, and from 
the interrupt handler they would try to queue the work on the same cpu 
the isr was answered on. With the new workqueue code could you possibly 
get queued onto a workqueue that is doing other work for other drivers?

Should qla2xxx be using the blkiopoll framework instead of a workqueue 
or will workqueues still provide the same performance when setting 
WQ_HIGHPRI | WQ_CPU_INTENSIVE?
