Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755329Ab1GFA0x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 20:26:53 -0400
Received: from mga14.intel.com ([143.182.124.37]:28878 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752329Ab1GFA0w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 20:26:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,482,1304319600"; 
   d="scan'208";a="22988183"
Message-ID: <4E13ABC9.1090209@intel.com>
Date: Wed, 06 Jul 2011 08:26:49 +0800
From: Huang Ying <ying.huang@intel.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110606 Iceowl/1.0b2 Icedove/3.1.10
MIME-Version: 1.0
To: Gong Chen <clumsycg@gmail.com>
CC: Len Brown <lenb@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>, "Luck, Tony" <tony.luck@intel.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        Thomas Renninger <trenn@novell.com>
Subject: Re: [RFC 1/2] ACPI, APEI, Add apei_exec_run_optional
References: <1309846023-16459-1-git-send-email-ying.huang@intel.com> <4E13174B.30403@gmail.com>
In-Reply-To: <4E13174B.30403@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Gong,

Thanks for review.

On 07/05/2011 09:53 PM, Gong Chen wrote:
> 于 2011/7/5 14:07, Huang Ying 写道:
>> Some actions in APEI ERST and EINJ tables are optional, for example,
>> ACPI_EINJ_BEGIN_OPERATION action is used to do some preparation for
>> error injection, and firmware may choose to do nothing here.  While
>> some other actions are mandatory, for example, firmware must provide
>> ACPI_EINJ_GET_ERROR_TYPE implementation.
>>
>> Original implementation treats all actions as optional (that is, can
>> have no instructions), that may cause issue if firmware does not
>> provide some mandatory actions.  To fix this, this patch adds
>> apei_exec_run_optional, which should be used for optional actions.
>> The original apei_exec_run should be used for mandatory actions.
>>
>> Cc: Thomas Renninger<trenn@novell.com>
>> Signed-off-by: Huang Ying<ying.huang@intel.com>
>> ---
>>   drivers/acpi/apei/apei-base.c     |    9 +++++----
>>   drivers/acpi/apei/apei-internal.h |   13 ++++++++++++-
>>   2 files changed, 17 insertions(+), 5 deletions(-)
>>
>> --- a/drivers/acpi/apei/apei-base.c
>> +++ b/drivers/acpi/apei/apei-base.c
>> @@ -157,9 +157,10 @@ EXPORT_SYMBOL_GPL(apei_exec_noop);
>>    * Interpret the specified action. Go through whole action table,
>>    * execute all instructions belong to the action.
>>    */
>> -int apei_exec_run(struct apei_exec_context *ctx, u8 action)
>> +int __apei_exec_run(struct apei_exec_context *ctx, u8 action,
>> +		    bool optional)
>>   {
>> -	int rc;
>> +	int rc = -ENOENT;
>>   	u32 i, ip;
>>   	struct acpi_whea_header *entry;
>>   	apei_exec_ins_func_t run;
>> @@ -198,9 +199,9 @@ rewind:
>>   			goto rewind;
>>   	}
>>
>> -	return 0;
>> +	return !optional&&  rc<  0 ? rc : 0;
> 
> if one operation is optional but running into errors when executing this 
> kind of command,
> here just ignoring it. Is it reasonable ?

If we running into errors except there is no instructions for the
action, we will return the error code before this.  Please take a look
at the whole function.

Best Regards,
Huang Ying
