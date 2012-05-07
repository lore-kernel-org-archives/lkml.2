Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932096Ab2EGRRQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 13:17:16 -0400
Received: from e24smtp05.br.ibm.com ([32.104.18.26]:37561 "EHLO
	e24smtp05.br.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757467Ab2EGRRO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 13:17:14 -0400
Message-ID: <4FA8037C.8010304@linux.vnet.ibm.com>
Date: Mon, 07 May 2012 14:16:44 -0300
From: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.6; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: jmorris@namei.org, pebolle@tiscali.nl, linux-kernel@vger.kernel.org,
        tpmdd@selhorst.net
Subject: Re: [PULL] TPM: MAINTAINERS contacts update and error report fix
References: <20120503171054.GA6165@localhost.br.ibm.com> <1336076080.13866.49.camel@joe2Laptop>
In-Reply-To: <1336076080.13866.49.camel@joe2Laptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12050717-2362-0000-0000-0000071808C0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/05/12 17:14, Joe Perches wrote:
> On Thu, 2012-05-03 at 14:10 -0300, Rajiv Andrade wrote:
>> The first as the subject implies is just a contacts update, and the second
>> makes the driver avoid to mistakenly report the disabled and deactivated TPM
>> states as an error.
> trivia:
>
>> diff --git a/drivers/char/tpm/tpm.c b/drivers/char/tpm/tpm.c
> []
>> @@ -845,7 +845,16 @@ int tpm_do_selftest(struct tpm_chip *chip)
>>   		return rc;
>>
>>   	do {
>> -		rc = __tpm_pcr_read(chip, 0, digest);
>> +		/* Attempt to read a PCR value */
>> +		cmd.header.in = pcrread_header;
>> +		cmd.params.pcrread_in.pcr_idx = cpu_to_be32(0);
>> +		rc = tpm_transmit(chip, (u8 *)&cmd, READ_PCR_RESULT_SIZE);
>> +
>> +		if (rc<  TPM_HEADER_SIZE)
>> +			return -EFAULT;
>> +		else
>> +			rc = be32_to_cpu(cmd.header.out.return_code);
> The else shouldn't be used here.
> Indented code followed by an unindented test is not nice.
Yep.. I missed it.
>
>> +
>>   		if (rc == TPM_ERR_DISABLED || rc == TPM_ERR_DEACTIVATED) {
>>   			dev_info(chip->dev,
>>   				 "TPM is disabled/deactivated (0x%X)\n", rc);
> A more kernel style conformant style looks like:
>
> 		rc = tpm_transmit(chip, (u8 *)&cmd, READ_PCR_RESULT_SIZE);
> 		if (rc<  TPM_HEADER_SIZE)
> 			return -EFAULT;
>
> 		rc = be32_to_cpu(cmd.header.out.return_code);
>   		if (rc == TPM_ERR_DISABLED || rc == TPM_ERR_DEACTIVATED) {
> 			etc...
>
>
Thanks for pointing.

James, please ignore, I'll send a better version of this fix.

Rajiv

