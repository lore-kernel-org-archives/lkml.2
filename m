Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752688Ab1LVS1f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 13:27:35 -0500
Received: from mx2.parallels.com ([64.131.90.16]:41152 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751834Ab1LVS1c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 13:27:32 -0500
From: James Bottomley <jbottomley@parallels.com>
To: Shaohua Li <shaohua.li@intel.com>
CC: lkml <linux-kernel@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@infradead.org>,
        "Ted Ts'o" <tytso@mit.edu>, "Wu, Fengguang" <fengguang.wu@intel.com>,
        "Darrick J. Wong" <djwong@us.ibm.com>
Subject: Re: [patch 1/2]scsi: scsi_run_queue() doesn't use local list to
 handle starved sdev
Thread-Topic: [patch 1/2]scsi: scsi_run_queue() doesn't use local list to
 handle starved sdev
Thread-Index: AQHMwFVgrIFdI6v1kk+WfPK7u9Q6qJXotCqA
Date: Thu, 22 Dec 2011 18:27:29 +0000
Message-ID: <1324578449.9709.15.camel@dabdike.int.hansenpartnership.com>
References: <1324523412.22361.471.camel@sli10-conroe>
In-Reply-To: <1324523412.22361.471.camel@sli10-conroe>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [76.243.235.53]
Content-Type: text/plain; charset="utf-8"
Content-ID: <A0BA817D123EB342B2D8E39A84CB3146@sw.swsoft.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id pBMIRjEs021531

On Thu, 2011-12-22 at 11:10 +0800, Shaohua Li wrote:
> scsi_run_queue() picks off all sdev from host starved_list to a local list,
> then handle them. If there are multiple threads running scsi_run_queue(),
> the starved_list will get messed. This is quite common, because request
> rq_affinity is on by default.
> 
> Signed-off-by: Shaohua Li <shaohua.li@intel.com>
> ---
>  drivers/scsi/scsi_lib.c |   21 ++++++++++++++-------
>  1 file changed, 14 insertions(+), 7 deletions(-)
> 
> Index: linux/drivers/scsi/scsi_lib.c
> ===================================================================
> --- linux.orig/drivers/scsi/scsi_lib.c	2011-12-21 16:56:23.000000000 +0800
> +++ linux/drivers/scsi/scsi_lib.c	2011-12-22 09:33:09.000000000 +0800
> @@ -401,9 +401,8 @@ static inline int scsi_host_is_busy(stru
>   */
>  static void scsi_run_queue(struct request_queue *q)
>  {
> -	struct scsi_device *sdev = q->queuedata;
> +	struct scsi_device *sdev = q->queuedata, *head_sdev = NULL;
>  	struct Scsi_Host *shost;
> -	LIST_HEAD(starved_list);
>  	unsigned long flags;
>  
>  	/* if the device is dead, sdev will be NULL, so no queue to run */
> @@ -415,9 +414,8 @@ static void scsi_run_queue(struct reques
>  		scsi_single_lun_run(sdev);
>  
>  	spin_lock_irqsave(shost->host_lock, flags);
> -	list_splice_init(&shost->starved_list, &starved_list);
>  
> -	while (!list_empty(&starved_list)) {
> +	while (!list_empty(&shost->starved_list)) {

The original reason for working from a copy instead of the original list
was that the device can end up back on the starved list because of a
variety of conditions in the HBA and so this would cause the loop not to
exit, so this piece of the patch doesn't look right to me.

James

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
