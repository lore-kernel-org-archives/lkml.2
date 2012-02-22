Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752802Ab2BVA6k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 19:58:40 -0500
Received: from mga01.intel.com ([192.55.52.88]:8950 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750932Ab2BVA6j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 19:58:39 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="127956875"
From: "Luck, Tony" <tony.luck@intel.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: Borislav Petkov <bp@amd64.org>,
        "lucas.demarchi@profusion.mobi" <lucas.demarchi@profusion.mobi>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        =?utf-8?B?TmlrbGFzIFPDtmRlcmx1bmQ=?= 
	<niklas.soderlund@ericsson.com>
Subject: RE: [PATCH] edac: i5100 ack error detection register after each read
Thread-Topic: [PATCH] edac: i5100 ack error detection register after each
 read
Thread-Index: AQHM8INSwCxROf2v+kuzA5s27WGSMJZH5eHA
Date: Wed, 22 Feb 2012 00:58:37 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F03DA5B@ORSMSX104.amr.corp.intel.com>
References: <1323447135-25914-1-git-send-email-niklas.soderlund@ericsson.com>
 <20111209162254.GB14900@aftab> <4F437164.5020408@ericsson.com>
In-Reply-To: <4F437164.5020408@ericsson.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.139]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q1M0wjuh021737

Mauro: Since this has been tested, do you care that the documentation
doesn't appear to describe this behavior?

-Tony

-----Original Message-----
From: Niklas SÃ¶derlund [mailto:niklas.soderlund@ericsson.com] 
Sent: Tuesday, February 21, 2012 2:27 AM
To: Luck, Tony
Cc: Borislav Petkov; lucas.demarchi@profusion.mobi; linux-kernel@vger.kernel.org
Subject: Re: [PATCH] edac: i5100 ack error detection register after each read

Hi Tony,

Is there any interest in this patch?

On 12/09/2011 05:22 PM, Borislav Petkov wrote:
> Adding Tony.
>
> On Fri, Dec 09, 2011 at 05:12:15PM +0100, Niklas SÃ¶derlund wrote:
>> If I only ack the detection register after a error have been detected
>> I'm unable to reliably detect errors. I have verified this behavior
>> using both an error injection DIMM and software to inject errors.
>>
>> I can't find any documentation supporting this behavior in Intel 5100
>> Memory Controller Hub Chipset, see 1. So this is all based on
>> experimentation.
>>
>> [1] IntelÂ® 5100 Memory Controller Hub Chipset
>>      http://www.intel.com/content/dam/doc/datasheet/5100-
>> 	memory-controller-hub-chipset-datasheet.pdf
>>
>> Signed-off-by: Niklas SÃ¶derlund<niklas.soderlund@ericsson.com>
>> ---
>>   drivers/edac/i5100_edac.c |   11 ++++-------
>>   1 files changed, 4 insertions(+), 7 deletions(-)
>>
>> diff --git a/drivers/edac/i5100_edac.c b/drivers/edac/i5100_edac.c
>> index bcbdeec..ec728e9 100644
>> --- a/drivers/edac/i5100_edac.c
>> +++ b/drivers/edac/i5100_edac.c
>> @@ -535,23 +535,20 @@ static void i5100_read_log(struct mem_ctl_info *mci, int chan,
>>   static void i5100_check_error(struct mem_ctl_info *mci)
>>   {
>>   	struct i5100_priv *priv = mci->pvt_info;
>> -	u32 dw;
>> -
>> +	u32 dw, dw2;
>>
>>   	pci_read_config_dword(priv->mc, I5100_FERR_NF_MEM,&dw);
>>   	if (i5100_ferr_nf_mem_any(dw)) {
>> -		u32 dw2;
>>
>>   		pci_read_config_dword(priv->mc, I5100_NERR_NF_MEM,&dw2);
>> -		if (dw2)
>> -			pci_write_config_dword(priv->mc, I5100_NERR_NF_MEM,
>> -					       dw2);
>> -		pci_write_config_dword(priv->mc, I5100_FERR_NF_MEM, dw);
>>
>>   		i5100_read_log(mci, i5100_ferr_nf_mem_chan_indx(dw),
>>   			       i5100_ferr_nf_mem_any(dw),
>>   			       i5100_nerr_nf_mem_any(dw2));
>> +
>> +		pci_write_config_dword(priv->mc, I5100_NERR_NF_MEM, dw2);
>>   	}
>> +	pci_write_config_dword(priv->mc, I5100_FERR_NF_MEM, dw);
>>   }
>>
>>   /* The i5100 chipset will scrub the entire memory once, then
>> --
>> 1.7.7.3
>>
>>
>
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
