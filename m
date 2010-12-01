Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754733Ab0LAPyr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 10:54:47 -0500
Received: from na3sys009aog111.obsmtp.com ([74.125.149.205]:48099 "EHLO
	na3sys009aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754600Ab0LAPyp convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 10:54:45 -0500
From: "Yang, Bo" <Bo.Yang@lsi.com>
To: Tomas Henzl <thenzl@redhat.com>
CC: "'James.Bottomley@HansenPartnership.com'" 
	<James.Bottomley@HansenPartnership.com>,
        "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>,
        "'akpm@osdl.org'" <akpm@osdl.org>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>
Date: Wed, 1 Dec 2010 08:55:00 -0700
Subject: RE: [PATCH 7/9] scsi: megaraid_sas - Driver created the self work
 queue for OCR
Thread-Topic: [PATCH 7/9] scsi: megaraid_sas - Driver created the self work
 queue for OCR
Thread-Index: AcuRUggqvhAwAqjtQX2Wom89NZ6W0QAHCBzA
Message-ID: <4B6A08C587958942AA3002690DD4F8C30106BC0277@cosmail02.lsi.com>
References: <4B6A08C587958942AA3002690DD4F8C3D0804533@cosmail02.lsi.com>
 <4B6A08C587958942AA3002690DD4F8C3DBD67F68@cosmail02.lsi.com>
 <4B6A08C587958942AA3002690DD4F8C30106A961BD@cosmail02.lsi.com>
 <4B6A08C587958942AA3002690DD4F8C30106A961D6@cosmail02.lsi.com>
 <4B6A08C587958942AA3002690DD4F8C30106A961E4@cosmail02.lsi.com>
 <4B6A08C587958942AA3002690DD4F8C30106A961F2@cosmail02.lsi.com>
 <4B6A08C587958942AA3002690DD4F8C30106A96213@cosmail02.lsi.com>
 <4B6A08C587958942AA3002690DD4F8C30106A96218@cosmail02.lsi.com>
 <4B6A08C587958942AA3002690DD4F8C30106A9621E@cosmail02.lsi.com>
 <4CF5221E.8080603@redhat.com>
 <4B6A08C587958942AA3002690DD4F8C30106BBFEB5@cosmail02.lsi.com>
 <4CF63D45.8020608@redhat.com>
In-Reply-To: <4CF63D45.8020608@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tomas,

The megasas_ocr_wq only used by online controller reset.  Driver can either do return error or continue load by disabling the Online controller reset bit.  I will discuss internally and post back today for the changes.

Regards,

Bo Yang   

-----Original Message-----
From: Tomas Henzl [mailto:thenzl@redhat.com] 
Sent: Wednesday, December 01, 2010 7:19 AM
To: Yang, Bo
Cc: 'James.Bottomley@HansenPartnership.com'; 'linux-scsi@vger.kernel.org'; 'akpm@osdl.org'; 'linux-kernel@vger.kernel.org'
Subject: Re: [PATCH 7/9] scsi: megaraid_sas - Driver created the self work queue for OCR

On 11/30/2010 07:05 PM, Yang, Bo wrote:
> Tomas,
>
> In which case megasas_ocr_wq will hit NULL if create_workqueue create work queue success? If create_workqueue failed, OCR may have the problem.  But do you know if create_workqueue has the number limitation for creating work queues (how many work queue can it created? 10 or 20)?
>   
+	megasas_ocr_wq = create_workqueue("megasas_ocr");
+
+	if ( !megasas_ocr_wq )
+		printk(KERN_DEBUG "megasas: Failed to create workqueue.\n");

Then why do you check the return value if it can not fail?

You are allocating a lot of resources in the init function and when some of them is not 
available (which is unlikely) you return with an error value. Why don't you want that for 
create_workqueue too?

Is it safe enter the suspend mode with the workqueue still doing some job?
Shouldn't be the workqueue flushed in the suspend function?
 

> Thanks,
>
> Bo Yang
>
> -----Original Message-----
> From: Tomas Henzl [mailto:thenzl@redhat.com]
> Sent: Tuesday, November 30, 2010 11:11 AM 
> To: Yang, Bo
> Cc: 'James.Bottomley@HansenPartnership.com'; 'linux-scsi@vger.kernel.org'; 'akpm@osdl.org'; 'linux-kernel@vger.kernel.org'
> Subject: Re: [PATCH 7/9] scsi: megaraid_sas - Driver created the self work queue for OCR
>
> On 11/19/2010 06:37 PM, Yang, Bo wrote:
>   
>> Driver created the owner work queue (don't use global work queue). This queue will be used for online controller reset routine.
>>
>> Signed-off-by Bo Yang<bo.yang@lsi.com>
>>
>> ---
>> drivers/scsi/megaraid/megaraid_sas.c |   13 ++++++++++++-
>>  1 file changed, 12 insertions(+), 1 deletion(-)
>>   
>> diff -rupN old/drivers/scsi/megaraid/megaraid_sas.c
>> new/drivers/scsi/megaraid/megaraid_sas.c ---
>> old/drivers/scsi/megaraid/megaraid_sas.c 2010-11-17 13:46:11.000000000
>> -0500 +++ new/drivers/scsi/megaraid/megaraid_sas.c 2010-11-17
>> 13:47:46.000000000 -0500 @@ -108,6 +108,7 @@ static struct
>> megasas_mgmt_info megasas_ static struct fasync_struct
>> *megasas_async_queue; static DEFINE_MUTEX(megasas_async_queue_mutex);
>> +static struct workqueue_struct *megasas_ocr_wq; static int
>> megasas_poll_wait_aen; static
>> DECLARE_WAIT_QUEUE_HEAD(megasas_poll_wait); static u32
>> support_poll_for_event; @@ -2435,7 +2436,7 @@
>> megasas_deplete_reply_queue(struct megas printk(KERN_NOTICE "megasas:
>> fwState=%x, stage:%d\n", fw_state, instance->adprecovery); -
>> schedule_work(&instance->work_init); + queue_work(megasas_ocr_wq,
>> &instance->work_init); return IRQ_HANDLED; } else { @@ -5157,6
>> +5158,11 @@ static int __init megasas_init(void) goto err_pcidrv; } +
>> megasas_ocr_wq = create_workqueue("megasas_ocr"); + + if (
>> !megasas_ocr_wq ) + printk(KERN_DEBUG "megasas: Failed to create
>> workqueue.\n"); + 
>>     
> What happens later, when you pass the null pointer to the queue_work ?
> I'm not sure this will work.
>
>   
>> rval = driver_create_file(&megasas_pci_driver.driver,
>> &driver_attr_version); if (rval) @@ -5228,6 +5234,11 @@ static void
>> __exit megasas_exit(void) &driver_attr_release_date);
>> driver_remove_file(&megasas_pci_driver.driver, &driver_attr_version);
>> + if (megasas_ocr_wq) { + destroy_workqueue(megasas_ocr_wq); +
>> megasas_ocr_wq = NULL; + } +
>> pci_unregister_driver(&megasas_pci_driver);
>> unregister_chrdev(megasas_mgmt_majorno, "megaraid_sas_ioctl"); } 
>>     
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>   

