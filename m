Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754054Ab2BUK0t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 05:26:49 -0500
Received: from mailgw10.se.ericsson.net ([193.180.251.61]:48234 "EHLO
	mailgw10.se.ericsson.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752584Ab2BUK0s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 05:26:48 -0500
X-AuditID: c1b4fb3d-b7bb7ae0000007b2-41-4f437166d6f8
Message-ID: <4F437164.5020408@ericsson.com>
Date: Tue, 21 Feb 2012 11:26:44 +0100
From: =?UTF-8?B?TmlrbGFzIFPDtmRlcmx1bmQ=?= 
	<niklas.soderlund@ericsson.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120212 Thunderbird/10.0.1
MIME-Version: 1.0
To: Tony Luck <tony.luck@intel.com>
CC: Borislav Petkov <bp@amd64.org>,
        "lucas.demarchi@profusion.mobi" <lucas.demarchi@profusion.mobi>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] edac: i5100 ack error detection register after each read
References: <1323447135-25914-1-git-send-email-niklas.soderlund@ericsson.com> <20111209162254.GB14900@aftab>
In-Reply-To: <20111209162254.GB14900@aftab>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tony,

Is there any interest in this patch?

On 12/09/2011 05:22 PM, Borislav Petkov wrote:
> Adding Tony.
>
> On Fri, Dec 09, 2011 at 05:12:15PM +0100, Niklas Söderlund wrote:
>> If I only ack the detection register after a error have been detected
>> I'm unable to reliably detect errors. I have verified this behavior
>> using both an error injection DIMM and software to inject errors.
>>
>> I can't find any documentation supporting this behavior in Intel 5100
>> Memory Controller Hub Chipset, see 1. So this is all based on
>> experimentation.
>>
>> [1] Intel® 5100 Memory Controller Hub Chipset
>>      http://www.intel.com/content/dam/doc/datasheet/5100-
>> 	memory-controller-hub-chipset-datasheet.pdf
>>
>> Signed-off-by: Niklas Söderlund<niklas.soderlund@ericsson.com>
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
