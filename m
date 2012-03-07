Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759487Ab2CGQKW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 11:10:22 -0500
Received: from xyratex195.xyratex.com ([194.131.166.195]:47798 "EHLO
	XY01EX21.xy01.xyratex.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757212Ab2CGQKV convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 11:10:21 -0500
Subject: Re: [PATCH] [SCSI] pm8001: fix endian issue with code optimization.
Mime-Version: 1.0 (Apple Message framework v1257)
Content-Type: text/plain; charset=US-ASCII
From: Mark Salyzyn <mark_salyzyn@xyratex.com>
In-Reply-To: <4F5785A9.2040707@bfs.de>
Date: Wed, 7 Mar 2012 11:10:14 -0500
Cc: Mark Salyzyn <mark_salyzyn@xyratex.com>, santoshprasadnayak@gmail.com,
        lindar_liu <lindar_liu@usish.com>,
        James Bottomley <JBottomley@parallels.com>,
        linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org, Jack Wang <jack_wang@usish.com>
Content-Transfer-Encoding: 7BIT
Message-Id: <2E1367F2-077A-4654-8932-4FDAEE56240B@xyratex.com>
References: <4f4a4580.aa3a440a.34c7.2776@mx.google.com> <4AB8AEEB15F74D15A87019F5663EA805@usish.com.cn> <D65B94D9-B33A-436F-9BCE-A500B35652D2@xyratex.com> <00F74E64-A5EC-4DF8-A347-2D8BC5659638@xyratex.com> <4F5785A9.2040707@bfs.de>
To: wharms@bfs.de
X-Mailer: Apple Mail (2.1257)
X-OriginalArrivalTime: 07 Mar 2012 16:10:17.0222 (UTC) FILETIME=[C96A1A60:01CCFC7C]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Speaking for the Author in the name of expediency, although I have little knowledge of his actions and history ;-)

void * piomb is used to permit pointer math and abstraction from the multitude of response frames. Making it an __u32* would result in side-effects regarding the pointer math code-paths as well. To be pedantic, an union of all the response frame types would provide the abstraction and type checking to work, but the author obviously considered that burdensome, and I would agree.

The opc field is actually 12 bits in length. The 0xFFF respects that. To be pedantic u16 should have been utilized. However, this driver only uses OPCs from 0x001 to 0x029, so the author obviously decided to optimize the code by using an u8 for the moment (loop up OPC_OUB_* in pm8001_hwi.h for list of OPC field entries). One would hope if a higher-order opcode is utilized and or reported from the controller in the future, we would upgrade to an u16 for this ...

Sincerely -- Mark Salyzyn

On Mar 7, 2012, at 10:58 AM, walter harms wrote:

> 
> 
> Am 07.03.2012 16:11, schrieb Mark Salyzyn:
>> One more NAK:
>> 
>>> @@ -3497,7 +3499,7 @@ static int mpi_hw_event(struct pm8001_hba_info *pm8001_ha, void* piomb)
>>> static void process_one_iomb(struct pm8001_hba_info *pm8001_ha, void *piomb)
>>> {
>>> 	u32 pHeader = (u32)*(u32 *)piomb;
>>> -	u8 opc = (u8)((le32_to_cpu(pHeader)) & 0xFFF);
>>> +	u8 opc = (u8)(pHeader & 0xFFF);
>>> 
>>> 	PM8001_MSG_DBG(pm8001_ha, pm8001_printk("process_one_iomb:"));
>> 
>> The swap is necessary. Should be:
>> 
>> 	__le32 pHeader = (__le32)*(__le32 *)piomb;
>> 
>> instead ...
>> 
> 
> hi,
> 
> would it help to make piomb __le32 instead of void ?
> 
> Also i do not understand what want to gain from 0xFFF
> Doing (u8) is effectively doing & 0xFF.
> 
> re,
> wh
> 
> 
> 

