Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932413Ab0FOTg2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 15:36:28 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:44996 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752419Ab0FOTgZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 15:36:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=gHb81XBVY2D27Nc9bWj12qbBlDnG3GCkmdXhwpUGjecW2ycxhS6xIp99cWAIacwtLs
         zowRxPdTYKMzC/XprlqOykwegYPupoU7UX3QqyPxlArBB7b7R5JLQu+k6uw7BC2HNnwj
         uKo1I9apf7IrtKpwG/d5uJISlzqrk5zMYP2s4=
Message-ID: <4C17D646.5030306@gmail.com>
Date: Tue, 15 Jun 2010 12:36:38 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091114 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: "Sergey V." <sftp.mtuci@gmail.com>
CC: linux-kernel@vger.kernel.org, reiserfs-devel@vger.kernel.org,
       linux-bluetooth@vger.kernel.org, clemens@ladisch.de,
       debora@linux.vnet.ibm.com, dri-devel@lists.freedesktop.org,
       linux-i2c@vger.kernel.org, linux1394-devel@lists.sourceforge.net,
       linux-media@vger.kernel.org
Subject: Re: [PATCH 4/8]drivers:tmp.c Fix warning: variable 'rc' set but not
 used
References: <1276547208-26569-1-git-send-email-justinmattock@gmail.com> <1276547208-26569-5-git-send-email-justinmattock@gmail.com> <201006152253.44326.sftp.mtuci@gmail.com>
In-Reply-To: <201006152253.44326.sftp.mtuci@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/15/2010 11:53 AM, Sergey V. wrote:
> On Tuesday 15 of June 2010 00:26:44 Justin P. Mattock wrote:
>> Im getting this warning when compiling:
>>   CC      drivers/char/tpm/tpm.o
>> drivers/char/tpm/tpm.c: In function 'tpm_gen_interrupt':
>> drivers/char/tpm/tpm.c:508:10: warning: variable 'rc' set but not used
>>
>> The below patch gets rid of the warning,
>> but I'm not sure if it's the best solution.
>>
>>   Signed-off-by: Justin P. Mattock<justinmattock@gmail.com>
>>
>> ---
>>   drivers/char/tpm/tpm.c |    2 ++
>>   1 files changed, 2 insertions(+), 0 deletions(-)
>>
>> diff --git a/drivers/char/tpm/tpm.c b/drivers/char/tpm/tpm.c
>> index 05ad4a1..3d685dc 100644
>> --- a/drivers/char/tpm/tpm.c
>> +++ b/drivers/char/tpm/tpm.c
>> @@ -514,6 +514,8 @@ void tpm_gen_interrupt(struct tpm_chip *chip)
>>
>>   	rc = transmit_cmd(chip,&tpm_cmd, TPM_INTERNAL_RESULT_SIZE,
>>   			"attempting to determine the timeouts");
>> +	if (!rc)
>> +		rc = 0;
>>   }
>>   EXPORT_SYMBOL_GPL(tpm_gen_interrupt);
>>
>> --
>> 1.7.1.rc1.21.gf3bd6
>>
>
> Hi Justin
>
> IMHO
> See code of functions tpm_transmit(), transmit_cmd and tpm_gen_interrupt().
> In tpm_gen_interrupt() not need check rc for wrong value bacause if in function
> transmit_cmd() len == TPM_ERROR_SIZE then put a debug message (dev_dbg()).
> Again, if something wrong in tpm_transmit() then runs dev_err() and rc in
> tpm_gen_interrupt() get -E* value.
> So, we can remove unused rc variable in tpm_gen_interrupt().
>
> See patch below. Note: I not tested it.
>
>
> Subject: [PATCH] drivers: tpm.c: Remove unused variable 'rc'
>
> ---
>   drivers/char/tpm/tpm.c |    5 ++---
>   1 files changed, 2 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/char/tpm/tpm.c b/drivers/char/tpm/tpm.c
> index 05ad4a1..f9f5b47 100644
> --- a/drivers/char/tpm/tpm.c
> +++ b/drivers/char/tpm/tpm.c
> @@ -505,15 +505,14 @@ ssize_t tpm_getcap(struct device *dev, __be32 subcap_id,
> cap_t *cap,
>   void tpm_gen_interrupt(struct tpm_chip *chip)
>   {
>   	struct	tpm_cmd_t tpm_cmd;
> -	ssize_t rc;
>
>   	tpm_cmd.header.in = tpm_getcap_header;
>   	tpm_cmd.params.getcap_in.cap = TPM_CAP_PROP;
>   	tpm_cmd.params.getcap_in.subcap_size = cpu_to_be32(4);
>   	tpm_cmd.params.getcap_in.subcap = TPM_CAP_PROP_TIS_TIMEOUT;
>
> -	rc = transmit_cmd(chip,&tpm_cmd, TPM_INTERNAL_RESULT_SIZE,
> -			"attempting to determine the timeouts");
> +	transmit_cmd(chip,&tpm_cmd, TPM_INTERNAL_RESULT_SIZE,
> +		     "attempting to determine the timeouts");
>   }
>   EXPORT_SYMBOL_GPL(tpm_gen_interrupt);
>



o.k. applied this patch and rebuilt, here is what I see:

   CC [M]  drivers/char/ipmi/ipmi_poweroff.o
   CC      drivers/char/tpm/tpm.o
   CC      drivers/char/tpm/tpm_bios.o
   CC      drivers/char/tpm/tpm_tis.o
   LD      drivers/char/tpm/built-in.o


looks good over here Thanks for sending this..

Justin P. Mattock
