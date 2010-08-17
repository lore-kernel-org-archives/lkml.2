Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754590Ab0HQCOW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 22:14:22 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:60828 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753528Ab0HQCOT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 22:14:19 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.5.1
Message-ID: <4C69F094.1040607@np.css.fujitsu.com>
Date: Tue, 17 Aug 2010 11:14:44 +0900
From: Jin Dongming <jin.dongming@np.css.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; ja; rv:1.9.2.7) Gecko/20100713 Thunderbird/3.1.1
MIME-Version: 1.0
To: Huang Ying <ying.huang@intel.com>
CC: Randy Dunlap <randy.dunlap@oracle.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Andi Kleen <andi@firstfloor.org>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        ACPI <linux-acpi@vger.kernel.org>, LKLM <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/4] [Patch-next] ACPI, APEI, ERST Fix the wrong checking
 of Serialization Header's length
References: <4C69DDB5.6060103@np.css.fujitsu.com> <1282008836.2744.1490.camel@yhuang-dev>
In-Reply-To: <1282008836.2744.1490.camel@yhuang-dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2010/08/17 10:33), Huang Ying wrote:
> On Tue, 2010-08-17 at 08:54 +0800, Jin Dongming wrote:
>> header_length in struct acpi_table_erst is not the length of struct
>> acpi_table_erst, but the length of Serialization Header.
>>
>> In erst_check_table(), header_length is used for checking the length
>> of struct acpi_table_erst. So I think it is wrong.
> 
> Why "think"? Do you have a machine with header_length set as you said?

I have such machine, and I confirmed that the header_length returned by firmware
is same as what I described in the above description.

And further more, according to the spec document of ACPI 4.0(page 515),
it is written like following.

  Field                      Byte length   Byte offset   Description
  Serialization Header Size  4             0x24          Length in bytes of
                                                         the serialization header.

> 
>> This patch fixed it and I confirmed it on x86_64 next-tree.
>>
>> Signed-off-by: Jin Dongming <jin.dongming@np.css.fujitsu.com>
>> ---
>>  drivers/acpi/apei/erst.c |   13 ++++++++-----
>>  include/acpi/actbl1.h    |   14 +++++++++++---
>>  2 files changed, 19 insertions(+), 8 deletions(-)
>>
>> diff --git a/drivers/acpi/apei/erst.c b/drivers/acpi/apei/erst.c
>> index 864dd46..28a5caf 100644
>> --- a/drivers/acpi/apei/erst.c
>> +++ b/drivers/acpi/apei/erst.c
>> @@ -358,7 +358,8 @@ static struct apei_exec_ins_type erst_ins_type[] = {
>>  static inline void erst_exec_ctx_init(struct apei_exec_context *ctx)
>>  {
>>  	apei_exec_ctx_init(ctx, erst_ins_type, ARRAY_SIZE(erst_ins_type),
>> -			   ERST_TAB_ENTRY(erst_tab), erst_tab->entries);
>> +			   ERST_TAB_ENTRY(erst_tab),
>> +			   erst_tab->seri_header.entries);
>>  }
>>  
>>  static int erst_get_erange(struct erst_erange *range)
>> @@ -749,12 +750,14 @@ __setup("erst_disable", setup_erst_disable);
>>  
>>  static int erst_check_table(struct acpi_table_erst *erst_tab)
>>  {
>> -	if (erst_tab->header_length != sizeof(struct acpi_table_erst))
>> +	if (erst_tab->common_header.length < sizeof(struct acpi_table_erst))
>>  		return -EINVAL;
>> -	if (erst_tab->header.length < sizeof(struct acpi_table_erst))
>> +
>> +	if (erst_tab->seri_header.length != sizeof(struct acpi_erst_header))
>>  		return -EINVAL;
>> -	if (erst_tab->entries !=
>> -	    (erst_tab->header.length - sizeof(struct acpi_table_erst)) /
>> +
>> +	if (erst_tab->seri_header.entries !=
>> +	    (erst_tab->common_header.length - sizeof(struct acpi_table_erst)) /
>>  	    sizeof(struct acpi_erst_entry))
>>  		return -EINVAL;
>>  
>> diff --git a/include/acpi/actbl1.h b/include/acpi/actbl1.h
>> index c637b75..821f8ac 100644
>> --- a/include/acpi/actbl1.h
>> +++ b/include/acpi/actbl1.h
>> @@ -283,13 +283,21 @@ enum acpi_einj_command_status {
>>   *
>>   ******************************************************************************/
>>  
>> -struct acpi_table_erst {
>> -	struct acpi_table_header header;	/* Common ACPI table header */
>> -	u32 header_length;
>> +/* ERST Serialization Header */
>> +
>> +struct acpi_erst_header {
>> +	u32 length;
>>  	u32 reserved;
>>  	u32 entries;
>>  };
>>  
>> +/* ERST Header */
>> +
>> +struct acpi_table_erst {
>> +	struct acpi_table_header common_header;	/* Common ACPI table header */
>> +	struct acpi_erst_header seri_header;	/* ERST Serialization Header */
>> +};
> 
> I don't think it is necessary to change the header definition, and
> seri_header is not a good name for me.
Why I added this structure here is that I don't want to do following checking.
For example,
	if (header_length != 0x0c) {
		...
	}

Though it is simple, it is really difficult for us to understand the real meaning
of the code.
> 
> Best Regards,
> Huang Ying
> 
> 
> 
> 


