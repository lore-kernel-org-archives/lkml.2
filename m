Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754331Ab2ISDUV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 23:20:21 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:37521 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753752Ab2ISDUT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 23:20:19 -0400
X-AuditID: b753bd60-91b5cba000007c38-88-505939ef58fb
X-AuditID: b753bd60-91b5cba000007c38-88-505939ef58fb
Message-ID: <505939EB.8080004@hitachi.com>
Date: Wed, 19 Sep 2012 12:20:11 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Namhyung Kim <namhyung@kernel.org>
Cc: Irina Tirdea <irina.tirdea@gmail.com>, mingo@redhat.com,
        acme@ghostprotocols.net, a.p.zijlstra@chello.nl, rostedt@goodmis.org,
        paulus@samba.org, dsahern@gmail.com, namhyung.kim@lge.com,
        linux-kernel@vger.kernel.org, Irina Tirdea <irina.tirdea@intel.com>
Subject: Re: [PATCH 1/4] perf tools: remove sscanf extension %as
References: <1347574063-22521-1-git-send-email-irina.tirdea@intel.com> <1347574063-22521-2-git-send-email-irina.tirdea@intel.com> <87ligd8j46.fsf@sejong.aot.lge.com>
In-Reply-To: <87ligd8j46.fsf@sejong.aot.lge.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/09/14 10:54), Namhyung Kim wrote:
> Hi Irina,
> 
> (Adding Masami to Cc)

Thanks Irina and Namhyung :)

> On Fri, 14 Sep 2012 01:07:40 +0300, Irina Tirdea wrote:
>> From: Irina Tirdea <irina.tirdea@intel.com>
>>
>> perf uses sscanf extension %as to read and allocate a
>> string in the same step. This is a non-standard extension
>> only present in new versions of glibc.
>>
>> Replacing the use of sscanf and %as with strtok_r calls
>> in order to parse a given string into its components.
>> This is needed in Android since bionic does not support
>> %as extension for sscanf.
>>
>> Signed-off-by: Irina Tirdea <irina.tirdea@intel.com>
>> ---
>>  tools/perf/util/probe-event.c       |   25 ++++++++++++++++++-------
>>  tools/perf/util/trace-event-parse.c |   18 ++++++++----------
>>  2 files changed, 26 insertions(+), 17 deletions(-)
>>
>> diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
>> index 4ce04c2..685ddcf 100644
>> --- a/tools/perf/util/probe-event.c
>> +++ b/tools/perf/util/probe-event.c
>> @@ -1100,6 +1100,7 @@ static int parse_probe_trace_command(const char *cmd,
>>  	struct probe_trace_point *tp = &tev->point;
>>  	char pr;
>>  	char *p;
>> +	char *argv0_str = NULL, *fmt, *fmt1_str, *fmt2_str, *fmt3_str;
>>  	int ret, i, argc;
>>  	char **argv;
>>  
>> @@ -1116,14 +1117,19 @@ static int parse_probe_trace_command(const char *cmd,
>>  	}
>>  
>>  	/* Scan event and group name. */
>> -	ret = sscanf(argv[0], "%c:%a[^/ \t]/%a[^ \t]",
>> -		     &pr, (float *)(void *)&tev->group,
>> -		     (float *)(void *)&tev->event);
>> -	if (ret != 3) {
>> +	argv0_str = strdup(argv[0]);
> 
> It seems you need to check return value of strdup.

Agreed.

>> +	fmt1_str = strtok_r(argv0_str, ":", &fmt);
>> +	fmt2_str = strtok_r(NULL, "/", &fmt);
>> +	fmt3_str = strtok_r(NULL, " \t", &fmt);
>> +	if (fmt1_str == NULL || strlen(fmt1_str) != 1 || fmt2_str == NULL
>> +	    || fmt3_str == NULL) {
>>  		semantic_error("Failed to parse event name: %s\n", argv[0]);
>>  		ret = -EINVAL;
>>  		goto out;
>>  	}
>> +	pr = fmt1_str[0];
>> +	tev->group = strdup(fmt2_str);
>> +	tev->event = strdup(fmt3_str);
>>  	pr_debug("Group:%s Event:%s probe:%c\n", tev->group, tev->event, pr);
>>  
>>  	tp->retprobe = (pr == 'r');
>> @@ -1135,10 +1141,13 @@ static int parse_probe_trace_command(const char *cmd,
>>  		p++;
>>  	} else
>>  		p = argv[1];
>> -	ret = sscanf(p, "%a[^+]+%lu", (float *)(void *)&tp->symbol,
>> -		     &tp->offset);
>> -	if (ret == 1)
>> +	fmt1_str = strtok_r(p, "+", &fmt);
>> +	tp->symbol = strdup(fmt1_str);
> 
> Probably here too - although the original code didn't but I think it's
> needed.

right, it should be fixed.

>> +	fmt2_str = strtok_r(NULL, "", &fmt);
>> +	if (fmt2_str == NULL)
>>  		tp->offset = 0;
>> +	else
>> +		tp->offset = strtoul(fmt2_str, NULL, 10);
>>  
>>  	tev->nargs = argc - 2;
>>  	tev->args = zalloc(sizeof(struct probe_trace_arg) * tev->nargs);
>> @@ -1162,6 +1171,8 @@ static int parse_probe_trace_command(const char *cmd,
>>  	}
>>  	ret = 0;
>>  out:
>> +	if (argv0_str)
>> +		free(argv0_str);
> 
> The free() can handle a NULL pointer safely.

I don't care about it, since there are already lots of "if (ptr) free(ptr)"
style code ;)

> 
>>  	argv_free(argv);
>>  	return ret;
>>  }

Thank you!

-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


