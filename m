Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753333Ab2JRBUk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 21:20:40 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:50606 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753107Ab2JRBUj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 21:20:39 -0400
X-AuditID: 9c93016f-b7c7bae000000eb7-31-507f5966ea11
From: Namhyung Kim <namhyung@kernel.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Hyeoncheol Lee <hyc.lee@gmail.com>, acme@ghostprotocols.net,
        LKML <linux-kernel@vger.kernel.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        "yrl.pp-manager.tt\@hitachi.com" <yrl.pp-manager.tt@hitachi.com>
Subject: Re: [PATCH] perf probe: convert_name_to_addr() allocated the wrong size buffers for names
References: <1350462496-20035-1-git-send-email-hyc.lee@gmail.com>
	<507E914E.50100@hitachi.com>
Date: Thu, 18 Oct 2012 10:20:37 +0900
In-Reply-To: <507E914E.50100@hitachi.com> (Masami Hiramatsu's message of "Wed,
	17 Oct 2012 20:06:54 +0900")
Message-ID: <877gqo37a2.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, 17 Oct 2012 20:06:54 +0900, Masami Hiramatsu wrote:
> (2012/10/17 17:28), Hyeoncheol Lee wrote:
>> The function allocated wrong size buffers for names
>> 
>> Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
>> Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
>> Signed-off-by: Hyeoncheol Lee <hyc.lee@gmail.com>
>> ---
>>  tools/perf/util/probe-event.c |   11 +++++++----
>>  1 file changed, 7 insertions(+), 4 deletions(-)
>> 
>> diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
>> index 49a256e..5cd7c42 100644
>> --- a/tools/perf/util/probe-event.c
>> +++ b/tools/perf/util/probe-event.c
>> @@ -2273,6 +2273,8 @@ int show_available_funcs(const char *target, struct strfilter *_filter,
>>  	return available_user_funcs(target);
>>  }
>>  
>
> Please add a comment like below on the code.
>
> /*
>  * sizeof(type) * 2 returns the maximum length of hexadecimal number
>  * of type, because each half byte is encoding in one hex character.
>  * Another 3 bytes are for "0x" and null character.
>  */
>
> Others are OK for me :)
>
> Thanks!
>
>> +#define MAX_ADDRNAME_LEN  (3 + sizeof(unsigned long long) * 2)
>> +
>>  /*
>>   * uprobe_events only accepts address:
>>   * Convert function and any offset to address
>> @@ -2332,7 +2334,7 @@ static int convert_name_to_addr(struct perf_probe_event *pev, const char *exec)
>>  	if (!pev->group) {
>>  		char *ptr1, *ptr2, *exec_copy;
>>  
>> -		pev->group = zalloc(sizeof(char *) * 64);
>> +		pev->group = zalloc(sizeof(char) * 64);

I guess we don't need this 'sizeof(char)' part?


>>  		exec_copy = strdup(exec);
>>  		if (!exec_copy) {
>>  			ret = -ENOMEM;
>> @@ -2352,14 +2354,15 @@ static int convert_name_to_addr(struct perf_probe_event *pev, const char *exec)
>>  		free(exec_copy);
>>  	}
>>  	free(pp->function);
>> -	pp->function = zalloc(sizeof(char *) * MAX_PROBE_ARGS);
>> +	pp->function = zalloc(sizeof(char) * MAX_ADDRNAME_LEN);

Ditto.

Thanks,
Namhyung


>>  	if (!pp->function) {
>>  		ret = -ENOMEM;
>>  		pr_warning("Failed to allocate memory by zalloc.\n");
>>  		goto out;
>>  	}
>> -	e_snprintf(pp->function, MAX_PROBE_ARGS, "0x%llx", vaddr);
>> -	ret = 0;
>> +	ret = e_snprintf(pp->function, MAX_ADDRNAME_LEN, "0x%llx", vaddr);
>> +	if (ret > 0)
>> +		ret = 0;
>>  
>>  out:
>>  	if (map) {
>> 
