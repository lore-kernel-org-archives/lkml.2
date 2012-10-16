Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754295Ab2JPINt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 04:13:49 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:41470 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754079Ab2JPINr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 04:13:47 -0400
MIME-Version: 1.0
In-Reply-To: <507CE06D.8050806@hitachi.com>
References: <1350351452-9737-1-git-send-email-hyc.lee@gmail.com>
	<507CE06D.8050806@hitachi.com>
Date: Tue, 16 Oct 2012 17:13:46 +0900
Message-ID: <CANFS6baFhCSvFhKPDVam3hGxSrhdX9-6dXROJSMM9KdrK-AK8A@mail.gmail.com>
Subject: Re: [PATCH] perf probe: convert_name_to_addr() allocated the wrong
 size buffer for a function name
From: Hyeoncheol Lee <hyc.lee@gmail.com>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: acme@ghostprotocols.net, LKML <linux-kernel@vger.kernel.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        "yrl.pp-manager.tt@hitachi.com" <yrl.pp-manager.tt@hitachi.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

2012/10/16 Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>:
> (2012/10/16 10:37), Hyeoncheol Lee wrote:
>> convert_name_to_addr() allocated sizeof(char *) * MAX_PROBE_ARGS
>> bytes for a function name
>
> Yeah, that one was from my laziness...
>
>>
>> Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
>> Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
>> Signed-off-by: Hyeoncheol Lee <hyc.lee@gmail.com>
>> ---
>>  tools/perf/util/probe-event.c |    5 +++--
>>  1 file changed, 3 insertions(+), 2 deletions(-)
>>
>> diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
>> index 49a256e..bb40ed4 100644
>> --- a/tools/perf/util/probe-event.c
>> +++ b/tools/perf/util/probe-event.c
>> @@ -2352,13 +2352,14 @@ static int convert_name_to_addr(struct perf_probe_event *pev, const char *exec)
>>               free(exec_copy);
>>       }
>>       free(pp->function);
>> -     pp->function = zalloc(sizeof(char *) * MAX_PROBE_ARGS);
>> +     pp->function = zalloc(sizeof(char) *
>> +                           (3 + sizeof(unsigned long long) * 2));
>
> Could you comment that this is enough long here?
>

Because a hexadecimal address that starts with "0x"
will be stored in pp->function. sizeof(unsigned long long) * 2 is
maximum length of hexadecimal number of  variable "vaddr"
and 3 bytes are for "0x" and null character.

>>       if (!pp->function) {
>>               ret = -ENOMEM;
>>               pr_warning("Failed to allocate memory by zalloc.\n");
>>               goto out;
>>       }
>> -     e_snprintf(pp->function, MAX_PROBE_ARGS, "0x%llx", vaddr);
>> +     sprintf(pp->function, "0x%llx", vaddr);
>
> And at least we should use snprintf instead of sprintf...
> (I think ret = e_snprintf(...) is better)
>

You are right, but I didn't want to write down the length of
"pp->function" again.

>>       ret = 0;
>>
>>  out:
>>
>
> Thank you,
>
> --
> Masami HIRAMATSU
> IT Management Research Dept. Linux Technology Center
> Hitachi, Ltd., Yokohama Research Laboratory
> E-mail: masami.hiramatsu.pt@hitachi.com
>
>

Thank you very much!
