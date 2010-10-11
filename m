Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754562Ab0JKNVp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Oct 2010 09:21:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34509 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754312Ab0JKNVn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Oct 2010 09:21:43 -0400
Message-ID: <4CB30F27.9090009@redhat.com>
Date: Mon, 11 Oct 2010 15:20:39 +0200
From: Tomas Henzl <thenzl@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.12) Gecko/20100907 Fedora/3.0.7-1.fc12 Thunderbird/3.0.7
MIME-Version: 1.0
To: "Yang, Bo" <Bo.Yang@lsi.com>
CC: James Bottomley <James.Bottomley@suse.de>, bo yang <boyang1288@gmail.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "akpm@osdl.org" <akpm@osdl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: PATCH 1/5] scsi: megaraid_sas - Add Online Controller Reset to
 MegaRAID SAS drive
References: <AANLkTin53S+C_+QzF-drs5BUAx=k7YeiHrTaQGTFSc_a@mail.gmail.com>	 <4CAF3E04.1050304@redhat.com> <1286555954.2985.110.camel@mulgrave.site> <4CAF70CD.6020307@redhat.com> <4CB0D2AF.7080609@redhat.com> <4B6A08C587958942AA3002690DD4F8C30100F5506B@cosmail02.lsi.com>
In-Reply-To: <4B6A08C587958942AA3002690DD4F8C30100F5506B@cosmail02.lsi.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/11/2010 02:55 PM, Yang, Bo wrote:
> Tomas,
>
>   
>> Another correction - flush_scheduled_work is already present in megass_detach_one
>> it only should be moved away from the if statement.
>>     
> The flush_scheduled_work is for schedule_delayed_work().  We need to flush it and remove.
>   
I'm not saying it should be removed, I think a move outside from the 'if' block
makes it work for ev->hotplug_work and for the newly added instance->work_init


diff --git a/drivers/scsi/megaraid/megaraid_sas.c b/drivers/scsi/megaraid/megaraid_sas.c
index 55951f4..7773707 100644
--- a/drivers/scsi/megaraid/megaraid_sas.c
+++ b/drivers/scsi/megaraid/megaraid_sas.c
@@ -4088,9 +4088,9 @@ static void __devexit megasas_detach_one(struct pci_dev *pdev)
 		struct megasas_aen_event *ev = instance->ev;
 		cancel_delayed_work(
 			(struct delayed_work *)&ev->hotplug_work);
-		flush_scheduled_work();
-		instance->ev = NULL;
 	}
+	flush_scheduled_work();
+	instance->ev = NULL;
 
 	tasklet_kill(&instance->isr_tasklet);
 
--

> -----Original Message-----
> From: Tomas Henzl [mailto:thenzl@redhat.com] 
> Sent: Saturday, October 09, 2010 4:38 PM
> To: James Bottomley
> Cc: bo yang; linux-scsi@vger.kernel.org; akpm@osdl.org; linux-kernel@vger.kernel.org; Yang, Bo
> Subject: Re: PATCH 1/5] scsi: megaraid_sas - Add Online Controller Reset to MegaRAID SAS drive
>
> On 10/08/2010 09:28 PM, Tomas Henzl wrote:
>   
>> On 10/08/2010 06:39 PM, James Bottomley wrote:
>>   
>>     
>>> On Fri, 2010-10-08 at 17:51 +0200, Tomas Henzl wrote:
>>>   
>>>     
>>>       
>>>> On 09/23/2010 04:36 AM, bo yang wrote:
>>>>     
>>>>       
>>>>         
>>>>> This patch is too big.  I am using attachment to submit.  Please
>>>>> use attached file to apply.  Also let me know if it can't be accepted.
>>>>>
>>>>> To add the Online controller reset support, driver need to do:
>>>>> a). reset the controller chips -- Xscale and Gen2 which will change
>>>>> the function calls and add the reset function related to this two
>>>>> chips.
>>>>> b). during the reset, driver will store the pending cmds which not
>>>>> returned by FW to driver's pending queue.  Driver will re-issue those
>>>>> pending cmds again to FW after the OCR finished.
>>>>> c). In driver's timeout routine, driver will report to OS as reset.
>>>>> Also driver's queue routine will block the cmds until the OCR
>>>>> finished.
>>>>> d). in Driver's ISR routine, if driver get the FW state as state
>>>>> change, FW in Failure status and FW support online controller
>>>>> reset (OCR), driver will start to do the controller reset.
>>>>> e). In driver's IOCTL routine, the application cmds will wait for the
>>>>> OCR to finish, then issue the cmds to FW.
>>>>>
>>>>> Signed-off-by Bo Yang<bo.yang@lsi.com>
>>>>>
>>>>> ---
>>>>>  drivers/scsi/megaraid/megaraid_sas.c |  756 ++++++++++++++++++++++++++++++++---
>>>>>  drivers/scsi/megaraid/megaraid_sas.h |   88 +++-
>>>>>  2 files changed, 787 insertions(+), 57 deletions(-)
>>>>>       
>>>>>         
>>>>>           
>>>> Hi Bo,
>>>> in the workqueue function you sleep for 30s,
>>>> it's scheduled here - schedule_work(&instance->work_init);
>>>>
>>>> +process_fw_state_change_wq(struct work_struct *work)
>>>> +{
>>>> ...
>>>> +		/*waitting for about 20 second before start the second init*/
>>>> +		for (wait = 0; wait < 30; wait++) {
>>>> +			msleep(1000);
>>>> +		}
>>>>     
>>>>       
>>>>         
>>> this lot should be ssleep(20) if you want a 20 sec sleep.
>>>   
>>>     
>>>       
>> please do that on every place where you use the 
>> "for (wait = 0; wait < n; wait++) msleep(1000);" construction
>>
>>   
>>     
>>>> - this is not a good practice to sleep for a so long time I think
>>>>     
>>>>       
>>>>         
>> this long sleep might might be ok, if the workqueue is used only rarely
>> is it so?
>>
>>   
>>     
>>>> - you should use in your exit function some synchronization 
>>>>   for example 'cancel_work_sync', without that if someone rmmods your 
>>>>   module, it could then lead to a memory corruption
>>>>     
>>>>       
>>>>         
>>> Actually flush_scheduled_work() should be fine ... it will force the
>>> module removal to wait for completion ... cancellation can be error
>>> prone, so just forcing the wait sounds easier.
>>>   
>>>     
>>>       
> Another correction - flush_scheduled_work is already present in megass_detach_one
> it only should be moved away from the if statement.
>
>
>   
>> someone told that cancel_work_sync is safer then flush_scheduled_work
>> but I'm not an expert, so ok 
>>
>> Tomas
>>
>>   
>>     
>>> James
>>>
>>>
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>   
>>>     
>>>       
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>   
>>     
> N�����r��y���b�X��ǧv�^�)޺{.n�+����{���"�{ay�ʇڙ�,j��f���h���z��w������j:+v���w�j�m��������zZ+��ݢj"��!tml=

