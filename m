Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753679Ab2BVMNo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 07:13:44 -0500
Received: from mx1.redhat.com ([209.132.183.28]:8186 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751408Ab2BVMNm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 07:13:42 -0500
Message-ID: <4F44DBE2.5080706@redhat.com>
Date: Wed, 22 Feb 2012 10:13:22 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120209 Thunderbird/10.0.1
MIME-Version: 1.0
To: "Luck, Tony" <tony.luck@intel.com>
CC: Borislav Petkov <bp@amd64.org>,
        "lucas.demarchi@profusion.mobi" <lucas.demarchi@profusion.mobi>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        =?UTF-8?B?TmlrbGFzIFPDtmRlcmx1bmQ=?= 
	<niklas.soderlund@ericsson.com>
Subject: Re: [PATCH] edac: i5100 ack error detection register after each read
References: <1323447135-25914-1-git-send-email-niklas.soderlund@ericsson.com> <20111209162254.GB14900@aftab> <4F437164.5020408@ericsson.com> <3908561D78D1C84285E8C5FCA982C28F03DA5B@ORSMSX104.amr.corp.intel.com>
In-Reply-To: <3908561D78D1C84285E8C5FCA982C28F03DA5B@ORSMSX104.amr.corp.intel.com>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tony,

Em 21-02-2012 22:58, Luck, Tony escreveu:
> Mauro: Since this has been tested, do you care that the documentation
> doesn't appear to describe this behavior?

On some chipsets, the documentation allows more than one way to read it.

Yet, the common behavior to ack for an error on those Intel 3xxxx/5xxx/7xxx
memory controllers is to do:

	pci_read_config_dword(priv->mc, reg, &dw);
	pci_write_config_dword(priv->mc, reg, dw);

Which is exactly what Niklas patch is doing, so it looks fine for me.

Acked-by: Mauro Carvalho Chehab <mchehab@redhat.com>


> 
> -Tony
> 
> -----Original Message-----
> From: Niklas Söderlund [mailto:niklas.soderlund@ericsson.com] 
> Sent: Tuesday, February 21, 2012 2:27 AM
> To: Luck, Tony
> Cc: Borislav Petkov; lucas.demarchi@profusion.mobi; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH] edac: i5100 ack error detection register after each read
> 
> Hi Tony,
> 
> Is there any interest in this patch?
> 
> On 12/09/2011 05:22 PM, Borislav Petkov wrote:
>> Adding Tony.
>>
>> On Fri, Dec 09, 2011 at 05:12:15PM +0100, Niklas Söderlund wrote:
>>> If I only ack the detection register after a error have been detected
>>> I'm unable to reliably detect errors. I have verified this behavior
>>> using both an error injection DIMM and software to inject errors.
>>>
>>> I can't find any documentation supporting this behavior in Intel 5100
>>> Memory Controller Hub Chipset, see 1. So this is all based on
>>> experimentation.
>>>
>>> [1] Intel® 5100 Memory Controller Hub Chipset
>>>      http://www.intel.com/content/dam/doc/datasheet/5100-
>>> 	memory-controller-hub-chipset-datasheet.pdf
>>>
>>> Signed-off-by: Niklas Söderlund<niklas.soderlund@ericsson.com>
>>> ---
>>>   drivers/edac/i5100_edac.c |   11 ++++-------
>>>   1 files changed, 4 insertions(+), 7 deletions(-)
>>>
>>> diff --git a/drivers/edac/i5100_edac.c b/drivers/edac/i5100_edac.c
>>> index bcbdeec..ec728e9 100644
>>> --- a/drivers/edac/i5100_edac.c
>>> +++ b/drivers/edac/i5100_edac.c
>>> @@ -535,23 +535,20 @@ static void i5100_read_log(struct mem_ctl_info *mci, int chan,
>>>   static void i5100_check_error(struct mem_ctl_info *mci)
>>>   {
>>>   	struct i5100_priv *priv = mci->pvt_info;
>>> -	u32 dw;
>>> -
>>> +	u32 dw, dw2;
>>>
>>>   	pci_read_config_dword(priv->mc, I5100_FERR_NF_MEM,&dw);
>>>   	if (i5100_ferr_nf_mem_any(dw)) {
>>> -		u32 dw2;
>>>
>>>   		pci_read_config_dword(priv->mc, I5100_NERR_NF_MEM,&dw2);
>>> -		if (dw2)
>>> -			pci_write_config_dword(priv->mc, I5100_NERR_NF_MEM,
>>> -					       dw2);
>>> -		pci_write_config_dword(priv->mc, I5100_FERR_NF_MEM, dw);
>>>
>>>   		i5100_read_log(mci, i5100_ferr_nf_mem_chan_indx(dw),
>>>   			       i5100_ferr_nf_mem_any(dw),
>>>   			       i5100_nerr_nf_mem_any(dw2));
>>> +
>>> +		pci_write_config_dword(priv->mc, I5100_NERR_NF_MEM, dw2);
>>>   	}
>>> +	pci_write_config_dword(priv->mc, I5100_FERR_NF_MEM, dw);
>>>   }
>>>
>>>   /* The i5100 chipset will scrub the entire memory once, then
>>> --
>>> 1.7.7.3
>>>
>>>
>>

