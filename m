Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754717Ab0HBTqP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 15:46:15 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:40659 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754546Ab0HBTqN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 15:46:13 -0400
From: "Ramos Falcon, Ernesto" <ernesto@ti.com>
To: "Menon, Nishanth" <nm@ti.com>
CC: "gregkh@suse.de" <gregkh@suse.de>,
        "Ramirez Luna, Omar" <omar.ramirez@ti.com>,
        "ohad@wizery.com" <ohad@wizery.com>,
        "ameya.palande@nokia.com" <ameya.palande@nokia.com>,
        "felipe.contreras@nokia.com" <felipe.contreras@nokia.com>,
        "Guzman Lugo, Fernando" <fernando.lugo@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "andy.shevchenko@gmail.com" <andy.shevchenko@gmail.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
Date: Mon, 2 Aug 2010 14:46:03 -0500
Subject: RE: [PATCH 4/5] staging:ti dspbridge: remove unnecessary volatile
 variables
Thread-Topic: [PATCH 4/5] staging:ti dspbridge: remove unnecessary volatile
 variables
Thread-Index: AcsuZhYVK9gqGwrjSbKQvRJCBOkhWAEESdyw
Message-ID: <B852767254C5C94EBB1040EE0EFA060094D16F7E@dlee01.ent.ti.com>
References: <1280328052-31292-1-git-send-email-ernesto@ti.com>
 <1280328052-31292-2-git-send-email-ernesto@ti.com>
 <1280328052-31292-3-git-send-email-ernesto@ti.com>
 <1280328052-31292-4-git-send-email-ernesto@ti.com>
 <1280328052-31292-5-git-send-email-ernesto@ti.com> <4C5046D5.6010306@ti.com>
In-Reply-To: <4C5046D5.6010306@ti.com>
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

Hi,

>-----Original Message-----
>From: Menon, Nishanth
>Sent: Wednesday, July 28, 2010 10:04 AM
>To: Ramos Falcon, Ernesto
>Cc: gregkh@suse.de; Ramirez Luna, Omar; ohad@wizery.com;
>ameya.palande@nokia.com; felipe.contreras@nokia.com; Guzman Lugo, Fernando;
>linux-kernel@vger.kernel.org; andy.shevchenko@gmail.com; linux-
>omap@vger.kernel.org
>Subject: Re: [PATCH 4/5] staging:ti dspbridge: remove unnecessary volatile
>variables

<snip>

>> index 08a2f5f..ae1f394 100644
>> --- a/drivers/staging/tidspbridge/core/tiomap3430.c
>> +++ b/drivers/staging/tidspbridge/core/tiomap3430.c
>> @@ -404,7 +404,7 @@ static int bridge_brd_start(struct bridge_dev_context
>*dev_ctxt,
>>  		pr_err("%s: Illegal SM base\n", __func__);
>>  		status = -EPERM;
>>  	} else
>> -		*((volatile u32 *)dw_sync_addr) = 0xffffffff;
>> +		__raw_writel(0xffffffff, dw_sync_addr);
>curious question: any reason not to use writel instead of __raw_writel?
>
I was not aware of the existence of writel, but I think I should use writel instead.

>>
>>  	if (DSP_SUCCEEDED(status)) {
>>  		resources = dev_context->resources;
>> @@ -584,7 +584,7 @@ static int bridge_brd_start(struct bridge_dev_context
>*dev_ctxt,
>>  		dev_dbg(bridge, "Waiting for Sync @ 0x%x\n", dw_sync_addr);
>>  		dev_dbg(bridge, "DSP c_int00 Address =  0x%x\n", dsp_addr);
>>  		if (dsp_debug)
>> -			while (*((volatile u16 *)dw_sync_addr))
>> +			while (__raw_readw(dw_sync_addr))
>>  				;;
>
>may be for a later on patch -> we seem to have a potential infinite loop
>here..
>
This is done intentionally and it is used to debug the dsp.  The system will hang here, and then Lautherback or jtag can be connected to take control of the program execution from this point.

>> diff --git a/drivers/staging/tidspbridge/pmgr/cmm.c
>b/drivers/staging/tidspbridge/pmgr/cmm.c
>> index 874ed64..b7cba1b 100644
>> --- a/drivers/staging/tidspbridge/pmgr/cmm.c
>> +++ b/drivers/staging/tidspbridge/pmgr/cmm.c
>> @@ -1008,6 +1008,7 @@ void *cmm_xlator_alloc_buf(struct cmm_xlatorobject
>*xlator, void *va_buf,
>>  {
>>  	struct cmm_xlator *xlator_obj = (struct cmm_xlator *)xlator;
>>  	void *pbuf = NULL;
>> +	void *tmp_va_buff;
>>  	struct cmm_attrs attrs;
>>
>>  	DBC_REQUIRE(refs > 0);
>> @@ -1019,16 +1020,16 @@ void *cmm_xlator_alloc_buf(struct
>cmm_xlatorobject *xlator, void *va_buf,
>>
>>  	if (xlator_obj) {
>>  		attrs.ul_seg_id = xlator_obj->ul_seg_id;
>> -		*(volatile u32 *)va_buf = 0;
>> +		__raw_writel(0, va_buf);
>>  		/* Alloc SM */
>>  		pbuf =
>>  		    cmm_calloc_buf(xlator_obj->hcmm_mgr, pa_size, &attrs,
>NULL);
>>  		if (pbuf) {
>>  			/* convert to translator(node/strm) process Virtual
>>  			 * address */
>> -			*(volatile u32 **)va_buf =
>> -			    (u32 *) cmm_xlator_translate(xlator,
>> +			 tmp_va_buff = cmm_xlator_translate(xlator,
>>  							 pbuf, CMM_PA2VA);
>> +			__raw_writel((u32)tmp_va_buff, va_buf);
>
>a) is the u32 cast of tmp_va_buff really necessary?
>b) tmp_va_buff is used only in this branch, why not reduce the scope of
>the variable to just to this if branch

Agree!


