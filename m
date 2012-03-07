Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932393Ab2CGRYW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 12:24:22 -0500
Received: from mail-pz0-f42.google.com ([209.85.210.42]:32979 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754220Ab2CGRYS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 12:24:18 -0500
MIME-Version: 1.0
In-Reply-To: <2E1367F2-077A-4654-8932-4FDAEE56240B@xyratex.com>
References: <4f4a4580.aa3a440a.34c7.2776@mx.google.com>
	<4AB8AEEB15F74D15A87019F5663EA805@usish.com.cn>
	<D65B94D9-B33A-436F-9BCE-A500B35652D2@xyratex.com>
	<00F74E64-A5EC-4DF8-A347-2D8BC5659638@xyratex.com>
	<4F5785A9.2040707@bfs.de>
	<2E1367F2-077A-4654-8932-4FDAEE56240B@xyratex.com>
Date: Wed, 7 Mar 2012 22:54:17 +0530
Message-ID: <CAOD=uF67VkUnqYQQpgP=+0ndw-x+c1uWqN3-JUAVN24bgV2c=w@mail.gmail.com>
Subject: Re: [PATCH] [SCSI] pm8001: fix endian issue with code optimization.
From: santosh prasad nayak <santoshprasadnayak@gmail.com>
To: Mark Salyzyn <mark_salyzyn@xyratex.com>
Cc: wharms@bfs.de, lindar_liu <lindar_liu@usish.com>,
        James Bottomley <JBottomley@parallels.com>,
        linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org, Jack Wang <jack_wang@usish.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Following the are the changes as suggested by you. Please let me know
if anymore changes are required
so that I can send a formal patch for it.  The below patch is just for
review not a formal one.


diff --git a/drivers/scsi/pm8001/pm8001_hwi.c b/drivers/scsi/pm8001/pm8001_hwi.c
index 597593b..3976fab 100644
--- a/drivers/scsi/pm8001/pm8001_hwi.c
+++ b/drivers/scsi/pm8001/pm8001_hwi.c
@@ -3150,7 +3150,7 @@ mpi_fw_flash_update_resp(struct pm8001_hba_info
*pm8001_ha, void *piomb)
        struct fw_control_ex    fw_control_context;
        struct fw_flash_Update_resp *ppayload =
                (struct fw_flash_Update_resp *)(piomb + 4);
-       u32 tag = ppayload->tag;
+       u32 tag = le32_to_cpu(ppayload->tag);
        struct pm8001_ccb_info *ccb = &pm8001_ha->ccb_info[tag];
        status = le32_to_cpu(ppayload->status);
        memcpy(&fw_control_context,
@@ -3496,8 +3496,8 @@ static int mpi_hw_event(struct pm8001_hba_info
*pm8001_ha, void* piomb)
  */
 static void process_one_iomb(struct pm8001_hba_info *pm8001_ha, void *piomb)
 {
-       u32 pHeader = (u32)*(u32 *)piomb;
-       u8 opc = (u8)(pHeader & 0xFFF);
+       __le32 pHeader = (__le32)*(__le32 *)piomb;
+       u8 opc = (u8)((le32_to_cpu(pHeader)) & 0xFFF);

        PM8001_MSG_DBG(pm8001_ha, pm8001_printk("process_one_iomb:"));

diff --git a/drivers/scsi/pm8001/pm8001_hwi.h b/drivers/scsi/pm8001/pm8001_hwi.h
index 1a4611e..d437309 100644
--- a/drivers/scsi/pm8001/pm8001_hwi.h
+++ b/drivers/scsi/pm8001/pm8001_hwi.h
@@ -599,7 +599,7 @@ struct fw_flash_Update_req {
  *
  */
 struct fw_flash_Update_resp {
-       dma_addr_t      tag;
+       __le32  tag;
        __le32  status;
        u32     reserved[13];
 } __attribute__((packed, aligned(4)));





Regards
Santosh


On Wed, Mar 7, 2012 at 9:40 PM, Mark Salyzyn <mark_salyzyn@xyratex.com> wrote:
> Speaking for the Author in the name of expediency, although I have little knowledge of his actions and history ;-)
>
> void * piomb is used to permit pointer math and abstraction from the multitude of response frames. Making it an __u32* would result in side-effects regarding the pointer math code-paths as well. To be pedantic, an union of all the response frame types would provide the abstraction and type checking to work, but the author obviously considered that burdensome, and I would agree.
>
> The opc field is actually 12 bits in length. The 0xFFF respects that. To be pedantic u16 should have been utilized. However, this driver only uses OPCs from 0x001 to 0x029, so the author obviously decided to optimize the code by using an u8 for the moment (loop up OPC_OUB_* in pm8001_hwi.h for list of OPC field entries). One would hope if a higher-order opcode is utilized and or reported from the controller in the future, we would upgrade to an u16 for this ...
>
> Sincerely -- Mark Salyzyn
>
> On Mar 7, 2012, at 10:58 AM, walter harms wrote:
>
>>
>>
>> Am 07.03.2012 16:11, schrieb Mark Salyzyn:
>>> One more NAK:
>>>
>>>> @@ -3497,7 +3499,7 @@ static int mpi_hw_event(struct pm8001_hba_info *pm8001_ha, void* piomb)
>>>> static void process_one_iomb(struct pm8001_hba_info *pm8001_ha, void *piomb)
>>>> {
>>>>     u32 pHeader = (u32)*(u32 *)piomb;
>>>> -   u8 opc = (u8)((le32_to_cpu(pHeader)) & 0xFFF);
>>>> +   u8 opc = (u8)(pHeader & 0xFFF);
>>>>
>>>>     PM8001_MSG_DBG(pm8001_ha, pm8001_printk("process_one_iomb:"));
>>>
>>> The swap is necessary. Should be:
>>>
>>>      __le32 pHeader = (__le32)*(__le32 *)piomb;
>>>
>>> instead ...
>>>
>>
>> hi,
>>
>> would it help to make piomb __le32 instead of void ?
>>
>> Also i do not understand what want to gain from 0xFFF
>> Doing (u8) is effectively doing & 0xFF.
>>
>> re,
>> wh
>>
>>
>>
>
> ______________________________________________________________________
> This email may contain privileged or confidential information, which should only be used for the purpose for which it was sent by Xyratex. No further rights or licenses are granted to use such information. If you are not the intended recipient of this message, please notify the sender by return and delete it. You may not use, copy, disclose or rely on the information contained in it.
>
> Internet email is susceptible to data corruption, interception and unauthorised amendment for which Xyratex does not accept liability. While we have taken reasonable precautions to ensure that this email is free of viruses, Xyratex does not accept liability for the presence of any computer viruses in this email, nor for any losses caused as a result of viruses.
>
> Xyratex Technology Limited (03134912), Registered in England & Wales, Registered Office, Langstone Road, Havant, Hampshire, PO9 1SA.
>
> The Xyratex group of companies also includes, Xyratex Ltd, registered in Bermuda, Xyratex International Inc, registered in California, Xyratex (Malaysia) Sdn Bhd registered in Malaysia, Xyratex Technology (Wuxi) Co Ltd registered in The People's Republic of China and Xyratex Japan Limited registered in Japan.
> ______________________________________________________________________
>
>
